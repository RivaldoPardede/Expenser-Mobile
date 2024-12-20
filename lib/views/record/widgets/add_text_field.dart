import 'package:flutter/material.dart';

class AddTextField extends StatelessWidget {

  final String titleText;
  final String hintText;
  final TextEditingController controller;

  const AddTextField({
    super.key,
    required this.titleText,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            titleText,
            style: const TextStyle(fontSize: 16,),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
          ),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
          maxLines: null,
        ),
      ],
    );
  }
}
