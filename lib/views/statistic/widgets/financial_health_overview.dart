import 'package:flutter/material.dart';

class FinancialHealthOverview extends StatelessWidget {
  final double financialHealthScore;

  const FinancialHealthOverview({super.key, required this.financialHealthScore});

  @override
  Widget build(BuildContext context) {
    Color scoreColor;

    if (financialHealthScore <= 39) {
      scoreColor = Colors.red;
    } else if (financialHealthScore <= 59) {
      scoreColor = Colors.orange;
    } else if (financialHealthScore <= 79) {
      scoreColor = Colors.yellow;
    } else {
      scoreColor = Colors.blue;
    }

    return RichText(
      text: TextSpan(
        text: 'Financial Health: ',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: financialHealthScore.toStringAsFixed(0),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: scoreColor,
            ),
          ),
        ],
      ),
    );
  }
}
