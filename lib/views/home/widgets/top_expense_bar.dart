import 'package:flutter/material.dart';

class TopExpenseBarItem extends StatelessWidget {
  final String category;
  final double value;
  final double totalValue;
  final Color color;

  const TopExpenseBarItem({
    super.key,
    required this.category,
    required this.value,
    required this.totalValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = (value / totalValue) * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              'IDR ${value.toStringAsFixed(0).replaceAllMapped(
                RegExp(r'\B(?=(\d{3})+(?!\d))'),
                    (match) => ',',
              )}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 24,
            width: double.infinity,
            color: Colors.grey.withOpacity(0.2),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: MediaQuery.of(context).size.width * (percentage / 100) * 0.7,
                  height: 24,
                  color: color,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
