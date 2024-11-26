import 'package:flutter/material.dart';

class FinancialHealthOverview extends StatelessWidget {
  final double financialHealthScore;

  const FinancialHealthOverview({super.key, required this.financialHealthScore});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Financial Health',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          financialHealthScore.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE41111),
          ),
        ),
      ],
    );
  }
}
