import 'package:flutter/material.dart';
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
              Row(
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'dheataniassalsabila@gmail.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Edit Profile'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Settings Title
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Settings Options
              buildSettingsOption(
                context,
                icon: Icons.notifications,
                title: 'Notification',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                ),
              ),
              const Divider(),
              buildSettingsOption(
                context,
                icon: Icons.language,
                title: 'Language',
                onTap: () {
                  // Tampilkan dialog pemilihan bahasa
                  LanguageDialog.showLanguageSelection(context);
                },
              ),
              const Divider(),
              buildSettingsOption(
                context,
                icon: Icons.record_voice_over,
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
                icon: Icons.security,
                title: 'Security & Password',
              ),
              const Divider(),
              buildSettingsOption(
                context,
                icon: Icons.logout,
                title: 'Logout',
                iconColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSettingsOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing,
    Color iconColor = Colors.blue,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
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