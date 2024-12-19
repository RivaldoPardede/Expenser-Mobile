import 'package:final_project/services/firestore_service.dart';
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
  late Stream<List<Map<String, dynamic>>> expenseStream = const Stream.empty();

  @override
  void initState() {
    super.initState();
    _updateDropdownOptions();
    _updateExpenseStream();
  }

  @override
  void didUpdateWidget(covariant ExpenseGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.type != widget.type) {
      _updateDropdownOptions();
      _updateExpenseStream();
    }
  }

  List<Map<String, int>> calculateWeeksInMonth(int year, int month) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    List<Map<String, int>> weeks = [];

    int startDay = 1;
    while (startDay <= daysInMonth) {
      int endDay = (startDay + 6).clamp(startDay, daysInMonth);
      weeks.add({'start': startDay, 'end': endDay});
      startDay = endDay + 1;
    }

    return weeks;
  }

  void _updateDropdownOptions() {
    final now = DateTime.now();

    if (widget.type == ExpenseType.daily) {
      final weeks = calculateWeeksInMonth(now.year, now.month);
      dropdownOptions = List.generate(weeks.length, (index) => 'Week ${index + 1}');
    } else {
      dropdownOptions = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
    }

    selectedValue = dropdownOptions.first;
  }

  Future<void> _updateExpenseStream() async {
    final userId = await FirestoreService().getCurrentUserId();
    if (userId == null) return;

    final now = DateTime.now();

    if (widget.type == ExpenseType.daily) {
      final weekIndex = dropdownOptions.indexOf(selectedValue);
      final year = now.year;
      final month = now.month;

      setState(() {
        expenseStream = FirestoreService().getDailyExpenses(userId, year, month, weekIndex + 1);
      });
    } else {
      final selectedMonth = dropdownOptions.indexOf(selectedValue) + 1;

      setState(() {
        expenseStream = FirestoreService().getWeeklyExpenses(userId, now.year, selectedMonth);
      });
    }
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
      child: Column(
        children: [
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
                    .map(
                      (option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ),
                )
                    .toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      selectedValue = value;
                      _updateExpenseStream();
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 220,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: expenseStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('An error occurred. Please try again later.'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final dataPoints = snapshot.data!;
                final List<FlSpot> chartSpots = [];

                final now = DateTime.now();
                double minX;
                double maxX;

                if (widget.type == ExpenseType.daily) {
                  final weeks = calculateWeeksInMonth(now.year, now.month);
                  final weekIndex = dropdownOptions.indexOf(selectedValue);

                  final startDayOfWeek = weeks[weekIndex]['start']!;
                  final endDayOfWeek = weeks[weekIndex]['end']!;

                  final Map<int, double> defaultPoints = {
                    for (int i = startDayOfWeek; i <= endDayOfWeek; i++) i: 0.0,
                  };

                  for (var e in dataPoints) {
                    final dayOfMonth = (e['date'] as DateTime).day;
                    if (dayOfMonth >= startDayOfWeek && dayOfMonth <= endDayOfWeek) {
                      defaultPoints[dayOfMonth] =
                          (defaultPoints[dayOfMonth] ?? 0) + (e['amount'] as double);
                    }
                  }

                  defaultPoints.forEach((key, value) {
                    chartSpots.add(FlSpot(key.toDouble(), value));
                  });

                  minX = startDayOfWeek.toDouble();
                  maxX = endDayOfWeek.toDouble();
                } else {
                  for (int i = 0; i < dataPoints.length; i++) {
                    chartSpots.add(FlSpot((i + 1).toDouble(), dataPoints[i]['amount'] as double));
                  }
                  minX = 1;
                  maxX = dataPoints.length.toDouble();
                }

                final maxY = chartSpots.isNotEmpty
                    ? chartSpots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b)
                    : 10.0;

                return LineChart(
                  LineChartData(
                    minX: minX,
                    maxX: maxX,
                    minY: 0,
                    maxY: maxY + 10,
                    lineBarsData: [
                      LineChartBarData(
                        spots: chartSpots,
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
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            } else {
                              final weekIndex = value.toInt() - 1;
                              if (weekIndex >= 0 && weekIndex < calculateWeeksInMonth(now.year, dropdownOptions.indexOf(selectedValue) + 1).length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Week ${weekIndex + 1}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                );
                              }
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
