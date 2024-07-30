import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/view/login/login_page.dart';
import 'package:tlbilling/view/useraccess/access_level_shared_pref.dart';
import 'package:tlbilling/view/useraccess/user_access_levels.dart';

void main() async{
 WidgetsFlutterBinding.ensureInitialized();
  await AccessLevel.accessingData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
