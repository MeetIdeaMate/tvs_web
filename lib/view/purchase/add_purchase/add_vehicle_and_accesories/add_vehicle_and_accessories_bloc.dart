import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
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
  List<Map<String, String>> get engineDetailsList;

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
  List<PurchaseBillData> get purchaseBillDataList;
  Future<List<String>> getAllVendorNameList();
  List<String> get vendorNamesList;
  ScrollController get engineListScrollController;
  String? get selectedGstType;

  Stream<bool> get refreshPurchaseDataTable;
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
  final _selectedPurchaseTypeStream = StreamController.broadcast();
  final _engineDetailsStreamController = StreamController.broadcast();
  String? _vendorDropDownValue;
  String? _selectedPurchaseType;
  List<String> selectVendor = ['Ajithkumar', 'Peter', 'Prasath'];
  late Set<String> optionsSet = {selectedPurchaseType ?? ''};
  final List<Map<String, String>> _engineDetailsList = [];
  final _refreshEngineDetailsListStream = StreamController.broadcast();
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
  final _partNoFocusNode = FocusNode();
  final _purchaseFormKey = GlobalKey<FormState>();
  final List<PurchaseBillData> _purchaseBillDataList = [];
  final _apiServices = AppServiceUtilImpl();
  List<String> _vendorNamesList = [];
  var _engineListScrollController = ScrollController();
  String? _selectedGstType;
  final _purchaseDataTable = StreamController<bool>.broadcast();

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
  List<Map<String, String>> get engineDetailsList => _engineDetailsList;

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
  Future<List<String>> getAllVendorNameList() async {
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
}
