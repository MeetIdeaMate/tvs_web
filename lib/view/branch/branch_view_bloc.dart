import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_branches_by_pagination.dart';

abstract class BranchViewBloc {
  TextEditingController get filterBranchNameController;

  TextEditingController get filterpinCodeController;

  String? get selectedCity;

  Stream get branchNameStreamController;

  Stream get pinCodeStreamController;

  Stream get branchTablePageStreamController;

  Future<GetAllBranchesByPaginationModel?> getBranchList();

  int get currentPage;

  Future<void> deleteBranch(
      Function(int statusCode) successCallBack, String branchId);

  bool get isAsyncCall;
}

class BranchViewBlocImpl extends BranchViewBloc {
  final _filterBranchNameController = TextEditingController();
  final _filterPinCodeController = TextEditingController();
  final _branchNameStreamController = StreamController.broadcast();
  final _pinCodeStreamController = StreamController.broadcast();
  final _branchTablePageStreamController = StreamController.broadcast();
  String? _selectedCity;
  final _apiCalls = AppServiceUtilImpl();
  int _currentPage = 0;
  bool _isAsyncCall = false;

  @override
  TextEditingController get filterBranchNameController =>
      _filterBranchNameController;

  @override
  TextEditingController get filterpinCodeController => _filterPinCodeController;

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
    return _apiCalls.getBranchList(currentPage, filterpinCodeController.text,
        filterBranchNameController.text, selectedCity);
  }

  @override
  Stream get branchTablePageStreamController =>
      _branchTablePageStreamController.stream;

  branchTablePageStream(int? streamValue) {
    _branchTablePageStreamController.add(streamValue);
  }

  @override
  int get currentPage => _currentPage;

  set currentPage(int newValue) {
    _currentPage = newValue;
  }

  @override
  Future<void> deleteBranch(
      Function(int statusCode) successCallBack, String branchId) async {
    return _apiCalls.deleteBranch(successCallBack, branchId);
  }

  @override
  bool get isAsyncCall => _isAsyncCall;

  set isAsyncCall(bool value) {
    _isAsyncCall = value;
  }
}
