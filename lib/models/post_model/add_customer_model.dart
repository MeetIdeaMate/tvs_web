import 'dart:convert';

AddCustomerModel addEmployeeModelFromJson(String str) =>
    AddCustomerModel.fromJson(json.decode(str));

String addEmployeeModelToJson(AddCustomerModel data) =>
    json.encode(data.toJson());

class AddCustomerModel {
  String? aadharNo;
  String? accountNo;
  String? address;
  String? branchName;
  String? city;
  String? customerName;
  String? emailId;
  String? ifsc;
  String? mobileNo;

  AddCustomerModel({
    this.aadharNo,
    this.accountNo,
    this.address,
    this.branchName,
    this.city,
    this.customerName,
    this.emailId,
    this.ifsc,
    this.mobileNo,
  });

  factory AddCustomerModel.fromJson(Map<String, dynamic> json) =>
      AddCustomerModel(
        aadharNo: json["aadharNo"],
        accountNo: json["accountNo"],
        address: json["address"],
        branchName: json["branchName"],
        city: json["city"],
        customerName: json["customerName"],
        emailId: json["emailId"],
        ifsc: json["ifsc"],
        mobileNo: json["mobileNo"],
      );

  Map<String, dynamic> toJson() => {
        "aadharNo": aadharNo,
        "accountNo": accountNo,
        "address": address,
        "branchName": branchName,
        "city": city,
        "customerName": customerName,
        "emailId": emailId,
        "ifsc": ifsc,
        "mobileNo": mobileNo,
      };
}
