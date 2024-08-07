import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_login_response.dart';

abstract class LoginPageBloc {
  GlobalKey<FormState> get loginFormKey;
  TextEditingController get mobileNumberTextController;
  TextEditingController get passwordTextController;
  Stream<bool> get passwordVisibleStream;
  bool get ispasswordVisible;
  Future<GetAllLoginResponse> login(Function(int statusCode) onSuccessCallBack);
}

class LoginPageBlocImpl extends LoginPageBloc {
  final _appserviceUtilImpl = AppServiceUtilImpl();
  bool _isPasswordVisible = false;
  final _passwordVisibleStream = StreamController<bool>();
  final _loginformkey = GlobalKey<FormState>();
  final _mobileNumbertextController = TextEditingController();
  final _passwordTextController = TextEditingController();

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
  Future<GetAllLoginResponse> login(Function(int p1) onSuccessCallBack) {
    return _appserviceUtilImpl.login(mobileNumberTextController.text,
        passwordTextController.text, onSuccessCallBack);
  }
}
