import 'package:final_project/styles/button.dart';
import 'package:final_project/views/common/custom_header.dart';
import 'package:final_project/views/common/custom_image_header.dart';
import 'package:final_project/views/setup/account_created.dart';
import 'package:final_project/views/setup/setup_cash_balance.dart';
import 'package:flutter/material.dart';

class TurnOnNotification extends StatefulWidget {
  const TurnOnNotification({super.key});

  @override
  State<TurnOnNotification> createState() => _TurnOnNotificationState();
}

class _TurnOnNotificationState extends State<TurnOnNotification> {
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
              MaterialPageRoute(builder: (context) => const SetupCashBalance()),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomHeader(
                  headerText: 'Turn Notification',
                  detailText: 'Enable notifications to keep you informed and engaged.',
                ),
                SizedBox(height: 100),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: CustomImageHeader(
                        headerText: 'Turn On Security Notification',
                        detailText:
                        'Stay informed and keep your account safe with security notifications. Join us for a safer experience.',
                        svgPath: "images/notification.svg",
                      ),
                    ),
                  ),
                ),
              ]
            )
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
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const AccountCreated()),
                          );
                        },
                        child: const Text('Turn On Notification'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
