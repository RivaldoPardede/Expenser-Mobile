import 'package:final_project/styles/color.dart';
import 'package:final_project/views/common/custom_list_tile.dart';
import 'package:final_project/views/common/custom_list_tile_divider.dart';
import 'package:final_project/views/common/modal_header.dart';
import 'package:final_project/views/home/add_account_name.dart';
import 'package:final_project/views/home/add_balance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../common/modal_subheader.dart';

class AddAccount extends StatefulWidget {
  const AddAccount({super.key});

  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  String accountName = "";
  double accountBalance = 0.00;

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
                Navigator.pop(context);
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
                    title: "Account name",
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
                    title: "Current balance",
                    value: accountBalance.toString(),
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
                    value: "IDR",
                    valueWidth: 150,
                    needCircleAvatar: true,
                    trailingIcon: Icons.chevron_right,
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
                    value: "Cash",
                    valueWidth: 165,
                    needCircleAvatar: true,
                    trailingIcon: Icons.chevron_right,
                    onTap: () {},
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
