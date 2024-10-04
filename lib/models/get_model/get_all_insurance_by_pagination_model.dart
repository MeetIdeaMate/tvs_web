// To parse this JSON data, do
//
//     final getAllInsuranceByPaginationModel = getAllInsuranceByPaginationModelFromJson(jsonString);

import 'dart:convert';

GetAllInsuranceByPaginationModel getAllInsuranceByPaginationModelFromJson(
        String str) =>
    GetAllInsuranceByPaginationModel.fromJson(json.decode(str));

String getAllInsuranceByPaginationModelToJson(
        GetAllInsuranceByPaginationModel data) =>
    json.encode(data.toJson());

class GetAllInsuranceByPaginationModel {
  List<InsuranceDataList>? insuranceDataList;
  Pageable? pageable;
  bool? last;
  int? totalElements;
  int? totalPages;
  int? size;
  int? number;
  Sort? sort;
  int? numberOfElements;
  bool? first;
  bool? empty;

  GetAllInsuranceByPaginationModel({
    this.insuranceDataList,
    this.pageable,
    this.last,
    this.totalElements,
    this.totalPages,
    this.size,
    this.number,
    this.sort,
    this.numberOfElements,
    this.first,
    this.empty,
  });

  factory GetAllInsuranceByPaginationModel.fromJson(
          Map<String, dynamic> json) =>
      GetAllInsuranceByPaginationModel(
        insuranceDataList: json["content"] == null
            ? []
            : List<InsuranceDataList>.from(
                json["content"]!.map((x) => InsuranceDataList.fromJson(x))),
        pageable: json["pageable"] == null
            ? null
            : Pageable.fromJson(json["pageable"]),
        last: json["last"],
        totalElements: json["totalElements"],
        totalPages: json["totalPages"],
        size: json["size"],
        number: json["number"],
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        numberOfElements: json["numberOfElements"],
        first: json["first"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "content": insuranceDataList == null
            ? []
            : List<dynamic>.from(insuranceDataList!.map((x) => x.toJson())),
        "pageable": pageable?.toJson(),
        "last": last,
        "totalElements": totalElements,
        "totalPages": totalPages,
        "size": size,
        "number": number,
        "sort": sort?.toJson(),
        "numberOfElements": numberOfElements,
        "first": first,
        "empty": empty,
      };
}

class InsuranceDataList {
  String? insuranceId;
  String? insuranceNo;
  double? insuredAmt;
  double? premiumAmt;
  String? invoiceNo;
  String? insuredDate;
  String? ownDmgExpiryDate;
  String? thirdPartyExpiryDate;
  String? customerName;
  String? vehicleNo;
  String? customerId;
  String? mobileNo;
  String? insuranceCompanyName;

  InsuranceDataList({
    this.insuranceId,
    this.insuranceNo,
    this.insuredAmt,
    this.premiumAmt,
    this.invoiceNo,
    this.insuredDate,
    this.ownDmgExpiryDate,
    this.thirdPartyExpiryDate,
    this.customerName,
    this.vehicleNo,
    this.customerId,
    this.mobileNo,
    this.insuranceCompanyName,
  });

  factory InsuranceDataList.fromJson(Map<String, dynamic> json) =>
      InsuranceDataList(
        insuranceId: json["insuranceId"],
        insuranceNo: json["insuranceNo"],
        insuredAmt: json["insuredAmt"],
        premiumAmt: json["premiumAmt"],
        invoiceNo: json["invoiceNo"],
        insuredDate: json["insuredDate"],
        ownDmgExpiryDate: json["ownDmgExpiryDate"],
        thirdPartyExpiryDate: json["thirdPartyExpiryDate"],
        customerName: json["customerName"],
        vehicleNo: json["vehicleNo"],
        customerId: json["customerId"],
        mobileNo: json["mobileNo"],
        insuranceCompanyName: json["insuranceCompanyName"],
      );

  Map<String, dynamic> toJson() => {
        "insuranceId": insuranceId,
        "insuranceNo": insuranceNo,
        "insuredAmt": insuredAmt,
        "premiumAmt": premiumAmt,
        "invoiceNo": invoiceNo,
        "insuredDate": insuredDate,
        "ownDmgExpiryDate": ownDmgExpiryDate,
        "thirdPartyExpiryDate": thirdPartyExpiryDate,
        "customerName": customerName,
        "vehicleNo": vehicleNo,
        "customerId": customerId,
        "mobileNo": mobileNo,
        "insuranceCompanyName": insuranceCompanyName,
      };
}

class Pageable {
  Sort? sort;
  int? offset;
  int? pageSize;
  int? pageNumber;
  bool? unpaged;
  bool? paged;

  Pageable({
    this.sort,
    this.offset,
    this.pageSize,
    this.pageNumber,
    this.unpaged,
    this.paged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        offset: json["offset"],
        pageSize: json["pageSize"],
        pageNumber: json["pageNumber"],
        unpaged: json["unpaged"],
        paged: json["paged"],
      );

  Map<String, dynamic> toJson() => {
        "sort": sort?.toJson(),
        "offset": offset,
        "pageSize": pageSize,
        "pageNumber": pageNumber,
        "unpaged": unpaged,
        "paged": paged,
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
