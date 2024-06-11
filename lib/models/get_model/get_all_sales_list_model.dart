import 'dart:convert';

GetAllSalesList getAllSalesListFromJson(String str) =>
    GetAllSalesList.fromJson(json.decode(str));

String getAllSalesListToJson(GetAllSalesList data) =>
    json.encode(data.toJson());

class GetAllSalesList {
  List<SalesList>? salesList;

  GetAllSalesList({
    this.salesList,
  });

  factory GetAllSalesList.fromJson(Map<String, dynamic> json) =>
      GetAllSalesList(
        salesList: json["salesList"] == null
            ? []
            : List<SalesList>.from(
                json["salesList"]!.map((x) => SalesList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "salesList": salesList == null
            ? []
            : List<dynamic>.from(salesList!.map((x) => x.toJson())),
      };
}

class SalesList {
  String? billType;
  String? createdBy;
  DateTime? createdDateTime;
  String? customerId;
  String? id;
  DateTime? invoiceDate;
  String? invoiceNo;
  String? invoiceType;
  List<ItemDetail>? itemDetails;
  int? netAmt;
  List<PaidDetail>? paidDetails;
  String? paymentStatus;
  int? roundOffAmt;
  int? totalCgst;
  int? totalDisc;
  int? totalInvoiceAmt;
  int? totalQty;
  int? totalSgst;
  int? totalTaxableAmt;
  String? updatedBy;
  DateTime? updatedDateTime;

  SalesList({
    this.billType,
    this.createdBy,
    this.createdDateTime,
    this.customerId,
    this.id,
    this.invoiceDate,
    this.invoiceNo,
    this.invoiceType,
    this.itemDetails,
    this.netAmt,
    this.paidDetails,
    this.paymentStatus,
    this.roundOffAmt,
    this.totalCgst,
    this.totalDisc,
    this.totalInvoiceAmt,
    this.totalQty,
    this.totalSgst,
    this.totalTaxableAmt,
    this.updatedBy,
    this.updatedDateTime,
  });

  factory SalesList.fromJson(Map<String, dynamic> json) => SalesList(
        billType: json["billType"],
        createdBy: json["createdBy"],
        createdDateTime: json["createdDateTime"] == null
            ? null
            : DateTime.parse(json["createdDateTime"]),
        customerId: json["customerId"],
        id: json["id"],
        invoiceDate: json["invoiceDate"] == null
            ? null
            : DateTime.parse(json["invoiceDate"]),
        invoiceNo: json["invoiceNo"],
        invoiceType: json["invoiceType"],
        itemDetails: json["itemDetails"] == null
            ? []
            : List<ItemDetail>.from(
                json["itemDetails"]!.map((x) => ItemDetail.fromJson(x))),
        netAmt: json["netAmt"],
        paidDetails: json["paidDetails"] == null
            ? []
            : List<PaidDetail>.from(
                json["paidDetails"]!.map((x) => PaidDetail.fromJson(x))),
        paymentStatus: json["paymentStatus"],
        roundOffAmt: json["roundOffAmt"],
        totalCgst: json["totalCgst"],
        totalDisc: json["totalDisc"],
        totalInvoiceAmt: json["totalInvoiceAmt"],
        totalQty: json["totalQty"],
        totalSgst: json["totalSgst"],
        totalTaxableAmt: json["totalTaxableAmt"],
        updatedBy: json["updatedBy"],
        updatedDateTime: json["updatedDateTime"] == null
            ? null
            : DateTime.parse(json["updatedDateTime"]),
      );

  Map<String, dynamic> toJson() => {
        "billType": billType,
        "createdBy": createdBy,
        "createdDateTime": createdDateTime?.toIso8601String(),
        "customerId": customerId,
        "id": id,
        "invoiceDate":
            "${invoiceDate!.year.toString().padLeft(4, '0')}-${invoiceDate!.month.toString().padLeft(2, '0')}-${invoiceDate!.day.toString().padLeft(2, '0')}",
        "invoiceNo": invoiceNo,
        "invoiceType": invoiceType,
        "itemDetails": itemDetails == null
            ? []
            : List<dynamic>.from(itemDetails!.map((x) => x.toJson())),
        "netAmt": netAmt,
        "paidDetails": paidDetails == null
            ? []
            : List<dynamic>.from(paidDetails!.map((x) => x.toJson())),
        "paymentStatus": paymentStatus,
        "roundOffAmt": roundOffAmt,
        "totalCgst": totalCgst,
        "totalDisc": totalDisc,
        "totalInvoiceAmt": totalInvoiceAmt,
        "totalQty": totalQty,
        "totalSgst": totalSgst,
        "totalTaxableAmt": totalTaxableAmt,
        "updatedBy": updatedBy,
        "updatedDateTime": updatedDateTime?.toIso8601String(),
      };
}

class ItemDetail {
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

  ItemDetail({
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

  factory ItemDetail.fromJson(Map<String, dynamic> json) => ItemDetail(
        categoryId: json["categoryId"],
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
        itemName: json["itemName"],
        mainSpecValue: json["mainSpecValue"] == null
            ? null
            : Value.fromJson(json["mainSpecValue"]),
        partNo: json["partNo"],
        quantity: json["quantity"],
        specificationsValue: json["specificationsValue"] == null
            ? null
            : Value.fromJson(json["specificationsValue"]),
        taxableValue: json["taxableValue"],
        taxes: json["taxes"] == null
            ? []
            : List<Tax>.from(json["taxes"]!.map((x) => Tax.fromJson(x))),
        unitRate: json["unitRate"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "discount": discount,
        "finalInvoiceValue": finalInvoiceValue,
        "gstDetails": gstDetails == null
            ? []
            : List<dynamic>.from(gstDetails!.map((x) => x.toJson())),
        "incentives": incentives == null
            ? []
            : List<dynamic>.from(incentives!.map((x) => x.toJson())),
        "invoiceValue": invoiceValue,
        "itemName": itemName,
        "mainSpecValue": mainSpecValue?.toJson(),
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

class PaidDetail {
  String? id;
  String? paidAmount;
  String? paymentDate;
  String? paymentId;
  String? paymentType;

  PaidDetail({
    this.id,
    this.paidAmount,
    this.paymentDate,
    this.paymentId,
    this.paymentType,
  });

  factory PaidDetail.fromJson(Map<String, dynamic> json) => PaidDetail(
        id: json["id"],
        paidAmount: json["paidAmount"],
        paymentDate: json["paymentDate"],
        paymentId: json["paymentId"],
        paymentType: json["paymentType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "paidAmount": paidAmount,
        "paymentDate": paymentDate,
        "paymentId": paymentId,
        "paymentType": paymentType,
      };
}
