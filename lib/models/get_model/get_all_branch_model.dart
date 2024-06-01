import 'dart:convert';

GetAllBranchList gatAllBranchListFromJson(String str) =>
    GetAllBranchList.fromJson(json.decode(str));

String gatAllBranchListToJson(GetAllBranchList data) =>
    json.encode(data.toJson());

class SubBranch {
  String? address;
  String? branchId;
  String? branchName;
  String? city;
  String? mobileNo;
  String? pinCode;

  SubBranch({
    this.address,
    this.branchId,
    this.branchName,
    this.city,
    this.mobileNo,
    this.pinCode,
  });

  factory SubBranch.fromJson(Map<String, dynamic> json) => SubBranch(
        address: json["address"],
        branchId: json["branchId"],
        branchName: json["branchName"],
        city: json["city"],
        mobileNo: json["mobileNo"],
        pinCode: json["pinCode"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "branchId": branchId,
        "branchName": branchName,
        "city": city,
        "mobileNo": mobileNo,
        "pinCode": pinCode,
      };
}

class GetAllBranchList {
  String? address;
  String? branchId;
  String? branchName;
  String? city;
  String? id;
  bool? mainBranch;
  String? mainBranchId;
  String? mobileNo;
  String? pinCode;
  List<SubBranch>? subBranches;

  GetAllBranchList({
    this.address,
    this.branchId,
    this.branchName,
    this.city,
    this.id,
    this.mainBranch,
    this.mainBranchId,
    this.mobileNo,
    this.pinCode,
    this.subBranches,
  });

  factory GetAllBranchList.fromJson(Map<String, dynamic> json) =>
      GetAllBranchList(
        address: json["address"],
        branchId: json["branchId"],
        branchName: json["branchName"],
        city: json["city"],
        id: json["id"],
        mainBranch: json["mainBranch"],
        mainBranchId: json["mainBranchId"],
        mobileNo: json["mobileNo"],
        pinCode: json["pinCode"],
        subBranches: json["subBranches"] == null
            ? []
            : List<SubBranch>.from(
                json["subBranches"]!.map((x) => SubBranch.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "branchId": branchId,
        "branchName": branchName,
        "city": city,
        "id": id,
        "mainBranch": mainBranch,
        "mainBranchId": mainBranchId,
        "mobileNo": mobileNo,
        "pinCode": pinCode,
        "subBranches": subBranches == null
            ? []
            : List<dynamic>.from(subBranches!.map((x) => x.toJson())),
      };
}
