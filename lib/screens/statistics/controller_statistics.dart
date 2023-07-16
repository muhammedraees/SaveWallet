import 'package:flutter/material.dart';
import 'package:mm_helper/screens/statistics/both_statisctics.dart';
import 'expense_statistics.dart';
import 'income_statistics.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});
  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Statistics',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inder',
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 55,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30.0)),
                child: TabBar(
                    indicator: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(30.0)),
                    labelColor: Colors.white,
                    overlayColor:
                        const MaterialStatePropertyAll(Colors.transparent),
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(text: 'All'),
                      Tab(text: 'Income'),
                      Tab(
                        text: 'Expense',
                      )
                    ]),
              ),
            ),
            const Expanded(
                child: TabBarView(children: [
              BothStatistics(),
              IncomeStatistics(),
              ExpenseStatistics()
            ]))
          ],
        ),
      ),
    );
  }
}
