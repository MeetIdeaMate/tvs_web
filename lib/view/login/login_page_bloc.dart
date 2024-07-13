import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/services/api_response.dart';
import 'package:tlbilling/services/auth_request.dart';
import 'package:tlbilling/utils/app_constants.dart';

abstract class LoginPageBloc {
  GlobalKey<FormState> get loginFormKey;
  TextEditingController get mobileNumberTextController;
  TextEditingController get passwordTextController;
  Stream<bool> get passwordVisibleStream;
  bool get ispasswordVisible;
  Future<void> login(Function(int) onSuccessCallBack);
}

class LoginPageBlocImpl extends LoginPageBloc {
  final _appserviceUtilImpl = AppServiceUtilImpl();
  bool _isPasswordVisible = false;
  final _passwordVisibleStream = StreamController<bool>();
  final _loginformkey = GlobalKey<FormState>();
  final _mobileNumbertextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _authRequest = AuthRequest();

  set ispasswordVisible(bool passwordState) {
    _isPasswordVisible = passwordState;
  }

  @override
  GlobalKey<FormState> get loginFormKey => _loginformkey;

  @override
  TextEditingController get mobileNumberTextController =>
      _mobileNumbertextController;

  @override
  TextEditingController get passwordTextController => _passwordTextController;

  @override
  Stream<bool> get passwordVisibleStream => _passwordVisibleStream.stream;

  @override
  bool get ispasswordVisible => _isPasswordVisible;

  passwordVisbleStreamControler(bool passwordStreamValue) {
    _passwordVisibleStream.add(passwordStreamValue);
  }

  @override
  Future<void> login(Function(int) onSuccessCallBack) async {
    try {
      final apiResponse = await _authRequest.loginRequest(
        userName: _mobileNumbertextController.text,
        password: passwordTextController.text,
      );
      if (apiResponse.hasError()) {
      } else {
        // var designation = apiResponse.data['result']['login']['designation'];
        // var token = apiResponse.data  ['result']['login']['token'];
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // await prefs.setString(AppConstants.token, token);
        // await prefs.setString(AppConstants.designation, designation);
        // int statusCode = int.tryParse(apiResponse.code.toString()) ?? 200;

        // onSuccessCallBack(statusCode);
      }
    } catch (e) {
      print('Exception during login: $e');
    }
  }
}
