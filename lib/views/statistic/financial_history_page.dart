import 'package:flutter/material.dart';
import 'widgets/weekly_expense_graph.dart';
import 'widgets/financial_health_pie.dart';
import 'widgets/financial_health_overview.dart';
import 'widgets/financial_month_selector.dart';

class FinancialHistoryPage extends StatelessWidget {
  const FinancialHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Month Selector
                  MonthSelector(
                    months: const [
                      'Oct',
                      'Nov',
                      'Des',
                      'Jan',
                      'Feb',
                      'Mar',
                    ],
                    onMonthChanged: (selectedMonth) {
                      debugPrint('Selected Month: $selectedMonth');
                    },
                  ),
                  const SizedBox(height: 16),
                  // Expense Graph
                  const ExpenseGraph(type: ExpenseType.weekly),
                  const SizedBox(height: 16),
                  // Container for Pie Chart and Financial Health
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Pie Chart and Legend
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              // Pie Chart
                              FinancialHealthPie(),
                              const SizedBox(height: 30),
                              // Legend
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                  const SizedBox(width: 30),
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
                                        "Expends",
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
                            ],
                          ),
                        ),
                        const SizedBox(width: 30),
                        // Financial Health Overview
                        const Expanded(
                          flex: 1,
                          child: FinancialHealthOverview(
                            financialHealthScore: 52.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
