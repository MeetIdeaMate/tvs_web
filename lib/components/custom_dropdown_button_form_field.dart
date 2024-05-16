import 'package:flutter/material.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';

class CustomDropDownButtonFormField extends StatelessWidget {
  final double? height;
  final double? width;
  final String? dropDownValue;
  final String? hintText;
  final bool? validationMessage;
  final List<String> dropDownItems;
  final Function(String?)? onChange;
  final bool? addAllEnable;
  final String? Function(String?)? validator;
  final Widget? requiredLabelText;
  final String? labelText;

  const CustomDropDownButtonFormField(
      {super.key,
      required this.dropDownItems,
      this.height,
      this.width,
      this.dropDownValue,
      this.hintText,
      this.validationMessage,
      this.onChange,
      this.addAllEnable = false,
      this.validator,
      this.labelText,
      this.requiredLabelText});

  @override
  Widget build(BuildContext context) {
    final appColor = AppColors();
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (requiredLabelText != null)
          requiredLabelText ?? const SizedBox.shrink(),
        if (labelText != null)
          Text(
            labelText ?? '',
            style: const TextStyle(fontSize: 16),
          ),
        AppWidgetUtils.buildSizedBox(custHeight: 5),
        SizedBox(
          height: validationMessage ?? false ? height! + 20 : height,
          width: width,
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            child: DropdownButtonFormField<String?>(
              value: dropDownValue,
              focusColor: appColor.whiteColor,
              hint: _buildTextWidget(hintText,
                  color: appColor.greyColor,
                  fontSize: 12,
                  overflow: TextOverflow.fade),
              decoration: InputDecoration(
                focusedErrorBorder:
                    AppUtils.outlineInputBorder(color: appColor.primaryColor),
                errorBorder:
                    AppUtils.outlineInputBorder(color: appColor.errorColor),
                enabledBorder:
                    AppUtils.outlineInputBorder(color: appColor.borderColor),
                disabledBorder:
                    AppUtils.outlineInputBorder(color: appColor.disabledColor),
                focusedBorder:
                    AppUtils.outlineInputBorder(color: appColor.primaryColor),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: appColor.primaryColor)),
                contentPadding:
                    const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
              ),
              isExpanded: true,
              items: dropDownItems.map((item) {
                return DropdownMenuItem<String?>(
                  key: UniqueKey(),
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(color: appColor.blackColor),
                  ),
                );
              }).toList(),
              onChanged: onChange,
              validator: validator,
            ),
          ),
        ),
      ],
    ));
  }

  Widget _buildTextWidget(text,
      {TextOverflow? overflow,
      FontWeight? fontWeight,
      double? fontSize,
      Color? color}) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
      ),
      overflow: overflow,
    );
  }
}
