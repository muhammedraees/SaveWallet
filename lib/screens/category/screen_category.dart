import 'package:flutter/material.dart';
import 'package:mm_helper/db/category/category_db.dart';
import 'package:mm_helper/screens/category/category_add_popup.dart';
import 'package:mm_helper/screens/category/expense_cat_lisr.dart';
import 'package:mm_helper/screens/category/income_cat_list.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({Key? key}) : super(key: key);

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    CategoryDb().refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showCategoryAddPopup(context);
          },
          child: const Icon(Icons.add)),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            tabs: const [
              Tab(text: 'Income'),
              Tab(text: 'Expense'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                IncomeCategoryList(),
                ExpenseCategoryList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
