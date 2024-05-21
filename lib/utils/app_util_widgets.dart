import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/components/custom_form_field.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:toastification/toastification.dart';

class AppWidgetUtils {
  static Widget buildSizedBox({double? custWidth, double? custHeight}) {
    return SizedBox(width: custWidth, height: custHeight);
  }

  static Widget buildText(
      {String? text, Color? color, double? fontSize, FontWeight? fontWeight}) {
    return Text(
      text!,
      style:
          TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight),
    );
  }

  static buildHeaderText(String headerText) {
    return Text(headerText,
        style: TextStyle(
            color: AppColors().primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.w700));
  }

  static buildSearchField(
      String? name, TextEditingController controller, BuildContext context,
      {List<TextInputFormatter>? inputFormatters}) {
    double searchFieldWidth = MediaQuery.of(context).size.width * 0.19;

    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: CustomFormField(
        hintText: name,
        controller: controller,
        height: 40,
        width: searchFieldWidth,
        maxLength:
            (name == AppConstants.mobileNumber || name == AppConstants.pinCode)
                ? 10
                : null,
        inputFormatters:
            (name == AppConstants.mobileNumber || name == AppConstants.pinCode)
                ? [FilteringTextInputFormatter.digitsOnly]
                : [
                    FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]")),
                  ],
        hintColor: AppColors().hintColor,
        suffixIcon: IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(AppConstants.icSearch),
        ),
      ),
    );
  }

  static Widget labelTextWithRequired(String header, {double? fontSize}) {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
              text: header,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: AppColors().blackColor)),
          TextSpan(
              text: " *",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                  color: AppColors().red)),
        ]));
  }

  static buildToast(
      BuildContext context,
      ToastificationType? type,
      String titleText,
      Widget? icon,
      String description,
      Color? backgroundColor) {
    return toastification.show(
      showProgressBar: false,
      backgroundColor: backgroundColor,
      borderRadius: BorderRadius.circular(10),
      type: type,
      style: ToastificationStyle.minimal,
      context: context,
      title: Text(titleText),
      icon: icon,
      description: Text(description),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  static buildAddbutton(BuildContext context,
      {String? text, Function()? onPressed, int? flex}) {
    // double searchFieldWidth = MediaQuery.of(context).size.width * 0.17;
    return Expanded(
      flex: flex ?? 2,
      child: CustomElevatedButton(
          height: 40,
          text: text ?? '',
          fontSize: 16,
          buttonBackgroundColor: AppColors().primaryColor,
          fontColor: AppColors().whiteColor,
          suffixIcon: SvgPicture.asset(AppConstants.icAdd),
          onPressed: onPressed),
    );
  }

  static buildLoading() {
    return CircularProgressIndicator();
  }
}
