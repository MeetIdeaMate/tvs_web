import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';

class MatchedDialog extends StatelessWidget {
  const MatchedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final appColor = AppColors();
    return AlertDialog(
        content: Column(mainAxisSize: MainAxisSize.min, children: [
      SvgPicture.asset(AppConstants.icMatched),
      AppWidgetUtils.buildSizedBox(custHeight: 20),
      const Text(
        AppConstants.statementMatchedMsg,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.black45),
      ),
      AppWidgetUtils.buildSizedBox(custHeight: 20),
      Center(
          child: ElevatedButton(
        style: ButtonStyle(
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            )),
            backgroundColor: WidgetStatePropertyAll(appColor.primaryColor)),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          AppConstants.ok,
          style: TextStyle(color: appColor.whiteColor),
        ),
      ))
    ]));
  }
}
