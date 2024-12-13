import 'package:flutter/material.dart';

void deleteConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Are you sure?'),
        content: const Text('Do you really want to delete this record?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Menutup dialog
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Menutup dialog
              // Tambahkan logika untuk menghapus record di sini
              print('Record deleted');
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}
