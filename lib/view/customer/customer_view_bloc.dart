import 'package:flutter/material.dart';

abstract class CustomerViewBloc {
  TextEditingController get custNameFilterController;
  TextEditingController get custCityTextController;
  TextEditingController get custMobileNoController;
}

class CustomerViewBlocImpl extends CustomerViewBloc {
  final _custMobileNoController = TextEditingController();
  final _custNameTextController = TextEditingController();
  final _custCityTextController = TextEditingController();

  @override
  TextEditingController get custMobileNoController => _custNameTextController;

  @override
  TextEditingController get custNameFilterController => _custMobileNoController;

  @override
  TextEditingController get custCityTextController => _custCityTextController;
}
