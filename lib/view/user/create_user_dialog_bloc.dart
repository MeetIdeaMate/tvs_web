import 'dart:async';

import 'package:flutter/material.dart';

abstract class CreateUserDialogBloc {
  TextEditingController get mobileNoTextController;
  TextEditingController get passwordController;
  String? get selectedUserName;
  String? get selectedDesignation;
  GlobalKey<FormState> get userFormKey;
  Stream<bool> get passwordVisibleStream;
  bool get ispasswordVisible;
}

class CreateUserDialogBlocImpl extends CreateUserDialogBloc {
  bool _isPasswordVisible = false;
  final _passwordVisibleStream = StreamController<bool>();

  final _mobileNoTextController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedUserName;
  String? _selectedDesignation;
  final _userFormkey = GlobalKey<FormState>();
  set ispasswordVisible(bool passwordState) {
    _isPasswordVisible = passwordState;
  }

  @override
  TextEditingController get mobileNoTextController => _mobileNoTextController;

  @override
  TextEditingController get passwordController => _passwordController;

  @override
  String? get selectedUserName => _selectedUserName;

  set selectedUserName(String? newValue) {
    _selectedUserName = newValue;
  }

  @override
  String? get selectedDesignation => _selectedDesignation;
  set selectedDesignation(String? newValue) {
    _selectedUserName = newValue;
  }

  @override
  GlobalKey<FormState> get userFormKey => _userFormkey;
  @override
  Stream<bool> get passwordVisibleStream => _passwordVisibleStream.stream;

  @override
  bool get ispasswordVisible => _isPasswordVisible;

  passwordVisbleStreamControler(bool passwordStreamValue) {
    _passwordVisibleStream.add(passwordStreamValue);
  }
}
