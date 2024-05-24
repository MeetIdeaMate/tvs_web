import 'package:flutter/material.dart';

abstract class SalesReportBloc {
  TextEditingController get selectedVehicleName;
  TextEditingController get fromDateEditText;
  TextEditingController get toDateEditText;
  TextEditingController get customerNameEditText;
  String? get selectedPayementType;
}

class SaledReportBlocImpl extends SalesReportBloc {
  final _selectedVehicleName = TextEditingController();
  final _fromDateTextFeild = TextEditingController();
  final _toDateEditText = TextEditingController();

  final _customerNameEditText = TextEditingController();
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
}
