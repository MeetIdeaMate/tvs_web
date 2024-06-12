import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_employee_by_id.dart';
import 'package:tlbilling/models/parent_response_model.dart';
import 'package:tlbilling/models/user_model.dart';

abstract class CreateUserDialogBloc {
  TextEditingController get mobileNoTextController;
  TextEditingController get passwordController;
  TextEditingController get employeeNameEditText;
  String? get selectedUserName;
  String? get selectedDesignation;
  GlobalKey<FormState> get userFormKey;
  Stream<bool> get passwordVisibleStream;
  Stream<bool> get selectedDesinationStream;
  bool get ispasswordVisible;
  Future<UsersListModel?> getUserList();
  Future<List<String>> getConfigByIdModel({String? configId});
  String? get selectedEmpId;
  String? get userUpdatedStatus;
  String? get selectedBranchId;
  String? get selectedBranch;

  Future<ParentResponseModel> getEmployeeName();
  Future<ParentResponseModel> getBranchName();

  Stream<bool> get employeeSelectStream;
  Future<void> onboardNewUser(
    Function onSuccessCallBack,
    Function onErrorCallBack,
  );

  Future<void> updateUserStatus(
      String? userId, Function(int statusCode) onSuccessCallBack);

  Future<GetEmployeeById?> getEmployeeById(String employeeId);
}

class CreateUserDialogBlocImpl extends CreateUserDialogBloc {
  bool _isPasswordVisible = false;

  final _appServiceUtilsImpl = AppServiceUtilImpl();
  final _passwordVisibleStream = StreamController<bool>.broadcast();
  final _selectedDesinationStream = StreamController<bool>.broadcast();

  final _mobileNoTextController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedUserName;
  String? _selectedDesignation;
  String? _userUpdatedStatus;
  final _userFormkey = GlobalKey<FormState>();
  final _employeeNameEditText = TextEditingController();
  final _employeeSelectStream = StreamController<bool>();
  String? _selectedEmpId;
  String? _selectedBranchId;
  String? _selectedBranch;
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
    _selectedDesignation = newValue;
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

  @override
  Future<UsersListModel?> getUserList() {
    return _appServiceUtilsImpl.getUserList('', '', 0);
  }

  @override
  Future<ParentResponseModel> getEmployeeName() {
    return _appServiceUtilsImpl.getEmployeesName();
  }

  @override
  Future<List<String>> getConfigByIdModel({String? configId}) {
    return _appServiceUtilsImpl.getConfigByIdModel(configId: configId);
  }

  @override
  TextEditingController get employeeNameEditText => _employeeNameEditText;

  @override
  Stream<bool> get employeeSelectStream => _employeeSelectStream.stream;

  employeeNameSelectStream(bool newValue) {
    _employeeSelectStream.add(newValue);
  }

  @override
  Future<void> onboardNewUser(
    Function onSuccessCallBack,
    Function onErrorCallBack,
  ) {
    return _appServiceUtilsImpl.onboardNewUser(
        onSuccessCallBack,
        onErrorCallBack,
        selectedDesignation ?? '',
        selectedUserName ?? '',
        selectedBranchId ?? '',
        selectedEmpId ?? '',
        passwordController.text,
        mobileNoTextController.text);
  }

  @override
  String? get selectedEmpId => _selectedEmpId;
  set selectedEmpId(String? newValue) {
    _selectedEmpId = newValue;
  }

  @override
  Future<GetEmployeeById?> getEmployeeById(String employeeId) {
    return _appServiceUtilsImpl.getEmployeeById(employeeId);
  }

  @override
  Stream<bool> get selectedDesinationStream => _selectedDesinationStream.stream;

  selectedDesinationStreamController(bool newValue) {
    _selectedDesinationStream.add(newValue);
  }

  @override
  String? get userUpdatedStatus => _userUpdatedStatus;
  set userUpdatedStatus(String? newValue) {
    _userUpdatedStatus = newValue;
  }

  @override
  Future<void> updateUserStatus(
      String? userId, Function(int statusCode) onSuccessCallBack) {
    return _appServiceUtilsImpl.updateUserStatus(
        userId, userUpdatedStatus, onSuccessCallBack);
  }

  @override
  String? get selectedBranchId => _selectedBranchId;
  set selectedBranchId(String? newValue) {
    _selectedBranchId = newValue;
  }

  @override
  Future<ParentResponseModel> getBranchName() {
    return _appServiceUtilsImpl.getBranchName();
  }

  @override
  String? get selectedBranch => _selectedBranch;

  set selectedBranch(String? newValue) {
    _selectedBranch = newValue;
  }
}
