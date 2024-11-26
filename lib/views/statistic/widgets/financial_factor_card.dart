import 'package:final_project/styles/color.dart';
import 'package:flutter/material.dart';

Widget financialFactorCard() {
  final factors = [
    {"label": "Savings", "percentage": "30%", "status": "Overall good", "color": Colors.yellow},
    {"label": "Expenses", "percentage": "20%", "status": "Enough", "color": Colors.yellow},
    {"label": "Investments", "percentage": "35%", "status": "So Good", "color": Colors.blue},
    {"label": "Income", "percentage": "15%", "status": "Needs Attention", "color": Colors.red},
  ];

  return GridView.builder(
    padding: EdgeInsets.zero,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
    ),
    itemCount: factors.length,
    itemBuilder: (context, index) {
      final factor = factors[index];
      return Card(
        color: lightGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Container(
              width: 7,
              height: double.infinity,
              decoration: BoxDecoration(
                color: factor["color"] as Color,
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      factor["percentage"] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      factor["status"] as String,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C1C1C),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      factor["label"] as String,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}