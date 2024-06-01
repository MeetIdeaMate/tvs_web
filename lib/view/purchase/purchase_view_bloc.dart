import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_purchase_model.dart';

abstract class PurchaseViewBloc {
  TextEditingController get invoiceSearchFieldController;

  TextEditingController get partNoSearchFieldController;

  TextEditingController get vehicleSearchFieldController;

  TextEditingController get hsnCodeSearchFieldController;

  TabController get vehicleAndAccessoriesTabController;

  Stream get invoiceSearchFieldControllerStream;

  Stream get partNoSearchFieldControllerStream;

  Stream get vehicleSearchFieldControllerStream;

  Stream get hsnCodeSearchFieldControllerStream;

  Future<GetAllPurchaseByPageNation> getAllPurchaseList(int currentPage,
      String employeeName, String city, String designation, String branchName);
}

class PurchaseViewBlocImpl extends PurchaseViewBloc {
  final _invoiceSearchFieldController = TextEditingController();
  final _partNoSearchFieldController = TextEditingController();
  final _vehicleSearchFieldController = TextEditingController();
  final _hsnCodeSearchFieldController = TextEditingController();
  final _hsnCodeSearchFieldControllerStream = StreamController.broadcast();
  final _vehicleSearchFieldControllerStream = StreamController.broadcast();
  final _partNoSearchFieldControllerStream = StreamController.broadcast();
  final _invoiceSearchFieldControllerStream = StreamController.broadcast();
  late TabController _vehicleAndAccessoriesTabController;
  final _apiCalls = AppServiceUtilImpl();

  @override
  TextEditingController get invoiceSearchFieldController =>
      _invoiceSearchFieldController;

  @override
  TextEditingController get hsnCodeSearchFieldController =>
      _hsnCodeSearchFieldController;

  @override
  TextEditingController get partNoSearchFieldController =>
      _partNoSearchFieldController;

  @override
  TextEditingController get vehicleSearchFieldController =>
      _vehicleSearchFieldController;

  @override
  Stream get hsnCodeSearchFieldControllerStream =>
      _hsnCodeSearchFieldControllerStream.stream;

  hsnCodeSearchFieldStreamController(bool streamValue) {
    _hsnCodeSearchFieldControllerStream.add(streamValue);
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
  Future<GetAllPurchaseByPageNation> getAllPurchaseList(
      int currentPage,
      String employeeName,
      String city,
      String designation,
      String branchName) async {
    return await _apiCalls.getAllPurchaseList(
        currentPage, employeeName, city, designation, branchName);
  }
}
