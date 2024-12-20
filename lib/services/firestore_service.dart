import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveCurrencyCode(String userId, String currencyCode) async {
    try {
      await _firestore.collection('users').doc(userId).set({'currency_code': currencyCode}, SetOptions(merge: true));
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
      if (kDebugMode) {
        print('Error getting currency code: $e');
      }
      return null;
    }
  }

  Future<void> addAccount(String accountId, Map<String, dynamic> accountData) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not logged in');

      final accountRef = _firestore.collection('users').doc(userId).collection('accounts').doc(accountId);
      await accountRef.set(accountData);
    } catch (e) {
      throw Exception('Failed to add account: $e');
    }
  }

  Future<List<String>> getAccountIds() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      final docSnapshot = await _firestore.collection('users').doc(user.uid).collection('accounts').get();
      return docSnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      debugPrint('Error fetching account IDs: $e');
      return [];
    }
  }

  Future<String?> getCurrencyCodeFromAccount(String account) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      final docSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('accounts')
          .doc(account)
          .get();
      return docSnapshot.data()?['currency_code'] as String?;
    } catch (e) {
      debugPrint('Error getting currency code: $e');
      return null;
    }
  }

  Future<void> addTransaction(String accountId, Map<String, dynamic> recordData) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not logged in');

      final recordRef = _firestore.collection('transactions');
      final accountRef = _firestore.collection('users').doc(userId).collection('accounts').doc(accountId);

      await recordRef.add({
        ...recordData,
        'accountReference': accountRef,
      });
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  Future<void> updateAccountBalance(String accountReference, double balanceChange) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not logged in');

      final accountRef = _firestore.collection('users').doc(userId).collection('accounts').doc(accountReference);

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(accountRef);

        if (!snapshot.exists) {
          throw Exception("Account not found");
        }

        final data = snapshot.data() as Map<String, dynamic>;
        final currentBalance = (data['current_balance'] ?? 0.0) as double;
        final updatedBalance = currentBalance + balanceChange;

        transaction.update(accountRef, {'current_balance': updatedBalance});
      });
    } catch (e) {
      throw Exception('Failed to update account balance: $e');
    }
  }

  Future<String?> getCurrentUserId() async => _auth.currentUser?.uid;

  Stream<List<Map<String, dynamic>>> getAccountsStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('accounts')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<Map<String, List<Map<String, dynamic>>>> getUserTransactionsGroupedByDate() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception("User not logged in");
    }

    return _firestore.collection('users').doc(userId).collection('accounts').snapshots().asyncExpand((accountsSnapshot) {
      final accountReferences = accountsSnapshot.docs.map((doc) => doc.reference).toList();
      if (accountReferences.isEmpty) {
        return Stream.value({});
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
            'id': doc.id,
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

  Stream<List<Map<String, dynamic>>> getTop3ExpensesThisMonthWithCurrency() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      throw Exception("User not logged in");
    }

    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('accounts')
        .snapshots()
        .asyncMap((accountsSnapshot) async {
      final accountCurrencyMap = <String, String>{};

      for (var doc in accountsSnapshot.docs) {
        accountCurrencyMap[doc.reference.id] = doc.data()['currency_code'];
      }

      final querySnapshot = await _firestore
          .collection('transactions')
          .where('accountReference', whereIn: accountsSnapshot.docs.map((e) => e.reference).toList())
          .where('transactionType', isEqualTo: 'Expense')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(currentYear, currentMonth, 1)))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(DateTime(currentYear, currentMonth + 1, 0)))
          .get();

      final Map<String, Map<String, dynamic>> groupedExpenses = {};

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final category = data['category'];
        final amount = data['amount'] ?? 0.0;
        final accountRefId = (data['accountReference'] as DocumentReference).id;

        if (!groupedExpenses.containsKey(category)) {
          groupedExpenses[category] = {
            'category': category,
            'amount': 0.0,
            'currency_code': accountCurrencyMap[accountRefId] ?? '',
          };
        }

        groupedExpenses[category]!['amount'] += amount;
      }

      final sortedExpenses = groupedExpenses.values.toList()
        ..sort((a, b) => (b['amount'] as double).compareTo(a['amount'] as double));

      return sortedExpenses.take(3).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getTop3TransactionsThisMonth() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      throw Exception("User not logged in");
    }

    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('accounts')
        .snapshots()
        .asyncMap((accountsSnapshot) async {
      final accountCurrencyMap = <String, String>{};

      for (var doc in accountsSnapshot.docs) {
        accountCurrencyMap[doc.reference.id] = doc.data()['currency_code'];
      }

      final querySnapshot = await _firestore
          .collection('transactions')
          .where('accountReference', whereIn: accountsSnapshot.docs.map((e) => e.reference).toList())
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(currentYear, currentMonth, 1)))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(DateTime(currentYear, currentMonth + 1, 0)))
          .get();

      final List<Map<String, dynamic>> recentTransactions = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final category = data['category'];
        final amount = data['amount'] ?? 0.0;
        final transactionType = data['transactionType'];
        final accountRefId = (data['accountReference'] as DocumentReference).id;

        recentTransactions.add({
          'category': category,
          'amount': amount,
          'transactionType': transactionType,
          'currency_code': accountCurrencyMap[accountRefId] ?? '',
          'date': (data['date'] as Timestamp).toDate(),
        });
      }

      recentTransactions.sort((a, b) => b['date'].compareTo(a['date']));
      return recentTransactions.take(3).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getDailyExpenses(String userId, int year, int month, int week) {
    final weekStart = DateTime(year, month, (week - 1) * 7 + 1);
    final weekEnd = DateTime(year, month, (week - 1) * 7 + 7, 23, 59, 59);

    if (kDebugMode) print("Local Week start: ${weekStart.toLocal()}, Week end: ${weekEnd.toLocal()}");

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('accounts')
        .snapshots()
        .asyncExpand((accountsSnapshot) {
      final accountRefs = accountsSnapshot.docs.map((doc) => doc.reference).toList();

      if (accountRefs.isEmpty) {
        return const Stream<List<Map<String, dynamic>>>.empty();
      }

      return _firestore
          .collection('transactions')
          .where('accountReference', whereIn: accountRefs)
          .where('transactionType', isEqualTo: 'Expense')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(weekStart))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(weekEnd))
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'date': (data['date'] as Timestamp).toDate().toLocal(),
            'amount': data['amount'] as double,
          };
        }).toList();
      });
    });
  }

  Stream<List<Map<String, dynamic>>> getWeeklyExpenses(String userId, int year, int month) {
    final monthStart = DateTime(year, month, 1);
    final monthEnd = DateTime(year, month + 1, 0);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('accounts')
        .snapshots()
        .asyncExpand((accountsSnapshot) {
      final accountRefs = accountsSnapshot.docs.map((doc) => doc.reference).toList();

      if (accountRefs.isEmpty) {
        return const Stream<List<Map<String, dynamic>>>.empty();
      }

      return _firestore
          .collection('transactions')
          .where('accountReference', whereIn: accountRefs)
          .where('transactionType', isEqualTo: 'Expense')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(monthStart))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(monthEnd))
          .snapshots()
          .map((querySnapshot) {
        final weeklyExpenses = <int, double>{};

        for (var doc in querySnapshot.docs) {
          final data = doc.data();
          final date = (data['date'] as Timestamp).toDate();
          final weekOfMonth = ((date.day - 1) ~/ 7) + 1;

          weeklyExpenses[weekOfMonth] = (weeklyExpenses[weekOfMonth] ?? 0) + (data['amount'] as double);
        }

        return weeklyExpenses.entries
            .map((entry) => {
          'week': entry.key,
          'amount': entry.value,
        }).toList();
      });
    });
  }

  Stream<List<Map<String, dynamic>>> getSavingsAccountsStream() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('accounts')
        .where('type', isEqualTo: 'Savings')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "id": doc.id,
          "current_balance": data['current_balance'] ?? 0.0,
          "type": data['type'] ?? '',
        };
      }).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getUserTransactionsStream(String userId) {
    return FirebaseFirestore.instance
        .collection('transactions')
        .where('accountReference', isEqualTo: FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('accounts')
        .doc('main'))
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      final transactionDoc = await _firestore.collection('transactions').doc(transactionId).get();

      if (!transactionDoc.exists) {
        throw Exception('Transaction not found');
      }

      final transactionData = transactionDoc.data()!;
      final accountReference = transactionData['accountReference'] as DocumentReference;
      final amount = transactionData['amount'] as double;
      final transactionType = transactionData['transactionType'] as String;

      await _firestore.collection('transactions').doc(transactionId).delete();

      await _firestore.runTransaction((transaction) async {
        final accountDoc = await transaction.get(accountReference);

        if (!accountDoc.exists) {
          throw Exception('Associated account not found');
        }

        final accountData = accountDoc.data() as Map<String, dynamic>;
        final currentBalance = accountData['current_balance'] as double? ?? 0.0;

        final balanceChange = transactionType == 'Expense' ? amount : -amount;
        final updatedBalance = currentBalance + balanceChange;

        transaction.update(accountReference, {'current_balance': updatedBalance});
      });

      if (kDebugMode) {
        print('Transaction deleted and account balance updated successfully');
      }
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }

  Future<void> deleteAllTransactions() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception("User not logged in");
    }

    final accountSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('accounts')
        .get();

    if (accountSnapshot.docs.isEmpty) {
      throw Exception("User has no accounts");
    }

    final accountReferences = accountSnapshot.docs.map((doc) => doc.reference).toList();

    final transactionsSnapshot = await _firestore
        .collection('transactions')
        .where('accountReference', whereIn: accountReferences)
        .get();

    if (transactionsSnapshot.docs.isEmpty) {
      throw Exception("No transactions found for the user");
    }

    WriteBatch batch = _firestore.batch();

    for (var transactionDoc in transactionsSnapshot.docs) {
      batch.delete(transactionDoc.reference);
    }

    await batch.commit();

    if (kDebugMode) {
      print("All transactions deleted successfully");
    }
  }
}
