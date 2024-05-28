import 'package:flutter/material.dart';

abstract class PurchaseVehiclesReportBloc {
  String? get selectedVehiclesType;
  TextEditingController get fromDateTextEdit;
  TextEditingController get toDateTextEdit;
}

class PurchaseVehiclesReportBlocImpl extends PurchaseVehiclesReportBloc {
  String? _selectedVehiclesType;
  final _fromDateTextEdit = TextEditingController();
  final _toDateTextEdit = TextEditingController();
  @override
  String? get selectedVehiclesType => _selectedVehiclesType;

  set selectedVehiclesType(String? newValue) {
    _selectedVehiclesType = newValue;
  }

  @override
  TextEditingController get fromDateTextEdit => _fromDateTextEdit;

  @override
  TextEditingController get toDateTextEdit => _toDateTextEdit;
}
