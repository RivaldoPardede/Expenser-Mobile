import 'package:final_project/styles/button.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final String imagePath;
  final bool isFirstPage;
  final bool isLastPage; // New parameter to check if it's the last page
  final VoidCallback onNext;
  final VoidCallback? onSkip;

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.imagePath,
    this.isFirstPage = false,
    this.isLastPage = false, // Default to false
    required this.onNext,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Image.asset(imagePath, height: 200),
              SizedBox(height: 24),
              Text(
                title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                subtitle,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              // Spacer untuk memberikan ruang untuk button circular
              SizedBox(height: 80),
            ],
          ),
          // Circular button positioned at bottom right
          Positioned(
            bottom: 0,
            right: 16, // Jarak dari kanan
            child: (isFirstPage || isLastPage) // Check for first or last page
                ? ElevatedButton(
              style: buttonPrimary,
              onPressed: onNext,
              child: Text(buttonText),
            )
                : ElevatedButton(
              style: circleButtonStyle,
              onPressed: onNext,
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          if (onSkip != null && !isFirstPage && !isLastPage)
            Positioned(
              bottom: 0,
              left: 16, // Jarak dari kiri
              child: TextButton(
                onPressed: onSkip,
                child: Text(
                  'Skip',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
        ],
      ),
    );
  }
}