import 'dart:async';

import 'package:flutter/material.dart';

abstract class PurchaseReportBloc {
  TabController get purchaseReportTabController;
  Stream<bool> get tabChangeStreamController;
}

class PurchaseReportBlocImpl extends PurchaseReportBloc {
  late TabController _purchaseReportTabController;
  final _tabChangeStreamController = StreamController<bool>.broadcast();

  @override
  TabController get purchaseReportTabController => _purchaseReportTabController;

  set purchaseReportTabController(TabController newTab) {
    _purchaseReportTabController = newTab;
  }

  @override
  Stream<bool> get tabChangeStreamController =>
      _tabChangeStreamController.stream;

  tabChangeStreamControll(bool newValue) {
    _tabChangeStreamController.add(newValue);
  }
}
