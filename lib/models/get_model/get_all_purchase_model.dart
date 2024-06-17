// To parse this JSON data, do
//
//     final getAllPurchaseByPageNation = getAllPurchaseByPageNationFromJson(jsonString);

import 'dart:convert';

GetAllPurchaseByPageNation getAllPurchaseByPageNationFromJson(String str) =>
    GetAllPurchaseByPageNation.fromJson(json.decode(str));

String getAllPurchaseByPageNationToJson(GetAllPurchaseByPageNation data) =>
    json.encode(data.toJson());

class GetAllPurchaseByPageNation {
  List<PurchaseBill>? content;
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

  factory GetAllPurchaseByPageNation.fromJson(Map<String, dynamic> json) =>
      GetAllPurchaseByPageNation(
        content: json["content"] == null
            ? []
            : List<PurchaseBill>.from(
                json["content"]!.map((x) => PurchaseBill.fromJson(x))),
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
        "content": content == null
            ? []
            : List<dynamic>.from(content!.map((x) => x.toJson())),
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

class PurchaseBill {
  String? branchId;
  String? branchName;
  double? finalTotalInvoiceAmount;
  String? id;
  List<ItemDetail>? itemDetails;
  DateTime? pInvoiceDate;
  String? pInvoiceNo;
  String? pOrderRefNo;
  String? purchaseId;
  String? purchaseNo;
  double? totalGstAmount;
  double? totalIncentiveAmount;
  double? totalInvoiceAmount;
  int? totalQty;
  double? totalTaxAmount;
  double? totalValue;
  String? vendorId;
  String? vendorName;
  bool? stockUpdated;
  bool? cancelled;

  PurchaseBill(
      {this.branchId,
      this.branchName,
      this.finalTotalInvoiceAmount,
      this.id,
      this.itemDetails,
      this.pInvoiceDate,
      this.pInvoiceNo,
      this.pOrderRefNo,
      this.purchaseId,
      this.purchaseNo,
      this.totalGstAmount,
      this.totalIncentiveAmount,
      this.totalInvoiceAmount,
      this.totalQty,
      this.totalTaxAmount,
      this.totalValue,
      this.vendorId,
      this.vendorName,
      this.cancelled,
      this.stockUpdated});

  factory PurchaseBill.fromJson(Map<String, dynamic> json) => PurchaseBill(
        branchId: json["branchId"],
        branchName: json["branchName"],
        finalTotalInvoiceAmount: json["finalTotalInvoiceAmount"],
        id: json["id"],
        itemDetails: json["itemDetails"] == null
            ? []
            : List<ItemDetail>.from(
                json["itemDetails"]!.map((x) => ItemDetail.fromJson(x))),
        pInvoiceDate: json["p_invoiceDate"] == null
            ? null
            : DateTime.parse(json["p_invoiceDate"]),
        pInvoiceNo: json["p_invoiceNo"],
        pOrderRefNo: json["p_orderRefNo"],
        purchaseId: json["purchaseId"],
        purchaseNo: json["purchaseNo"],
        totalGstAmount: json["totalGstAmount"],
        totalIncentiveAmount: json["totalIncentiveAmount"],
        totalInvoiceAmount: json["totalInvoiceAmount"],
        totalQty: json["totalQty"],
        totalTaxAmount: json["totalTaxAmount"],
        totalValue: json["totalValue"],
        vendorId: json["vendorId"],
        vendorName: json["vendorName"],
        stockUpdated: json["stockUpdated"],
        cancelled: json["cancelled"],
      );

  Map<String, dynamic> toJson() => {
        "branchId": branchId,
        "branchName": branchName,
        "finalTotalInvoiceAmount": finalTotalInvoiceAmount,
        "id": id,
        "itemDetails": itemDetails == null
            ? []
            : List<dynamic>.from(itemDetails!.map((x) => x.toJson())),
        "p_invoiceDate":
            "${pInvoiceDate!.year.toString().padLeft(4, '0')}-${pInvoiceDate!.month.toString().padLeft(2, '0')}-${pInvoiceDate!.day.toString().padLeft(2, '0')}",
        "p_invoiceNo": pInvoiceNo,
        "p_orderRefNo": pOrderRefNo,
        "purchaseId": purchaseId,
        "purchaseNo": purchaseNo,
        "totalGstAmount": totalGstAmount,
        "totalIncentiveAmount": totalIncentiveAmount,
        "totalInvoiceAmount": totalInvoiceAmount,
        "totalQty": totalQty,
        "totalTaxAmount": totalTaxAmount,
        "totalValue": totalValue,
        "vendorId": vendorId,
        "cancelled": cancelled,
        "stockUpdated": stockUpdated,
        "vendorName": vendorName,
      };
}

class ItemDetail {
  String? categoryId;
  String? categoryName;
  double? discount;
  double? finalInvoiceValue;
  List<GstDetail>? gstDetails;
  String? hsnSacCode;
  List<Incentive>? incentives;
  double? invoiceValue;
  String? itemName;
  List<VehicleDetails>? mainSpecValues;
  String? partNo;
  int? quantity;
  VehicleDetails? specificationsValue;
  double? taxableValue;
  List<Tax>? taxes;
  double? unitRate;
  double? value;
  bool? cancelled;
  bool? stockUpdated;

  ItemDetail({
    this.categoryId,
    this.categoryName,
    this.discount,
    this.finalInvoiceValue,
    this.gstDetails,
    this.hsnSacCode,
    this.incentives,
    this.invoiceValue,
    this.itemName,
    this.mainSpecValues,
    this.partNo,
    this.quantity,
    this.specificationsValue,
    this.taxableValue,
    this.taxes,
    this.unitRate,
    this.value,
    this.cancelled,
    this.stockUpdated,
  });

  factory ItemDetail.fromJson(Map<String, dynamic> json) => ItemDetail(
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        discount: json["discount"],
        finalInvoiceValue: json["finalInvoiceValue"],
        gstDetails: json["gstDetails"] == null
            ? []
            : List<GstDetail>.from(
                json["gstDetails"].map((x) => GstDetail.fromJson(x))),
        hsnSacCode: json["hsnSacCode"],
        incentives: json["incentives"] == null
            ? []
            : List<Incentive>.from(
                json["incentives"].map((x) => Incentive.fromJson(x))),
        invoiceValue: json["invoiceValue"],
        itemName: json["itemName"],
        mainSpecValues: json["mainSpecValues"] == null
            ? null
            : List<VehicleDetails>.from(json["mainSpecValues"].map((x) {
                return VehicleDetails.fromJson(x);
              })),
        partNo: json["partNo"],
        quantity: json["quantity"],
        specificationsValue: json["specificationsValue"] == null
            ? null
            : VehicleDetails.fromJson(json["specificationsValue"]),
        taxableValue: json["taxableValue"],
        taxes: json["taxes"] == null
            ? []
            : List<Tax>.from(json["taxes"].map((x) => Tax.fromJson(x))),
        unitRate: json["unitRate"],
        value: json["value"],
        cancelled: json["cancelled"],
        stockUpdated: json["stockUpdated"],
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "categoryName": categoryName,
        "discount": discount,
        "finalInvoiceValue": finalInvoiceValue,
        "gstDetails": gstDetails == null
            ? []
            : List<dynamic>.from(gstDetails!.map((x) => x.toJson())),
        "hsnSacCode": hsnSacCode,
        "incentives": incentives == null
            ? []
            : List<dynamic>.from(incentives!.map((x) => x.toJson())),
        "invoiceValue": invoiceValue,
        "itemName": itemName,
        "mainSpecValues": mainSpecValues == null
            ? []
            : List<dynamic>.from(mainSpecValues!.map((x) => x.toJson())),
        "partNo": partNo,
        "quantity": quantity,
        "specificationsValue": specificationsValue?.toJson(),
        "taxableValue": taxableValue,
        "taxes": taxes == null
            ? []
            : List<dynamic>.from(taxes!.map((x) => x.toJson())),
        "unitRate": unitRate,
        "value": value,
        "cancelled": cancelled,
        "stockUpdated": stockUpdated,
      };
}

class VehicleDetails {
  String? engineNumber;
  String? frameNumber;

  VehicleDetails({this.engineNumber, this.frameNumber});

  factory VehicleDetails.fromJson(Map<String, dynamic> json) {
    return VehicleDetails(
      engineNumber: json['engineNo'],
      frameNumber: json['frameNo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'engineNo': engineNumber,
      'frameNo': frameNumber,
    };
  }
}

class GstDetail {
  double? gstAmount;
  String? gstName;
  double? percentage;

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
  double? incentiveAmount;
  String? incentiveName;
  double? percentage;

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

class Tax {
  double? percentage;
  double? taxAmount;
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
