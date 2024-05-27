class GatAllBranchList {
  String? id;
  String? branchId;
  String? branchName;
  String? mobileNo;
  String? pinCode;
  String? city;
  String? address;
  dynamic mainBranchId;
  List<dynamic>? subBranches;
  bool? mainBranch;

  GatAllBranchList({
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

  factory GatAllBranchList.fromJson(Map<String, dynamic> json) =>
      GatAllBranchList(
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
            : List<dynamic>.from(json["subBranches"]!.map((x) => x)),
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
            : List<dynamic>.from(subBranches!.map((x) => x)),
        "mainBranch": mainBranch,
      };
}
