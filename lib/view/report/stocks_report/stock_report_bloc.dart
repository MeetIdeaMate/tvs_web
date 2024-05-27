import 'package:flutter/material.dart';

abstract class StocksReportBloc {
  TabController get stockReportTabController;
}

class StocksReportBlocImpl extends StocksReportBloc {
  late TabController _stockReportTabController;
  @override
  TabController get stockReportTabController => _stockReportTabController;

  set stockReportTabController(TabController newTab) {
    _stockReportTabController = newTab;
  }
}
