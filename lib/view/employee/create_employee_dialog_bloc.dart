import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_employee_by_id.dart';
import 'package:tlbilling/models/parent_response_model.dart';
import 'package:tlbilling/models/post_model/add_employee_model.dart';

abstract class CreateEmployeeDialogBloc {
  TextEditingController get empNameController;
  TextEditingController get empMobNoController;
  TextEditingController get empEmailController;
  TextEditingController get empaddressController;
  TextEditingController get empAgeController;
  TextEditingController get empCityEditText;
  String? get selectedEmpType;
  String? get selectedEmpBranch;
  String? get selectEmpGender;
  String? get selectEmpCity;
  String? get selectEmpBranchId;
  GlobalKey<FormState> get empFormkey;
  Future<List<String>> getConfigByIdModel({String? configId});
  Future<void> onboardNewEmployee(Function(int? statusCode) statusCode);
  Future<void> updateEmployee(
      String employeeId, Function(int? statusCode) statusCode);
  Future<ParentResponseModel> getBranchName();
  Future<GetEmployeeById?> getEmployeeById(String employeeId);
}

class CreateEmployeeDialogBlocImpl extends CreateEmployeeDialogBloc {
  final _empNameController = TextEditingController();
  final _empMobNoController = TextEditingController();
  final _empEmailController = TextEditingController();
  final _empAddressController = TextEditingController();
  final _empAgeController = TextEditingController();
  final _empCityEditText = TextEditingController();
  String? _selectedEmpType;
  String? _selectedEmpBranch;
  String? _selectEmpGender;
  String? _selectEmpCity;
  String? _selectEmpBranchId;
  final _empFprmKey = GlobalKey<FormState>();
  final _appServices = AppServiceUtilImpl();

  @override
  TextEditingController get empNameController => _empNameController;

  @override
  TextEditingController get empMobNoController => _empMobNoController;

  @override
  TextEditingController get empEmailController => _empEmailController;

  @override
  TextEditingController get empaddressController => _empAddressController;

  @override
  String? get selectedEmpType => _selectedEmpType ?? '';
  set selectedEmpType(String? value) {
    _selectedEmpType = value ?? '';
  }

  @override
  String? get selectedEmpBranch => _selectedEmpBranch;
  set selectedEmpBranch(String? value) {
    _selectedEmpBranch = value ?? '';
  }

  @override
  String? get selectEmpGender => _selectEmpGender;
  set selectEmpGender(String? value) {
    _selectEmpGender = value ?? "";
  }

  @override
  TextEditingController get empAgeController => _empAgeController;

  @override
  String? get selectEmpCity => _selectEmpCity;
  set selectEmpCity(String? value) {
    _selectEmpCity = value ?? "";
  }

  @override
  GlobalKey<FormState> get empFormkey => _empFprmKey;

  @override
  Future<void> onboardNewEmployee(Function(int? statusCode) statusCode) {
    return _appServices.onboardNewEmployee(
        AddEmployeeModel(
            address: _empAddressController.text,
            age: int.parse(_empAgeController.text),
            branchId: selectEmpBranchId ?? '',
            city: _empCityEditText.text,
            designation: selectedEmpType ?? '',
            emailId: _empEmailController.text,
            employeeName: _empNameController.text,
            gender: selectEmpGender ?? '',
            mobileNumber: _empMobNoController.text),
        statusCode);
  }

  @override
  String? get selectEmpBranchId => _selectEmpBranchId;

  set selectEmpBranchId(String? newValue) {
    _selectEmpBranchId = newValue;
  }

  @override
  TextEditingController get empCityEditText => _empCityEditText;

  @override
  Future<List<String>> getConfigByIdModel({String? configId}) {
    return _appServices.getConfigByIdModel(configId: configId);
  }

  @override
  Future<ParentResponseModel> getBranchName() {
    return _appServices.getBranchName();
  }

  @override
  Future<void> updateEmployee(
      String employeeId, Function(int? statusCode) statusCode) {
    return _appServices.updateEmployee(
        employeeId,
        AddEmployeeModel(
            address: _empAddressController.text,
            age: int.parse(_empAgeController.text),
            branchId: selectEmpBranchId ?? '',
            city: _empCityEditText.text,
            designation: selectedEmpType ?? '',
            emailId: _empEmailController.text,
            employeeName: _empNameController.text,
            gender: selectEmpGender ?? '',
            mobileNumber: _empMobNoController.text),
        statusCode);
  }

  @override
  Future<GetEmployeeById?> getEmployeeById(String employeeId) {
    return _appServices.getEmployeeById(employeeId);
  }
}
