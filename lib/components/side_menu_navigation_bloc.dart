import 'dart:async';

abstract class SideMenuNavigationBloc {
  Stream get sideMenuStream;
}

class SideMenuNavigationBlocImpl extends SideMenuNavigationBloc {
  final _sideMenuStream = StreamController.broadcast();
  @override
  Stream get sideMenuStream => _sideMenuStream.stream;
  sideMenuStreamController(bool stream) {
    _sideMenuStream.add(stream);
  }
}
