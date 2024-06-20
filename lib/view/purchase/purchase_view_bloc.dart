import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_purchase_model.dart';

abstract class PurchaseViewBloc {
  TextEditingController get invoiceSearchFieldController;

  TextEditingController get partNoSearchFieldController;

  TextEditingController get vehicleSearchFieldController;

  TextEditingController get purchaseRefSearchFieldController;

  TabController get vehicleAndAccessoriesTabController;

  Stream get invoiceSearchFieldControllerStream;

  Stream get partNoSearchFieldControllerStream;

  Stream get vehicleSearchFieldControllerStream;

  Stream get purchaseRefSearchFieldControllerStream;

  Future<GetAllPurchaseByPageNation?> getAllPurchaseList(
      {String? categoryName});

  int get currentPage;
  Stream<int> get pageNumberStream;
  Future<void> createStockFromPurchase(String? purchaseId,
      List<String>? partNumbersList, Function(int)? statusCode);

  Future<void> purchaseBillCancel(
      String? purchaseId, Function(int)? onSuccessCallback);
}

class PurchaseViewBlocImpl extends PurchaseViewBloc {
  final _invoiceSearchFieldController = TextEditingController();
  final _partNoSearchFieldController = TextEditingController();
  final _vehicleSearchFieldController = TextEditingController();
  final _purchaseRefSearchFieldController = TextEditingController();
  final _purchaseRefSearchFieldControllerStream = StreamController.broadcast();
  final _vehicleSearchFieldControllerStream = StreamController.broadcast();
  final _partNoSearchFieldControllerStream = StreamController.broadcast();
  final _invoiceSearchFieldControllerStream = StreamController.broadcast();
  late TabController _vehicleAndAccessoriesTabController;
  final _apiCalls = AppServiceUtilImpl();
  int _currentPage = 0;
  final _pageNumberStreamController = StreamController<int>.broadcast();

  @override
  TextEditingController get invoiceSearchFieldController =>
      _invoiceSearchFieldController;

  @override
  TextEditingController get purchaseRefSearchFieldController =>
      _purchaseRefSearchFieldController;

  @override
  TextEditingController get partNoSearchFieldController =>
      _partNoSearchFieldController;

  @override
  TextEditingController get vehicleSearchFieldController =>
      _vehicleSearchFieldController;

  @override
  Stream get purchaseRefSearchFieldControllerStream =>
      _purchaseRefSearchFieldControllerStream.stream;

  hsnCodeSearchFieldStreamController(bool streamValue) {
    _purchaseRefSearchFieldControllerStream.add(streamValue);
  }

  @override
  Stream get invoiceSearchFieldControllerStream =>
      _invoiceSearchFieldControllerStream.stream;

  invoiceSearchFieldStreamController(bool streamValue) {
    _invoiceSearchFieldControllerStream.add(streamValue);
  }

  @override
  Stream get partNoSearchFieldControllerStream =>
      _partNoSearchFieldControllerStream.stream;

  partNoSearchFieldStreamController(bool streamValue) {
    _partNoSearchFieldControllerStream.add(streamValue);
  }

  @override
  Stream get vehicleSearchFieldControllerStream =>
      _vehicleSearchFieldControllerStream.stream;

  vehicleSearchFieldStreamController(bool streamValue) {
    _vehicleSearchFieldControllerStream.add(streamValue);
  }

  @override
  TabController get vehicleAndAccessoriesTabController =>
      _vehicleAndAccessoriesTabController;

  set vehicleAndAccessoriesTabController(TabController tabValue) {
    _vehicleAndAccessoriesTabController = tabValue;
  }

  @override
  Future<GetAllPurchaseByPageNation?> getAllPurchaseList(
      {String? categoryName}) async {
    return await _apiCalls.getAllPurchaseByPagenation(
        _currentPage,
        invoiceSearchFieldController.text,
        partNoSearchFieldController.text,
        purchaseRefSearchFieldController.text,
        categoryName: categoryName);
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
  Future<void> createStockFromPurchase(String? purchaseId,
      List<String>? partNumbersList, Function(int)? statusCode) async {
    return _apiCalls.createStockFromPurchase(
        purchaseId, partNumbersList, statusCode);
  }

  @override
  Future<void> purchaseBillCancel(
      String? purchaseId, Function(int p1)? onSuccessCallback) async {
    return await _apiCalls.purchaseBillCancel(purchaseId, onSuccessCallback);
  }
}
