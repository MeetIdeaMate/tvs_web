import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_booking_list_with_pagination.dart';
import 'package:tlbilling/models/get_model/get_configuration_model.dart';
import 'package:tlbilling/models/parent_response_model.dart';
import 'package:tlbilling/utils/app_constants.dart';

abstract class BookingListBloc {
  TextEditingController get bookingIdTextController;

  TextEditingController get customerTextController;

  Stream get bookingIdFieldStreamController;

  Stream get customerFieldStreamController;

  Stream get paymentTypeFieldStreamController;

  String? get selectedPaymentType;

  Future<GetConfigurationModel?> getPaymentsList();

  Future<GetBookingListWithPagination?> getBookingListWithPagination();

  Stream<bool> get bookingTableStream;

  int get currentPage;

  String? get branchId;

  bool? get isMainBranch;

  Stream<int> get pageNumberStream;
  Future<ParentResponseModel> getBranchName();

  Future<void> bookingCancel(
      String? bookingNo, Function(int p1)? onSuccessCallback);
}

class BookingListBlocImpl extends BookingListBloc {
  final _appServices = AppServiceUtilImpl();
  final _bookingIdTextController = TextEditingController();
  final _customerTextController = TextEditingController();
  final _bookingIdFieldStreamController = StreamController.broadcast();
  final _customerFieldStreamController = StreamController.broadcast();
  final _paymentTypeFieldStreamController = StreamController.broadcast();
  final _bookingTableStreamController = StreamController<bool>.broadcast();
  String? _selectedPaymentType;
  int _currentPage = 0;
  final _pageNumberStreamController = StreamController<int>.broadcast();
  String? _branchId;
  bool? _isMainBranch;
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
  Future<ParentResponseModel> getBranchName() {
    return _appServices.getBranchName();
  }

  @override
  String? get selectedPaymentType => _selectedPaymentType;

  set selectedPaymentType(String? newPaymentValue) {
    _selectedPaymentType = newPaymentValue;
  }

  @override
  Future<GetBookingListWithPagination?> getBookingListWithPagination() async {
    return await _appServices.getBookingListWithPagination(
        _currentPage,
        bookingIdTextController.text,
        customerTextController.text,
        selectedPaymentType,
        branchId);
  }

  @override
  Stream<bool> get bookingTableStream => _bookingTableStreamController.stream;

  bookingTableStreamControler(bool value) {
    _bookingTableStreamController.add(value);
  }

  @override
  int get currentPage => _currentPage;

  set currentPage(int value) {
    _currentPage = value;
  }

  @override
  Stream<int> get pageNumberStream => _pageNumberStreamController.stream;

  pageNumberUpdateStreamController(int streamValue) {
    _pageNumberStreamController.add(streamValue);
  }

  @override
  Future<void> bookingCancel(
      String? bookingNo, Function(int p1)? onSuccessCallback) async {
    return _appServices.bookingCancel(bookingNo, onSuccessCallback);
  }

  @override
  String? get branchId => _branchId;
  set branchId(String? value) {
    _branchId = value;
  }

  @override
  bool? get isMainBranch => _isMainBranch;
  set isMainBranch(bool? newValue) {
    _isMainBranch = newValue;
  }
}
