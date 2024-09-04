import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlbilling/models/get_model/get_all_access_controll_model.dart';

class UserAccessLevels {
  static const String _userAccessKey = 'user_access';

  static Future<void> storeUserAccessData(
      AccessControlList accessControlList) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, List<String>> menuAccess = {};

    for (MenuList menu in accessControlList.menus ?? []) {
      menuAccess[menu.menuName ?? ''] = menu.accessLevels ?? [];
    }

    await prefs.setString(_userAccessKey, json.encode(menuAccess));
  }

  static Future<Map<String, List<String>>> _getStoredUserAccessData() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_userAccessKey);
    if (jsonString != null) {
      return Map<String, List<String>>.from(json
          .decode(jsonString)
          .map((key, value) => MapEntry(key, List<String>.from(value))));
    }
    return {};
  }

  static Future<bool> hasAccess(String menuName, String accessLevel) async {
    Map<String, List<String>> menuAccess = await _getStoredUserAccessData();
    return menuAccess[menuName]?.contains(accessLevel) ?? false;
  }

  static Future<List<String>?> getAccessLevels(String menuName) async {
    Map<String, List<String>> menuAccess = await _getStoredUserAccessData();
    return menuAccess[menuName];
  }
}
