import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';

class DeleteDialog extends StatelessWidget {
  final String content;
  final dynamic Function() onPressed;
  final String? buttonText;
  final String? imagePath;
  const DeleteDialog({
    super.key,
    this.buttonText,
    this.imagePath,
    required this.content,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors().whiteColor,
      surfaceTintColor: AppColors().whiteColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(imagePath ?? AppConstants.icDelete),
          AppWidgetUtils.buildSizedBox(custHeight: 10),
          Center(
            child: Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors().greyColor),
            ),
          )
        ],
      ),
      actions: [
        CustomActionButtons(
          cancelButtonText: AppConstants.no,
          buttonText: buttonText ?? AppConstants.yes,
          onPressed: onPressed,
        )
      ],
    );
  }
}
