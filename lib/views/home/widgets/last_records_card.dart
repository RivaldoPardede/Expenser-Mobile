import 'package:final_project/views/home/widgets/last_records_item.dart';
import 'package:final_project/views/transaction/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:final_project/services/firestore_service.dart';

class LastRecordsCard extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  LastRecordsCard({super.key});

  String getCategoryIcon(TransactionType type) {
    return type == TransactionType.income
        ? 'images/transactionHistory/incomeArrow.svg'
        : 'images/transactionHistory/expenseArrow.svg';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: firestoreService.getTop3TransactionsThisMonth(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final records = snapshot.data!;

        return StreamBuilder<String?>(
          stream: firestoreService.getCurrencyCodeForUser().asStream(),
          builder: (context, currencySnapshot) {
            if (!currencySnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final currencyCode = currencySnapshot.data;

            return Column(
              children: records.map((record) {
                final categoryIconPath = getCategoryIcon(
                    record['transactionType'] == 'Income'
                        ? TransactionType.income
                        : TransactionType.expense);
                final currencySymbol = currencyCode ?? '';
                final amount = record['amount'];
                final formattedAmount = '$currencySymbol ${amount.toStringAsFixed(2)}';
                final isExpense = record['transactionType'] == 'Expense';
                final color = isExpense ? Colors.red : Colors.green;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: LastRecordsItem(
                    title: record['category'],
                    amount: formattedAmount,
                    date: record['date'],
                    paymentMethod: record['transactionType'],
                    icon: categoryIconPath,
                    color: color,
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}

