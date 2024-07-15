import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_category_model.dart';
import 'package:tlbilling/models/get_model/get_all_customer_name_list.dart';
import 'package:tlbilling/models/get_model/get_all_customers_model.dart';
import 'package:tlbilling/models/get_model/get_all_stocks_model.dart';
import 'package:tlbilling/models/get_model/get_configuration_model.dart';
import 'package:tlbilling/models/get_model/get_customer_booking_details.dart';
import 'package:tlbilling/models/post_model/add_sales_model.dart';
import 'package:tlbilling/utils/app_constants.dart';

abstract class AddSalesBloc {
  Stream get selectedVehicleAndAccessoriesStream;
  Stream get vehicleAndEngineNumberStream;
  Stream get changeVehicleAndAccessoriesListStream;
  Stream get selectedVehicleAndAccessoriesListStream;
  Stream get accessoriesIncrementStream;
  Stream get selectedCustomerDetailsViewStream;
  Stream get availableVehicleListStreamController;
  Stream get selectedVehiclesListStream;
  Stream get selectedAccessoriesListStream;
  Stream get selectedItemStreamController;
  Stream get availableAccListStreamController;
  Stream<List<GetAllStockDetails>> get filteredAccListStreamController;
  Stream<bool> get paymentDetailsStream;
  Stream<bool> get paymentOptionStream;
  Stream<bool> get isSplitPaymentStream;
  Stream<bool> get batteryDetailsRefreshStream;
  Stream<bool> get mandatoryRefereshStream;
  Stream<bool> get customerSelectstream;
  Stream<bool> get splitPaymentCheckBoxStream;
  Stream<bool> get advanceAmountRefreshStream;
  Stream<bool> get gstDetailsStream;
  Stream<bool> get screenChangeStream;
  Stream<bool> get refreshsalesDataTable;

  Map<String, int> get totalAccessoriesQty;

  TextEditingController get discountTextController;
  TextEditingController get transporterVehicleNumberController;
  TextEditingController get vehicleNoAndEngineNoSearchController;
  TextEditingController get unitRateControllers;
  TextEditingController get hsnCodeTextController;
  TextEditingController get betteryNameTextController;
  TextEditingController get batteryCapacityTextController;
  TextEditingController get empsIncentiveTextController;
  TextEditingController get stateIncentiveTextController;
  TextEditingController get paidAmountController;
  TextEditingController get paymentTypeIdTextController;
  TextEditingController get quantityTextController;
  TextEditingController get unitRateTextController;

  GlobalKey<FormState> get paymentFormKey;

  String? get selectedVehicleAndAccessories;
  String? get selectedBranch;
  String? get selectedCustomer;

  List<Widget> get selectedItems;
  List<GetAllStockDetails>? get vehicleData;
  List<GetAllStockDetails>? get accessoriesData;

  List<SalesItemDetail>? get accessoriesItemList;
  Map<String, String> get selectedMandatoryAddOns;

  GlobalKey<FormState> get accessoriesEntryFormkey;

  Stream<bool> get selectedSalesStreamItems;
  Map<int, String> get unitRates;

  Map<int, String> get splitPaymentAmt;

  Map<int, String> get splitPaymentId;

  Map<int, String> get paymentName;

  Map<String, int> get accessoriesQty;

  int get salesIndex;

  double? get totalValue;
  double? get taxableValue;
  double? get totalInvAmount;
  double? get invAmount;
  double? get igstAmount;
  double? get cgstAmount;
  double? get sgstAmount;
  double? get totalUnitRate;
  double? get advanceAmt;
  double? get toBePayedAmt;
  double? get totalQty;

  String get selectedTypeTools;
  String get selectedTypeManualBook;
  String get selectedTypeDuplicateKeys;
  String? get selectedGstType;
  String? get branchId;
  String? get selectedPaymentList;

  bool get isDiscountChecked;
  bool get isInsurenceChecked;
  bool get isSplitPayment;
  bool get isAccessoriestable;
  String? get selectedPaymentOption;
  Map<String, String> get batteryDetailsMap;
  Future<GetAllCustomersModel?> getCustomerById();

  Future<List<GetAllCustomerNameList>?> getAllCustomerList();

  Future<GetAllCategoryListModel?> getAllCategoryList();
  Future<List<GetCustomerBookingDetails>?> getCustomerBookingDetails(
      String? customerId);

  Future<List<String>> getPaymentmethods();
  Future<List<String>> getBatteryDetails();
  Future<List<String>> getMandantoryAddOns();
  Future<GetConfigurationModel?> getPaymentsList();
  Stream<List<GetAllStockDetails>> get vehicleListStream;
// List<Map<String, String>> get vehicleData;
  List<GetAllStockDetails> get filteredVehicleData;
  String? get selectedCustomerId;

  Future<List<GetAllStockDetails>?> getStockDetails();
  Future<void> addNewSalesDeatils(
      AddSalesModel salesdata, Function(int value) onSuccessCallBack);
  List<String> get gstTypeOptions;
  Stream<bool> get gstRadioBtnRefreashStream;
  TextEditingController get cgstPresentageTextController;
  TextEditingController get igstPresentageTextController;

  FocusNode get unitRateFocus;
  FocusNode get hsnCodeFocus;
  FocusNode get cgstFocus;
  FocusNode get discountFocus;
  FocusNode get igstFocus;
  FocusNode get stateIncentiveFocus;
  FocusNode get empsIncentiveFocus;
  FocusNode get quantityFocus;
  bool? get isTableDataVerifited;
  double? get totalDiscount;
  Stream<bool> get unitRateChangeStream;
  String? get bookingId;
}

class AddSalesBlocImpl extends AddSalesBloc {
  final _apiServices = AppServiceUtilImpl();
  final _selectedVehicleAndAccessoriesStream = StreamController.broadcast();
  final _changeVehicleAndAccessoriesListStream = StreamController.broadcast();
  final _vehicleAndEngineNumberStream = StreamController.broadcast();
  final _screenChangeStream = StreamController<bool>.broadcast();

  final _accessoriesIncrementStream = StreamController.broadcast();
  final _selectedVehicleAndAccessoriesListStream = StreamController.broadcast();
  final _selectedSalesStreamController = StreamController<bool>.broadcast();
  final _discountTextController = TextEditingController();
  final _transporterVehicleNumberController = TextEditingController();
  final _vehicleNoAndEngineNoSearchController = TextEditingController();
  final _unitRateControllers = TextEditingController();
  final _paidAmountController = TextEditingController();
  final _paymentTypeIdTextController = TextEditingController();
  final _quantityTextController = TextEditingController();
  final _unitRateTextController = TextEditingController();
  String? _bookingId;
  final Map<int, String> _unitRate = {};
  final Map<String, int> _accessoriesQty = {};
  final Map<String, String> _batteryDetailsMap = {};
  final Map<int, String> _paymentName = {};

  bool _isAccessoriestable = false;

  double? _totalDiscount = 0;

  final List<SalesItemDetail> _accessoriesItemList = [];

  final _accessoriesEntryFormkey = GlobalKey<FormState>();

  final _hsnCodeTextController = TextEditingController();
  final _cgstPresentageTextController = TextEditingController();
  final _igstPresentageTextController = TextEditingController();
  final _empsInsentivetextEditController = TextEditingController();
  final _stateInsentivetextEditController = TextEditingController();
  final _refreshsalesDataTable = StreamController<bool>.broadcast();
  final _availableVehicleListStreamController = StreamController.broadcast();
  final __availableAccListStreamController = StreamController.broadcast();
  final _filteredAccListStreamController =
      StreamController<List<GetAllStockDetails>>.broadcast();
  final _paymentDetailsStream = StreamController<bool>.broadcast();
  final _custerNameSelectStream = StreamController<bool>.broadcast();

  final _betteryNameTextController = TextEditingController();
  final _batteryCapacityTextController = TextEditingController();
  final _gstRadioBtnRefreashStream = StreamController<bool>.broadcast();
  final _paymentOptionStream = StreamController<bool>.broadcast();
  final _isSplitPaymentStream = StreamController<bool>.broadcast();
  final _batteryDetailsRefreshStream = StreamController<bool>.broadcast();
  final _mandatoryAddOnsRefreshStream = StreamController<bool>.broadcast();
  final _advanceAmountRefreshStreamController =
      StreamController<bool>.broadcast();
  String? _branchId;

  List<String> selectedVehicleList = [];

  final Map<int, String> _splitPaymentAmt = {};

  final _selectedItemStreamController = StreamController.broadcast();
  List<GetAllStockDetails>? selectedVehiclesList = [];

  List<GetAllStockDetails>? slectedAccessoriesList = [];

  Map<String, String> _selectedMandatoryAddOns = {};

  late Set<String> optionsSet = {selectedVehicleAndAccessories ?? 'M-vehicle'};
  String? _selectedVehicleAndAccessories = 'M-vehicle';
  String? _selectedBranch;
  String? _selectedCustomer;
  int? _availableAccessoriesQty;
  String? _selectedPaymentList = 'CASH';
  int initialValue = 0;
  final List<Widget> _selectedItems = [];
  int? _salesIndex = 0;
  String? _selectedGstType = AppConstants.gstPercent;
  bool _isDiscountChecked = false;
  bool _isInsurenceChecked = false;
  List<GetAllStockDetails>? _vehicleDatas = [];
  List<GetAllStockDetails>? _accessoriesData = [];
  ValueNotifier<int> initialValueNotifier = ValueNotifier<int>(0);

  final List<String> _gstTypeOptions = ['GST %', 'IGST %'];
  @override
  List<String> get gstTypeOptions => _gstTypeOptions;

  void incrementInitialValue() {
    initialValueNotifier.value++;
  }

  void decrementInitialValue() {
    if (initialValueNotifier.value > 0) {
      initialValueNotifier.value--;
    }
  }

  final _selectedVehiclesListStream = StreamController.broadcast();

  final _selectedAccessoriesListStream = StreamController.broadcast();

  final _selectedCustomerDetailsViewStream = StreamController.broadcast();

  final _splitPaymentCheckBoxStream = StreamController<bool>.broadcast();
  final _gstDetailsStreamController = StreamController<bool>.broadcast();
  final _unitRateChangeStream = StreamController<bool>.broadcast();

  final Map<String, int> _totalAccessoriesQty = {};
  final _paymentFormKey = GlobalKey<FormState>();
  String? _selectedPaymentOption = AppConstants.pay;
  String? _selectedCustomerId;
  double? _taxableValue;
  double? _totalValue;
  double? _totalInvAmount;
  double? _invAmount;
  double? _igstAmount;
  double? _cgstAmount;
  double? _sgstAmount;
  double? _totalUnitRate;
  double? _advanceAmt;
  double? _toBePayedAmt;
  double? _totalQty;

  bool _isSplitPayment = false;
  final _vehicleListStreamController =
      StreamController<List<GetAllStockDetails>>.broadcast();
  final _unitRateFocus = FocusNode();
  final _hsnCodeFocus = FocusNode();
  final _cgstFocus = FocusNode();
  final _discountFocus = FocusNode();
  final _igstFocus = FocusNode();
  final _stateIncentiveFocus = FocusNode();
  final _empsIncentiveFocus = FocusNode();
  final _quantityFocus = FocusNode();

  bool? _isTableDataVerifited = false;

  @override
  Stream get availableAccListStreamController =>
      __availableAccListStreamController.stream;

  availableAccListStream(bool? streamValue) {
    __availableAccListStreamController.add(streamValue);
  }

  final List<GetAllStockDetails> filteredAccessoriesList = [];

  List<GetAllStockDetails> _filteredVehicleData = [];

  @override
  String? get selectedVehicleAndAccessories => _selectedVehicleAndAccessories;

  set selectedVehicleAndAccessories(String? newValue) {
    _selectedVehicleAndAccessories = newValue;
  }

  @override
  Stream<List<GetAllStockDetails>> get filteredAccListStreamController =>
      _filteredAccListStreamController.stream;

  filteredAccListStream(List<GetAllStockDetails> streamValue) {
    _filteredAccListStreamController.add(streamValue);
  }

  @override
  Stream get availableVehicleListStreamController =>
      _availableVehicleListStreamController.stream;

  availableVehicleListStream(bool? streamValue) {
    _availableVehicleListStreamController.add(streamValue);
  }

  @override
  List<GetAllStockDetails>? get vehicleData => _vehicleDatas;
  set vehicleData(List<GetAllStockDetails>? newValue) {
    _vehicleDatas = newValue;
  }

  @override
  Stream get selectedVehicleAndAccessoriesStream =>
      _selectedVehicleAndAccessoriesStream.stream;

  selectedVehicleAndAccessoriesStreamController(bool streamValue) {
    _selectedVehicleAndAccessoriesStream.add(streamValue);
  }

  changeSegmentedColor(Color color) {
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return color;
      }
      return null;
    });
  }

  @override
  Stream get vehicleAndEngineNumberStream =>
      _vehicleAndEngineNumberStream.stream;

  vehicleAndEngineNumberStreamController(bool streamValue) {
    _vehicleAndEngineNumberStream.add(streamValue);
  }

  @override
  TextEditingController get discountTextController => _discountTextController;

  @override
  Stream get changeVehicleAndAccessoriesListStream =>
      _changeVehicleAndAccessoriesListStream.stream;

  changeVehicleAndAccessoriesListStreamController(bool streamValue) {
    _changeVehicleAndAccessoriesListStream.add(streamValue);
  }

  @override
  Stream get selectedVehicleAndAccessoriesListStream =>
      _selectedVehicleAndAccessoriesListStream.stream;

  selectedVehicleAndAccessoriesListStreamController(bool streamValue) {
    _selectedVehicleAndAccessoriesListStream.add(streamValue);
  }

  @override
  Stream get selectedItemStreamController =>
      _selectedItemStreamController.stream;

  selectedItemStream(bool? streamValue) {
    _selectedItemStreamController.add(streamValue);
  }

  @override
  Stream get accessoriesIncrementStream => _accessoriesIncrementStream.stream;

  accessoriesIncrementStreamController(bool streamValue) {
    _accessoriesIncrementStream.add(streamValue);
  }

  @override
  String? get selectedBranch => _selectedBranch;

  set selectedBranch(String? newValue) {
    _selectedBranch = newValue;
  }

  @override
  TextEditingController get transporterVehicleNumberController =>
      _transporterVehicleNumberController;

  @override
  List<Widget> get selectedItems => _selectedItems;

  @override
  Stream<bool> get selectedSalesStreamItems =>
      _selectedSalesStreamController.stream;

  selectedSalesStreamController(bool streamValue) {
    _selectedSalesStreamController.add(streamValue);
  }

  @override
  int get salesIndex => _salesIndex!;
  set salesIndex(int value) {
    _salesIndex = value;
  }

  @override
  bool get isDiscountChecked => _isDiscountChecked;

  set isDiscountChecked(bool discountValue) {
    _isDiscountChecked = discountValue;
  }

  @override
  bool get isInsurenceChecked => _isInsurenceChecked;

  set isInsurenceChecked(bool insurenceValue) {
    _isInsurenceChecked = insurenceValue;
  }

  @override
  String? get selectedPaymentOption => _selectedPaymentOption;

  set selectedPaymentOption(String? paymentOption) {
    _selectedPaymentOption = paymentOption;
  }

  @override
  TextEditingController get vehicleNoAndEngineNoSearchController =>
      _vehicleNoAndEngineNoSearchController;

  @override
  Future<List<GetAllCustomerNameList>?> getAllCustomerList() async {
    return await _apiServices.getAllCustomerList();
  }

  @override
  Future<List<String>> getPaymentmethods() async {
    return await _apiServices.getConfigByIdModel(configId: 'paymentMethod');
  }

  @override
  String? get selectedCustomer => _selectedCustomer;

  set selectedCustomer(String? selectedValue) {
    _selectedCustomer = selectedValue;
  }

  @override
  Stream<List<GetAllStockDetails>> get vehicleListStream =>
      _vehicleListStreamController.stream;

  vehicleListStreamController(List<GetAllStockDetails> streamValue) {
    _vehicleListStreamController.add(streamValue);
  }

  @override
  Stream get selectedVehiclesListStream => _selectedVehiclesListStream.stream;

  selectedVehiclesListStreamController(bool streamValue) {
    _selectedVehiclesListStream.add(streamValue);
  }

// @override
// List<Map<String, String>> get vehicleData => _vehicleData;

  @override
  List<GetAllStockDetails> get filteredVehicleData => _filteredVehicleData;

  set filteredVehicleData(List<GetAllStockDetails> vehicleData) {
    _filteredVehicleData = vehicleData;
  }

  @override
  String? get selectedCustomerId => _selectedCustomerId;

  set selectedCustomerId(String? value) {
    _selectedCustomerId = value;
  }

  @override
  Future<List<GetAllStockDetails>?> getStockDetails({String? category}) async {
    return await _apiServices.getStockList(category);
  }

  @override
  Future<GetAllCustomersModel?> getCustomerById() {
    return _apiServices.getCustomerDetails(selectedCustomerId ?? '');
  }

  @override
  Stream get selectedCustomerDetailsViewStream =>
      _selectedCustomerDetailsViewStream.stream;

  selectedCustomerDetailsStreamController(bool newValue) {
    _selectedCustomerDetailsViewStream.add(newValue);
  }

  @override
  Future<GetAllCategoryListModel?> getAllCategoryList() async {
    return _apiServices.getAllCategoryList();
  }

  @override
  List<GetAllStockDetails>? get accessoriesData => _accessoriesData;

  set accessoriesData(List<GetAllStockDetails>? newValue) {
    _accessoriesData = newValue;
  }

  @override
  Stream get selectedAccessoriesListStream =>
      _selectedAccessoriesListStream.stream;

  selectedAccessoriesListStreamController(bool newValue) {
    _selectedAccessoriesListStream.add(newValue);
  }

  String _selectedTypeTools = 'YES';
  String _selectedTypeManualBook = 'YES';
  String _selectedTypeDuplicateKeys = 'YES';

  @override
  String get selectedTypeTools => _selectedTypeTools;

  set selectedTypeTools(String value) {
    _selectedTypeTools = value;
  }

  @override
  String get selectedTypeManualBook => _selectedTypeManualBook;

  set selectedTypeManualBook(String value) {
    _selectedTypeManualBook = value;
  }

  @override
  String? get selectedGstType => _selectedGstType;
  set selectedGstType(String? value) {
    _selectedGstType = value;
  }

  @override
  String get selectedTypeDuplicateKeys => _selectedTypeDuplicateKeys;

  set selectedTypeDuplicateKeys(String value) {
    _selectedTypeDuplicateKeys = value;
  }

  @override
  TextEditingController get batteryCapacityTextController =>
      _batteryCapacityTextController;

  @override
  TextEditingController get betteryNameTextController =>
      _betteryNameTextController;

  @override
  Stream<bool> get gstRadioBtnRefreashStream =>
      _gstRadioBtnRefreashStream.stream;

  gstRadioBtnRefreashStreamController(bool newValue) {
    _gstRadioBtnRefreashStream.add(newValue);
  }

  @override
  TextEditingController get cgstPresentageTextController =>
      _cgstPresentageTextController;

  @override
  TextEditingController get igstPresentageTextController =>
      _igstPresentageTextController;

  @override
  TextEditingController get hsnCodeTextController => _hsnCodeTextController;
  final Map<int, String> _splitPaymentId = {};

  @override
  Stream<bool> get paymentDetailsStream => _paymentDetailsStream.stream;
  paymentDetailsStreamController(bool newValue) {
    _paymentDetailsStream.add(newValue);
  }

  @override
  double? get cgstAmount => _cgstAmount;

  set cgstAmount(double? cgst) {
    _cgstAmount = cgst;
  }

  @override
  TextEditingController get empsIncentiveTextController =>
      _empsInsentivetextEditController;

  @override
  double? get igstAmount => _igstAmount;
  set igstAmount(double? igst) {
    _igstAmount = igst;
  }

  @override
  double? get invAmount => _invAmount;
  set invAmount(double? inv) {
    _invAmount = inv;
  }

  @override
  double? get sgstAmount => _sgstAmount;
  set sgstAmount(double? sgst) {
    _sgstAmount = sgst;
  }

  @override
  TextEditingController get stateIncentiveTextController =>
      _stateInsentivetextEditController;

  @override
  double? get taxableValue => _taxableValue;
  set taxableValue(double? value) {
    _taxableValue = value;
  }

  @override
  double? get totalInvAmount => _totalInvAmount;
  set totalInvAmount(double? value) {
    _totalInvAmount = value;
  }

  @override
  double? get totalValue => _totalValue;
  set totalValue(double? value) {
    _totalValue = value;
  }

  @override
  Stream<bool> get paymentOptionStream => _paymentOptionStream.stream;

  paymentOptionStreamController(bool newValue) {
    _paymentOptionStream.add(newValue);
  }

  @override
  bool get isSplitPayment => _isSplitPayment;
  set isSplitPayment(bool value) {
    _isSplitPayment = value;
  }

  @override
  Stream<bool> get isSplitPaymentStream => _isSplitPaymentStream.stream;
  isSplitPaymentStreamController(bool newValue) {
    _isSplitPaymentStream.add(newValue);
  }

  @override
  TextEditingController get unitRateControllers => _unitRateControllers;
  ValueNotifier<double> totalValueNotifier = ValueNotifier<double>(0.0);

  @override
  double? get totalUnitRate => _totalUnitRate;
  set totalUnitRate(double? value) {
    _totalUnitRate = value;
  }

  @override
  double? get advanceAmt => _advanceAmt;
  set advanceAmt(double? value) {
    _advanceAmt = value;
  }

  @override
  double? get toBePayedAmt => _toBePayedAmt;
  set toBePayedAmt(double? value) {
    _toBePayedAmt = value;
  }

  @override
  FocusNode get cgstFocus => _cgstFocus;

  @override
  FocusNode get discountFocus => _discountFocus;

  @override
  FocusNode get empsIncentiveFocus => _empsIncentiveFocus;

  @override
  FocusNode get hsnCodeFocus => _hsnCodeFocus;

  @override
  FocusNode get igstFocus => _igstFocus;

  @override
  FocusNode get stateIncentiveFocus => _stateIncentiveFocus;

  @override
  FocusNode get unitRateFocus => _unitRateFocus;

  @override
  GlobalKey<FormState> get paymentFormKey => _paymentFormKey;

  @override
  Future<List<String>> getMandantoryAddOns() async {
    return await _apiServices.getConfigByIdModel(configId: 'mAddons');
  }

  @override
  Stream<bool> get batteryDetailsRefreshStream =>
      _batteryDetailsRefreshStream.stream;
  batteryDetailsRefreshStreamController(bool newValue) {
    _batteryDetailsRefreshStream.add(newValue);
  }

  @override
  Stream<bool> get mandatoryRefereshStream =>
      _mandatoryAddOnsRefreshStream.stream;
  mandatoryRefereshStreamController(bool newValue) {
    _mandatoryAddOnsRefreshStream.add(newValue);
  }

  @override
  Future<List<String>> getBatteryDetails() async {
    return await _apiServices.getConfigByIdModel(
        configId: 'eVehicleComponents');
  }

  @override
  Map<String, String> get selectedMandatoryAddOns => _selectedMandatoryAddOns;
  set selectedMandatoryAddOns(Map<String, String> value) {
    _selectedMandatoryAddOns = value;
  }

  @override
  Map<int, String> get unitRates => _unitRate;

  @override
  Map<String, int> get accessoriesQty => _accessoriesQty;

  @override
  Future<void> addNewSalesDeatils(
      AddSalesModel salesdata, Function(int value) onSuccessCallBack) {
    return _apiServices.addNewSalesDetails(salesdata, onSuccessCallBack);
  }

  @override
  String? get branchId => _branchId;
  set branchId(String? value) {
    _branchId = value;
  }

  @override
  Map<String, String> get batteryDetailsMap => _batteryDetailsMap;

  @override
  Future<GetConfigurationModel?> getPaymentsList() async {
    return await _apiServices.getConfigById(AppConstants.paymentTypes);
  }

  @override
  Map<int, String> get splitPaymentAmt => _splitPaymentAmt;

  @override
  Map<int, String> get paymentName => _paymentName;

  @override
  Stream<bool> get customerSelectstream => _custerNameSelectStream.stream;

  customerNameStreamcontroller(bool newvalue) {
    _custerNameSelectStream.add(newvalue);
  }

  @override
  Stream<bool> get splitPaymentCheckBoxStream =>
      _splitPaymentCheckBoxStream.stream;

  splitPaymentCheckBoxStreamController(bool newValue) {
    _splitPaymentCheckBoxStream.add(newValue);
  }

  @override
  String? get selectedPaymentList => _selectedPaymentList;
  set selectedPaymentList(String? value) {
    _selectedPaymentList = value;
  }

  @override
  TextEditingController get paidAmountController => _paidAmountController;

  @override
  TextEditingController get paymentTypeIdTextController =>
      _paymentTypeIdTextController;

  @override
  Map<int, String> get splitPaymentId => _splitPaymentId;

  @override
  Future<List<GetCustomerBookingDetails>?> getCustomerBookingDetails(
      String? customerId) async {
    return await _apiServices.getCustomerBookingDetails(customerId);
  }

  @override
  Stream<bool> get advanceAmountRefreshStream =>
      _advanceAmountRefreshStreamController.stream;

  advanceAmountRefreshStreamController(bool newValue) {
    _advanceAmountRefreshStreamController.add(newValue);
  }

  @override
  Stream<bool> get gstDetailsStream => _gstDetailsStreamController.stream;

  gstDetailsStreamController(bool newValue) {
    _gstDetailsStreamController.add(newValue);
  }

  @override
  Stream<bool> get screenChangeStream => _screenChangeStream.stream;

  screenChangeStreamController(bool newValue) {
    _screenChangeStream.add(newValue);
  }

  @override
  TextEditingController get quantityTextController => _quantityTextController;

  @override
  TextEditingController get unitRateTextController => _unitRateTextController;

  @override
  FocusNode get quantityFocus => _quantityFocus;

  @override
  GlobalKey<FormState> get accessoriesEntryFormkey => _accessoriesEntryFormkey;

  @override
  List<SalesItemDetail>? get accessoriesItemList => _accessoriesItemList;

  @override
  Stream<bool> get refreshsalesDataTable => _refreshsalesDataTable.stream;

  refreshsalesDataTableController(bool newValue) {
    _refreshsalesDataTable.add(newValue);
  }

  @override
  int? get availableAccessoriesQty => _availableAccessoriesQty;
  set availableAccessoriesQty(int? value) {
    _availableAccessoriesQty = value;
  }

  @override
  bool? get isTableDataVerifited => _isTableDataVerifited;
  set isTableDataVerifited(bool? value) {
    _isTableDataVerifited = value;
  }

  @override
  bool get isAccessoriestable => _isAccessoriestable;
  set isAccessoriestable(bool value) {
    _isAccessoriestable = value;
  }

  @override
  double? get totalDiscount => _totalDiscount;
  set totalDiscount(double? value) {
    _totalDiscount = value;
  }

  @override
  double? get totalQty => _totalQty;

  set totalQty(double? value) {
    _totalQty = value;
  }

  @override
  Stream<bool> get unitRateChangeStream => _unitRateChangeStream.stream;
  unitRateChangeStreamController(bool newValue) {
    _unitRateChangeStream.add(newValue);
  }

  @override
  Map<String, int> get totalAccessoriesQty => _totalAccessoriesQty;

  @override
  String? get bookingId => _bookingId;

  set bookingId(String? value) {
    _bookingId = value;
  }
}
