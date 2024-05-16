import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tlbilling/utils/app_colors.dart';

class AppUtils {
  static final DateFormat _appDateFormat = DateFormat('dd-MM-yyyy');
  static final DateFormat _apiDateFormat = DateFormat('yyyy-MM-dd');

  static String formatCurrency(double amount) {
    final formatCurrency = NumberFormat.currency(locale: "en_IN", symbol: "₹");
    return formatCurrency.format(amount);
  }

  static String appToAPIDateFormat(String dateText) {
    final date = appStringToDateTime(dateText);
    final formattedDate = _apiDateFormat.format(date);
    return formattedDate;
  }

  static String apiToAppDateFormat(String dateText) {
    final date = apiStringToDateTime(dateText);
    final formattedDate = _appDateFormat.format(date);
    return formattedDate;
  }

  static DateTime appStringToDateTime(String inputDateTime) {
    return _appDateFormat.parse(inputDateTime);
  }

  static String apiDateTimeToString(DateTime inputDateTime) {
    return _apiDateFormat.format(inputDateTime);
  }

  static DateTime apiStringToDateTime(String inputDateTime) {
    return _apiDateFormat.parse(inputDateTime);
  }

  static OutlineInputBorder outlineInputBorder({Color? color}){
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: color ?? AppColors().primaryColor,
        ));
  }
}
