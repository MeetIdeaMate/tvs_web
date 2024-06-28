import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/parent_response_model.dart';
import 'package:tlbilling/models/post_model/add_vouchar_model.dart';
import 'package:tlbilling/utils/app_utils.dart';

abstract class NewVoucherBloc {
  TextEditingController get payToTextController;

  TextEditingController get voucherDateTextController;

  TextEditingController get giverTextController;

  TextEditingController get amountTextController;
  TextEditingController get reasonTextController;

  Future<ParentResponseModel> getEmployeeName();
  Future<void> addNewVouchar(Function(int? statusCode) statusCode);
  Stream<bool> get payToTextStream;
  Stream<bool> get giverTextStream;

  GlobalKey<FormState> get formKey;
}

class NewVoucherBlocImpl extends NewVoucherBloc {
  final _payToTextController = TextEditingController();
  final _voucherDateTextController = TextEditingController();
  final _giverTextController = TextEditingController();
  final _amountTextController = TextEditingController();
  final _reasonTextController = TextEditingController();
  final _appServiceUtilsImpl = AppServiceUtilImpl();
  final _payToTextStream = StreamController<bool>.broadcast();
  final _giverTextStream = StreamController<bool>.broadcast();
  final _formKey = GlobalKey<FormState>();

  @override
  TextEditingController get payToTextController => _payToTextController;

  @override
  TextEditingController get voucherDateTextController =>
      _voucherDateTextController;

  @override
  TextEditingController get giverTextController => _giverTextController;

  @override
  TextEditingController get amountTextController => _amountTextController;

  @override
  Future<ParentResponseModel> getEmployeeName() {
    return _appServiceUtilsImpl.getEmployeesName();
  }

  @override
  Stream<bool> get payToTextStream => _payToTextStream.stream;

  @override
  Stream<bool> get giverTextStream => _giverTextStream.stream;

  payToTextStreamController(bool newValue) {
    _payToTextStream.add(newValue);
  }

  giverTextStreamController(bool newValue) {
    _giverTextStream.add(newValue);
  }

  @override
  Future<void> addNewVouchar(Function(int? statusCode) statusCode) {
    return _appServiceUtilsImpl.addNewVouchar(
        AddVocuhar(
            approvedPay: _giverTextController.text,
            paidAmount: double.tryParse(_amountTextController.text) ?? 0,
            paidTo: _payToTextController.text,
            reason: _reasonTextController.text,
            voucherDate:
                AppUtils.appToAPIDateFormat(_voucherDateTextController.text)),
        statusCode);
  }

  @override
  GlobalKey<FormState> get formKey => _formKey;

  @override
  TextEditingController get reasonTextController => _reasonTextController;
}
