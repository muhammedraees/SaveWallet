import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mm_helper/model/category/category_model.dart';

const categoryDbName = 'category_database';

abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deleteCategory(String categoryID);
}

class CategoryDb implements CategoryDbFunctions {
  CategoryDb._internal();

  static CategoryDb instance = CategoryDb._internal();

  factory CategoryDb() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomeCategoryListListener =
      ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryListListener =
      ValueNotifier([]);
  @override
  Future<void> insertCategory(CategoryModel value) async {
    final categoryDb = await Hive.openBox<CategoryModel>(categoryDbName);
    await categoryDb.put(value.id, value);
    refreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final categoryDb = await Hive.openBox<CategoryModel>(categoryDbName);
    return categoryDb.values.toList();
  }

  Future<void> refreshUI() async {
    final allCategories = await getCategories();
    incomeCategoryListListener.value.clear();
    expenseCategoryListListener.value.clear();
    await Future.forEach(allCategories, (CategoryModel category) {
      if (category.type == CategoryType.income) {
        incomeCategoryListListener.value.add(category);
      } else {
        expenseCategoryListListener.value.add(category);
      }
    });
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    incomeCategoryListListener.notifyListeners();
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    expenseCategoryListListener.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String categoryID) async {
    final categoryDb = await Hive.openBox<CategoryModel>(categoryDbName);
    await categoryDb.delete(categoryID);
    refreshUI();
  }

  Future<void> clearAllData() async {
    final db = await Hive.openBox<CategoryModel>(categoryDbName);
    await db.clear();
    await refreshUI();
  }

  getCategoriesByType(CategoryType income) {}

  void refresh() {}

  deleteAllCategories() {}
}
