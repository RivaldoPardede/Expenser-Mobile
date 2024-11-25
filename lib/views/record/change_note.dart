import 'package:final_project/views/common/modal_header.dart';
import 'package:final_project/views/record/widgets/add_text_field.dart';
import 'package:flutter/material.dart';

class ChangeNote extends StatefulWidget {

  final String note;

  const ChangeNote({
    super.key,
    required this.note,
  });

  @override
  State<ChangeNote> createState() => _ChangeNoteState();
}

class _ChangeNoteState extends State<ChangeNote> {

  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.note.isNotEmpty) {
      _noteController.text = widget.note;
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
              title: "Note",
              cancelText: "Back",
              isleadingIcon: true,
              addText: "Save",
              onAdd: () {
                Navigator.pop(context, _noteController.text);
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
            AddTextField(
              titleText: "Add note",
              hintText: "Enter your note here...",
              controller: _noteController,
            ),
          ],
        ),
      ),
    );
  }
}
