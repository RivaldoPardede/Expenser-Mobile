import 'package:flutter/material.dart';
import 'color.dart';

final ButtonStyle buttonPrimary = ElevatedButton.styleFrom(
  minimumSize: const Size(343, 66),
  backgroundColor: blue,
  foregroundColor: Colors.white,
  elevation: 0,
  ).copyWith(
    overlayColor: WidgetStateProperty.all(Colors.transparent),
);

final ButtonStyle circleButtonStyle = ElevatedButton.styleFrom(
  minimumSize: const Size(60, 60),
  padding: EdgeInsets.zero,
  backgroundColor: Colors.black,
  foregroundColor: Colors.white,
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30),
  ),
  ).copyWith(
    overlayColor: WidgetStateProperty.all(Colors.transparent),
);
