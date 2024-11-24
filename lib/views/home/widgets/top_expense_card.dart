import 'package:final_project/views/home/widgets/top_expense_bar.dart';
import 'package:flutter/material.dart';

class TopExpenseCard extends StatelessWidget {
  final List<Map<String, dynamic>> expenseData = [
    {'title': 'Food', 'amount': 120000.0, 'color': Colors.blue},
    {'title': 'Transport', 'amount': 80000.0, 'color': Colors.green},
    {'title': 'Shopping', 'amount': 100000.0, 'color': Colors.red},
  ];

  TopExpenseCard({super.key});

  @override
  Widget build(BuildContext context) {
    double total = expenseData.fold(0, (sum, item) => sum + item['amount']);

    return Column(
      children: expenseData.map((expense) {
        return TopExpenseBarItem(
          category: expense['title'],
          value: expense['amount'],
          totalValue: total,
          color: expense['color'],
        );
      }).toList(),
    );
  }
}
