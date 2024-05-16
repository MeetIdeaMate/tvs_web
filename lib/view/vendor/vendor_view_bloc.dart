import 'package:flutter/material.dart';

abstract class VendarViewBloc {
  TextEditingController get vendorNameSearchController;
  TextEditingController get vendorMobNoSearchController;
  TextEditingController get vendorCitySearchController;
}

class VendarViewBlocImpl extends VendarViewBloc {
  final _vendorNameSearchController = TextEditingController();
  final _vendorMobNoSearchController = TextEditingController();
  final _vendorCitySearchController = TextEditingController();

  @override
  TextEditingController get vendorCitySearchController =>
      _vendorNameSearchController;

  @override
  TextEditingController get vendorMobNoSearchController =>
      _vendorMobNoSearchController;

  @override
  TextEditingController get vendorNameSearchController =>
      _vendorCitySearchController;
}
