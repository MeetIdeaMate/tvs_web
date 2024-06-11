import 'package:flutter/cupertino.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_customerName_List.dart';
import 'package:tlbilling/models/parent_response_model.dart';

abstract class NewReceiptBloc {
  TextEditingController get customerNameController;

  TextEditingController get newReceiptDateController;

  TextEditingController get productController;

  TextEditingController get colorController;

  TextEditingController get paymentTypeController;

  TextEditingController get receivedFromController;

  TextEditingController get receivedAmountController;

  Future<List<String>> getConfigById();

  GlobalKey<FormState> get formKey;

  Future<ParentResponseModel> getAllCustomerList();

  Future<ParentResponseModel> getEmployeeName();
}

class NewReceiptBlocImpl extends NewReceiptBloc {
  final _customerNameController = TextEditingController();
  final _newReceiptDateController = TextEditingController();
  final _productController = TextEditingController();
  final _paymentTypeController = TextEditingController();
  final _colorController = TextEditingController();
  final _receivedFromController = TextEditingController();
  final _receivedAmountController = TextEditingController();
  final _apiSericeUtils = AppServiceUtilImpl();
  final _formKey = GlobalKey<FormState>();
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

  @override
  Future<List<String>> getConfigById() {
    return _apiSericeUtils.getConfigByIdModel(configId: 'Payments');
  }

  @override
  GlobalKey<FormState> get formKey => _formKey;

  @override
  Future<ParentResponseModel> getAllCustomerList() {
    return _apiSericeUtils.getAllCustomerList();
  }

  @override
  Future<ParentResponseModel> getEmployeeName() {
    return _apiSericeUtils.getEmployeesName();
  }
}
