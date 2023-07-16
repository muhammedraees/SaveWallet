import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mm_helper/db/category/category_db.dart';
import 'package:mm_helper/db/transaction/transaction_db.dart';
import 'package:mm_helper/model/category/category_model.dart';
import 'package:mm_helper/model/transaction/transaction_model.dart';

import '../../db/transaction/balance.dart';

class ScreenEditTransaction extends StatefulWidget {
  const ScreenEditTransaction({Key? key, required this.model})
      : super(key: key);
  final TransactionModel model;

  @override
  State<ScreenEditTransaction> createState() => _ScreenEditTransactionState();
}

class _ScreenEditTransactionState extends State<ScreenEditTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategorytype;
  CategoryModel? _selectedCategoryModel;

  String? _categoryID;

  final _descriptionTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

  @override
  void initState() {
    _selectedCategorytype = widget.model.type;
    _descriptionTextEditingController.text = widget.model.description;
    _amountTextEditingController.text = widget.model.amount.toString();
    _selectedDate = widget.model.date;
    _selectedCategoryModel = widget.model.category;
    _categoryID = widget.model.category.id;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Edit Transaction'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: CategoryType.income,
                            groupValue: _selectedCategorytype,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCategorytype = CategoryType.income;
                                _categoryID = null;
                              });
                            },
                          ),
                          const Text('Income'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: CategoryType.expense,
                            groupValue: _selectedCategorytype,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCategorytype = CategoryType.expense;
                                _categoryID = null;
                              });
                            },
                          ),
                          const Text('Expense'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                      child: DropdownButton<String>(
                        hint: const Padding(
                          padding: EdgeInsets.only(left: 11, top: 0),
                          child: Text('Select Category'),
                        ),
                        value: _categoryID,
                        items: (_selectedCategorytype == CategoryType.income
                                ? CategoryDb().incomeCategoryListListener
                                : CategoryDb().expenseCategoryListListener)
                            .value
                            .map((e) {
                          return DropdownMenuItem(
                            value: e.id,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 11, top: 0),
                              child: Text(e.name),
                            ),
                            onTap: () {
                              _selectedCategoryModel = e;
                            },
                          );
                        }).toList(),
                        onChanged: (selectedValue) {
                          setState(() {
                            _categoryID = selectedValue;
                          });
                        },
                        isExpanded: true,
                        underline: Container(),
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _descriptionTextEditingController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      hintText: 'Description',
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _amountTextEditingController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      hintText: 'Amount',
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () async {
                          final DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 30)),
                            lastDate: DateTime.now(),
                          );

                          if (selectedDate != null) {
                            setState(() {
                              _selectedDate = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                              );
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_month),
                        label: Padding(
                          padding: const EdgeInsets.only(right: 0),
                          child: Text(
                            _selectedDate == null
                                ? 'Select Date'
                                : DateFormat.yMMMMd().format(_selectedDate!),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  Center(
                    child: SizedBox(
                      width: 400,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: () {
                          editTransaction();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Transaction updated'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Text('Update'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> editTransaction() async {
    final descriptionText = _descriptionTextEditingController.text.trim();
    final amountText = _amountTextEditingController.text.trim();

    if (descriptionText.isEmpty ||
        amountText.isEmpty ||
        _categoryID == null ||
        _selectedDate == null) {
      return;
    }

    final parsedAmount = double.tryParse(amountText);
    if (parsedAmount == null) {
      return;
    }

    final model = TransactionModel(
      description: descriptionText,
      amount: parsedAmount,
      date: _selectedDate!,
      type: _selectedCategorytype!,
      category: _selectedCategoryModel!,
      id: widget.model.id,
    );
    await TransactionDB.instance.editTransaction(model);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    TransactionDB.instance.refresh();
    balanceAmount();
  }
}
