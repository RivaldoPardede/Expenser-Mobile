import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

enum ExpenseType { daily, weekly }

class ExpenseGraph extends StatefulWidget {
  final ExpenseType type;
  const ExpenseGraph({super.key, required this.type});

  @override
  State<ExpenseGraph> createState() => _ExpenseGraphState();
}

class _ExpenseGraphState extends State<ExpenseGraph> {
  late String selectedValue;
  late List<String> dropdownOptions;

  @override
  void initState() {
    super.initState();
    _updateDropdownOptions();
  }

  @override
  void didUpdateWidget(covariant ExpenseGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.type != widget.type) {
      _updateDropdownOptions();
    }
  }

  void _updateDropdownOptions() {
    if (widget.type == ExpenseType.daily) {
      dropdownOptions = ['Week1', 'Week2', 'Week3', 'Week4'];
    } else {
      dropdownOptions = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
    }
    selectedValue = dropdownOptions.first;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Expense',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            DropdownButton<String>(
              value: selectedValue,
              items: dropdownOptions
                  .map((option) => DropdownMenuItem(
                value: option,
                child: Text(option),
              ))
                  .toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedValue = value!;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          height: 220,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (widget.type == ExpenseType.daily ? 6 : 3),
              minY: 0,
              maxY: 600000,
              lineBarsData: [
                LineChartBarData(
                  spots: _getDataPoints(),
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 2,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 6,
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeColor: Colors.blue,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.blue.withOpacity(0.1),
                  ),
                ),
              ],
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      if (widget.type == ExpenseType.daily) {
                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            value.toInt() < days.length ? days[value.toInt()] : '',
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      } else {
                        const weeks = ['W1', 'W2', 'W3', 'W4'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            value.toInt() < weeks.length ? weeks[value.toInt()] : '',
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }
                    },
                  ),
                ),
                leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),

            ),
          ),
        )
      ]),
    );
  }

  List<FlSpot> _getDataPoints() {
    if (widget.type == ExpenseType.daily) {
      return [
        FlSpot(0, 500000),
        FlSpot(1, 250000),
        FlSpot(2, 500000),
        FlSpot(3, 200000),
        FlSpot(4, 250000),
        FlSpot(5, 250000),
        FlSpot(6, 500000),
      ];
    } else {
      return [
        FlSpot(0, 500000),
        FlSpot(1, 250000),
        FlSpot(2, 500000),
        FlSpot(3, 200000),
      ];
    }
  }
}
