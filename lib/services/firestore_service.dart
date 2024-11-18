import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveCurrencyCode(String userId, String currencyCode) async {
    try {
      await _firestore.collection('users').doc(userId).set({'currency_code': currencyCode,}, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save currency code: $e');
    }
  }

  Future<String?> getCurrencyCodeForUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final docSnapshot = await _firestore.collection('users').doc(user.uid).get();
        return docSnapshot.data()?['currency_code'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting currency code: $e');
      return null;
    }
  }

  Future<void> addAccount(String accountId, Map<String, dynamic> accountData) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final accountRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('accounts')
        .doc(accountId);

    await accountRef.set(accountData);
  }

}
