import 'package:final_project/styles/color.dart';
import 'package:flutter/material.dart';

class ModalHeader extends StatelessWidget {
  final String title;
  final VoidCallback onCancel;
  final VoidCallback onAdd;

  const ModalHeader({
    super.key,
    required this.title,
    required this.onCancel,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            "Cancel",
            style: TextStyle(
              color: blue,
              fontSize: 16,
            ),
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: onAdd,
          child: Text(
            "Add",
            style: TextStyle(
              color: blue,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
