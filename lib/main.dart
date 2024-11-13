import 'package:device_preview/device_preview.dart';
import 'package:final_project/views/onBoarding/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:final_project/providers/auth_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    DevicePreview(
        builder: (context) =>
      const MyApp()
  )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financial App Onboarding',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OnboardingScreen(),
    );
  }
}
