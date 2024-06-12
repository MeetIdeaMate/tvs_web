import 'dart:convert';

List<GetAllStocksWithoutPaginationModel>
    getAllStocksWithoutPaginationModelFromJson(String str) =>
        List<GetAllStocksWithoutPaginationModel>.from(json
            .decode(str)
            .map((x) => GetAllStocksWithoutPaginationModel.fromJson(x)));

String getAllStocksWithoutPaginationModelToJson(
        List<GetAllStocksWithoutPaginationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllStocksWithoutPaginationModel {
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

  GetAllStocksWithoutPaginationModel({
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

  factory GetAllStocksWithoutPaginationModel.fromJson(
          Map<String, dynamic> json) =>
      GetAllStocksWithoutPaginationModel(
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
