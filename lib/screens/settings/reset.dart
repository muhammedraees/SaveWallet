import 'package:flutter/material.dart';
import 'package:mm_helper/db/category/category_db.dart';
import 'package:mm_helper/db/transaction/transaction_db.dart';
import 'package:mm_helper/screens/splash/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> resetButton(BuildContext ctx) async {
  SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  await sharedPrefs.clear();
  TransactionDB.instance.clearAllData();
  CategoryDb.instance.clearAllData();
  // ignore: use_build_context_synchronously
  Navigator.of(ctx).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx) => const OnboardingPage()),
      (route) => false);
}
