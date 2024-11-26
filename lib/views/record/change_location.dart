import 'package:final_project/views/common/modal_header.dart';
import 'package:final_project/views/record/widgets/add_text_field.dart';
import 'package:flutter/material.dart';

class ChangeLocation extends StatefulWidget {

  final String location;

  const ChangeLocation({
    super.key,
    required this.location,
  });

  @override
  State<ChangeLocation> createState() => _ChangeLocationState();
}

class _ChangeLocationState extends State<ChangeLocation> {

  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.location.isNotEmpty) {
      _locationController.text = widget.location;
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
              title: "Location",
              cancelText: "Back",
              isleadingIcon: true,
              addText: "Save",
              onAdd: () {
                Navigator.pop(context, _locationController.text);
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
              titleText: "Add location",
              hintText: "Enter your location here...",
              controller: _locationController,
            ),
          ],
        ),
      ),
    );
  }
}
