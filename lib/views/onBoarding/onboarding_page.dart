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
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.05;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                imagePath,
                height: isFirstPage? size.height * 0.1 : size.height * 0.3,
                fit: BoxFit.contain,
              ),
              SizedBox(height: size.height * 0.03),
              Text(
                title,
                style: TextStyle(
                  fontSize: size.width * 0.06,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: size.width * 0.045,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(height: size.height * 0.1),
            ],
          ),
          Positioned(
            bottom: 0,
            right: padding,
            left: (isFirstPage || isLastPage) ? padding : null,
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
              left: padding,
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
