import 'package:flutter/material.dart';
import 'record_popup.dart'; // Import fungsi dialog pop-up

class RecordPage extends StatelessWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Record'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDeleteConfirmation(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Today',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildRecordItem('Rent', '- IDR 500,000.00', 'Cash', '15 October 2024',
              Icons.arrow_upward),
          _buildRecordItem('Clothes & Shoes', '- IDR 70,000.00', 'Cash',
              '15 October 2024', Icons.arrow_upward),
          _buildRecordItem('Groceries', '- IDR 70,000.00', 'Cash',
              '15 October 2024', Icons.arrow_upward),
          const SizedBox(height: 16),
          const Text(
            'Yesterday',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildRecordItem('Income', '+ IDR 1,000,000.00', 'Cash',
              '14 October 2024', Icons.arrow_downward),
        ],
      ),
    );
  }

  Widget _buildRecordItem(String title, String amount, String method,
      String date, IconData icon) {
    return ListTile(
      leading: Icon(
        icon,
        color: icon == Icons.arrow_upward ? Colors.red : Colors.green,
      ),
      title: Text(title),
      subtitle: Text('$method\n$date'),
      trailing: Text(
        amount,
        style: TextStyle(
          color: icon == Icons.arrow_upward ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
