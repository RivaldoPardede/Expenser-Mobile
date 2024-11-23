import 'package:final_project/services/firestore_service.dart';
import 'package:final_project/views/common/modal_header.dart';
import 'package:final_project/views/common/modal_input_amount.dart';
import 'package:final_project/views/common/modal_toggle_selector.dart';
import 'package:flutter/material.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String transactionType = "Expense";
  String account = "Cash";
  String? userCurrencyCode;
  late String category; // TODO: hapus
  final List<String> accounts = ["Cash", "Bank"]; //Todo: hapus
  final List<String> categories = ["Food", "Transport", "Utilities"]; //TODO: Hapus

  void fetchCurrencyCode() async {
    try {
      String? currencyCode = await _firestoreService.getCurrencyCodeForUser();
      if (currencyCode != null) {
        setState(() {
          userCurrencyCode = currencyCode;
        });
      } else {
        print("Currency code not found for the user.");
      }
    } catch (e) {
      print("Error fetching currency code: $e");
    }
  }

  void _saveRecord() {
    int? amount = int.tryParse(amountController.text.replaceAll('-', '').replaceAll('+', ''));
    print(amount);
  }

  @override
  void initState() {
    super.initState();
    fetchCurrencyCode();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center(
            //   child: Container(
            //     width: 40,
            //     height: 5,
            //     decoration: BoxDecoration(
            //       color: Colors.grey,
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 16),
            ModalHeader(
              title: "Add Record",
              onCancel: () {
                Navigator.pop(context);
              },
              onAdd: () {
                _saveRecord();
              },
            ),
            SizedBox(height: 69,),
            ModalToggleSelector(
              selectedOption: transactionType,
              options: ["Expense", "Income"],
              onOptionSelected: (value) {
                setState(() {
                  transactionType = value;
                  if (transactionType == "Expense") {
                    amountController.text = amountController.text.replaceAll("+", "-");
                  } else{
                    amountController.text = amountController.text.replaceAll("-", "+");
                  }
                });
              },
            ),
            SizedBox(height: 35,),
            ModalInputAmount(
              currencyCode: userCurrencyCode,
              transactionType: transactionType,
              amountController: amountController,
            ),
          ],
        ),
      ),
    );
  }
}
