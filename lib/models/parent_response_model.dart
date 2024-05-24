import 'dart:convert';

import 'package:tlbilling/models/get_all_employee_model.dart';
import 'package:tlbilling/models/get_cofig_model.dart';
import 'package:tlbilling/models/get_employee_by_id.dart';
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

  Map<String, dynamic> toJson() => {
        "result": result?.toJson(),
        "error": error,
        "status": status,
        "statusCode": statusCode,
      };
}

class ResultObj {
  UsersListModel? usersListModel;
  ConfigModel? getConfigModel;
  List<EmployeeListModel>? employeeListModel;
  GetEmployeeById? employeeById;

  ResultObj(
      {this.usersListModel,
      this.getConfigModel,
      this.employeeListModel,
      this.employeeById});

  factory ResultObj.fromJson(Map<String, dynamic> json) => ResultObj(
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
      );

  Map<String, dynamic> toJson() => {};
}
