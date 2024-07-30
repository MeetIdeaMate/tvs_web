import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/view/login/login_page.dart';
import 'package:tlds_flutter/util/app_colors.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

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
                  MaterialStatePropertyAll(AppColors().primaryColor)),
          child: Text(
            'Log Out',
            style: TextStyle(color: AppColor().whiteColor),
          ),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove('token');
            Navigator.pushReplacement(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ));
          },
        ),
      ],
    );
  }
}
