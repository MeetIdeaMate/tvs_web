import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_branches_by_pagination.dart';
import 'package:tlbilling/models/get_model/get_all_transfer_model.dart';
import 'package:tlbilling/models/get_model/get_configuration_model.dart';
import 'package:tlbilling/models/parent_response_model.dart';
import 'package:tlbilling/utils/app_constants.dart';

abstract class TransferViewBloc {
  Stream get transporterNameSearchStream;

  Stream get vehicleNameSearchStream;

  TextEditingController get transporterNameSearchController;

  TextEditingController get vehicleNameSearchController;

  TabController get transferScreenTabController;

  String? get selectedVendor;

  Future<ParentResponseModel> getVendorList();

  Future<List<GetAllTransferModel>?> getTransferList(String status);

  String? get transferListCount;

  String? get receivedListCount;

  Stream get tabBarStreamController;

  String? get transferStatus;

  String? get selectedFromBranch;

  String? get selectedToBranch;

  String? get branchId;

  String? get fromBranchId;

  String? get toBranchId;

  Stream get tableRefreshStreamController;

  Future<List<BranchDetail>?> getBranchesList();

  List<String> get fromBranchList;

  List<String> get toBranchList;

  Stream get toBranchNameListStreamController;

  Stream get fromBranchNameListStreamController;

  Future<GetConfigurationModel?> getTransferStatus();

  TextEditingController get fromDateTextController;

  TextEditingController get toDateTextController;

  Future<void> stockTransferApproval(
      String transferId, Function(int statusCode) onSuccessCallback);

  String? get sharePrefBranchId;
}

class TransferViewBlocImpl extends TransferViewBloc {
  final _transporterNameSearchController = TextEditingController();
  final _vehicleNameSearchController = TextEditingController();
  final _fromDateTextController = TextEditingController();
  final _toDateTextController = TextEditingController();
  final _transporterNameSearchStream = StreamController.broadcast();
  final _vehicleNameSearchStream = StreamController.broadcast();
  final _tabBarStreamController = StreamController.broadcast();
  final _tableRefreshStreamController = StreamController.broadcast();
  final _toBranchNameListStreamController = StreamController.broadcast();
  final _fromBranchNameListStreamController = StreamController.broadcast();
  late TabController _transferScreenTabController;
  String? _selectedVendor;
  final _appService = AppServiceUtilImpl();
  String? _transferListCount;
  String? _receivedListCount;
  String? _selectedStatus;
  String? _selectedFromBranch;
  String? _selectedToBranch;
  String? _branchId;
  String? _fromBranchId;
  String? _toBranchId;
  String? _sharePrefBranchId;
  List<String> _fromBranchList = [];
  List<String> _toBranchList = [];

  @override
  TextEditingController get transporterNameSearchController =>
      _transporterNameSearchController;

  @override
  TextEditingController get vehicleNameSearchController =>
      _vehicleNameSearchController;

  @override
  Stream get transporterNameSearchStream => _transporterNameSearchStream.stream;

  transporterNameStreamController(bool streamValue) {
    _transporterNameSearchStream.add(streamValue);
  }

  @override
  Stream get vehicleNameSearchStream => _vehicleNameSearchStream.stream;

  vehicleNameSearchStreamController(bool streamValue) {
    _vehicleNameSearchStream.add(streamValue);
  }

  @override
  TabController get transferScreenTabController => _transferScreenTabController;

  set transferScreenTabController(TabController controllerValue) {
    _transferScreenTabController = controllerValue;
  }

  @override
  String? get selectedVendor => _selectedVendor;

  set selectedVendor(String? newValue) {
    _selectedVendor = newValue;
  }

  @override
  Future<ParentResponseModel> getVendorList() async {
    return _appService.getAllVendorNameList();
  }

  @override
  Future<List<GetAllTransferModel>?> getTransferList(String status) async {
    return _appService.getTransferList(status, transferStatus, fromBranchId,
        toBranchId, fromDateTextController.text, toDateTextController.text);
  }

  @override
  String? get receivedListCount => _receivedListCount;

  set receivedListCount(String? newValue) {
    _receivedListCount = newValue;
  }

  @override
  String? get transferListCount => _transferListCount;

  set transferListCount(String? newValue) {
    _transferListCount = newValue;
  }

  @override
  Stream get tabBarStreamController => _tabBarStreamController.stream;

  tabBarStream(bool newValue) {
    _tabBarStreamController.add(newValue);
  }

  @override
  String? get transferStatus => _selectedStatus;

  set transferStatus(String? newValue) {
    _selectedStatus = newValue;
  }

  @override
  Stream get tableRefreshStreamController =>
      _tableRefreshStreamController.stream;

  tableRefreshStream(bool? streamValue) {
    _tableRefreshStreamController.add(streamValue);
  }

  @override
  Future<List<BranchDetail>?> getBranchesList() async {
    return await _appService.getAllBranchListWithoutPagination();
  }

  @override
  String? get selectedFromBranch => _selectedFromBranch;

  set selectedFromBranch(String? newValue) {
    _selectedFromBranch = newValue;
  }

  @override
  String? get selectedToBranch => _selectedToBranch;

  set selectedToBranch(String? newValue) {
    _selectedToBranch = newValue;
  }

  @override
  List<String> get fromBranchList => _fromBranchList;

  set fromBranchList(List<String> newListValue) {
    _fromBranchList = newListValue;
  }

  @override
  List<String> get toBranchList => _toBranchList;

  set toBranchList(List<String> newListValue) {
    _toBranchList = newListValue;
  }

  @override
  String? get branchId => _branchId;

  set branchId(String? newValue) {
    _branchId = newValue;
  }

  @override
  String? get fromBranchId => _fromBranchId;

  set fromBranchId(String? newValue) {
    _fromBranchId = newValue;
  }

  @override
  String? get toBranchId => _toBranchId;

  set toBranchId(String? newValue) {
    _toBranchId = newValue;
  }

  @override
  Stream get toBranchNameListStreamController =>
      _toBranchNameListStreamController.stream;

  toBranchNameListStream(bool? streamValue) {
    _toBranchNameListStreamController.add(streamValue);
  }

  @override
  Stream get fromBranchNameListStreamController =>
      _fromBranchNameListStreamController.stream;

  fromBranchNameListStream(bool? streamValue) {
    _fromBranchNameListStreamController.add(streamValue);
  }

  @override
  Future<GetConfigurationModel?> getTransferStatus() async {
    return _appService.getConfigById(AppConstants.transferStatus);
  }

  @override
  TextEditingController get fromDateTextController => _fromDateTextController;

  @override
  TextEditingController get toDateTextController => _toDateTextController;

  @override
  Future<void> stockTransferApproval(
      String transferId, Function(int statusCode) onSuccessCallback) async {
    return await _appService.stockTransferApproval(
        sharePrefBranchId, transferId, onSuccessCallback);
  }

  @override
  String? get sharePrefBranchId => _sharePrefBranchId;

  set sharePrefBranchId(String? newValue) {
    _sharePrefBranchId = newValue;
  }
}
