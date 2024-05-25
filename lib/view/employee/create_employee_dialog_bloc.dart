import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/post_model/add_customer_model.dart';

abstract class CreateEmployeeDialogBloc {
  TextEditingController get empNameController;
  TextEditingController get empMobNoController;
  TextEditingController get empEmailController;
  TextEditingController get empaddressController;
  TextEditingController get empAgeController;
  String? get selectedEmpType;
  String? get selectedEmpBranch;
  String? get selectEmpGender;
  String? get selectEmpCity;
  GlobalKey<FormState> get empFormkey;
}

class CreateEmployeeDialogBlocImpl extends CreateEmployeeDialogBloc {
  final _empNameController = TextEditingController();
  final _empMobNoController = TextEditingController();
  final _empEmailController = TextEditingController();
  final _empAddressController = TextEditingController();
  final _empAgeController = TextEditingController();
  String? _selectedEmpType;
  String? _selectedEmpBranch;
  String? _selectEmpGender;
  String? _selectEmpCity;
  final _empFprmKey = GlobalKey<FormState>();
  final _appServices = AppServiceUtilImpl();

  @override
  TextEditingController get empNameController => _empNameController;

  @override
  TextEditingController get empMobNoController => _empMobNoController;

  @override
  TextEditingController get empEmailController => _empEmailController;

  @override
  TextEditingController get empaddressController => _empAddressController;

  @override
  String? get selectedEmpType => _selectedEmpType!;
  set selectedEmpType(String? value) {
    _selectedEmpType = value!;
  }

  @override
  String? get selectedEmpBranch => _selectedEmpBranch;
  set selectedEmpBranch(String? value) {
    _selectedEmpBranch = value!;
  }

  @override
  String? get selectEmpGender => _selectEmpGender;
  set selectEmpGender(String? value) {
    _selectEmpGender = value!;
  }

  @override
  TextEditingController get empAgeController => _empAgeController;

  @override
  String? get selectEmpCity => _selectEmpCity;
  set selectEmpCity(String? value) {
    _selectEmpCity = value!;
  }

  @override
  GlobalKey<FormState> get empFormkey => _empFprmKey;
}
