import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlds_flutter/export.dart';
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

  static Widget buildCustomDmSansTextWidget(String text,
      {Color? color, double? fontSize, FontWeight? fontWeight}) {
    return Text(
      text,
      style: GoogleFonts.dmSans(
          color: color, fontSize: fontSize, fontWeight: fontWeight),
    );
  }

  static buildHeaderText(String headerText, {double? fontSize}) {
    return Text(headerText,
        style: TextStyle(
            color: AppColors().primaryColor,
            fontSize: fontSize ?? 22,
            fontWeight: FontWeight.w700));
  }

  static buildSearchField(
      String? name, TextEditingController controller, BuildContext context,
      {List<TextInputFormatter>? inputFormatters,
      Widget? suffixIcon,
      void Function(String)? onSubmit}) {
    double searchFieldWidth = MediaQuery.of(context).size.width * 0.19;

    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: TldsInputFormField(
        hintText: name,
        controller: controller,
        height: 40,
        width: searchFieldWidth,
        maxLength:
            (name == AppConstants.mobileNumber || name == AppConstants.pinCode)
                ? 10
                : null,
        counterText: '',
        inputFormatters:
            (name == AppConstants.mobileNumber || name == AppConstants.pinCode)
                ? TldsInputFormatters.onlyAllowNumbers
                : inputFormatters ?? inputFormatters,
        isSearch: true,
        suffixIcon: suffixIcon ??
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(AppConstants.icSearch),
            ),
        onSubmit: onSubmit,
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

  static Widget buildAddbutton(BuildContext context,
      {String? text, Function()? onPressed, int? flex, double? width}) {
    // double searchFieldWidth = MediaQuery.of(context).size.width * 0.17;
    return Expanded(
      flex: flex ?? 2,
      child: CustomElevatedButton(
          width: width ?? 0.0,
          height: 40,
          text: text ?? '',
          fontSize: 16,
          buttonBackgroundColor: AppColors().primaryColor,
          fontColor: AppColors().whiteColor,
          suffixIcon: SvgPicture.asset(text == AppConstants.pdfGeneration
              ? AppConstants.icPdfPrint
              : AppConstants.icAdd),
          onPressed: onPressed),
    );
  }

  // static buildLoading() {
  //   return LottieBuilder.asset(
  //     AppConstants.jsonLoader,
  //     height: 200,
  //     width: 200,
  //   );
  // }

  static buildLoading() {
    return LoadingAnimationWidget.flickr(
        rightDotColor: AppColors().primaryColor,
        leftDotColor: AppColor().orangeColor,
        size: 30);
  }

  static OutlineInputBorder outlineInputBorder({Color? color}) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: color ?? AppColors().primaryColor,
        ));
  }
}
