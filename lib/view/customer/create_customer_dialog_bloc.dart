import 'package:flutter/material.dart';

abstract class CreateCustomerDialogBloc {
  TextEditingController get customerNameTextController;
  TextEditingController get custMobileNoTextController;
  TextEditingController get custMailIdTextController;
  TextEditingController get custAccNoTextController;
  TextEditingController get custAadharNoTextController;
  TextEditingController get custCitytextcontroller;
  TextEditingController get custAddressTextController;
  GlobalKey<FormState> get custFormKey;
}

class CreateCustomerDialogBlocImpl extends CreateCustomerDialogBloc {
  final _custFormKey = GlobalKey<FormState>();
  final _customerNameTextController = TextEditingController();
  final _custMobileNoTextController = TextEditingController();
  final _custMailIdTextController = TextEditingController();
  final _custAccNoTextController = TextEditingController();
  final _custAadharNoTextController = TextEditingController();
  final _custCityTextController = TextEditingController();
  final _custAddressTextController = TextEditingController();

  @override
  TextEditingController get customerNameTextController =>
      _customerNameTextController;

  @override
  TextEditingController get custMobileNoTextController =>
      _custMobileNoTextController;

  @override
  TextEditingController get custMailIdTextController =>
      _custMailIdTextController;

  @override
  TextEditingController get custAccNoTextController => _custAccNoTextController;

  @override
  TextEditingController get custAadharNoTextController =>
      _custAadharNoTextController;

  @override
  TextEditingController get custCitytextcontroller => _custCityTextController;

  @override
  TextEditingController get custAddressTextController =>
      _custAddressTextController;

  @override
  GlobalKey<FormState> get custFormKey => _custFormKey;
}
