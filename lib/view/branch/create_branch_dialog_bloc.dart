import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_branch_model.dart';
import 'package:tlbilling/models/parent_response_model.dart';
import 'package:tlbilling/models/post_model/add_branch_model.dart';
import 'package:tlbilling/models/update/update_branch_model.dart';
import 'package:tlbilling/utils/app_constants.dart';

abstract class CreateBranchDialogBloc {
  TextEditingController get branchNameController;

  TextEditingController get cityController;

  TextEditingController get addressController;

  TextEditingController get mobileNoController;

  TextEditingController get pinCodeController;

  String? get selectedMainBranch;

  String? get selectedBranchId;

  String? get selectedCity;

  bool? get isMainBranch;

  bool? get isAsyncCall;

  GlobalKey<FormState> get branchFormKey;

  Stream get radioButtonStreamController;

  Future<void> addBranch(Function(int? statusCode) onSuccessCallBack);

  Future<void> updateBranch(
      String? branchId, Function(int statusCode) successCallBack);

  Future<ParentResponseModel> getBranchList();

  Future<GetAllBranchList?> getBranchDetailsById(String? branchId);

  Future<List<String>> getCities();
}

class CreateBranchDialogBlocImpl extends CreateBranchDialogBloc {
  final _branchNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _radioButtonStreamController = StreamController.broadcast();
  String? _selectedMainBranch;
  String? _selectedBranch;
  String? _selectCity;
  final _branchFormKey = GlobalKey<FormState>();
  final _appService = AppServiceUtilImpl();
  bool? _isMainBranch;
  bool? _isAsyncCall = false;

  @override
  TextEditingController get addressController => _addressController;

  @override
  TextEditingController get branchNameController => _branchNameController;

  @override
  TextEditingController get cityController => _cityController;

  @override
  TextEditingController get mobileNoController => _mobileNoController;

  @override
  TextEditingController get pinCodeController => _pinCodeController;

  @override
  String? get selectedMainBranch => _selectedMainBranch;

  set selectedMainBranch(String? newValue) {
    _selectedMainBranch = newValue;
  }

  @override
  String? get selectedBranchId => _selectedBranch;

  @override
  GlobalKey<FormState> get branchFormKey => _branchFormKey;

  @override
  String? get selectedCity => _selectCity;

  set selectedCity(String? newValue) {
    _selectCity = newValue;
  }

  set selectedBranchId(String? newValue) {
    _selectedBranch = newValue;
  }

  @override
  Future<void> addBranch(Function(int? statusCode) onSuccessCallBack) async {
    return await _appService.addBranch(
        AddBranchModel(
            branchName: branchNameController.text,
            address: addressController.text,
            city: selectedCity,
            mobileNo: mobileNoController.text,
            pinCode: pinCodeController.text,
            mainBranch: isMainBranch,
            mainBranchId: selectedBranchId),
        onSuccessCallBack);
  }

  @override
  bool? get isMainBranch => _isMainBranch;

  set isMainBranch(bool? newValue) {
    _isMainBranch = newValue;
  }

  @override
  bool? get isAsyncCall => _isAsyncCall;

  set isAsyncCall(bool? newValue) {
    _isAsyncCall = newValue;
  }

  @override
  Stream get radioButtonStreamController => _radioButtonStreamController.stream;

  radioButtonStream(bool? streamValue) {
    _radioButtonStreamController.add(streamValue);
  }

  @override
  Future<ParentResponseModel> getBranchList() async {
    return _appService.getBranchName();
  }

  @override
  Future<GetAllBranchList?> getBranchDetailsById(String? branchId) async {
    return _appService.getBranchDetailsById(branchId);
  }

  @override
  Future<List<String>> getCities() async {
    return await _appService.getConfigByIdModel(configId: AppConstants.cities);
  }

  @override
  Future<void> updateBranch(
      String? branchId, Function(int statusCode) successCallBack) async {
    return _appService.updateBranch(
        UpdateBranchModel(
            address: addressController.text,
            branchName: branchNameController.text,
            city: selectedCity,
            mobileNo: mobileNoController.text,
            mainBranch: isMainBranch,
            pinCode: pinCodeController.text,
            mainBranchId: branchId),
        branchId,
        successCallBack);
  }
}
