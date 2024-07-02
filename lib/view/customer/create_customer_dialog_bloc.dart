import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_customers_model.dart';
import 'package:tlbilling/models/post_model/add_customer_model.dart';

abstract class CreateCustomerDialogBloc {
  TextEditingController get customerNameTextController;

  TextEditingController get customerMobileNoTextController;

  TextEditingController get customerMailIdTextController;

  TextEditingController get customerAccNoTextController;

  TextEditingController get customerAadharNoTextController;

  TextEditingController get customerCitytextcontroller;

  TextEditingController get customerAddressTextController;

  TextEditingController get customerIFSCTextController;

  GlobalKey<FormState> get customerFormKey;

  bool? get isAsyncCall;

  String? get branchId;

  Future<void> addCustomer(
      Function(int? statusCode, String? customerName, String? customerId)
          onSuccessCallBack);

  Future<GetAllCustomersModel?> getCustomerDetails(String customerId);

  Future<void> updateCustomer(
      String customerId, Function(int statusCode) onSuccessCallBack);
}

class CreateCustomerDialogBlocImpl extends CreateCustomerDialogBloc {
  final _customerFormKey = GlobalKey<FormState>();
  final _customerNameTextController = TextEditingController();
  final _customerMobileNoTextController = TextEditingController();
  final _customerMailIdTextController = TextEditingController();
  final _customerAccNoTextController = TextEditingController();
  final _customerAadharNoTextController = TextEditingController();
  final _customerCityTextController = TextEditingController();
  final _customerAddressTextController = TextEditingController();
  final _customerIFSCTextController = TextEditingController();
  final _apiCalls = AppServiceUtilImpl();
  bool? _isAsyncCall = false;
  String? _branchId;

  @override
  TextEditingController get customerNameTextController =>
      _customerNameTextController;

  @override
  TextEditingController get customerMobileNoTextController =>
      _customerMobileNoTextController;

  @override
  TextEditingController get customerMailIdTextController =>
      _customerMailIdTextController;

  @override
  TextEditingController get customerAccNoTextController =>
      _customerAccNoTextController;

  @override
  TextEditingController get customerAadharNoTextController =>
      _customerAadharNoTextController;

  @override
  TextEditingController get customerCitytextcontroller =>
      _customerCityTextController;

  @override
  TextEditingController get customerAddressTextController =>
      _customerAddressTextController;

  @override
  GlobalKey<FormState> get customerFormKey => _customerFormKey;

  @override
  String? get branchId => _branchId;

  set branchId(String? value) {
    _branchId = value;
  }

  @override
  Future<void> addCustomer(
      Function(int? statusCode, String? customerName, String? customerId)
          onSuccessCallBack) async {
    return await _apiCalls.addCustomer(
        onSuccessCallBack,
        AddCustomerModel(
            aadharNo: customerAadharNoTextController.text,
            address: customerAddressTextController.text,
            mobileNo: customerMobileNoTextController.text,
            accountNo: customerAccNoTextController.text,
            branchId: branchId,
            city: customerCitytextcontroller.text,
            emailId: customerMailIdTextController.text,
            customerName: customerNameTextController.text,
            ifsc: customerIFSCTextController.text));
  }

  @override
  TextEditingController get customerIFSCTextController =>
      _customerIFSCTextController;

  @override
  Future<GetAllCustomersModel?> getCustomerDetails(String customerId) async {
    return await _apiCalls.getCustomerDetails(customerId);
  }

  @override
  Future<void> updateCustomer(
      String customerId, Function(int statusCode) onSuccessCallBack) async {
    return await _apiCalls.updateCustomer(
        customerId,
        AddCustomerModel(
            aadharNo: customerAadharNoTextController.text,
            address: customerAddressTextController.text,
            mobileNo: customerMobileNoTextController.text,
            accountNo: customerAccNoTextController.text,
            city: customerCitytextcontroller.text,
            emailId: customerMailIdTextController.text,
            customerName: customerNameTextController.text,
            ifsc: customerIFSCTextController.text),
        onSuccessCallBack);
  }

  @override
  bool? get isAsyncCall => _isAsyncCall;

  set isAsyncCall(bool? newValue) {
    _isAsyncCall = newValue;
  }
}
