// To parse this JSON data, do
//
//     final getAllPurchaseByPageNation = getAllPurchaseByPageNationFromJson(jsonString);

import 'dart:convert';

GetAllPurchaseByPageNation getAllPurchaseByPageNationFromJson(String str) => GetAllPurchaseByPageNation.fromJson(json.decode(str));

String getAllPurchaseByPageNationToJson(GetAllPurchaseByPageNation data) => json.encode(data.toJson());

class GetAllPurchaseByPageNation {
    List<Content>? content;
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

    GetAllPurchaseByPageNation({
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

    factory GetAllPurchaseByPageNation.fromJson(Map<String, dynamic> json) => GetAllPurchaseByPageNation(
        content: json["content"] == null ? [] : List<Content>.from(json["content"]!.map((x) => Content.fromJson(x))),
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

class Content {
    String? branchId;
    String? createdBy;
    DateTime? createdDateTime;
    int? finalTotalInvoiceAmount;
    String? gstType;
    String? id;
    List<ItemDetail>? itemDetails;
    DateTime? pInvoiceDate;
    String? pInvoiceNo;
    String? pOrderRefNo;
    String? purchaseNo;
    int? totalGstAmount;
    int? totalIncentiveAmount;
    int? totalInvoiceAmount;
    int? totalQty;
    int? totalTaxAmount;
    int? totalValue;
    String? updatedBy;
    DateTime? updatedDateTime;
    String? vendorId;

    Content({
        this.branchId,
        this.createdBy,
        this.createdDateTime,
        this.finalTotalInvoiceAmount,
        this.gstType,
        this.id,
        this.itemDetails,
        this.pInvoiceDate,
        this.pInvoiceNo,
        this.pOrderRefNo,
        this.purchaseNo,
        this.totalGstAmount,
        this.totalIncentiveAmount,
        this.totalInvoiceAmount,
        this.totalQty,
        this.totalTaxAmount,
        this.totalValue,
        this.updatedBy,
        this.updatedDateTime,
        this.vendorId,
    });

    factory Content.fromJson(Map<String, dynamic> json) => Content(
        branchId: json["branchId"],
        createdBy: json["createdBy"],
        createdDateTime: json["createdDateTime"] == null ? null : DateTime.parse(json["createdDateTime"]),
        finalTotalInvoiceAmount: json["finalTotalInvoiceAmount"],
        gstType: json["gstType"],
        id: json["id"],
        itemDetails: json["itemDetails"] == null ? [] : List<ItemDetail>.from(json["itemDetails"]!.map((x) => ItemDetail.fromJson(x))),
        pInvoiceDate: json["p_invoiceDate"] == null ? null : DateTime.parse(json["p_invoiceDate"]),
        pInvoiceNo: json["p_invoiceNo"],
        pOrderRefNo: json["p_orderRefNo"],
        purchaseNo: json["purchaseNo"],
        totalGstAmount: json["totalGstAmount"],
        totalIncentiveAmount: json["totalIncentiveAmount"],
        totalInvoiceAmount: json["totalInvoiceAmount"],
        totalQty: json["totalQty"],
        totalTaxAmount: json["totalTaxAmount"],
        totalValue: json["totalValue"],
        updatedBy: json["updatedBy"],
        updatedDateTime: json["updatedDateTime"] == null ? null : DateTime.parse(json["updatedDateTime"]),
        vendorId: json["vendorId"],
    );

    Map<String, dynamic> toJson() => {
        "branchId": branchId,
        "createdBy": createdBy,
        "createdDateTime": createdDateTime?.toIso8601String(),
        "finalTotalInvoiceAmount": finalTotalInvoiceAmount,
        "gstType": gstType,
        "id": id,
        "itemDetails": itemDetails == null ? [] : List<dynamic>.from(itemDetails!.map((x) => x.toJson())),
        "p_invoiceDate": "${pInvoiceDate!.year.toString().padLeft(4, '0')}-${pInvoiceDate!.month.toString().padLeft(2, '0')}-${pInvoiceDate!.day.toString().padLeft(2, '0')}",
        "p_invoiceNo": pInvoiceNo,
        "p_orderRefNo": pOrderRefNo,
        "purchaseNo": purchaseNo,
        "totalGstAmount": totalGstAmount,
        "totalIncentiveAmount": totalIncentiveAmount,
        "totalInvoiceAmount": totalInvoiceAmount,
        "totalQty": totalQty,
        "totalTaxAmount": totalTaxAmount,
        "totalValue": totalValue,
        "updatedBy": updatedBy,
        "updatedDateTime": updatedDateTime?.toIso8601String(),
        "vendorId": vendorId,
    };
}

class ItemDetail {
    String? categoryId;
    int? discount;
    int? finalInvoiceValue;
    List<GstDetail>? gstDetails;
    List<Incentive>? incentives;
    int? invoiceValue;
    String? itemId;
    String? partNo;
    PrimarySpecification? primarySpecification;
    int? quantity;
    PrimarySpecification? specifications;
    int? taxableValue;
    List<Tax>? taxes;
    int? unitRate;
    int? value;

    ItemDetail({
        this.categoryId,
        this.discount,
        this.finalInvoiceValue,
        this.gstDetails,
        this.incentives,
        this.invoiceValue,
        this.itemId,
        this.partNo,
        this.primarySpecification,
        this.quantity,
        this.specifications,
        this.taxableValue,
        this.taxes,
        this.unitRate,
        this.value,
    });

    factory ItemDetail.fromJson(Map<String, dynamic> json) => ItemDetail(
        categoryId: json["categoryId"],
        discount: json["discount"],
        finalInvoiceValue: json["finalInvoiceValue"],
        gstDetails: json["gstDetails"] == null ? [] : List<GstDetail>.from(json["gstDetails"]!.map((x) => GstDetail.fromJson(x))),
        incentives: json["incentives"] == null ? [] : List<Incentive>.from(json["incentives"]!.map((x) => Incentive.fromJson(x))),
        invoiceValue: json["invoiceValue"],
        itemId: json["itemId"],
        partNo: json["partNo"],
        primarySpecification: json["primarySpecification"] == null ? null : PrimarySpecification.fromJson(json["primarySpecification"]),
        quantity: json["quantity"],
        specifications: json["specifications"] == null ? null : PrimarySpecification.fromJson(json["specifications"]),
        taxableValue: json["taxableValue"],
        taxes: json["taxes"] == null ? [] : List<Tax>.from(json["taxes"]!.map((x) => Tax.fromJson(x))),
        unitRate: json["unitRate"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "discount": discount,
        "finalInvoiceValue": finalInvoiceValue,
        "gstDetails": gstDetails == null ? [] : List<dynamic>.from(gstDetails!.map((x) => x.toJson())),
        "incentives": incentives == null ? [] : List<dynamic>.from(incentives!.map((x) => x.toJson())),
        "invoiceValue": invoiceValue,
        "itemId": itemId,
        "partNo": partNo,
        "primarySpecification": primarySpecification?.toJson(),
        "quantity": quantity,
        "specifications": specifications?.toJson(),
        "taxableValue": taxableValue,
        "taxes": taxes == null ? [] : List<dynamic>.from(taxes!.map((x) => x.toJson())),
        "unitRate": unitRate,
        "value": value,
    };
}

class GstDetail {
    int? gstAmount;
    String? gstName;
    int? percentage;

    GstDetail({
        this.gstAmount,
        this.gstName,
        this.percentage,
    });

    factory GstDetail.fromJson(Map<String, dynamic> json) => GstDetail(
        gstAmount: json["gstAmount"],
        gstName: json["gstName"],
        percentage: json["percentage"],
    );

    Map<String, dynamic> toJson() => {
        "gstAmount": gstAmount,
        "gstName": gstName,
        "percentage": percentage,
    };
}

class Incentive {
    int? incentiveAmount;
    String? incentiveName;
    int? percentage;

    Incentive({
        this.incentiveAmount,
        this.incentiveName,
        this.percentage,
    });

    factory Incentive.fromJson(Map<String, dynamic> json) => Incentive(
        incentiveAmount: json["incentiveAmount"],
        incentiveName: json["incentiveName"],
        percentage: json["percentage"],
    );

    Map<String, dynamic> toJson() => {
        "incentiveAmount": incentiveAmount,
        "incentiveName": incentiveName,
        "percentage": percentage,
    };
}

class PrimarySpecification {
    String? additionalProp1;
    String? additionalProp2;
    String? additionalProp3;

    PrimarySpecification({
        this.additionalProp1,
        this.additionalProp2,
        this.additionalProp3,
    });

    factory PrimarySpecification.fromJson(Map<String, dynamic> json) => PrimarySpecification(
        additionalProp1: json["additionalProp1"],
        additionalProp2: json["additionalProp2"],
        additionalProp3: json["additionalProp3"],
    );

    Map<String, dynamic> toJson() => {
        "additionalProp1": additionalProp1,
        "additionalProp2": additionalProp2,
        "additionalProp3": additionalProp3,
    };
}

class Tax {
    int? percentage;
    int? taxAmount;
    String? taxName;

    Tax({
        this.percentage,
        this.taxAmount,
        this.taxName,
    });

    factory Tax.fromJson(Map<String, dynamic> json) => Tax(
        percentage: json["percentage"],
        taxAmount: json["taxAmount"],
        taxName: json["taxName"],
    );

    Map<String, dynamic> toJson() => {
        "percentage": percentage,
        "taxAmount": taxAmount,
        "taxName": taxName,
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
