import 'package:final_project/views/onBoarding/onboarding_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Preview',
      theme: ThemeData(
        fontFamily: 'Inter',
      ),
      home: const OnboardingScreen(),
    );
  }
}
