import 'package:flutter/material.dart';

class LanguageDialog {
  static void showLanguageSelection(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Language',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildLanguageOption(context, 'Russia', false),
                    _buildLanguageOption(context, 'Korea', false),
                    _buildLanguageOption(context, 'Indonesia', false),
                    _buildLanguageOption(context, 'English', true),
                    _buildLanguageOption(context, 'Indonesia', false),
                    _buildLanguageOption(context, 'Korea', false),
                    _buildLanguageOption(context, 'Russia', false),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildLanguageOption(
      BuildContext context, String language, bool isSelected) {
    return ListTile(
      title: Text(language),
      trailing: isSelected ? Icon(Icons.check, color: Colors.blue) : null,
      onTap: () {
        Navigator.pop(context); // Menutup dialog
        print('Selected: $language'); // Tambahkan logika untuk menyimpan pilihan
      },
    );
  }
}
