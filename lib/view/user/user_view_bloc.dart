import 'package:flutter/material.dart';

abstract class UserViewBloc {
  TextEditingController get searchUserNameAndMobNoController;
  String? get selectedDestination;
}

class UserViewBlocImpl extends UserViewBloc {
  final _searchUserNameAndMobNoController = TextEditingController();
  String? _selectedDestination;

  @override
  TextEditingController get searchUserNameAndMobNoController =>
      _searchUserNameAndMobNoController;

  @override
  String? get selectedDestination => _selectedDestination;
  set selectedDestination(String? newValue) {
    _selectedDestination = newValue;
  }
}
