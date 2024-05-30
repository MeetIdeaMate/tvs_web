import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_vendor_by_pagination_model.dart';

abstract class VendorViewBloc {
  TextEditingController get vendorNameSearchController;
  TextEditingController get vendorMobNoSearchController;
  TextEditingController get vendorCitySearchController;
  Future<GetAllVendorByPagination> getAllVendorByPagination();
  int get currentPage;
  Stream<int> get pageNumberStream;
  Stream<bool> get vendorNameStream;
  Stream<bool> get vendorMobileNoSearchStream;
  Stream<bool> get vendorCitySearchStream;
}

class VendorViewBlocImpl extends VendorViewBloc {
  final _vendorNameSearchController = TextEditingController();
  final _vendorMobNoSearchController = TextEditingController();
  final _vendorCitySearchController = TextEditingController();
  final _appServiseUtilsBlocImpl = AppServiceUtilImpl();
  int _currentPage = 0;
  final _pageNumberStreamController = StreamController<int>.broadcast();
  final _vendorNameStream = StreamController<bool>.broadcast();
  final _vendorMobileNoStream = StreamController<bool>.broadcast();
  final _vendorCitySearchStream = StreamController<bool>.broadcast();

  @override
  TextEditingController get vendorCitySearchController =>
      _vendorNameSearchController;

  @override
  TextEditingController get vendorMobNoSearchController =>
      _vendorMobNoSearchController;

  @override
  TextEditingController get vendorNameSearchController =>
      _vendorCitySearchController;

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
  Future<GetAllVendorByPagination> getAllVendorByPagination() {
    return _appServiseUtilsBlocImpl.getAllVendorByPagination(
        currentPage,
        vendorNameSearchController.text,
        vendorCitySearchController.text,
        vendorMobNoSearchController.text);
  }

  @override
  Stream<bool> get vendorNameStream => _vendorNameStream.stream;

  vendorNameStreamController(bool newValue) {
    _vendorNameStream.add(newValue);
  }

  @override
  Stream<bool> get vendorMobileNoSearchStream => _vendorMobileNoStream.stream;
  vendorMobileNoSearchStreamController(bool newValue) {
    _vendorMobileNoStream.add(newValue);
  }

  @override
  Stream<bool> get vendorCitySearchStream => _vendorCitySearchStream.stream;
  vendorCitySearchStreamController(bool newValue) {
    _vendorCitySearchStream.add(newValue);
  }
}
