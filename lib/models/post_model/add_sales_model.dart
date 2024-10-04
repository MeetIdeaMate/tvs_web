class EvBatteryObj {
  double? evBatteryCapacity;
  String? evBatteryName;

  EvBatteryObj({
    this.evBatteryCapacity,
    this.evBatteryName,
  });

  Map<String, dynamic> toJson() => {
        'evBatteryCapacity': evBatteryCapacity,
        'evBatteryName': evBatteryName,
      };
}

class InsuranceObj {
  final String? customerId;
  final String? insuranceCompanyName;
  final String? insuranceNo;
  final double? insuredAmt;
  final String? insuredDate;
  final String? invoiceNo;
  final String? ownDmgExpiryDate;
  final double? premiumAmt;
  final String? thirdPartyExpiryDate;
  final String? vehicleNo;

  InsuranceObj({
    this.customerId,
    this.insuranceCompanyName,
    this.insuranceNo,
    this.insuredAmt,
    this.insuredDate,
    this.invoiceNo,
    this.ownDmgExpiryDate,
    this.premiumAmt,
    this.thirdPartyExpiryDate,
    this.vehicleNo,
  });

  Map<String, dynamic> toJson() => {
        'customerId': customerId,
        'insuranceCompanyName': insuranceCompanyName,
        'insuranceNo': insuranceNo,
        'insuredAmt': insuredAmt,
        'insuredDate': insuredDate,
        'invoiceNo': invoiceNo,
        'ownDmgExpiryDate': ownDmgExpiryDate,
        'premiumAmt': premiumAmt,
        'thirdPartyExpiryDate': thirdPartyExpiryDate,
        'vehicleNo': vehicleNo,
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

  Map<String, dynamic> toJson() => {
        'gstAmount': gstAmount,
        'gstName': gstName,
        'percentage': percentage,
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

  Map<String, dynamic> toJson() => {
        'incentiveAmount': incentiveAmount,
        'incentiveName': incentiveName,
        'percentage': percentage,
      };
}

class SalesItemDetail {
  String? categoryId;
  double? discount;
  double? finalInvoiceValue;
  List<GstDetail>? gstDetails;
  String? hsnSacCode;
  List<Incentive>? incentives;
  double? invoiceValue;
  String? itemName;
  Map<String, String>? mainSpecValue;
  String? partNo;
  int? quantity;
  Map<String, String>? specificationsValue;
  String? stockId;
  double? taxableValue;
  List<Tax>? taxes;
  double? unitRate;
  double? value;
  Map<String, dynamic>? addOns;

  SalesItemDetail({
    this.categoryId,
    this.discount,
    this.finalInvoiceValue,
    this.gstDetails,
    this.hsnSacCode,
    this.incentives,
    this.invoiceValue,
    this.itemName,
    this.mainSpecValue,
    this.partNo,
    this.quantity,
    this.specificationsValue,
    this.stockId,
    this.taxableValue,
    this.taxes,
    this.unitRate,
    this.value,
    this.addOns
  });

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'discount': discount,
        'finalInvoiceValue': finalInvoiceValue,
        'gstDetails': gstDetails?.map((x) => x.toJson()).toList(),
        'hsnSacCode': hsnSacCode,
        'incentives': incentives?.map((x) => x.toJson()).toList(),
        'invoiceValue': invoiceValue,
        'itemName': itemName,
        'mainSpecValue': mainSpecValue,
        'partNo': partNo,
        'quantity': quantity,
        'specificationsValue': specificationsValue,
        'stockId': stockId,
        'taxableValue': taxableValue,
        'taxes': taxes?.map((x) => x.toJson()).toList(),
        'unitRate': unitRate,
        'value': value,
        'addOns' :addOns
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

  Map<String, dynamic> toJson() => {
        'percentage': percentage,
        'taxAmount': taxAmount,
        'taxName': taxName,
      };
}

class Loaninfo {
  String? bankName;
  double? loanAmt;
  String? loanId;

  Loaninfo({
    this.bankName,
    this.loanAmt,
    this.loanId,
  });

  Map<String, dynamic> toJson() => {
        'bankName': bankName,
        'loanAmt': loanAmt,
        'loanId': loanId,
      };
}

class PaidDetail {
  double? paidAmount;
  String? paymentDate;
  String? paymentId;
  String? paymentType;
  String? paymentReference;
  String? reason;

  PaidDetail(
      {this.paidAmount,
      this.paymentDate,
      this.paymentId,
      this.paymentType,
      this.paymentReference,
      this.reason});

  Map<String, dynamic> toJson() => {
        'paidAmount': paidAmount,
        'paymentDate': paymentDate,
        'paymentId': paymentId,
        'paymentType': paymentType,
        'paymentReference': paymentReference,
        'reason': reason
      };
}

class AddSalesModel {
  String? billType;
  String? bookingNo;
  String? branchId;
  String? customerId;
  Map<String, String>? evBattery;
  InsuranceObj? insurance;
  String? invoiceDate;
  String? invoiceType;
  List<SalesItemDetail>? itemDetails;
  Loaninfo? loaninfo;
  Map<String, String>? mandatoryAddons;
  double? netAmt;
  List<PaidDetail>? paidDetails;
  String? paymentStatus;
  double? roundOffAmt;
  int? totalQty;
  double? rtoCharges;
  double? optionFitting;
  double? others;
  double? mandatoryFitting;

  AddSalesModel(
      {this.billType,
      this.bookingNo,
      this.branchId,
      this.customerId,
      this.evBattery,
      this.insurance,
      this.invoiceDate,
      this.invoiceType,
      this.itemDetails,
      this.loaninfo,
      this.mandatoryAddons,
      this.netAmt,
      this.paidDetails,
      this.paymentStatus,
      this.roundOffAmt,
      this.totalQty,
      this.rtoCharges,
      this.mandatoryFitting,
      this.others,
      this.optionFitting});

  Map<String, dynamic> toJson() => {
        'billType': billType,
        'bookingNo': bookingNo,
        'branchId': branchId,
        'customerId': customerId,
        'evBattery': evBattery,
        'insurance': insurance?.toJson(),
        'invoiceDate': invoiceDate,
        'invoiceType': invoiceType,
        'itemDetails': itemDetails?.map((x) => x.toJson()).toList(),
        'loaninfo': loaninfo?.toJson(),
        'mandatoryAddons': mandatoryAddons,
        'netAmt': netAmt,
        'paidDetails': paidDetails?.map((x) => x.toJson()).toList(),
        'paymentStatus': paymentStatus,
        'roundOffAmt': roundOffAmt,
        'rtoCharges': rtoCharges,
        'totalQty': totalQty,
        "optionFitting": optionFitting,
        "others": others,
        "mandatoryFitting": mandatoryFitting,
      };
}
