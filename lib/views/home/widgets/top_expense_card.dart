import 'package:final_project/views/home/widgets/top_expense_bar.dart';
import 'package:flutter/material.dart';
import 'package:final_project/services/firestore_service.dart';

class TopExpenseCard extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  final List<Color> barColors = [
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.purple,
    Colors.red,
  ];

  TopExpenseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _firestoreService.getTop3ExpensesThisMonthWithCurrency(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No expenses this month'));
        }

        final expenseData = snapshot.data!;

        double total = expenseData.fold(0.0, (sum, item) => sum + (item['amount'] ?? 0.0));

        return Column(
          children: [
            ...expenseData.asMap().entries.map((entry) {
              int index = entry.key;
              final expense = entry.value;

              return TopExpenseBarItem(
                category: expense['category'],
                value: expense['amount'],
                totalValue: total,
                color: barColors[index % barColors.length],
                currencyCode: expense['currency_code'] ?? '',
              );
            }),
          ],
        );
      },
    );
  }
}

