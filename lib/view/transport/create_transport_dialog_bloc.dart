import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_transport_by_pagination.dart';
import 'package:tlbilling/models/post_model/add_transport_model.dart';

abstract class CreateTransportBloc {
  TextEditingController get transportNameController;

  TextEditingController get transportMobNoController;

  TextEditingController get transportCityController;

  GlobalKey<FormState> get transportFormKey;

  Future<void> addTransport(Function(int statusCode) successCallBack);

  Future<TransportDetails?> getTransportDetailById(String transportId);

  Future<void> editTransport(
      String transportId, Function(int statusCode) successCallBack);

  bool get isAsyncCall;
}

class CreateTransportBlocImpl extends CreateTransportBloc {
  final _transportFormKey = GlobalKey<FormState>();
  final _transportNameController = TextEditingController();
  final _transportMobNoController = TextEditingController();
  final _transportCityController = TextEditingController();
  final _apiServices = AppServiceUtilImpl();
  bool _isAsyncCall = false;

  @override
  TextEditingController get transportCityController => _transportCityController;

  @override
  TextEditingController get transportMobNoController =>
      _transportMobNoController;

  @override
  TextEditingController get transportNameController => _transportNameController;

  @override
  GlobalKey<FormState> get transportFormKey => _transportFormKey;

  @override
  Future<void> addTransport(Function(int statusCode) successCallBack) async {
    return _apiServices.addTransport(
        AddTransportModel(
            mobileNo: transportMobNoController.text,
            city: transportCityController.text,
            transportName: transportNameController.text),
        successCallBack);
  }

  @override
  Future<TransportDetails?> getTransportDetailById(String transportId) async {
    return _apiServices.getTransportDetailsById(transportId);
  }

  @override
  Future<void> editTransport(
      String transportId, Function(int statusCode) successCallBack) async {
    return _apiServices.editTransport(
        transportId,
        AddTransportModel(
            mobileNo: transportMobNoController.text,
            city: transportCityController.text,
            transportName: transportNameController.text),
        successCallBack);
  }

  @override
  bool get isAsyncCall => _isAsyncCall;

  set isAsyncCall(bool newValue) {
    _isAsyncCall = newValue;
  }
}
