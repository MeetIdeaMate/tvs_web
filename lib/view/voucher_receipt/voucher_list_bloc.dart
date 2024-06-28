import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_voucher_with_pagenation.dart';
import 'package:tlbilling/models/parent_response_model.dart';
import 'package:tlbilling/utils/app_constants.dart';

abstract class VoucherList {
  TextEditingController get receiptIdTextController;

  Stream get receiptIdStream;

  String? get selectedEmployee;

  Future<ParentResponseModel> getEmployeeName();

  int get currentPage;
  Stream<int> get pageNumberStream;

  Future<GetAllVoucherWithPagenationModel?> getVocherReport();
}

class VoucherListBlocImpl extends VoucherList {
  final _receiptIdStream = StreamController.broadcast();
  final _receiptIdTextController = TextEditingController();
  List<String> employeeList = ['Ajith', 'Karthik', 'Senthil'];
  final __appServiceUtilsImpl = AppServiceUtilImpl();

  List<Map<String, String>> rowData = [
    {
      AppConstants.sno: '1',
      AppConstants.receiptNumber: '87654',
      AppConstants.receiptDate: '28-08-2024',
      AppConstants.vehicleName: 'TVS - Apache',
      AppConstants.color: 'White',
      AppConstants.receivedFrom: 'Ajith',
      AppConstants.paymentType: 'Cash',
      AppConstants.amount: '10,000',
    },
    {
      AppConstants.sno: '2',
      AppConstants.receiptNumber: '3564',
      AppConstants.receiptDate: '30-08-2024',
      AppConstants.vehicleName: 'TVS - Apache',
      AppConstants.color: 'Red',
      AppConstants.receivedFrom: 'Kishore',
      AppConstants.paymentType: 'Card',
      AppConstants.amount: '5,000',
    },
  ];
  List<Map<String, String>> voucherData = [
    {
      AppConstants.sno: '1',
      AppConstants.voucherId: '87654',
      AppConstants.voucherDate: '28-08-2024',
      AppConstants.giver: 'Manager',
      AppConstants.receiver: 'Muthukumar',
      AppConstants.amount: '10,000',
    },
    {
      AppConstants.sno: '2',
      AppConstants.voucherId: '3564',
      AppConstants.voucherDate: '30-08-2024',
      AppConstants.giver: 'Manger',
      AppConstants.receiver: 'RajKumar',
      AppConstants.amount: '5,000',
    },
  ];
  String? _selectedEmployee;
  int _currentPage = 0;
  final _pageNumberStreamController = StreamController<int>.broadcast();

  @override
  int get currentPage => _currentPage;
  set currentPage(int pageValue) {
    _currentPage = pageValue;
  }

  @override
  Stream<int> get pageNumberStream => _pageNumberStreamController.stream;

  pageNumberUpdateStreamController(int streamValue) {
    _pageNumberStreamController.add(streamValue);
  }

  @override
  Stream get receiptIdStream => _receiptIdStream.stream;
  receiptIdStreamController(bool streamValue) {
    _receiptIdStream.add(streamValue);
  }

  @override
  TextEditingController get receiptIdTextController => _receiptIdTextController;

  @override
  String? get selectedEmployee => _selectedEmployee;
  set selectedEmployee(String? value) {
    _selectedEmployee = value;
  }

  @override
  Future<ParentResponseModel> getEmployeeName() {
    return __appServiceUtilsImpl.getEmployeesName();
  }

  @override
  Future<GetAllVoucherWithPagenationModel?> getVocherReport() {
    return __appServiceUtilsImpl.getVoucharRecieptList(
        receiptIdTextController.text, selectedEmployee ?? '', currentPage);
  }
}
