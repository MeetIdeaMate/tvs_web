// To parse this JSON data, do
//
//     final getAllVoucherWithPagenationModel = getAllVoucherWithPagenationModelFromJson(jsonString);

import 'dart:convert';

GetAllVoucherWithPagenationModel getAllVoucherWithPagenationModelFromJson(String str) => GetAllVoucherWithPagenationModel.fromJson(json.decode(str));

String getAllVoucherWithPagenationModelToJson(GetAllVoucherWithPagenationModel data) => json.encode(data.toJson());

class GetAllVoucherWithPagenationModel {
    List<VoucherDetails>? content;
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

    GetAllVoucherWithPagenationModel({
        this.content,
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

    factory GetAllVoucherWithPagenationModel.fromJson(Map<String, dynamic> json) => GetAllVoucherWithPagenationModel(
        content: json["content"] == null ? [] : List<VoucherDetails>.from(json["content"]!.map((x) => VoucherDetails.fromJson(x))),
        empty: json["empty"],
        first: json["first"],
        last: json["last"],
        number: json["number"],
        numberOfElements: json["numberOfElements"],
        pageable: json["pageable"] == null ? null : Pageable.fromJson(json["pageable"]),
        size: json["size"],
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        totalElements: json["totalElements"],
        totalPages: json["totalPages"],
    );

    Map<String, dynamic> toJson() => {
        "content": content == null ? [] : List<dynamic>.from(content!.map((x) => x.toJson())),
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

class VoucherDetails {
    String? approvedPay;
    String? createdBy;
    DateTime? createdDateTime;
    String? id;
    double? paidAmount;
    String? paidTo;
    String? reason;
    String? updatedBy;
    DateTime? updatedDateTime;
    DateTime? voucherDate;
    String? voucherId;

    VoucherDetails({
        this.approvedPay,
        this.createdBy,
        this.createdDateTime,
        this.id,
        this.paidAmount,
        this.paidTo,
        this.reason,
        this.updatedBy,
        this.updatedDateTime,
        this.voucherDate,
        this.voucherId,
    });

    factory VoucherDetails.fromJson(Map<String, dynamic> json) => VoucherDetails(
        approvedPay: json["approvedPay"],
        createdBy: json["createdBy"],
        createdDateTime: json["createdDateTime"] == null ? null : DateTime.parse(json["createdDateTime"]),
        id: json["id"],
        paidAmount: json["paidAmount"],
        paidTo: json["paidTo"],
        reason: json["reason"],
        updatedBy: json["updatedBy"],
        updatedDateTime: json["updatedDateTime"] == null ? null : DateTime.parse(json["updatedDateTime"]),
        voucherDate: json["voucherDate"] == null ? null : DateTime.parse(json["voucherDate"]),
        voucherId: json["voucherId"],
    );

    Map<String, dynamic> toJson() => {
        "approvedPay": approvedPay,
        "createdBy": createdBy,
        "createdDateTime": createdDateTime?.toIso8601String(),
        "id": id,
        "paidAmount": paidAmount,
        "paidTo": paidTo,
        "reason": reason,
        "updatedBy": updatedBy,
        "updatedDateTime": updatedDateTime?.toIso8601String(),
        "voucherDate": "${voucherDate!.year.toString().padLeft(4, '0')}-${voucherDate!.month.toString().padLeft(2, '0')}-${voucherDate!.day.toString().padLeft(2, '0')}",
        "voucherId": voucherId,
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
