import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/api_service/service_locator.dart';
import 'package:tlbilling/models/get_model/get_configuration_model.dart';

abstract class ConfigurationDialogBloc {
  TextEditingController get configIdTextController;

  TextEditingController get addConfigTextController;

  TextEditingController get configValuesTextController;

  TextEditingController get defaultValueTextController;

  Future<GetConfigurationModel?> getConfigById(String configId);

  Future<void> updateConfigValues(Function(int statusCode) onSuccessCallBack);

  Future<void> createConfig(Function(int statusCode) onSuccessCallBack);

  bool get isAsyncCall;

  Stream get addChipStream;
}

class ConfigurationDialogBlocImpl extends ConfigurationDialogBloc {
  final _configIdTextController = TextEditingController();
  final _addConfigTextController = TextEditingController();
  final _configValuesTextController = TextEditingController();
  final _defaultValueTextController = TextEditingController();
  final _addChipStream = StreamController();
  final _appServices = getIt<AppServiceUtilImpl>();
  late List<String> configValues = [];
  bool _isAsyncCall = false;

  @override
  TextEditingController get configIdTextController => _configIdTextController;

  @override
  TextEditingController get addConfigTextController => _addConfigTextController;

  @override
  TextEditingController get configValuesTextController =>
      _configValuesTextController;

  @override
  Stream get addChipStream => _addChipStream.stream;

  addChipStreamController(bool streamValue) {
    _addChipStream.add(streamValue);
  }

  @override
  TextEditingController get defaultValueTextController =>
      _defaultValueTextController;

  @override
  Future<GetConfigurationModel?> getConfigById(String configId) async {
    return await _appServices.getConfigById(configId);
  }

  @override
  Future<void> updateConfigValues(
      Function(int statusCode) onSuccessCallBack) async {
    return await _appServices.updateConfigModel(configIdTextController.text,
        defaultValueTextController.text, configValues, onSuccessCallBack);
  }

  @override
  Future<void> createConfig(Function(int statusCode) onSuccessCallBack) async {
    return await _appServices.createConfig(configIdTextController.text,
        defaultValueTextController.text, configValues, onSuccessCallBack);
  }

  @override
  bool get isAsyncCall => _isAsyncCall;
  set isAsyncCall(bool call) {
    _isAsyncCall = call;
  }
}
