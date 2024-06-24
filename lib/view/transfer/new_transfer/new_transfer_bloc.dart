import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_branches_by_pagination.dart';
import 'package:tlbilling/models/get_model/get_all_category_model.dart';
import 'package:tlbilling/models/get_model/get_all_stocks_without_pagination.dart';
import 'package:tlbilling/models/get_model/get_transport_by_pagination.dart';
import 'package:tlbilling/models/post_model/add_new_transfer.dart';

abstract class NewTransferBloc {
  Stream get selectedVehicleAndAccessoriesStream;

  Stream get vehicleAndEngineNumberStream;

  Stream get changeVehicleAndAccessoriesListStream;

  Stream get selectedVehicleListStream;

  Stream get selectedVehicleAndAccessoriesListStream;

  Stream get accessoriesIncrementStream;

  TextEditingController get vehicleAndEngineNumberController;

  TextEditingController get transporterVehicleNumberController;

  String? get selectedVehicleAndAccessories;

  String? get selectedFromBranch;

  String? get selectedFromBranchId;

  String? get selectedToBranch;

  String? get selectedToBranchId;

  String? get selectedTransporterName;

  String? get selectedTransporterId;

  Future<List<BranchDetail>?> getBranches();

  Future<List<TransportDetails>?> getAllTransportsWithoutPagination();

  Stream get transporterDetailsStreamController;

  Future<TransportDetails?> getTransporterDetailById();

  String? get transporterName;

  String? get transporterMobileNumber;

  String? get transporterMailId;

  List<GetAllStocksWithoutPaginationModel>? get vehicleData;

  int? get salesIndex;

  Stream get availableVehicleListStreamController;

  Stream get selectedItemStreamController;

  List<String> get toBranchNameList;

  Stream get toBranchNameListStreamController;

  Stream get fromBranchNameListStreamController;

  GlobalKey<FormState> get dropDownFormKey;

  Stream get availableAccListStreamController;

  Stream<bool> get filteredAccListStreamController;

  List<TextEditingController> get accessoriesCountController;

  Future<List<GetAllStocksWithoutPaginationModel>?>
      stockListWithOutPagination();

  Future<void> createNewTransfer(AddNewTransfer addNewTransfer,
      Function(int statusCode) onSuccessCallBack);

  Future<GetAllCategoryListModel?> getCategoryList();

  List<GetAllStocksWithoutPaginationModel>? get filteredVehicleData;

  bool? get isLoading;

  String? get branchId;

  int? get quantity;
}

class NewTransferBlocImpl extends NewTransferBloc {
  final _selectedVehicleAndAccessoriesStream = StreamController.broadcast();
  final _changeVehicleAndAccessoriesListStream = StreamController.broadcast();
  final _vehicleAndEngineNumberStream = StreamController.broadcast();
  final _selectedVehicleListStream = StreamController.broadcast();
  final _accessoriesIncrementStream = StreamController.broadcast();
  final _selectedVehicleAndAccessoriesListStream = StreamController.broadcast();
  final _transporterDetailsStreamController = StreamController.broadcast();
  final _availableVehicleListStreamController = StreamController.broadcast();
  final _selectedItemStreamController = StreamController.broadcast();
  final _fromBranchNameListStreamController = StreamController.broadcast();
  final _toBranchNameListStreamController = StreamController.broadcast();
  final _availableAccListStreamController = StreamController.broadcast();
  final StreamController<bool> _filteredAccListStreamController =
      StreamController.broadcast();
  final _dropDownFormKey = GlobalKey<FormState>();
  final _vehicleAndEngineNumberController = TextEditingController();
  final _transporterVehicleNumberController = TextEditingController();
  final List<TextEditingController> _accessoriesCountController = [];
  List<String>? _toBranchNameList;
  List<String> vehicleAndAccessoriesList = ['Vehicle', 'Accessories'];
  List<GetAllStocksWithoutPaginationModel>? selectedVehicleList = [];
  List<GetAllStocksWithoutPaginationModel>? _filteredVehicleData = [];
  List<String> branch = ['Kovilpatti', 'Sattur', 'Sivakasi'];
  late Set<String> optionsSet = {selectedVehicleAndAccessories ?? ''};
  String? _selectedVehicleAndAccessories;
  String? _selectedFromBranch;
  String? _selectedFromBranchId;
  String? _selectedToBranch;
  String? _selectedToBranchId;
  String? _selectedTransporterName;
  String? _selectedTransporterId;
  String? _transporterMailId;
  String? _transporterMobileNumber;
  String? _transporterName;
  String? _branchId;
  bool? _isLoading = false;
  int initialValue = 0;
  int? _salesIndex = 0;
  int? _quantity;

  List<GetAllStocksWithoutPaginationModel>? _vehicleData = [];
  List<GetAllStocksWithoutPaginationModel>? accessoriesList = [];
  final List<GetAllStocksWithoutPaginationModel>? filteredAccessoriesList = [];

  final _appServices = AppServiceUtilImpl();

  @override
  String? get selectedVehicleAndAccessories => _selectedVehicleAndAccessories;

  set selectedVehicleAndAccessories(String? newValue) {
    _selectedVehicleAndAccessories = newValue;
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
  TextEditingController get vehicleAndEngineNumberController =>
      _vehicleAndEngineNumberController;

  @override
  Stream get changeVehicleAndAccessoriesListStream =>
      _changeVehicleAndAccessoriesListStream.stream;

  changeVehicleAndAccessoriesListStreamController(bool streamValue) {
    _changeVehicleAndAccessoriesListStream.add(streamValue);
  }

  @override
  Stream get selectedVehicleListStream => _selectedVehicleListStream.stream;

  selectedVehicleListStreamController(bool streamValue) {
    _selectedVehicleListStream.add(streamValue);
  }

  @override
  Stream get selectedVehicleAndAccessoriesListStream =>
      _selectedVehicleAndAccessoriesListStream.stream;

  selectedVehicleAndAccessoriesListStreamController(bool streamValue) {
    _selectedVehicleAndAccessoriesListStream.add(streamValue);
  }

  @override
  Stream get accessoriesIncrementStream => _accessoriesIncrementStream.stream;

  accessoriesIncrementStreamController(bool? streamValue) {
    _accessoriesIncrementStream.add(streamValue);
  }

  @override
  String? get selectedFromBranch => _selectedFromBranch;

  set selectedFromBranch(String? newValue) {
    _selectedFromBranch = newValue;
  }

  @override
  TextEditingController get transporterVehicleNumberController =>
      _transporterVehicleNumberController;

  @override
  Future<List<BranchDetail>?> getBranches() async {
    return _appServices.getAllBranchListWithoutPagination();
  }

  @override
  Future<List<TransportDetails>?> getAllTransportsWithoutPagination() async {
    return _appServices.getAllTransportsWithoutPagination();
  }

  @override
  String? get selectedToBranch => _selectedToBranch;

  set selectedToBranch(String? newValue) {
    _selectedToBranch = newValue;
  }

  @override
  String? get selectedTransporterId => _selectedTransporterId;

  set selectedTransporterId(String? newValue) {
    _selectedTransporterId = newValue;
  }

  @override
  String? get selectedTransporterName => _selectedTransporterName;

  set selectedTransporterName(String? newValue) {
    _selectedTransporterName = newValue;
  }

  @override
  Stream get transporterDetailsStreamController =>
      _transporterDetailsStreamController.stream;

  transporterDetailsStream(bool? streamValue) {
    _transporterDetailsStreamController.add(streamValue);
  }

  @override
  Future<TransportDetails?> getTransporterDetailById() async {
    return _appServices.getTransportDetailsById(selectedTransporterId ?? '');
  }

  @override
  String? get transporterMailId => _transporterMailId;

  set transporterMailId(String? newValue) {
    _transporterMailId = newValue;
  }

  @override
  String? get transporterMobileNumber => _transporterMobileNumber;

  set transporterMobileNumber(String? newValue) {
    _transporterMobileNumber = newValue;
  }

  @override
  String? get transporterName => _transporterName;

  set transporterName(String? newValue) {
    _transporterName = newValue;
  }

  @override
  List<GetAllStocksWithoutPaginationModel>? get vehicleData => _vehicleData;

  set vehicleData(List<GetAllStocksWithoutPaginationModel>? newValue) {
    _vehicleData = newValue;
  }

  @override
  int? get salesIndex => _salesIndex;

  set salesIndex(int? newValue) {
    _salesIndex = newValue;
  }

  @override
  Stream get availableVehicleListStreamController =>
      _availableVehicleListStreamController.stream;

  availableVehicleListStream(bool? streamValue) {
    _availableVehicleListStreamController.add(streamValue);
  }

  @override
  Stream get selectedItemStreamController =>
      _selectedItemStreamController.stream;

  selectedItemStream(bool? streamValue) {
    _selectedItemStreamController.add(streamValue);
  }

  @override
  List<String> get toBranchNameList => _toBranchNameList ?? [];

  set toBranchNameList(List<String> newList) {
    _toBranchNameList = newList;
  }

  @override
  Stream get toBranchNameListStreamController =>
      _toBranchNameListStreamController.stream;

  toBranchNameListStream(bool? streamValue) {
    _toBranchNameListStreamController.add(streamValue);
  }

  @override
  GlobalKey<FormState> get dropDownFormKey => _dropDownFormKey;

  @override
  Stream get fromBranchNameListStreamController =>
      _fromBranchNameListStreamController.stream;

  fromBranchNameListStream(bool? streamValue) {
    _fromBranchNameListStreamController.add(streamValue);
  }

  @override
  Stream get availableAccListStreamController =>
      _availableAccListStreamController.stream;

  availableAccListStream(bool? streamValue) {
    _availableAccListStreamController.add(streamValue);
  }

  @override
  Stream<bool> get filteredAccListStreamController =>
      _filteredAccListStreamController.stream;

  filteredAccListStream(bool streamValue) {
    _filteredAccListStreamController.add(streamValue);
  }

  @override
  List<TextEditingController> get accessoriesCountController =>
      _accessoriesCountController;

  @override
  Future<List<GetAllStocksWithoutPaginationModel>?>
      stockListWithOutPagination() async {
    return _appServices.getAllStockList(
        selectedVehicleAndAccessories, branchId);
  }

  @override
  Future<void> createNewTransfer(AddNewTransfer? addNewTransfer,
      Function(int statusCode) onSuccessCallBack) async {
    return _appServices.createNewTransfer(addNewTransfer, onSuccessCallBack);
  }

  @override
  Future<GetAllCategoryListModel?> getCategoryList() async {
    return _appServices.getAllCategoryList();
  }

  @override
  List<GetAllStocksWithoutPaginationModel>? get filteredVehicleData =>
      _filteredVehicleData;

  set filteredVehicleData(List<GetAllStocksWithoutPaginationModel>? newValue) {
    _filteredVehicleData = newValue;
  }

  @override
  bool? get isLoading => _isLoading;

  set isLoading(bool? newValue) {
    _isLoading = newValue;
  }

  @override
  String? get branchId => _branchId;

  set branchId(String? newValue) {
    _branchId = newValue;
  }

  @override
  String? get selectedFromBranchId => _selectedFromBranchId;

  set selectedFromBranchId(String? newValue) {
    _selectedFromBranchId = newValue;
  }

  @override
  String? get selectedToBranchId => _selectedToBranchId;

  set selectedToBranchId(String? newValue) {
    _selectedToBranchId = newValue;
  }

  @override
  int? get quantity => _quantity;

  set quantity(int? newValue) {
    _quantity = newValue;
  }

  void updateAccessoriesQuantity(
      GetAllStocksWithoutPaginationModel? accessoriesDetails,
      bool isQtyIncrease) {
    for (GetAllStocksWithoutPaginationModel accessDet
        in filteredAccessoriesList ?? []) {
      if (accessDet.stockId == accessoriesDetails?.stockId) {
        if (isQtyIncrease) {
          if (accessDet.selectedQuantity != accessoriesDetails?.quantity) {
            accessDet.selectedQuantity = (accessDet.selectedQuantity ?? 0) + 1;
          }
        } else {
          if ((accessDet.selectedQuantity ?? 0) > 0) {
            accessDet.selectedQuantity = (accessDet.selectedQuantity ?? 0) - 1;
          } else if ((accessDet.selectedQuantity ?? 0) >= 0) {
            filteredAccessoriesList?.remove(accessoriesDetails);
            accessoriesList?.add(accessoriesDetails!);
          }
        }
      }
    }
    filteredAccListStream(true);
    availableAccListStream(true);
  }
}
