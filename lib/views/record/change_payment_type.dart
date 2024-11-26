import 'package:final_project/styles/color.dart';
import 'package:final_project/views/common/modal_header.dart';
import 'package:flutter/material.dart';

class ChangePaymentType extends StatefulWidget {

  final String paymentType;

  const ChangePaymentType({
    super.key,
    required this.paymentType,
  });

  @override
  State<ChangePaymentType> createState() => _ChangePaymentTypeState();
}

class _ChangePaymentTypeState extends State<ChangePaymentType> {
  late String selectedPayment;
  final List<String> paymentMethods = [
    'Cash',
    'Debit Card',
    'Voucher',
    'Mobile payment',
    'Web payment'
  ];

  @override
  void initState() {
    super.initState();
    selectedPayment = widget.paymentType;
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
              title: "Payment",
              cancelText: "Back",
              isleadingIcon: true,
              onCancel: () {
                Navigator.pop(context);
              },
            ),
            Divider(
              height: 3,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(9),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: paymentMethods.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      const SizedBox(height: 10,),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 100,),
                        decoration: BoxDecoration(
                          color: paymentMethods[index] == selectedPayment
                              ? Colors.blue.withOpacity(0.1)
                              : Colors.transparent,
                        ),
                        child: ListTile(
                          title: Text(paymentMethods[index]),
                          trailing: paymentMethods[index] == selectedPayment
                            ? Icon(Icons.check, color: blue,)
                            : null,
                          onTap: () {
                            setState(() {
                              selectedPayment = paymentMethods[index];
                            });
                            Navigator.pop(context, selectedPayment);
                          },
                        ),
                      ),
                      const SizedBox(height: 10,),
                      if(index < paymentMethods.length - 1)
                        Divider(
                          height: 3,
                          color: Colors.grey[300],
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
