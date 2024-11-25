import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../home/home_page.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistic"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            //TODO: Implement back action
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Good Morning, Username",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C1C1C)
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Your Financial Health Score",
                  style: TextStyle(fontSize: 14, color: Color(0xFF4A4A4A)),
                ),
                const SizedBox(height: 8),
                _buildFinancialHealthScoreGauge(),
                const SizedBox(height: 24),
                const Text(
                  "Financial Health Factors",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ),
      )
    );
  }

  Widget _buildFinancialHealthScoreGauge() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "9 October 2024",
                  style: TextStyle(fontSize: 12, color: Color(0xFF4A4A4A)),
                ),
                IconButton(
                  icon: const Icon(Icons.help_outlined, color: Color(0xFF7BB2E8)),
                  onPressed: () {
                    // Implement help action
                  },
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
                        endValue: 70,
                        color: const Color(0xFF7BB2E8),
                        startWidth: 15,
                        endWidth: 15,
                      ),
                      GaugeRange(
                        startValue: 70,
                        endValue: 100,
                        color: const Color(0xFFE6EBF8),
                        startWidth: 15,
                        endWidth: 15,
                      ),
                    ],
                    pointers: const <GaugePointer>[
                      NeedlePointer(
                        value: 70, // Financial score
                        needleColor: Color(0xFF5B9EE1),
                        knobStyle: KnobStyle(
                          color: Colors.white,
                          borderColor: Color(0xFF5470C6),
                          borderWidth: 0.07,
                          knobRadius: 0.1,
                        ),
                      ),
                    ],
                    annotations: const <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Text(
                          '70',
                          style: TextStyle(
                            fontSize: 62,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFEDF00),
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
          ],
        ),
      ),
    );
  }

  Widget _buildScoreLegend() {
    final legendItems = [
      {"label": "Poor", "color": const Color(0xFFE93939), "range": "0-39"},
      {"label": "Fair", "color": const Color(0xFFFF9433), "range": "40-59"},
      {"label": "Good", "color": const Color(0xFFFEE256), "range": "60-79"},
      {"label": "Excellent", "color": const Color(0xFF7BB2E8), "range": "80-100"},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            ),
            const SizedBox(height: 4),
            Text(
              item["label"] as String,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
}

