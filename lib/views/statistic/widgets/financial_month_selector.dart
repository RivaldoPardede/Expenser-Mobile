import 'package:flutter/material.dart';

class MonthSelector extends StatefulWidget {
  final List<String> months;
  final Function(String) onMonthChanged;

  const MonthSelector({
    super.key,
    required this.months,
    required this.onMonthChanged,
  });

  @override
  State<MonthSelector> createState() => _MonthSelectorState();
}

class _MonthSelectorState extends State<MonthSelector> {
  String selectedMonth = '';

  @override
  void initState() {
    super.initState();
    selectedMonth = widget.months.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: widget.months.map((month) {
            final isSelected = month == selectedMonth;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedMonth = month;
                });
                widget.onMonthChanged(month);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFA2C8EF)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    month,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? const Color(0xFF3B3B3B)
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
