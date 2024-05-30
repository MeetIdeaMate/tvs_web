import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class CreateVendorDialogBloc {
  TextEditingController get vendorNameTextController;
  TextEditingController get vendorMobNoController;
  TextEditingController get vendorCityController;
  TextEditingController get vendorAddressController;
  TextEditingController get vendorGstNoController;
  TextEditingController get vendorPanNoController;
  TextEditingController get vendorTelephoneNoController;
  TextEditingController get vendorFaxController;
  TextEditingController get vendorAccNoController;
  TextEditingController get vendorIFSCCodeController;
  GlobalKey<FormState> get vendorFormKey;
}

class CreateVendorDialogBlocImpl extends CreateVendorDialogBloc {
  final _vendorFormKey = GlobalKey<FormState>();
  final _vendorNameTextController = TextEditingController();
  final _vendorMobNoController = TextEditingController();
  final _vendorCityController = TextEditingController();
  final _vendorAddressController = TextEditingController();
  final _vendorGstNoController = TextEditingController();
  final _vendorPanNoController = TextEditingController();
  final _vendorTelephoneNoController = TextEditingController();
  final _vendorFaxController = TextEditingController();
  final _vendorAccNoController = TextEditingController();
  final _vendorIFSCCodeController = TextEditingController();

  @override
  TextEditingController get vendorAddressController =>
      _vendorNameTextController;

  @override
  TextEditingController get vendorCityController => _vendorMobNoController;

  @override
  TextEditingController get vendorGstNoController => _vendorCityController;

  @override
  TextEditingController get vendorMobNoController => _vendorAddressController;

  @override
  TextEditingController get vendorNameTextController => _vendorGstNoController;

  @override
  TextEditingController get vendorPanNoController => _vendorPanNoController;

  @override
  TextEditingController get vendorFaxController => _vendorFaxController;

  @override
  TextEditingController get vendorTelephoneNoController =>
      _vendorTelephoneNoController;

  @override
  GlobalKey<FormState> get vendorFormKey => _vendorFormKey;

  @override
  TextEditingController get vendorAccNoController => _vendorAccNoController;

  @override
  TextEditingController get vendorIFSCCodeController =>
      _vendorIFSCCodeController;
}
