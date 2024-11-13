import 'package:final_project/views/auth/signup_page.dart';
import 'package:flutter/material.dart';
import 'onboarding_page.dart';
import 'package:final_project/views/home/home.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  late final List<Widget> _pages = [
    OnboardingPage(
      title: "Hello!",
      subtitle: "Welcome to our app, your best way to get financial freedom.",
      buttonText: "Get Started",
      imagePath: "images/ilogo.png",
      isFirstPage: true, // Set true untuk halaman pertama
      onNext: _nextPage,
    ),
    OnboardingPage(
      title: "Your Finance in One Place",
      subtitle: "Get the help you need to stay on top of your money.",
      buttonText: "Next",
      imagePath: "images/io_1.png",
      onNext: _nextPage,
      onSkip: _goToLastPage,
    ),
    OnboardingPage(
      title: "Track your Spending",
      subtitle: "Track and analyze expenses meticulously.",
      buttonText: "Next",
      imagePath: "images/io_2.png",
      onNext: _nextPage,
      onSkip: _goToLastPage,
    ),
    OnboardingPage(
      title: "Budget your Money",
      subtitle: "Add monthly budgets, control unnecessary expenses.",
      buttonText: "Next",
      imagePath: "images/io_3.png",
      onNext: _nextPage,
      onSkip: _goToLastPage,
    ),
    OnboardingPage(
      title: "Manage your Financial Health",
      subtitle: "Review detailed monthly financial reports.",
      buttonText: "Next",
      imagePath: "images/io_4.png",
      onNext: _nextPage,
      onSkip: _goToLastPage,
    ),
    OnboardingPage(
      title: "Manage your Financial Health",
      subtitle: "Review detailed monthly financial reports.",
      buttonText: "Let’s Start",
      imagePath: "images/io_5.png",
      isLastPage: true, // Set true untuk halaman terakhir
      onNext: _nextPage,
    )
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to HomePage when onboarding is complete
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }

  void _goToLastPage() {
    _controller.jumpToPage(_pages.length - 1); // Lompat ke halaman terakhir
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemCount: _pages.length,
              itemBuilder: (context, index) => _pages[index],
            ),
          ),
          if (_currentPage > 0) // Hanya tampilkan indikator halaman jika bukan halaman pertama
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length - 1, (index) { // Kurangi 1 dari itemCount
                return Container(
                  margin: const EdgeInsets.all(4),
                  width: _currentPage == index + 1 ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index + 1 ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
