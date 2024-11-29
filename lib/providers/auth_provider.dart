import 'dart:async';
import 'package:final_project/views/auth/country_selection_page.dart';
import 'package:final_project/views/navigation/main_screen.dart';
import 'package:final_project/views/setup/setup_cash_balance.dart';
import 'package:flutter/material.dart';
import 'package:final_project/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final Auth _auth = Auth();
  User? _user;
  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool _isEmailVerified = false;
  bool get isEmailVerified => _isEmailVerified;

  Timer? _timer;

  AuthProvider() {
    _auth.authStateChanges.listen((user) async {
      _user = user;
      if (_user != null) {
        _isEmailVerified = await _auth.checkEmailVerified();
      }
      notifyListeners();
    });
  }

  Future<void> signUp(String email, String password) async {
    await _auth.signUpWithEmailAndPassword(email: email, password: password);
    _user = _auth.currentUser;
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      User? user = await _auth.signInWithEmailAndPassword(email, password);
      if (user != null) {
        bool userExists = await _auth.doesUserExist(user.uid);
        bool accountsExists = await _auth.doesAccountsExist(user.uid);
        if (userExists && accountsExists) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else if (userExists && !accountsExists) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SetupCashBalance()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CountrySelectionPage()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Incorrect email or password. Please check your email and password and try again.")),
        );
      }
    } catch (e) {
      String errorMessage = "An error occurred. Please try again later.";

      // Handle specific exception cases based on type or message
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-email':
            errorMessage = "The email address is badly formatted.";
            break;
          case 'user-disabled':
            errorMessage = "This user account has been disabled.";
            break;
          case 'user-not-found':
            errorMessage = "No user found for that email address.";
            break;
          case 'wrong-password':
            errorMessage = "Incorrect password provided. Please try again.";
            break;
          case 'invalid-credential':
            errorMessage = "Incorrect email or password. Please check your email and password and try again.";
            break;
          default:
            errorMessage = e.code;
            break;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      } else if (e is FormatException) {
        errorMessage = "The email address is badly formatted.";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      } else if (e is Exception) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }


  void startEmailVerificationCheck(Function onVerified) {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await _auth.currentUser?.reload();
      _isEmailVerified = await _auth.checkEmailVerified();
      notifyListeners();
      if (_isEmailVerified) {
        timer.cancel();
        onVerified();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      User? user = await _auth.signInWithGoogle();
      if (user != null) {
        bool userExists = await _auth.doesUserExist(user.uid);
        if (userExists) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CountrySelectionPage()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Google Sign-In failed")),
        );
      }
    } catch (e) {
      print("Error during Google Sign-In: $e");
    }
  }

}
