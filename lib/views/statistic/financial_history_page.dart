import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_project/services/firestore_service.dart';
import 'package:final_project/views/common/expense_graph.dart';
import 'widgets/financial_health_pie.dart';
import 'widgets/financial_health_overview.dart';

class FinancialHistoryPage extends StatelessWidget {
  const FinancialHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            backgroundColor: Colors.white,
            floating: true,
            pinned: false,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Financial History',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            iconTheme: IconThemeData(color: Colors.black),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: firestoreService.getAccountsStream(
                    FirebaseAuth.instance.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(
                      child: Text('Error fetching data'),
                    );
                  }

                  final accounts = snapshot.data!;
                  double totalIncome = 0.0;
                  double totalSavings = 0.0;
                  double totalExpenses = 0.0;

                  for (var account in accounts) {
                    final balance = (account['current_balance'] ?? 0.0) as double;
                    final type = account['type'] ?? '';
                    if (type == 'Savings') {
                      totalSavings += balance;
                    } else if (type == 'Expenses') {
                      totalExpenses += balance;
                    } else if (type == 'Income') {
                      totalIncome += balance;
                    }
                  }

                  final savingsPercentage =
                  totalIncome > 0 ? (totalSavings / totalIncome) * 100 : 0.0;
                  final expendituresPercentage =
                  totalIncome > 0 ? (totalExpenses / totalIncome) * 100 : 0.0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ExpenseGraph(type: ExpenseType.weekly),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(35),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Pie Chart
                                Expanded(
                                  flex: 2,
                                  child: FinancialHealthPie(
                                    savingsPercentage: savingsPercentage,
                                    expendituresPercentage: expendituresPercentage,
                                  ),
                                ),
                                const SizedBox(width: 30),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 14,
                                            height: 14,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF7BB2E8),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          const Text(
                                            "Savings",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Container(
                                            width: 14,
                                            height: 14,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF114A83),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          const Text(
                                            "Expenses",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            FinancialHealthOverview(
                              financialHealthScore:
                              (savingsPercentage + expendituresPercentage) / 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
