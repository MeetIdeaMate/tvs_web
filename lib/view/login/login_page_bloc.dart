import 'dart:async';

import 'package:flutter/widgets.dart';

abstract class LoginPageBloc {
  GlobalKey<FormState> get loginFormKey;
  TextEditingController get mobileNumberTextController;
  TextEditingController get passwordTextController;
  Stream<bool> get passwordVisibleStream;
  bool get ispasswordVisible;
}

class LoginPageBlocImpl extends LoginPageBloc {
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
}
