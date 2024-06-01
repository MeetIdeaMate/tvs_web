import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/parent_response_model.dart';

abstract class GenratePdfDialogBloc {
  Future<ParentResponseModel> getBranchName();
  String? get selectedBranch;
  TextEditingController get fromDateTextEdit;
  TextEditingController get toDateTextEdit;
  GlobalKey<FormState> get formkey;
}

class GenratePdfDialogBlocImpl extends GenratePdfDialogBloc {
  String? _selectedEmpBranch;
  final _appServices = AppServiceUtilImpl();
  final _fromDateTextEdit = TextEditingController();
  final _toDateTextEdit = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Future<ParentResponseModel> getBranchName() {
    return _appServices.getBranchName();
  }

  @override
  String? get selectedBranch => _selectedEmpBranch;

  set selectedBranch(String? newValue) {
    _selectedEmpBranch = newValue;
  }

  @override
  TextEditingController get fromDateTextEdit => _fromDateTextEdit;

  @override
  TextEditingController get toDateTextEdit => _toDateTextEdit;

  @override
  GlobalKey<FormState> get formkey => _formKey;
}
