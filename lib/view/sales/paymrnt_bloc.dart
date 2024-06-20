import 'dart:async';

abstract class Bloc {
  Stream get refresh;
}

class blocimpl extends Bloc {
  final _refresh = StreamController.broadcast();

  @override
  Stream get refresh => _refresh.stream;

  refreshStream(bool vcalue) {
    _refresh.add(vcalue);
  }
}
