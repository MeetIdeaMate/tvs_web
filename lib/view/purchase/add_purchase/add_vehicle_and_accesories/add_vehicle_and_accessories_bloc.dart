import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_category_model.dart';
import 'package:tlbilling/models/get_model/get_all_purchase_model.dart';
import 'package:tlbilling/models/get_model/get_purchase_report_model.dart';
import 'package:tlbilling/models/parent_response_model.dart';
import 'package:tlbilling/models/post_model/add_purchase_model.dart';
import 'package:tlbilling/models/purchase_bill_data.dart';

abstract class AddVehicleAndAccessoriesBloc {
  GlobalKey<FormState> get purchaseFormKey;

  TextEditingController get invoiceNumberController;

  TextEditingController get purchaseRefController;

  TextEditingController get carrierController;

  TextEditingController get carrierNumberController;

  TextEditingController get partNumberController;

  TextEditingController get hsnCodeController;

  TextEditingController get unitRateController;

  TextEditingController get engineNumberController;

  TextEditingController get frameNumberController;

  TextEditingController get materialNumberController;

  TextEditingController get materialNameController;

  TextEditingController get quantityController;

  TextEditingController get variantController;

  TextEditingController get colorController;

  TextEditingController get invoiceDateController;

  Stream get selectedPurchaseTypeStream;

  String? get vendorDropDownValue;

  String? get selectedPurchaseType;
  List<EngineDetails> get engineDetailsList;

  Stream get updateEngineDetailsStream;
  Stream get refreshEngineListStream;
  FocusNode get engineNoFocusNode;
  FocusNode get frameNumberFocusNode;
  FocusNode get inVoiceDateFocusNode;
  FocusNode get purchaseRefFocusNode;
  FocusNode get carrierNameFocusNode;
  FocusNode get carrierNoFocusNode;
  FocusNode get varientFocusNode;
  FocusNode get colorFocusNode;
  FocusNode get hsnCodeFocusNode;
  FocusNode get unitRateFocusNode;
  FocusNode get partNoFocusNode;
  FocusNode get vehiceNameFocusNode;
  List<PurchaseBillData> get purchaseBillDataList;
  Future<ParentResponseModel> getAllVendorNameList();
  List<String> get vendorNamesList;
  ScrollController get engineListScrollController;
  String? get selectedGstType;

  Stream<bool> get refreshPurchaseDataTable;
  Stream<bool> get gstRadioBtnRefreashStream;
  Stream<bool> get incentiveCheckBoxStream;
  Stream<bool> get taxValueCheckBoxStream;
  Stream<bool> get paymentDetailsStream;

  TextEditingController get cgstPresentageTextController;
  TextEditingController get sgstPresentageTextController;
  TextEditingController get igstPresentageTextController;
  TextEditingController get empsIncentiveTextController;
  TextEditingController get stateIncentiveTextController;
  TextEditingController get tcsvalueTextController;
  TextEditingController get discountTextController;
  TextEditingController get vehicleNameTextController;
  bool get isEmpsIncChecked;
  bool get isStateIncChecked;

  bool get isTcsValueChecked;
  bool get isDiscountChecked;
  Future<ParentResponseModel> getPurchasePartNoDetails(
      Function(int) statusCode);
  Future<void> addNewPurchaseDetails(AddPurchaseModel purchaseData,
      Function(int p1, PurchaseBill response) onSuccessCallBack);
  String? get selectedVendorId;
  double? get totalValue;
  double? get cgstAmount;
  double? get sgstAmount;
  double? get igstAmount;
  double? get invAmount;
  double? get taxableValue;
  double? get totalInvAmount;
  double? get discountValue;
  String? get branchId;
  String? get categoryId;
  String? get categoryName;

  bool get isAddPurchseBillLoading;
  CategoryItems? get selectedCategory;
  Future<GetAllCategoryListModel?> getAllCategoryList();
  List<String> get gstTypeOptions;
  Future<bool> purchaseValidate();
  bool? get isTableDataVerifited;
  Stream<bool> get isTableDataVerifyedStream;
}

class AddVehicleAndAccessoriesBlocImpl extends AddVehicleAndAccessoriesBloc {
  final _invoiceNumberController = TextEditingController();
  final _purchaseRefController = TextEditingController();
  final _carrierNumberController = TextEditingController();
  final _carrierController = TextEditingController();
  final _partNumberController = TextEditingController();
  final _hsnCodeController = TextEditingController();
  final _unitRateController = TextEditingController();
  final _engineNumberController = TextEditingController();
  final _frameNumberController = TextEditingController();
  final _materialNumberController = TextEditingController();
  final _materialNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _variantController = TextEditingController();
  final _colorController = TextEditingController();
  final _invoiceDateController = TextEditingController();
  final _cgstPresentageTextController = TextEditingController();
  final _sgstPresentageTextController = TextEditingController();
  final _igstPresentageTextController = TextEditingController();
  final _selectedPurchaseTypeStream = StreamController.broadcast();
  final _engineDetailsStreamController = StreamController.broadcast();
  final _gstRadioBtnRefreshStreamController =
      StreamController<bool>.broadcast();
  String? _vendorDropDownValue;
  String? _selectedPurchaseType;
  List<String> selectVendor = ['Ajithkumar', 'Peter', 'Prasath'];
  late Set<String> optionsSet = {selectedPurchaseType ?? ''};
  final List<EngineDetails> _engineDetailsList = [];
  int? editIndex;
  final _refreshEngineDetailsListStream = StreamController.broadcast();
  final _paymentDetailsStreamController = StreamController<bool>.broadcast();
  final _frameNumberFocusNode = FocusNode();
  final _inVoiceDateFocusNode = FocusNode();
  final _purchaseRefFocusNode = FocusNode();
  final _carrierNameFocusNode = FocusNode();
  final _carrierNoFocusNode = FocusNode();
  final _engineNoFocusNode = FocusNode();
  final _varientFocusNode = FocusNode();
  final _colorFocusNode = FocusNode();
  final _hsnCodeFocusNode = FocusNode();
  final _unitRateFocusNode = FocusNode();
  final _vehicleNameFocusNode = FocusNode();
  final _partNoFocusNode = FocusNode();
  final _purchaseFormKey = GlobalKey<FormState>();
  final List<PurchaseBillData> _purchaseBillDataList = [];
  final _apiServices = AppServiceUtilImpl();
  List<String> _vendorNamesList = [];
  var _engineListScrollController = ScrollController();
  String? _selectedGstType;
  final _purchaseDataTable = StreamController<bool>.broadcast();
  final _incentiveCheckBoxStreamController = StreamController<bool>.broadcast();
  final _taxValueCheckboxStreamController = StreamController<bool>.broadcast();
  bool _isEmpsIncChecked = false;
  bool _isStateIncChecked = false;
  bool _isTcsValueChecked = false;
  bool _isDiscountChecked = false;
  final _tcsValueTextController = TextEditingController();
  final _discountTextController = TextEditingController();
  final _empsIncentiveTextController = TextEditingController();
  final _stateIncentiveTextController = TextEditingController();
  final _vehicleNameTextController = TextEditingController();
  CategoryItems? _selectedCategory;
  String? _selectedVendorId;
  double? _totalValue;
  double? _cgstAmount;
  double? _sgstAmount;
  double? _igstAmount;
  double? _invAmount;
  double? _totalInvAmount;
  double? _taxableValue;
  double? _discountValue;
  String? _branchId;
  String? _categoryId;
  String? _categoryName;
  bool _isAddPurchaseBillLoading = false;
  final List<String> _gstTypeOptions = ['GST %', 'IGST %'];
  bool? _isTableDataVerifited = false;
  final _isTableDataVerifyedStreamController =
      StreamController<bool>.broadcast();

  @override
  String? get vendorDropDownValue => _vendorDropDownValue;

  set vendorDropDownValue(String? value) {
    _vendorDropDownValue = value;
  }

  @override
  TextEditingController get invoiceNumberController => _invoiceNumberController;

  @override
  TextEditingController get purchaseRefController => _purchaseRefController;

  @override
  TextEditingController get carrierController => _carrierController;

  @override
  TextEditingController get carrierNumberController => _carrierNumberController;

  @override
  TextEditingController get partNumberController => _partNumberController;

  @override
  TextEditingController get hsnCodeController => _hsnCodeController;

  @override
  TextEditingController get unitRateController => _unitRateController;

  @override
  TextEditingController get engineNumberController => _engineNumberController;

  @override
  TextEditingController get frameNumberController => _frameNumberController;

  @override
  String? get selectedPurchaseType => _selectedPurchaseType;

  set selectedPurchaseType(String? newValue) {
    _selectedPurchaseType = newValue;
  }

  @override
  Stream get selectedPurchaseTypeStream => _selectedPurchaseTypeStream.stream;

  selectedPurchaseTypeStreamController(bool streamValue) {
    _selectedPurchaseTypeStream.add(streamValue);
  }

  @override
  TextEditingController get materialNameController => _materialNameController;

  @override
  TextEditingController get materialNumberController =>
      _materialNumberController;

  @override
  TextEditingController get quantityController => _quantityController;

  changeSegmentedColor(Color color) {
    return MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return color;
      }
      return null;
    });
  }

  @override
  TextEditingController get colorController => _colorController;

  @override
  TextEditingController get variantController => _variantController;

  @override
  TextEditingController get invoiceDateController => _invoiceDateController;

  @override
  List<EngineDetails> get engineDetailsList => _engineDetailsList;

  @override
  Stream get updateEngineDetailsStream => _engineDetailsStreamController.stream;

  engineDetailsStreamController(bool streamValue) {
    _engineDetailsStreamController.add(streamValue);
  }

  @override
  Stream get refreshEngineListStream => _refreshEngineDetailsListStream.stream;
  refreshEngineDetailsListStramController(bool streamValue) {
    _refreshEngineDetailsListStream.add(streamValue);
  }

  @override
  FocusNode get frameNumberFocusNode => _frameNumberFocusNode;

  @override
  FocusNode get carrierNameFocusNode => _carrierNameFocusNode;

  @override
  FocusNode get carrierNoFocusNode => _carrierNoFocusNode;

  @override
  FocusNode get inVoiceDateFocusNode => _inVoiceDateFocusNode;

  @override
  FocusNode get purchaseRefFocusNode => _purchaseRefFocusNode;

  @override
  FocusNode get colorFocusNode => _colorFocusNode;

  @override
  FocusNode get hsnCodeFocusNode => _hsnCodeFocusNode;

  @override
  FocusNode get unitRateFocusNode => _unitRateFocusNode;

  @override
  FocusNode get varientFocusNode => _varientFocusNode;

  @override
  FocusNode get engineNoFocusNode => _engineNoFocusNode;

  @override
  FocusNode get partNoFocusNode => _partNoFocusNode;

  @override
  GlobalKey<FormState> get purchaseFormKey => _purchaseFormKey;

  @override
  List<PurchaseBillData> get purchaseBillDataList => _purchaseBillDataList;

  @override
  Future<ParentResponseModel> getAllVendorNameList() async {
    return await _apiServices.getAllVendorNameList();
  }

  @override
  List<String> get vendorNamesList => _vendorNamesList;

  set vendorNamesList(List<String> value) {
    _vendorNamesList = value;
  }

  @override
  ScrollController get engineListScrollController =>
      _engineListScrollController;
  set engineListScrollController(ScrollController scrollController) {
    _engineListScrollController = scrollController;
  }

  @override
  String? get selectedGstType => _selectedGstType;

  set selectedGstType(String? gstValue) {
    _selectedGstType = gstValue;
  }

  @override
  Stream<bool> get refreshPurchaseDataTable => _purchaseDataTable.stream;

  refreshPurchaseDataTableList(bool streamValue) {
    _purchaseDataTable.add(streamValue);
  }

  @override
  TextEditingController get cgstPresentageTextController =>
      _cgstPresentageTextController;

  @override
  TextEditingController get igstPresentageTextController =>
      _igstPresentageTextController;

  @override
  TextEditingController get sgstPresentageTextController =>
      _sgstPresentageTextController;

  @override
  bool get isEmpsIncChecked => _isEmpsIncChecked;

  set isEmpsIncChecked(bool checkBoxValue) {
    _isEmpsIncChecked = checkBoxValue;
  }

  @override
  bool get isStateIncChecked => _isStateIncChecked;

  set isStateIncChecked(bool checkBoxValue) {
    _isStateIncChecked = checkBoxValue;
  }

  @override
  TextEditingController get empsIncentiveTextController =>
      _empsIncentiveTextController;

  @override
  TextEditingController get stateIncentiveTextController =>
      _stateIncentiveTextController;

  @override
  bool get isDiscountChecked => _isDiscountChecked;

  set isDiscountChecked(bool checkBoxValue) {
    _isDiscountChecked = checkBoxValue;
  }

  @override
  bool get isTcsValueChecked => _isTcsValueChecked;

  set isTcsValueChecked(bool checkBoxValue) {
    _isTcsValueChecked = checkBoxValue;
  }

  @override
  TextEditingController get discountTextController => _discountTextController;

  @override
  TextEditingController get tcsvalueTextController => _tcsValueTextController;

  @override
  Future<ParentResponseModel> getPurchasePartNoDetails(
      Function(int) statusCode) async {
    return await _apiServices.getPurchasePartNoDetails(
        _partNumberController.text, statusCode);
  }

  @override
  TextEditingController get vehicleNameTextController =>
      _vehicleNameTextController;

  @override
  FocusNode get vehiceNameFocusNode => _vehicleNameFocusNode;

  @override
  Future<void> addNewPurchaseDetails(AddPurchaseModel purchaseData,
      Function(int p1, PurchaseBill response) onSuccessCallBack) async {
    return await _apiServices.addNewPurchaseDetails(
        purchaseData, onSuccessCallBack);
  }

  @override
  String? get selectedVendorId => _selectedVendorId;
  set selectedVendorId(String? value) {
    _selectedVendorId = value;
  }

  @override
  double? get cgstAmount => _cgstAmount;

  set cgstAmount(double? value) {
    _cgstAmount = value;
  }

  @override
  double? get igstAmount => _igstAmount;

  set igstAmount(double? value) {
    _igstAmount = value;
  }

  @override
  double? get invAmount => _invAmount;

  set invAmount(double? value) {
    _invAmount = value;
  }

  @override
  double? get sgstAmount => _sgstAmount;

  set sgstAmount(double? value) {
    _sgstAmount = value;
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
  double? get taxableValue => _taxableValue;

  set taxableValue(double? value) {
    _taxableValue = value;
  }

  @override
  double? get discountValue => _discountValue;

  set discountValue(double? value) {
    _discountValue = value;
  }

  @override
  String? get branchId => _branchId;

  set branchId(String? value) {
    _branchId = value;
  }

  @override
  bool get isAddPurchseBillLoading => _isAddPurchaseBillLoading;

  set isAddPurchseBillLoading(bool value) {
    _isAddPurchaseBillLoading = value;
  }

  @override
  Future<GetAllCategoryListModel?> getAllCategoryList() async {
    return _apiServices.getAllCategoryList();
  }

  @override
  String? get categoryId => _categoryId;

  set categoryId(String? value) {
    _categoryId = value;
  }

  @override
  String? get categoryName => _categoryName;

  set categoryName(String? value) {
    _categoryName = value;
  }

  @override
  CategoryItems? get selectedCategory => _selectedCategory;

  set selectedCategory(CategoryItems? category) {
    _selectedCategory = category;
  }

  @override
  List<String> get gstTypeOptions => _gstTypeOptions;

  @override
  Stream<bool> get gstRadioBtnRefreashStream =>
      _gstRadioBtnRefreshStreamController.stream;

  gstRadioBtnRefreshStreamController(bool streamValue) {
    _gstRadioBtnRefreshStreamController.add(streamValue);
  }

  @override
  Stream<bool> get incentiveCheckBoxStream =>
      _incentiveCheckBoxStreamController.stream;

  incentiveCheckBoxStreamController(bool streamValue) {
    _incentiveCheckBoxStreamController.add(streamValue);
  }

  @override
  Stream<bool> get taxValueCheckBoxStream =>
      _taxValueCheckboxStreamController.stream;

  taxValueCheckboxStreamController(bool streamValue) {
    _taxValueCheckboxStreamController.add(streamValue);
  }

  @override
  Stream<bool> get paymentDetailsStream =>
      _paymentDetailsStreamController.stream;

  paymentDetailsStreamController(bool streamValue) {
    _paymentDetailsStreamController.add(streamValue);
  }

  @override
  Future<bool> purchaseValidate() async {
    return _apiServices.purchaseValidate({
      "engineNo": engineNumberController.text,
      "frameNo": frameNumberController.text
    }, partNumberController.text);
  }

  @override
  bool? get isTableDataVerifited => _isTableDataVerifited;

  set isTableDataVerifited(bool? verifyed) {
    _isTableDataVerifited = verifyed;
  }

  @override
  Stream<bool> get isTableDataVerifyedStream =>
      _isTableDataVerifyedStreamController.stream;

  isTableDataVerifyedStreamController(bool tableData) {
    _isTableDataVerifyedStreamController.add(tableData);
  }
}
