import 'dart:async';

abstract class AccessControlViewBloc {
  List<String> get screenNameList;

  Stream<List<bool>> get hideChecksStream;
  Stream<List<bool>> get viewChecksStream;
  Stream<List<bool>> get addChecksStream;
  Stream<List<bool>> get pUpdateChecksStream;
  Stream<List<bool>> get fUpdateChecksStream;
  Stream<List<bool>> get deleteChecksStream;

  void updateHideCheck(int index, bool value);
  void updateViewCheck(int index, bool value);
  void updateAddCheck(int index, bool value);
  void updatePUpdateCheck(int index, bool value);
  void updateFUpdateCheck(int index, bool value);
  void updateDeleteCheck(int index, bool value);

  bool isHideChecked(int index);

  void dispose();
}

class AccessControlViewBlocImpl implements AccessControlViewBloc {
  final _hideChecksController = StreamController<List<bool>>.broadcast();
  final _viewChecksController = StreamController<List<bool>>.broadcast();
  final _addChecksController = StreamController<List<bool>>.broadcast();
  final _pUpdateChecksController = StreamController<List<bool>>.broadcast();
  final _fUpdateChecksController = StreamController<List<bool>>.broadcast();
  final _deleteChecksController = StreamController<List<bool>>.broadcast();

  @override
  Stream<List<bool>> get hideChecksStream => _hideChecksController.stream;
  @override
  Stream<List<bool>> get viewChecksStream => _viewChecksController.stream;
  @override
  Stream<List<bool>> get addChecksStream => _addChecksController.stream;
  @override
  Stream<List<bool>> get pUpdateChecksStream => _pUpdateChecksController.stream;
  @override
  Stream<List<bool>> get fUpdateChecksStream => _fUpdateChecksController.stream;
  @override
  Stream<List<bool>> get deleteChecksStream => _deleteChecksController.stream;

  List<bool> hideChecks = List.generate(5, (index) => false);
  List<bool> viewChecks = List.generate(5, (index) => false);
  List<bool> addChecks = List.generate(5, (index) => false);
  List<bool> pUpdateChecks = List.generate(5, (index) => false);
  List<bool> fUpdateChecks = List.generate(5, (index) => false);
  List<bool> deleteChecks = List.generate(5, (index) => false);

  @override
  List<String> screenNameList = [
    'Dashboard',
    'Purchase',
    'Sales',
    'Transfer',
    'Stock'
  ];

  @override
  void updateHideCheck(int index, bool value) {
    hideChecks[index] = value;
    _hideChecksController.add(hideChecks);
    if (value) {
      _disableAllOtherCheckboxes(index);
    } else {
      _enableAllCheckboxes();
    }
  }

  void _disableAllOtherCheckboxes(int index) {
    _viewChecksController.add(_createDisabledList(index));
    _addChecksController.add(_createDisabledList(index));
    _pUpdateChecksController.add(_createDisabledList(index));
    _fUpdateChecksController.add(_createDisabledList(index));
    _deleteChecksController.add(_createDisabledList(index));
  }

  void _enableAllCheckboxes() {
    _viewChecksController
        .add(List.generate(screenNameList.length, (index) => false));
    _addChecksController
        .add(List.generate(screenNameList.length, (index) => false));
    _pUpdateChecksController
        .add(List.generate(screenNameList.length, (index) => false));
    _fUpdateChecksController
        .add(List.generate(screenNameList.length, (index) => false));
    _deleteChecksController.add(
        List.generate(screenNameList.length, (index) => !hideChecks[index]));
    //  false - > or !hideChecks[index] to enable the checkboxs after that
  }

  List<bool> _createDisabledList(int index) {
    return List.generate(
        screenNameList.length, (i) => i == index ? true : false);
  }

  @override
  void updateViewCheck(int index, bool value) {
    viewChecks[index] = value;
    _viewChecksController.add(viewChecks);
  }

  @override
  void updateAddCheck(int index, bool value) {
    addChecks[index] = value;
    _addChecksController.add(addChecks);
  }

  @override
  void updatePUpdateCheck(int index, bool value) {
    pUpdateChecks[index] = value;
    _pUpdateChecksController.add(pUpdateChecks);
  }

  @override
  void updateFUpdateCheck(int index, bool value) {
    fUpdateChecks[index] = value;
    _fUpdateChecksController.add(fUpdateChecks);
  }

  @override
  void updateDeleteCheck(int index, bool value) {
    deleteChecks[index] = value;
    _deleteChecksController.add(deleteChecks);
  }

  @override
  bool isHideChecked(int index) {
    return hideChecks[index];
  }

  @override
  void dispose() {
    _hideChecksController.close();
    _viewChecksController.close();
    _addChecksController.close();
    _pUpdateChecksController.close();
    _fUpdateChecksController.close();
    _deleteChecksController.close();
  }
}
