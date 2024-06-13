class GetAllStockDetails {
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

  GetAllStockDetails({
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

  factory GetAllStockDetails.fromJson(Map<String, dynamic> json) =>
      GetAllStockDetails(
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
        frameNo: json["frameNo"],
        engineNo: json["engineNo"],
      );

  Map<String, dynamic> toJson() => {
        "frameNo": frameNo,
        "engineNo": engineNo,
      };
}
