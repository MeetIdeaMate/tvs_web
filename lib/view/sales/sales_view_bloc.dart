import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_sales_list_model.dart';

abstract class SalesViewBloc {
  TextEditingController get invoiceNoTextController;
  TextEditingController get paymentTypeTextController;
  TextEditingController get customerNameTextController;

  Stream<bool> get invoiceNoStream;
  Stream<bool> get paymentTypeStream;
  Stream<bool> get customerNameStream;
  int get currentPage;
  Stream<int> get pageNumberStream;

  TabController get salesTabController;
  Future<GetAllSales?> getSalesList();
}

class SalesViewBlocImpl extends SalesViewBloc {
  final _invoiceNoController = TextEditingController();
  final _paymentTypeController = TextEditingController();
  final _customerNameController = TextEditingController();

  final _invoiceNoStreamControler = StreamController<bool>.broadcast();
  final _paymentTypeStreamController = StreamController<bool>.broadcast();
  final _customerNameStreamController = StreamController<bool>.broadcast();
  final _appServiceUtilBlocImpl = AppServiceUtilImpl();
  int _currentPage = 0;
  final _pageNumberStreamController = StreamController<int>.broadcast();

  @override
  Stream<int> get pageNumberStream => _pageNumberStreamController.stream;

  pageNumberUpdateStreamController(int streamValue) {
    _pageNumberStreamController.add(streamValue);
  }

  late TabController _salesViewTabController;

  @override
  TextEditingController get customerNameTextController =>
      _customerNameController;

  @override
  TextEditingController get invoiceNoTextController => _invoiceNoController;

  @override
  TextEditingController get paymentTypeTextController => _paymentTypeController;

  @override
  Stream<bool> get customerNameStream => _customerNameStreamController.stream;

  customerNameStreamController(bool customerNameStreamValue) {
    _customerNameStreamController.add(customerNameStreamValue);
  }

  @override
  Stream<bool> get invoiceNoStream => _invoiceNoStreamControler.stream;

  invoiceNoStreamController(bool invoiceNoStreamValue) {
    _invoiceNoStreamControler.add(invoiceNoStreamValue);
  }

  @override
  Stream<bool> get paymentTypeStream => _paymentTypeStreamController.stream;

  paymentTypeStreamController(bool paymentTypeStreamValue) {
    _paymentTypeStreamController.add(paymentTypeStreamValue);
  }

  @override
  TabController get salesTabController => _salesViewTabController;

  set salesTabController(TabController tabValue) {
    _salesViewTabController = tabValue;
  }

  @override
  Future<GetAllSales?> getSalesList() {
    return _appServiceUtilBlocImpl.getSalesList(
        invoiceNoTextController.text,
        paymentTypeTextController.text,
        customerNameTextController.text,
        currentPage);
  }

  @override
  int get currentPage => _currentPage;
  set currentPage(int pageValue) {
    _currentPage = pageValue;
  }
}
