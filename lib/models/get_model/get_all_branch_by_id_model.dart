class GetBranchById {
  String? id;
  String? branchId;
  String? branchName;
  String? mobileNo;
  String? pinCode;
  String? city;
  String? address;
  String? mainBranchId;
  List<SubBranch>? subBranches;
  bool? mainBranch;

  GetBranchById({
    this.id,
    this.branchId,
    this.branchName,
    this.mobileNo,
    this.pinCode,
    this.city,
    this.address,
    this.mainBranchId,
    this.subBranches,
    this.mainBranch,
  });

  factory GetBranchById.fromJson(Map<String, dynamic> json) => GetBranchById(
        id: json["id"],
        branchId: json["branchId"],
        branchName: json["branchName"],
        mobileNo: json["mobileNo"],
        pinCode: json["pinCode"],
        city: json["city"],
        address: json["address"],
        mainBranchId: json["mainBranchId"],
        subBranches: json["subBranches"] == null
            ? []
            : List<SubBranch>.from(
                json["subBranches"]!.map((x) => SubBranch.fromJson(x))),
        mainBranch: json["mainBranch"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "branchId": branchId,
        "branchName": branchName,
        "mobileNo": mobileNo,
        "pinCode": pinCode,
        "city": city,
        "address": address,
        "mainBranchId": mainBranchId,
        "subBranches": subBranches == null
            ? []
            : List<dynamic>.from(subBranches!.map((x) => x.toJson())),
        "mainBranch": mainBranch,
      };
}

class SubBranch {
  String? branchId;
  String? branchName;
  String? mobileNo;
  String? pinCode;
  String? city;
  String? address;

  SubBranch({
    this.branchId,
    this.branchName,
    this.mobileNo,
    this.pinCode,
    this.city,
    this.address,
  });

  factory SubBranch.fromJson(Map<String, dynamic> json) => SubBranch(
        branchId: json["branchId"],
        branchName: json["branchName"],
        mobileNo: json["mobileNo"],
        pinCode: json["pinCode"],
        city: json["city"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "branchId": branchId,
        "branchName": branchName,
        "mobileNo": mobileNo,
        "pinCode": pinCode,
        "city": city,
        "address": address,
      };
}
