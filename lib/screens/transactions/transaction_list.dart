import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../db/transaction/transaction_db.dart';
import '../../model/category/category_model.dart';
import 'edit_transaction.dart';

transactionList(BuildContext context, List<dynamic> filteredList) {
  return ListView.separated(
    padding: const EdgeInsets.all(10),
    itemBuilder: (ctx, index) {
      final value = filteredList[index];
      return Slidable(
        key: Key(value.id!),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (ctx) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Delete'),
                      content: const Text(
                          'Are you sure you want to delete this transaction ?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Delete'),
                          onPressed: () {
                            TransactionDB.instance.deleteTransaction(value.id!);

                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Transaction deleted'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icons.delete,
            ),
            SlidableAction(
              onPressed: (ctx) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScreenEditTransaction(model: value),
                  ),
                );
              },
              icon: Icons.edit,
            ),
          ],
        ),
        child: Card(
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
                      value.category.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      value.description,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rs ${value.amount}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: value.type == CategoryType.income
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      parseDate(value.date),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
    separatorBuilder: (ctx, index) {
      return const SizedBox(
        height: 10,
      );
    },
    itemCount: filteredList.length,
  );
}

String parseDate(DateTime date) {
  final date0 = DateFormat.MMMd().format(date);
  final splitedDate = date0.split(' ');
  return '${splitedDate.last} ${splitedDate.first}';
}
