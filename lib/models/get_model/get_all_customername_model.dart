// To parse this JSON data, do
//
//     final getAllCustomerNameModel = getAllCustomerNameModelFromJson(jsonString);

import 'dart:convert';

List<GetAllCustomerNameModel> getAllCustomerNameModelFromJson(String str) =>
    List<GetAllCustomerNameModel>.from(
        json.decode(str).map((x) => GetAllCustomerNameModel.fromJson(x)));

String getAllCustomerNameModelToJson(List<GetAllCustomerNameModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllCustomerNameModel {
  String? aadharNo;
  String? accountNo;
  String? address;
  String? branchName;
  String? city;
  String? createdBy;
  DateTime? createdDateTime;
  String? customerId;
  String? customerName;
  String? emailId;
  String? id;
  String? ifsc;
  String? image;
  String? mobileNo;
  String? updatedBy;
  DateTime? updatedDateTime;

  GetAllCustomerNameModel({
    this.aadharNo,
    this.accountNo,
    this.address,
    this.branchName,
    this.city,
    this.createdBy,
    this.createdDateTime,
    this.customerId,
    this.customerName,
    this.emailId,
    this.id,
    this.ifsc,
    this.image,
    this.mobileNo,
    this.updatedBy,
    this.updatedDateTime,
  });

  factory GetAllCustomerNameModel.fromJson(Map<String, dynamic> json) =>
      GetAllCustomerNameModel(
        aadharNo: json["aadharNo"],
        accountNo: json["accountNo"],
        address: json["address"],
        branchName: json["branchName"],
        city: json["city"],
        createdBy: json["createdBy"],
        createdDateTime: json["createdDateTime"] == null
            ? null
            : DateTime.parse(json["createdDateTime"]),
        customerId: json["customerId"],
        customerName: json["customerName"],
        emailId: json["emailId"],
        id: json["id"],
        ifsc: json["ifsc"],
        image: json["image"],
        mobileNo: json["mobileNo"],
        updatedBy: json["updatedBy"],
        updatedDateTime: json["updatedDateTime"] == null
            ? null
            : DateTime.parse(json["updatedDateTime"]),
      );

  Map<String, dynamic> toJson() => {
        "aadharNo": aadharNo,
        "accountNo": accountNo,
        "address": address,
        "branchName": branchName,
        "city": city,
        "createdBy": createdBy,
        "createdDateTime": createdDateTime?.toIso8601String(),
        "customerId": customerId,
        "customerName": customerName,
        "emailId": emailId,
        "id": id,
        "ifsc": ifsc,
        "image": image,
        "mobileNo": mobileNo,
        "updatedBy": updatedBy,
        "updatedDateTime": updatedDateTime?.toIso8601String(),
      };
}
