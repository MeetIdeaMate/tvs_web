import 'dart:convert';

GetAllStocksWithoutPaginationModel getAllStocksWithoutPaginationModelFromJson(
        String str) =>
    GetAllStocksWithoutPaginationModel.fromJson(json.decode(str));

String getAllStocksWithoutPaginationModelToJson(
        GetAllStocksWithoutPaginationModel data) =>
    json.encode(data.toJson());

class GetAllStocksWithoutPaginationModel {
  String? stockId;
  String? partNo;
  String? itemName;
  String? categoryId;
  String? categoryName;
  MainSpecValue? mainSpecValue;
  dynamic specificationsValue;
  int? quantity;
  PurchaseItem? purchaseItem;
  String? branchId;
  String? branchName;
  dynamic hsnSacCode;
  String? stockStatus;
  int? selectedQuantity = 1;

  GetAllStocksWithoutPaginationModel(
      {this.stockId,
      this.partNo,
      this.itemName,
      this.categoryId,
      this.categoryName,
      this.mainSpecValue,
      this.specificationsValue,
      this.quantity,
      this.purchaseItem,
      this.branchId,
      this.branchName,
      this.hsnSacCode,
      this.stockStatus,
      this.selectedQuantity});

  factory GetAllStocksWithoutPaginationModel.fromJson(
          Map<String, dynamic> json) =>
      GetAllStocksWithoutPaginationModel(
        stockId: json["stockId"],
        partNo: json["partNo"],
        itemName: json["itemName"],
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        mainSpecValue: json["mainSpecValue"] == null
            ? null
            : MainSpecValue.fromJson(json["mainSpecValue"]),
        specificationsValue: json["specificationsValue"],
        quantity: json["quantity"],
        purchaseItem: json["purchaseItem"] == null
            ? null
            : PurchaseItem.fromJson(json["purchaseItem"]),
        branchId: json["branchId"],
        branchName: json["branchName"],
        hsnSacCode: json["hsnSacCode"],
        stockStatus: json["stockStatus"],
        selectedQuantity: json["selectedQuantity"] ?? 1,
      );

  Map<String, dynamic> toJson() => {
        "stockId": stockId,
        "partNo": partNo,
        "itemName": itemName,
        "categoryId": categoryId,
        "categoryName": categoryName,
        "mainSpecValue": mainSpecValue,
        "specificationsValue": specificationsValue,
        "quantity": quantity,
        "purchaseItem": purchaseItem?.toJson(),
        "branchId": branchId,
        "branchName": branchName,
        "hsnSacCode": hsnSacCode,
        "stockStatus": stockStatus,
        "selectedQuantity": selectedQuantity,
      };
}

class PurchaseItem {
  double? unitRate;
  double? value;
  double? discount;
  double? taxableValue;
  List<GstDetail>? gstDetails;
  List<dynamic>? taxes;
  List<dynamic>? incentives;
  double? invoiceValue;
  double? finalInvoiceValue;

  PurchaseItem({
    this.unitRate,
    this.value,
    this.discount,
    this.taxableValue,
    this.gstDetails,
    this.taxes,
    this.incentives,
    this.invoiceValue,
    this.finalInvoiceValue,
  });

  factory PurchaseItem.fromJson(Map<String, dynamic> json) => PurchaseItem(
        unitRate: json["unitRate"],
        value: json["value"],
        discount: json["discount"],
        taxableValue: json["taxableValue"],
        gstDetails: json["gstDetails"] == null
            ? []
            : List<GstDetail>.from(
                json["gstDetails"]!.map((x) => GstDetail.fromJson(x))),
        taxes: json["taxes"] == null
            ? []
            : List<dynamic>.from(json["taxes"]!.map((x) => x)),
        incentives: json["incentives"] == null
            ? []
            : List<dynamic>.from(json["incentives"]!.map((x) => x)),
        invoiceValue: json["invoiceValue"],
        finalInvoiceValue: json["finalInvoiceValue"],
      );

  Map<String, dynamic> toJson() => {
        "unitRate": unitRate,
        "value": value,
        "discount": discount,
        "taxableValue": taxableValue,
        "gstDetails": gstDetails == null
            ? []
            : List<dynamic>.from(gstDetails!.map((x) => x.toJson())),
        "taxes": taxes == null ? [] : List<dynamic>.from(taxes!.map((x) => x)),
        "incentives": incentives == null
            ? []
            : List<dynamic>.from(incentives!.map((x) => x)),
        "invoiceValue": invoiceValue,
        "finalInvoiceValue": finalInvoiceValue,
      };
}

class GstDetail {
  String? gstName;
  double? percentage;
  double? gstAmount;

  GstDetail({
    this.gstName,
    this.percentage,
    this.gstAmount,
  });

  factory GstDetail.fromJson(Map<String, dynamic> json) => GstDetail(
        gstName: json["gstName"],
        percentage: json["percentage"],
        gstAmount: json["gstAmount"],
      );

  Map<String, dynamic> toJson() => {
        "gstName": gstName,
        "percentage": percentage,
        "gstAmount": gstAmount,
      };
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
