import 'package:final_project/styles/color.dart';
import 'package:final_project/views/common/modal_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddAccountType extends StatefulWidget {
  final String accountType;

  const AddAccountType({
    super.key,
    required this.accountType,
  });

  @override
  State<AddAccountType> createState() => _AddAccountTypeState();
}

class _AddAccountTypeState extends State<AddAccountType> {
  late String selectedPayment;
  final List<String> paymentMethods = [
    'Cash',
    'General',
    'Savings',
  ];

  final List<String> paymentIcons = [
    "images/home/cash.svg",
    "images/home/general.svg",
    "images/home/savings.svg",
  ];

  @override
  void initState() {
    super.initState();
    selectedPayment = widget.accountType;
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
              title: "Type",
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
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[800],
                            child: SvgPicture.asset(
                              paymentIcons[index],
                              width: 20,
                              height: 20,
                              fit: BoxFit.contain,
                            ),
                          ),
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
