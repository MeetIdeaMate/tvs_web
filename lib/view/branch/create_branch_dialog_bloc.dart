import 'package:flutter/material.dart';

abstract class CreateBranchDialogBloc {
  TextEditingController get branchNameController;
  TextEditingController get cityController;
  TextEditingController get addressController;
  TextEditingController get mobileNoController;
  TextEditingController get pinCodeController;
  String? get selectedMainBranch;
  String? get selectedBranch;
  String? get selectedCity;
  GlobalKey<FormState> get branchFormKey;
}

class CreateBranchDialogBlocImpl extends CreateBranchDialogBloc {
  final _branchNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final _pinCodeController = TextEditingController();
  String? _selectedMainBranch;
  String? _selectedBranch;
  String? _selectCity;
  final _branchFormKey = GlobalKey<FormState>();

  @override
  TextEditingController get addressController => _addressController;

  @override
  TextEditingController get branchNameController => _branchNameController;

  @override
  TextEditingController get cityController => _cityController;

  @override
  TextEditingController get mobileNoController => _mobileNoController;

  @override
  TextEditingController get pinCodeController => _pinCodeController;

  @override
  String? get selectedMainBranch => _selectedMainBranch;
  set selectedMainBranch(String? newValue) {
    _selectedMainBranch = newValue;
  }

  @override
  String? get selectedBranch => _selectedBranch;

  @override
  GlobalKey<FormState> get branchFormKey => _branchFormKey;

  @override
  String? get selectedCity => _selectCity;
  set selectedCity(String? newValue) {
    _selectCity = newValue;
  }

  set selectedBranch(String? newValue) {
    _selectedBranch = newValue;
  }
}
