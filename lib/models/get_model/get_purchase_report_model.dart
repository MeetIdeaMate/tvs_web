class GetAllpurchaseReport {
  List<Content>? content;
  Pageable? pageable;
  int? totalPages;
  int? totalElements;
  bool? last;
  int? size;
  int? number;
  Sort? sort;
  int? numberOfElements;
  bool? first;
  bool? empty;

  GetAllpurchaseReport({
    this.content,
    this.pageable,
    this.totalPages,
    this.totalElements,
    this.last,
    this.size,
    this.number,
    this.sort,
    this.numberOfElements,
    this.first,
    this.empty,
  });

  factory GetAllpurchaseReport.fromJson(Map<String, dynamic> json) =>
      GetAllpurchaseReport(
        content: json["content"] == null
            ? []
            : List<Content>.from(
                json["content"]!.map((x) => Content.fromJson(x))),
        pageable: json["pageable"] == null
            ? null
            : Pageable.fromJson(json["pageable"]),
        totalPages: json["totalPages"],
        totalElements: json["totalElements"],
        last: json["last"],
        size: json["size"],
        number: json["number"],
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        numberOfElements: json["numberOfElements"],
        first: json["first"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "content": content == null
            ? []
            : List<dynamic>.from(content!.map((x) => x.toJson())),
        "pageable": pageable?.toJson(),
        "totalPages": totalPages,
        "totalElements": totalElements,
        "last": last,
        "size": size,
        "number": number,
        "sort": sort?.toJson(),
        "numberOfElements": numberOfElements,
        "first": first,
        "empty": empty,
      };
}

class Content {
  String? id;
  String? purchaseId;
  String? purchaseNo;
  String? branchId;
  String? branchName;
  String? vendorId;
  String? vendorName;
  String? pInvoiceNo;
  DateTime? pInvoiceDate;
  String? pOrderRefNo;
  List<ItemDetail>? itemDetails;
  int? totalQty;
  double? totalValue;
  double? totalGstAmount;
  double? totalTaxAmount;
  double? totalIncentiveAmount;
  double? totalInvoiceAmount;
  double? finalTotalInvoiceAmount;

  Content({
    this.id,
    this.purchaseId,
    this.purchaseNo,
    this.branchId,
    this.branchName,
    this.vendorId,
    this.vendorName,
    this.pInvoiceNo,
    this.pInvoiceDate,
    this.pOrderRefNo,
    this.itemDetails,
    this.totalQty,
    this.totalValue,
    this.totalGstAmount,
    this.totalTaxAmount,
    this.totalIncentiveAmount,
    this.totalInvoiceAmount,
    this.finalTotalInvoiceAmount,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json["id"],
        purchaseId: json["purchaseId"],
        purchaseNo: json["purchaseNo"],
        branchId: json["branchId"],
        branchName: json["branchName"],
        vendorId: json["vendorId"],
        vendorName: json["vendorName"],
        pInvoiceNo: json["p_invoiceNo"],
        pInvoiceDate: json["p_invoiceDate"] == null
            ? null
            : DateTime.parse(json["p_invoiceDate"]),
        pOrderRefNo: json["p_orderRefNo"],
        itemDetails: json["itemDetails"] == null
            ? []
            : List<ItemDetail>.from(
                json["itemDetails"]!.map((x) => ItemDetail.fromJson(x))),
        totalQty: json["totalQty"],
        totalValue: json["totalValue"],
        totalGstAmount: json["totalGstAmount"],
        totalTaxAmount: json["totalTaxAmount"],
        totalIncentiveAmount: json["totalIncentiveAmount"],
        totalInvoiceAmount: json["totalInvoiceAmount"],
        finalTotalInvoiceAmount: json["finalTotalInvoiceAmount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "purchaseId": purchaseId,
        "purchaseNo": purchaseNo,
        "branchId": branchId,
        "branchName": branchName,
        "vendorId": vendorId,
        "vendorName": vendorName,
        "p_invoiceNo": pInvoiceNo,
        "p_invoiceDate":
            "${pInvoiceDate!.year.toString().padLeft(4, '0')}-${pInvoiceDate!.month.toString().padLeft(2, '0')}-${pInvoiceDate!.day.toString().padLeft(2, '0')}",
        "p_orderRefNo": pOrderRefNo,
        "itemDetails": itemDetails == null
            ? []
            : List<dynamic>.from(itemDetails!.map((x) => x.toJson())),
        "totalQty": totalQty,
        "totalValue": totalValue,
        "totalGstAmount": totalGstAmount,
        "totalTaxAmount": totalTaxAmount,
        "totalIncentiveAmount": totalIncentiveAmount,
        "totalInvoiceAmount": totalInvoiceAmount,
        "finalTotalInvoiceAmount": finalTotalInvoiceAmount,
      };
}

class ItemDetail {
  String? partNo;
  String? itemName;
  String? categoryId;
  String? categoryName;
  String? hsnSacCode;
  List<MainSpecValue>? mainSpecValues;
  dynamic specificationsValue;
  double? unitRate;
  int? quantity;
  double? value;
  double? discount;
  double? taxableValue;
  List<GstDetail>? gstDetails;
  List<Tax>? taxes;
  List<Incentive>? incentives;
  double? invoiceValue;
  double? finalInvoiceValue;

  ItemDetail({
    this.partNo,
    this.itemName,
    this.categoryId,
    this.categoryName,
    this.hsnSacCode,
    this.mainSpecValues,
    this.specificationsValue,
    this.unitRate,
    this.quantity,
    this.value,
    this.discount,
    this.taxableValue,
    this.gstDetails,
    this.taxes,
    this.incentives,
    this.invoiceValue,
    this.finalInvoiceValue,
  });

  factory ItemDetail.fromJson(Map<String, dynamic> json) => ItemDetail(
        partNo: json["partNo"],
        itemName: json["itemName"],
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        hsnSacCode: json["hsnSacCode"],
        mainSpecValues: json["mainSpecValues"] == null
            ? []
            : List<MainSpecValue>.from(
                json["mainSpecValues"]!.map((x) => MainSpecValue.fromJson(x))),
        specificationsValue: json["specificationsValue"],
        unitRate: json["unitRate"],
        quantity: json["quantity"],
        value: json["value"],
        discount: json["discount"],
        taxableValue: json["taxableValue"],
        gstDetails: json["gstDetails"] == null
            ? []
            : List<GstDetail>.from(
                json["gstDetails"]!.map((x) => GstDetail.fromJson(x))),
        taxes: json["taxes"] == null
            ? []
            : List<Tax>.from(json["taxes"]!.map((x) => Tax.fromJson(x))),
        incentives: json["incentives"] == null
            ? []
            : List<Incentive>.from(
                json["incentives"]!.map((x) => Incentive.fromJson(x))),
        invoiceValue: json["invoiceValue"],
        finalInvoiceValue: json["finalInvoiceValue"],
      );

  Map<String, dynamic> toJson() => {
        "partNo": partNo,
        "itemName": itemName,
        "categoryId": categoryId,
        "categoryName": categoryName,
        "hsnSacCode": hsnSacCode,
        "mainSpecValues": mainSpecValues == null
            ? []
            : List<dynamic>.from(mainSpecValues!.map((x) => x.toJson())),
        "specificationsValue": specificationsValue,
        "unitRate": unitRate,
        "quantity": quantity,
        "value": value,
        "discount": discount,
        "taxableValue": taxableValue,
        "gstDetails": gstDetails == null
            ? []
            : List<dynamic>.from(gstDetails!.map((x) => x.toJson())),
        "taxes": taxes == null
            ? []
            : List<dynamic>.from(taxes!.map((x) => x.toJson())),
        "incentives": incentives == null
            ? []
            : List<dynamic>.from(incentives!.map((x) => x.toJson())),
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

class Incentive {
  String? incentiveName;
  double? percentage;
  double? incentiveAmount;

  Incentive({
    this.incentiveName,
    this.percentage,
    this.incentiveAmount,
  });

  factory Incentive.fromJson(Map<String, dynamic> json) => Incentive(
        incentiveName: json["incentiveName"],
        percentage: json["percentage"],
        incentiveAmount: json["incentiveAmount"],
      );

  Map<String, dynamic> toJson() => {
        "incentiveName": incentiveName,
        "percentage": percentage,
        "incentiveAmount": incentiveAmount,
      };
}

class MainSpecValue {
  String? engineNo;
  String? frameNo;

  MainSpecValue({
    this.engineNo,
    this.frameNo,
  });

  factory MainSpecValue.fromJson(Map<String, dynamic> json) => MainSpecValue(
        engineNo: json["EngineNo"],
        frameNo: json["FrameNo"],
      );

  Map<String, dynamic> toJson() => {
        "EngineNo": engineNo,
        "FrameNo": frameNo,
      };
}

class Tax {
  String? taxName;
  double? percentage;
  double? taxAmount;

  Tax({
    this.taxName,
    this.percentage,
    this.taxAmount,
  });

  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
        taxName: json["taxName"],
        percentage: json["percentage"],
        taxAmount: json["taxAmount"],
      );

  Map<String, dynamic> toJson() => {
        "taxName": taxName,
        "percentage": percentage,
        "taxAmount": taxAmount,
      };
}

class Pageable {
  Sort? sort;
  int? offset;
  int? pageNumber;
  int? pageSize;
  bool? paged;
  bool? unpaged;

  Pageable({
    this.sort,
    this.offset,
    this.pageNumber,
    this.pageSize,
    this.paged,
    this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        offset: json["offset"],
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        paged: json["paged"],
        unpaged: json["unpaged"],
      );

  Map<String, dynamic> toJson() => {
        "sort": sort?.toJson(),
        "offset": offset,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "paged": paged,
        "unpaged": unpaged,
      };
}

class Sort {
  bool? empty;
  bool? sorted;
  bool? unsorted;

  Sort({
    this.empty,
    this.sorted,
    this.unsorted,
  });

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        empty: json["empty"],
        sorted: json["sorted"],
        unsorted: json["unsorted"],
      );

  Map<String, dynamic> toJson() => {
        "empty": empty,
        "sorted": sorted,
        "unsorted": unsorted,
      };
}
