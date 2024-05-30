import 'dart:async';

import 'package:flutter/material.dart';

abstract class SalesViewBloc {
  TextEditingController get invoiceNoTextController;
  TextEditingController get paymentTypeTextController;
  TextEditingController get customerNameTextController;

  Stream get invoiceNoStream;
  Stream get paymentTypeStream;
  Stream get customerNameStream;

  TabController get salesTabController;
}

class SalesViewBlocImpl extends SalesViewBloc {
  final _invoiceNoController = TextEditingController();
  final _paymentTypeController = TextEditingController();
  final _customerNameController = TextEditingController();

  final _invoiceNoStreamControler = StreamController.broadcast();
  final _paymentTypeStreamController = StreamController.broadcast();
  final _customerNameStreamController = StreamController.broadcast();

  late TabController _salesViewTabController;

  @override
  TextEditingController get customerNameTextController =>
      _customerNameController;

  @override
  TextEditingController get invoiceNoTextController => _invoiceNoController;

  @override
  TextEditingController get paymentTypeTextController => _paymentTypeController;

  @override
  Stream get customerNameStream => _customerNameStreamController.stream;

  customerNameStreamController(bool customerNameStreamValue) {
    _customerNameStreamController.add(customerNameStreamValue);
  }

  @override
  Stream get invoiceNoStream => _invoiceNoStreamControler.stream;

  invoiceNoStreamController(bool invoiceNoStreamValue) {
    _customerNameStreamController.add(invoiceNoStreamValue);
  }

  @override
  Stream get paymentTypeStream => _paymentTypeStreamController.stream;

  paymentTypeStreamController(bool paymentTypeStreamValue) {
    _customerNameStreamController.add(paymentTypeStreamValue);
  }

  @override
  TabController get salesTabController => _salesViewTabController;

  set salesTabController(TabController tabValue) {
    _salesViewTabController = tabValue;
  }
}
