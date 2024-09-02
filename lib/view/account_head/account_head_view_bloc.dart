import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/api_service/service_locator.dart';
import 'package:tlbilling/models/get_model/get_all_account_head_by_pagination_model.dart';
import 'package:tlbilling/utils/app_constants.dart';

abstract class AccountViewBloc {
  TextEditingController get accCodeTextEditController;
  TextEditingController get nameTextEditController;
  String? get selectedType;
  Stream<bool> get accCodeTextEditStream;
  Stream<bool> get nameTextEditStream;
  Future<List<String>> getConfigByIdModel({String? configId});
  Future<GetAllAccountHeadPagination?> getAccountHead();
  int get currentPage;
  Stream<int> get pageNumberStream;
}

class AccountViewBlocImpl extends AccountViewBloc {
  final _accCodeTextEditController = TextEditingController();
  final _nameTextEditController = TextEditingController();
  final _accCodeTextEditStream = StreamController<bool>.broadcast();
  final _nameTextEditStream = StreamController<bool>.broadcast();
  final _appServiceUtilsImpl = getIt<AppServiceUtilImpl>();
  String? _selectedType = AppConstants.alltype;
  int _currentPage = 0;
  final _pageNumberStreamController = StreamController<int>.broadcast();
  @override
  TextEditingController get accCodeTextEditController =>
      _accCodeTextEditController;

  @override
  TextEditingController get nameTextEditController => _nameTextEditController;

  @override
  String? get selectedType => _selectedType;

  set selectedType(String? value) {
    _selectedType = value;
  }

  @override
  Stream<bool> get accCodeTextEditStream => _accCodeTextEditStream.stream;

  @override
  Stream<bool> get nameTextEditStream => _nameTextEditStream.stream;

  accCodeTextEditStreamController(bool value) {
    _accCodeTextEditStream.add(value);
  }

  @override
  Future<List<String>> getConfigByIdModel({String? configId}) {
    return _appServiceUtilsImpl.getConfigByIdModel(configId: configId);
  }

  nameTextEditStreamController(bool value) {
    _nameTextEditStream.add(value);
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
  Future<GetAllAccountHeadPagination?> getAccountHead() {
    return _appServiceUtilsImpl.getAccountHeadPagination(
        accountHeadCode: _accCodeTextEditController.text,
        accountHeadName: _nameTextEditController.text,
        accountType: _selectedType,
        currentPage: currentPage);
  }
}
