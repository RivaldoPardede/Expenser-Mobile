import 'package:final_project/views/auth/signin_page.dart';
import 'package:final_project/views/settings/logout_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:final_project/providers/auth_provider.dart' as CustomAuthProvider;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
    _checkPasswordResetStatus();
  }

  Future<void> _sendPasswordResetEmail(BuildContext context, String email) async {
    final firebaseAuth = FirebaseAuth.instance;

    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('passwordReset', true);

      Fluttertoast.showToast(
        msg: "Password reset email sent successfully.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      String errorMessage = "Failed to send reset email.";
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-email':
            errorMessage = "Invalid email address.";
            break;
          case 'user-not-found':
            errorMessage = "No user found with this email.";
            break;
          default:
            errorMessage = e.message ?? "An unknown error occurred.";
        }
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _checkPasswordResetStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final passwordReset = prefs.getBool('passwordReset') ?? false;

    if (passwordReset) {
      await prefs.remove('passwordReset');

      try {
        await FirebaseAuth.instance.currentUser?.reload();
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SigninPage()),
          );

          Fluttertoast.showToast(
            msg: "Password changed successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Error checking password reset status",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  void _promptPasswordReset(BuildContext context) {
    final authProvider = Provider.of<CustomAuthProvider.AuthProvider>(context, listen: false);
    final emailController = TextEditingController(text: authProvider.userEmail ?? "");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset Password"),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: "Enter your email",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final email = emailController.text.trim();
              Navigator.pop(context);
              _sendPasswordResetEmail(context, email);
            },
            child: const Text("Reset"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isGoogleSignIn = user?.providerData.any((provider) => provider.providerId == 'google.com') ?? false;

    final photoUrl = isGoogleSignIn ? user?.photoURL : null;
    final displayName = isGoogleSignIn ? user?.displayName : null;

    final username = displayName ?? 'User';
    final userEmail = user?.email ?? 'Email not available';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: photoUrl != null ? 20 : 30,
                        backgroundImage: photoUrl != null
                            ? NetworkImage(photoUrl)
                            : const AssetImage('images/profile.png') as ImageProvider,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              userEmail,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: Column(
                  children: [
                    buildSettingsOption(
                      context,
                      icon: SvgPicture.asset(
                        'images/Shield Keyhole.svg',
                        width: 30,
                        height: 30,
                      ),
                      title: 'Reset Password',
                      onTap: () => _promptPasswordReset(context),
                    ),
                    const Divider(),
                    buildSettingsOption(
                      context,
                      icon: SvgPicture.asset(
                        'images/logout.svg',
                        width: 30,
                        height: 30,
                      ),
                      title: 'Logout',
                      onTap: () => showLogOutDialog(context),
                    ),
                  ],
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
        required Widget icon,
        required String title,
        VoidCallback? onTap,
      }) {
    return ListTile(
      leading: icon,
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
