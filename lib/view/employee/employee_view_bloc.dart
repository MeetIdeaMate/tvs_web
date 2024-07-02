import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_branches_by_pagination.dart';
import 'package:tlbilling/models/get_model/get_all_employee_by_pagination.dart';
import 'package:tlbilling/models/parent_response_model.dart';

abstract class EmployeeViewBloc {
  TextEditingController get empNameAndMobNoFilterController;
  String? get employeeCity;
  String? get employeeWorktype;
  String? get employeeBranch;
  String? get selectedBranch;
  Future<GetAllEmployeesByPaginationModel> getEmployeesList();
  Stream<bool> get employeeTableStream;
  Future<List<String>> getConfigByIdModel({String? configId});
  Future<ParentResponseModel> getBranchName();
  int get currentPage;
  Stream<int> get pageNumberStream;
  Future<List<BranchDetail>?> getBranchesList();
  bool? get isMainBranch;
}

class EmployeeViewBlocImpl extends EmployeeViewBloc {
  String? _employeeCity;
  String? _employeeBranch;
  String? _employeeWorktype;
  String? _selectedBranch;
  final _empNameAndMobNoFilterController = TextEditingController();
  final _appServiceBlocImpl = AppServiceUtilImpl();
  final _employeeTableStream = StreamController<bool>.broadcast();
  int _currentPage = 0;
  final _pageNumberStreamController = StreamController<int>.broadcast();
  bool? _isMainBranch = false;

  @override
  TextEditingController get empNameAndMobNoFilterController =>
      _empNameAndMobNoFilterController;

  @override
  String? get employeeCity => _employeeCity;
  set employeeCity(String? city) {
    _employeeCity = city;
  }

  set employeeWorktype(String? workType) {
    _employeeWorktype = workType;
  }

  set employeeBranch(String? branch) {
    _employeeBranch = branch;
  }

  @override
  String? get employeeWorktype => _employeeWorktype;

  @override
  String? get employeeBranch => _employeeBranch;

  @override
  Future<GetAllEmployeesByPaginationModel> getEmployeesList() {
    return _appServiceBlocImpl.getAllEmployeesByPaginationModel(
        currentPage,
        empNameAndMobNoFilterController.text,
        employeeCity ?? '',
        employeeWorktype ?? '',
        employeeBranch ?? '');
  }

  @override
  Stream<bool> get employeeTableStream => _employeeTableStream.stream;

  employeeTableViewStream(bool newValue) {
    return _employeeTableStream.add(newValue);
  }

  @override
  int get currentPage => _currentPage;
  set currentPage(int pageValue) {
    _currentPage = pageValue;
  }

  @override
  Stream<int> get pageNumberStream => _pageNumberStreamController.stream;

  pageNumberUpdateStreamController(int streamValue) {
    _pageNumberStreamController.add(streamValue);
  }

  @override
  Future<List<String>> getConfigByIdModel({String? configId}) {
    return _appServiceBlocImpl.getConfigByIdModel(configId: configId);
  }

  @override
  Future<ParentResponseModel> getBranchName() {
    return _appServiceBlocImpl.getBranchName();
  }

  @override
  Future<List<BranchDetail>?> getBranchesList() async {
    return await _appServiceBlocImpl.getAllBranchListWithoutPagination();
  }

  @override
  String? get selectedBranch => _selectedBranch;

  set selectedBranch(String? branchName) {
    _selectedBranch = branchName;
  }

  @override
  bool? get isMainBranch => _isMainBranch;

  set isMainBranch(bool? value) {
    _isMainBranch = value;
  }
}
