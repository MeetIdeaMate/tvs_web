import 'dart:convert';

GetAllStockDetails getAllStockDetailsFromJson(String str) =>
    GetAllStockDetails.fromJson(json.decode(str));

String getAllStockDetailsToJson(GetAllStockDetails data) =>
    json.encode(data.toJson());

class GetAllStockDetails {
  List<Stock>? stocks;

  GetAllStockDetails({
    this.stocks,
  });

  factory GetAllStockDetails.fromJson(Map<String, dynamic> json) =>
      GetAllStockDetails(
        stocks: json["Stocks"] == null
            ? []
            : List<Stock>.from(json["Stocks"]!.map((x) => Stock.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Stocks": stocks == null
            ? []
            : List<dynamic>.from(stocks!.map((x) => x.toJson())),
      };
}

class Stock {
  String? partNo;
  String? itemName;
  String? categoryId;
  String? categoryName;
  MainSpecValue? mainSpecValue;
  dynamic specificationsValue;
  int? quantity;
  String? branchId;
  String? branchName;
  String? hsnSacCode;

  Stock({
    this.partNo,
    this.itemName,
    this.categoryId,
    this.categoryName,
    this.mainSpecValue,
    this.specificationsValue,
    this.quantity,
    this.branchId,
    this.branchName,
    this.hsnSacCode,
  });

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
        partNo: json["partNo"],
        itemName: json["itemName"],
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        mainSpecValue: json["mainSpecValue"] == null
            ? null
            : MainSpecValue.fromJson(json["mainSpecValue"]),
        specificationsValue: json["specificationsValue"],
        quantity: json["quantity"],
        branchId: json["branchId"],
        branchName: json["branchName"],
        hsnSacCode: json["hsnSacCode"],
      );

  Map<String, dynamic> toJson() => {
        "partNo": partNo,
        "itemName": itemName,
        "categoryId": categoryId,
        "categoryName": categoryName,
        "mainSpecValue": mainSpecValue?.toJson(),
        "specificationsValue": specificationsValue,
        "quantity": quantity,
        "branchId": branchId,
        "branchName": branchName,
        "hsnSacCode": hsnSacCode,
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
        frameNo: json["FrameNo"],
        engineNo: json["EngineNo"],
      );

  Map<String, dynamic> toJson() => {
        "FrameNo": frameNo,
        "EngineNo": engineNo,
      };
}
