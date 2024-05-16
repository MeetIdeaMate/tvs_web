import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/components/custom_form_field.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';

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
      String? name, TextEditingController controller, BuildContext context) {
    double searchFieldWidth = MediaQuery.of(context).size.width * 0.19;

    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: CustomFormField(
        hintText: name,
        controller: controller,
        height: 40,
        width: searchFieldWidth,
        maxLength: name == AppConstants.mobileNumber ? 10 : 1000,
        inputFormatters: name == AppConstants.mobileNumber
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
}
