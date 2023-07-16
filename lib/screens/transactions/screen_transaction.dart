import 'package:flutter/material.dart';
import 'package:mm_helper/db/category/category_db.dart';
import 'package:mm_helper/db/transaction/transaction_db.dart';
import 'package:mm_helper/model/category/category_model.dart';
import 'package:mm_helper/model/transaction/transaction_model.dart';
import 'package:mm_helper/screens/add_transaction/screen_add_transaction.dart';
import 'package:mm_helper/screens/transactions/transaction_list.dart';

enum TransactionFilter {
  all,
  income,
  expense,
}

enum TimeFilter {
  today,
  thisWeek,
  thisMonth,
  all,
}

class ScreenTransation extends StatefulWidget {
  const ScreenTransation({Key? key}) : super(key: key);

  @override
  ScreenTransationState createState() => ScreenTransationState();
}

class ScreenTransationState extends State<ScreenTransation> {
  TransactionFilter _selectedFilter = TransactionFilter.all;
  TimeFilter _selectedTimeFilter = TimeFilter.all;

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
    CategoryDb.instance.refreshUI();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Transactions',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(ScreenAddTransaction.routaName);
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 112,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    border: Border.all(width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<TransactionFilter>(
                      underline: const SizedBox(),
                      value: _selectedFilter,
                      onChanged: (value) {
                        setState(() {
                          _selectedFilter = value!;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: TransactionFilter.all,
                          child: Text('All'),
                        ),
                        DropdownMenuItem(
                          value: TransactionFilter.income,
                          child: Text('Income'),
                        ),
                        DropdownMenuItem(
                          value: TransactionFilter.expense,
                          child: Text('Expense'),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    border: Border.all(width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<TimeFilter>(
                      underline: const SizedBox(),
                      value: _selectedTimeFilter,
                      onChanged: (value) {
                        setState(() {
                          _selectedTimeFilter = value!;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: TimeFilter.today,
                          child: Text('Today'),
                        ),
                        DropdownMenuItem(
                          value: TimeFilter.thisWeek,
                          child: Text('Week'),
                        ),
                        DropdownMenuItem(
                          value: TimeFilter.thisMonth,
                          child: Text('Month'),
                        ),
                        DropdownMenuItem(
                          value: TimeFilter.all,
                          child: Text('All'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<TransactionModel>>(
              valueListenable: TransactionDB.instance.transationListNotifier,
              builder:
                  (BuildContext context, List<TransactionModel> newlist, _) {
                List<TransactionModel> filteredList;

                if (_selectedFilter == TransactionFilter.all) {
                  filteredList = newlist;
                } else if (_selectedFilter == TransactionFilter.income) {
                  filteredList = newlist
                      .where((transaction) =>
                          transaction.type == CategoryType.income)
                      .toList();
                } else {
                  filteredList = newlist
                      .where((transaction) =>
                          transaction.type == CategoryType.expense)
                      .toList();
                }

                if (_selectedTimeFilter == TimeFilter.today) {
                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);
                  filteredList = filteredList
                      .where((transaction) =>
                          transaction.date.year == today.year &&
                          transaction.date.month == today.month &&
                          transaction.date.day == today.day)
                      .toList();
                } else if (_selectedTimeFilter == TimeFilter.thisWeek) {
                  final now = DateTime.now();
                  final lastWeek = now.subtract(const Duration(days: 7));

                  filteredList = filteredList
                      .where((transaction) =>
                          transaction.date.isAfter(lastWeek) &&
                          transaction.date.isBefore(now))
                      .toList();
                } else if (_selectedTimeFilter == TimeFilter.thisMonth) {
                  final now = DateTime.now();
                  final startOfMonth = DateTime(now.year, now.month, 1);
                  final endOfMonth = DateTime(now.year, now.month + 1, 0);
                  filteredList = filteredList
                      .where((transaction) =>
                          transaction.date.isAfter(startOfMonth) &&
                              transaction.date.isBefore(endOfMonth) ||
                          transaction.date.year == startOfMonth.year &&
                              transaction.date.month == startOfMonth.month &&
                              transaction.date.day == startOfMonth.day)
                      .toList();
                }

                if (filteredList.isEmpty) {
                  return const Center(
                    child: Text(
                      'Transaction list is Empty',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                return transactionList(context, filteredList);
              },
            ),
          ),
        ],
      ),
    );
  }
}
