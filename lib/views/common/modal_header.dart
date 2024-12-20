import 'package:final_project/styles/color.dart';
import 'package:flutter/material.dart';

class ModalHeader extends StatelessWidget {
  final String title;
  final String cancelText;
  final String? addText;
  final bool isleadingIcon;
  final VoidCallback onCancel;
  final VoidCallback? onAdd;

  const ModalHeader({
    super.key,
    required this.title,
    required this.cancelText,
    this.addText,
    required this.isleadingIcon,
    required this.onCancel,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: onCancel,
            icon: isleadingIcon ? Icon(Icons.arrow_back, color: blue,) : null,
            label: Text(
              cancelText,
              style: TextStyle(
                color: blue,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (addText != null)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onAdd,
              child: Text(
                addText!,
                style: TextStyle(
                  color: blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
