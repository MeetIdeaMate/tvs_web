import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_category_model.dart';
import 'package:tlbilling/models/get_model/get_all_customers_model.dart';
import 'package:tlbilling/models/get_model/get_all_stocks_model.dart';
import 'package:tlbilling/models/parent_response_model.dart';
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

  TextEditingController get discountTextController;
  TextEditingController get transporterVehicleNumberController;
  TextEditingController get vehicleNoAndEngineNoSearchController;

  String? get selectedVehicleAndAccessories;
  String? get selectedBranch;
  String? get selectedCustomer;

  List<Widget> get selectedItems;
  List<GetAllStockDetails>? get vehicleData;
  List<GetAllStockDetails>? get accessoriesData;

  Stream<bool> get selectedSalesStreamItems;

  int get salesIndex;

  String get selectedGstType;
  bool get isDiscountChecked;
  bool get isInsurenceChecked;
  String? get selectedPaymentOption;
  Future<GetAllCustomersModel?> getCustomerById();

  Future<ParentResponseModel> getAllCustomerList();

  Future<GetAllCategoryListModel?> getAllCategoryList();

  Future<List<String>> getPaymentmethods();
  Stream<List<GetAllStockDetails>> get vehicleListStream;
  // List<Map<String, String>> get vehicleData;
  List<GetAllStockDetails> get filteredVehicleData;
  String? get selectedCustomerId;

  Future<List<GetAllStockDetails>?> getStockDetails();
}

class AddSalesBlocImpl extends AddSalesBloc {
  final _apiServices = AppServiceUtilImpl();
  final _selectedVehicleAndAccessoriesStream = StreamController.broadcast();
  final _changeVehicleAndAccessoriesListStream = StreamController.broadcast();
  final _vehicleAndEngineNumberStream = StreamController.broadcast();

  final _accessoriesIncrementStream = StreamController.broadcast();
  final _selectedVehicleAndAccessoriesListStream = StreamController.broadcast();
  final _selectedSalesStreamController = StreamController<bool>.broadcast();
  final _discountTextController = TextEditingController();
  final _transporterVehicleNumberController = TextEditingController();
  final _vehicleNoAndEngineNoSearchController = TextEditingController();
  final _availableVehicleListStreamController = StreamController.broadcast();
  final __availableAccListStreamController = StreamController.broadcast();
  final _filteredAccListStreamController =
      StreamController<List<GetAllStockDetails>>.broadcast();

  List<String> selectedVehicleList = [];

  final _selectedItemStreamController = StreamController.broadcast();
  List<GetAllStockDetails>? selectedVehiclesList = [];

  List<GetAllStockDetails>? slectedAccessoriesList = [];

  late Set<String> optionsSet = {selectedVehicleAndAccessories ?? 'M-vehicle'};
  String? _selectedVehicleAndAccessories;
  String? _selectedBranch;
  String? _selectedCustomer;
  int initialValue = 0;
  final List<Widget> _selectedItems = [];
  int? _salesIndex = 0;
  String _selectedGstType = 'GST';
  bool _isDiscountChecked = false;
  bool _isInsurenceChecked = false;
  List<GetAllStockDetails>? _vehicleDatas = [];
  List<GetAllStockDetails>? _accessoriesData = [];
  ValueNotifier<int> initialValueNotifier = ValueNotifier<int>(0);
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
  String? _selectedPaymentOption;
  String? _selectedCustomerId;
  final _vehicleListStreamController =
      StreamController<List<GetAllStockDetails>>.broadcast();
  final List<Map<String, dynamic>> accessoriesList = [
    {
      AppConstants.accessoriesName: 'TVS-APACHE TOOL KIT',
      AppConstants.quantity: 10,
      AppConstants.accessoriesNumber: 'K61916321F',
    },
    {
      AppConstants.accessoriesName: 'HELMET',
      AppConstants.quantity: 20,
      AppConstants.accessoriesNumber: 'K61916322F',
    },
    {
      AppConstants.accessoriesName: 'STAR-CITY FOOT REST',
      AppConstants.quantity: 10,
      AppConstants.accessoriesNumber: 'K61916323F',
    },
    {
      AppConstants.accessoriesName: 'XL-SUPER SEAT',
      AppConstants.quantity: 5,
      AppConstants.accessoriesNumber: 'K61916324F',
    },
    {
      AppConstants.accessoriesName: 'SILENCER',
      AppConstants.quantity: 2,
      AppConstants.accessoriesNumber: 'K61916325F',
    },
  ];

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
    return MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
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
  String get selectedGstType => _selectedGstType;

  set selectedGstType(String value) {
    _selectedGstType = value;
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
  Future<ParentResponseModel> getAllCustomerList() async {
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
}
