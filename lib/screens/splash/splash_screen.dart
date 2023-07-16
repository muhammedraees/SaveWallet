import 'package:flutter/material.dart';
import 'package:mm_helper/main.dart';

import 'package:mm_helper/screens/splash/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/nav_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoggedIn();
  }

  void navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (ctx1) => HomeNavigation(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(image: AssetImage('assets/images/letest-splash.avif')),
      ),
    );
  }

  Future<void> checkLoggedIn() async {
    final pref = await SharedPreferences.getInstance();
    final userLogged = pref.getBool(logKey);
    if (userLogged == true) {
      navigateToHome();
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const OnboardingPage(),
      ));
    }
  }
}
