import 'package:final_project/styles/button.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final String imagePath;
  final bool isFirstPage;
  final bool isLastPage;
  final VoidCallback onNext;
  final VoidCallback? onSkip;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.imagePath,
    this.isFirstPage = false,
    this.isLastPage = false,
    required this.onNext,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(imagePath, height: 200),
              const SizedBox(height: 24),
              Text(
                title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                subtitle,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              const SizedBox(height: 80),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 16,
            child: (isFirstPage || isLastPage)
                ? ElevatedButton(
              style: buttonPrimary,
              onPressed: onNext,
              child: Text(buttonText),
            )
                : ElevatedButton(
              style: circleButtonStyle,
              onPressed: onNext,
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          if (onSkip != null && !isFirstPage && !isLastPage)
            Positioned(
              bottom: 0,
              left: 16,
              child: TextButton(
                onPressed: onSkip,
                child: const Text(
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