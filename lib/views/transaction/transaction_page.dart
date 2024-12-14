import 'package:final_project/services/firestore_service.dart';
import 'package:final_project/styles/color.dart';
import 'package:final_project/views/common/custom_list_tile_divider.dart';
import 'package:final_project/views/transaction/widgets/delete_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:final_project/views/transaction/widgets/transaction_card.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Transaction History',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              deleteConfirmation(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<Map<String, List<Map<String, dynamic>>>>(
        stream: FirestoreService().getUserTransactionsGroupedByDate(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No transactions found."));
          }

          final transactions = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final date = transactions.keys.toList()[index];
              final dayTransactions = transactions[date]!;

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4, // Box shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: darkGrey,
                        ),
                      ),
                      const CustomListTileDivider(),
                      const SizedBox(height: 8),
                      ...dayTransactions.map((transaction) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TransactionCard(
                            title: transaction['category'] ?? 'Unknown',
                            amount: "\$${transaction['amount'].toString()}",
                            method: transaction['paymentType'] ?? 'Unknown',
                            date: transaction['date'].toLocal().toString().split(' ')[0],
                            type: transaction['transactionType'] == "Income"
                                ? TransactionType.income
                                : TransactionType.expense,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
