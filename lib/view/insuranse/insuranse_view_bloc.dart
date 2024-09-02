import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/api_service/service_locator.dart';
import 'package:tlbilling/models/get_model/get_all_insurance_by_pagination_model.dart';

abstract class InsuranceViewBloc {
  TextEditingController get invoiceNoSearchController;
  TextEditingController get mobileNumberSearchController;
  TextEditingController get customerNameSearchController;
  // Future<GetAllInsuranceByPagination> getAllInsuranceByPagination();
  int get currentPage;
  Stream<int> get pageNumberStream;
  Stream<bool> get invoiceNoStream;
  Stream<bool> get mobileNumberSearchStream;
  Stream<bool> get customerNameSearchStream;
  TabController get insuranseTabController;
  Stream<bool> get tabChangeStreamController;
  Future<GetAllInsuranceByPaginationModel?> getAllInsuranceByPagination();
}

class InsuranceViewBlocImpl extends InsuranceViewBloc {
  final _invoiceNoSearchController = TextEditingController();
  final _mobileNumberSearchController = TextEditingController();
  final _customerNameSearchController = TextEditingController();
  final _appServiceUtilsBlocImpl = getIt<AppServiceUtilImpl>();
  int _currentPage = 0;
  final _pageNumberStreamController = StreamController<int>.broadcast();
  final _invoiceNoStream = StreamController<bool>.broadcast();
  final _mobileNumberStream = StreamController<bool>.broadcast();
  final _customerNameSearchStream = StreamController<bool>.broadcast();
  late TabController _insuranseTabController;
  final _tabChangeStreamController = StreamController<bool>.broadcast();

  @override
  TextEditingController get invoiceNoSearchController =>
      _invoiceNoSearchController;

  @override
  TextEditingController get mobileNumberSearchController =>
      _mobileNumberSearchController;

  @override
  TextEditingController get customerNameSearchController =>
      _customerNameSearchController;

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
  Future<GetAllInsuranceByPaginationModel?> getAllInsuranceByPagination() {
    return _appServiceUtilsBlocImpl.getAllInsuranceByPagination(
      invoiceNoSearchController.text,
      mobileNumberSearchController.text,
      customerNameSearchController.text,
      currentPage,
    );
  }

  @override
  Stream<bool> get invoiceNoStream => _invoiceNoStream.stream;

  invoiceNoStreamController(bool newValue) {
    _invoiceNoStream.add(newValue);
  }

  @override
  Stream<bool> get mobileNumberSearchStream => _mobileNumberStream.stream;
  mobileNumberSearchStreamController(bool newValue) {
    _mobileNumberStream.add(newValue);
  }

  @override
  Stream<bool> get customerNameSearchStream => _customerNameSearchStream.stream;
  customerNameSearchStreamController(bool newValue) {
    _customerNameSearchStream.add(newValue);
  }

  @override
  TabController get insuranseTabController => _insuranseTabController;

  set insuranseTabController(TabController newTab) {
    _insuranseTabController = newTab;
  }

  @override
  Stream<bool> get tabChangeStreamController =>
      _tabChangeStreamController.stream;

  tabChangeStreamControll(bool newValue) {
    _tabChangeStreamController.add(newValue);
  }
}
