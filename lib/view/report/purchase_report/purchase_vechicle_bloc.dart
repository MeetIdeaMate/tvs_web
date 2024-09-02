import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/api_service/service_locator.dart';
import 'package:tlbilling/models/get_model/get_all_vendor_by_pagination_model.dart';

abstract class PurchaseVehiclesReportBloc {
  String? get selectedVehiclesType;
  TextEditingController get fromDateTextEdit;
  TextEditingController get toDateTextEdit;
  Future<GetAllVendorByPagination?> getPurchaseReport();
  int get currentPage;
  Stream<int> get pageNumberStream;
}

class PurchaseVehiclesReportBlocImpl extends PurchaseVehiclesReportBloc {
  String? _selectedVehiclesType;
  final _fromDateTextEdit = TextEditingController();
  final _toDateTextEdit = TextEditingController();
  final _appServiceUtils = getIt<AppServiceUtilImpl>();
  int _currentPage = 0;
  final _pageNumberStreamController = StreamController<int>.broadcast();
  @override
  String? get selectedVehiclesType => _selectedVehiclesType;

  set selectedVehiclesType(String? newValue) {
    _selectedVehiclesType = newValue;
  }

  @override
  TextEditingController get fromDateTextEdit => _fromDateTextEdit;

  @override
  TextEditingController get toDateTextEdit => _toDateTextEdit;

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
  Future<GetAllVendorByPagination?> getPurchaseReport() {
    return _appServiceUtils.getPurchaseReport(_selectedVehiclesType ?? '',
        fromDateTextEdit.text, toDateTextEdit.text, currentPage);
  }
}
