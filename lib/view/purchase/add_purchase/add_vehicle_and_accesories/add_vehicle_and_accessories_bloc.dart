import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AddVehicleAndAccessoriesBloc {
  TextEditingController get invoiceNumberController;

  TextEditingController get purchaseRefController;

  TextEditingController get carrierController;

  TextEditingController get carrierNumberController;

  TextEditingController get partNumberController;

  TextEditingController get hsnCodeController;

  TextEditingController get unitRateController;

  TextEditingController get engineNumberController;

  TextEditingController get frameNumberController;

  TextEditingController get materialNumberController;

  TextEditingController get materialNameController;

  TextEditingController get quantityController;

  TextEditingController get variantController;

  TextEditingController get colorController;

  TextEditingController get invoiceDateController;

  Stream get selectedPurchaseTypeStream;

  String? get vendorDropDownValue;

  String? get selectedPurchaseType;
}

class AddVehicleAndAccessoriesBlocImpl extends AddVehicleAndAccessoriesBloc {
  final _invoiceNumberController = TextEditingController();
  final _purchaseRefController = TextEditingController();
  final _carrierNumberController = TextEditingController();
  final _carrierController = TextEditingController();
  final _partNumberController = TextEditingController();
  final _hsnCodeController = TextEditingController();
  final _unitRateController = TextEditingController();
  final _engineNumberController = TextEditingController();
  final _frameNumberController = TextEditingController();
  final _materialNumberController = TextEditingController();
  final _materialNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _variantController = TextEditingController();
  final _colorController = TextEditingController();
  final _invoiceDateController = TextEditingController();
  final _selectedPurchaseTypeStream = StreamController.broadcast();
  String? _vendorDropDownValue;
  String? _selectedPurchaseType;
  List<String> selectVendor = ['Ajithkumar', 'Peter', 'Prasath'];
  late Set<String> optionsSet = {selectedPurchaseType ?? ''};

  @override
  String? get vendorDropDownValue => _vendorDropDownValue;

  set vendorDropDownValue(String? value) {
    _vendorDropDownValue = value;
  }

  @override
  TextEditingController get invoiceNumberController => _invoiceNumberController;

  @override
  TextEditingController get purchaseRefController => _purchaseRefController;

  @override
  TextEditingController get carrierController => _carrierController;

  @override
  TextEditingController get carrierNumberController => _carrierNumberController;

  @override
  TextEditingController get partNumberController => _partNumberController;

  @override
  TextEditingController get hsnCodeController => _hsnCodeController;

  @override
  TextEditingController get unitRateController => _unitRateController;

  @override
  TextEditingController get engineNumberController => _engineNumberController;

  @override
  TextEditingController get frameNumberController => _frameNumberController;

  @override
  String? get selectedPurchaseType => _selectedPurchaseType;

  set selectedPurchaseType(String? newValue) {
    _selectedPurchaseType = newValue;
  }

  @override
  Stream get selectedPurchaseTypeStream => _selectedPurchaseTypeStream.stream;

  selectedPurchaseTypeStreamController(bool streamValue) {
    _selectedPurchaseTypeStream.add(streamValue);
  }

  @override
  TextEditingController get materialNameController => _materialNameController;

  @override
  TextEditingController get materialNumberController =>
      _materialNumberController;

  @override
  TextEditingController get quantityController => _quantityController;

  changeSegmentedColor(Color color) {
    return MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return color;
      }
      return null;
    });
  }

  @override
  TextEditingController get colorController => _colorController;

  @override
  TextEditingController get variantController => _variantController;

  @override
  TextEditingController get invoiceDateController => _invoiceDateController;
}
