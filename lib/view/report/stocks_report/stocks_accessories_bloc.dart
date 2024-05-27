import 'package:flutter/material.dart';

abstract class StocksAccessoriesReportBloc {
  String? get selectedAccessories;
  String? get selectedBranch;
  TextEditingController get fromDateTextEdit;
  TextEditingController get toDateTextEdit;
}

class StocksAccessoriesReportBlocImpl extends StocksAccessoriesReportBloc {
  String? _selectedAccessories;
  String? _selectedBranch;

  final _fromDateTextEdit = TextEditingController();
  final _toDateTextEdit = TextEditingController();

  @override
  String? get selectedAccessories => _selectedAccessories;

  set selectedAccessories(String? newValue) {
    _selectedAccessories = newValue;
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
