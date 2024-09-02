import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/api_service/service_locator.dart';
import 'package:tlbilling/models/get_model/get_all_access_controll_model.dart';
import 'package:tlbilling/models/get_model/get_all_branches_by_pagination.dart';
import 'package:tlbilling/models/get_model/get_configuration_model.dart';
import 'package:tlbilling/models/parent_response_model.dart';
import 'package:tlbilling/models/post_model/user_access_model.dart';
import 'package:tlbilling/models/user_model.dart';
import 'package:tlbilling/utils/app_constants.dart';

abstract class AccessControlViewBloc {
  List<String> get screenNameList;
  List<String> get uiComponentsList;

  Future<List<BranchDetail>?> getBranchesList();
  List<String> get branchList;
  String? get selectedBranch;
  String? get branchId;
  String? get selectedRole;
  String? get selectedUserName;
  String? get selectedDesignation;
  Future<GetConfigurationModel?> getRoleConfigList();
  Future<GetConfigurationModel?> getDesignationConfigList();
  Future<GetConfigurationModel?> getMenuNameConfigList();
  Future<GetConfigurationModel?> getUiComponentsConfigList();
  TabController get accessControlTabController;
  List<String> get menusList;
  List<String> get accessLevels;

  // Stream properties
  Stream<List<String>> get screenNamesStream;
  Stream<List<String>> get uiComponentsNameStream;
  Stream<List<bool>> get hideChecksStream;
  Stream<List<bool>> get viewChecksStream;
  Stream<List<bool>> get addChecksStream;
  Stream<List<bool>> get pUpdateChecksStream;
  Stream<List<bool>> get fUpdateChecksStream;
  Stream<List<bool>> get deleteChecksStream;
  Stream<bool> get userNameSelectStream;
  Stream<bool> get designationSelectStream;
  Stream<bool> get checkBoxStream;
  Future<void> accessControlPostData(
      Function(int? statusCode) onSuccessCallBack, UserAccess requestObj);
  Future<void> accessControlUpdateData(
      Function(int? statusCode) onSuccessCallBack,
      UserAccess requestObj,
      String accessId);

  Future<List<AccessControlList>?> getAllUserAccessControlData(
      {required Function(int? statusCode,
              AccessControlList? getAllUserAccessControlDetails)
          onSuccessCallback,
      String? userId,
      String? role});

  Future<List<UserDetailsList>?> getAllUserNameList();
  Future<ParentResponseModel> getBranchName();
  Stream<bool> get refreshTabViewStream;

  void dispose();
}

class AccessControlViewBlocImpl implements AccessControlViewBloc {
  final _apiCalls = getIt<AppServiceUtilImpl>();
  late TabController _accessControlTabController;
  final List<String> _accessLevels = [];

  final List<String> _menusList = [];

  @override
  List<String> screenNameList = [];
  List<String> uiComponentList = [];

  final List<String> _branchList = [];
  String? _selectedBranch;
  String? _branchId;
  String? _selectedRole;
  String? _selectedDesignation;
  String? _selectedUserName;

  // State for checkboxes
  List<bool> _hideChecks = [];
  List<bool> _viewChecks = [];
  List<bool> _addChecks = [];
  List<bool> _pUpdateChecks = [];
  List<bool> _fUpdateChecks = [];
  List<bool> _deleteChecks = [];
  final _loadingController = StreamController<bool>.broadcast();

  Stream<bool> get loadingStream => _loadingController.stream;

  void setLoadingState(bool isLoading) {
    _loadingController.add(isLoading);
  }

  // Stream controllers
  final _screenNamesController = StreamController<List<String>>.broadcast();
  final _hideChecksController = StreamController<List<bool>>.broadcast();
  final _viewChecksController = StreamController<List<bool>>.broadcast();
  final _addChecksController = StreamController<List<bool>>.broadcast();
  final _pUpdateChecksController = StreamController<List<bool>>.broadcast();
  final _fUpdateChecksController = StreamController<List<bool>>.broadcast();
  final _deleteChecksController = StreamController<List<bool>>.broadcast();
  final _refreshTabViewStreamController = StreamController<bool>.broadcast();
  final _checkBoxStreamController = StreamController<bool>.broadcast();
  final _uiComponentsNamesController =
      StreamController<List<String>>.broadcast();

  final _userNameSelectedSream = StreamController<bool>.broadcast();
  final _designationSelectedStream = StreamController<bool>.broadcast();

  @override
  Future<List<BranchDetail>?> getBranchesList() async {
    return await _apiCalls.getAllBranchListWithoutPagination();
  }

  @override
  List<String> get branchList => _branchList;

  @override
  String? get selectedBranch => _selectedBranch;

  set selectedBranch(String? value) {
    _selectedBranch = value;
  }

  @override
  Future<GetConfigurationModel?> getRoleConfigList() async {
    return await _apiCalls.getConfigById(AppConstants.designation);
  }

  @override
  Future<GetConfigurationModel?> getDesignationConfigList() async {
    return await _apiCalls.getConfigById(AppConstants.designation);
  }

  @override
  String? get selectedRole => _selectedRole;

  set selectedRole(String? value) {
    _selectedRole = value;
  }

  @override
  String? get selectedUserName => _selectedUserName;

  set selectedUserName(String? value) {
    _selectedUserName = value;
  }

  @override
  String? get selectedDesignation => _selectedDesignation;

  set selectedDesignation(String? value) {
    _selectedDesignation = value;
  }

  @override
  Future<GetConfigurationModel?> getMenuNameConfigList() async {
    return await _apiCalls.getConfigById(AppConstants.menus);
  }

  @override
  Future<GetConfigurationModel?> getUiComponentsConfigList() async {
    return await _apiCalls.getConfigById(AppConstants.uiComponents);
  }

  @override
  TabController get accessControlTabController => _accessControlTabController;

  set accessControlTabController(TabController tabValue) {
    _accessControlTabController = tabValue;
  }

  @override
  List<String> get menusList => _menusList;

  @override
  Stream<List<String>> get screenNamesStream => _screenNamesController.stream;
  @override
  Stream<List<bool>> get hideChecksStream => _hideChecksController.stream;
  @override
  Stream<List<bool>> get viewChecksStream => _viewChecksController.stream;
  @override
  Stream<List<bool>> get addChecksStream => _addChecksController.stream;
  @override
  Stream<List<bool>> get pUpdateChecksStream => _pUpdateChecksController.stream;
  @override
  Stream<List<bool>> get fUpdateChecksStream => _fUpdateChecksController.stream;
  @override
  Stream<List<bool>> get deleteChecksStream => _deleteChecksController.stream;

  @override
  Stream<List<String>> get uiComponentsNameStream =>
      _uiComponentsNamesController.stream;

  // Stream updates
  void updateScreenNames(List<String> screenNames) {
    screenNameList = screenNames;
    _screenNamesController.sink.add(screenNames);
    _initializeCheckboxStates(screenNames.length);
  }

  void updateUiComponentNameList(List<String> componentNames) {
    uiComponentList = componentNames;
    _uiComponentsNamesController.sink.add(componentNames);
    _initializeCheckboxStates(componentNames.length);
  }

  void _initializeCheckboxStates(int length) {
    if (_hideChecks.isEmpty) {
      _hideChecks = List<bool>.filled(length, false);
      _viewChecks = List<bool>.filled(length, false);
      _addChecks = List<bool>.filled(length, false);
      _pUpdateChecks = List<bool>.filled(length, false);
      _fUpdateChecks = List<bool>.filled(length, false);
      _deleteChecks = List<bool>.filled(length, false);

      _hideChecksController.sink.add(_hideChecks);
      _viewChecksController.sink.add(_viewChecks);
      _addChecksController.sink.add(_addChecks);
      _pUpdateChecksController.sink.add(_pUpdateChecks);
      _fUpdateChecksController.sink.add(_fUpdateChecks);
      _deleteChecksController.sink.add(_deleteChecks);
    }
  }

  void updateHideCheck(int index, bool value) {
    _hideChecks[index] = value;
    _hideChecksController.sink.add(_hideChecks);

    if (value) {
      _accessLevels.add('HIDE');
      _viewChecks[index] = false;
      _addChecks[index] = false;
      _pUpdateChecks[index] = false;
      _fUpdateChecks[index] = false;
      _deleteChecks[index] = false;
    } else {
      _accessLevels.remove('HIDE');
    }

    // Notify listeners of changes
    _viewChecksController.sink.add(_viewChecks);
    _addChecksController.sink.add(_addChecks);
    _pUpdateChecksController.sink.add(_pUpdateChecks);
    _fUpdateChecksController.sink.add(_fUpdateChecks);
    _deleteChecksController.sink.add(_deleteChecks);
  }

  void updateViewCheck(int index, bool value) {
    _viewChecks[index] = value;
    _viewChecksController.sink.add(_viewChecks);

    if (value) {
      _accessLevels.add('VIEW');
    } else {
      _accessLevels.remove('VIEW');
    }
  }

  void updateAddCheck(int index, bool value) {
    _addChecks[index] = value;
    _addChecksController.sink.add(_addChecks);

    if (value) {
      _accessLevels.add('ADD');
    } else {
      _accessLevels.remove('ADD');
    }
  }

  void updatePUpdateCheck(int index, bool value) {
    _pUpdateChecks[index] = value;
    _pUpdateChecksController.sink.add(_pUpdateChecks);

    if (value) {
      _accessLevels.add('PUPDATE');
    } else {
      _accessLevels.remove('PUPDATE');
    }
  }

  void updateFUpdateCheck(int index, bool value) {
    _fUpdateChecks[index] = value;
    _fUpdateChecksController.sink.add(_fUpdateChecks);

    if (value) {
      _accessLevels.add('FUPDATE');
    } else {
      _accessLevels.remove('FUPDATE');
    }
  }

  void updateDeleteCheck(int index, bool value) {
    _deleteChecks[index] = value;
    _deleteChecksController.sink.add(_deleteChecks);

    if (value) {
      _accessLevels.add('DELETE');
      // If "Delete" is checked, select all other checkboxes (except "Hide")
      _viewChecks[index] = true;
      _addChecks[index] = true;
      _pUpdateChecks[index] = true;
      _fUpdateChecks[index] = true;

      _viewChecksController.sink.add(_viewChecks);
      _addChecksController.sink.add(_addChecks);
      _pUpdateChecksController.sink.add(_pUpdateChecks);
      _fUpdateChecksController.sink.add(_fUpdateChecks);
    } else {
      _accessLevels.remove('DELETE');
      // If "Delete" is unchecked, unselect all other checkboxes (except "Hide")
      _viewChecks[index] = false;
      _addChecks[index] = false;
      _pUpdateChecks[index] = false;
      _fUpdateChecks[index] = false;

      _viewChecksController.sink.add(_viewChecks);
      _addChecksController.sink.add(_addChecks);
      _pUpdateChecksController.sink.add(_pUpdateChecks);
      _fUpdateChecksController.sink.add(_fUpdateChecks);
    }
  }

  bool isHideChecked(int index) {
    if (index < 0 || index >= _hideChecks.length) return false;
    return _hideChecks[index];
  }

  @override
  void dispose() {
    _screenNamesController.close();
    _hideChecksController.close();
    _viewChecksController.close();
    _addChecksController.close();
    _pUpdateChecksController.close();
    _fUpdateChecksController.close();
    _deleteChecksController.close();
    _uiComponentsNamesController.close();
  }

  @override
  Future<void> accessControlPostData(
      Function(int? statusCode) onSuccessCallBack,
      UserAccess requestObj) async {
    return await _apiCalls.accessControlPostData(onSuccessCallBack, requestObj);
  }

  @override
  List<String> get accessLevels => _accessLevels;

  @override
  List<String> get uiComponentsList => uiComponentList;

  @override
  Future<List<AccessControlList>?> getAllUserAccessControlData(
      {Function(int? statusCode,
              AccessControlList? getAllUserAccessControlDetails)?
          onSuccessCallback,
      String? branchId,
      String? userId,
      String? role}) {
    return _apiCalls.getAllUserAccessControlData(
      onSuccessCallback: onSuccessCallback,
      role: role,
      userId: userId,
      branchId: branchId,
    );
  }

  @override
  Future<List<UserDetailsList>?> getAllUserNameList() async {
    return await _apiCalls.getAllUserNameList();
  }

  @override
  Stream<bool> get refreshTabViewStream =>
      _refreshTabViewStreamController.stream;

  refreshTavViewStreamController(bool value) {
    _refreshTabViewStreamController.add(value);
  }

  @override
  Stream<bool> get checkBoxStream => _checkBoxStreamController.stream;

  checkBoxStreamController(bool value) {
    _checkBoxStreamController.add(value);
  }

  @override
  Future<void> accessControlUpdateData(
      Function(int? statusCode) onSuccessCallBack,
      UserAccess requestObj,
      String accessId) {
    return _apiCalls.accessControlUpdateData(
        onSuccessCallBack, requestObj, accessId);
  }

  @override
  Future<ParentResponseModel> getBranchName() {
    return _apiCalls.getBranchName();
  }

  @override
  String? get branchId => _branchId;
  set branchId(String? value) {
    _branchId = value;
  }

  @override
  Stream<bool> get userNameSelectStream => _userNameSelectedSream.stream;
  userNameSelectedSreamController(bool value) {
    _userNameSelectedSream.add(value);
  }

  @override
  Stream<bool> get designationSelectStream => _designationSelectedStream.stream;
  designationSelectedSreamController(bool value) {
    _designationSelectedStream.add(value);
  }
}
