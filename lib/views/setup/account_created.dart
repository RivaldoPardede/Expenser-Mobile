import 'package:final_project/styles/button.dart';
import 'package:final_project/views/common/custom_image_header.dart';
import 'package:final_project/views/navigation/main_screen.dart';
import 'package:flutter/material.dart';

class AccountCreated extends StatelessWidget {
  const AccountCreated({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Center(
                child: CustomImageHeader(
                  headerText: 'Account Created',
                  detailText:
                  'Welcome! Your account is ready. Discover meaningful projects and join us on Activity',
                  svgPath: "images/account_created.svg",
                ),
              ),
            ),
          ),
          // Button Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: buttonPrimary,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
                },
                child: const Text('Continue'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
