// To parse this JSON data, do
//
//     final purchaseByPartNoModel = purchaseByPartNoModelFromJson(jsonString);

import 'dart:convert';

PurchaseByPartNoModel purchaseByPartNoModelFromJson(String str) =>
    PurchaseByPartNoModel.fromJson(json.decode(str));

String purchaseByPartNoModelToJson(PurchaseByPartNoModel data) =>
    json.encode(data.toJson());

class PurchaseByPartNoModel {
  String? categoryId;
  String? categoryName;
  double? discount;
  double? finalInvoiceValue;
  List<GstDetail>? gstDetails;
  String? hsnSacCode;
  List<Incentive>? incentives;
  double? invoiceValue;
  String? itemName;
  List<Value>? mainSpecValues;
  String? partNo;
  int? quantity;
  Value? specificationsValue;
  double? taxableValue;
  List<Tax>? taxes;
  double? unitRate;
  double? value;

  PurchaseByPartNoModel({
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
  });

  factory PurchaseByPartNoModel.fromJson(Map<String, dynamic> json) =>
      PurchaseByPartNoModel(
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        discount: json["discount"],
        finalInvoiceValue: json["finalInvoiceValue"],
        gstDetails: json["gstDetails"] == null
            ? []
            : List<GstDetail>.from(
                json["gstDetails"]!.map((x) => GstDetail.fromJson(x))),
        hsnSacCode: json["hsnSacCode"],
        incentives: json["incentives"] == null
            ? []
            : List<Incentive>.from(
                json["incentives"]!.map((x) => Incentive.fromJson(x))),
        invoiceValue: json["invoiceValue"],
        itemName: json["itemName"],
        mainSpecValues: json["mainSpecValues"] == null
            ? []
            : List<Value>.from(
                json["mainSpecValues"]!.map((x) => Value.fromJson(x))),
        partNo: json["partNo"],
        quantity: json["quantity"],
        taxableValue: json["taxableValue"],
        taxes: json["taxes"] == null
            ? []
            : List<Tax>.from(json["taxes"]!.map((x) => Tax.fromJson(x))),
        unitRate: json["unitRate"],
        value: json["value"],
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
      };
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

class Value {
  Value();

  factory Value.fromJson(Map<String, dynamic> json) => Value();

  Map<String, dynamic> toJson() => {};
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
