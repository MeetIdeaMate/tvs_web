import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_configuration_model.dart';
import 'package:tlbilling/utils/app_constants.dart';

abstract class BookingListBloc {
  TextEditingController get bookingIdTextController;

  TextEditingController get customerTextController;

  Stream get bookingIdFieldStreamController;

  Stream get customerFieldStreamController;

  Stream get paymentTypeFieldStreamController;

  String? get selectedPaymentType;

  Future<GetConfigurationModel?> getPaymentsList();
}

class BookingListBlocImpl extends BookingListBloc {
  final _appServices = AppServiceUtilImpl();
  final _bookingIdTextController = TextEditingController();
  final _customerTextController = TextEditingController();
  final _bookingIdFieldStreamController = StreamController.broadcast();
  final _customerFieldStreamController = StreamController.broadcast();
  final _paymentTypeFieldStreamController = StreamController.broadcast();
  String? _selectedPaymentType;

  @override
  Stream get bookingIdFieldStreamController =>
      _bookingIdFieldStreamController.stream;

  bookingIdFieldStream(bool streamValue) {
    _bookingIdFieldStreamController.add(streamValue);
  }

  @override
  TextEditingController get bookingIdTextController => _bookingIdTextController;

  @override
  Stream get customerFieldStreamController =>
      _customerFieldStreamController.stream;

  customerFieldStream(bool streamValue) {
    _customerFieldStreamController.add(streamValue);
  }

  @override
  TextEditingController get customerTextController => _customerTextController;

  @override
  Stream get paymentTypeFieldStreamController =>
      _paymentTypeFieldStreamController.stream;

  paymentTypeFieldStream(bool streamValue) {
    _paymentTypeFieldStreamController.add(streamValue);
  }

  @override
  Future<GetConfigurationModel?> getPaymentsList() async {
    return await _appServices.getConfigById(AppConstants.payments);
  }

  @override
  String? get selectedPaymentType => _selectedPaymentType;

  set selectedPaymentType(String? newPaymentValue) {
    _selectedPaymentType = newPaymentValue;
  }
}
