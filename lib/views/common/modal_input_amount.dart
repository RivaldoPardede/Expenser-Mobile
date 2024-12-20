import 'package:final_project/styles/color.dart';
import 'package:flutter/material.dart';

class ModalInputAmount extends StatelessWidget {
  final String? currencyCode;
  final String transactionType;
  final TextEditingController amountController;

  const ModalInputAmount({
    super.key,
    required this.currencyCode,
    required this.transactionType,
    required this.amountController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 15,),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
            decoration: BoxDecoration(
              color: blackPrimary,
              borderRadius: BorderRadius.circular(56),
            ),
            child: Text(
              currencyCode ?? "",
              style: TextStyle(
                color: white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              showCursor: false,
              controller: amountController,
              textAlign: TextAlign.end,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if(value.isEmpty || value == "-" || value == "+"){
                  amountController.text = "";
                  amountController.selection = TextSelection.fromPosition(
                    TextPosition(offset: amountController.text.length),
                  );
                  return;
                }

                if(transactionType == "Expense" && !value.startsWith('-')) {
                  amountController.text = "-${value.replaceAll('+', '')}";
                  amountController.selection = TextSelection.fromPosition(
                    TextPosition(offset: amountController.text.length),
                  );
                } else if(transactionType == "Income" && !value.startsWith('+')){
                  amountController.text = "+${value.replaceAll('-', '')}";
                  amountController.selection = TextSelection.fromPosition(
                    TextPosition(offset: amountController.text.length),
                  );
                }
              },
              decoration: InputDecoration(
                hintText: (transactionType == "Expense") ? "-0" : "+0",
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 60,
                  color: blackPrimary,
                ),
              ),
              style: const TextStyle(
                fontSize: 60,
              ),
            ),
          ),
          const SizedBox(width: 10,),
        ],
    );
  }
}
