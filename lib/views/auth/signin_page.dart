import 'package:final_project/views/settings/settings.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:final_project/providers/auth_provider.dart';
import 'package:final_project/styles/button.dart';
import 'package:final_project/styles/color.dart';
import 'package:final_project/views/auth/signup_page.dart';
import 'package:final_project/views/auth/widgets/auth_button.dart';
import 'package:final_project/views/auth/widgets/input_field.dart';
import 'package:final_project/views/common/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isFormValid = false;
  bool isLoading = false;
  final _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _loadStoredPassword();
  }

  void _validateForm() {
    setState(() {
      isFormValid = _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty && _isEmailValid();
    });
  }

  bool _isEmailValid() {
    String email = _emailController.text.trim();
    return email.isNotEmpty && email.contains('@') && email.contains('.');
  }

  Future<void> _loadStoredPassword() async {
    String? storedPassword = await _secureStorage.read(key: _emailController.text.trim());
    if (storedPassword != null) {
      _passwordController.text = storedPassword;
    }
  }

  Future<void> _storePassword(String email, String password) async {
    await _secureStorage.write(key: email, value: password);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const CustomHeader(
          headerText: 'Welcome Back!',
          detailText: 'Ready to take control of your finances?',
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 70.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InputField(hintText: 'Your Email', controller: _emailController),
                const SizedBox(height: 35),
                InputField(hintText: 'Your Password', controller: _passwordController, isPassword: true),
                const SizedBox(height: 40),
                Row(
                  children: <Widget>[
                    Expanded(child: SvgPicture.asset('images/Line.svg')),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Or Sign In With',
                        style: TextStyle(color: grey),
                      ),
                    ),
                    Expanded(child: SvgPicture.asset('images/Line.svg')),
                  ],
                ),
                const SizedBox(height: 40),
                AuthButton(
                  text: 'Continue With Google',
                  iconPath: 'images/Google.svg',
                  onPressed: () async {
                    await Provider.of<AuthProvider>(context, listen: false).signInWithGoogle(context);
                  },
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: buttonPrimary,
                      onPressed: isFormValid
                          ? () async {
                        setState(() {
                          isLoading = true;
                        });
                        await Provider.of<AuthProvider>(context, listen: false).signInWithEmailAndPassword(
                          context,
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );
                        await _storePassword(_emailController.text.trim(), _passwordController.text.trim());
                        setState(() {
                          isLoading = false;
                        });
                      }
                          : null,
                      child: isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.0,
                        ),
                      )
                          : const Text('Sign In'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don’t Have An Account Yet? ',
                        style: TextStyle(
                          color: Color(0xFF2E2E2E),
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const SignupPage()),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Color(0xFF2E2E2E),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
