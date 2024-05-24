import 'package:flutter/material.dart';

abstract class ReportScreenBloc {
  TabController get reportScreenTabController;
}

class ReportScreenBlocImpl extends ReportScreenBloc {
  late TabController _reportScreenTabController;
  @override
  TabController get reportScreenTabController => _reportScreenTabController;

  set reportScreenTabController(TabController newTab) {
    _reportScreenTabController = newTab;
  }
}
