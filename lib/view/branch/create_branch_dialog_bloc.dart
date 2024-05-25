import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/post_model/add_branch_model.dart';

abstract class CreateBranchDialogBloc {
  TextEditingController get branchNameController;

  TextEditingController get cityController;

  TextEditingController get addressController;

  TextEditingController get mobileNoController;

  TextEditingController get pinCodeController;

  String? get selectedMainBranch;

  String? get selectedBranch;

  String? get selectedCity;

  bool? get isMainBranch;

  bool? get isAsyncCall;

  GlobalKey<FormState> get branchFormKey;

  Future<void> addBranch(Function(int? statusCode) onSuccessCallBack);
}

class CreateBranchDialogBlocImpl extends CreateBranchDialogBloc {
  final _branchNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final _pinCodeController = TextEditingController();
  String? _selectedMainBranch;
  String? _selectedBranch;
  String? _selectCity;
  final _branchFormKey = GlobalKey<FormState>();
  final _appService = AppServiceUtilImpl();
  bool? _isMainBranch;
  bool? _isAsyncCall;

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
  String? get selectedBranch => _selectedBranch;

  @override
  GlobalKey<FormState> get branchFormKey => _branchFormKey;

  @override
  String? get selectedCity => _selectCity;

  set selectedCity(String? newValue) {
    _selectCity = newValue;
  }

  set selectedBranch(String? newValue) {
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
            mainBranch: isMainBranch),
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
    isAsyncCall = false;
  }
}
