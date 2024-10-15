import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_statement_summary_model.dart';
import 'package:tlbilling/models/get_model/get_statement_by_id_model.dart';

abstract class StatementCompareBloc {
  Future<Statement> getStatementById(String statementId);
  Future<StatementSummary> getStatementSummary(
      String statementId, String accountType);
  bool get isSummarize;
  bool get isMissMatch;
  bool get isUpdated;
  TextEditingController get fromDateController;
  TextEditingController get toDateController;
  String? get accountType;
  String? get selectedAccountHead;
  Stream<bool> get tableRefreshStream;
  Stream<bool> get matchedChipStream;
  Future<List<String>> getConfigByIdModel();
}

class StatementCompareBlocImpl extends StatementCompareBloc {
  final _apiService = AppServiceUtilImpl();
  bool _isSummarize = false;
  bool _isMissMatch = false;
  bool _isUpdated = false;
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  String? _accountType = 'CREDIT';
  String? _selectedAccountHead;

  List<SummaryDetail>? summaryDetails = [];
  List<BankStatementSummaryList>? bankStatmentDetails = [];
  final _tableRefreshStream = StreamController<bool>.broadcast();
  final _matchedChipStream = StreamController<bool>.broadcast();
  @override
  Future<Statement> getStatementById(String statementId) {
    return _apiService.getStatementById(
        statementId, _fromDateController.text, _toDateController.text);
  }

  @override
  bool get isSummarize => _isSummarize;
  set isSummarize(bool value) {
    _isSummarize = value;
  }

  @override
  Stream<bool> get tableRefreshStream => _tableRefreshStream.stream;

  tableRefreshStreamController(bool value) {
    _tableRefreshStream.add(value);
  }

  @override
  Stream<bool> get matchedChipStream => _matchedChipStream.stream;
  matchedChipStreamController(bool value) {
    _matchedChipStream.add(value);
  }

  @override
  Future<StatementSummary> getStatementSummary(
      String statementId, String accountType) {
    return _apiService.getStatementSUmmary(statementId, accountType,
        _fromDateController.text, _toDateController.text);
  }

  @override
  bool get isMissMatch => _isMissMatch;

  set isMissMatch(bool value) {
    _isMissMatch = value;
  }

  @override
  bool get isUpdated => _isUpdated;

  set isUpdated(bool value) {
    _isUpdated = value;
  }

  @override
  TextEditingController get fromDateController => _fromDateController;
  @override
  TextEditingController get toDateController => _toDateController;
  @override
  String? get accountType => _accountType;

  set accountType(String? value) {
    _accountType = value;
  }

  @override
  Future<List<String>> getConfigByIdModel() {
    return _apiService.getConfigByIdModel(configId: 'accountType');
  }

  @override
  String? get selectedAccountHead => _selectedAccountHead;
  set selectedAccountHead(String? value) {
    _selectedAccountHead = value;
  }
}
