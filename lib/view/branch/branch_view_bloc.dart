import 'package:flutter/material.dart';

abstract class BranchViewBloc {
  TextEditingController get filterBranchnameController;
  TextEditingController get filterpinCodeController;
  String? get selectedCity;
}

class BranchViewBlocImpl extends BranchViewBloc {
  final _filterBranchnameController = TextEditingController();
  final _filterpinCodeController = TextEditingController();
  String? _selectedCity;
  @override
  TextEditingController get filterBranchnameController =>
      _filterBranchnameController;

  @override
  TextEditingController get filterpinCodeController => _filterpinCodeController;

  @override
  String? get selectedCity => _selectedCity;
  set selectedCity(String? newValue) {
    _selectedCity = newValue;
  }
}
