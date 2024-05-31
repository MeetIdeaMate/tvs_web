import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_transport_by_pagination.dart';

abstract class TransportViewBloc {
  TextEditingController get transportNameSearchController;

  TextEditingController get transportMobNoSearchController;

  TextEditingController get transportCitySearchController;

  Stream get transportNameStreamController;

  Stream get transportMobileNumberStreamController;

  Stream get transportCityStreamController;

  Stream get tablePageNoStreamController;

  int get currentPage;

  Future<GetTransportByPaginationModel?> getAllTransportByPagination();
}

class TransportBlocImpl extends TransportViewBloc {
  final _transportNameSearchController = TextEditingController();
  final _transportMobNoSearchController = TextEditingController();
  final _transportCitySearchController = TextEditingController();
  final _transportNameStreamController = StreamController.broadcast();
  final _transportMobileNumberStreamController = StreamController.broadcast();
  final _transportCityStreamController = StreamController.broadcast();
  final _tablePageNoStreamController = StreamController.broadcast();
  int _currentPage = 0;
  final _apiCalls = AppServiceUtilImpl();

  @override
  TextEditingController get transportCitySearchController =>
      _transportCitySearchController;

  @override
  TextEditingController get transportMobNoSearchController =>
      _transportMobNoSearchController;

  @override
  TextEditingController get transportNameSearchController =>
      _transportNameSearchController;

  @override
  Stream get transportCityStreamController =>
      _transportCityStreamController.stream;

  transportCityStream(bool? streamValue) {
    _transportCityStreamController.add(streamValue);
  }

  @override
  Stream get transportMobileNumberStreamController =>
      _transportMobileNumberStreamController.stream;

  transportMobileNumberStream(bool? streamValue) {
    _transportMobileNumberStreamController.add(streamValue);
  }

  @override
  Stream get transportNameStreamController =>
      _transportNameStreamController.stream;

  transportNameStream(bool? streamValue) {
    _transportNameStreamController.add(streamValue);
  }

  @override
  int get currentPage => _currentPage;

  set currentPage(int newValue) {
    _currentPage = newValue;
  }

  @override
  Stream get tablePageNoStreamController => _tablePageNoStreamController.stream;

  tablePageNoStream(int? streamValue) {
    _tablePageNoStreamController.add(streamValue);
  }

  @override
  Future<GetTransportByPaginationModel?> getAllTransportByPagination() async {
    return _apiCalls.getTransportByPagination(
        currentPage,
        transportCitySearchController.text,
        transportMobNoSearchController.text,
        transportNameSearchController.text);
  }
}
