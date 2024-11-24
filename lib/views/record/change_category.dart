import 'package:final_project/models/categories_model.dart';
import 'package:final_project/styles/color.dart';
import 'package:final_project/views/common/custom_list_tile.dart';
import 'package:final_project/views/common/custom_list_tile_divider.dart';
import 'package:final_project/views/common/modal_header.dart';
import 'package:final_project/views/common/modal_subheader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChangeCategory extends StatefulWidget {
  const ChangeCategory({super.key});

  @override
  State<ChangeCategory> createState() => _ChangeCategoryState();
}

class _ChangeCategoryState extends State<ChangeCategory> {
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
              title: "Categories",
              cancelText: "Back",
              isleadingIcon: true,
              onCancel: () {
                Navigator.pop(context);
              },
            ),
            Divider(
              height: 3,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 20,),
            const ModalSubheader(text: "ALL CATEGORIES"),
            const SizedBox(height: 15,),
            Container(
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(9)
              ),
              child: Column(
                children: [
                  const SizedBox(height: 14,),
                  for(var entry in categoriesData.entries) ...[
                    CustomListTile(
                      icon: SvgPicture.asset(
                        entry.value,
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                      title: entry.key,
                      value: "",
                      needCircleAvatar: false,
                      onTap: () {
                        Navigator.pop(context, entry.key);
                      },
                    ),
                    if(entry.key !=  "Others")
                      const CustomListTileDivider(),
                  ],
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
