import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mm_helper/model/transaction/transaction_model.dart';

const transactionDbName = 'transaction-db';

abstract class TransactionDbFunctions {
  Future<void> addTransaction(TransactionModel obj);
  Future<List<TransactionModel>> getAllTransactions();
  Future<void> deleteTransaction(String id);
}

class TransactionDB implements TransactionDbFunctions {
  TransactionDB._internal();

  static TransactionDB instance = TransactionDB._internal();

  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transationListNotifier =
      ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final db = await Hive.openBox<TransactionModel>(transactionDbName);
    await db.put(obj.id, obj);
    refresh();
  }

  Future<void> refresh() async {
    final list = await getAllTransactions();
    list.sort((first, second) => second.date.compareTo(first.date));
    transationListNotifier.value = list;
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await Hive.openBox<TransactionModel>(transactionDbName);
    final List<TransactionModel> transactions = db.values.toList();

    return transactions;
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final db = await Hive.openBox<TransactionModel>(transactionDbName);
    await db.delete(id);
    refresh();
  }

  Future<void> clearAllData() async {
    final db = await Hive.openBox<TransactionModel>(transactionDbName);
    await db.clear();
    await refresh();
  }

  Future<void> editTransaction(TransactionModel model) async {
    final db = await Hive.openBox<TransactionModel>(transactionDbName);
    await db.delete(model.id);
    await db.put(model.id, model);
    refresh();
    // recentRefresh();
  }

  getRecentTransactions() {}

  deleteAllCategories() {}
}
