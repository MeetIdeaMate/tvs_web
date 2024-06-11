import 'package:flutter/material.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/view/login/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: AppConstants.poppinsRegular,
      ),
      title: 'TL Billing',
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
