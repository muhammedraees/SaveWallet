import 'package:flutter/material.dart';
import 'package:mm_helper/db/transaction/transaction_db.dart';

import '../../model/category/category_model.dart';

ValueNotifier<double> incomeNotifier = ValueNotifier(0);
ValueNotifier<double> expenseNotifier = ValueNotifier(0);
ValueNotifier<double> totalNotifier = ValueNotifier(0);

Future<void> balanceAmount() async {
  await TransactionDB.instance.getAllTransactions().then((value) {
    expenseNotifier.value = 0;
    incomeNotifier.value = 0;
    totalNotifier.value = 0;

    for (var item in value) {
      if (item.type == CategoryType.income) {
        incomeNotifier.value += item.amount;
      } else {
        expenseNotifier.value += item.amount;
      }
    }
    totalNotifier.value = incomeNotifier.value - expenseNotifier.value;
  });
}
