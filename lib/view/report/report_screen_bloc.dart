import 'dart:async';

import 'package:flutter/material.dart';

abstract class ReportScreenBloc {
  TabController get reportScreenTabController;
  Stream<bool> get dropDownChangeStream;
}

class ReportScreenBlocImpl extends ReportScreenBloc {
  late TabController _reportScreenTabController;
  final _dropDownChangeStream = StreamController<bool>.broadcast();
  @override
  TabController get reportScreenTabController => _reportScreenTabController;

  set reportScreenTabController(TabController newTab) {
    _reportScreenTabController = newTab;
  }

  @override
  Stream<bool> get dropDownChangeStream => _dropDownChangeStream.stream;
  dropDownChangeStreamController(bool newValue) {
    _dropDownChangeStream.add(newValue);
  }
}
