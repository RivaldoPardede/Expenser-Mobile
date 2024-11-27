import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'language_dialog.dart'; // Pastikan file LanguageDialog sudah ada
import 'record_page.dart'; // Pastikan file RecordPage sudah ada

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyProfilePage(),
    );
  }
}

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Information
              Card(
                elevation: 4, // Tambahkan sedikit elevation untuk efek bayangan
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            'https://via.placeholder.com/150'), // Ganti dengan URL gambar
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Dhea Tania Salsabila',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'dheataniassalsabila@gmail.com',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(fontSize: 12, color: Colors.white), // Mengubah ukuran teks
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Mengubah warna tombol menjadi biru
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Mengatur ukuran tombol
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0), // Menambahkan sudut membulat
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Settings Title
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Card containing all Settings Options
              Card(
                elevation: 4, // Elevation for the whole settings options card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white, // Set the background color to white
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      buildSettingsOption(
                        context,
                        icon: SvgPicture.asset(
                          'images/notification.svg', // Ganti dengan path gambar Anda
                          width: 30,
                          height: 30,
                        ),
                        title: 'Notification',
                        trailing: Switch(
                          value: true,
                          activeColor: Colors.green,
                          onChanged: (value) {
                            print('Notification toggled: $value');
                          },
                        ),
                      ),
                      const Divider(),
                      buildSettingsOption(
                        context,
                        icon: SvgPicture.asset(
                          'images/language.svg', // Ganti dengan path gambar Anda
                          width: 30,
                          height: 30,
                        ),
                        title: 'Language',
                        onTap: () {
                          // Tampilkan dialog pemilihan bahasa
                          LanguageDialog.showLanguageSelection(context);
                        },
                      ),
                      const Divider(),
                      buildSettingsOption(
                        context,
                        icon: SvgPicture.asset(
                          'images/record.svg', // Ganti dengan path gambar Anda
                          width: 30,
                          height: 30,
                        ),
                        title: 'Record',
                        onTap: () {
                          // Navigasi ke halaman RecordPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RecordPage()),
                          );
                        },
                      ),
                      const Divider(),
                      buildSettingsOption(
                        context,
                        icon: SvgPicture.asset(
                          'images/Shield Keyhole.svg', // Ganti dengan path gambar Anda
                          width: 30,
                          height: 30,
                        ),
                        title: 'Security & Password',
                      ),
                      const Divider(),
                      buildSettingsOption(
                        context,
                        icon: SvgPicture.asset(
                          'images/logout.svg', // Ganti dengan path gambar Anda
                          width: 30,
                          height: 30,
                        ),
                        title: 'Logout',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSettingsOption(
      BuildContext context, {
        required Widget icon, // Ubah tipe menjadi Widget
        required String title,
        Widget? trailing,
        VoidCallback? onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Padding setiap item
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Mengubah alignment menjadi start (kiri)
          children: [
            icon,
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.left, // Menjadikan teks di kiri
              ),
            ),
            if (trailing != null) trailing,
            if (trailing == null)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }
}
