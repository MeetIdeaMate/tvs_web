import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/service_locator.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/view/login/login_page.dart';
import 'package:toastification/toastification.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator.setupLocator();
  runApp(const ToastificationWrapper(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
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
        dialogBackgroundColor: Colors.white,
        shadowColor: Colors.grey,
      ),
      title: 'TL Billing',
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
