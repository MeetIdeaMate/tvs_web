class GetAllStockDetails {
  String? branchId;
  String? branchName;
  String? categoryId;
  String? categoryName;
  String? hsnSacCode;
  String? itemName;
  MainSpecValue? mainSpecValue;
  String? partNo;
  PurchaseItem? purchaseItem;
  int? quantity;
  Value? specificationsValue;
  String? stockId;
  String? stockStatus;
 AddOns? addOns;

  GetAllStockDetails(
      {this.branchId,
      this.branchName,
      this.categoryId,
      this.categoryName,
      this.hsnSacCode,
      this.itemName,
      this.mainSpecValue,
      this.partNo,
      this.purchaseItem,
      this.quantity,
      this.specificationsValue,
      this.stockId,
      this.stockStatus,
      this.addOns});

  factory GetAllStockDetails.fromJson(Map<String, dynamic> json) =>
      GetAllStockDetails(
          branchId: json["branchId"],
          branchName: json["branchName"],
          categoryId: json["categoryId"],
          categoryName: json["categoryName"],
          hsnSacCode: json["hsnSacCode"],
          itemName: json["itemName"],
          mainSpecValue: json["mainSpecValue"] == null
              ? null
              : MainSpecValue.fromJson(json["mainSpecValue"]),
          partNo: json["partNo"],
          purchaseItem: json["purchaseItem"] == null
              ? null
              : PurchaseItem.fromJson(json["purchaseItem"]),
          quantity: json["quantity"],
          specificationsValue: json["specificationsValue"] == null
              ? null
              : Value.fromJson(json["specificationsValue"]),
          stockId: json["stockId"],
          stockStatus: json["stockStatus"],
          addOns: json["addOns"] == null ? null : AddOns.fromJson(json["addOns"]));

  Map<String, dynamic> toJson() => {
        "branchId": branchId,
        "branchName": branchName,
        "categoryId": categoryId,
        "categoryName": categoryName,
        "hsnSacCode": hsnSacCode,
        "itemName": itemName,
        "mainSpecValue": mainSpecValue?.toJson(),
        "partNo": partNo,
        "purchaseItem": purchaseItem?.toJson(),
        "quantity": quantity,
        "specificationsValue": specificationsValue?.toJson(),
        "stockId": stockId,
        "stockStatus": stockStatus,
         "addOns": addOns?.toJson(),
      };
}
class AddOns {
  Map<String, double>? addOnsMap;

  AddOns({this.addOnsMap});

  factory AddOns.fromJson(Map<String, dynamic> json) {
    // Dynamically map each key-value pair from the JSON object into a Dart map
    Map<String, double> map = {};
    json.forEach((key, value) {
      map[key] = value.toDouble();
    });
    return AddOns(addOnsMap: map);
  }

  Map<String, dynamic> toJson() {
    return addOnsMap != null ? Map.from(addOnsMap!) : {};
  }
}



class Value {
  Value();

  factory Value.fromJson(Map<String, dynamic> json) => Value();

  Map<String, dynamic> toJson() => {};
}

class MainSpecValue {
  String? frameNo;
  String? engineNo;

  MainSpecValue({
    this.frameNo,
    this.engineNo,
  });

  factory MainSpecValue.fromJson(Map<String, dynamic> json) => MainSpecValue(
        frameNo: json["frameNo"],
        engineNo: json["engineNo"],
      );

  Map<String, dynamic> toJson() => {
        "frameNo": frameNo,
        "engineNo": engineNo,
      };
}

class PurchaseItem {
  double? discount;
  double? finalInvoiceValue;
  List<GstDetail>? gstDetails;
  List<Incentive>? incentives;
  double? invoiceValue;
  double? taxableValue;
  List<Tax>? taxes;
  double? unitRate;
  double? value;

  PurchaseItem({
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

  factory PurchaseItem.fromJson(Map<String, dynamic> json) => PurchaseItem(
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
