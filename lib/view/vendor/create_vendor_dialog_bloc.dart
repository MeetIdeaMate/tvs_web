import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_vendor_by_id_model.dart';
import 'package:tlbilling/models/post_model/add_vendor_model.dart';

abstract class CreateVendorDialogBloc {
  TextEditingController get vendorNameTextController;
  TextEditingController get vendorMobNoController;
  TextEditingController get vendorCityController;
  TextEditingController get vendorAddressController;
  TextEditingController get vendorGstNoController;
  TextEditingController get vendorPanNoController;
  TextEditingController get vendorEmailIdcontroller;
  TextEditingController get vendorFaxController;
  TextEditingController get vendorAccNoController;
  TextEditingController get vendorIFSCCodeController;
  GlobalKey<FormState> get vendorFormKey;
  Future<void> addVendor(Function(int? statusCode) statusCode);
  Future<void> updateVendor(
      String vendorId, Function(int? statusCode) statusCode);
  Future<GetVendorById?> getVendorById(String vendorId);
}

class CreateVendorDialogBlocImpl extends CreateVendorDialogBloc {
  final _vendorFormKey = GlobalKey<FormState>();
  final _vendorNameTextController = TextEditingController();
  final _vendorMobNoController = TextEditingController();
  final _vendorCityController = TextEditingController();
  final _vendorAddressController = TextEditingController();
  final _vendorGstNoController = TextEditingController();
  final _vendorPanNoController = TextEditingController();
  final _vendorEmailIdcontroller = TextEditingController();
  final _vendorFaxController = TextEditingController();
  final _vendorAccNoController = TextEditingController();
  final _vendorIFSCCodeController = TextEditingController();
  final _appServiceBlocImpl = AppServiceUtilImpl();

  @override
  TextEditingController get vendorAddressController => _vendorAddressController;

  @override
  TextEditingController get vendorCityController => _vendorCityController;

  @override
  TextEditingController get vendorGstNoController => _vendorGstNoController;

  @override
  TextEditingController get vendorMobNoController => _vendorMobNoController;

  @override
  TextEditingController get vendorNameTextController =>
      _vendorNameTextController;

  @override
  TextEditingController get vendorPanNoController => _vendorPanNoController;

  @override
  TextEditingController get vendorFaxController => _vendorFaxController;

  @override
  TextEditingController get vendorEmailIdcontroller => _vendorEmailIdcontroller;

  @override
  GlobalKey<FormState> get vendorFormKey => _vendorFormKey;

  @override
  TextEditingController get vendorAccNoController => _vendorAccNoController;

  @override
  TextEditingController get vendorIFSCCodeController =>
      _vendorIFSCCodeController;

  @override
  Future<void> addVendor(Function(int? statusCode) statusCode) {
    return _appServiceBlocImpl.addVendor(
        AddVendorModel(
            accountNo: _vendorAccNoController.text,
            address: _vendorAddressController.text,
            city: _vendorCityController.text,
            emailId: _vendorEmailIdcontroller.text,
            gstNumber: _vendorGstNoController.text,
            ifscCode: _vendorIFSCCodeController.text,
            mobileNo: _vendorMobNoController.text,
            vendorName: _vendorNameTextController.text),
        statusCode);
  }

  @override
  Future<void> updateVendor(
      String vendorId, Function(int? statusCode) statusCode) {
    return _appServiceBlocImpl.updateVendor(
        vendorId,
        AddVendorModel(
            accountNo: _vendorAccNoController.text,
            address: _vendorAddressController.text,
            city: _vendorCityController.text,
            emailId: _vendorEmailIdcontroller.text,
            gstNumber: _vendorGstNoController.text,
            ifscCode: _vendorIFSCCodeController.text,
            mobileNo: _vendorMobNoController.text,
            vendorName: _vendorNameTextController.text),
        statusCode);
  }

  @override
  Future<GetVendorById?> getVendorById(String vendorId) {
    return _appServiceBlocImpl.getVendorById(vendorId);
  }
}
