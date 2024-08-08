import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/token_interceptor.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/view/login/login_page.dart';
import 'package:tlbilling/view/useraccess/access_level_shared_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AccessLevel.accessingData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final Dio dio = Dio();
    dio.interceptors.add(TokenInterceptor(dio, context));
    return MaterialApp(
      routes: {
        '/login': (context) => const LoginPage(),
      },
      initialRoute: '/',
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.unknown
        },
      ),
      theme: ThemeData(
        fontFamily: AppConstants.poppinsRegular,
      ),
      title: 'TL Billing',
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
