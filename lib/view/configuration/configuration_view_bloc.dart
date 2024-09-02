import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/api_service/service_locator.dart';
import 'package:tlbilling/models/get_model/get_configuration_list_model.dart';

abstract class ConfigurationViewBloc {
  Stream get searchConfigStream;

  Stream get reLoadStream;

  TextEditingController get configSearchTextController;

  Future<List<GetAllConfigurationListModel>?> getAllConfigList();
}

class ConfigurationBlocImpl extends ConfigurationViewBloc {
  final _appServices = getIt<AppServiceUtilImpl>();
  final _searchConfigStream = StreamController();
  final _reLoadStream = StreamController();
  final _configSearchTextController = TextEditingController();

  @override
  Stream get searchConfigStream => _searchConfigStream.stream;

  searchConfigStreamController(bool stream) {
    _searchConfigStream.add(stream);
  }

  @override
  TextEditingController get configSearchTextController =>
      _configSearchTextController;

  @override
  Future<List<GetAllConfigurationListModel>?> getAllConfigList() async {
    return await _appServices.getAllConfigList(configSearchTextController.text);
  }

  @override
  Stream get reLoadStream => _reLoadStream.stream;
  reLoadStreamController(bool stream) {
    _reLoadStream.add(stream);
  }
}
