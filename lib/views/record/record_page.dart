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
import 'package:final_project/views/record/change_location.dart';
import 'package:final_project/views/record/change_note.dart';
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
  String account = "", paymentType = "Cash";
  String category = "", payee = "", note = "", location = "";
  String? userCurrencyCode;
  bool isLoading = true;
  List<String> accountIds = [];

  void fetchAccountIds() async {
    try {
      List<String> ids = await _firestoreService.getAccountIds();
      if(ids.isNotEmpty) {
        setState(() {
          accountIds = ids;
          account = ids[0];
          fetchCurrencyCode(account);
        });
      } else {
        print("No accounts found.");
      }
    } catch (e) {
      print('Error fetching account IDs: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void fetchCurrencyCode(String account) async {
    try {
      String? currencyCode = await _firestoreService.getCurrencyCodeFromAccount(account);
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

  Future<void> _saveRecord(BuildContext modalContext) async {
    int? amount = int.tryParse(amountController.text.replaceAll('-', '').replaceAll('+', ''));
    final recordData = {
      "transactionType" : transactionType,
      "amount" : amount,
      "account" : account,
      "category" : category,
      "date" : DateTime.now(),
      "paymentType" : paymentType,
      "payee" : payee,
      "location" : location,
      "note" : note,
    };

    if (recordData["amount"] == null) {
      ScaffoldMessenger.of(modalContext).showSnackBar(
        const SnackBar(content: Text("Record Amount must not be 0")),
      );
    } else if (recordData["category"] == null || recordData["category"] == "") {
      ScaffoldMessenger.of(modalContext).showSnackBar(
        const SnackBar(content: Text("Record Category must not be empty")),
      );
    } else if(recordData["paymentType"] == "") {
      ScaffoldMessenger.of(modalContext).showSnackBar(
        const SnackBar(content: Text("Record Payment Type must not be empty")),
      );
    } else if(recordData["Account"] == "") {
      ScaffoldMessenger.of(modalContext).showSnackBar(
        const SnackBar(content: Text("Record Account must not be empty")),
      );
    } else{
      try {
        await _firestoreService.addTransaction(recordData["account"].toString(), recordData);
        Navigator.pop(modalContext);

        ScaffoldMessenger.of(modalContext).showSnackBar(
          const SnackBar(content: Text("Record saved successfully"),
            behavior: SnackBarBehavior.floating,),
        );
      } catch (e) {
        print("Error saving record: $e");
      }
    }
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
    fetchAccountIds();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(29)),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
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
                    _saveRecord(context);
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
                isLoading
                  ? Row(
                    children: [
                      const SizedBox(height: 100, width: 18,),
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
                  : ModalInputAmount(
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
                              fetchCurrencyCode(account);
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
                        value: payee,
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
                        value: location,
                        needCircleAvatar: true,
                        onTap: () async {
                          final Location = await _showBottomModal(context, ChangeLocation(location: location,));
                          if (Location != null) {
                            setState(() {
                              location = Location;
                            });
                          }
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
                        value: note,
                        needCircleAvatar: true,
                        onTap: () async {
                          final notes = await _showBottomModal(context, ChangeNote(note: note,));
                          if (notes != null) {
                            setState(() {
                              note = notes;
                            });
                          }
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
        ),
      ),
    );
  }
}
