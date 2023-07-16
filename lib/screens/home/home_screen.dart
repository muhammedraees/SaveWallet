
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mm_helper/db/transaction/transaction_db.dart';
import 'package:mm_helper/model/category/category_model.dart';
import 'package:mm_helper/model/transaction/transaction_model.dart';
import 'package:mm_helper/screens/home/recent_transaction.dart';

import '../settings/settings_screen.dart';

enum DateFilter {
  todays,
  week,
  month,
  all,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double totalIncome = 0;
  double totalExpense = 0;
  double balance = 0;

  DateFilter selectedDateFilter = DateFilter.all;

  @override
  void initState() {
    super.initState();
    updateFinancialData();

  }

  Future<void> updateFinancialData() async {
    final transactions = await TransactionDB.instance.getAllTransactions();
    double income = 0;
    double expense = 0;

    for (final transaction in transactions) {
      if (_isTransactionInSelectedDateFilter(transaction)) {
        if (transaction.type == CategoryType.income) {
          income += transaction.amount;
        } else if (transaction.type == CategoryType.expense) {
          expense += transaction.amount;
        }
      }
    }

    setState(() {
      totalIncome = income;
      totalExpense = expense;
      balance = income - expense;
    });
  }

  bool _isTransactionInSelectedDateFilter(TransactionModel transaction) {
    final now = DateTime.now();
    final lastWeek = now.subtract(const Duration(days: 7));

    switch (selectedDateFilter) {
      case DateFilter.todays:
        return DateFormat('yyyy-MM-dd').format(transaction.date) ==
            DateFormat('yyyy-MM-dd').format(now);
      case DateFilter.week:
        return transaction.date.isAfter(lastWeek) &&
            transaction.date.isBefore(now);
      case DateFilter.month:
        return transaction.date.month == now.month &&
            transaction.date.year == now.year;
      case DateFilter.all:
        return true;
    }
  }



  @override
  Widget build(BuildContext context) {
    final currentDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(currentDate),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.menu),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
              color: Color.fromARGB(255, 240, 239, 239),
            ),
            height: screenHeight * 0.38,
            padding: EdgeInsets.only(
              left: screenWidth * 0.1,
              right: screenWidth * 0.1,
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02,
                    left: MediaQuery.of(context).size.width * 0.5,
                    bottom: MediaQuery.of(context).size.height * 0.035,
                  ),
                  child: DropdownButton<DateFilter>(
                    underline: const SizedBox(),
                    value: selectedDateFilter,
                    onChanged: (DateFilter? newValue) {
                      setState(() {
                        selectedDateFilter = newValue!;
                        updateFinancialData();
                      });
                    },
                    items: DateFilter.values.map<DropdownMenuItem<DateFilter>>(
                      (DateFilter value) {
                        String label;
                        switch (value) {
                          case DateFilter.todays:
                            label = 'Today';
                            break;
                          case DateFilter.week:
                            label = 'Week';
                            break;
                          case DateFilter.month:
                            label = 'Month';
                            break;
                          case DateFilter.all:
                            label = 'All';
                            break;
                        }
                        return DropdownMenuItem<DateFilter>(
                          value: value,
                          child: Text(label),
                        );
                      },
                    ).toList(),
                  ),
                ),
                const Text(
                  'Total Balance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  'Rs $balance',
                  style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    fontWeight: FontWeight.bold,
                    color: balance >= 0 ? Colors.green : Colors.red,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          child: Column(
                            children: [
                              const Text(
                                'Total Income',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                'Rs $totalIncome',
                                style: TextStyle(
                                  fontSize: screenHeight * 0.016,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.015),
                    Expanded(
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          child: Column(
                            children: [
                              const Text(
                                'Total Expense',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                'Rs $totalExpense',
                                style: TextStyle(
                                  fontSize: screenHeight * 0.016,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Expanded(flex: 1, child: RecentTransaction()),
        ],
      ),
    );
  }
}
