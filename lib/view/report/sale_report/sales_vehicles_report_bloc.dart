import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_vendor_by_pagination_model.dart';

abstract class SalesVehicleReportBloc {
  String? get vehicleType;
  String? get selectedBranch;
  String? get selectedPaymentType;
  TextEditingController get fromDateTextEdit;
  TextEditingController get toDateTextEdit;
  int get currentPage;
  Stream<int> get pageNumberStream;
  Future<GetAllVendorByPagination?> getPurchaseReport();
}

class SalesVehicleReportBlocImpl extends SalesVehicleReportBloc {
  String? _vehicleType;
  String? _selectedBranch;
  String? _selectedPaymentType;
  final _fromDateTextEdit = TextEditingController();
  final _toDateTextEdit = TextEditingController();
  int _currentPage = 0;
  final _pageNumberStreamController = StreamController<int>.broadcast();
  final _appServiceUtils = AppServiceUtilImpl();

  @override
  String? get vehicleType => _vehicleType;

  set vehicleType(String? newValue) {
    _vehicleType = newValue;
  }

  @override
  String? get selectedBranch => _selectedBranch;

  set selectedBranch(String? newValue) {
    _selectedBranch = newValue;
  }

  @override
  String? get selectedPaymentType => _selectedPaymentType;

  set selectedPaymentType(String? newValue) {
    _selectedPaymentType = newValue;
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
  TextEditingController get fromDateTextEdit => _fromDateTextEdit;

  @override
  TextEditingController get toDateTextEdit => _toDateTextEdit;
  @override
  Future<GetAllVendorByPagination?> getPurchaseReport() {
    return _appServiceUtils.getPurchaseReport(vehicleType ?? '',
        fromDateTextEdit.text, toDateTextEdit.text, currentPage);
  }
}
