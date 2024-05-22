import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tlbilling/utils/app_constants.dart';

abstract class VoucherReceiptListBloc {
  TabController get receiptVoucherTabController;

  TextEditingController get receiptIdTextController;

  Stream get receiptIdStream;

  String? get selectedEmployee;
}

class VoucherReceiptListBlocImpl extends VoucherReceiptListBloc {
  late TabController _receiptVoucherTabController;
  final _receiptIdStream = StreamController.broadcast();
  final _receiptIdTextController = TextEditingController();
  List<String> employeeList = ['Ajith', 'Karthik', 'Senthil'];
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

  @override
  TabController get receiptVoucherTabController => _receiptVoucherTabController;

  set receiptVoucherTabController(TabController tabValue) {
    _receiptVoucherTabController = tabValue;
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
  set selectedEmployee(String? value){
    _selectedEmployee = value;
  }
}
