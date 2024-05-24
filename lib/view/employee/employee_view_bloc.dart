import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/parent_response_model.dart';

abstract class EmployeeViewBloc {
  TextEditingController get empNameAndMobNoFilterController;
  String? get employeeCity;
  String? get employeeWorktype;
  String? get employeeBranch;
  Future<ParentResponseModel> getEmployeesList();
  Stream<bool> get employeeTableStream;
}

class EmployeeViewBlocImpl extends EmployeeViewBloc {
  String? _employeeCity;
  String? _employeeBranch;
  String? _employeeWorktype;
  final _empNameAndMobNoFilterController = TextEditingController();
  final _appServiceBlocImpl = AppServiceUtilImpl();
  final _employeeTableStream = StreamController<bool>.broadcast();

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
  Future<ParentResponseModel> getEmployeesList() {
    return _appServiceBlocImpl.getEmployeesList(
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
}
