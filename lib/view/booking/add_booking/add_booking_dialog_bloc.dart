import 'package:flutter/cupertino.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_customer_name_list.dart';
import 'package:tlbilling/models/get_model/get_all_employee_model.dart';
import 'package:tlbilling/models/get_model/get_all_stocks_without_pagination.dart';
import 'package:tlbilling/models/get_model/get_booking_by_id_model.dart';
import 'package:tlbilling/models/get_model/get_configuration_model.dart';
import 'package:tlbilling/models/post_model/add_new_booking_model.dart';
import 'package:tlbilling/utils/app_constants.dart';

abstract class AddBookingDialogBloc {
  TextEditingController get bookingDateTextController;

  TextEditingController get customerNameTextController;

  TextEditingController get vehicleNameTextController;

  TextEditingController get additionalInfoTextController;

  TextEditingController get amountTextController;
  TextEditingController get targetInvoiceDateTextController;
  Future<List<GetAllCustomerNameList>?> getCustomerNames();
  String? get branchId;
  String? get selectedPaymentType;
  String? get selectedExcutiveId;
  String? get selectedCustomerId;
  String? get selectedVehiclePartNo;
  Future<List<GetAllStocksWithoutPaginationModel>?> getVehicleList();
  Future<GetConfigurationModel?> getPaymentsList();
  Future<void> addNewBookingDetails(
      BookingModel bookingPostObj, Function(int statusCode) onSuccessCallBack);
  Future<List<GetAllEmployeeModel>?> getAllExcutiveList();
  GlobalKey<FormState> get bookinFormKey;
  bool? get isAsyncCall;
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
  String? _selectedExcutiveId;
  String? _selectedCustomerId;
  String? _selectedVehiclePartNo;
  final _bookingFormKey = GlobalKey<FormState>();
  bool? _isAsyncCall = false;

  @override
  TextEditingController get bookingDateTextController =>
      _bookingDateTextController;

  @override
  TextEditingController get customerNameTextController =>
      _customerNameTextController;

  @override
  Future<List<GetAllCustomerNameList>?> getCustomerNames() async {
    return await _appServices.getAllCustomerList();
  }

  @override
  String? get branchId => _branchId;

  set branchId(String? newValue) {
    _branchId = newValue;
  }

  @override
  Future<List<GetAllStocksWithoutPaginationModel>?> getVehicleList() async {
    return await _appServices.getAllStockList(AppConstants.vehicle, _branchId);
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
    return await _appServices.getConfigById(AppConstants.paymentTypes);
  }

  @override
  TextEditingController get amountTextController => _amountTextController;

  @override
  TextEditingController get targetInvoiceDateTextController =>
      _targetInvoiceDateTextController;

  @override
  Future<void> addNewBookingDetails(BookingModel bookingPostObj,
      Function(int statusCode) onSuccessCallBack) async {
    return await _appServices.addNewBookingDetails(
        bookingPostObj, onSuccessCallBack);
  }

  @override
  Future<List<GetAllEmployeeModel>?> getAllExcutiveList() async {
    return await _appServices.getAllExcutiveList();
  }

  @override
  String? get selectedExcutiveId => _selectedExcutiveId;

  set selectedExcutiveId(String? newValue) {
    _selectedExcutiveId = newValue;
  }

  @override
  String? get selectedCustomerId => _selectedCustomerId;

  set selectedCustomerId(String? newValue) {
    _selectedCustomerId = newValue;
  }

  @override
  GlobalKey<FormState> get bookinFormKey => _bookingFormKey;

  @override
  bool? get isAsyncCall => _isAsyncCall;

  set isAsyncCall(bool? newValue) {
    _isAsyncCall = newValue;
  }

  @override
  String? get selectedVehiclePartNo => _selectedVehiclePartNo;

  set selectedVehiclePartNo(String? newValue) {
    _selectedVehiclePartNo = newValue;
  }
}
