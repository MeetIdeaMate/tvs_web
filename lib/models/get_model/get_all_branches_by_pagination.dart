// To parse this JSON data, do
//
//     final getAllBranchesByPaginationModel = getAllBranchesByPaginationModelFromJson(jsonString);

import 'dart:convert';

GetAllBranchesByPaginationModel getAllBranchesByPaginationModelFromJson(
        String str) =>
    GetAllBranchesByPaginationModel.fromJson(json.decode(str));

String getAllBranchesByPaginationModelToJson(
        GetAllBranchesByPaginationModel data) =>
    json.encode(data.toJson());

class GetAllBranchesByPaginationModel {
  List<BranchDetail>? branchDetail;
  bool? empty;
  bool? first;
  bool? last;
  int? number;
  int? numberOfElements;
  Pageable? pageable;
  int? size;
  Sort? sort;
  int? totalElements;
  int? totalPages;

  GetAllBranchesByPaginationModel({
    this.branchDetail,
    this.empty,
    this.first,
    this.last,
    this.number,
    this.numberOfElements,
    this.pageable,
    this.size,
    this.sort,
    this.totalElements,
    this.totalPages,
  });

  factory GetAllBranchesByPaginationModel.fromJson(Map<String, dynamic> json) =>
      GetAllBranchesByPaginationModel(
        branchDetail: json["content"] == null
            ? []
            : List<BranchDetail>.from(
                json["content"]!.map((x) => BranchDetail.fromJson(x))),
        empty: json["empty"],
        first: json["first"],
        last: json["last"],
        number: json["number"],
        numberOfElements: json["numberOfElements"],
        pageable: json["pageable"] == null
            ? null
            : Pageable.fromJson(json["pageable"]),
        size: json["size"],
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        totalElements: json["totalElements"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "content": branchDetail == null
            ? []
            : List<dynamic>.from(branchDetail!.map((x) => x.toJson())),
        "empty": empty,
        "first": first,
        "last": last,
        "number": number,
        "numberOfElements": numberOfElements,
        "pageable": pageable?.toJson(),
        "size": size,
        "sort": sort?.toJson(),
        "totalElements": totalElements,
        "totalPages": totalPages,
      };
}

class BranchDetail {
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

  BranchDetail({
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

  factory BranchDetail.fromJson(Map<String, dynamic> json) => BranchDetail(
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

class Pageable {
  int? offset;
  int? pageNumber;
  int? pageSize;
  bool? paged;
  Sort? sort;
  bool? unpaged;

  Pageable({
    this.offset,
    this.pageNumber,
    this.pageSize,
    this.paged,
    this.sort,
    this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        offset: json["offset"],
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        paged: json["paged"],
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        unpaged: json["unpaged"],
      );

  Map<String, dynamic> toJson() => {
        "offset": offset,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "paged": paged,
        "sort": sort?.toJson(),
        "unpaged": unpaged,
      };
}

class Sort {
  bool? empty;
  bool? sorted;
  bool? unsorted;

  Sort({
    this.empty,
    this.sorted,
    this.unsorted,
  });

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        empty: json["empty"],
        sorted: json["sorted"],
        unsorted: json["unsorted"],
      );

  Map<String, dynamic> toJson() => {
        "empty": empty,
        "sorted": sorted,
        "unsorted": unsorted,
      };
}
