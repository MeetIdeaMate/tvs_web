// To parse this JSON data, do
//
//     final getAllSalesList = getAllSalesListFromJson(jsonString);

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
        salesList: json["SalesList"] == null
            ? []
            : List<SalesList>.from(
                json["SalesList"]!.map((x) => SalesList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "SalesList": salesList == null
            ? []
            : List<dynamic>.from(salesList!.map((x) => x.toJson())),
      };
}

class SalesList {
  String? billType;
  String? branchId;
  String? branchName;
  String? customerId;
  String? customerName;
  Insurance? insurance;
  DateTime? invoiceDate;
  String? invoiceNo;
  String? invoiceType;
  List<ItemDetail>? itemDetails;
  Loaninfo? loaninfo;
  String? mobileNo;
  int? netAmt;
  List<PaidDetail>? paidDetails;
  String? paymentStatus;
  int? pendingAmt;
  int? roundOffAmt;
  int? totalCgst;
  int? totalDisc;
  int? totalInvoiceAmt;
  int? totalQty;
  int? totalSgst;
  int? totalTaxableAmt;

  SalesList({
    this.billType,
    this.branchId,
    this.branchName,
    this.customerId,
    this.customerName,
    this.insurance,
    this.invoiceDate,
    this.invoiceNo,
    this.invoiceType,
    this.itemDetails,
    this.loaninfo,
    this.mobileNo,
    this.netAmt,
    this.paidDetails,
    this.paymentStatus,
    this.pendingAmt,
    this.roundOffAmt,
    this.totalCgst,
    this.totalDisc,
    this.totalInvoiceAmt,
    this.totalQty,
    this.totalSgst,
    this.totalTaxableAmt,
  });

  factory SalesList.fromJson(Map<String, dynamic> json) => SalesList(
        billType: json["billType"],
        branchId: json["branchId"],
        branchName: json["branchName"],
        customerId: json["customerId"],
        customerName: json["customerName"],
        insurance: json["insurance"] == null
            ? null
            : Insurance.fromJson(json["insurance"]),
        invoiceDate: json["invoiceDate"] == null
            ? null
            : DateTime.parse(json["invoiceDate"]),
        invoiceNo: json["invoiceNo"],
        invoiceType: json["invoiceType"],
        itemDetails: json["itemDetails"] == null
            ? []
            : List<ItemDetail>.from(
                json["itemDetails"]!.map((x) => ItemDetail.fromJson(x))),
        loaninfo: json["loaninfo"] == null
            ? null
            : Loaninfo.fromJson(json["loaninfo"]),
        mobileNo: json["mobileNo"],
        netAmt: json["netAmt"],
        paidDetails: json["paidDetails"] == null
            ? []
            : List<PaidDetail>.from(
                json["paidDetails"]!.map((x) => PaidDetail.fromJson(x))),
        paymentStatus: json["paymentStatus"],
        pendingAmt: json["pendingAmt"],
        roundOffAmt: json["roundOffAmt"],
        totalCgst: json["totalCgst"],
        totalDisc: json["totalDisc"],
        totalInvoiceAmt: json["totalInvoiceAmt"],
        totalQty: json["totalQty"],
        totalSgst: json["totalSgst"],
        totalTaxableAmt: json["totalTaxableAmt"],
      );

  Map<String, dynamic> toJson() => {
        "billType": billType,
        "branchId": branchId,
        "branchName": branchName,
        "customerId": customerId,
        "customerName": customerName,
        "insurance": insurance?.toJson(),
        "invoiceDate":
            "${invoiceDate!.year.toString().padLeft(4, '0')}-${invoiceDate!.month.toString().padLeft(2, '0')}-${invoiceDate!.day.toString().padLeft(2, '0')}",
        "invoiceNo": invoiceNo,
        "invoiceType": invoiceType,
        "itemDetails": itemDetails == null
            ? []
            : List<dynamic>.from(itemDetails!.map((x) => x.toJson())),
        "loaninfo": loaninfo?.toJson(),
        "mobileNo": mobileNo,
        "netAmt": netAmt,
        "paidDetails": paidDetails == null
            ? []
            : List<dynamic>.from(paidDetails!.map((x) => x.toJson())),
        "paymentStatus": paymentStatus,
        "pendingAmt": pendingAmt,
        "roundOffAmt": roundOffAmt,
        "totalCgst": totalCgst,
        "totalDisc": totalDisc,
        "totalInvoiceAmt": totalInvoiceAmt,
        "totalQty": totalQty,
        "totalSgst": totalSgst,
        "totalTaxableAmt": totalTaxableAmt,
      };
}

class Insurance {
  DateTime? expiryDate;
  String? insuranceCompanyName;
  String? insuranceId;
  int? insuredAmt;
  DateTime? insuredDate;
  String? invoiceNo;

  Insurance({
    this.expiryDate,
    this.insuranceCompanyName,
    this.insuranceId,
    this.insuredAmt,
    this.insuredDate,
    this.invoiceNo,
  });

  factory Insurance.fromJson(Map<String, dynamic> json) => Insurance(
        expiryDate: json["expiryDate"] == null
            ? null
            : DateTime.parse(json["expiryDate"]),
        insuranceCompanyName: json["insuranceCompanyName"],
        insuranceId: json["insuranceId"],
        insuredAmt: json["insuredAmt"],
        insuredDate: json["insuredDate"] == null
            ? null
            : DateTime.parse(json["insuredDate"]),
        invoiceNo: json["invoiceNo"],
      );

  Map<String, dynamic> toJson() => {
        "expiryDate": expiryDate?.toIso8601String(),
        "insuranceCompanyName": insuranceCompanyName,
        "insuranceId": insuranceId,
        "insuredAmt": insuredAmt,
        "insuredDate": insuredDate?.toIso8601String(),
        "invoiceNo": invoiceNo,
      };
}

class ItemDetail {
  String? categoryId;
  int? discount;
  int? finalInvoiceValue;
  List<GstDetail>? gstDetails;
  List<Incentive>? incentives;
  int? invoiceValue;
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
  Value();

  factory Value.fromJson(Map<String, dynamic> json) => Value();

  Map<String, dynamic> toJson() => {};
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

class Loaninfo {
  String? bankName;
  int? loanAmt;
  String? loanId;

  Loaninfo({
    this.bankName,
    this.loanAmt,
    this.loanId,
  });

  factory Loaninfo.fromJson(Map<String, dynamic> json) => Loaninfo(
        bankName: json["bankName"],
        loanAmt: json["loanAmt"],
        loanId: json["loanId"],
      );

  Map<String, dynamic> toJson() => {
        "bankName": bankName,
        "loanAmt": loanAmt,
        "loanId": loanId,
      };
}

class PaidDetail {
  String? paidAmount;
  DateTime? paymentDate;
  String? paymentId;
  String? paymentType;

  PaidDetail({
    this.paidAmount,
    this.paymentDate,
    this.paymentId,
    this.paymentType,
  });

  factory PaidDetail.fromJson(Map<String, dynamic> json) => PaidDetail(
        paidAmount: json["paidAmount"],
        paymentDate: json["paymentDate"] == null
            ? null
            : DateTime.parse(json["paymentDate"]),
        paymentId: json["paymentId"],
        paymentType: json["paymentType"],
      );

  Map<String, dynamic> toJson() => {
        "paidAmount": paidAmount,
        "paymentDate":
            "${paymentDate!.year.toString().padLeft(4, '0')}-${paymentDate!.month.toString().padLeft(2, '0')}-${paymentDate!.day.toString().padLeft(2, '0')}",
        "paymentId": paymentId,
        "paymentType": paymentType,
      };
}
