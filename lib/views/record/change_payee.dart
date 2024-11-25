import 'package:final_project/views/common/modal_header.dart';
import 'package:flutter/material.dart';

class ChangePayee extends StatefulWidget {

  final String payee;

  const ChangePayee({
    super.key,
    required this.payee
  });

  @override
  State<ChangePayee> createState() => _ChangePayeeState();
}

class _ChangePayeeState extends State<ChangePayee> {

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.payee.isNotEmpty) {
      _nameController.text = widget.payee;
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
              title: "Name",
              cancelText: "Back",
              isleadingIcon: true,
              onCancel: () {
                Navigator.pop(context, _nameController.text);
              },
            ),
            Divider(
              height: 3,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 20,),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Payee name",
                style: TextStyle(fontSize: 16,),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Enter payee name here...",
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
              maxLines: null, // Allows multi-line input
            ),
          ],
        ),
      ),
    );
  }
}
