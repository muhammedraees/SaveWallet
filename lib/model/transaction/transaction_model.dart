import 'package:hive_flutter/adapters.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mm_helper/model/category/category_model.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 3)
class TransactionModel {
  @HiveField(0)
  late final String description;

  @HiveField(1)
  late final double amount;

  @HiveField(2)
  late final DateTime date;

  @HiveField(3)
  late final CategoryType type;

  @HiveField(4)
  late final CategoryModel category;

  @HiveField(5)
  String? id;

  TransactionModel(
      {required this.description,
      required this.amount,
      required this.date,
      required this.type,
      required this.category,
      required this.id});
}
