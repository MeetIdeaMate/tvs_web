import 'dart:convert';

AddBranchModel addBranchModelFromJson(String str) =>
    AddBranchModel.fromJson(json.decode(str));

String addBranchModelToJson(AddBranchModel data) => json.encode(data.toJson());

class AddBranchModel {
  String? address;
  String? branchId;
  String? branchName;
  String? city;
  String? createdBy;
  DateTime? createdDateTime;
  String? id;
  bool? mainBranch;
  String? mainBranchId;
  String? mobileNo;
  String? pinCode;
  String? updatedBy;
  DateTime? updatedDateTime;

  AddBranchModel({
    this.address,
    this.branchId,
    this.branchName,
    this.city,
    this.createdBy,
    this.createdDateTime,
    this.id,
    this.mainBranch,
    this.mainBranchId,
    this.mobileNo,
    this.pinCode,
    this.updatedBy,
    this.updatedDateTime,
  });

  factory AddBranchModel.fromJson(Map<String, dynamic> json) => AddBranchModel(
        address: json["address"],
        branchId: json["branchId"],
        branchName: json["branchName"],
        city: json["city"],
        createdBy: json["createdBy"],
        createdDateTime: json["createdDateTime"] == null
            ? null
            : DateTime.parse(json["createdDateTime"]),
        id: json["id"],
        mainBranch: json["mainBranch"],
        mainBranchId: json["mainBranchId"],
        mobileNo: json["mobileNo"],
        pinCode: json["pinCode"],
        updatedBy: json["updatedBy"],
        updatedDateTime: json["updatedDateTime"] == null
            ? null
            : DateTime.parse(json["updatedDateTime"]),
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "branchId": branchId,
        "branchName": branchName,
        "city": city,
        "createdBy": createdBy,
        "createdDateTime": createdDateTime?.toIso8601String(),
        "id": id,
        "mainBranch": mainBranch,
        "mainBranchId": mainBranchId,
        "mobileNo": mobileNo,
        "pinCode": pinCode,
        "updatedBy": updatedBy,
        "updatedDateTime": updatedDateTime?.toIso8601String(),
      };
}
