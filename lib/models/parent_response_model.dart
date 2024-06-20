import 'dart:convert';

import 'package:tlbilling/models/get_model/get_all_booking_list_with_pagination.dart';
import 'package:tlbilling/models/get_model/get_all_branch_by_id_model.dart';
import 'package:tlbilling/models/get_model/get_all_insurance_by_pagination_model.dart';
import 'package:tlbilling/models/get_model/get_all_sales_list_model.dart';
import 'package:tlbilling/models/get_model/get_all_stock_with_pagination.dart';
import 'package:tlbilling/models/get_model/get_all_stocks_model.dart';
import 'package:tlbilling/models/get_model/get_all_stocks_without_pagination.dart';
import 'package:tlbilling/models/get_model/get_all_transfer_model.dart';
import 'package:tlbilling/models/get_model/get_all_vendorName_List.dart';
import 'package:tlbilling/models/get_model/get_all_branch_model.dart';
import 'package:tlbilling/models/get_model/get_all_branches_by_pagination.dart';
import 'package:tlbilling/models/get_model/get_all_category_model.dart';
import 'package:tlbilling/models/get_model/get_all_customerName_List.dart';
import 'package:tlbilling/models/get_model/get_all_customer_by_pagination_model.dart';
import 'package:tlbilling/models/get_model/get_all_customers_model.dart';

import 'package:tlbilling/models/get_all_employee_model.dart';
import 'package:tlbilling/models/get_cofig_model.dart';
import 'package:tlbilling/models/get_employee_by_id.dart';
import 'package:tlbilling/models/get_model/get_all_employee_by_pagination.dart';
import 'package:tlbilling/models/get_model/get_all_purchase_model.dart';
import 'package:tlbilling/models/get_model/get_all_vendor_by_pagination_model.dart';
import 'package:tlbilling/models/get_model/get_configuration_list_model.dart';
import 'package:tlbilling/models/get_model/get_configuration_model.dart';
import 'package:tlbilling/models/get_model/get_purchase_report_model.dart';
import 'package:tlbilling/models/get_model/get_transport_by_pagination.dart';
import 'package:tlbilling/models/get_model/get_vendor_by_id_model.dart';
import 'package:tlbilling/models/get_model/purchase_by_partno_model.dart';
import 'package:tlbilling/models/user_model.dart';

ParentResponseModel parentResponseModelFromJson(String str) =>
    ParentResponseModel.fromJson(json.decode(str));

String parentResponseModelToJson(ParentResponseModel data) =>
    json.encode(data.toJson());

class ParentResponseModel {
  ResultObj? result;
  dynamic error;
  String? status;
  int? statusCode;

  ParentResponseModel({
    this.result,
    this.error,
    this.status,
    this.statusCode,
  });

  factory ParentResponseModel.fromJson(Map<String, dynamic> json) =>
      ParentResponseModel(
        result:
        json["result"] == null ? null : ResultObj.fromJson(json["result"]),
        error: json["error"],
        status: json["status"],
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() =>
      {
        "result": result?.toJson(),
        "error": error,
        "status": status,
        "statusCode": statusCode,
      };
}

class ResultObj {
  GetAllVendorByPagination? getAllVendorByPagination;
  GetAllCustomersByPaginationModel? getAllCustomersByPaginationModel;
  GetAllCustomersModel? getAllCustomersModel;
  GetAllEmployeesByPaginationModel? getAllEmployeesByPaginationModel;
  UsersListModel? usersListModel;
  ConfigModel? getConfigModel;
  List<EmployeeListModel>? employeeListModel;
  GetEmployeeById? employeeById;
  GetVendorById? vendorById;
  List<GetAllBranchList>? getAllBranchList;
  GetAllPurchaseByPageNation? getAllPurchaseByPageNation;
  List<GetAllVendorNameList>? getAllVendorNameList;
  List<GetAllCustomerNameList>? getAllCustomerNameList;
  GetAllBranchesByPaginationModel? getAllBranchesByPaginationModel;
  GetAllBranchList? getBranchById;
  GetTransportByPaginationModel? getTransportByPaginationModel;
  List<GetAllConfigurationListModel>? getAllConfigurationListModel;
  GetConfigurationModel? getConfigurationModel;
  TransportDetails? transportDetails;
  List<BranchDetail>? branchDetails;
  GetAllInsuranceByPaginationModel? getAllInsuranceModel;
  GetAllSalesList? getAllSalesList;
  GetBranchById? getBranchId;
  GetAllpurchaseReport? getPurchaseReport;
  PurchaseByPartNoModel? purchaseByPartNo;
  GetAllCategoryListModel? getAllcategoryList;
  List<TransportDetails>? getAllTransportsWithoutPagination;
  List<GetAllStocksWithoutPaginationModel>? getAllStocksWithoutPagination;
  GetAllStockDetails? getAllStockDetails;
  GetAllStocksByPagenation? getAllStocksByPagenation;
  List<GetAllTransferModel>? getAllTransferModel;
  GetBookingListWithPagination? getAllBookingListWithPagination;

  ResultObj({this.getAllVendorByPagination,
    this.getAllCustomersByPaginationModel,
    this.getAllCustomersModel,
    this.usersListModel,
    this.getConfigModel,
    this.employeeListModel,
    this.employeeById,
    this.getAllEmployeesByPaginationModel,
    this.getAllBranchList,
    this.getAllPurchaseByPageNation,
    this.getAllVendorNameList,
    this.getAllCustomerNameList,
    this.vendorById,
    this.getAllBranchesByPaginationModel,
    this.getBranchById,
    this.getTransportByPaginationModel,
    this.getAllConfigurationListModel,
    this.getConfigurationModel,
    this.transportDetails,
    this.branchDetails,
    this.getAllTransportsWithoutPagination,
    this.getAllInsuranceModel,
    this.getAllSalesList,
    this.getBranchId,
    this.getPurchaseReport,
    this.purchaseByPartNo,
    this.getAllcategoryList,
    this.getAllStocksWithoutPagination,
    this.getAllStockDetails,
    this.getAllStocksByPagenation,
    this.getAllTransferModel,
    this.getAllBookingListWithPagination});

  factory ResultObj.fromJson(Map<String, dynamic> json) =>
      ResultObj(
          getAllCustomersByPaginationModel: json['customersWithPage'] != null
              ? GetAllCustomersByPaginationModel.fromJson(
              json['customersWithPage'])
              : null,
          getAllCustomersModel:
          json[''] != null ? GetAllCustomersModel.fromJson(json['']) : null,
          usersListModel: json['userWithPage'] != null
              ? UsersListModel.fromJson(json['userWithPage'])
              : null,
          getConfigModel: json["config"] != null
              ? ConfigModel.fromJson(json["config"])
              : null,
          employeeById: json["employee"] != null
              ? GetEmployeeById.fromJson(json["employee"])
              : null,
          employeeListModel: json['employeeList'] != null
              ? List<EmployeeListModel>.from(
              json['employeeList'].map((x) => EmployeeListModel.fromJson(x)))
              : null,
          getAllEmployeesByPaginationModel: json['employeesWithPage'] != null
              ? GetAllEmployeesByPaginationModel.fromJson(
              json['employeesWithPage'])
              : null,
          getAllBranchList: json['branchResponseList'] != null
              ? List<GetAllBranchList>.from(json['branchResponseList']
              .map((x) => GetAllBranchList.fromJson(x)))
              : null,
          getAllBranchesByPaginationModel: json['branchWithPage'] != null
              ? GetAllBranchesByPaginationModel.fromJson(json['branchWithPage'])
              : null,
          getBranchById: json['branchResponse'] != null
              ? GetAllBranchList.fromJson(json['branchResponse'])
              : null,
          getTransportByPaginationModel: json['transportsWithPage'] != null
              ? GetTransportByPaginationModel.fromJson(
              json['transportsWithPage'])
              : null,
          getAllConfigurationListModel: json['configList'] != null
              ? List<GetAllConfigurationListModel>.from(json['configList']
              .map((x) => GetAllConfigurationListModel.fromJson(x)))
              : null,
          getConfigurationModel: json['config'] != null
              ? GetConfigurationModel.fromJson(json['config'])
              : null,
          transportDetails: json['transport'] != null
              ? TransportDetails.fromJson(json['transport'])
              : null,
          branchDetails: json['branchResponseList'] != null
              ? List<BranchDetail>.from(
              json['branchResponseList'].map((x) => BranchDetail.fromJson(x)))
              : null,
          getAllVendorByPagination: json['vendorsWithPage'] != null
              ? GetAllVendorByPagination.fromJson(json['vendorsWithPage'])
              : null,
          vendorById: json["vendor"] != null
              ? GetVendorById.fromJson(json["vendor"])
              : null,
          getAllPurchaseByPageNation: json['purchasesWithPage'] != null
              ? GetAllPurchaseByPageNation.fromJson(json['purchasesWithPage'])
              : null,
          getAllVendorNameList: json['vendors'] != null
              ? List<GetAllVendorNameList>.from(
              json['vendors'].map((x) => GetAllVendorNameList.fromJson(x)))
              : null,
          getAllCustomerNameList: json['customers'] != null
              ? List<GetAllCustomerNameList>.from(json['customers']
              .map((x) => GetAllCustomerNameList.fromJson(x)))
              : null,
          getAllTransportsWithoutPagination: json['transports'] != null
              ? List<TransportDetails>.from(
              json['transports'].map((x) => TransportDetails.fromJson(x)))
              : null,
          getAllInsuranceModel: json['customersWithPage'] != null
              ? GetAllInsuranceByPaginationModel.fromJson(
              json['customersWithPage'])
              : null,
          getAllSalesList: json['salesList'] != null
              ? GetAllSalesList.fromJson(json['salesList'])
              : null,
          getBranchId: json["branchResponse"] != null
              ? GetBranchById.fromJson(json["branchResponse"])
              : null,
          getPurchaseReport: json['purchasesReportWithPage'] != null
              ? GetAllpurchaseReport.fromJson(json['purchasesReportWithPage'])
              : null,
          purchaseByPartNo: json['ItemDetailByPartNo'] != null
              ? PurchaseByPartNoModel.fromJson(json['ItemDetailByPartNo'])
              : null,
          getAllcategoryList: json['categorysWithPage'] != null
              ? GetAllCategoryListModel.fromJson(json['categorysWithPage'])
              : null,
          getAllStocksWithoutPagination: json['Stocks'] != null
              ? List<GetAllStocksWithoutPaginationModel>.from(json['Stocks']
              .map((x) => GetAllStocksWithoutPaginationModel.fromJson(x)))
              : null,
          getAllStockDetails: json['stocks'] != null
              ? GetAllStockDetails.fromJson(json['stocks'])
              : null,
          getAllStocksByPagenation: json['stockDTOWithPage'] != null
              ? GetAllStocksByPagenation.fromJson(json['stockDTOWithPage'])
              : null,
          getAllTransferModel: json['transferDetails'] != null
              ? List<GetAllTransferModel>.from(json['transferDetails']
              .map((x) => GetAllTransferModel.fromJson(x)))
              : null,
          getAllBookingListWithPagination: json['bookingsWithPage'] != null
              ? GetBookingListWithPagination.fromJson(json['bookingsWithPage'])
              : null,
      );

  Map<String, dynamic> toJson() => {};
}
