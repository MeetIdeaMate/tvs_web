import 'package:flutter/material.dart';

abstract class CreateTransportBloc {
  TextEditingController get transportNameController;
  TextEditingController get transportMobNoController;
  TextEditingController get transportCityController;
  GlobalKey<FormState> get transportFormKey;
}

class CreateTransportBlocImpl extends CreateTransportBloc {
  final _transportFormKey = GlobalKey<FormState>();
  final _transportNameController = TextEditingController();
  final _transportMobNoController = TextEditingController();
  final _transportCityController = TextEditingController();

  @override
  TextEditingController get transportCityController => _transportCityController;

  @override
  TextEditingController get transportMobNoController =>
      _transportMobNoController;

  @override
  TextEditingController get transportNameController => _transportNameController;

  @override
  GlobalKey<FormState> get transportFormKey => _transportFormKey;
}
