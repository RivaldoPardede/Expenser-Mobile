import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:final_project/main.dart';
import 'package:final_project/views/onBoarding/onboarding_screen.dart';

void main() {
  testWidgets('MyApp starts on the onboarding screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.text('Hello!'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
