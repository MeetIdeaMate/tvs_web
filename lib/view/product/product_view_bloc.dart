import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_product_by_pagination.dart';

abstract class ProductViewBloc {
  TextEditingController get productNameController;
  TextEditingController get partNoController;
  TextEditingController get hsnCodeController;
  Stream<bool> get productNameSearchStream;
  Stream<bool> get partNoSearchStream;
  Stream<bool> get hsnCodeSearchStream;
  Stream<int> get pageNumberStream;
  int get currentPage;
  Future<GetAllProductByPagination?> getAllProductByPagination();
}

class ProductViewBlocImpl extends ProductViewBloc {
  final _productNameController = TextEditingController();
  final _partNoController = TextEditingController();
  final _hsnCodeController = TextEditingController();
  final _productNameSearchStream = StreamController<bool>.broadcast();
  final _partNoSearchStream = StreamController<bool>.broadcast();
  final _hsnCodeSearchStream = StreamController<bool>.broadcast();
  final _pageNumberStream = StreamController<int>.broadcast();
  int _currentPage = 0;
  final apiService = AppServiceUtilImpl();

  @override
  TextEditingController get productNameController => _productNameController;
  @override
  TextEditingController get partNoController => _partNoController;
  @override
  TextEditingController get hsnCodeController => _hsnCodeController;

  @override
  Stream<bool> get productNameSearchStream => _productNameSearchStream.stream;

  @override
  Stream<bool> get partNoSearchStream => _partNoSearchStream.stream;
  @override
  Stream<bool> get hsnCodeSearchStream => _hsnCodeSearchStream.stream;
  @override
  Stream<int> get pageNumberStream => _pageNumberStream.stream;

  productNameSearchStreamController(bool value) {
    _productNameSearchStream.sink.add(value);
  }

  partNoSearchStreamController(bool value) {
    _partNoSearchStream.sink.add(value);
  }

  hsnCodeSearchStreamController(bool value) {
    _hsnCodeSearchStream.sink.add(value);
  }

  pageNumberStreamController(int value) {
    _pageNumberStream.sink.add(value);
  }

  set currentPage(int value) {
    _currentPage = value;
  }

  @override
  int get currentPage => _currentPage;

  @override
  Future<GetAllProductByPagination?> getAllProductByPagination() {
    return apiService.getAllProductByPagination(_productNameController.text,
        _partNoController.text, _hsnCodeController.text, currentPage);
  }
}
