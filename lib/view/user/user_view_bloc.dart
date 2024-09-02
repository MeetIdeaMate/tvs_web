import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/api_service/service_locator.dart';
import 'package:tlbilling/models/parent_response_model.dart';
import 'package:tlbilling/models/user_model.dart';

abstract class UserViewBloc {
  TextEditingController get searchUserNameAndMobNoController;
  String? get selectedDestination;
  Future<UsersListModel?> getUserList();
  Future<List<String>> getConfigByIdModel({String? configId});
  Stream<bool> get userListStream;
  int get currentPage;
  Stream<int> get pageNumberStream;
  String? get branchId;
  bool? get isMainBranch;
  String? get branchName;
  Future<ParentResponseModel> getBranchName();
}

class UserViewBlocImpl extends UserViewBloc {
  final _searchUserNameAndMobNoController = TextEditingController();
  String? _selectedDestination;
  final _userListStream = StreamController<bool>.broadcast();
  // final _appServiceUtilsImpl = AppServiceUtilImpl();
  final _appServiceUtilsImpl = getIt<AppServiceUtilImpl>();

  int _currentPage = 0;
  final _pageNumberStreamController = StreamController<int>.broadcast();
  String? _branchId;
  bool? _isMainBranch;
  String? _branchName;

  @override
  TextEditingController get searchUserNameAndMobNoController =>
      _searchUserNameAndMobNoController;

  @override
  String? get selectedDestination => _selectedDestination;
  set selectedDestination(String? newValue) {
    _selectedDestination = newValue;
  }

  @override
  Future<UsersListModel?> getUserList() {
    return _appServiceUtilsImpl.getUserList(
        _searchUserNameAndMobNoController.text,
        _selectedDestination ?? '',
        currentPage,
        branchId ?? '');
  }

  @override
  Future<List<String>> getConfigByIdModel({String? configId}) {
    return _appServiceUtilsImpl.getConfigByIdModel(configId: configId);
  }

  @override
  Stream<bool> get userListStream => _userListStream.stream;

  usersListStream(bool newValue) {
    _userListStream.add(newValue);
  }

  @override
  int get currentPage => _currentPage;
  set currentPage(int pageValue) {
    _currentPage = pageValue;
  }

  @override
  Stream<int> get pageNumberStream => _pageNumberStreamController.stream;

  pageNumberUpdateStreamController(int streamValue) {
    _pageNumberStreamController.add(streamValue);
  }

  @override
  String? get branchId => _branchId;
  set branchId(String? value) {
    _branchId = value;
  }

  @override
  bool? get isMainBranch => _isMainBranch;

  set isMainBranch(bool? value) {
    _isMainBranch = value;
  }

  @override
  String? get branchName => _branchName;
  set branchName(String? value) {
    _branchName = value;
  }

  @override
  Future<ParentResponseModel> getBranchName() {
    return _appServiceUtilsImpl.getBranchName();
  }
}
