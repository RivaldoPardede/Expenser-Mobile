import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomImageHeader extends StatelessWidget {
  final String headerText;
  final String detailText;
  final String svgPath;

  const CustomImageHeader({
    super.key,
    required this.headerText,
    required this.detailText,
    required this.svgPath
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: SvgPicture.asset(svgPath, height: 80, fit: BoxFit.contain,),
        ),
        const SizedBox(height: 25),
        Container(
          margin: const EdgeInsets.only(right: 16.0),
          child: Text(
            headerText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 26,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          detailText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

