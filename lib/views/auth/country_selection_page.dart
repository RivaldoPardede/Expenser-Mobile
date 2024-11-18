import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/styles/button.dart';
import 'package:final_project/views/onBoarding/onboarding_screen.dart';
import 'package:final_project/views/common/custom_header.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:final_project/views/setup/setup_cash_balance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_project/services/firestore_service.dart';

class CountrySelectionPage extends StatefulWidget {
  const CountrySelectionPage({super.key});

  @override
  _CountrySelectionPageState createState() => _CountrySelectionPageState();
}

class _CountrySelectionPageState extends State<CountrySelectionPage> {
  Currency? selectedCurrency;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const CustomHeader(
                  headerText: 'The Nation Where You Primarily Reside',
                  detailText: 'Which part of the country do you call home?',
                ),
                const SizedBox(height: 50),

                // Currency Selection Button
                SizedBox(
                  width: double.infinity,
                  height: 62,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 10,
                      shadowColor: Colors.grey.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(56),
                      ),
                    ),
                    onPressed: () {
                      showCurrencyPicker(
                        context: context,
                        showFlag: true,
                        showCurrencyName: true,
                        showCurrencyCode: true,
                        onSelect: (Currency currency) {
                          setState(() {
                            selectedCurrency = currency;
                          });
                        },
                        theme: CurrencyPickerThemeData(
                          backgroundColor: Colors.white,
                        )
                      );
                    },
                    child: Text(
                      selectedCurrency != null
                          ? 'Currency: ${selectedCurrency!.name} (${selectedCurrency!.code})'
                          : 'Select your country',
                      style: const TextStyle(
                        color: Color(0xFF757575),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: ElevatedButton(
              style: buttonPrimary,
              onPressed: selectedCurrency != null
                  ? () async {
                final userId = FirebaseAuth.instance.currentUser?.uid;
                if (userId != null && selectedCurrency != null) {
                  try {
                    await _firestoreService.saveCurrencyCode(userId, selectedCurrency!.code);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SetupCashBalance()),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Failed to save currency: ${e.toString()}"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              } : null,
              child: const Text('Continue')
            )
          ),
        ],
      ),
    );
  }
}
