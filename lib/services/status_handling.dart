import 'package:flutter/material.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:toastification/toastification.dart';

mixin ErrorMessage {
  void errorToastMessage(
      String errorMessage, String errorDescription, BuildContext context) {
    AppWidgetUtils.buildToast(
      context,
      ToastificationType.error,
      errorMessage,
      Icon(
        Icons.error_outline_outlined,
        color: AppColors().errorColor,
      ),
      errorDescription,
      AppColors().errorLightColor,
    );
  }
}

mixin SuccessMessage {
  void successToastMessage(
      String successMessage, String successDescription, BuildContext context) {
    AppWidgetUtils.buildToast(
      context,
      ToastificationType.success,
      successMessage,
      Icon(
        Icons.check_circle_outline_rounded,
        color: AppColors().successColor,
      ),
      successDescription,
      AppColors().successLightColor,
    );
  }
}

class StatusMessageHandling with ErrorMessage, SuccessMessage {
  void handleError(
      BuildContext context, String errorMessage, String errorDescription) {
    errorToastMessage(errorMessage, errorDescription, context);
  }

  void handleSuccess(
      BuildContext context, String successMessage, String successDescription) {
    successToastMessage(successMessage, successDescription, context);
  }
}
