import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password is too weak.');
      } else if (e.code =='email-already-in-use') {
        throw Exception('The email is already registered.');
      }
      throw Exception('An Error occurred during sign-up.');
    }
  }

  Future<bool> checkEmailVerified() async{
    await currentUser?.reload();
    return currentUser?.emailVerified ?? false;
  }
}