import 'dart:async';

import 'package:flutter/material.dart';

abstract class StocksViewBloc {
  TextEditingController get partNumberSearchController;

  TextEditingController get vehicleNameSearchController;

  Stream get partNumberSearchControllerStream;

  Stream get vehicleNameSearchControllerStream;

  TabController get stocksTableTableController;
}

class StocksViewBlocImpl extends StocksViewBloc {
  final _partNumberSearchController = TextEditingController();
  final _vehicleNameSearchController = TextEditingController();
  final _partNumberSearchControllerStream = StreamController.broadcast();
  final _vehicleNameSearchControllerStream = StreamController.broadcast();
  late TabController _stocksTableTableController;

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
}
