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
  String? partNo;
  int? quantity;
  String? stockId;

  TransferItem({
    this.partNo,
    this.quantity,
    this.stockId,
  });

  factory TransferItem.fromJson(Map<String, dynamic> json) => TransferItem(
        partNo: json["partNo"],
        quantity: json["quantity"],
        stockId: json["stockId"],
      );

  Map<String, dynamic> toJson() => {
        "partNo": partNo,
        "quantity": quantity,
        "stockId": stockId,
      };
}
