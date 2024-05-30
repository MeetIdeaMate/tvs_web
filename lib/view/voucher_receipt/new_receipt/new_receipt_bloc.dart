import 'package:flutter/cupertino.dart';

abstract class NewReceiptBloc {
  TextEditingController get customerNameController;

  TextEditingController get newReceiptDateController;

  TextEditingController get productController;

  TextEditingController get colorController;

  TextEditingController get paymentTypeController;

  TextEditingController get receivedFromController;

  TextEditingController get receivedAmountController;
}

class NewReceiptBlocImpl extends NewReceiptBloc {
  final _customerNameController = TextEditingController();
  final _newReceiptDateController = TextEditingController();
  final _productController = TextEditingController();
  final _paymentTypeController = TextEditingController();
  final _colorController = TextEditingController();
  final _receivedFromController = TextEditingController();
  final _receivedAmountController = TextEditingController();
  List<String> customerList = [
    'Ajithkumar',
    'Arthi',
    'Kamal',
    'kishore',
    'Kannan',
    'MariSelvam'
  ];

  @override
  TextEditingController get customerNameController => _customerNameController;

  @override
  TextEditingController get newReceiptDateController =>
      _newReceiptDateController;

  @override
  TextEditingController get productController => _productController;

  @override
  TextEditingController get colorController => _colorController;

  @override
  TextEditingController get paymentTypeController => _paymentTypeController;

  @override
  TextEditingController get receivedFromController => _receivedFromController;

  @override
  TextEditingController get receivedAmountController =>
      _receivedAmountController;
}
