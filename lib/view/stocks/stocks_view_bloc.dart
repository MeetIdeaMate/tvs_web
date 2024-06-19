import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_stock_with_pagination.dart';

abstract class StocksViewBloc {
  TextEditingController get partNumberSearchController;

  TextEditingController get vehicleNameSearchController;

  Stream get partNumberSearchControllerStream;

  Stream get vehicleNameSearchControllerStream;

  TabController get stocksTableTableController;
  Future<GetAllStocksByPagenation?> getAllStockByPagenation(String? status);

  int get currentPage;
  Stream<int> get pageNumberStream;
}

class StocksViewBlocImpl extends StocksViewBloc {
  final _partNumberSearchController = TextEditingController();
  final _vehicleNameSearchController = TextEditingController();
  final _partNumberSearchControllerStream = StreamController.broadcast();
  final _vehicleNameSearchControllerStream = StreamController.broadcast();
  late TabController _stocksTableTableController;
  final _apiServices = AppServiceUtilImpl();
  int _currentPage = 0;
  final _pageNumberStreamController = StreamController<int>.broadcast();

  @override
  TextEditingController get partNumberSearchController =>
      _partNumberSearchController;

  @override
  TextEditingController get vehicleNameSearchController =>
      _vehicleNameSearchController;

  @override
  Stream get partNumberSearchControllerStream =>
      _partNumberSearchControllerStream.stream;

  partNumberSearchStreamController(bool streamValue) {
    _partNumberSearchControllerStream.add(streamValue);
  }

  @override
  Stream get vehicleNameSearchControllerStream =>
      _vehicleNameSearchControllerStream.stream;

  vehicleNameSearchStreamController(bool streamValue) {
    _vehicleNameSearchControllerStream.add(streamValue);
  }

  @override
  TabController get stocksTableTableController => _stocksTableTableController;

  set stocksTableTableController(TabController tabValue) {
    _stocksTableTableController = tabValue;
  }

  @override
  int get currentPage => _currentPage;
  set currentPage(int pageValue) {
    _currentPage = pageValue;
  }

  @override
  Future<GetAllStocksByPagenation?> getAllStockByPagenation(
      String? status) async {
    return await _apiServices.getAllStockByPagenation(
        currentPage,
        _partNumberSearchController.text,
        _vehicleNameSearchController.text,
        status);
  }

  @override
  Stream<int> get pageNumberStream => _pageNumberStreamController.stream;

  pageNumberUpdateStreamController(int streamValue) {
    _pageNumberStreamController.add(streamValue);
  }
}
