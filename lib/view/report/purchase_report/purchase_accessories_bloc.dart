import 'package:flutter/material.dart';

abstract class PurchaseAccessoriesReportBloc {
  String? get selectedAccessoriesType;
  TextEditingController get fromDateTextEdit;
  TextEditingController get toDateTextEdit;
}

class PurchaseAccessoriesReportBlocImpl extends PurchaseAccessoriesReportBloc {
  String? _selectedAccessoriesType;
  final _fromDateTextEdit = TextEditingController();
  final _toDateTextEdit = TextEditingController();
  @override
  String? get selectedAccessoriesType => _selectedAccessoriesType;

  set selectedAccessoriesType(String? newValue) {
    _selectedAccessoriesType = newValue;
  }

  @override
  TextEditingController get fromDateTextEdit => _fromDateTextEdit;

  @override
  TextEditingController get toDateTextEdit => _toDateTextEdit;
}
