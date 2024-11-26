import 'package:flutter/material.dart';

class CustomListTileDivider extends StatelessWidget {
  const CustomListTileDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all( 14.0),
      child: Divider(
        height: 3,
        color: Color(0xffF5F5F5),
      ),
    );
  }
}
