import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/parent_response_model.dart';

abstract class PurchaseReportBloc {
  TabController get purchaseReportTabController;
  Stream<bool> get tabChangeStreamController;
  Future<ParentResponseModel> getBranchName();
}

class PurchaseReportBlocImpl extends PurchaseReportBloc {
  late TabController _purchaseReportTabController;
  final _tabChangeStreamController = StreamController<bool>.broadcast();
  final _apiServiceBlocImpl = AppServiceUtilImpl();

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

  @override
  Future<ParentResponseModel> getBranchName() {
    return _apiServiceBlocImpl.getBranchName();
  }
}
