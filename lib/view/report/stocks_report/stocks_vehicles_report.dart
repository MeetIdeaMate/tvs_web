import 'package:flutter/material.dart';

abstract class StocksVehicleReportBloc {
  String? get vehicleType;
  String? get selectedBranch;
  TextEditingController get fromDateTextEdit;
  TextEditingController get toDateTextEdit;
}

class StocksVehicleReportBlocImpl extends StocksVehicleReportBloc {
  String? _vehicleType;
  String? _selectedBranch;

  final _fromDateTextEdit = TextEditingController();
  final _toDateTextEdit = TextEditingController();

  @override
  String? get vehicleType => _vehicleType;

  set vehicleType(String? newValue) {
    _vehicleType = newValue;
  }

  @override
  String? get selectedBranch => _selectedBranch;

  set selectedBranch(String? newValue) {
    _selectedBranch = newValue;
  }

  @override
  TextEditingController get fromDateTextEdit => _fromDateTextEdit;

  @override
  TextEditingController get toDateTextEdit => _toDateTextEdit;
}
