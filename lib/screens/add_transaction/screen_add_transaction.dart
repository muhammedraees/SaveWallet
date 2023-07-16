import 'package:flutter/material.dart';
import 'package:mm_helper/db/category/category_db.dart';
import 'package:mm_helper/db/transaction/transaction_db.dart';
import 'package:mm_helper/model/category/category_model.dart';
import 'package:mm_helper/model/transaction/transaction_model.dart';
import 'package:intl/intl.dart';

import '../../db/transaction/balance.dart';

class ScreenAddTransaction extends StatefulWidget {
  static const routaName = 'add-transaction';
  const ScreenAddTransaction({Key? key}) : super(key: key);

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategorytype;
  CategoryModel? _selectedCategoryModel;

  String? _categoryID;

  final _descriptionTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

  String? _descriptionErrorText;
  String? _amountErrorText;
  String? _dateErrorText;
  // String? _categoryErrorText;
  bool _showCategoryError = false;

  @override
  void initState() {
    _selectedCategorytype = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Transaction'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
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
                  const SizedBox(
                    height: 30,
                  ),
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
                          // print(selectedValue);
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
                  if (_showCategoryError)
                    const Padding(
                      padding: EdgeInsets.only(left: 10, top: 5),
                      child: Text(
                        'Please select a category.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: _descriptionTextEditingController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      hintText: 'Description',
                      errorText: _descriptionErrorText,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: _amountTextEditingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      hintText: 'Amount',
                      errorText: _amountErrorText,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
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
                            style: TextStyle(
                              color: _selectedDate == null
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_dateErrorText != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Text(
                        _dateErrorText!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(
                    height: 70,
                  ),
                  Center(
                    child: SizedBox(
                      width: 400,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: () {
                          validateForm();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('New Transaction added'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Text('Continue'),
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

  void validateForm() {
    final descriptionText = _descriptionTextEditingController.text;
    final amountText = _amountTextEditingController.text;

    if (descriptionText.isEmpty) {
      setState(() {
        _descriptionErrorText = 'Please enter a description.';
      });
    } else {
      setState(() {
        _descriptionErrorText = null;
      });
    }

    if (amountText.isEmpty) {
      setState(() {
        _amountErrorText = 'Please enter an amount.';
      });
    } else {
      setState(() {
        _amountErrorText = null;
      });
    }

    if (_selectedDate == null) {
      setState(() {
        _dateErrorText = 'Please select a date.';
      });
    } else {
      setState(() {
        _dateErrorText = null;
      });
    }

    if (_categoryID == null) {
      setState(() {
        _showCategoryError = true;
      });
    } else {
      setState(() {
        _showCategoryError = false;
      });
    }

    if (descriptionText.isNotEmpty &&
        amountText.isNotEmpty &&
        _selectedDate != null &&
        _categoryID != null) {
      addTransaction();
    }
  }

  Future<void> addTransaction() async {
    final descriptionText = _descriptionTextEditingController.text;
    final amountText = _amountTextEditingController.text;

    final parsedAmount = double.tryParse(amountText);

    final model = TransactionModel(
        description: descriptionText,
        amount: parsedAmount!,
        date: _selectedDate!,
        type: _selectedCategorytype!,
        category: _selectedCategoryModel!,
        id: DateTime.now().millisecondsSinceEpoch.toString());

    await TransactionDB.instance.addTransaction(model);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    TransactionDB.instance.refresh();
    balanceAmount();
  }
}
