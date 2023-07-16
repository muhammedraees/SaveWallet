import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../db/transaction/transaction_db.dart';
import '../../model/category/category_model.dart';

class Amounts {
  Amounts._internal();
  static Amounts instance = Amounts._internal();

  factory Amounts() {
    return instance;
  }

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
}

class BothStatistics extends StatefulWidget {
  const BothStatistics({Key? key}) : super(key: key);

  @override
  State<BothStatistics> createState() => _BothStatisticsState();
}

class _BothStatisticsState extends State<BothStatistics> {
  String selectedFilter = 'all';

  Map<String, double> dataMap = {
    "Income": 0,
    "Expense": 0,
  };

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await Amounts.instance.balanceAmount();

    setState(() {
      dataMap = {
        "Income": Amounts.instance.incomeNotifier.value,
        "Expense": Amounts.instance.expenseNotifier.value,
      };
    });
  }

  void applyFilter(String? filter) async {
    if (filter != null) {
      setState(() {
        selectedFilter = filter;
      });

      if (filter == 'all') {
        loadData();
      } else {
        await TransactionDB.instance.getAllTransactions().then((value) {
          double filteredIncome = 0;
          double filteredExpense = 0;

          final currentDate = DateTime.now();

          for (var item in value) {
            if (filter == 'Today') {
              if (item.date.year == currentDate.year &&
                  item.date.month == currentDate.month &&
                  item.date.day == currentDate.day) {
                if (item.type == CategoryType.income) {
                  filteredIncome += item.amount;
                } else {
                  filteredExpense += item.amount;
                }
              }
            } else if (filter == 'Week') {
              final now = DateTime.now();
              final lastWeek = now.subtract(const Duration(days: 7));

              if (item.date.isAfter(lastWeek) && item.date.isBefore(now)) {
                if (item.type == CategoryType.income) {
                  filteredIncome += item.amount;
                } else {
                  filteredExpense += item.amount;
                }
              }
            } else if (filter == 'Month') {
              if (item.date.year == currentDate.year &&
                  item.date.month == currentDate.month) {
                if (item.type == CategoryType.income) {
                  filteredIncome += item.amount;
                } else {
                  filteredExpense += item.amount;
                }
              }
            }
          }

          setState(() {
            dataMap = {
              "Income": filteredIncome,
              "Expense": filteredExpense,
            };
          });
        }).catchError((error) {
          log('Error applying filter: $error');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 90,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(80),
                border: Border.all(width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: DropdownButton<String>(
                  underline: const SizedBox(),
                  onChanged: applyFilter,
                  value: selectedFilter,
                  items: const [
                    DropdownMenuItem(
                      value: 'all',
                      child: Text('All'),
                    ),
                    DropdownMenuItem(
                      value: 'Today',
                      child: Text('Today'),
                    ),
                    DropdownMenuItem(
                      value: 'Week',
                      child: Text('Week'),
                    ),
                    DropdownMenuItem(
                      value: 'Month',
                      child: Text('Month'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Total Balance: ${Amounts.instance.totalNotifier.value}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SizedBox(
                height: 500,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: PieChart(
                    dataMap: dataMap,
                    animationDuration: const Duration(milliseconds: 800),
                    chartLegendSpacing: 32,
                    colorList: const [
                      Color.fromARGB(255, 140, 229, 143),
                      Color.fromARGB(255, 228, 104, 95),
                    ],
                    chartRadius: MediaQuery.of(context).size.width / 1.5,
                    initialAngleInDegree: 0,
                    chartType: ChartType.disc,
                    ringStrokeWidth: 32,
                    centerText: '',
                    legendOptions: const LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.bottom,
                      showLegends: true,
                      legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
