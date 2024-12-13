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

  Future<List<String>> getAccountIds() async {
    List<String> accountIds = [];

    try {
      final user = _auth.currentUser;
      if(user != null) {
        final docSnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('accounts')
            .get();

        for(var doc in docSnapshot.docs) {
          accountIds.add(doc.id);
        }

        return accountIds;
      }
    } catch (e) {
      print('Error fetching account IDs: $e');
      return [];
    }

    return accountIds;
  }

  Future<String?> getCurrencyCodeFromAccount(String account) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final docSnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('accounts')
            .doc(account)
            .get();
        return docSnapshot.data()?['currency_code'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting currency code: $e');
      return null;
    }
  }

  Future<void> addTransaction(String accountId, Map<String, dynamic> recordData) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final recordRef = FirebaseFirestore.instance
        .collection('transactions');

    final accountRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('accounts')
        .doc(accountId);

    await recordRef.add({
      ...recordData,
      'accountReference': accountRef,
    });
  }

  Future<void> updateAccountBalance(String accountReference, double balanceChange) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final accountRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('accounts')
        .doc(accountReference);

    print('Updating account balance for reference: $accountReference');

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(accountRef);

      if (!snapshot.exists) {
        throw Exception("Account not found");
      }

      final data = snapshot.data() as Map<String, dynamic>;
      double currentBalance = (data['current_balance'] ?? 0.0) as double;
      double updatedBalance = currentBalance + balanceChange;

      transaction.update(accountRef, {'current_balance': updatedBalance});
    });
  }

  Future<String?> getCurrentUserId() async {
    final user = _auth.currentUser;
    return user?.uid;
  }

  Stream<List<Map<String, dynamic>>> getAccountsStream(String userId) {
    try {
      return _firestore
          .collection('users')
          .doc(userId)
          .collection('accounts')
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return doc.data();
        }).toList();
      });
    } catch (e) {
      throw Exception('Failed to fetch accounts: $e');
    }
  }

  Stream<Map<String, List<Map<String, dynamic>>>> getUserTransactionsGroupedByDate() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception("User not logged in");
    }

    return _firestore.collection('users').doc(userId).collection('accounts').snapshots().asyncExpand((accountsSnapshot) {
      final accountReferences = accountsSnapshot.docs.map((doc) => doc.reference).toList();
      if (accountReferences.isEmpty) {
        return Stream.value({}); // No accounts, return an empty map
      }

      return _firestore
          .collection('transactions')
          .where('accountReference', whereIn: accountReferences)
          .orderBy('date', descending: true)
          .snapshots()
          .map((querySnapshot) {
        final transactions = <String, List<Map<String, dynamic>>>{};

        for (var doc in querySnapshot.docs) {
          final data = doc.data();

          final timestamp = data['date'] as Timestamp;
          final date = timestamp.toDate();
          final dateString = "${date.year}-${date.month}-${date.day}";

          final transaction = {
            'category': data['category'],
            'paymentType': data['paymentType'],
            'transactionType': data['transactionType'],
            'date': date,
            'amount': data['amount'],
          };

          transactions[dateString] ??= [];
          transactions[dateString]!.add(transaction);
        }

        return transactions;
      });
    });
  }


}
  