import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_customer_by_pagination_model.dart';

abstract class CustomerViewBloc {
  TextEditingController get custNameFilterController;

  TextEditingController get custCityTextController;

  TextEditingController get custMobileNoController;

  Stream get customerTableStreamController;

  Stream get customerNameStreamController;

  Stream get customerMobileNumberStreamController;

  Stream get customerCityStreamController;

  Future<GetAllCustomersByPaginationModel?> getAllCustomersByPagination();
}

class CustomerViewBlocImpl extends CustomerViewBloc {
  final _custMobileNoController = TextEditingController();
  final _custNameTextController = TextEditingController();
  final _custCityTextController = TextEditingController();
  final _customerTableStreamController = StreamController.broadcast();
  final _customerNameStreamController = StreamController.broadcast();
  final _customerMobileNumberStreamController = StreamController.broadcast();
  final _customerCityStreamController = StreamController.broadcast();
  final _appServices = AppServiceUtilImpl();

  @override
  TextEditingController get custMobileNoController => _custNameTextController;

  @override
  TextEditingController get custNameFilterController => _custMobileNoController;

  @override
  TextEditingController get custCityTextController => _custCityTextController;

  @override
  Future<GetAllCustomersByPaginationModel?>
      getAllCustomersByPagination() async {
    return _appServices.getAllCustomersByPagination(
        custCityTextController.text,
        custMobileNoController.text,
        custNameFilterController.text,
    );
  }

  @override
  Stream get customerTableStreamController =>
      _customerTableStreamController.stream;

  customerTableStream(bool streamValue) {
    _customerTableStreamController.add(streamValue);
  }

  @override
  Stream get customerNameStreamController =>
      _customerNameStreamController.stream;

  customerNameStream(bool streamValue) {
    _customerNameStreamController.add(streamValue);
  }

  @override
  Stream get customerCityStreamController =>
      _customerCityStreamController.stream;

  customerCityStream(bool streamValue) {
    _customerCityStreamController.add(streamValue);
  }

  @override
  Stream get customerMobileNumberStreamController =>
      _customerMobileNumberStreamController.stream;

  customerMobileNumberStream(bool streamValue) {
    _customerMobileNumberStreamController.add(streamValue);
  }
}
