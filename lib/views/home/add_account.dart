import 'package:final_project/services/firestore_service.dart';
import 'package:final_project/styles/color.dart';
import 'package:final_project/views/common/custom_list_tile.dart';
import 'package:final_project/views/common/custom_list_tile_divider.dart';
import 'package:final_project/views/common/modal_header.dart';
import 'package:final_project/views/home/add_account_name.dart';
import 'package:final_project/views/home/add_account_type.dart';
import 'package:final_project/views/home/add_balance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../common/modal_subheader.dart';

class AddAccount extends StatefulWidget {
  const AddAccount({super.key});

  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  final FirestoreService _firestoreService = FirestoreService();

  String accountName = "";
  double accountBalance = 0.00;
  String accountType = "Cash";
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

  Future<void> _saveAccount(BuildContext modalContext) async {
    try {
      List<String> accountNames = await _firestoreService.getAccountIds();

      if (accountNames.contains(accountName)) {
        ScaffoldMessenger.of(modalContext).showSnackBar(
          const SnackBar(
            content: Text("Account Name already exists"),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
    } catch (e) {
      print('Error fetching account IDs: $e');
      ScaffoldMessenger.of(modalContext).showSnackBar(
        const SnackBar(
          content: Text("Error checking account ID. Please try again."),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (accountName.isEmpty) {
      ScaffoldMessenger.of(modalContext).showSnackBar(
        const SnackBar(
          content: Text("Account Name must not be Empty"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (accountBalance < 0.00){
      ScaffoldMessenger.of(modalContext).showSnackBar(
        const SnackBar(
          content: Text("Account Balance must not be below 0.0"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      try {
        final accountData = {
          "account_name": accountName,
          "current_balance": accountBalance,
          "currency_code": userCurrencyCode,
          "type": accountType,
        };

        await _firestoreService.addAccount(accountData["account_name"].toString(), accountData);
        Navigator.pop(modalContext);

        ScaffoldMessenger.of(modalContext).showSnackBar(
          const SnackBar(content: Text("Account saved successfully"),
            behavior: SnackBarBehavior.floating,),
        );
      } catch (e) {
        print("Error saving account: $e");
      }
    }
  }

  Future<String?> _showBottomModal(BuildContext context, Widget destination) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
        minHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      builder: (context) => destination,
    );
  }

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
              title: "Add Account",
              cancelText: "Cancel",
              addText: "Add",
              isleadingIcon: false,
              onCancel: () {
                Navigator.pop(context);
              },
              onAdd: () {
                // Navigator.pop(context);
                _saveAccount(context);
              },
            ),
            const SizedBox(height: 35,),
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
                    icon: SvgPicture.asset(
                      'images/home/account_name.svg',
                      width: 25,
                      height: 25,
                      fit: BoxFit.contain,
                    ),
                    title: "Account Name",
                    value: accountName.isEmpty
                        ? "Required"
                        : accountName,
                    valueWidth: 125,
                    needCircleAvatar: true,
                    trailingIcon: Icons.chevron_right,
                    onTap: () async {
                      final name = await _showBottomModal(context, AddAccountName(name: accountName));
                      if(name != null) {
                        setState(() {
                          accountName = name;
                        });
                      }
                    },
                  ),
                  const CustomListTileDivider(),
                  CustomListTile(
                    icon: SvgPicture.asset(
                      'images/home/current_balance.svg',
                      width: 25,
                      height: 25,
                      fit: BoxFit.contain,
                    ),
                    title: "Current Balance",
                    value: NumberFormat.decimalPattern().format(accountBalance).toString(),
                    valueWidth: 125,
                    needCircleAvatar: true,
                    trailingIcon: Icons.chevron_right,
                    onTap: () async{
                      final balance = await _showBottomModal(context, AddBalance(balance: accountBalance,));
                      if (balance != null) {
                        accountBalance = double.tryParse(balance)!;
                      }
                    },
                  ),
                  const CustomListTileDivider(),
                  CustomListTile(
                    icon: SvgPicture.asset(
                      'images/home/currency.svg',
                      width: 25,
                      height: 25,
                      fit: BoxFit.contain,
                    ),
                    title: "Currency",
                    value: userCurrencyCode ?? "",
                    valueWidth: 150,
                    needCircleAvatar: true,
                    onTap: () {},
                  ),
                  const CustomListTileDivider(),
                  CustomListTile(
                    icon: SvgPicture.asset(
                      'images/home/type.svg',
                      width: 25,
                      height: 25,
                      fit: BoxFit.contain,
                    ),
                    title: "Type",
                    value: accountType,
                    valueWidth: 165,
                    needCircleAvatar: true,
                    trailingIcon: Icons.chevron_right,
                    onTap: () async {
                      final selectedType = await _showBottomModal(context, AddAccountType(accountType: accountType,));
                      if(selectedType != null) {
                        setState(() {
                          accountType = selectedType;
                        });
                      }
                    },
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
