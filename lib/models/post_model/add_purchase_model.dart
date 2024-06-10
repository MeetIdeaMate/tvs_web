class AddPurchaseModel {
  String branchId;
  List<ItemDetail> itemDetails;
  String pInvoiceDate;
  String pInvoiceNo;
  String pOrderRefNo;
  int totalQty;
  String vendorId;

  AddPurchaseModel({
    required this.branchId,
    required this.itemDetails,
    required this.pInvoiceDate,
    required this.pInvoiceNo,
    required this.pOrderRefNo,
    required this.totalQty,
    required this.vendorId,
  });

  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId,
      'itemDetails': itemDetails.map((i) => i.toJson()).toList(),
      'p_invoiceDate': pInvoiceDate,
      'p_invoiceNo': pInvoiceNo,
      'p_orderRefNo': pOrderRefNo,
      'totalQty': totalQty,
      'vendorId': vendorId,
    };
  }
}

class ItemDetail {
  String categoryId;
  double discount;
  List<GstDetail> gstDetails;
  List<Incentive> incentives;
  String itemName;
  List<Map<String, dynamic>> mainSpecInfos;
  String partNo;
  int quantity;
  SpecificationsValue specificationsValue;
  List<Tax> taxes;
  double unitRate;

  ItemDetail({
    required this.categoryId,
    required this.discount,
    required this.gstDetails,
    required this.incentives,
    required this.itemName,
    required this.mainSpecInfos,
    required this.partNo,
    required this.quantity,
    required this.specificationsValue,
    required this.taxes,
    required this.unitRate,
  });

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'discount': discount,
      'gstDetails': gstDetails.map((i) => i.toJson()).toList(),
      'incentives': incentives.map((i) => i.toJson()).toList(),
      'itemName': itemName,
      'mainSpecInfos': mainSpecInfos,
      'partNo': partNo,
      'quantity': quantity,
      'specificationsValue': specificationsValue.toJson(),
      'taxes': taxes.map((i) => i.toJson()).toList(),
      'unitRate': unitRate,
    };
  }
}

class GstDetail {
  double gstAmount;
  String gstName;
  double percentage;

  GstDetail({
    required this.gstAmount,
    required this.gstName,
    required this.percentage,
  });

  Map<String, dynamic> toJson() {
    return {
      'gstAmount': gstAmount,
      'gstName': gstName,
      'percentage': percentage,
    };
  }
}

class Incentive {
  double incentiveAmount;
  String incentiveName;
  double percentage;

  Incentive({
    required this.incentiveAmount,
    required this.incentiveName,
    required this.percentage,
  });

  Map<String, dynamic> toJson() {
    return {
      'incentiveAmount': incentiveAmount,
      'incentiveName': incentiveName,
      'percentage': percentage,
    };
  }
}

class MainSpecInfo {
  Map<String, dynamic> mainSpecValue;

  MainSpecInfo({required this.mainSpecValue});

  Map<String, dynamic> toJson() {
    return {
      'mainSpecValue': mainSpecValue,
    };
  }
}

class SpecificationsValue {
  Map<String, dynamic> specs;

  SpecificationsValue({required this.specs});

  Map<String, dynamic> toJson() {
    return specs;
  }
}

class Tax {
  double percentage;
  double taxAmount;
  String taxName;

  Tax({
    required this.percentage,
    required this.taxAmount,
    required this.taxName,
  });

  Map<String, dynamic> toJson() {
    return {
      'percentage': percentage,
      'taxAmount': taxAmount,
      'taxName': taxName,
    };
  }
}
