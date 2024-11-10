import 'package:final_project/styles/button.dart';
import 'package:final_project/styles/color.dart';
import 'package:final_project/views/auth/country_selection_page.dart';
import 'package:final_project/views/auth/signin_page.dart';
import 'package:final_project/views/auth/widgets/auth_button.dart';
import 'package:final_project/views/auth/widgets/input_field.dart';
import 'package:final_project/views/common/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController = TextEditingController();
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _retypePasswordController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      isFormValid = _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _retypePasswordController.text.isNotEmpty &&
        _passwordController.text == _retypePasswordController.text;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _retypePasswordController.dispose();
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
          headerText: 'Welcome!',
          detailText: 'Start managing your finances with ease.',
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
                const SizedBox(height: 35),
                InputField(hintText: 'Re-type New Password', controller: _retypePasswordController, isPassword: true),
                const SizedBox(height: 40),
                Row(
                  children: <Widget>[
                    Expanded(child: SvgPicture.asset('images/Line.svg')),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Or Sign Up With',
                        style: TextStyle(color: grey),
                      ),
                    ),
                    Expanded(child: SvgPicture.asset('images/Line.svg')),
                  ],
                ),
                const SizedBox(height: 40),
                AuthButton(text: 'Continue With Google', iconPath: 'images/Google.svg', onPressed: () => {}),
                const SizedBox(height: 60),

              ],
            ),
          ),
          Expanded(
            child: Align(
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
                          ? () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const CountrySelectionPage()),
                          );
                        }
                        : null,
                        child: const Text('Sign Up'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: Color(0xFF2E2E2E),
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const SigninPage()),
                            );
                          },
                          child: const Text(
                            'Sign In',
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
          ),
        ],
      ),
    );
  }

}
