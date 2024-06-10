// To parse this JSON data, do
//
//     final purchaseByPartNoModel = purchaseByPartNoModelFromJson(jsonString);

import 'dart:convert';

PurchaseByPartNoModel purchaseByPartNoModelFromJson(String str) => PurchaseByPartNoModel.fromJson(json.decode(str));

String purchaseByPartNoModelToJson(PurchaseByPartNoModel data) => json.encode(data.toJson());

class PurchaseByPartNoModel {
    String? categoryId;
    int? discount;
    int? finalInvoiceValue;
    List<GstDetail>? gstDetails;
    List<Incentive>? incentives;
    int? invoiceValue;
    String? itemName;
    Value? mainSpecValue;
    String? partNo;
    int? quantity;
    Value? specificationsValue;
    int? taxableValue;
    List<Tax>? taxes;
    int? unitRate;
    int? value;

    PurchaseByPartNoModel({
        this.categoryId,
        this.discount,
        this.finalInvoiceValue,
        this.gstDetails,
        this.incentives,
        this.invoiceValue,
        this.itemName,
        this.mainSpecValue,
        this.partNo,
        this.quantity,
        this.specificationsValue,
        this.taxableValue,
        this.taxes,
        this.unitRate,
        this.value,
    });

    factory PurchaseByPartNoModel.fromJson(Map<String, dynamic> json) => PurchaseByPartNoModel(
        categoryId: json["categoryId"],
        discount: json["discount"],
        finalInvoiceValue: json["finalInvoiceValue"],
        gstDetails: json["gstDetails"] == null ? [] : List<GstDetail>.from(json["gstDetails"]!.map((x) => GstDetail.fromJson(x))),
        incentives: json["incentives"] == null ? [] : List<Incentive>.from(json["incentives"]!.map((x) => Incentive.fromJson(x))),
        invoiceValue: json["invoiceValue"],
        itemName: json["itemName"],
        mainSpecValue: json["mainSpecValue"] == null ? null : Value.fromJson(json["mainSpecValue"]),
        partNo: json["partNo"],
        quantity: json["quantity"],
        specificationsValue: json["specificationsValue"] == null ? null : Value.fromJson(json["specificationsValue"]),
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
        "itemName": itemName,
        "mainSpecValue": mainSpecValue?.toJson(),
        "partNo": partNo,
        "quantity": quantity,
        "specificationsValue": specificationsValue?.toJson(),
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

class Value {
    Value();

    factory Value.fromJson(Map<String, dynamic> json) => Value(
    );

    Map<String, dynamic> toJson() => {
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
