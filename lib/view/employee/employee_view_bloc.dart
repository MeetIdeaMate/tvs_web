import 'package:flutter/material.dart';

abstract class EmployeeViewBloc {
  TextEditingController get empNameAndMobNoFilterController;
  String? get employeeCity;
  String? get employeeWorktype;
  String? get employeeBranch;
}

class EmployeeViewBlocImpl extends EmployeeViewBloc {
  String? _employeeCity;
  String? _employeeBranch;
  String? _employeeWorktype;
  final _empNameAndMobNoFilterController = TextEditingController();

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
}
