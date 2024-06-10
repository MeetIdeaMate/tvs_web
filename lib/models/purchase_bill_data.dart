class PurchaseBillData {
  List<VehicleDetails>? vehicleDetails;

  PurchaseBillData({
    this.vehicleDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      "vehicleDetails": vehicleDetails?.map((v) => v.toJson()).toList(),
    };
  }
}

class VehicleDetails {
  int partNo;
  String? categoryId;
  String vehicleName;
  int hsnCode;
  double unitRate;
  double? totalValue;
  double? taxableValue;
  int qty;
  String? gstType;
  double? cgstPercentage;
  double? cgstAmount;
  double? sgstPercentage;
  double? sgstAmount;
  double? igstPercentage;
  double? igstAmount;
  double? empsIncentive;
  String? incentiveType;
  double? stateIncentive;
  double? tcsValue;
  double? invoiceValue;
  double? discountValue;
  double? discountPresentage;
  double? totalInvoiceValue;
  List<EngineDetails> engineDetails;

  VehicleDetails({
    required this.partNo,
    required this.vehicleName,
    required this.hsnCode,
    required this.unitRate,
    required this.qty,
    this.totalValue,
    this.taxableValue,
    this.gstType,
    this.cgstPercentage,
    this.cgstAmount,
    this.sgstPercentage,
    this.sgstAmount,
    this.igstPercentage,
    this.igstAmount,
    this.incentiveType,
    this.empsIncentive,
    this.discountPresentage,
    this.stateIncentive,
    this.tcsValue,
    this.invoiceValue,
    this.discountValue,
    this.totalInvoiceValue,
    required this.engineDetails,
    this.categoryId
  });

  Map<String, dynamic> toJson() {
    return {
      "partNo": partNo,
      "vehicleName": vehicleName,
      "hsnCode": hsnCode,
      "unitRate": unitRate,
      "totalValue": totalValue,
      "taxableValue": taxableValue,
      "qty": qty,
      "gstType": gstType,
      "cgstPercentage": cgstPercentage ,
      "cgstAmount": cgstAmount,
      "sgstPercentage": sgstPercentage,
      "sgstAmount": sgstAmount,
      "igstPercentage": igstPercentage,
      "igstAmount": igstAmount,
      "incentiveType": incentiveType,
      "empsIncentive": empsIncentive,
      "categoryId": categoryId,
      "stateIncentive": stateIncentive,
      "tcsValue": tcsValue,
      "invoiceValue": invoiceValue,
      "discountValue": discountValue ?? 0.0,
      "discountPresentage": discountPresentage ?? 0.0,
      "totalInvoiceValue": totalInvoiceValue,
      "engineDetails": engineDetails.map((e) => e.toJson()).toList(),
    };
  }
}

class EngineDetails {
  String engineNo;
  String frameNo;

  EngineDetails({
    required this.engineNo,
    required this.frameNo,
  });

  Map<String, dynamic> toJson() {
    return {
      "engineNo": engineNo,
      "frameNo": frameNo,
    };
  }
}
