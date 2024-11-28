import 'package:final_project/views/common/modal_header.dart';
import 'package:flutter/material.dart';

class AddAccountName extends StatefulWidget {

  final String name;

  const AddAccountName({
    super.key,
    required this.name,
  });

  @override
  State<AddAccountName> createState() => _AddAccountNameState();
}

class _AddAccountNameState extends State<AddAccountName> {

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.name.isNotEmpty) {
      _nameController.text = widget.name;
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
              addText: "Save",
              onAdd: () {
                Navigator.pop(context, _nameController.text);
              },
              onCancel: () {
                Navigator.pop(context);
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
                "Account Name",
                style: TextStyle(fontSize: 16,),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Enter account name here...",
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
              maxLines: 1,
              maxLength: 25,
            ),
          ],
        ),
      ),
    );
  }
}
