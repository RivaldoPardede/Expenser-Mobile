import 'package:final_project/models/categories_model.dart';
import 'package:final_project/services/firestore_service.dart';
import 'package:final_project/styles/color.dart';
import 'package:final_project/views/common/custom_list_tile_divider.dart';
import 'package:final_project/views/common/modal_header.dart';
import 'package:final_project/views/common/modal_input_amount.dart';
import 'package:final_project/views/common/modal_subheader.dart';
import 'package:final_project/views/common/modal_toggle_selector.dart';
import 'package:final_project/views/common/custom_list_tile.dart';
import 'package:final_project/views/record/change_account.dart';
import 'package:final_project/views/record/change_category.dart';
import 'package:final_project/views/record/change_payee.dart';
import 'package:final_project/views/record/change_payment_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

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
  String category = "";
  String paymentType = "Cash";
  String payee = "";
  String? userCurrencyCode;

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
    final accountData = {
      "amount" : amount,
      "transactionType" : transactionType,
      "account" : account,
      "category" : category,
      "date" : DateTime.now(),
    };
    print(accountData); // TODO: logic firestore
  }

  String getFormattedTime() {
    DateTime now = DateTime.now(); // Mendapatkan waktu saat ini
    String formattedTime = DateFormat('HH.mm').format(now); // Format waktu
    formattedTime = "Today " + formattedTime;
    return formattedTime;
  }

  Future<String?> _showBottomModal(BuildContext context, Widget destination) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.95,
        minHeight: MediaQuery.of(context).size.height * 0.95,
      ),
      builder: (context) => destination,
    );
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
            ModalHeader(
              title: "Add Record",
              cancelText: "Cancel",
              addText: "Add",
              isleadingIcon: false,
              onCancel: () {
                Navigator.pop(context);
              },
              onAdd: () {
                _saveRecord();
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 40,),
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
            ModalInputAmount(
              currencyCode: userCurrencyCode,
              transactionType: transactionType,
              amountController: amountController,
            ),
            const SizedBox(height: 20,),
            const ModalSubheader(text: 'GENERAL'),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(9)
              ),
              child: Column(
                children: [
                  const SizedBox(height: 14,),
                  CustomListTile(
                    icon: Icon(
                      Icons.account_balance_wallet,
                      color: Colors.grey[600],
                    ),
                    title: 'Account',
                    value: account,
                    needCircleAvatar: true,
                    onTap: () async{
                      final selectedAccount = await _showBottomModal(context, const ChangeAccount());
                      if (selectedAccount != null) {
                        setState(() {
                          account = selectedAccount;
                        });
                      }
                    },
                    trailingIcon: Icons.chevron_right,
                  ),
                  const CustomListTileDivider(),
                  CustomListTile(
                    icon: category.isEmpty
                        ? Icon(
                            Icons.category,
                            color: Colors.grey[600],
                        )
                        : SvgPicture.asset(
                            categoriesData[category]!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                        ),
                    title: 'Category',
                    value: category.isEmpty ? 'Required' : category,
                    needCircleAvatar: category.isEmpty ? true : false,
                    onTap: () async {
                      final selectedCategory = await _showBottomModal(context, const ChangeCategory());
                      if (selectedCategory != null) {
                        setState(() {
                          category = selectedCategory;
                        });
                      }
                    },
                    trailingIcon: Icons.chevron_right,
                  ),
                  const CustomListTileDivider(),
                  CustomListTile(
                    icon: Icon(
                      Icons.calendar_month,
                      color: Colors.grey[600],
                    ),
                    title: 'Date',
                    value: getFormattedTime(),
                    needCircleAvatar: true,
                    onTap: () {},
                  ),
                  const SizedBox(height: 14,),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            const ModalSubheader(text: "MORE DETAIL"),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9)
              ),
              child: Column(
                children: [
                  const SizedBox(height: 14,),
                  CustomListTile(
                    icon: SvgPicture.asset(
                      "images/modal/payment_type.svg",
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                    ),
                    title: 'Payment Type',
                    value: paymentType,
                    needCircleAvatar: true,
                    onTap: () async {
                      final selectedPayment = await _showBottomModal(context, ChangePaymentType(paymentType: paymentType,));
                      if(selectedPayment != null) {
                        setState(() {
                          paymentType = selectedPayment;
                        });
                      }
                    },
                    trailingIcon: Icons.chevron_right,
                  ),
                  const CustomListTileDivider(),
                  CustomListTile(
                    icon: Icon(
                      Icons.person,
                      color: Colors.grey[600],
                    ),
                    title: 'Payee',
                    value: payee.length > 18 ? "${payee.substring(0, 18)}..." : payee,
                    needCircleAvatar: true,
                    onTap: () async {
                      final payeeName = await _showBottomModal(context, ChangePayee(payee: payee,));
                      if(payeeName != null) {
                        setState(() {
                          payee = payeeName;
                        });
                      }
                    },
                    trailingIcon: Icons.chevron_right,
                  ),
                  const CustomListTileDivider(),
                  CustomListTile(
                    icon: Icon(
                      Icons.location_on,
                      color: Colors.grey[600],
                    ),
                    title: 'Add Location',
                    value: "",
                    needCircleAvatar: true,
                    onTap: () {

                    },
                    trailingIcon: Icons.chevron_right,
                  ),
                  const CustomListTileDivider(),
                  CustomListTile(
                    icon: SvgPicture.asset(
                      "images/modal/note.svg",
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                    ),
                    title: 'Note',
                    value: '',
                    needCircleAvatar: true,
                    onTap: () {
                      // Open Labels Modal
                    },
                    trailingIcon: Icons.chevron_right,
                  ),
                  const SizedBox(height: 14,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
