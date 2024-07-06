class GetAllSales {
  List<Content>? content;
  bool? empty;
  bool? first;
  bool? last;
  int? number;
  int? numberOfElements;
  Pageable? pageable;
  int? size;
  Sort? sort;
  int? totalElements;
  int? totalPages;

  GetAllSales({
    this.content,
    this.empty,
    this.first,
    this.last,
    this.number,
    this.numberOfElements,
    this.pageable,
    this.size,
    this.sort,
    this.totalElements,
    this.totalPages,
  });

  factory GetAllSales.fromJson(Map<String, dynamic> json) => GetAllSales(
        content: json["content"] == null
            ? []
            : List<Content>.from(
                json["content"]!.map((x) => Content.fromJson(x))),
        empty: json["empty"],
        first: json["first"],
        last: json["last"],
        number: json["number"],
        numberOfElements: json["numberOfElements"],
        pageable: json["pageable"] == null
            ? null
            : Pageable.fromJson(json["pageable"]),
        size: json["size"],
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        totalElements: json["totalElements"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "content": content == null
            ? []
            : List<dynamic>.from(content!.map((x) => x.toJson())),
        "empty": empty,
        "first": first,
        "last": last,
        "number": number,
        "numberOfElements": numberOfElements,
        "pageable": pageable?.toJson(),
        "size": size,
        "sort": sort?.toJson(),
        "totalElements": totalElements,
        "totalPages": totalPages,
      };
}

class Content {
  String? billType;
  String? branchId;
  String? branchName;
  bool? cancelled;
  String? createdBy;
  String? createdByName;
  String? customerId;
  String? customerName;
  EvBattery? evBattery;
  Insurance? insurance;
  DateTime? invoiceDate;
  String? invoiceNo;
  String? invoiceType;
  List<ItemDetail>? itemDetails;
  Loaninfo? loaninfo;
  MandatoryAddons? mandatoryAddons;
  String? mobileNo;
  double? netAmt;
  List<PaidDetail>? paidDetails;
  String? paymentStatus;
  double? pendingAmt;
  String? reason;
  double? roundOffAmt;
  String? salesId;
  double? totalCgst;
  double? totalDisc;
  double? totalIncentiveAmt;
  double? totalInvoiceAmt;
  double? totalPaidAmt;
  int? totalQty;
  double? totalSgst;
  double? totalTaxableAmt;

  Content({
    this.billType,
    this.branchId,
    this.branchName,
    this.cancelled,
    this.createdBy,
    this.createdByName,
    this.customerId,
    this.customerName,
    this.evBattery,
    this.insurance,
    this.invoiceDate,
    this.invoiceNo,
    this.invoiceType,
    this.itemDetails,
    this.loaninfo,
    this.mandatoryAddons,
    this.mobileNo,
    this.netAmt,
    this.paidDetails,
    this.paymentStatus,
    this.pendingAmt,
    this.reason,
    this.roundOffAmt,
    this.salesId,
    this.totalCgst,
    this.totalDisc,
    this.totalIncentiveAmt,
    this.totalInvoiceAmt,
    this.totalPaidAmt,
    this.totalQty,
    this.totalSgst,
    this.totalTaxableAmt,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        billType: json["billType"],
        branchId: json["branchId"],
        branchName: json["branchName"],
        cancelled: json["cancelled"],
        createdBy: json["createdBy"],
        createdByName: json["createdByName"],
        customerId: json["customerId"],
        customerName: json["customerName"],
        evBattery: json["evBattery"] == null
            ? null
            : EvBattery.fromJson(json["evBattery"]),
        insurance: json["insurance"] == null
            ? null
            : Insurance.fromJson(json["insurance"]),
        invoiceDate: json["invoiceDate"] == null
            ? null
            : DateTime.parse(json["invoiceDate"]),
        invoiceNo: json["invoiceNo"],
        invoiceType: json["invoiceType"],
        itemDetails: json["itemDetails"] == null
            ? []
            : List<ItemDetail>.from(
                json["itemDetails"]!.map((x) => ItemDetail.fromJson(x))),
        loaninfo: json["loaninfo"] == null
            ? null
            : Loaninfo.fromJson(json["loaninfo"]),
        mandatoryAddons: json["mandatoryAddons"] == null
            ? null
            : MandatoryAddons.fromJson(json["mandatoryAddons"]),
        mobileNo: json["mobileNo"],
        netAmt: json["netAmt"],
        paidDetails: json["paidDetails"] == null
            ? []
            : List<PaidDetail>.from(
                json["paidDetails"]!.map((x) => PaidDetail.fromJson(x))),
        paymentStatus: json["paymentStatus"],
        pendingAmt: json["pendingAmt"],
        reason: json["reason"],
        roundOffAmt: json["roundOffAmt"],
        salesId: json["salesId"],
        totalCgst: json["totalCgst"],
        totalDisc: json["totalDisc"],
        totalIncentiveAmt: json["totalIncentiveAmt"],
        totalInvoiceAmt: json["totalInvoiceAmt"],
        totalPaidAmt: json["totalPaidAmt"],
        totalQty: json["totalQty"],
        totalSgst: json["totalSgst"],
        totalTaxableAmt: json["totalTaxableAmt"],
      );

  Map<String, dynamic> toJson() => {
        "billType": billType,
        "branchId": branchId,
        "branchName": branchName,
        "cancelled": cancelled,
        "createdBy": createdBy,
        "createdByName": createdByName,
        "customerId": customerId,
        "customerName": customerName,
        "evBattery": evBattery?.toJson(),
        "insurance": insurance?.toJson(),
        "invoiceDate":
            "${invoiceDate!.year.toString().padLeft(4, '0')}-${invoiceDate!.month.toString().padLeft(2, '0')}-${invoiceDate!.day.toString().padLeft(2, '0')}",
        "invoiceNo": invoiceNo,
        "invoiceType": invoiceType,
        "itemDetails": itemDetails == null
            ? []
            : List<dynamic>.from(itemDetails!.map((x) => x.toJson())),
        "loaninfo": loaninfo?.toJson(),
        "mandatoryAddons": mandatoryAddons?.toJson(),
        "mobileNo": mobileNo,
        "netAmt": netAmt,
        "paidDetails": paidDetails == null
            ? []
            : List<dynamic>.from(paidDetails!.map((x) => x.toJson())),
        "paymentStatus": paymentStatus,
        "pendingAmt": pendingAmt,
        "reason": reason,
        "roundOffAmt": roundOffAmt,
        "salesId": salesId,
        "totalCgst": totalCgst,
        "totalDisc": totalDisc,
        "totalIncentiveAmt": totalIncentiveAmt,
        "totalInvoiceAmt": totalInvoiceAmt,
        "totalPaidAmt": totalPaidAmt,
        "totalQty": totalQty,
        "totalSgst": totalSgst,
        "totalTaxableAmt": totalTaxableAmt,
      };
}

class EvBattery {
  double? evBatteryCapacity;
  String? evBatteryName;

  EvBattery({
    this.evBatteryCapacity,
    this.evBatteryName,
  });

  factory EvBattery.fromJson(Map<String, dynamic> json) => EvBattery(
        evBatteryCapacity: json["evBatteryCapacity"],
        evBatteryName: json["evBatteryName"],
      );

  Map<String, dynamic> toJson() => {
        "evBatteryCapacity": evBatteryCapacity,
        "evBatteryName": evBatteryName,
      };
}

class VehicleDetails {
  String? engineNumber;
  String? frameNumber;

  VehicleDetails({this.engineNumber, this.frameNumber});

  factory VehicleDetails.fromJson(Map<String, dynamic> json) {
    return VehicleDetails(
      engineNumber: json['engineNo'],
      frameNumber: json['frameNo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'engineNo': engineNumber,
      'frameNo': frameNumber,
    };
  }
}

class Insurance {
  DateTime? expiryDate;
  String? insuranceCompanyName;
  String? insuranceId;
  double? insuredAmt;
  DateTime? insuredDate;
  String? invoiceNo;

  Insurance({
    this.expiryDate,
    this.insuranceCompanyName,
    this.insuranceId,
    this.insuredAmt,
    this.insuredDate,
    this.invoiceNo,
  });

  factory Insurance.fromJson(Map<String, dynamic> json) => Insurance(
        expiryDate: json["expiryDate"] == null
            ? null
            : DateTime.parse(json["expiryDate"]),
        insuranceCompanyName: json["insuranceCompanyName"],
        insuranceId: json["insuranceId"],
        insuredAmt: json["insuredAmt"],
        insuredDate: json["insuredDate"] == null
            ? null
            : DateTime.parse(json["insuredDate"]),
        invoiceNo: json["invoiceNo"],
      );

  Map<String, dynamic> toJson() => {
        "expiryDate": expiryDate?.toIso8601String(),
        "insuranceCompanyName": insuranceCompanyName,
        "insuranceId": insuranceId,
        "insuredAmt": insuredAmt,
        "insuredDate": insuredDate?.toIso8601String(),
        "invoiceNo": invoiceNo,
      };
}

class ItemDetail {
  String? categoryId;
  double? discount;
  double? finalInvoiceValue;
  List<GstDetail>? gstDetails;
  String? hsnSacCode;
  List<Incentive>? incentives;
  double? invoiceValue;
  String? itemName;
  VehicleDetails? mainSpecValue;
  String? partNo;
  int? quantity;
  VehicleDetails? specificationsValue;
  String? stockId;
  double? taxableValue;
  List<Tax>? taxes;
  double? unitRate;
  double? value;

  ItemDetail({
    this.categoryId,
    this.discount,
    this.finalInvoiceValue,
    this.gstDetails,
    this.hsnSacCode,
    this.incentives,
    this.invoiceValue,
    this.itemName,
    this.mainSpecValue,
    this.partNo,
    this.quantity,
    this.specificationsValue,
    this.stockId,
    this.taxableValue,
    this.taxes,
    this.unitRate,
    this.value,
  });

  factory ItemDetail.fromJson(Map<String, dynamic> json) => ItemDetail(
        categoryId: json["categoryId"],
        discount: json["discount"],
        finalInvoiceValue: json["finalInvoiceValue"],
        gstDetails: json["gstDetails"] == null
            ? []
            : List<GstDetail>.from(
                json["gstDetails"]!.map((x) => GstDetail.fromJson(x))),
        hsnSacCode: json["hsnSacCode"],
        incentives: json["incentives"] == null
            ? []
            : List<Incentive>.from(
                json["incentives"]!.map((x) => Incentive.fromJson(x))),
        invoiceValue: json["invoiceValue"],
        itemName: json["itemName"],
        mainSpecValue: json["mainSpecValue"] == null
            ? null
            : VehicleDetails.fromJson(json["mainSpecValue"]),
        partNo: json["partNo"],
        quantity: json["quantity"],
        specificationsValue: json["specificationsValue"] == null
            ? null
            : VehicleDetails.fromJson(json["specificationsValue"]),
        stockId: json["stockId"],
        taxableValue: json["taxableValue"],
        taxes: json["taxes"] == null
            ? []
            : List<Tax>.from(json["taxes"]!.map((x) => Tax.fromJson(x))),
        unitRate: json["unitRate"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "discount": discount,
        "finalInvoiceValue": finalInvoiceValue,
        "gstDetails": gstDetails == null
            ? []
            : List<dynamic>.from(gstDetails!.map((x) => x.toJson())),
        "hsnSacCode": hsnSacCode,
        "incentives": incentives == null
            ? []
            : List<dynamic>.from(incentives!.map((x) => x.toJson())),
        "invoiceValue": invoiceValue,
        "itemName": itemName,
        "mainSpecValue": mainSpecValue?.toJson(),
        "partNo": partNo,
        "quantity": quantity,
        "specificationsValue": specificationsValue?.toJson(),
        "stockId": stockId,
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

class MandatoryAddons {
  Map<String, dynamic> addonsMap;

  MandatoryAddons({required this.addonsMap});

  factory MandatoryAddons.fromJson(Map<String, dynamic> json) {
    return MandatoryAddons(
      addonsMap: json,
    );
  }

  Map<String, dynamic> toJson() => addonsMap;

  @override
  String toString() {
    return 'MandatoryAddons(addonsMap: $addonsMap)';
  }
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

class Loaninfo {
  String? bankName;
  double? loanAmt;
  String? loanId;

  Loaninfo({
    this.bankName,
    this.loanAmt,
    this.loanId,
  });

  factory Loaninfo.fromJson(Map<String, dynamic> json) => Loaninfo(
        bankName: json["bankName"],
        loanAmt: json["loanAmt"],
        loanId: json["loanId"],
      );

  Map<String, dynamic> toJson() => {
        "bankName": bankName,
        "loanAmt": loanAmt,
        "loanId": loanId,
      };
}

class PaidDetail {
  bool? cancelled;
  double? paidAmount;
  DateTime? paymentDate;
  String? paymentId;
  String? paymentReference;
  String? paymentType;
  String? reason;

  PaidDetail({
    this.cancelled,
    this.paidAmount,
    this.paymentDate,
    this.paymentId,
    this.paymentReference,
    this.paymentType,
    this.reason,
  });

  factory PaidDetail.fromJson(Map<String, dynamic> json) => PaidDetail(
        cancelled: json["cancelled"],
        paidAmount: json["paidAmount"],
        paymentDate: json["paymentDate"] == null
            ? null
            : DateTime.parse(json["paymentDate"]),
        paymentId: json["paymentId"],
        paymentReference: json["paymentReference"],
        paymentType: json["paymentType"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "cancelled": cancelled,
        "paidAmount": paidAmount,
        "paymentDate":
            "${paymentDate!.year.toString().padLeft(4, '0')}-${paymentDate!.month.toString().padLeft(2, '0')}-${paymentDate!.day.toString().padLeft(2, '0')}",
        "paymentId": paymentId,
        "paymentReference": paymentReference,
        "paymentType": paymentType,
        "reason": reason,
      };
}

class Pageable {
  int? offset;
  int? pageNumber;
  int? pageSize;
  bool? paged;
  Sort? sort;
  bool? unpaged;

  Pageable({
    this.offset,
    this.pageNumber,
    this.pageSize,
    this.paged,
    this.sort,
    this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        offset: json["offset"],
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        paged: json["paged"],
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        unpaged: json["unpaged"],
      );

  Map<String, dynamic> toJson() => {
        "offset": offset,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "paged": paged,
        "sort": sort?.toJson(),
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
