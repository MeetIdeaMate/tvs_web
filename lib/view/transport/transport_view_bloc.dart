import 'package:flutter/material.dart';

abstract class TransportViewBloc {
  TextEditingController get transportNameSearchController;
  TextEditingController get transportMobNoSearchController;
  TextEditingController get transportCitySearchController;
}

class TransportBlocImpl extends TransportViewBloc {
  final _transportNameSearchController = TextEditingController();
  final _transportMobNoSearchController = TextEditingController();
  final _transportCitySearchController = TextEditingController();

  @override
  TextEditingController get transportCitySearchController =>
      _transportCitySearchController;

  @override
  TextEditingController get transportMobNoSearchController =>
      _transportMobNoSearchController;

  @override
  TextEditingController get transportNameSearchController =>
      _transportNameSearchController;
}
