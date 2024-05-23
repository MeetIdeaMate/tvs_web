import 'dart:convert';

import 'package:tlbilling/models/get_model/get_all_customer_by_pagination_model.dart';
import 'package:tlbilling/models/get_model/get_all_customers_model.dart';

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
  GetAllCustomersByPaginationModel? getAllCustomersByPaginationModel;
  GetAllCustomersModel? getAllCustomersModel;

  ResultObj({this.getAllCustomersByPaginationModel, this.getAllCustomersModel});

  factory ResultObj.fromJson(Map<String, dynamic> json) =>
      ResultObj(
          getAllCustomersByPaginationModel: json['customersWithPage'] != null
              ? GetAllCustomersByPaginationModel.fromJson(
              json['customersWithPage'])
              : null,
          getAllCustomersModel: json[''] != null ? GetAllCustomersModel.fromJson(
              json['']) : null);

  Map<String, dynamic> toJson() => {};
}
