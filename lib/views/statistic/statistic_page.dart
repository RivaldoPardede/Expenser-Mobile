import 'package:flutter/material.dart';
import 'package:final_project/views/statistic/widgets/financial_health_score.dart';
import './widgets/financial_factor_card.dart';
import 'financial_history_page.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  Map<String, double> factors = {
    "income": 0.0,
    "expense": 0.0,
    "savings": 0.0,
    "investment": 0.0,
  };

  void updateFactors(Map<String, double> updatedFactors) {
    setState(() {
      factors = updatedFactors;
    });
  }

  double calculateFinancialHealthScore() {
    return (0.40 * factors["income"]!) +
        (0.25 * factors["expense"]!) +
        (0.20 * factors["savings"]!) +
        (0.15 * factors["investment"]!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            floating: false,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                "Statistic",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
              centerTitle: true,
              background: Container(
                color: Colors.white,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Good Morning, User",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Your Financial Health Score",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 8),
                      financialHealthScore(
                        score: calculateFinancialHealthScore(),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Financial Health Factors",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 28),
                      financialFactorCard(
                        onFactorsUpdated: updateFactors,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 16.0,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FinancialHistoryPage(financialHealthScore: calculateFinancialHealthScore(),)),
                          );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4391DE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(34),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Center(
                            child: Text(
                              "Financial History",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}