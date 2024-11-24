import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TotalBalanceCard extends StatelessWidget {
  final String svgPath;
  final String accountName;
  final int totalBalance;

  const TotalBalanceCard({
    super.key,
    required this.svgPath,
    required this.accountName,
    required this.totalBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 150.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SvgPicture.asset(svgPath, height: 35, fit: BoxFit.contain),
          const SizedBox(height: 20),
          Text(
            accountName,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            'IDR ${totalBalance.toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (match) => '${match.group(1)},',
            )}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}