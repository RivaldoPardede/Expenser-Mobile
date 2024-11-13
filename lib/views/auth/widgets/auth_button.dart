import 'package:final_project/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: SvgPicture.asset(iconPath),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: black,
          ),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(376, 66),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12),
          textStyle: const TextStyle(fontSize: 16),
        ).copyWith(
          overlayColor: WidgetStateProperty.all(Colors.transparent),
        ),
      ),
    );
  }
}
