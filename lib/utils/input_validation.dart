import 'package:tlbilling/utils/app_constants.dart';

class InputValidations {
  static mobileNumberValidation(String errorText) {
    if (errorText.isEmpty) {
      return AppConstants.mobileNumberErrorText;
    } else if (errorText.length != 10) {
      return AppConstants.mobileNumberDigitErrorText;
    }
    return null;
  }

  static gstNumberValidation(String errorText) {
    if (errorText.isEmpty) {
      return AppConstants.gstNumberErrorText;
    } else if (errorText.length != 15) {
      return AppConstants.gstDigitErrorText;
    }
    return null;
  }

  static passwordValidation(String errorText) {
    if (errorText.isEmpty) {
      return AppConstants.passwordErrorText;
    }
    return null;
  }

  static String? nameValidation(String errorText) {
    if (errorText.isEmpty) {
      return AppConstants.nameValidationText;
    } else if (RegExp(r"[^a-zA-Z]").hasMatch(errorText)) {
      return AppConstants.nameValidationErrorText;
    }
    return null;
  }

  static String? mailValidation(String email) {
    if (email.isNotEmpty) {
      if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
          .hasMatch(email)) {
        return AppConstants.mailValidationErrorText;
      }
    }

    return null;
  }

  static String? cityValidation(String errorText) {
    if (errorText.isEmpty) {
      return AppConstants.cityValidationText;
    }
    return null;
  }

  static String? genderValidation(String errorText) {
    if (errorText.isEmpty) {
      return AppConstants.genderErrorMsg;
    }
    return null;
  }

  static String? userNameValidation(String errorText) {
    if (errorText.isEmpty) {
      return AppConstants.userValidation;
    }
    return null;
  }

  static String? designationValidation(String errorText) {
    if (errorText.isEmpty) {
      return AppConstants.designationValidation;
    }
    return null;
  }

  static String? branchValidation(String errorText) {
    if (errorText.isEmpty) {
      return AppConstants.branchErrorMsg;
    }
    return null;
  }

  static String? empTypeValidation(String errorText) {
    if (errorText.isEmpty) {
      return AppConstants.empTypeErrorMsg;
    }
    return null;
  }

  static String? addressValidation(String errorText) {
    if (errorText.isEmpty) {
      return AppConstants.addressValidationText;
    }
    return null;
  }

  static aadharValidation(String errorText) {
    if (errorText.isNotEmpty) {
      if (errorText.length != 16) {
        return AppConstants.aadharDigitErrorText;
      }
    }
    return null;
  }

  static accountNOValidation(String errorText) {
    if (errorText.isEmpty) {
      return AppConstants.accountNoErrorText;
    }
    return null;
  }

  static panValidation(String errorText) {
    if (errorText.isNotEmpty) {
      if (errorText.length != 10) {
        return AppConstants.aadharDigitErrorText;
      }
    }
    return null;
  }

  static pinCodeValidation(String errorText) {
    if (errorText.isNotEmpty) {
      if (errorText.length != 6) {
        return AppConstants.pinCodeValidation;
      }
    }
    return null;
  }
}
