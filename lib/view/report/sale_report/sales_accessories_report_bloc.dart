import 'package:flutter/material.dart';

abstract class SalesAccessoriesReportBloc {
  String? get accessoriesType;
  String? get selectedBranch;
  String? get selectedPaymentType;
  TextEditingController get fromDateTextEdit;
  TextEditingController get toDateTextEdit;
}

class SalesAccessoriesReportBlocImpl extends SalesAccessoriesReportBloc {
  String? _accessoriesType;
  String? _selectedBranch;
  String? _selectedPaymentType;
  final _fromDateTextEdit = TextEditingController();
  final _toDateTextEdit = TextEditingController();

  @override
  String? get accessoriesType => _accessoriesType;

  set accessoriesType(String? newValue) {
    _accessoriesType = newValue;
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
