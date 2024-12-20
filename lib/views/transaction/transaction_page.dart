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
  String? _currencyCode;
  bool _isLoadingCurrencyCode = true;

  @override
  void initState() {
    super.initState();
    _fetchCurrencyCode();
  }

  Future<void> _fetchCurrencyCode() async {
    try {
      final currencyCode = await FirestoreService().getCurrencyCodeForUser();
      if (mounted) {
        setState(() {
          _currencyCode = currencyCode ?? '';
          _isLoadingCurrencyCode = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoadingCurrencyCode = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch currency code: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingCurrencyCode) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete All Transactions?'),
                    content: const Text('This action cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );

              if (result == true) {
                await FirestoreService().deleteAllTransactions();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All transactions deleted.')),
                  );
                }
              }
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
                elevation: 4,
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
                        final transactionId = transaction['id'];
                        return GestureDetector(
                          onLongPress: () {
                            deleteConfirmation(context, transactionId);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TransactionCard(
                              title: transaction['category'] ?? 'Unknown',
                              amount: "${_currencyCode ?? ''} ${transaction['amount'].toString()}",
                              method: transaction['paymentType'] ?? 'Unknown',
                              date: transaction['date'].toLocal().toString().split(' ')[0],
                              type: transaction['transactionType'] == "Income"
                                  ? TransactionType.income
                                  : TransactionType.expense,
                            ),
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

