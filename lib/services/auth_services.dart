import 'package:tlbilling/services/local_storage.dart';
import 'package:tlbilling/utils/app_constants.dart';

class AuthServices {
   // Token
  static Future<String> getAuthBearerToken() async {
    return LocalStorageService.prefs?.getString(AppConstants.token) ?? "";
  }

  static Future<bool> setAuthBearerToken(token) async {
    return LocalStorageService.prefs!
        .setString(AppConstants.token, token);


  }
}