import 'dart:convert';

UpdateBranchModel updateBranchModelFromJson(String str) =>
    UpdateBranchModel.fromJson(json.decode(str));

String updateBranchModelToJson(UpdateBranchModel data) =>
    json.encode(data.toJson());

class UpdateBranchModel {
  String? address;
  String? branchName;
  String? city;
  bool? mainBranch;
  String? mainBranchId;
  String? mobileNo;
  String? pinCode;

  UpdateBranchModel({
    this.address,
    this.branchName,
    this.city,
    this.mainBranch,
    this.mainBranchId,
    this.mobileNo,
    this.pinCode,
  });

  factory UpdateBranchModel.fromJson(Map<String, dynamic> json) =>
      UpdateBranchModel(
        address: json["address"],
        branchName: json["branchName"],
        city: json["city"],
        mainBranch: json["mainBranch"],
        mainBranchId: json["mainBranchId"],
        mobileNo: json["mobileNo"],
        pinCode: json["pinCode"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "branchName": branchName,
        "city": city,
        "mainBranch": mainBranch,
        "mainBranchId": mainBranchId,
        "mobileNo": mobileNo,
        "pinCode": pinCode,
      };
}
