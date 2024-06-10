import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/parent_response_model.dart';

abstract class ReportScreenBloc {
  TabController get reportScreenTabController;
  Stream<bool> get dropDownChangeStream;
  Future<ParentResponseModel> getConfigByIdModel({String? configId});
}

class ReportScreenBlocImpl extends ReportScreenBloc {
  late TabController _reportScreenTabController;
  final _dropDownChangeStream = StreamController<bool>.broadcast();
  final _appServiceUtils = AppServiceUtilImpl();
  @override
  TabController get reportScreenTabController => _reportScreenTabController;

  set reportScreenTabController(TabController newTab) {
    _reportScreenTabController = newTab;
  }

  @override
  Stream<bool> get dropDownChangeStream => _dropDownChangeStream.stream;
  dropDownChangeStreamController(bool newValue) {
    _dropDownChangeStream.add(newValue);
  }

  @override
  Future<ParentResponseModel> getConfigByIdModel({String? configId}) {
    return _appServiceUtils.getConfigurationById(configId: configId);
  }
}
