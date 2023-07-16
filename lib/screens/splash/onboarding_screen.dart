import 'package:flutter/material.dart';
import 'package:mm_helper/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/nav_controller.dart';

class OnboardingPage extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const OnboardingPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            const Image(image: AssetImage('assets/images/onboarding.jpg')),
            SizedBox(
              height: screenHeight * 0.15,
            ),
            Column(
              children: [
                const Text(
                  'Simple solution for your budget',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                const Text(
                  'Manage your income and expense \nintelligently',
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                SizedBox(
                  width: screenWidth * 0.7,
                  height: screenHeight * 0.06,
                  child: ElevatedButton(
                    onPressed: () async {
                      final pref = await SharedPreferences.getInstance();
                      await pref.setBool(logKey, true);
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => HomeNavigation(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 142, 192, 187),
                    ),
                    child: const Text(
                      'Get started',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
