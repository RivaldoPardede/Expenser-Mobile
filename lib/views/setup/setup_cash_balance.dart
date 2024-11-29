import 'package:final_project/services/firestore_service.dart';
import 'package:final_project/styles/button.dart';
import 'package:final_project/views/common/custom_image_header.dart';
import 'package:final_project/views/onBoarding/onboarding_screen.dart';
import 'package:final_project/views/setup/turn_on_notification.dart';
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
    currencySymbol: "", // Placeholder, will update with Firestore value
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
        print("Currency code not found for the user.");
      }
    } catch (e) {
      print("Error fetching currency code: $e");
    }
  }

  Future<void> saveAccount() async {
    if (inputValue == null || userCurrencyCode == null) {
      print("Incomplete data to save the account.");
      return;
    }

    try {
      final accountData = {
        "account_name": "main",
        "current_balance": double.tryParse(inputValue!.replaceAll(",", "")),
        "currency_code": userCurrencyCode,
        "type": "cash",
      };

      await _firestoreService.addAccount("main", accountData);
      print("Main account successfully created.");
    } catch (e) {
      print("Error saving account: $e");
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
                              hintText: "0", // Placeholder text
                              border: InputBorder.none, // No border
                              hintStyle: TextStyle(
                                fontSize: 30, // Size of hint text
                                color: Colors.grey,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 20, // Larger font for the entered text
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
                              MaterialPageRoute(builder: (context) => const TurnOnNotification()),
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
