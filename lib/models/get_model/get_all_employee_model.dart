// To parse this JSON data, do
//
//     final getAllEmployeeModel = getAllEmployeeModelFromJson(jsonString);

import 'dart:convert';

List<GetAllEmployeeModel> getAllEmployeeModelFromJson(String str) =>
    List<GetAllEmployeeModel>.from(
        json.decode(str).map((x) => GetAllEmployeeModel.fromJson(x)));

String getAllEmployeeModelToJson(List<GetAllEmployeeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllEmployeeModel {
  String? address;
  int? age;
  String? branchId;
  String? branchName;
  String? city;
  DateTime? dateOfBirth;
  String? designation;
  String? emailId;
  String? employeeId;
  String? employeeName;
  String? gender;
  String? id;
  String? mobileNumber;

  GetAllEmployeeModel({
    this.address,
    this.age,
    this.branchId,
    this.branchName,
    this.city,
    this.dateOfBirth,
    this.designation,
    this.emailId,
    this.employeeId,
    this.employeeName,
    this.gender,
    this.id,
    this.mobileNumber,
  });

  factory GetAllEmployeeModel.fromJson(Map<String, dynamic> json) =>
      GetAllEmployeeModel(
        address: json["address"],
        age: json["age"],
        branchId: json["branchId"],
        branchName: json["branchName"],
        city: json["city"],
        dateOfBirth: json["dateOfBirth"] == null
            ? null
            : DateTime.parse(json["dateOfBirth"]),
        designation: json["designation"],
        emailId: json["emailId"],
        employeeId: json["employeeId"],
        employeeName: json["employeeName"],
        gender: json["gender"],
        id: json["id"],
        mobileNumber: json["mobileNumber"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "age": age,
        "branchId": branchId,
        "branchName": branchName,
        "city": city,
        "dateOfBirth":
            "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
        "designation": designation,
        "emailId": emailId,
        "employeeId": employeeId,
        "employeeName": employeeName,
        "gender": gender,
        "id": id,
        "mobileNumber": mobileNumber,
      };
}
