import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:final_project/providers/auth_provider.dart' as CustomAuthProvider;
import 'package:firebase_auth/firebase_auth.dart';

class SecurityPass extends StatelessWidget {
  const SecurityPass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SecurityPasswordScreen(),
    );
  }
}

class SecurityPasswordScreen extends StatefulWidget {
  const SecurityPasswordScreen({Key? key}) : super(key: key);

  @override
  _SecurityPasswordScreenState createState() => _SecurityPasswordScreenState();
}

class _SecurityPasswordScreenState extends State<SecurityPasswordScreen> {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<void> _sendPasswordResetEmail(BuildContext context, String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password reset email sent. Check your inbox."),
          backgroundColor: Colors.green,
        ),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Security & Password",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            'image/LeftArrow.svg',
            placeholderBuilder: (context) => const Icon(Icons.arrow_back),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                leading: SvgPicture.asset(
                  'image/key.svg',
                  placeholderBuilder: (context) => const Icon(Icons.vpn_key),
                ),
                title: const Text("Reset Password"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _promptPasswordReset(context),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
