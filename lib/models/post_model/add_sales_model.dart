class AddSalesModel {
  String billType;
  String branchId;
  String customerId;
  Insurance insurance;
  String invoiceDate;
  String invoiceType;
  List<ItemDetails> itemDetails;
  LoanInfo loanInfo;
  double netAmt;
  List<PaidDetails> paidDetails;
  String paymentStatus;
  double roundOffAmt;
  double totalCgst;
  double totalDisc;
  double totalInvoiceAmt;
  int totalQty;
  double totalSgst;
  double totalTaxableAmt;

  AddSalesModel({
    required this.billType,
    required this.branchId,
    required this.customerId,
    required this.insurance,
    required this.invoiceDate,
    required this.invoiceType,
    required this.itemDetails,
    required this.loanInfo,
    required this.netAmt,
    required this.paidDetails,
    required this.paymentStatus,
    required this.roundOffAmt,
    required this.totalCgst,
    required this.totalDisc,
    required this.totalInvoiceAmt,
    required this.totalQty,
    required this.totalSgst,
    required this.totalTaxableAmt,
  });

  Map<String, dynamic> toJson() {
    return {
      'billType': billType,
      'branchId': branchId,
      'customerId': customerId,
      'insurance': insurance.toJson(),
      'invoiceDate': invoiceDate,
      'invoiceType': invoiceType,
      'itemDetails': itemDetails.map((item) => item.toJson()).toList(),
      'loanInfo': loanInfo.toJson(),
      'netAmt': netAmt,
      'paidDetails': paidDetails.map((paid) => paid.toJson()).toList(),
      'paymentStatus': paymentStatus,
      'roundOffAmt': roundOffAmt,
      'totalCgst': totalCgst,
      'totalDisc': totalDisc,
      'totalInvoiceAmt': totalInvoiceAmt,
      'totalQty': totalQty,
      'totalSgst': totalSgst,
      'totalTaxableAmt': totalTaxableAmt,
    };
  }
}

class Insurance {
  String expiryDate;
  String insuranceCompanyName;
  String insuranceId;
  double insuredAmt;
  String insuredDate;
  String invoiceNo;

  Insurance({
    required this.expiryDate,
    required this.insuranceCompanyName,
    required this.insuranceId,
    required this.insuredAmt,
    required this.insuredDate,
    required this.invoiceNo,
  });

  Map<String, dynamic> toJson() {
    return {
      'expiryDate': expiryDate,
      'insuranceCompanyName': insuranceCompanyName,
      'insuranceId': insuranceId,
      'insuredAmt': insuredAmt,
      'insuredDate': insuredDate,
      'invoiceNo': invoiceNo,
    };
  }
}

class ItemDetails {
  String categoryId;
  double discount;
  double finalInvoiceValue;
  List<GstDetails> gstDetails;
  List<Incentives> incentives;
  double invoiceValue;
  MainSpecValue mainSpecValue;
  String partNo;
  int quantity;
  SpecificationsValue specificationsValue;
  double taxableValue;
  List<Taxes> taxes;
  double unitRate;
  double value;

  ItemDetails({
    required this.categoryId,
    required this.discount,
    required this.finalInvoiceValue,
    required this.gstDetails,
    required this.incentives,
    required this.invoiceValue,
    required this.mainSpecValue,
    required this.partNo,
    required this.quantity,
    required this.specificationsValue,
    required this.taxableValue,
    required this.taxes,
    required this.unitRate,
    required this.value,
  });

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'discount': discount,
      'finalInvoiceValue': finalInvoiceValue,
      'gstDetails': gstDetails.map((gst) => gst.toJson()).toList(),
      'incentives': incentives.map((incentive) => incentive.toJson()).toList(),
      'invoiceValue': invoiceValue,
      'mainSpecValue': mainSpecValue.toJson(),
      'partNo': partNo,
      'quantity': quantity,
      'specificationsValue': specificationsValue.toJson(),
      'taxableValue': taxableValue,
      'taxes': taxes.map((tax) => tax.toJson()).toList(),
      'unitRate': unitRate,
      'value': value,
    };
  }
}

class MainSpecValue {
  String additionalProp1;
  String additionalProp2;
  String additionalProp3;

  MainSpecValue({
    required this.additionalProp1,
    required this.additionalProp2,
    required this.additionalProp3,
  });

  Map<String, dynamic> toJson() {
    return {
      'additionalProp1': additionalProp1,
      'additionalProp2': additionalProp2,
      'additionalProp3': additionalProp3,
    };
  }
}

class GstDetails {
  double gstAmount;
  String gstName;
  double percentage;

  GstDetails({
    required this.gstAmount,
    required this.gstName,
    required this.percentage,
  });

  Map<String, dynamic> toJson() {
    return {
      'gstAmount': gstAmount,
      'gstName': gstName,
      'percentage': percentage,
    };
  }
}

class Incentives {
  double incentiveAmount;
  String incentiveName;
  double percentage;

  Incentives({
    required this.incentiveAmount,
    required this.incentiveName,
    required this.percentage,
  });

  Map<String, dynamic> toJson() {
    return {
      'incentiveAmount': incentiveAmount,
      'incentiveName': incentiveName,
      'percentage': percentage,
    };
  }
}

class SpecificationsValue {
  String additionalProp1;
  String additionalProp2;
  String additionalProp3;

  SpecificationsValue({
    required this.additionalProp1,
    required this.additionalProp2,
    required this.additionalProp3,
  });

  Map<String, dynamic> toJson() {
    return {
      'additionalProp1': additionalProp1,
      'additionalProp2': additionalProp2,
      'additionalProp3': additionalProp3,
    };
  }
}

class Taxes {
  double percentage;
  double taxAmount;
  String taxName;

  Taxes({
    required this.percentage,
    required this.taxAmount,
    required this.taxName,
  });

  Map<String, dynamic> toJson() {
    return {
      'percentage': percentage,
      'taxAmount': taxAmount,
      'taxName': taxName,
    };
  }
}

class PaidDetails {
  String paidAmount;
  String paymentDate;
  String paymentId;
  String paymentType;

  PaidDetails({
    required this.paidAmount,
    required this.paymentDate,
    required this.paymentId,
    required this.paymentType,
  });

  Map<String, dynamic> toJson() {
    return {
      'paidAmount': paidAmount,
      'paymentDate': paymentDate,
      'paymentId': paymentId,
      'paymentType': paymentType,
    };
  }
}

class LoanInfo {
  String bankName;
  double loanAmt;
  String loanId;

  LoanInfo({
    required this.bankName,
    required this.loanAmt,
    required this.loanId,
  });

  Map<String, dynamic> toJson() {
    return {
      'bankName': bankName,
      'loanAmt': loanAmt,
      'loanId': loanId,
    };
  }
}
