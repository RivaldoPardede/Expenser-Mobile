import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onPressed;

  const AuthButton({
    super.key,
    required this.text,
    required this.iconPath,
    required this.onPressed,
});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Image.asset(iconPath, height: 23),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        textStyle: const TextStyle(fontSize: 16)
      ),
    );
  }
}
