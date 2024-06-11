// To parse this JSON data, do
//
//     final getAllStockDetails = getAllStockDetailsFromJson(jsonString);

import 'dart:convert';

GetAllStockDetails getAllStockDetailsFromJson(String str) =>
    GetAllStockDetails.fromJson(json.decode(str));

String getAllStockDetailsToJson(GetAllStockDetails data) =>
    json.encode(data.toJson());

class GetAllStockDetails {
  List<Stock>? stocks;

  GetAllStockDetails({
    this.stocks,
  });

  factory GetAllStockDetails.fromJson(Map<String, dynamic> json) =>
      GetAllStockDetails(
        stocks: json["Stocks"] == null
            ? []
            : List<Stock>.from(json["Stocks"]!.map((x) => Stock.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Stocks": stocks == null
            ? []
            : List<dynamic>.from(stocks!.map((x) => x.toJson())),
      };
}

class Stock {
  String? branchId;
  String? categoryId;
  String? createdBy;
  DateTime? createdDateTime;
  String? id;
  Value? mainSpecValue;
  String? partNo;
  String? purchaseId;
  Item? purchaseItem;
  int? purchaseQuantity;
  int? quantity;
  String? salesId;
  Item? salesItem;
  int? salesQuantity;
  Value? specificationsValue;
  String? stockId;
  String? stockStatus;
  List<TransferDetail>? transferDetails;
  String? updatedBy;
  DateTime? updatedDateTime;

  Stock({
    this.branchId,
    this.categoryId,
    this.createdBy,
    this.createdDateTime,
    this.id,
    this.mainSpecValue,
    this.partNo,
    this.purchaseId,
    this.purchaseItem,
    this.purchaseQuantity,
    this.quantity,
    this.salesId,
    this.salesItem,
    this.salesQuantity,
    this.specificationsValue,
    this.stockId,
    this.stockStatus,
    this.transferDetails,
    this.updatedBy,
    this.updatedDateTime,
  });

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
        branchId: json["branchId"],
        categoryId: json["categoryId"],
        createdBy: json["createdBy"],
        createdDateTime: json["createdDateTime"] == null
            ? null
            : DateTime.parse(json["createdDateTime"]),
        id: json["id"],
        mainSpecValue: json["mainSpecValue"] == null
            ? null
            : Value.fromJson(json["mainSpecValue"]),
        partNo: json["partNo"],
        purchaseId: json["purchaseId"],
        purchaseItem: json["purchaseItem"] == null
            ? null
            : Item.fromJson(json["purchaseItem"]),
        purchaseQuantity: json["purchaseQuantity"],
        quantity: json["quantity"],
        salesId: json["salesId"],
        salesItem:
            json["salesItem"] == null ? null : Item.fromJson(json["salesItem"]),
        salesQuantity: json["salesQuantity"],
        specificationsValue: json["specificationsValue"] == null
            ? null
            : Value.fromJson(json["specificationsValue"]),
        stockId: json["stockId"],
        stockStatus: json["stockStatus"],
        transferDetails: json["transferDetails"] == null
            ? []
            : List<TransferDetail>.from(json["transferDetails"]!
                .map((x) => TransferDetail.fromJson(x))),
        updatedBy: json["updatedBy"],
        updatedDateTime: json["updatedDateTime"] == null
            ? null
            : DateTime.parse(json["updatedDateTime"]),
      );

  Map<String, dynamic> toJson() => {
        "branchId": branchId,
        "categoryId": categoryId,
        "createdBy": createdBy,
        "createdDateTime": createdDateTime?.toIso8601String(),
        "id": id,
        "mainSpecValue": mainSpecValue?.toJson(),
        "partNo": partNo,
        "purchaseId": purchaseId,
        "purchaseItem": purchaseItem?.toJson(),
        "purchaseQuantity": purchaseQuantity,
        "quantity": quantity,
        "salesId": salesId,
        "salesItem": salesItem?.toJson(),
        "salesQuantity": salesQuantity,
        "specificationsValue": specificationsValue?.toJson(),
        "stockId": stockId,
        "stockStatus": stockStatus,
        "transferDetails": transferDetails == null
            ? []
            : List<dynamic>.from(transferDetails!.map((x) => x.toJson())),
        "updatedBy": updatedBy,
        "updatedDateTime": updatedDateTime?.toIso8601String(),
      };
}

class Value {
  String? additionalProp1;
  String? additionalProp2;
  String? additionalProp3;

  Value({
    this.additionalProp1,
    this.additionalProp2,
    this.additionalProp3,
  });

  factory Value.fromJson(Map<String, dynamic> json) => Value(
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

class Item {
  int? discount;
  int? finalInvoiceValue;
  List<GstDetail>? gstDetails;
  List<Incentive>? incentives;
  int? invoiceValue;
  int? taxableValue;
  List<Tax>? taxes;
  int? unitRate;
  int? value;

  Item({
    this.discount,
    this.finalInvoiceValue,
    this.gstDetails,
    this.incentives,
    this.invoiceValue,
    this.taxableValue,
    this.taxes,
    this.unitRate,
    this.value,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        discount: json["discount"],
        finalInvoiceValue: json["finalInvoiceValue"],
        gstDetails: json["gstDetails"] == null
            ? []
            : List<GstDetail>.from(
                json["gstDetails"]!.map((x) => GstDetail.fromJson(x))),
        incentives: json["incentives"] == null
            ? []
            : List<Incentive>.from(
                json["incentives"]!.map((x) => Incentive.fromJson(x))),
        invoiceValue: json["invoiceValue"],
        taxableValue: json["taxableValue"],
        taxes: json["taxes"] == null
            ? []
            : List<Tax>.from(json["taxes"]!.map((x) => Tax.fromJson(x))),
        unitRate: json["unitRate"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "discount": discount,
        "finalInvoiceValue": finalInvoiceValue,
        "gstDetails": gstDetails == null
            ? []
            : List<dynamic>.from(gstDetails!.map((x) => x.toJson())),
        "incentives": incentives == null
            ? []
            : List<dynamic>.from(incentives!.map((x) => x.toJson())),
        "invoiceValue": invoiceValue,
        "taxableValue": taxableValue,
        "taxes": taxes == null
            ? []
            : List<dynamic>.from(taxes!.map((x) => x.toJson())),
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

class TransferDetail {
  DateTime? receivedDate;
  String? status;
  DateTime? transferDate;
  String? transferFromBranch;
  String? transferToBranch;

  TransferDetail({
    this.receivedDate,
    this.status,
    this.transferDate,
    this.transferFromBranch,
    this.transferToBranch,
  });

  factory TransferDetail.fromJson(Map<String, dynamic> json) => TransferDetail(
        receivedDate: json["receivedDate"] == null
            ? null
            : DateTime.parse(json["receivedDate"]),
        status: json["status"],
        transferDate: json["transferDate"] == null
            ? null
            : DateTime.parse(json["transferDate"]),
        transferFromBranch: json["transferFromBranch"],
        transferToBranch: json["transferToBranch"],
      );

  Map<String, dynamic> toJson() => {
        "receivedDate": receivedDate?.toIso8601String(),
        "status": status,
        "transferDate": transferDate?.toIso8601String(),
        "transferFromBranch": transferFromBranch,
        "transferToBranch": transferToBranch,
      };
}
