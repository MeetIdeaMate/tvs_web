import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';

abstract class ProductConfigurationBloc {
  Future<List<String>> getConfigById();
  Stream get selectedConfigStream;
  Map<String, double> get configNameAndAmount;
  TextEditingController get amtTextController;
  Future<bool> updateProductConfig(Map<String, double> addOns, String itemId);
  ValueNotifier<bool> get isButtonDisabled;
}

class ProductConfigurationBlocImpl extends ProductConfigurationBloc {
  final _apiService = AppServiceUtilImpl();
  final _selectedConfigStream = StreamController.broadcast();
  final _amtTextController = TextEditingController();
  final List<String> selectedConfig = [];
  final ValueNotifier<bool> _isButtonDisabled = ValueNotifier<bool>(false);

  Map<String, double> _configNameAndAmount = {};

  @override
  Future<List<String>> getConfigById() {
    return _apiService.getConfigByIdModel(configId: 'ProductConfiguration');
  }

  @override
  Stream get selectedConfigStream => _selectedConfigStream.stream;

  selectConfigStreamController(bool value) {
    _selectedConfigStream.sink.add(value);
  }

  @override
  Map<String, double> get configNameAndAmount => _configNameAndAmount;

  set configNameAndAmount(Map<String, double> value) {
    _configNameAndAmount = value;
  }

  @override
  TextEditingController get amtTextController => _amtTextController;

  @override
  Future<bool> updateProductConfig(Map<String, double> addOns, String itemId) {
    return _apiService.updateProductConfig(addOns, itemId);
  }

  @override
  ValueNotifier<bool> get isButtonDisabled => _isButtonDisabled;
}
