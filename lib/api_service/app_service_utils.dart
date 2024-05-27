// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlbilling/api_service/app_url.dart';
import 'package:tlbilling/models/get_employee_by_id.dart';
import 'package:tlbilling/models/get_model/get_all_customer_by_pagination_model.dart';
import 'package:tlbilling/models/get_model/get_all_customers_model.dart';
import 'package:tlbilling/models/get_model/get_all_employee_by_pagination.dart';
import 'package:tlbilling/models/parent_response_model.dart';
import 'package:tlbilling/models/post_model/add_branch_model.dart';
import 'package:tlbilling/models/post_model/add_customer_model.dart';
import 'package:tlbilling/models/post_model/add_employee_model.dart';
import 'package:tlbilling/models/user_model.dart';
import 'package:tlbilling/utils/app_constants.dart';

abstract class AppServiceUtil {
  Future<void> login(
      String userName, String password, Function(int) onSuccessCallBack);

  Future<void> addBranch(AddBranchModel addBranchModel,
      Function(int? statusCode) onSuccessCallBack);

  Future<void> addCustomer(Function(int? statusCode) onSuccessCallBack,
      AddCustomerModel addEmployeeModel);

  Future<GetAllCustomersByPaginationModel?> getAllCustomersByPagination(
      String city, String mobileNumber, String customerName);

  Future<GetAllCustomersModel?> getCustomerDetails(String customerId);

  Future<void> updateCustomer(
      String customerId,
      AddCustomerModel addCustomerModel,
      Function(int statusCode) onSuccessCallBack);
  //Future<UserList>? getAllUserList();
  Future<UsersListModel?> getUserList(
      String userName, String selectedDesignation);

  Future<List<String>> getConfigByIdModel({String? configId});
  Future<ParentResponseModel> getEmployeesName();

  Future<List<Content>?> getAllEmployeesByPaginationModel(
      String employeeName, String city, String designation, String branchName);
  Future<GetEmployeeById?> getEmployeeById(String employeeId);
  Future<void> updateUserStatus(String? userId, String? userUpdateStatus,
      Function(int statusCode) onSuccessCallBack);

  Future<void> onboardNewUser(
      Function onSuccessCallBack,
      Function onErrorCallBack,
      String selectedDesignation,
      String selectedUserName,
      String employeeId,
      String password,
      String mobileNumber);

  Future<void> onboardNewEmployee(
      AddEmployeeModel empObj, Function(int? statusCode) statusCode);

  Future<void> updateEmployee(String employeeId, AddEmployeeModel empObj,
      Function(int? statusCode) statusCode);

  Future<ParentResponseModel> getBranchName();
}

class AppServiceUtilImpl extends AppServiceUtil {
  final dio = Dio();

  @override
  Future<void> login(String userName, String password,
      Function(int p1) onSuccessCallBack) async {
    try {
      var response = await dio.post(AppUrl.login,
          data: {'mobileNo': userName, 'passWord': password});
      if (response.statusCode == 200 || response.statusCode == 201) {
        var designation = response.data['result']['login']['designation'];
        var token = response.data['result']['login']['token'];
        var userName = response.data['result']['login']['userName'];
        var userId = response.data['result']['login']['userId'];
        var useRefId = response.data['result']['login']['useRefId'] ?? '';
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(AppConstants.token, token);
        prefs.setString(AppConstants.designation, designation);
        prefs.setString(AppConstants.userName, userName);
        prefs.setString(AppConstants.userId, userId);
        prefs.setString(AppConstants.useRefId, useRefId);
        onSuccessCallBack(response.statusCode ?? 0);
      }
    } on DioException catch (e) {
      onSuccessCallBack(e.response?.statusCode ?? 0);
    }
  }

  @override
  Future<void> addBranch(AddBranchModel addBranchModel,
      Function(int? statusCode) onSuccessCallBack) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      var response =
          await dio.post(AppUrl.addBranch, data: jsonEncode(addBranchModel));
      onSuccessCallBack(response.statusCode);
    } on DioException catch (e) {
      onSuccessCallBack(e.response?.statusCode);
    }
  }

  @override
  Future<UsersListModel?> getUserList(
      String userName, String selectedDesignation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String userListUrl = AppUrl.user;
    print('**************8$userName');
    if (userName.isNotEmpty) {
      userListUrl += '&userName=$userName';
    }
    if (selectedDesignation.isNotEmpty && selectedDesignation != 'All') {
      userListUrl += '&designation=$selectedDesignation';
    }
    print(userListUrl);
    final response = await dio.get(userListUrl);

    print('***************************$userListUrl');
    print(response.statusCode);

    return parentResponseModelFromJson(jsonEncode(response.data))
        .result
        ?.usersListModel;
  }

  @override
  Future<void> addCustomer(Function(int? statusCode) onSuccessCallBack,
      AddCustomerModel addEmployeeModel) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      var response =
          await dio.post(AppUrl.customer, data: jsonEncode(addEmployeeModel));
      onSuccessCallBack(response.statusCode);
    } on DioException catch (e) {
      onSuccessCallBack(e.response?.statusCode);
    }
  }

  @override
  Future<GetAllCustomersByPaginationModel?> getAllCustomersByPagination(
      String city, String mobileNumber, String customerName) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      String url = '${AppUrl.customer}/page?page=0&size=10';
      if (city.isNotEmpty) {
        url += '&city=$city';
      }
      if (customerName.isNotEmpty) {
        url += '&customerName=$customerName';
      }
      if (mobileNumber.isNotEmpty) {
        url += '&mobileNo=$mobileNumber';
      }
      var response = await dio.get('${url}');
      return parentResponseModelFromJson(jsonEncode(response.data))
          .result
          ?.getAllCustomersByPaginationModel;
    } on DioException catch (e) {}
    return null;
  }

  @override
  Future<GetAllCustomersModel?> getCustomerDetails(String customerId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      var response = await dio.get('${AppUrl.customer}/$customerId');
      return GetAllCustomersModel.fromJson(response.data);
    } on DioException catch (e) {}
    return null;
  }

  @override
  Future<void> updateCustomer(
      String customerId,
      AddCustomerModel addCustomerModel,
      Function(int statusCode) onSuccessCallBack) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      var response = await dio.put('${AppUrl.customer}/$customerId',
          data: jsonEncode(addCustomerModel));
      onSuccessCallBack(response.statusCode ?? 0);
    } on DioException catch (e) {
      onSuccessCallBack(e.response?.statusCode ?? 0);
    }
  }

  @override
  Future<List<String>> getConfigByIdModel({String? configId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String configUrl = '${AppUrl.config}$configId';

    final response = await dio.get(configUrl);
    print(' Url $configUrl');
    print(' satatus code config ${response.statusCode}');
    if (response.statusCode == 200) {
      return parentResponseModelFromJson(jsonEncode(response.data))
              .result
              ?.getConfigModel
              ?.configuration ??
          [];
    } else {
      throw Exception('Failed to load employee data: ${response.statusCode}');
    }
  }

  @override
  Future<List<Content>> getAllEmployeesByPaginationModel(String employeeName,
      String city, String designation, String branchName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String employeeListUrl = AppUrl.employeeByPagination;

    if (employeeName.isNotEmpty) {
      employeeListUrl += '&employeeName=$employeeName';
    }
    if (designation.isNotEmpty || designation != 'All') {
      employeeListUrl += '&designation=$designation';
    }
    if (branchName.isNotEmpty) {
      employeeListUrl += '&branchName=$branchName';
    }

    var response = await dio.get(employeeListUrl);
    final responseList = parentResponseModelFromJson(jsonEncode(response.data));
    print(employeeListUrl);
    print(parentResponseModelFromJson(jsonEncode(response.data)).toJson());
    print(response.statusCode);
    return responseList.result?.getAllEmployeesByPaginationModel?.content ?? [];
  }

  @override
  Future<ParentResponseModel> getEmployeesName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String employeeListUrl = AppUrl.employee;

    var response = await dio.get(employeeListUrl);
    final responseList = parentResponseModelFromJson(jsonEncode(response.data));

    return responseList;
  }

  @override
  Future<ParentResponseModel> getBranchName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String branchListUrl = AppUrl.addBranch;

    var response = await dio.get(branchListUrl);
    final responseList = parentResponseModelFromJson(jsonEncode(response.data));

    return responseList;
  }

  @override
  Future<GetEmployeeById?> getEmployeeById(String employeeId) async {
    final dio = Dio();
    String employeeUrl = '${AppUrl.employee}/$employeeId';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    var response = await dio.get(employeeUrl);

    var empDetails = parentResponseModelFromJson(jsonEncode(response.data))
        .result
        ?.employeeById;

    return empDetails;
  }

  @override
  Future<void> onboardNewUser(
      Function onSuccessCallBack,
      Function onErrorCallBack,
      String selectedDesignation,
      String selectedUserName,
      String employeeId,
      String password,
      String mobileNumber) async {
    final dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Map<String, dynamic> jsonObjectForUser = {
      'designation': selectedDesignation,
      'mobileNo': mobileNumber,
      'passWord': password,
      'userName': selectedUserName,
      'useRefId': employeeId,
    };

    var selectedJson = jsonObjectForUser;
    try {
      var response = await dio.post(AppUrl.newUserOnboard,
          options: Options(headers: <String, String>{
            'Content-Type': 'application/json',
          }),
          data: jsonEncode(selectedJson));
      if (response.statusCode == 200 || response.statusCode == 201) {
        onSuccessCallBack();
      } else if (response.statusCode != null) {
        onErrorCallBack(response.statusCode);
      }
    } on DioException catch (e) {
      onErrorCallBack(e.response?.statusCode);
    }
  }

  @override
  Future<void> onboardNewEmployee(
      AddEmployeeModel empObj, Function(int? statusCode) statusCode) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      var response =
          await dio.post(AppUrl.newEmployeeOnBoard, data: jsonEncode(empObj));
      print(response.data);
      statusCode(response.statusCode);
    } on DioException catch (e) {
      statusCode(e.response?.statusCode);
    }
  }

  @override
  Future<void> updateUserStatus(String? userId, String? userUpdateStatus,
      Function(int statusCode) onSuccessCallBack) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String updateUserStatusUrl =
        '${AppUrl.updateUserStatus}$userId?status=$userUpdateStatus';
    var response = await dio.patch(updateUserStatusUrl);
    onSuccessCallBack(response.statusCode ?? 0);
  }

  @override
  Future<void> updateEmployee(String employeeId, AddEmployeeModel empObj,
      Function(int? statusCode) statusCode) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      var response = await dio.put('${AppUrl.customer}/$employeeId',
          data: jsonEncode(empObj));
      statusCode(response.statusCode ?? 0);
    } on DioException catch (e) {
      statusCode(e.response?.statusCode ?? 0);
    }
  }
}
