import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message,
      );
    }
  }

  Future<bool> checkEmailVerified() async{
    await currentUser?.reload();
    return currentUser?.emailVerified ?? false;
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("Google Sign-In aborted by user.");
        return null;
      }

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      print(userCredential.user?.displayName);
      return userCredential.user;
    } catch (e) {
      print("Error during Google Sign-In: $e");
      return null;
    }
  }

  Future<bool> doesUserExist(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      return userDoc.exists;
    } catch (e) {
      print("Error checking user existence: $e");
      return false;
    }
  }
}