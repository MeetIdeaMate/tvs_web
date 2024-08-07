import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlbilling/components/side_menu_navigation_bloc.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/view/login/login_page.dart';
import 'package:tlbilling/view/useraccess/access_level_shared_pref.dart';
import 'package:tlds_flutter/util/app_colors.dart';

class LogoutDialog extends StatelessWidget {
  final SideMenuNavigationBlocImpl? sideMenuNavigationBlocImpl;
  const LogoutDialog({super.key, this.sideMenuNavigationBlocImpl});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: AppColors().whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: const Text('Log Out'),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll(AppColors().primaryColor)),
          child: Text(
            'Log Out',
            style: TextStyle(color: AppColor().whiteColor),
          ),
          onPressed: () => logout(context),
        ),
      ],
    );
  }

  Future<void> logout(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('isAccessCheckBoxChanged');
    prefs.remove('rememberMe');
    prefs.remove('user_access');
    prefs.clear();
    sideMenuNavigationBlocImpl?.sideMenuStreamController(true);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ));
  }
}
