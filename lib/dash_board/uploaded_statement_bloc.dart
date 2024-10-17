import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_statement_list_model.dart';

abstract class UploadedStatementBloc {
  Future<List<GetAllStatementInfo>> getAllStatement();
  String? get statementId;
}

class UploadedStatementBlocImpl extends UploadedStatementBloc {
  final _apiService = AppServiceUtilImpl();
  String? _statementId;

  @override
  Future<List<GetAllStatementInfo>> getAllStatement() {
    return _apiService.getAllStatementInfo();
  }

  @override
  String? get statementId => _statementId;
  set statementId(String? statementId) {
    _statementId = statementId;
  }
}
