import 'package:flutter/material.dart';
import 'color.dart';

final ButtonStyle buttonPrimary = ElevatedButton.styleFrom(
  minimumSize: Size(343, 66),
  backgroundColor: blue,
  foregroundColor: Colors.white,
  elevation: 0,
).copyWith(
  overlayColor: MaterialStateProperty.all(Colors.transparent), // Menghilangkan efek hover abu-abu
);

final ButtonStyle circleButtonStyle = ElevatedButton.styleFrom(
  minimumSize: Size(60, 60), // Ukuran button circular
  padding: EdgeInsets.zero,
  backgroundColor: Colors.black,
  foregroundColor: Colors.white,
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30), // Membuat bentuk circular
  ),
).copyWith(
  overlayColor: MaterialStateProperty.all(Colors.transparent), // Menghilangkan efek hover
);
