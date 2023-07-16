import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../db/transaction/transaction_db.dart';
import '../../model/category/category_model.dart';
import '../../model/transaction/transaction_model.dart';

class RecentTransaction extends StatefulWidget {
  const RecentTransaction({super.key});

  @override
  State<RecentTransaction> createState() => _RecentTransactionState();
}

class _RecentTransactionState extends State<RecentTransaction> {
  @override
  void initState() {
    super.initState();

    fetchRecentTransactions();
  }

  List<TransactionModel> recentTransactions = [];

  Future<void> fetchRecentTransactions() async {
    final transactions = await TransactionDB.instance.getAllTransactions();
    transactions.sort((a, b) => b.date.compareTo(a.date));
    setState(() {
      recentTransactions = transactions.take(5).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final currentDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());
    final double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(25.0),
          alignment: Alignment.bottomLeft,
          child: const Text(
            'Recent Transactions',
            style: TextStyle(
              color: Colors.teal,
              fontSize: 16,
            ),
          ),
        ),
        recentTransactions.isEmpty
            ? Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.25),
                child: Text(
                  'Transaction list is Empty',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: screenHeight * 0.016,
                  ),
                ),
              )
            : Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (ctx, index) {
                    final transaction = recentTransactions[index];
                    return Card(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaction.category.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                Text(
                                  transaction.description,
                                  style: TextStyle(
                                    fontSize: screenHeight * 0.012,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Rs ${transaction.amount}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenHeight * 0.016,
                                    color:
                                        transaction.type == CategoryType.income
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                Text(
                                  DateFormat.yMMMd().format(transaction.date),
                                  style: TextStyle(
                                    fontSize: screenHeight * 0.012,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (ctx, index) {
                    return SizedBox(height: screenHeight * 0.01);
                  },
                  itemCount: (recentTransactions.length >= 4
                      ? 4
                      : recentTransactions.length),
                ),
              ),
      ],
    );
  }
}
