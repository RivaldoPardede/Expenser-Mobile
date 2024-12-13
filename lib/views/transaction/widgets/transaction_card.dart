import 'package:final_project/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum TransactionType { expense, income }

class TransactionCard extends StatelessWidget {
  final String title;
  final String amount;
  final String method;
  final String date;
  final TransactionType type;

  const TransactionCard({
    super.key,
    required this.title,
    required this.amount,
    required this.method,
    required this.date,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          type == TransactionType.income
              ? 'images/transactionHistory/incomeArrow.svg'
              : 'images/transactionHistory/expenseArrow.svg',
          width: 40,
          height: 40,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                method,
                style: TextStyle(
                  fontSize: 14,
                  color: black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                date,
                style:  TextStyle(
                  fontSize: 14,
                  color: darkGrey,
                ),
              ),
            ],
          ),
        ),
        // Trailing amount text
        Text(
          amount,
          style: TextStyle(
            color: type == TransactionType.income ? green : red,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

}
