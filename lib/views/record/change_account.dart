import 'package:final_project/services/firestore_service.dart';
import 'package:final_project/styles/color.dart';
import 'package:final_project/views/common/custom_list_tile.dart';
import 'package:final_project/views/common/custom_list_tile_divider.dart';
import 'package:final_project/views/common/modal_header.dart';
import 'package:flutter/material.dart';

class ChangeAccount extends StatefulWidget {
  const ChangeAccount({super.key});

  @override
  State<ChangeAccount> createState() => _ChangeAccountState();
}

class _ChangeAccountState extends State<ChangeAccount> {
  final FirestoreService _firestoreService = FirestoreService();

  bool isLoading = true;
  List<String> accountIds = [];

  @override
  void initState(){
    super.initState();
    fetchAccountIds();
  }

  Future<void> fetchAccountIds() async {
    try {
      List<String> ids = await _firestoreService.getAccountIds();
      setState(() {
        accountIds = ids;
      });
    } catch (e) {
      print('Error fetching account IDs: $e');
    } finally {
      setState(() {
        isLoading = false;
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
              title: "",
              cancelText: "Add Record",
              isleadingIcon: true,
              onCancel: () {
                Navigator.pop(context);
              },
            ),
            Divider(
              height: 3,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 35,),
            Container(
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(9)
              ),
              child: isLoading
                  ? Column(
                    children: [
                      const SizedBox(height: 28,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox.shrink(),
                          CircularProgressIndicator(color: blue,),
                        ],
                      ),
                      const SizedBox(height: 28,),
                    ],
                  )
                  : Column(
                      children: [
                        const SizedBox(height: 14,),
                        ...accountIds.asMap().entries.map((entry) {
                          final index = entry.key;
                          final id = entry.value;

                          return Column(
                            children: [
                              CustomListTile(
                                icon: Icon(
                                  Icons.account_balance_wallet,
                                  color: Colors.grey[600],
                                ),
                                title: id,
                                value: "",
                                valueWidth: 0,
                                needCircleAvatar: true,
                                onTap: () {
                                  Navigator.pop(context, id);
                                },
                              ),
                              if (index != accountIds.length - 1)
                                const CustomListTileDivider(),
                            ],
                          );
                        }).toList(),
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
