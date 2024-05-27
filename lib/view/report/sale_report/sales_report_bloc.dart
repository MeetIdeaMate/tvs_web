import 'dart:async';

import 'package:flutter/material.dart';

abstract class SalesReportBloc {
  TextEditingController get selectedVehicleName;
  TextEditingController get fromDateEditText;
  TextEditingController get toDateEditText;
  TextEditingController get customerNameEditText;
  String? get selectedPayementType;
  TabController get salesScreenTabController;
  Stream<bool> get tabChangeStreamController;
}

class SaledReportBlocImpl extends SalesReportBloc {
  final _selectedVehicleName = TextEditingController();
  final _fromDateTextFeild = TextEditingController();
  final _toDateEditText = TextEditingController();

  final _customerNameEditText = TextEditingController();
  final _tabChangeStreamController = StreamController<bool>.broadcast();
  late TabController _salesScreenTabController;
  @override
  TabController get salesScreenTabController => _salesScreenTabController;

  set salesScreenTabController(TabController newTab) {
    _salesScreenTabController = newTab;
  }

  String? _selectedPaymentType;

  @override
  TextEditingController get fromDateEditText => _fromDateTextFeild;

  @override
  TextEditingController get toDateEditText => _toDateEditText;

  @override
  TextEditingController get selectedVehicleName => _selectedVehicleName;

  @override
  TextEditingController get customerNameEditText => _customerNameEditText;

  @override
  String? get selectedPayementType => _selectedPaymentType;

  @override
  Stream<bool> get tabChangeStreamController =>
      _tabChangeStreamController.stream;

  tabChangeStreamControll(bool newValue) {
    _tabChangeStreamController.add(newValue);
  }
}
