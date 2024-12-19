import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class FinancialHealthPie extends StatelessWidget {
  final double savingsPercentage;
  final double expendituresPercentage;

  const FinancialHealthPie({
    super.key,
    required this.savingsPercentage,
    required this.expendituresPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final totalPercentage = savingsPercentage + expendituresPercentage;

    return Container(
      height: 180,
      width: 180,
      child: PieChart(
        dataMap: {
          "Savings": savingsPercentage,
          "Expenditures": expendituresPercentage,
        },
        animationDuration: const Duration(milliseconds: 800),
        chartType: ChartType.ring,
        ringStrokeWidth: 50,
        baseChartColor: Colors.grey[200]!,
        colorList: const [
          Color(0xFF7BB2E8), // Savings
          Color(0xFF114A83), // Expenditures
        ],
        chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: true,
          chartValueBackgroundColor: const Color(0xFFFFFFFF).withOpacity(0.67),
          showChartValuesInPercentage: true,
          showChartValuesOutside: false,
          chartValueStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF012169),
          ),
        ),
        legendOptions: const LegendOptions(
          showLegends: false,
        ),
        totalValue: totalPercentage,
      ),
    );
  }
}
