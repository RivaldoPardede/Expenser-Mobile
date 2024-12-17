import 'package:final_project/services/firestore_service.dart';
import 'package:final_project/styles/color.dart';
import 'package:flutter/material.dart';

class financialFactorCard extends StatefulWidget {
  const financialFactorCard({super.key});

  @override
  State<financialFactorCard> createState() => _financialFactorCardState();
}

class _financialFactorCardState extends State<financialFactorCard> {
  final FirestoreService firestoreService = FirestoreService();
  double totalIncome = 0.0;
  double totalExpenses = 0.0;

  double calculateIncomePercentage(Map<String, List<Map<String, dynamic>>> transactionsByDate) {
    totalIncome = 0.0;
    totalExpenses = 0.0;

    transactionsByDate.forEach((date, transactions) {
      for (var transaction in transactions) {
        final double amount = (transaction['amount'] ?? 0.0).toDouble();
        final String type = transaction['transactionType'] ?? '';

        if (type.toLowerCase() == 'income') {
          totalIncome += amount;
        } else if (type.toLowerCase() == 'expense') {
          totalExpenses += amount;
        }
      }
    });

    if (totalIncome > 0) {
      final percentage = ((totalIncome - totalExpenses) / totalIncome) * 100;
      return percentage < 0 ? 0.0 : percentage;
    } else {
      return 0.0;
    }
  }

  double calculateExpensePercentage() {
    if (totalIncome > 0) {
      final percentage = (100 - (totalExpenses / (0.7 *totalIncome)) * 100);
      return percentage < 0 ? 0.0 : percentage;
    } else {
      return 0.0;
    }
  }

  Map<String, dynamic> getStatusAndColor(double percentage) {
    if (percentage >= 80) {
      return {"status": "So Good", "color": const Color(0xFF7BB2E8)};
    } else if (percentage >= 60) {
      return {"status": "Overall good", "color": const Color(0xFFFEE256)};
    } else if (percentage >= 40) {
      return {"status": "Enough", "color": const Color(0xFFFF9433)};
    } else {
      return {"status": "Needs Attention", "color": const Color(0xFFE93939)};
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, List<Map<String, dynamic>>>>(
      stream: firestoreService.getUserTransactionsGroupedByDate(),
      builder: (context, snapshot) {
        double incomePercentage = 0.0, expensePercentage = 0.0;

        if (snapshot.hasData) {
          incomePercentage = calculateIncomePercentage(snapshot.data!);
          expensePercentage = calculateExpensePercentage();
        }

        final factors = [
          {"label": "Savings", "percentage": "30%", "status": "Overall good", "color": Colors.yellow},
          {"label": "Expenses", "percentage": "${expensePercentage.toStringAsFixed(2)}%", "status": getStatusAndColor(expensePercentage)["status"], "color": getStatusAndColor(expensePercentage)["color"]},
          {"label": "Investments", "percentage": "35%", "status": "So Good", "color": Colors.blue},
          {"label": "Income", "percentage": "${incomePercentage.toStringAsFixed(2)}%", "status": getStatusAndColor(incomePercentage)["status"], "color": getStatusAndColor(incomePercentage)["color"]},
        ];

        return GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: factors.length,
          itemBuilder: (context, index) {
            final factor = factors[index];
            return Card(
              color: lightGrey,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Container(
                    width: 7,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: factor["color"] as Color,
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            factor["percentage"] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            factor["status"] as String,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1C1C1C),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            factor["label"] as String,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}