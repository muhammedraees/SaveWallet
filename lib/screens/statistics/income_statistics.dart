import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../db/transaction/transaction_db.dart';
import '../../model/category/category_model.dart';
import '../../model/transaction/transaction_model.dart';

class IncomeStatistics extends StatefulWidget {
  const IncomeStatistics({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _IncomeStatisticsState createState() => _IncomeStatisticsState();
}

class _IncomeStatisticsState extends State<IncomeStatistics> {
  String selectedFilter = 'all';

  double getFilteredTotal(List<TransactionModel> transactions) {
    double total = 0;
    for (var transaction in transactions) {
      total += transaction.amount;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Container(
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
                onChanged: (newValue) {
                  setState(() {
                    selectedFilter = newValue!;
                  });
                },
                value: selectedFilter,
                items: const [
                  DropdownMenuItem(
                    value: 'all',
                    child: Text('All'),
                  ),
                  DropdownMenuItem(
                    value: 'today',
                    child: Text('Today'),
                  ),
                  DropdownMenuItem(
                    value: 'week',
                    child: Text('Week'),
                  ),
                  DropdownMenuItem(
                    value: 'month',
                    child: Text('Month'),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ValueListenableBuilder<List<TransactionModel>>(
            valueListenable: TransactionDB.instance.transationListNotifier,
            builder: (BuildContext context, List<TransactionModel> newList, _) {
              List<TransactionModel> incomeTransactions = newList
                  .where((element) => element.type == CategoryType.income)
                  .toList();

              if (selectedFilter != 'all') {
                DateTime currentDate = DateTime.now();
                late DateTime startDate;
                if (selectedFilter == 'today') {
                  startDate = DateTime(
                      currentDate.year, currentDate.month, currentDate.day);
                } else if (selectedFilter == 'week') {
                  startDate = DateTime.now().subtract(const Duration(days: 7));
                } else if (selectedFilter == 'month') {
                  startDate = DateTime(currentDate.year, currentDate.month);
                }
                incomeTransactions = incomeTransactions
                    .where((element) =>
                        element.date.isAtSameMomentAs(startDate) ||
                        element.date.isAfter(startDate))
                    .toList();
              }

              Map<String, double> dataMap = {};

              for (var transaction in incomeTransactions) {
                String categoryName = transaction.category.name;
                if (dataMap.containsKey(categoryName)) {
                  dataMap[categoryName] =
                      dataMap[categoryName]! + transaction.amount;
                } else {
                  dataMap[categoryName] = transaction.amount;
                }
              }

              if (dataMap.isEmpty) {
                return const Center(
                    child: Text(
                  'Income statistics is Empty',
                  style: TextStyle(color: Colors.grey),
                ));
              }

              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Total Income: ${getFilteredTotal(incomeTransactions)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: PieChart(
                          dataMap: dataMap,
                          animationDuration: const Duration(milliseconds: 800),
                          chartLegendSpacing: 32,
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
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
