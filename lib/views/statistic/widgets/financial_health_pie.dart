import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class FinancialHealthPie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: 180,
      child: PieChart(
        dataMap: {
          "Savings": 67,
          "Expenditures": 33,
        },
        animationDuration: const Duration(milliseconds: 800),
        chartType: ChartType.ring,
        ringStrokeWidth: 50,
        baseChartColor: Colors.grey,
        colorList: const [
          Color(0xFF7BB2E8),
          Color(0xFF114A83),
        ],
        chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: true,
          chartValueBackgroundColor: const Color(0xFFFFFFFF)
              .withOpacity(0.67),
          showChartValuesInPercentage: true,
          showChartValuesOutside: false,
          chartValueStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF012169),
          ),
        ),
        legendOptions: const LegendOptions(
          showLegends: false,
        ),
      ),
    );
  }
}
