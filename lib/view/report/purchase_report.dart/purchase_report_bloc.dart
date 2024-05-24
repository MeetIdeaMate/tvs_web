import 'package:flutter/material.dart';

abstract class PurchaseReportBloc {
  TextEditingController? get selectedVehicleName;
  TextEditingController? get fromDateEditText;
  TextEditingController? get toDateEditText;
  String? get selectedBillType;
}

class PurchaseReportBlocImpl extends PurchaseReportBloc {
  final _selectedVehicleName = TextEditingController();
  final _fromDateTextFeild = TextEditingController();
  final _toDateEditText = TextEditingController();
  String? _selectedBillType;

  @override
  TextEditingController get fromDateEditText => _fromDateTextFeild;

  @override
  TextEditingController get toDateEditText => _toDateEditText;

  @override
  TextEditingController get selectedVehicleName => _selectedVehicleName;

  @override
  String? get selectedBillType => _selectedBillType;
  set selectedBillType(String? newvalue) {
    _selectedBillType = newvalue;
  }
}
