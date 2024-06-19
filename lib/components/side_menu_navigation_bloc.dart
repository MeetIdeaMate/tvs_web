import 'dart:async';

import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_branch_model.dart';

abstract class SideMenuNavigationBloc {
  Stream get sideMenuStream;
  String? get userName;
  String? get designation;
  String? get branchId;
  Future<GetAllBranchList?> getBranchById();
}

class SideMenuNavigationBlocImpl extends SideMenuNavigationBloc {
  final _sideMenuStream = StreamController.broadcast();
  String? _userName;
  String? _designation;
  String? _branchId;
  final _apiServiceUtils = AppServiceUtilImpl();

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

  @override
  String? get branchId => _branchId;

  set branchId(String? newValue) {
    _branchId = newValue;
  }

  @override
  Future<GetAllBranchList?> getBranchById() {
    return _apiServiceUtils.getBranchDetailsById(branchId ?? '');
  }
}
