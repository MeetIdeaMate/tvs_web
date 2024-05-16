import 'package:flutter/material.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';

class CustomActionButtons extends StatelessWidget {
  final Function() onPressed;
  final String buttonText;
  final String? cancelButtonText;
  const CustomActionButtons(
      {super.key,
      required this.onPressed,
      required this.buttonText,
      this.cancelButtonText});

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        buildCustomButton(
          context,
          appColors,
          cancelButtonText == 'No' ? AppConstants.no : AppConstants.cancel,
          appColors.primaryColor,
          appColors.whiteColor,
          () {
            Navigator.pop(context);
          },
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 10),
        buildCustomButton(
          context,
          appColors,
          buttonText,
          appColors.whiteColor,
          appColors.primaryColor,
          onPressed,
        ),
      ],
    );
  }

  ElevatedButton buildCustomButton(
    BuildContext context,
    AppColors appColor,
    String text,
    Color textColor,
    Color buttonColor,
    Function() onPressed,
  ) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        )),
        side: MaterialStateProperty.all(
          BorderSide(color: appColor.primaryColor),
        ),
        backgroundColor: MaterialStateProperty.all(buttonColor),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
