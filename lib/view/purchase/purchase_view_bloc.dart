import 'dart:async';

import 'package:flutter/material.dart';

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
}
