import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../styles/color.dart';

class financialHealthScore extends StatelessWidget {
  final double score;

  const financialHealthScore({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('d MMMM yyyy').format(DateTime.now()),
                  style: TextStyle(
                      fontSize: 12,
                      color: darkGrey,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 300,
              height: 300,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: 100.1,
                    ranges: <GaugeRange>[
                      GaugeRange(
                        startValue: 0,
                        endValue: score,
                        color: const Color(0xFF7BB2E8),
                        startWidth: 15,
                        endWidth: 15,
                      ),
                      GaugeRange(
                        startValue: score,
                        endValue: 100,
                        color: const Color(0xFFE6EBF8),
                        startWidth: 15,
                        endWidth: 15,
                      ),
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(
                        value: score, // Financial score
                        needleColor: Color(0xFF5B9EE1),
                        knobStyle: KnobStyle(
                          color: Colors.white,
                          borderColor: Color(0xFF5470C6),
                          borderWidth: 0.07,
                          knobRadius: 0.1,
                        ),
                      ),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Text(
                          '${score.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 62,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                          ),
                        ),
                        positionFactor: 0.8,
                        angle: 90,
                      ),
                    ],
                    showLabels: true,
                    showTicks: true,
                    labelOffset: 10,
                    axisLabelStyle: const GaugeTextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              "Your score is above the average of U.S. Consumers and demonstrates to lenders that you are a very dependable borrower.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF4A4A4A)),
            ),
            const SizedBox(height: 16),
            _buildScoreLegend(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );;
  }
}

// double calculateFinancialHealthScore() {
//   // Get the percentage values for income, expenses, savings, and investments.
//   double incomePercentage = 70.0;  // Example value, replace with your actual calculated percentage
//   double expensePercentage = 30.0; // Example value, replace with your actual calculated percentage
//   double savingsPercentage = 50.0; // Example value, replace with your actual calculated percentage
//   double investmentPercentage = 40.0; // Example value, replace with your actual calculated percentage
//
//   // Apply the weighted formula
//   double financialHealthScore = (0.40 * incomePercentage) +
//       (0.25 * expensePercentage) +
//       (0.20 * savingsPercentage) +
//       (0.15 * investmentPercentage);
//
//   // Ensure the score is within the range [0, 100]
//   return financialHealthScore.clamp(0.0, 100.0);
// }

Widget _buildScoreLegend() {
  final legendItems = [
    {"label": "Poor", "color": const Color(0xFFE93939), "range": "0-39"},
    {"label": "Fair", "color": const Color(0xFFFF9433), "range": "40-59"},
    {"label": "Good", "color": const Color(0xFFFEE256), "range": "60-79"},
    {"label": "Excellent", "color": const Color(0xFF7BB2E8), "range": "80-100"},
  ];

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: legendItems.map((item) {
      return Column(
        children: [
          Container(
            width: 18,
            height: 8,
            decoration: BoxDecoration(
              color: item["color"] as Color,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.centerLeft,
          ),
          const SizedBox(height: 4),
          Text(
            item["label"] as String,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: item["color"] as Color),
          ),
          Text(
            item["range"] as String,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      );
    }).toList(),
  );
}