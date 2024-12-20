import 'package:final_project/services/firestore_service.dart';
import 'package:final_project/styles/button.dart';
import 'package:final_project/views/common/custom_image_header.dart';
import 'package:final_project/views/onBoarding/onboarding_screen.dart';
import 'package:final_project/views/setup/account_created.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:currency_textfield/currency_textfield.dart';

class SetupCashBalance extends StatefulWidget {
  const SetupCashBalance({super.key});

  @override
  State<SetupCashBalance> createState() => _SetupCashBalanceState();
}

class _SetupCashBalanceState extends State<SetupCashBalance> {
  final FirestoreService _firestoreService = FirestoreService();
  final CurrencyTextFieldController currencyController = CurrencyTextFieldController(
    currencySymbol: "",
    decimalSymbol: ".",
    thousandSymbol: ",",
    currencyOnLeft: false,
  );
  String? inputValue;
  String? userCurrencyCode;

  @override
  void initState() {
    super.initState();
    fetchCurrencyCode();
    currencyController.addListener(() {
      setState(() {
        inputValue = currencyController.textWithoutCurrencySymbol.trim().isNotEmpty
            ? currencyController.textWithoutCurrencySymbol
            : null;
      });
    });
  }

  void fetchCurrencyCode() async {
    try {
      String? currencyCode = await _firestoreService.getCurrencyCodeForUser();
      if (currencyCode != null) {
        setState(() {
          userCurrencyCode = currencyCode;
          currencyController.replaceCurrencySymbol(currencyCode);
        });
      } else {
        if (kDebugMode) {
          print("Currency code not found for the user.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching currency code: $e");
      }
    }
  }

  Future<void> saveAccount() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (inputValue == null || userCurrencyCode == null) {
      if (kDebugMode) {
        print("Incomplete data to save the account.");
      }
      return;
    }

    try {
      final accountData = {
        "userId": userId,
        "account_name": "main",
        "current_balance": double.tryParse(inputValue!.replaceAll(",", "")),
        "currency_code": userCurrencyCode,
        "type": "cash",
      };

      await _firestoreService.addAccount("main", accountData);
      if (kDebugMode) {
        print("Main account successfully created.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error saving account: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const ImageIcon(
              AssetImage('images/LeftArrow.png'),
              size: 32.0,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const OnboardingScreen()),
              );
            },
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: CustomImageHeader(
                      headerText: "Set up your cash balance",
                      detailText: "How much cash you have in your physical wallet?",
                      svgPath: "images/setup_cash.svg",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: currencyController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: "0",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontSize: 30,
                                color: Colors.grey,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: buttonPrimary,
                          onPressed: inputValue != null
                              && double.tryParse(inputValue!.replaceAll(",", "")) != null
                              && double.tryParse(inputValue!.replaceAll(",", ""))! >= 0
                              ? () async {
                            await saveAccount();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const AccountCreated()),
                            );
                          }
                              : null,
                          child: const Text('Finish'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
