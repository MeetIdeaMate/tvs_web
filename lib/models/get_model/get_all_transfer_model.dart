// To parse this JSON data, do
//
//     final getAllTransferModel = getAllTransferModelFromJson(jsonString);

import 'dart:convert';

List<GetAllTransferModel> getAllTransferModelFromJson(String str) =>
    List<GetAllTransferModel>.from(
        json.decode(str).map((x) => GetAllTransferModel.fromJson(x)));

String getAllTransferModelToJson(List<GetAllTransferModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllTransferModel {
  String? transferId;
  String? fromBranchId;
  String? fromBranchName;
  String? toBranchId;
  String? toBranchName;
  List<TransferItem>? transferItems;
  int? totalQuantity;
  DateTime? transferDate;
  dynamic receivedDate;
  dynamic transferStatus;

  GetAllTransferModel({
    this.transferId,
    this.fromBranchId,
    this.fromBranchName,
    this.toBranchId,
    this.toBranchName,
    this.transferItems,
    this.totalQuantity,
    this.transferDate,
    this.receivedDate,
    this.transferStatus,
  });

  factory GetAllTransferModel.fromJson(Map<String, dynamic> json) =>
      GetAllTransferModel(
        transferId: json["transferId"],
        fromBranchId: json["fromBranchId"],
        fromBranchName: json["fromBranchName"],
        toBranchId: json["toBranchId"],
        toBranchName: json["toBranchName"],
        transferItems: json["transferItems"] == null
            ? []
            : List<TransferItem>.from(
                json["transferItems"]!.map((x) => TransferItem.fromJson(x))),
        totalQuantity: json["totalQuantity"],
        transferDate: json["transferDate"] == null
            ? null
            : DateTime.parse(json["transferDate"]),
        receivedDate: json["receivedDate"],
        transferStatus: json["transferStatus"],
      );

  Map<String, dynamic> toJson() => {
        "transferId": transferId,
        "fromBranchId": fromBranchId,
        "fromBranchName": fromBranchName,
        "toBranchId": toBranchId,
        "toBranchName": toBranchName,
        "transferItems": transferItems == null
            ? []
            : List<dynamic>.from(transferItems!.map((x) => x.toJson())),
        "totalQuantity": totalQuantity,
        "transferDate": transferDate?.toIso8601String(),
        "receivedDate": receivedDate,
        "transferStatus": transferStatus,
      };
}

class TransferItem {
  String? partNo;
  String? itemName;
  String? categoryId;
  String? categoryName;
  MainSpecValue? mainSpecValue;
  int? quantity;

  TransferItem({
    this.partNo,
    this.itemName,
    this.categoryId,
    this.categoryName,
    this.mainSpecValue,
    this.quantity,
  });

  factory TransferItem.fromJson(Map<String, dynamic> json) => TransferItem(
        partNo: json["partNo"],
        itemName: json["itemName"],
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        mainSpecValue: json["mainSpecValue"] == null
            ? null
            : MainSpecValue.fromJson(json["mainSpecValue"]),
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "partNo": partNo,
        "itemName": itemName,
        "categoryId": categoryId,
        "categoryName": categoryName,
        "mainSpecValue": mainSpecValue?.toJson(),
        "quantity": quantity,
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
