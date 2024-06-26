import 'dart:convert';
import 'dart:core';

class EvBatteryObj {
  double evBatteryCapacity;
  String evBatteryName;

  EvBatteryObj({
    required this.evBatteryCapacity,
    required this.evBatteryName,
  });

  Map<String, dynamic> toJson() => {
        'evBatteryCapacity': evBatteryCapacity,
        'evBatteryName': evBatteryName,
      };
}

class InsuranceObj {
  String expiryDate;
  String insuranceCompanyName;
  String insuranceId;
  double insuredAmt;
  String insuredDate;
  String invoiceNo;

  InsuranceObj({
    required this.expiryDate,
    required this.insuranceCompanyName,
    required this.insuranceId,
    required this.insuredAmt,
    required this.insuredDate,
    required this.invoiceNo,
  });

  Map<String, dynamic> toJson() => {
        'expiryDate': expiryDate,
        'insuranceCompanyName': insuranceCompanyName,
        'insuranceId': insuranceId,
        'insuredAmt': insuredAmt,
        'insuredDate': insuredDate,
        'invoiceNo': invoiceNo,
      };
}

class GstDetail {
  double gstAmount;
  String gstName;
  double percentage;

  GstDetail({
    required this.gstAmount,
    required this.gstName,
    required this.percentage,
  });

  Map<String, dynamic> toJson() => {
        'gstAmount': gstAmount,
        'gstName': gstName,
        'percentage': percentage,
      };
}

class Incentive {
  double incentiveAmount;
  String incentiveName;
  double percentage;

  Incentive({
    required this.incentiveAmount,
    required this.incentiveName,
    required this.percentage,
  });

  Map<String, dynamic> toJson() => {
        'incentiveAmount': incentiveAmount,
        'incentiveName': incentiveName,
        'percentage': percentage,
      };
}

class SalesItemDetail {
  String categoryId;
  double discount;
  double finalInvoiceValue;
  List<GstDetail> gstDetails;
  String hsnSacCode;
  List<Incentive> incentives;
  double invoiceValue;
  String itemName;
  Map<String, String> mainSpecValue;
  String partNo;
  int quantity;
  Map<String, String> specificationsValue;
  String stockId;
  double taxableValue;
  List<Tax> taxes;
  double unitRate;
  double value;

  SalesItemDetail({
    required this.categoryId,
    required this.discount,
    required this.finalInvoiceValue,
    required this.gstDetails,
    required this.hsnSacCode,
    required this.incentives,
    required this.invoiceValue,
    required this.itemName,
    required this.mainSpecValue,
    required this.partNo,
    required this.quantity,
    required this.specificationsValue,
    required this.stockId,
    required this.taxableValue,
    required this.taxes,
    required this.unitRate,
    required this.value,
  });

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'discount': discount,
        'finalInvoiceValue': finalInvoiceValue,
        'gstDetails': gstDetails.map((x) => x.toJson()).toList(),
        'hsnSacCode': hsnSacCode,
        'incentives': incentives.map((x) => x.toJson()).toList(),
        'invoiceValue': invoiceValue,
        'itemName': itemName,
        'mainSpecValue': mainSpecValue,
        'partNo': partNo,
        'quantity': quantity,
        'specificationsValue': specificationsValue,
        'stockId': stockId,
        'taxableValue': taxableValue,
        'taxes': taxes.map((x) => x.toJson()).toList(),
        'unitRate': unitRate,
        'value': value,
      };
}

class Tax {
  double percentage;
  double taxAmount;
  String taxName;

  Tax({
    required this.percentage,
    required this.taxAmount,
    required this.taxName,
  });

  Map<String, dynamic> toJson() => {
        'percentage': percentage,
        'taxAmount': taxAmount,
        'taxName': taxName,
      };
}

class Loaninfo {
  String bankName;
  double loanAmt;
  String loanId;

  Loaninfo({
    required this.bankName,
    required this.loanAmt,
    required this.loanId,
  });

  Map<String, dynamic> toJson() => {
        'bankName': bankName,
        'loanAmt': loanAmt,
        'loanId': loanId,
      };
}

class PaidDetail {
  double paidAmount;
  String paymentDate;
  String paymentId;
  String paymentType;

  PaidDetail({
    required this.paidAmount,
    required this.paymentDate,
    required this.paymentId,
    required this.paymentType,
  });

  Map<String, dynamic> toJson() => {
        'paidAmount': paidAmount,
        'paymentDate': paymentDate,
        'paymentId': paymentId,
        'paymentType': paymentType,
      };
}

class AddSalesModel {
  String billType;
  String bookingNo;
  String branchId;
  String customerId;
  EvBatteryObj evBattery;
  InsuranceObj insurance;
  String invoiceDate;
  String invoiceType;
  List<SalesItemDetail> itemDetails;
  Loaninfo loaninfo;
  Map<String, String> mandatoryAddons;
  int netAmt;
  List<PaidDetail> paidDetails;
  String paymentStatus;
  double roundOffAmt;
  int totalQty;

  AddSalesModel({
    required this.billType,
    required this.bookingNo,
    required this.branchId,
    required this.customerId,
    required this.evBattery,
    required this.insurance,
    required this.invoiceDate,
    required this.invoiceType,
    required this.itemDetails,
    required this.loaninfo,
    required this.mandatoryAddons,
    required this.netAmt,
    required this.paidDetails,
    required this.paymentStatus,
    required this.roundOffAmt,
    required this.totalQty,
  });

  Map<String, dynamic> toJson() => {
        'billType': billType,
        'bookingNo': bookingNo,
        'branchId': branchId,
        'customerId': customerId,
        'evBattery': evBattery.toJson(),
        'insurance': insurance.toJson(),
        'invoiceDate': invoiceDate,
        'invoiceType': invoiceType,
        'itemDetails': itemDetails.map((x) => x.toJson()).toList(),
        'loaninfo': loaninfo.toJson(),
        'mandatoryAddons': mandatoryAddons,
        'netAmt': netAmt,
        'paidDetails': paidDetails.map((x) => x.toJson()).toList(),
        'paymentStatus': paymentStatus,
        'roundOffAmt': roundOffAmt,
        'totalQty': totalQty,
      };

  String toJsonString() => jsonEncode(toJson());
}
