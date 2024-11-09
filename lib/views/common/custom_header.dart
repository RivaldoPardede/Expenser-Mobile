import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String headerText;
  final String detailText;

  const CustomHeader({
    super.key,
    required this.headerText,
    required this.detailText
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 16.0),
          child: Text(
           headerText,
            style: const TextStyle(
             fontWeight: FontWeight.w500,
             fontSize: 26,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          detailText,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14
          ),
        )
      ],
    );
  }
}
