import 'package:final_project/views/common/modal_header.dart';
import 'package:flutter/material.dart';

class ChangeAccount extends StatefulWidget {
  const ChangeAccount({super.key});

  @override
  State<ChangeAccount> createState() => _ChangeAccountState();
}

class _ChangeAccountState extends State<ChangeAccount> {
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
            SizedBox(height: 35,)
          ],
        ),
      ),
    );
  }
}
