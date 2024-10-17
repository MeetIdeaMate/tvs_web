import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/update/update_statement_model.dart';

abstract class UpdateStatementDialogBloc {
  TextEditingController get dateTextEditController;
  TextEditingController get amountTextEditController;
  TextEditingController get descriptionTextEditController;
  TextEditingController get chequeTextEditingController;
  GlobalKey<FormState> get formKey;
  Stream<bool> get loadingStream;
  Future<bool> updateStatementSummary(
      String statementId, UpdateStatementModel updateStatementModel);
}

class UpdateStatementDialogBlocImpl extends UpdateStatementDialogBloc {
  final _apiService = AppServiceUtilImpl();
  final _dateTextEditController = TextEditingController();
  final _amountTextEditController = TextEditingController();
  final _descriptionTextEditController = TextEditingController();
  final _chequeTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _loadingStream = StreamController<bool>.broadcast();
  @override
  Stream<bool> get loadingStream => _loadingStream.stream;

  loadingStreamController(bool value) {
    _loadingStream.sink.add(value);
  }

  @override
  TextEditingController get dateTextEditController => _dateTextEditController;
  @override
  TextEditingController get amountTextEditController =>
      _amountTextEditController;
  @override
  TextEditingController get descriptionTextEditController =>
      _descriptionTextEditController;
  @override
  TextEditingController get chequeTextEditingController =>
      _chequeTextEditingController;
  @override
  GlobalKey<FormState> get formKey => _formKey;

  @override
  Future<bool> updateStatementSummary(
      String statementId, UpdateStatementModel updateStatementModel) {
    return _apiService.updateStatementSummary(
        statementId, updateStatementModel);
  }
}
