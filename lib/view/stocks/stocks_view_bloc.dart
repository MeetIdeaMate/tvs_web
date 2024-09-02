import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/api_service/service_locator.dart';
import 'package:tlbilling/models/get_model/get_all_branch_model.dart';
import 'package:tlbilling/models/get_model/get_all_branches_by_pagination.dart';
import 'package:tlbilling/models/get_model/get_all_stock_with_pagination.dart';
import 'package:tlbilling/utils/app_constants.dart';

abstract class StocksViewBloc {
  TextEditingController get partNumberSearchController;

  TextEditingController get vehicleNameSearchController;

  Stream get partNumberSearchControllerStream;

  Stream get vehicleNameSearchControllerStream;

  TabController get stocksTableTableController;
  Future<GetAllStocksByPagenation?> getAllStockByPagenation(String? status);

  int get currentPage;
  Stream<int> get pageNumberStream;
  Stream<bool> get branchNameDropdownStream;
  Future<List<BranchDetail>?> getBranchesList();

  String? get selectedBranch;

  Future<GetAllBranchList?> getBranchById();

  String? get branchId;

  bool? get isMainBranch;
}

class StocksViewBlocImpl extends StocksViewBloc {
  final _partNumberSearchController = TextEditingController();
  final _vehicleNameSearchController = TextEditingController();
  final _partNumberSearchControllerStream = StreamController.broadcast();
  final _vehicleNameSearchControllerStream = StreamController.broadcast();
  late TabController _stocksTableTableController;
  final _apiServices = getIt<AppServiceUtilImpl>();
  int _currentPage = 0;
  final _pageNumberStreamController = StreamController<int>.broadcast();
  final _branchNameStreamController = StreamController<bool>.broadcast();
  String? _selectedBranch = AppConstants.allBranch;

  bool? _isMainBranch;

  String? _branchId;

  @override
  TextEditingController get partNumberSearchController =>
      _partNumberSearchController;

  @override
  TextEditingController get vehicleNameSearchController =>
      _vehicleNameSearchController;

  @override
  Stream get partNumberSearchControllerStream =>
      _partNumberSearchControllerStream.stream;

  partNumberSearchStreamController(bool streamValue) {
    _partNumberSearchControllerStream.add(streamValue);
  }

  @override
  Stream get vehicleNameSearchControllerStream =>
      _vehicleNameSearchControllerStream.stream;

  vehicleNameSearchStreamController(bool streamValue) {
    _vehicleNameSearchControllerStream.add(streamValue);
  }

  @override
  TabController get stocksTableTableController => _stocksTableTableController;

  set stocksTableTableController(TabController tabValue) {
    _stocksTableTableController = tabValue;
  }

  @override
  int get currentPage => _currentPage;
  set currentPage(int pageValue) {
    _currentPage = pageValue;
  }

  @override
  Future<GetAllStocksByPagenation?> getAllStockByPagenation(
      String? status) async {
    return await _apiServices.getAllStockByPagenation(
        currentPage,
        _partNumberSearchController.text,
        _vehicleNameSearchController.text,
        status,
        branchId);
  }

  @override
  Stream<int> get pageNumberStream => _pageNumberStreamController.stream;

  pageNumberUpdateStreamController(int streamValue) {
    _pageNumberStreamController.add(streamValue);
  }

  @override
  Stream<bool> get branchNameDropdownStream =>
      _branchNameStreamController.stream;

  branchNameDropdownStreamController(bool streamValue) {
    _branchNameStreamController.add(streamValue);
  }

  @override
  Future<List<BranchDetail>?> getBranchesList() async {
    return await _apiServices.getAllBranchListWithoutPagination();
  }

  @override
  String? get selectedBranch => _selectedBranch;

  set selectedBranch(String? newValue) {
    _selectedBranch = newValue;
  }

  @override
  Future<GetAllBranchList?> getBranchById() {
    return _apiServices.getBranchDetailsById(branchId ?? '');
  }

  @override
  String? get branchId => _branchId;

  set branchId(String? newValue) {
    _branchId = newValue;
  }

  @override
  bool? get isMainBranch => _isMainBranch;

  set isMainBranch(bool? value) {
    _isMainBranch = value;
  }
}
