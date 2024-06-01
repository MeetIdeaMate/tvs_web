import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/parent_response_model.dart';

abstract class NewVoucherBloc {
  TextEditingController get payToTextController;

  TextEditingController get voucherDateTextController;

  TextEditingController get giverTextController;

  TextEditingController get amountTextController;

  Future<ParentResponseModel> getEmployeeName();
  Stream<bool> get payToTextStream;
  Stream<bool> get giverTextStream;
}

class NewVoucherBlocImpl extends NewVoucherBloc {
  final _payToTextController = TextEditingController();
  final _voucherDateTextController = TextEditingController();
  final _giverTextController = TextEditingController();
  final _amountTextController = TextEditingController();
  final _appServiceUtilsImpl = AppServiceUtilImpl();
  final _payToTextStream = StreamController<bool>.broadcast();
  final _giverTextStream = StreamController<bool>.broadcast();

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
}
