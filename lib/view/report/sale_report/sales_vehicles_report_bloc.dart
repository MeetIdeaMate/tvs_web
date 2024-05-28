import 'package:flutter/material.dart';

abstract class SalesVehicleReportBloc {
  String? get vehicleType;
  String? get selectedBranch;
  String? get selectedPaymentType;
  TextEditingController get fromDateTextEdit;
  TextEditingController get toDateTextEdit;
}

class SalesVehicleReportBlocImpl extends SalesVehicleReportBloc {
  String? _vehicleType;
  String? _selectedBranch;
  String? _selectedPaymentType;
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
  String? get selectedPaymentType => _selectedPaymentType;

  set selectedPaymentType(String? newValue) {
    _selectedPaymentType = newValue;
  }

  @override
  TextEditingController get fromDateTextEdit => _fromDateTextEdit;

  @override
  TextEditingController get toDateTextEdit => _toDateTextEdit;
}
