import 'package:flutter/material.dart';

import 'package:mm_helper/screens/category/screen_category.dart';
import 'package:mm_helper/screens/home/home_screen.dart';
import 'package:mm_helper/screens/home/widgets/bottom_nav.dart';

import 'package:mm_helper/screens/transactions/screen_transaction.dart';

import '../statistics/controller_statistics.dart';


class HomeNavigation extends StatelessWidget {
  HomeNavigation({super.key});

  final _pages = [
    const HomeScreen(),
    const ScreenTransation(),
    const ScreenCategory(),
    const Statistics(),
  ];

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(),
      body: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: selectedIndexNotifier,
              builder: (BuildContext context, int updatedIndex, _) {
                return _pages[updatedIndex];
              })),
    );
  }
}
