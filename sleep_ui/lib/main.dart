import 'package:flutter/material.dart';
import 'package:sleep_ui/screens/digital_detox_screen.dart';
import 'package:flutter/material.dart';
import 'package:sleep_ui/screens/splash_screen.dart';
import 'package:sleep_ui/screens/login_screen.dart';
import 'package:sleep_ui/screens/signup_screen.dart';
import 'package:sleep_ui/screens/onboarding_screen.dart';
import 'package:sleep_ui/screens/home_screen.dart';
import 'package:sleep_ui/screens/digital_detox_screen.dart';
import 'package:sleep_ui/screens/sleep_calculator_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SleepCalculatorScreen(),
    );
  }
}
