import 'package:flutter/material.dart';
import '../auth/signin_page.dart';

void showLogOutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Logout',
            semanticsLabel: 'Logout Confirmation',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        content: const Text(
          'Are you sure you want to logout? Any unsaved progress may be lost.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () => _handleLogout(context),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      );
    },
  );
}

void _handleLogout(BuildContext context) {
  Navigator.pop(context);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const SigninPage()),
  );
}
