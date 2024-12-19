import 'dart:async';
import 'package:flutter/material.dart';
import 'package:final_project/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project/views/navigation/main_screen.dart';
import 'package:final_project/views/auth/country_selection_page.dart';
import 'package:final_project/views/setup/setup_cash_balance.dart';

class AuthProvider with ChangeNotifier {
  final Auth _auth = Auth();
  User? _user;
  User? get user => _user;

  String? _userEmail;
  String? get userEmail => _userEmail;

  String? _username;
  String? get username => _username;

  bool get isAuthenticated => _user != null;
  bool _isEmailVerified = false;
  bool get isEmailVerified => _isEmailVerified;

  Timer? _timer;

  AuthProvider() {
    _auth.authStateChanges.listen((user) async {
      _user = user;
      if (_user != null) {
        _userEmail = _user?.email;
        _isEmailVerified = await _auth.checkEmailVerified();
      }
      notifyListeners();
    });
  }

  Future<void> signUp(String email, String password) async {
    await _auth.signUpWithEmailAndPassword(email: email, password: password);
    _user = _auth.currentUser;
    _userEmail = _user?.email;
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      _showLoadingDialog(context); // Show loading spinner
      User? user = await _auth.signInWithEmailAndPassword(email, password);
      Navigator.pop(context); // Dismiss loading spinner
      if (user != null) {
        _user = user;
        _userEmail = user.email;
        bool userExists = await _auth.doesUserExist(user.uid);
        bool accountsExists = await _auth.doesAccountsExist(user.uid);

        _navigateUser(context, userExists: userExists, accountsExists: accountsExists);
      } else {
        _showSnackBar(context, "Incorrect email or password. Please check your email and password and try again.");
      }
    } catch (e) {
      Navigator.pop(context); // Ensure spinner is dismissed on error
      _handleSignInError(context, e);
    }
  }

  void startEmailVerificationCheck(Function onVerified) {
    if (_timer?.isActive == true) return; // Prevent multiple timers
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
      _showLoadingDialog(context); // Show loading spinner
      User? user = await _auth.signInWithGoogle();
      Navigator.pop(context); // Dismiss loading spinner
      if (user != null) {
        _user = user;
        _userEmail = user.email;
        bool userExists = await _auth.doesUserExist(user.uid);
        _navigateUser(context, userExists: userExists, accountsExists: userExists); // Assume accountsExist check is handled elsewhere
      } else {
        _showSnackBar(context, "Google Sign-In failed");
      }
    } catch (e) {
      Navigator.pop(context); // Ensure spinner is dismissed on error
      _handleSignInError(context, e);
    }
  }

  void _navigateUser(BuildContext context, {required bool userExists, required bool accountsExists}) {
    if (userExists && accountsExists) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else if (userExists) {
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
  }

  void _handleSignInError(BuildContext context, Object e) {
    String errorMessage = "An error occurred. Please try again later.";

    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'network-request-failed':
          errorMessage = "Network error occurred. Please check your connection.";
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
          errorMessage = e.message ?? e.code;
          break;
      }
    } else if (e is FormatException) {
      errorMessage = "The email address is badly formatted.";
    } else if (e is Exception) {
      errorMessage = e.toString();
    }

    _showSnackBar(context, errorMessage, isError: true);
  }

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
