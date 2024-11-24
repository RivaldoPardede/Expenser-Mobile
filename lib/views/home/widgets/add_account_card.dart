import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddAccountCard extends StatelessWidget {
  const AddAccountCard({super.key});

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset('images/home/add_account.svg', height: 40, fit: BoxFit.contain),
          const SizedBox(height: 8),
          const Text(
            'Add account',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
