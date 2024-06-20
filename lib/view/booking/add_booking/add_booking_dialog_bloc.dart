import 'package:flutter/cupertino.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_stocks_without_pagination.dart';
import 'package:tlbilling/models/get_model/get_configuration_model.dart';
import 'package:tlbilling/models/parent_response_model.dart';
import 'package:tlbilling/utils/app_constants.dart';

abstract class AddBookingDialogBloc {
  TextEditingController get bookingDateTextController;

  TextEditingController get customerNameTextController;

  TextEditingController get vehicleNameTextController;

  TextEditingController get additionalInfoTextController;

  TextEditingController get amountTextController;

  TextEditingController get targetInvoiceDateTextController;

  Future<ParentResponseModel> getCustomerNames();

  String? get branchId;

  String? get selectedPaymentType;

  Future<List<GetAllStocksWithoutPaginationModel>?> getVehicleList();

  Future<GetConfigurationModel?> getPaymentsList();
}

class AddBookingDialogBlocImpl extends AddBookingDialogBloc {
  final _appServices = AppServiceUtilImpl();
  final _bookingDateTextController = TextEditingController();
  final _customerNameTextController = TextEditingController();
  final _vehicleNameTextController = TextEditingController();
  final _additionalInfoTextController = TextEditingController();
  final _amountTextController = TextEditingController();
  final _targetInvoiceDateTextController = TextEditingController();
  String? _branchId;
  String? _selectedPaymentType;

  @override
  TextEditingController get bookingDateTextController =>
      _bookingDateTextController;

  @override
  TextEditingController get customerNameTextController =>
      _customerNameTextController;

  @override
  Future<ParentResponseModel> getCustomerNames() async {
    return await _appServices.getAllCustomerList();
  }

  @override
  String? get branchId => _branchId;

  set branchId(String? newValue) {
    _branchId = newValue;
  }

  @override
  Future<List<GetAllStocksWithoutPaginationModel>?> getVehicleList() async {
    return await _appServices.getAllStockList(AppConstants.vehicle, branchId);
  }

  @override
  TextEditingController get vehicleNameTextController =>
      _vehicleNameTextController;

  @override
  TextEditingController get additionalInfoTextController =>
      _additionalInfoTextController;

  @override
  String? get selectedPaymentType => _selectedPaymentType;

  set selectedPaymentType(String? newValue) {
    _selectedPaymentType = newValue;
  }

  @override
  Future<GetConfigurationModel?> getPaymentsList() async {
    return await _appServices.getConfigById(AppConstants.payments);
  }

  @override
  TextEditingController get amountTextController => _amountTextController;

  @override
  TextEditingController get targetInvoiceDateTextController =>
      _targetInvoiceDateTextController;
}
