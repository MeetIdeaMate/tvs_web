import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/utils/app_constants.dart';

abstract class TransferViewBloc {
  Stream get transporterNameSearchStream;

  Stream get vehicleNameSearchStream;

  TextEditingController get transporterNameSearchController;

  TextEditingController get vehicleNameSearchController;

  TabController get transferScreenTabController;
}

class TransferViewBlocImpl extends TransferViewBloc {
  final _transporterNameSearchController = TextEditingController();
  final _vehicleNameSearchController = TextEditingController();
  final _transporterNameSearchStream = StreamController.broadcast();
  final _vehicleNameSearchStream = StreamController.broadcast();
  late TabController _transferScreenTabController;
  final List<String> status = ['Transferred', 'Not Transferred'];
  List<Map<String, String>> rowData = [
    {
      AppConstants.sno: '1',
      AppConstants.fromBranch: 'Kovilpatti',
      AppConstants.toBranch: 'Sattur',
      AppConstants.transporterName: 'AK Logistics PVT LTD',
      AppConstants.mobileNumber: '9876543210',
      AppConstants.vehicleNumber: 'TN9834212',
      AppConstants.status: 'Transferred',
    },
    {
      AppConstants.sno: '2',
      AppConstants.fromBranch: 'Virudhunagar',
      AppConstants.toBranch: 'Sattur',
      AppConstants.transporterName: 'AK Transporters',
      AppConstants.mobileNumber: '7654321890',
      AppConstants.vehicleNumber: 'TN2348234',
      AppConstants.status: 'Not Transferred',
    },
  ];
  String? selectedStatus;

  @override
  TextEditingController get transporterNameSearchController =>
      _transporterNameSearchController;

  @override
  TextEditingController get vehicleNameSearchController =>
      _vehicleNameSearchController;

  @override
  Stream get transporterNameSearchStream => _transporterNameSearchStream.stream;

  transporterNameStreamController(bool streamValue) {
    _transporterNameSearchStream.add(streamValue);
  }

  @override
  Stream get vehicleNameSearchStream => _vehicleNameSearchStream.stream;

  vehicleNameSearchStreamController(bool streamValue) {
    _vehicleNameSearchStream.add(streamValue);
  }

  @override
  TabController get transferScreenTabController => _transferScreenTabController;

  set transferScreenTabController(TabController controllerValue) {
    _transferScreenTabController = controllerValue;
  }
}
