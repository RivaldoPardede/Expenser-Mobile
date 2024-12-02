import 'package:flutter/material.dart';
import '../auth/signin_page.dart';// Pastikan import halaman signin_page

void showLogOut(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Center( // Membuat judul berada di tengah
          child: Text(
            'Logout',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        content: const Text(
          'The less Text People Have To Read Onscreen, The Better',
          textAlign: TextAlign.center, // Agar konten teks berada di tengah
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Menutup dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Menutup dialog
              // Gunakan Navigator.pushReplacement untuk mengganti halaman ke signin_page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SigninPage()), // Pastikan SigninPage terdaftar
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}
