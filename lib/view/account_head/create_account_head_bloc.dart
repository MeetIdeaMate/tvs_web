import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_account_head_by_pagination_model.dart';
import 'package:tlbilling/models/post_model/add_account_head.dart';

abstract class CreateAccountBloc {
  TextEditingController get accountCodeTextEditController;
  TextEditingController get accountNameTextEditController;
  TextEditingController get flatAmtTextEditController;
  String? get selectedAccountHeadType;
  String? get selectedPricingFormat;
  bool? get iscashierRequired;
  bool? get isPrint;
  String? get selectedTransferFrom;
  GlobalKey<FormState> get formkey;
  Stream<bool> get radioOnchangeStream;
  Stream<bool> get checkBoxOnChangeStream;
  Stream<bool> get transfterFromStream;
  Future<List<String>> getConfigByIdModel({String? configId});
  Future<void> addAccountHead(
    Function(int? statusCode) onSuccessCallBack,
  );
  Future<GetAllAccount?> getAccountHeadById(String accountId);

  Future<void> updateAccountHead(
      Function(int? statusCode) onSuccessCallBack, String accountId);
}

class CreateAccountBlocImpl extends CreateAccountBloc {
  final _appServiceUtilsImpl = AppServiceUtilImpl();
  final _accountCodeTextEditController = TextEditingController();
  final _accountNameTextEditController = TextEditingController();
  final _flatAmtTextEditController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final _radioOnchangeStream = StreamController<bool>.broadcast();
  final _checkBoxOnChangeStream = StreamController<bool>.broadcast();
  final _transfterFromStream = StreamController<bool>.broadcast();

  String? _selectedAccountHeadType;
  String? _selectedPricingFormat;
  bool? _iscashierRequired = false;
  bool? _isPrint = false;
  String? _selectedTransferFrom;

  @override
  TextEditingController get accountCodeTextEditController =>
      _accountCodeTextEditController;
  @override
  TextEditingController get accountNameTextEditController =>
      _accountNameTextEditController;
  @override
  TextEditingController get flatAmtTextEditController =>
      _flatAmtTextEditController;
  @override
  String? get selectedAccountHeadType => _selectedAccountHeadType;

  set selectedAccountHeadType(String? value) {
    _selectedAccountHeadType = value;
  }

  @override
  String? get selectedPricingFormat => _selectedPricingFormat;

  set selectedPricingFormat(String? value) {
    _selectedPricingFormat = value;
  }

  @override
  bool? get iscashierRequired => _iscashierRequired;

  set iscashierRequired(bool? value) {
    _iscashierRequired = value;
  }

  @override
  bool? get isPrint => _isPrint;

  set isPrint(bool? value) {
    _isPrint = value;
  }

  @override
  String? get selectedTransferFrom => _selectedTransferFrom;

  set selectedTransferFrom(String? value) {
    _selectedTransferFrom = value;
  }

  @override
  GlobalKey<FormState> get formkey => _formkey;

  @override
  Stream<bool> get radioOnchangeStream => _radioOnchangeStream.stream;

  radioOnchangeStreamController(bool value) {
    _radioOnchangeStream.add(value);
  }

  @override
  Stream<bool> get checkBoxOnChangeStream => _checkBoxOnChangeStream.stream;

  checkBoxOnChangeStreamController(bool value) {
    _checkBoxOnChangeStream.add(value);
  }

  @override
  Stream<bool> get transfterFromStream => _transfterFromStream.stream;
  transfterFromStreamController(bool value) {
    _transfterFromStream.add(value);
  }

  @override
  Future<List<String>> getConfigByIdModel({String? configId}) {
    return _appServiceUtilsImpl.getConfigByIdModel(configId: configId);
  }

  @override
  Future<void> addAccountHead(
    Function(int? statusCode) onSuccessCallBack,
  ) {
    return _appServiceUtilsImpl.addAccountHead(
      onSuccessCallBack,
      AccountHeadModel(
        accountHeadCode: _accountCodeTextEditController.text,
        accountHeadName: _accountNameTextEditController.text,
        accountType: _selectedAccountHeadType,
        activeStatus: true,
        cashierOps: _iscashierRequired,
        maxAmount: double.tryParse(flatAmtTextEditController.text),
        minAmount: 0.0,
        needPrinting: _isPrint,
        pricingFormat: _selectedPricingFormat,
        printingTemplate: " ",
        ptVariables: " ",
        transferFrom: _selectedTransferFrom,
        transferTo: " ",
      ),
    );
  }

  @override
  Future<GetAllAccount?> getAccountHeadById(String accountId) {
    return _appServiceUtilsImpl.getAccountHeadById(accountId);
  }

  @override
  Future<void> updateAccountHead(
      Function(int? statusCode) onSuccessCallBack, String accountId) {
    return _appServiceUtilsImpl.updateAccountHead(
        onSuccessCallBack,
        AccountHeadModel(
          accountHeadCode: _accountCodeTextEditController.text,
          accountHeadName: _accountNameTextEditController.text,
          accountType: _selectedAccountHeadType,
          activeStatus: true,
          cashierOps: _iscashierRequired,
          maxAmount: double.tryParse(flatAmtTextEditController.text) ?? 0,
          minAmount: 0.0,
          needPrinting: _isPrint,
          pricingFormat: _selectedPricingFormat,
          printingTemplate: " ",
          ptVariables: " ",
          transferFrom: _selectedTransferFrom,
          transferTo: " ",
        ),
        accountId);
  }
}
