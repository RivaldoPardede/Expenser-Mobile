import 'package:final_project/services/firestore_service.dart';
import 'package:final_project/styles/color.dart';
import 'package:final_project/views/common/modal_header.dart';
import 'package:flutter/material.dart';

class AddBalance extends StatefulWidget {
  final double balance;

  const AddBalance({
    super.key,
    required this.balance,
  });

  @override
  State<AddBalance> createState() => _AddBalanceState();
}

class _AddBalanceState extends State<AddBalance> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController balanceController = TextEditingController();

  String? userCurrencyCode;
  bool isLoading = true;

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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCurrencyCode();
    if(widget.balance != 0.00) {
      setState(() {
        balanceController.text = widget.balance.toString();
      });
    }
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
            ModalHeader(
              title: "Balance",
              cancelText: "Back",
              isleadingIcon: true,
              addText: "Save",
              onAdd: () {
                if(balanceController.text.isNotEmpty){
                  Navigator.pop(context, balanceController.text);
                } else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Balance Amount must not be 0"),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              onCancel: () {
                Navigator.pop(context);
              },
            ),
            Divider(
              height: 3,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 35,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 15,),
                isLoading
                ? Row(
                    children: [
                      const SizedBox(height: 100, width: 0,),
                      Container(
                        height: 35,
                        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 25),
                        decoration: BoxDecoration(
                          color: blackPrimary,
                          borderRadius: BorderRadius.circular(56),
                        ),
                        child: SizedBox(
                          width: 22,
                          height: 30,
                          child: CircularProgressIndicator(color: blue,),
                        ),
                      ),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                    decoration: BoxDecoration(
                      color: blackPrimary,
                      borderRadius: BorderRadius.circular(56),
                    ),
                    child: Text(
                      userCurrencyCode ?? "",
                      style: TextStyle(
                        color: white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Expanded(
                  child: TextFormField(
                    showCursor: false,
                    controller: balanceController,
                    textAlign: TextAlign.end,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if(value.isEmpty){
                        balanceController.text = "";
                        balanceController.selection = TextSelection.fromPosition(
                          TextPosition(offset: balanceController.text.length),
                        );
                        return;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "0", // Placeholder text
                      border: InputBorder.none, // No border
                      hintStyle: TextStyle(
                        fontSize: 60, // Size of hint text
                        color: blackPrimary,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 60, // Larger font for the entered text
                    ),
                  ),
                ),
                const SizedBox(width: 15,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
