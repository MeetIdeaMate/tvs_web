import 'dart:convert';

AddNewTransfer addNewTransferFromJson(String str) =>
    AddNewTransfer.fromJson(json.decode(str));

String addNewTransferToJson(AddNewTransfer data) => json.encode(data.toJson());

class AddNewTransfer {
  String? transferFromBranch;
  List<TransferItem>? transferItems;
  String? transferToBranch;

  AddNewTransfer({
    this.transferFromBranch,
    this.transferItems,
    this.transferToBranch,
  });

  factory AddNewTransfer.fromJson(Map<String, dynamic> json) => AddNewTransfer(
        transferFromBranch: json["transferFromBranch"],
        transferItems: json["transferItems"] == null
            ? []
            : List<TransferItem>.from(
                json["transferItems"]!.map((x) => TransferItem.fromJson(x))),
        transferToBranch: json["transferToBranch"],
      );

  Map<String, dynamic> toJson() => {
        "transferFromBranch": transferFromBranch,
        "transferItems": transferItems == null
            ? []
            : List<dynamic>.from(transferItems!.map((x) => x.toJson())),
        "transferToBranch": transferToBranch,
      };
}

class TransferItem {
  String? categoryId;
  AddNewTransferMainSpecValue? addNewTransferMainSpecValue;
  String? partNo;
  int? quantity;

  TransferItem({
    this.categoryId,
    this.addNewTransferMainSpecValue,
    this.partNo,
    this.quantity,
  });

  factory TransferItem.fromJson(Map<String, dynamic> json) => TransferItem(
        categoryId: json["categoryId"],
        addNewTransferMainSpecValue: json["mainSpecValue"] == null
            ? null
            : AddNewTransferMainSpecValue.fromJson(json["mainSpecValue"]),
        partNo: json["partNo"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "mainSpecValue": addNewTransferMainSpecValue?.toJson(),
        "partNo": partNo,
        "quantity": quantity,
      };
}

class AddNewTransferMainSpecValue {
  String? frameNo;
  String? engineNo;

  AddNewTransferMainSpecValue({
    this.frameNo,
    this.engineNo,
  });

  factory AddNewTransferMainSpecValue.fromJson(Map<String, dynamic> json) => AddNewTransferMainSpecValue(
    frameNo: json["FrameNo"],
    engineNo: json["EngineNo"],
  );

  Map<String, dynamic> toJson() => {
    "FrameNo": frameNo,
    "EngineNo": engineNo,
  };
}
