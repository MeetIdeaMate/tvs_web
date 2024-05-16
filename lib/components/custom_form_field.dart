import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';

// ignore: must_be_immutable
class CustomFormField extends StatelessWidget {
  final _appColor = AppColors();
  CustomFormField(
      {super.key,
      this.onTap,
      required this.controller,
      this.type,
      this.validator,
      this.enabled,
      this.suffixIcon,
      this.prefixIcon,
      this.inputFormat,
      this.hintText,
      this.inputAction,
      this.autofocus = false,
      this.obscure = false,
      this.onSubmit,
      this.style,
      this.maxLine = 1,
      this.width,
      this.fontSize,
      this.textInputAction,
      this.bgColor,
      this.focusNode,
      this.maxLength,
      this.textAlign = TextAlign.start,
      this.initialValue,
      this.onChanged,
      this.counterText,
      this.inputFormatters,
      this.labelText,
      this.requiredLabelText,
      this.hintColor,
      this.height});

  TextEditingController controller;
  TextInputType? type;
  final VoidCallback? onTap;
  String? Function(String?)? validator;
  void Function(String)? onSubmit;
  void Function(String)? onChanged;
  bool? enabled;
  TextAlign textAlign;
  Widget? suffixIcon;
  Widget? prefixIcon;
  String? hintText;
  TextStyle? style;
  List<TextInputFormatter>? inputFormat;
  TextInputAction? inputAction;
  bool autofocus;
  bool obscure;
  int maxLine;
  double? width;
  double? fontSize;
  TextInputAction? textInputAction;
  Color? bgColor;
  int? maxLength;
  String? initialValue;
  FocusNode? focusNode;
  String? counterText;
  List<TextInputFormatter>? inputFormatters;
  String? labelText;
  Widget? requiredLabelText;
  double? height;
  Color? hintColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (requiredLabelText != null)
          requiredLabelText ?? const SizedBox.shrink(),
        if (labelText != null)
          Text(
            labelText!,
            style: const TextStyle(fontSize: 16),
          ),
        AppWidgetUtils.buildSizedBox(custHeight: 5),
        SizedBox(
          width: width,
          height: height,
          child: TextFormField(
            inputFormatters: inputFormatters,
            style: TextStyle(
                fontSize: fontSize,
                height: 1.0,
                color: AppColors().blackColor,
                fontWeight: FontWeight.w400),
            enabled: enabled,
            onTap: onTap,
            initialValue: initialValue,
            textAlign: textAlign,
            focusNode: focusNode,
            controller: controller,
            keyboardType: type,
            cursorColor: Colors.grey,
            obscureText: obscure,
            maxLines: maxLine,
            maxLength: maxLength,
            textInputAction: inputAction,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
              counterText: '',
              hintText: hintText,
              hintStyle:
                  TextStyle(color: hintColor ?? _appColor.grey, fontSize: 13),
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              focusedErrorBorder:
                  AppUtils.outlineInputBorder(color: _appColor.primaryColor),
              errorBorder:
                  AppUtils.outlineInputBorder(color: _appColor.errorColor),
              enabledBorder:
                  AppUtils.outlineInputBorder(color: _appColor.hintColor),
              disabledBorder:
                  AppUtils.outlineInputBorder(color: _appColor.disabledColor),
              focusedBorder:
                  AppUtils.outlineInputBorder(color: _appColor.primaryColor),
            ),
            textCapitalization: TextCapitalization.words,
            onChanged: onChanged,
            onFieldSubmitted: onSubmit,
            validator: validator,
          ),
        ),
      ],
    );
  }
}
