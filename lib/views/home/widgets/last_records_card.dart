import 'package:final_project/views/home/widgets/last_records_item.dart';
import 'package:flutter/material.dart';

class LastRecordsCard extends StatelessWidget {
  final List<Map<String, dynamic>> records = [
    {
      'title': 'Rent',
      'amount': 500000,
      'date': DateTime(2024, 11, 15),
      'paymentMethod': 'Bank Transfer',
      'icon': Icons.home,
      'color': Colors.orange,
    },
    {
      'title': 'Groceries',
      'amount': 70000,
      'date': DateTime(2024, 11, 16),
      'paymentMethod': 'Cash',
      'icon': Icons.local_grocery_store,
      'color': Colors.green,
    },
    {
      'title': 'Clothes',
      'amount': 100000,
      'date': DateTime(2024, 11, 17),
      'paymentMethod': 'Credit Card',
      'icon': Icons.shopping_bag,
      'color': Colors.blue,
    },
  ];

  LastRecordsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: records.map((record) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: LastRecordsItem(
            title: record['title'],
            amount: record['amount'],
            date: record['date'],
            paymentMethod: record['paymentMethod'],
            icon: record['icon'],
            color: record['color'],
          ),
        );
      }).toList(),
    );
  }
}
