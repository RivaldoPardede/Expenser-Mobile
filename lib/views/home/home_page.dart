import 'package:final_project/views/common/expense_graph.dart';
import 'package:final_project/views/home/widgets/add_account_card.dart';
import 'package:final_project/views/home/widgets/last_records_card.dart';
import 'package:final_project/views/home/widgets/top_expense_card.dart';
import 'package:final_project/views/home/widgets/total_balance_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String? selectedValue = 'Week1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Expanded(
                      child: TotalBalanceCard(
                          svgPath: 'images/home/total_balance.svg',
                          accountName: 'Main',
                          totalBalance: 1000000
                      )
                    ),
                    SizedBox(width: 18),
                    Expanded(
                      child: AddAccountCard()
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const ExpenseGraph(type: ExpenseType.daily),

                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Top Expenses', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Divider(
                        color: Colors.black.withOpacity(0.2),
                        thickness: 0.5,
                        indent: 0,
                        endIndent: 0,
                      ),
                      const Text('THIS MONTH', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 16),
                      TopExpenseCard()
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Last Records', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Divider(
                        color: Colors.black.withOpacity(0.2),
                        thickness: 0.5,
                        indent: 0,
                        endIndent: 0,
                      ),
                      const Text('THIS MONTH', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      LastRecordsCard(),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
