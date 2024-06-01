import 'dart:async';

abstract class SideMenuNavigationBloc {
  Stream get sideMenuStream;
  String? get userName;
  String? get designation;
}

class SideMenuNavigationBlocImpl extends SideMenuNavigationBloc {
  final _sideMenuStream = StreamController.broadcast();
  String? _userName;
  String? _designation;
  @override
  Stream get sideMenuStream => _sideMenuStream.stream;
  sideMenuStreamController(bool stream) {
    _sideMenuStream.add(stream);
  }

  @override
  String? get designation => _designation;

  @override
  String? get userName => _userName;

  set userName(String? newValue) {
    _userName = newValue;
  }

  set designation(String? newValue) {
    _designation = newValue ?? '';
  }
}
