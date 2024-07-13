import 'package:tlbilling/api_service/app_url.dart';
import 'package:tlbilling/services/api_response.dart';
import 'package:tlbilling/services/http_services.dart';

class AuthRequest extends HttpServices {
  Future<ApiResponse> loginRequest({
    required String userName,
    required String password,
  }) async {
    final apiResult = await post(
      AppUrl.login,
      {'mobileNo': userName, 'passWord': password},
    );
    return ApiResponse.fromResponse(apiResult);
  }
}
