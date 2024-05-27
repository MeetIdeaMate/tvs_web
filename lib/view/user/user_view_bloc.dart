import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/user_model.dart';

abstract class UserViewBloc {
  TextEditingController get searchUserNameAndMobNoController;
  String? get selectedDestination;
  Future<UsersListModel?> getUserList();
  Future<List<String>> getConfigByIdModel({String? configId});
  Stream<bool> get userListStream;
  int get currentPage;
  Stream<int> get pageNumberStream;
}

class UserViewBlocImpl extends UserViewBloc {
  final _searchUserNameAndMobNoController = TextEditingController();
  String? _selectedDestination;
  final _userListStream = StreamController<bool>.broadcast();
  final _appServiceUtilsImpl = AppServiceUtilImpl();
  int _currentPage = 0;
  final _pageNumberStreamController = StreamController<int>.broadcast();

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
        currentPage);
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
}
