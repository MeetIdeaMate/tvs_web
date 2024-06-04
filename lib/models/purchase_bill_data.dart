class PurchaseBillData {
  String? vendorName;
  String? invoiceNo;
  String? invoiceDate;
  String? purchaseRef;
  String? gstType;
  String? carrierName;
  String? carrierNumber;
  List<VehicleDetails>? vehicleDetails;

  PurchaseBillData({
    this.vendorName,
    this.invoiceNo,
    this.invoiceDate,
    this.purchaseRef,
    this.gstType,
    this.carrierName,
    this.carrierNumber,
    this.vehicleDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      "vendorName": vendorName,
      "invoiceDate": invoiceDate,
      "purchaseref": purchaseRef,
      "gstType": gstType,
      "carrierName": carrierName,
      "carrierNumber": carrierNumber,
      "invoiceNo": invoiceNo,
      "vehicleDetails": vehicleDetails?.map((v) => v.toJson()).toList(),
    };
  }
}

class VehicleDetails {
  int partNo;
  String vehicleName;
  String varient;
  String color;
  int hsnCode;
  int unitRate;
  List<EngineDetails> engineDetails;

  VehicleDetails({
    required this.partNo,
    required this.vehicleName,
    required this.varient,
    required this.color,
    required this.hsnCode,
    required this.unitRate,
    required this.engineDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      "partNo": partNo,
      "vehicleName": vehicleName,
      "varient": varient,
      "color": color,
      "hsnCode": hsnCode,
      "unitRate": unitRate,
      "engineDetails": engineDetails.map((e) => e.toJson()).toList(),
    };
  }
}

class EngineDetails {
  int engineNo;
  int frameNo;

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
