import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/api_service/service_locator.dart';
import 'package:tlbilling/models/get_model/get_all_customer_by_pagination_model.dart';
import 'package:tlbilling/models/parent_response_model.dart';

abstract class CustomerViewBloc {
  TextEditingController get customerNameFilterController;

  TextEditingController get customerCityTextController;

  TextEditingController get customerMobileNoController;

  Stream get customerTableStreamController;

  Stream get customerNameStreamController;

  Stream get customerMobileNumberStreamController;

  Stream get customerCityStreamController;

  Future<GetAllCustomersByPaginationModel?> getAllCustomersByPagination();

  int get currentPage;
  Stream<int> get pageNumberStream;

  String? get branchName;

  bool? get isMainBranch;
  Future<ParentResponseModel> getBranchName();
}

class CustomerViewBlocImpl extends CustomerViewBloc {
  final _customerMobileNoController = TextEditingController();
  final _customerNameTextController = TextEditingController();
  final _customerCityTextController = TextEditingController();
  final _customerTableStreamController = StreamController.broadcast();
  final _customerNameStreamController = StreamController.broadcast();
  final _customerMobileNumberStreamController = StreamController.broadcast();
  final _customerCityStreamController = StreamController.broadcast();
  final _appServices = getIt<AppServiceUtilImpl>();
  String? _branchName;
  bool? _isMainBranch;

  int _currentPage = 0;
  final _pageNumberStreamController = StreamController<int>.broadcast();

  @override
  TextEditingController get customerMobileNoController =>
      _customerNameTextController;

  @override
  TextEditingController get customerNameFilterController =>
      _customerMobileNoController;

  @override
  TextEditingController get customerCityTextController =>
      _customerCityTextController;

  @override
  Future<GetAllCustomersByPaginationModel?>
      getAllCustomersByPagination() async {
    return _appServices.getAllCustomersByPagination(
        customerCityTextController.text,
        customerMobileNoController.text,
        customerNameFilterController.text,
        currentPage,
        branchName ?? '');
  }

  @override
  Stream get customerTableStreamController =>
      _customerTableStreamController.stream;

  customerTableStream(bool streamValue) {
    _customerTableStreamController.add(streamValue);
  }

  @override
  Stream get customerNameStreamController =>
      _customerNameStreamController.stream;

  customerNameStream(bool streamValue) {
    _customerNameStreamController.add(streamValue);
  }

  @override
  Stream get customerCityStreamController =>
      _customerCityStreamController.stream;

  customerCityStream(bool streamValue) {
    _customerCityStreamController.add(streamValue);
  }

  @override
  Stream get customerMobileNumberStreamController =>
      _customerMobileNumberStreamController.stream;

  customerMobileNumberStream(bool streamValue) {
    _customerMobileNumberStreamController.add(streamValue);
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
  String? get branchName => _branchName;

  set branchName(String? value) {
    _branchName = value;
  }

  @override
  bool? get isMainBranch => _isMainBranch;
  set isMainBranch(bool? value) {
    _isMainBranch = value;
  }

  @override
  Future<ParentResponseModel> getBranchName() {
    return _appServices.getBranchName();
  }
}
