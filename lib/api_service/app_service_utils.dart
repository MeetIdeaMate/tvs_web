import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlbilling/api_service/app_url.dart';
import 'package:tlbilling/models/get_employee_by_id.dart';
import 'package:tlbilling/models/get_model/get_all_booking_list_with_pagination.dart';
import 'package:tlbilling/models/get_model/get_all_branch_by_id_model.dart';
import 'package:tlbilling/models/get_model/get_all_branch_model.dart';
import 'package:tlbilling/models/get_model/get_all_branches_by_pagination.dart';
import 'package:tlbilling/models/get_model/get_all_category_model.dart';
import 'package:tlbilling/models/get_model/get_all_customer_by_pagination_model.dart';
import 'package:tlbilling/models/get_model/get_all_customer_name_list.dart';
import 'package:tlbilling/models/get_model/get_all_customers_model.dart';
import 'package:tlbilling/models/get_model/get_all_employee_by_pagination.dart';
import 'package:tlbilling/models/get_model/get_all_employee_model.dart';
import 'package:tlbilling/models/get_model/get_all_insurance_by_pagination_model.dart';
import 'package:tlbilling/models/get_model/get_all_purchase_model.dart';
import 'package:tlbilling/models/get_model/get_all_sales_list_model.dart';
import 'package:tlbilling/models/get_model/get_all_stock_with_pagination.dart';
import 'package:tlbilling/models/get_model/get_all_stocks_model.dart';
import 'package:tlbilling/models/get_model/get_all_stocks_without_pagination.dart';
import 'package:tlbilling/models/get_model/get_all_transfer_model.dart';
import 'package:tlbilling/models/get_model/get_all_vendor_by_pagination_model.dart';
import 'package:tlbilling/models/get_model/get_all_voucher_with_pagenation.dart';
import 'package:tlbilling/models/get_model/get_configuration_list_model.dart';
import 'package:tlbilling/models/get_model/get_configuration_model.dart';
import 'package:tlbilling/models/get_model/get_transport_by_pagination.dart';
import 'package:tlbilling/models/get_model/get_vendor_by_id_model.dart';
import 'package:tlbilling/models/parent_response_model.dart';
import 'package:tlbilling/models/post_model/add_branch_model.dart';
import 'package:tlbilling/models/post_model/add_customer_model.dart';
import 'package:tlbilling/models/post_model/add_employee_model.dart';
import 'package:tlbilling/models/post_model/add_new_booking_model.dart';
import 'package:tlbilling/models/post_model/add_new_transfer.dart';
import 'package:tlbilling/models/post_model/add_purchase_model.dart';
import 'package:tlbilling/models/post_model/add_sales_model.dart';
import 'package:tlbilling/models/post_model/add_transport_model.dart';
import 'package:tlbilling/models/post_model/add_vouchar_model.dart';
import 'package:tlbilling/models/update/update_branch_model.dart';
import 'package:tlbilling/models/user_model.dart';
import 'package:tlbilling/utils/app_constants.dart';

import '../models/post_model/add_vendor_model.dart';

abstract class AppServiceUtil {
  Future<void> login(
      String userName, String password, Function(int) onSuccessCallBack);

  Future<void> addBranch(AddBranchModel addBranchModel,
      Function(int? statusCode) onSuccessCallBack);

  Future<void> addCustomer(
      Function(int? statusCode, String? customerName, String? customerId)
          onSuccessCallBack,
      AddCustomerModel addEmployeeModel);

  Future<GetAllCustomersByPaginationModel?> getAllCustomersByPagination(
      String city, String mobileNumber, String customerName, int currentPage);

  Future<GetAllInsuranceByPaginationModel?> getAllInsuranceByPagination(
      String invoiceNo,
      String mobileNumber,
      String customerName,
      int currentPage);

  Future<GetAllCustomersModel?> getCustomerDetails(String customerId);

  Future<void> updateVendor(String vendorId, AddVendorModel vendorObj,
      Function(int? statusCode) statusCode);

  Future<GetAllSales?> getSalesList(String invoiceNo, String paymentType,
      String customerName, int currentPage);

  Future<List<GetAllStockDetails>?> getStockList(String? categoryName);

  Future<GetAllVendorByPagination?> getPurchaseReport(
      String vehicleType, String fromDate, String toDate, int currentPage);

  Future<void> updateCustomer(
      String customerId,
      AddCustomerModel addCustomerModel,
      Function(int statusCode) onSuccessCallBack);

  //Future<UserList>? getAllUserList();
  Future<UsersListModel?> getUserList(
      String userName, String selectedDesignation, int currentPage);

  Future<List<String>> getConfigByIdModel({String? configId});

  Future<ParentResponseModel> getEmployeesName();

  Future<ParentResponseModel> getConfigurationById({String? configId});

  // Future<List<Content>?> getAllEmployeesByPaginationModel(
  //     String employeeName, String city, String designation, String branchName);

  Future<GetAllEmployeesByPaginationModel> getAllEmployeesByPaginationModel(
      int currentPage,
      String employeeName,
      String city,
      String designation,
      String branchName);

  Future<GetAllVendorByPagination> getAllVendorByPagination(
      int currentPage, String vendorName, String city, String mobileNumber);

  Future<GetEmployeeById?> getEmployeeById(String employeeId);
  Future<void> addNewSalesDetails(
    AddSalesModel salesdata,
    Function(int value) onSuccessCallBack,
  );

  Future<GetBranchById?> getBranchById();

  Future<void> updateUserStatus(String? userId, String? userUpdateStatus,
      Function(int statusCode) onSuccessCallBack);

  Future<void> onboardNewUser(
      Function onSuccessCallBack,
      Function onErrorCallBack,
      String selectedDesignation,
      String selectedUserName,
      String branchId,
      String employeeId,
      String password,
      String mobileNumber);

  Future<bool> purchaseValidate(Map<String, String> itemDetails, String partNo);

  Future<void> onboardNewEmployee(
      AddEmployeeModel empObj, Function(int? statusCode) statusCode);
  Future<void> addNewVouchar(
      AddVocuhar voucharObj, Function(int? statusCode) statusCode);

  Future<void> addVendor(
      AddVendorModel vendorObj, Function(int? statusCode) statusCode);

  Future<void> updateEmployee(String employeeId, AddEmployeeModel empObj,
      Function(int? statusCode) statusCode);

  Future<ParentResponseModel> getBranchName();

  Future<ParentResponseModel> getAllVendorNameList();

  Future<List<GetAllCustomerNameList>?> getAllCustomerList();

  Future<GetAllPurchaseByPageNation?> getAllPurchaseByPagenation(
      int? currentIndex, String? invoiceNo, String? partNo, String? purchaseNo,
      {String? categoryName});

  Future<GetAllBranchesByPaginationModel?> getBranchList(
      int currentPage, String pinCode, String branchName, String? selectedCity);

  Future<GetAllBranchList?> getBranchDetailsById(String? branchId);

  Future<void> updateBranch(UpdateBranchModel updateBranchModel,
      String? branchId, Function(int statusCode) successCallBack);

  Future<void> addTransport(AddTransportModel addTransportModel,
      Function(int statusCode) successCallBack);

  Future<GetTransportByPaginationModel?> getTransportByPagination(
      int currentPage, String city, String mobileNumber, String transportName);

  Future<List<GetAllConfigurationListModel>?> getAllConfigList(String configId);

  Future<GetConfigurationModel?> getConfigById(String configId);

  Future<void> updateConfigModel(String configId, String defaultValue,
      List<String> configValues, Function(int statusCode) onSuccessCallBack);

  Future<void> createConfig(String? configId, String? defaultValue,
      List<String>? configValues, Function(int statusCode) onSuccessCallBack);

  Future<void> deleteBranch(
      Function(int statusCode) successCallBack, String branchId);

  Future<TransportDetails?> getTransportDetailsById(String transportId);

  Future<void> editTransport(
    String transportId,
    AddTransportModel addTransportModel,
    Function(int statusCode) successCallBack,
  );

  Future<List<BranchDetail>?> getAllBranchListWithoutPagination();

  Future<List<TransportDetails>?> getAllTransportsWithoutPagination();

  Future<GetVendorById?> getVendorById(String vendorId);

  Future<ParentResponseModel> getPurchasePartNoDetails(
      String? partNo, Function(int) statusCode);

  Future<void> addNewPurchaseDetails(AddPurchaseModel purchaseData,
      Function(int p1, PurchaseBill response) onSuccessCallBack);
  Future<GetAllCategoryListModel?> getAllCategoryList();

  Future<List<GetAllStocksWithoutPaginationModel>?> getAllStockList(
      String? categoryName, String? branchId);

  Future<void> createNewTransfer(AddNewTransfer? addNewTransfer,
      Function(int statusCode) onSuccessCallBack);

  Future<GetAllVoucherWithPagenationModel?> getVoucharRecieptList(
      String reportId, String receiver, int currentPage);

  Future<void> createStockFromPurchase(String? purchaseId,
      List<String>? partNumbersList, Function(int)? statusCode);
  Future<void> purchaseBillCancel(
      String? purchaseId, Function(int p1)? onSuccessCallback);
  Future<GetAllStocksByPagenation?> getAllStockByPagenation(
      int? currentIndex,
      String? partNumber,
      String? vehicleName,
      String? status,
      String? branchId);

  Future<List<GetAllTransferModel>?> getTransferList(
      String? selectedStatus,
      String? transferStatus,
      String? fromBranchId,
      String? toBranchId,
      String? fromDateTextController,
      String? toDateTextController);

  Future<void> stockTransferApproval(
      String? branchId, String? transferId, Function(int)? onSuccessCallback);

  Future<GetBookingListWithPagination?> getBookingListWithPagination(
      int? currentPage,
      String? bookingId,
      String? customerName,
      String? paymentType);

  Future<void> addNewBookingDetails(
      BookingModel bookingPostObj, Function(int statusCode) onSuccessCallBack);

  Future<List<GetAllEmployeeModel>?> getAllExcutiveList();

  Future<ParentResponseModel> getAllVoucherData();
  Future<void> salesPaymentUpdate(String paymentDate, String paymentType,
      double paidAmt, String salesId, Function(int p1) onSuccessCallBack);
}

class AppServiceUtilImpl extends AppServiceUtil {
  String? branchId;
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
        var branchId = response.data['result']['login']['branchId'] ?? '';
        print('************loign branch id********$branchId');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(AppConstants.token, token);
        prefs.setString(AppConstants.designation, designation);
        prefs.setString(AppConstants.userName, userName);
        prefs.setString(AppConstants.userId, userId);
        prefs.setString(AppConstants.useRefId, useRefId);
        prefs.setString(AppConstants.branchId, branchId);
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
          await dio.post(AppUrl.branch, data: jsonEncode(addBranchModel));
      onSuccessCallBack(response.statusCode);
    } on DioException catch (e) {
      onSuccessCallBack(e.response?.statusCode);
    }
  }

  @override
  Future<UsersListModel?> getUserList(
      String userName, String selectedDesignation, int currentPage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String userListUrl = '${AppUrl.user}page=$currentPage&pageSize=10';

    if (userName.isNotEmpty) {
      userListUrl += '&userName=$userName';
    }
    if (selectedDesignation.isNotEmpty && selectedDesignation != 'All') {
      userListUrl += '&designation=$selectedDesignation';
    }

    final response = await dio.get(userListUrl);

    return parentResponseModelFromJson(jsonEncode(response.data))
        .result
        ?.usersListModel;
  }

  @override
  Future<void> addCustomer(
      Function(int? statusCode, String? customerName, String? customerId)
          onSuccessCallBack,
      AddCustomerModel addEmployeeModel) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      var response =
          await dio.post(AppUrl.customer, data: jsonEncode(addEmployeeModel));
      var responseData = response.data;
      //  print('*****************$responseData');
      var cuctomerId = responseData['customerId'];
      var customerName = responseData['customerName'];
      // print(cuctomerId);
      // print(customerName);
      onSuccessCallBack(response.statusCode ?? 0, customerName, cuctomerId);
      //onSuccessCallBack(response.statusCode);
    } on DioException catch (e) {
      onSuccessCallBack(e.response?.statusCode, '', '');
    }

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var token = prefs.getString('token');
    // dio.options.headers['Authorization'] = 'Bearer $token';
    // var jsonData = json.encode(addEmployeeModel);

    // var response = await dio.post(AppUrl.purchase, data: jsonData);
    // var responseData = response.data;
    // print(responseData);
    // print(response.statusCode);

    // if (response.statusCode == 200 || response.statusCode == 201) {
    //   GetAllCustomersModel addCustomerResponse =
    //       GetAllCustomersModel.fromJson(responseData['result']['customer']);
    //   onSuccessCallBack(response.statusCode ?? 0, addCustomerResponse);
    // } else {
    //   onSuccessCallBack(
    //       response.statusCode ?? 0, responseData['result']['customer']);
    // }
  }

  @override
  Future<GetAllCustomersByPaginationModel?> getAllCustomersByPagination(
      String city,
      String mobileNumber,
      String customerName,
      int currentPage) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      String url = '${AppUrl.customer}/page?page=$currentPage&size=10';
      if (city.isNotEmpty) {
        url += '&city=$city';
      }
      if (customerName.isNotEmpty) {
        url += '&customerName=$customerName';
      }
      if (mobileNumber.isNotEmpty) {
        url += '&mobileNo=$mobileNumber';
      }
      var response = await dio.get(url);
      return parentResponseModelFromJson(jsonEncode(response.data))
          .result
          ?.getAllCustomersByPaginationModel;
    } on DioException catch (e) {
      e.response?.statusCode ?? 0;
    }
    return null;
  }

  @override
  Future<GetAllCustomersModel?> getCustomerDetails(String customerId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      var response = await dio.get('${AppUrl.customer}/$customerId');
      return parentResponseModelFromJson(jsonEncode(response.data))
          .result
          ?.getCustomerById;
    } on DioException catch (e) {
      e.response?.statusCode ?? 0;
    }
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
    if (response.statusCode == 200) {
      return parentResponseModelFromJson(jsonEncode(response.data))
              .result
              ?.getConfigModel
              ?.configuration ??
          [];
    } else {
      throw Exception('Failed to load  data: ${response.statusCode}');
    }
  }

  @override
  Future<ParentResponseModel> getConfigurationById({String? configId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String configUrl = '${AppUrl.config}$configId';

    final response = await dio.get(configUrl);

    if (response.statusCode == 200) {
      return parentResponseModelFromJson(jsonEncode(response.data));
    } else {
      throw Exception('Failed to load employee data: ${response.statusCode}');
    }
  }

  @override
  Future<GetAllEmployeesByPaginationModel> getAllEmployeesByPaginationModel(
      int currentPage,
      String employeeName,
      String city,
      String designation,
      String branchName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';

    String employeeListUrl =
        '${AppUrl.employeeByPagination}page=$currentPage&pageSize=10';

    if (employeeName.isNotEmpty) {
      employeeListUrl += '&employeeName=$employeeName';
    }
    if (designation.isNotEmpty && designation != 'All') {
      employeeListUrl += '&designation=$designation';
    }
    if (branchName.isNotEmpty && branchName != 'All') {
      employeeListUrl += '&branchName=$branchName';
    }

    var response = await dio.get(employeeListUrl);
    final responseList = parentResponseModelFromJson(jsonEncode(response.data));

    return responseList.result!.getAllEmployeesByPaginationModel!;
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
    String branchListUrl = AppUrl.branch;

    var response = await dio.get(branchListUrl);
    final responseList = parentResponseModelFromJson(jsonEncode(response.data));

    return responseList;
  }

  @override
  Future<GetEmployeeById?> getEmployeeById(String employeeId) async {
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
      String branchId,
      String employeeId,
      String password,
      String mobileNumber) async {
    final dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Map<String, dynamic> jsonObjectForUser = {
      'branchId': branchId,
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
      var response = await dio.put('${AppUrl.employee}/$employeeId',
          data: jsonEncode(empObj));
      statusCode(response.statusCode ?? 0);
    } on DioException catch (e) {
      statusCode(e.response?.statusCode ?? 0);
    }
  }

  @override
  Future<GetAllPurchaseByPageNation?> getAllPurchaseByPagenation(
      int? currentIndex, String? invoiceNo, String? partNo, String? purchaseNo,
      {String? categoryName}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    dio.options.headers['Authorization'] = 'Bearer $token';
    String purchaseListUrl =
        '${AppUrl.purchase}/page?page=$currentIndex&size=10';
    // String purchaseListUrl =
    // '${AppUrl.purchase}/page?page=$currentIndex&size=10&branchId=$branchId';
    if (invoiceNo!.isNotEmpty) {
      purchaseListUrl += '&p_invoiceNo=$invoiceNo';
    }

    if (purchaseNo!.isNotEmpty) {
      purchaseListUrl += '&purchaseNo==$purchaseNo';
    }
    if (categoryName != null && categoryName.isNotEmpty && categoryName != '') {
      purchaseListUrl += '&categoryName=$categoryName';
    }

    var response = await dio.get(purchaseListUrl);
    // print('^^^^^^^^^purchase sc^^^^^^^^^^${response.statusCode}');
    // print('^^^^^^^^^purchase rb^^^^^^^^^^${response.data}');

    final responseList = parentResponseModelFromJson(jsonEncode(response.data));
    return responseList.result!.getAllPurchaseByPageNation;
  }

  @override
  Future<ParentResponseModel> getAllVendorNameList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String vendorUrl = AppUrl.vendorNameList;
    final response = await dio.get(vendorUrl);
    ParentResponseModel vendorList =
        parentResponseModelFromJson(jsonEncode(response.data));
    return vendorList;
  }

  @override
  Future<List<GetAllCustomerNameList>?> getAllCustomerList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String customerNameList = AppUrl.customer;
    final response = await dio.get(customerNameList);
    return parentResponseModelFromJson(jsonEncode(response.data))
        .result
        ?.getAllCustomerNameList;
  }

  @override
  Future<GetAllBranchesByPaginationModel?> getBranchList(int currentPage,
      String pinCode, String branchName, String? selectedCity) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      String url = '${AppUrl.branch}/page?page=$currentPage&size=10';
      if (selectedCity?.isNotEmpty == true && selectedCity != 'All') {
        url += '&city=$selectedCity';
      }
      if (branchName.isNotEmpty) {
        url += '&branchName=$branchName';
      }
      var response = await dio.get(url);
      return ParentResponseModel.fromJson(response.data)
          .result
          ?.getAllBranchesByPaginationModel;
    } on DioException catch (e) {
      e.response?.statusCode ?? 0;
    }
    return null;
  }

  @override
  Future<GetAllBranchList?> getBranchDetailsById(String? branchId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      var response = await dio.get('${AppUrl.branch}/$branchId');
      return ParentResponseModel.fromJson(response.data).result?.getBranchById;
    } on DioException catch (e) {
      e.response?.statusCode ?? 0;
    }
    return null;
  }

  @override
  Future<void> updateBranch(UpdateBranchModel updateBranchModel,
      String? branchId, Function(int statusCode) successCallBack) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      var response = await dio.put('${AppUrl.branch}/$branchId',
          data: jsonEncode(updateBranchModel));
      successCallBack(response.statusCode ?? 0);
    } on DioException catch (e) {
      successCallBack(e.response?.statusCode ?? 0);
      e.response?.statusCode ?? 0;
    }
  }

  @override
  Future<void> addTransport(AddTransportModel addTransportModel,
      Function(int statusCode) successCallBack) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      var response =
          await dio.post(AppUrl.transport, data: jsonEncode(addTransportModel));
      successCallBack(response.statusCode ?? 0);
    } on DioException catch (e) {
      successCallBack(e.response?.statusCode ?? 0);
      e.response?.statusCode ?? 0;
    }
  }

  @override
  Future<GetTransportByPaginationModel?> getTransportByPagination(
      int currentPage,
      String city,
      String mobileNumber,
      String transportName) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      String url = '${AppUrl.transport}page?page=$currentPage&size=10';
      if (city.isNotEmpty) {
        url += '&city=$city';
      }
      if (transportName.isNotEmpty) {
        url += '&transportName=$transportName';
      }
      if (mobileNumber.isNotEmpty) {
        url += '&mobileNo=$mobileNumber';
      }
      var response = await dio.get(url);
      return parentResponseModelFromJson(jsonEncode(response.data))
          .result
          ?.getTransportByPaginationModel;
    } on DioException catch (e) {
      e.response?.statusCode ?? 0;
    }
    return null;
  }

  @override
  Future<List<GetAllConfigurationListModel>?> getAllConfigList(
      String configId) async {
    try {
      final dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      String endPoint = '${AppUrl.getAllConfigList}?configId=$configId';
      var response = await dio.get(endPoint);
      return parentResponseModelFromJson(jsonEncode(response.data))
          .result
          ?.getAllConfigurationListModel;
    } on DioException catch (exception) {
      exception.response?.statusCode ?? 0;
    }
    return null;
  }

  @override
  Future<GetConfigurationModel?> getConfigById(String configId) async {
    final dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String endPoint = '${AppUrl.config}$configId';
    var response = await dio.get(endPoint);
    return parentResponseModelFromJson(jsonEncode(response.data))
        .result
        ?.getConfigurationModel;
  }

  @override
  Future<void> updateConfigModel(
      String configId,
      String defaultValue,
      List<String> configValues,
      Function(int statusCode) onSuccessCallBack) async {
    try {
      final dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      Map<String, dynamic> jsonObject = {
        'configId': configId,
        'configuration': configValues,
        'defaultValue': defaultValue
      };
      var response = await dio.put('${AppUrl.config}edit/$configId',
          options: Options(headers: <String, String>{
            'Content-Type': 'application/json',
          }),
          data: jsonEncode(jsonObject));
      onSuccessCallBack(response.data['statusCode']);
      return response.data;
    } on DioException catch (exception) {
      exception.response?.statusCode ?? 0;
    }
  }

  @override
  Future<void> createConfig(
      String? configId,
      String? defaultValue,
      List<String>? configValues,
      Function(int statusCode) onSuccessCallBack) async {
    try {
      final dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      Map<String, dynamic> jsonObject = {
        'configId': configId ?? '',
        'configuration': configValues ?? '',
        'defaultValue': defaultValue ?? ''
      };
      var response = await dio.post(AppUrl.config,
          options: Options(headers: <String, String>{
            'Content-Type': 'application/json',
          }),
          data: jsonEncode(jsonObject));
      onSuccessCallBack(response.data['statusCode']);
      return response.data;
    } on DioException catch (exception) {
      exception.response?.statusCode ?? 0;
    }
  }

  @override
  Future<void> deleteBranch(
      Function(int statusCode) successCallBack, String branchId) async {
    try {
      final dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      var response = await dio.delete('${AppUrl.branch}/$branchId');
      successCallBack(response.statusCode ?? 0);
    } on DioException catch (exception) {
      exception.response?.statusCode ?? 0;
      successCallBack(exception.response?.statusCode ?? 0);
    }
  }

  @override
  Future<TransportDetails?> getTransportDetailsById(String transportId) async {
    try {
      final dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      var response = await dio.get('${AppUrl.transport}$transportId');
      return parentResponseModelFromJson(jsonEncode(response.data))
          .result
          ?.transportDetails;
    } on DioException catch (exception) {
      exception.response?.statusCode ?? 0;
    }
    return null;
  }

  @override
  Future<void> editTransport(
    String transportId,
    AddTransportModel addTransportModel,
    Function(int statusCode) successCallBack,
  ) async {
    try {
      final dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      var response = await dio.put(
        '${AppUrl.transport}$transportId',
        data: jsonEncode(addTransportModel),
      );
      successCallBack(response.statusCode ?? 0);
    } on DioException catch (exception) {
      exception.response?.statusCode ?? 0;
      successCallBack(exception.response?.statusCode ?? 0);
    }
  }

  @override
  Future<List<BranchDetail>?> getAllBranchListWithoutPagination() async {
    try {
      final dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      var response = await dio.get(AppUrl.branch);
      return parentResponseModelFromJson(jsonEncode(response.data))
          .result
          ?.branchDetails;
    } on DioException catch (exception) {
      exception.response?.statusCode ?? 0;
    }
    return null;
  }

  @override
  Future<List<TransportDetails>?> getAllTransportsWithoutPagination() async {
    try {
      final dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      var response = await dio.get(AppUrl.transport);
      return parentResponseModelFromJson(jsonEncode(response.data))
          .result
          ?.getAllTransportsWithoutPagination;
    } on DioException catch (exception) {
      exception.response?.statusCode ?? 0;
    }
    return null;
  }

  @override
  Future<GetAllVendorByPagination> getAllVendorByPagination(int currentPage,
      String vendorName, String city, String mobileNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';

    String vendorListUrl =
        '${AppUrl.vendorByPagination}page=$currentPage&pageSize=10';

    if (vendorName.isNotEmpty) {
      vendorListUrl += '&vendorName=$vendorName';
    }
    if (mobileNumber.isNotEmpty) {
      vendorListUrl += '&mobileNo=$mobileNumber';
    }
    if (city.isNotEmpty) {
      vendorListUrl += '&city=$city';
    }
    //  print(vendorListUrl);

    var response = await dio.get(vendorListUrl);

    final responseList = parentResponseModelFromJson(jsonEncode(response.data));

    return responseList.result!.getAllVendorByPagination!;
  }

  @override
  Future<void> addVendor(
      AddVendorModel vendorObj, Function(int? statusCode) statusCode) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      var response =
          await dio.post(AppUrl.addVendor, data: jsonEncode(vendorObj));

      statusCode(response.statusCode);
    } on DioException catch (e) {
      statusCode(e.response?.statusCode);
    }
  }

  @override
  Future<void> updateVendor(String vendorId, AddVendorModel vendorObj,
      Function(int? statusCode) statusCode) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      var response = await dio.put('${AppUrl.addVendor}/$vendorId',
          data: jsonEncode(vendorObj));
      statusCode(response.statusCode ?? 0);
    } on DioException catch (e) {
      statusCode(e.response?.statusCode ?? 0);
    }
  }

  @override
  Future<GetVendorById?> getVendorById(String vendorId) async {
    String vendorUrl = '${AppUrl.addVendor}/$vendorId';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    var response = await dio.get(vendorUrl);

    var vendorDetails = parentResponseModelFromJson(jsonEncode(response.data))
        .result
        ?.vendorById;

    return vendorDetails;
  }

  @override
  Future<ParentResponseModel> getPurchasePartNoDetails(
      String? partNo, Function(int) statusCode) async {
    final dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String endPoint = '${AppUrl.purchaseByPartNo}$partNo';
    var response = await dio.get(endPoint);
    ParentResponseModel parentResponse =
        parentResponseModelFromJson(jsonEncode(response.data));
    return parentResponse;
  }

  @override
  Future<void> addNewPurchaseDetails(AddPurchaseModel purchaseData,
      Function(int p1, PurchaseBill response) onSuccessCallBack) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    var jsonData = json.encode(purchaseData);

    var response = await dio.post(AppUrl.purchase, data: jsonData);
    var responseData = response.data;

    if (response.statusCode == 200 || response.statusCode == 201) {
      PurchaseBill purchaseBill =
          PurchaseBill.fromJson(responseData['result']['purchase']);
      onSuccessCallBack(response.statusCode ?? 0, purchaseBill);
    } else {
      onSuccessCallBack(
          response.statusCode ?? 0, responseData['result']['purchase']);
    }
  }

  @override
  Future<GetAllCategoryListModel?> getAllCategoryList() async {
    try {
      final dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      var response = await dio.get(AppUrl.category);
      var customerList = parentResponseModelFromJson(jsonEncode(response.data))
          .result
          ?.getAllcategoryList;
      return customerList;
    } on DioException catch (exception) {
      exception.response?.statusCode ?? 0;
    }
    return null;
  }

  @override
  Future<List<GetAllStocksWithoutPaginationModel>?> getAllStockList(
      String? categoryName, String? branchId) async {
    try {
      final dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';

      var response = await dio
          .get('${AppUrl.stock}?branchId=$branchId&categoryName=$categoryName');

      var stocksList = parentResponseModelFromJson(jsonEncode(response.data))
          .result
          ?.getAllStocksWithoutPagination;
      return stocksList;
    } on DioException catch (exception) {
      exception.response?.statusCode ?? 0;
    }
    return null;
  }

  @override
  Future<void> createNewTransfer(AddNewTransfer? addNewTransfer,
      Function(int statusCode) onSuccessCallBack) async {
    try {
      final dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      // ignore: unused_local_variable
      var response = await dio.post('${AppUrl.stock}/transfer',
          data: jsonEncode(addNewTransfer));
      onSuccessCallBack(response.statusCode ?? 0);
    } on DioException catch (exception) {
      exception.response?.statusCode ?? 0;
      onSuccessCallBack(exception.response?.statusCode ?? 0);
    }
  }

  @override
  Future<GetAllInsuranceByPaginationModel?> getAllInsuranceByPagination(
      String invoiceNo,
      String mobileNumber,
      String customerName,
      int currentPage) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      String url = '${AppUrl.insurance}/page?page=$currentPage&size=10';
      if (invoiceNo.isNotEmpty) {
        url += '&city=$invoiceNo';
      }
      if (customerName.isNotEmpty) {
        url += '&customerName=$customerName';
      }
      if (mobileNumber.isNotEmpty) {
        url += '&mobileNo=$mobileNumber';
      }
      var response = await dio.get(url);

      return parentResponseModelFromJson(jsonEncode(response.data))
          .result
          ?.getAllInsuranceModel;
    } on DioException catch (e) {
      e.response?.statusCode ?? 0;
    }
    return null;
  }

  @override
  Future<GetAllSales?> getSalesList(String invoiceNo, String paymentType,
      String customerName, int currentPage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String salesListUrl = '${AppUrl.sales}page?page=$currentPage&size=10';

    if (invoiceNo.isNotEmpty) {
      salesListUrl += '&invoiceNo=$invoiceNo';
    }
    if (paymentType.isNotEmpty) {
      salesListUrl += '&paymentType=$paymentType';
    }

    final response = await dio.get(salesListUrl);

    return parentResponseModelFromJson(jsonEncode(response.data))
        .result
        ?.getAllSalesList;
  }

  @override
  Future<GetBranchById?> getBranchById() async {
    String branchUrl = '${AppUrl.branch}/$branchId';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    var response = await dio.get(branchUrl);

    var branchDetails = parentResponseModelFromJson(jsonEncode(response.data))
        .result
        ?.getBranchId;

    return branchDetails;
  }

  @override
  Future<GetAllVendorByPagination?> getPurchaseReport(String vehicleType,
      String fromDate, String toDate, int currentPage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';

    String purchaseReportUrl = '${AppUrl.vendorByPagination}page=0&pageSize=10';

    if (vehicleType.isNotEmpty && vehicleType != 'All') {
      purchaseReportUrl += '&vehicleType=$vehicleType';
    }
    if (fromDate.isNotEmpty) {
      purchaseReportUrl += '&fromDate=$fromDate';
    }
    if (toDate.isNotEmpty) {
      purchaseReportUrl += '&toDate=$toDate';
    }

    var response = await dio.get(purchaseReportUrl);

    final responseList = parentResponseModelFromJson(jsonEncode(response.data));

    return responseList.result?.getAllVendorByPagination;
  }

  @override
  Future<GetAllVoucherWithPagenationModel?> getVoucharRecieptList(
      String reportId, String receiver, int currentPage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';

    String voucherListUrl = '${AppUrl.voucher}?page=$currentPage&pageSize=10';

    if (receiver.isNotEmpty && receiver != 'All') {
      voucherListUrl += '&vehicleType=$receiver';
    }
    if (reportId.isNotEmpty) {
      voucherListUrl += '&fromDate=$reportId';
    }
    var response = await dio.get(voucherListUrl);
    final responseList = parentResponseModelFromJson(jsonEncode(response.data));

    return responseList.result?.getAllVoucherWithPaganation;
  }

  @override
  Future<List<GetAllStockDetails>?> getStockList(String? categoryName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String stocksListUrl = AppUrl.stock;
    if (categoryName!.isNotEmpty) {
      stocksListUrl += '?categoryName=$categoryName';
    }
    final response = await dio.get(stocksListUrl);

    return parentResponseModelFromJson(jsonEncode(response.data))
        .result
        ?.getAllStockDetails;
  }

  @override
  Future<List<GetAllTransferModel>?> getTransferList(
      String? selectedStatus,
      String? transferStatus,
      String? fromBranchId,
      String? toBranchId,
      String? fromDateTextController,
      String? toDateTextController) async {
    try {
      final dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      String url = '${AppUrl.stock}/transferd?transferType=$selectedStatus';
      if (transferStatus != null) {
        if (transferStatus == AppConstants.allStatus) {
          url;
        } else {
          url += '&transferStatus=$transferStatus';
        }
      }
      if (fromBranchId != null) {
        url += '&fromBranchId=$fromBranchId';
      }
      if (toBranchId != null) {
        url += '&toBranchId=$toBranchId';
      }
      /*if (fromDateTextController != null) {
        url +=
            '&fromDate=${AppUtils.appToAPIDateFormat(fromDateTextController.toString())}';
      }
      if (toDateTextController != null) {
        url +=
            '&toDate=${AppUtils.appToAPIDateFormat(fromDateTextController.toString())}';
      }*/
      var response = await dio.get(url);
      return parentResponseModelFromJson(jsonEncode(response.data))
          .result
          ?.getAllTransferModel;
    } on DioException catch (exception) {
      exception.response?.statusCode ?? 0;
    }
    return null;
  }

  @override
  Future<void> stockTransferApproval(String? branchId, String? transferId,
      Function(int p1)? onSuccessCallback) async {
    final dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    var response = await dio.patch(
      '${AppUrl.stockTransfer}?branchId=$branchId&transferId=$transferId',
    );
    if (onSuccessCallback != null) {
      onSuccessCallback(response.statusCode ?? 0);
    }
  }

  @override
  Future<bool> purchaseValidate(
      Map<String, String> itemDetails, String partNo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    var selectedJson = itemDetails;
    var response = await dio.post('${AppUrl.purchaseValidate}$partNo',
        options: Options(headers: <String, String>{
          'Content-Type': 'application/json',
        }),
        data: jsonEncode(selectedJson));
    var responseData = response.data;
    return responseData['result']['successResponse'];
  }

  @override
  Future<void> createStockFromPurchase(String? purchaseId,
      List<String>? partNumbersList, Function(int)? statusCode) async {
    final dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    var requestObj = {"partNos": partNumbersList};
    var response = await dio.patch(
      '${AppUrl.stock}/$purchaseId',
      data: json.encode(requestObj),
    );
    if (statusCode != null) {
      statusCode(response.statusCode ?? 0);
    }
  }

  @override
  Future<void> purchaseBillCancel(
      String? purchaseId, Function(int p1)? onSuccessCallback) async {
    final dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    var response = await dio.patch(
      '${AppUrl.purchaseCancel}$purchaseId',
    );
    if (onSuccessCallback != null) {
      onSuccessCallback(response.statusCode ?? 0);
    }
  }

  @override
  Future<GetAllStocksByPagenation?> getAllStockByPagenation(
      int? currentIndex,
      String? partNumber,
      String? vehicleName,
      String? status,
      String? branchId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';

      String url = '${AppUrl.stock}/cumulative/page?page=$currentIndex&size=10';
      if (status != null && status.isNotEmpty) {
        url += '&categoryName=$status';
        if (partNumber != null && partNumber.isNotEmpty) {
          url += '&partNo=$partNumber';
        }
        if (vehicleName != null && vehicleName.isNotEmpty) {
          url += '&itemName=$vehicleName';
        }
        if (branchId != null && branchId.isNotEmpty) {
          url += '&branchId=$branchId';
        }
      }
      var response = await dio.get(url);

      final responseList =
          parentResponseModelFromJson(jsonEncode(response.data));

      return responseList.result?.getAllStocksByPagenation;
    } on DioException catch (e) {
      e.response?.statusCode ?? 0;
    }
    return null;
  }

  @override
  Future<GetBookingListWithPagination?> getBookingListWithPagination(
      int? currentPage,
      String? bookingId,
      String? customerName,
      String? paymentType) async {
    try {
      final dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';

      String url = '${AppUrl.booking}/page?page=$currentPage&size=10';

      if (bookingId != null && bookingId.isNotEmpty) {
        url += '&bookingNo=$bookingId';
      }
      if (customerName != null && customerName.isNotEmpty) {
        url += '&customerName=$customerName';
      }
      if (paymentType != null &&
          paymentType.isNotEmpty &&
          paymentType != 'All') {
        url += '&paymentType=$paymentType';
      }
      var response = await dio.get(url);
      return parentResponseModelFromJson(jsonEncode(response.data))
          .result
          ?.getAllBookingListWithPagination;
    } on DioException catch (exception) {
      exception.response?.statusCode ?? 0;
    }
    return null;
  }

  @override
  Future<void> addNewBookingDetails(BookingModel bookingPostObj,
      Function(int statusCode) onSuccessCallBack) async {
    try {
      final dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      var response =
          await dio.post(AppUrl.booking, data: jsonEncode(bookingPostObj));
      onSuccessCallBack(response.statusCode ?? 0);
    } on DioException catch (exception) {
      exception.response?.statusCode ?? 0;
      onSuccessCallBack(exception.response?.statusCode ?? 0);
    }
  }

  @override
  Future<List<GetAllEmployeeModel>?> getAllExcutiveList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String employeeList = AppUrl.employee;
    final response = await dio.get(employeeList);

    return parentResponseModelFromJson(jsonEncode(response.data))
        .result
        ?.getAllEmployeeListWithouPagenation;
  }

  @override
  Future<void> addNewSalesDetails(
    AddSalesModel salesdata,
    Function(int value) onSuccessCallBack,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      dio.options.headers['Authorization'] = 'Bearer $token';
      var jsonData = json.encode(salesdata);

      var response = await dio.post(AppUrl.sales, data: jsonData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        onSuccessCallBack(response.statusCode!);
      } else {
        onSuccessCallBack(response.statusCode ?? 0);
      }
    } catch (e) {
      onSuccessCallBack(0);
    }
  }

  @override
  Future<void> addNewVouchar(
      AddVocuhar voucharObj, Function(int? statusCode) statusCode) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';

      var response =
          await dio.post(AppUrl.newVouchar, data: jsonEncode(voucharObj));

      statusCode(response.statusCode);
    } on DioException catch (e) {
      statusCode(e.response?.statusCode);
    }
  }

  @override
  Future<ParentResponseModel> getAllVoucherData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String voucherListUrl = AppUrl.voucher;
    var response = await dio.get(voucherListUrl);
    final responseList = parentResponseModelFromJson(jsonEncode(response.data));
    return responseList;
  }

  @override
  Future<void> salesPaymentUpdate(
      String paymentDate,
      String paymentType,
      double paidAmt,
      String salesId,
      Function(int p1) onSuccessCallBack) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String salesPaymentUpdateUrl = '${AppUrl.salesPaymentUpdate}$salesId';
    var response = await dio.patch(salesPaymentUpdateUrl, data: {
      "paidAmount": paidAmt,
      "paymentDate": paymentDate,
      "paymentType": paymentType
    });
    print(response);
    onSuccessCallBack(response.statusCode ?? 0);
  }
}
