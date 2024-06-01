import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/parent_response_model.dart';

abstract class StocksReportBloc {
  TabController get stockReportTabController;
  Future<ParentResponseModel> getBranchName();
}

class StocksReportBlocImpl extends StocksReportBloc {
  late TabController _stockReportTabController;
  final _apiServiceBlocImpl = AppServiceUtilImpl();
  @override
  TabController get stockReportTabController => _stockReportTabController;

  set stockReportTabController(TabController newTab) {
    _stockReportTabController = newTab;
  }

  @override
  Future<ParentResponseModel> getBranchName() {
    return _apiServiceBlocImpl.getBranchName();
  }
}
