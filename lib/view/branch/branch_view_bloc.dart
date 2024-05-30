import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_branches_by_pagination.dart';

abstract class BranchViewBloc {
  TextEditingController get filterBranchnameController;

  TextEditingController get filterpinCodeController;

  String? get selectedCity;

  Stream get branchNameStreamController;

  Stream get pinCodeStreamController;

  Stream get branchTableStreamController;

  Future<GetAllBranchesByPaginationModel?> getBranchList();
}

class BranchViewBlocImpl extends BranchViewBloc {
  final _filterBranchnameController = TextEditingController();
  final _filterpinCodeController = TextEditingController();
  final _branchNameStreamController = StreamController.broadcast();
  final _pinCodeStreamController = StreamController.broadcast();
  final _branchTableStreamController = StreamController.broadcast();
  String? _selectedCity;
  final _apiCalls = AppServiceUtilImpl();

  @override
  TextEditingController get filterBranchnameController =>
      _filterBranchnameController;

  @override
  TextEditingController get filterpinCodeController => _filterpinCodeController;

  @override
  String? get selectedCity => _selectedCity;

  set selectedCity(String? newValue) {
    _selectedCity = newValue;
  }

  @override
  Stream get branchNameStreamController => _branchNameStreamController.stream;

  branchNameStream(bool? streamValue) {
    _branchNameStreamController.add(streamValue);
  }

  @override
  Stream get pinCodeStreamController => _pinCodeStreamController.stream;

  pinCodeStream(bool? streamValue) {
    _pinCodeStreamController.add(streamValue);
  }

  @override
  Future<GetAllBranchesByPaginationModel?> getBranchList() async {
    return _apiCalls.getBranchList();
  }

  @override
  Stream get branchTableStreamController => _branchTableStreamController.stream;

  branchTableStream(bool? streamValue) {
    _branchTableStreamController.add(streamValue);
  }
}
