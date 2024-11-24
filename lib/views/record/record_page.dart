import 'package:final_project/services/firestore_service.dart';
import 'package:final_project/styles/color.dart';
import 'package:final_project/views/common/modal_header.dart';
import 'package:final_project/views/common/modal_input_amount.dart';
import 'package:final_project/views/common/modal_toggle_selector.dart';
import 'package:final_project/views/common/custom_list_tile.dart';
import 'package:final_project/views/record/change_account.dart';
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
  String account = "Cash"; // TODO:ganti jd firestore
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
    print(amount); // TODO: logic firestore
  }

  String getFormattedTime() {
    DateTime now = DateTime.now(); // Mendapatkan waktu saat ini
    String formattedTime = DateFormat('HH.mm').format(now); // Format waktu
    formattedTime = "Today " + formattedTime;
    return formattedTime;
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
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'GENERAL',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 15),
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
                    onTap: () async{
                      final selectedAccount = await showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled: true,
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.95,
                          minHeight: MediaQuery.of(context).size.height * 0.95,
                        ),
                        builder: (context) => const ChangeAccount(),
                      );
                      if (selectedAccount != null) {
                        setState(() {
                          account = selectedAccount;
                        });
                      }
                    },
                    trailingIcon: Icons.chevron_right,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Divider(
                      height: 3,
                      color: Color(0xffF5F5F5),
                    ),
                  ),
                  CustomListTile(
                    icon: Icon(
                      Icons.category,
                      color: Colors.grey[600],
                    ),
                    title: 'Category',
                    value: 'Required',
                    onTap: () {

                    },
                    trailingIcon: Icons.chevron_right,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Divider(
                      height: 3,
                      color: Color(0xffF5F5F5),
                    ),
                  ),
                  CustomListTile(
                    icon: Icon(
                      Icons.calendar_month,
                      color: Colors.grey[600],
                    ),
                    title: 'Date',
                    value: getFormattedTime(),
                    onTap: () {},
                  ),
                  const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Divider(
                      height: 3,
                      color: Color(0xffF5F5F5),
                    ),
                  ),
                  CustomListTile(
                    icon: SvgPicture.asset(
                      "images/modal/labels.svg",
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                    ),
                    title: 'Labels',
                    value: '',
                    onTap: () {
                      // Open Labels Modal
                    },
                    trailingIcon: Icons.add,
                  ),
                  const SizedBox(height: 14,),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'MORE DETAIL',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 15),
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
                    value: account,
                    onTap: () {

                    },
                    trailingIcon: Icons.chevron_right,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Divider(
                      height: 3,
                      color: Color(0xffF5F5F5),
                    ),
                  ),
                  CustomListTile(
                    icon: Icon(
                      Icons.person,
                      color: Colors.grey[600],
                    ),
                    title: 'Payee',
                    value: '',
                    onTap: () {

                    },
                    trailingIcon: Icons.chevron_right,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Divider(
                      height: 3,
                      color: Color(0xffF5F5F5),
                    ),
                  ),
                  CustomListTile(
                    icon: Icon(
                      Icons.location_on,
                      color: Colors.grey[600],
                    ),
                    title: 'Add Location',
                    value: "",
                    onTap: () {

                    },
                    trailingIcon: Icons.chevron_right,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Divider(
                      height: 3,
                      color: Color(0xffF5F5F5),
                    ),
                  ),
                  CustomListTile(
                    icon: Icon(
                      Icons.photo_camera,
                      color: Colors.grey[600],
                    ),
                    title: 'Attach photo',
                    value: '',
                    onTap: () {
                      // Open Labels Modal
                    },
                    trailingIcon: Icons.chevron_right,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Divider(
                      height: 3,
                      color: Color(0xffF5F5F5),
                    ),
                  ),
                  CustomListTile(
                    icon: SvgPicture.asset(
                      "images/modal/note.svg",
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                    ),
                    title: 'Note',
                    value: '',
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
