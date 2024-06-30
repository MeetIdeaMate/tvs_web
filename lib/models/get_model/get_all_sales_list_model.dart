class GetAllSales {
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

  GetAllSales({
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

  factory GetAllSales.fromJson(Map<String, dynamic> json) => GetAllSales(
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
  String? salesId;
  String? invoiceType;
  String? invoiceNo;
  DateTime? invoiceDate;
  String? billType;
  String? customerId;
  String? customerName;
  String? mobileNo;
  List<PaidDetail>? paidDetails;
  List<ItemDetail>? itemDetails;
  String? paymentStatus;
  int? totalQty;
  double? totalTaxableAmt;
  double? totalDisc;
  double? totalCgst;
  double? totalSgst;
  double? totalInvoiceAmt;
  double? totalIncentiveAmt;
  double? roundOffAmt;
  double? netAmt;
  Insurance? insurance;
  Loaninfo? loaninfo;
  double? pendingAmt;
  String? branchId;
  dynamic branchName;
  EvBattery? evBattery;
  MandatoryAddons? mandatoryAddons;

  Content({
    this.salesId,
    this.invoiceType,
    this.invoiceNo,
    this.invoiceDate,
    this.billType,
    this.customerId,
    this.customerName,
    this.mobileNo,
    this.paidDetails,
    this.itemDetails,
    this.paymentStatus,
    this.totalQty,
    this.totalTaxableAmt,
    this.totalDisc,
    this.totalCgst,
    this.totalSgst,
    this.totalInvoiceAmt,
    this.totalIncentiveAmt,
    this.roundOffAmt,
    this.netAmt,
    this.insurance,
    this.loaninfo,
    this.pendingAmt,
    this.branchId,
    this.branchName,
    this.evBattery,
    this.mandatoryAddons,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        salesId: json["salesId"],
        invoiceType: json["invoiceType"],
        invoiceNo: json["invoiceNo"],
        invoiceDate: json["invoiceDate"] == null
            ? null
            : DateTime.parse(json["invoiceDate"]),
        billType: json["billType"],
        customerId: json["customerId"],
        customerName: json["customerName"],
        mobileNo: json["mobileNo"],
        paidDetails: json["paidDetails"] == null
            ? []
            : List<PaidDetail>.from(
                json["paidDetails"]!.map((x) => PaidDetail.fromJson(x))),
        itemDetails: json["itemDetails"] == null
            ? []
            : List<ItemDetail>.from(
                json["itemDetails"]!.map((x) => ItemDetail.fromJson(x))),
        paymentStatus: json["paymentStatus"],
        totalQty: json["totalQty"],
        totalTaxableAmt: json["totalTaxableAmt"]?.toDouble(),
        totalDisc: json["totalDisc"],
        totalCgst: json["totalCgst"]?.toDouble(),
        totalSgst: json["totalSgst"]?.toDouble(),
        totalInvoiceAmt: json["totalInvoiceAmt"],
        totalIncentiveAmt: json["totalIncentiveAmt"],
        roundOffAmt: json["roundOffAmt"],
        netAmt: json["netAmt"],
        insurance: json["insurance"] == null
            ? null
            : Insurance.fromJson(json["insurance"]),
        loaninfo: json["loaninfo"] == null
            ? null
            : Loaninfo.fromJson(json["loaninfo"]),
        pendingAmt: json["pendingAmt"],
        branchId: json["branchId"],
        branchName: json["branchName"],
        evBattery: json["evBattery"] == null
            ? null
            : EvBattery.fromJson(json["evBattery"]),
        mandatoryAddons: json["mandatoryAddons"] == null
            ? null
            : MandatoryAddons.fromJson(json["mandatoryAddons"]),
      );

  Map<String, dynamic> toJson() => {
        "salesId": salesId,
        "invoiceType": invoiceType,
        "invoiceNo": invoiceNo,
        "invoiceDate":
            "${invoiceDate!.year.toString().padLeft(4, '0')}-${invoiceDate!.month.toString().padLeft(2, '0')}-${invoiceDate!.day.toString().padLeft(2, '0')}",
        "billType": billType,
        "customerId": customerId,
        "customerName": customerName,
        "mobileNo": mobileNo,
        "paidDetails": paidDetails == null
            ? []
            : List<dynamic>.from(paidDetails!.map((x) => x.toJson())),
        "itemDetails": itemDetails == null
            ? []
            : List<dynamic>.from(itemDetails!.map((x) => x.toJson())),
        "paymentStatus": paymentStatus,
        "totalQty": totalQty,
        "totalTaxableAmt": totalTaxableAmt,
        "totalDisc": totalDisc,
        "totalCgst": totalCgst,
        "totalSgst": totalSgst,
        "totalInvoiceAmt": totalInvoiceAmt,
        "totalIncentiveAmt": totalIncentiveAmt,
        "roundOffAmt": roundOffAmt,
        "netAmt": netAmt,
        "insurance": insurance?.toJson(),
        "loaninfo": loaninfo?.toJson(),
        "pendingAmt": pendingAmt,
        "branchId": branchId,
        "branchName": branchName,
        "evBattery": evBattery?.toJson(),
        "mandatoryAddons": mandatoryAddons?.toJson(),
      };
}

class EvBattery {
  String? evBatteryName;
  double? evBatteryCapacity;

  EvBattery({
    this.evBatteryName,
    this.evBatteryCapacity,
  });

  factory EvBattery.fromJson(Map<String, dynamic> json) => EvBattery(
        evBatteryName: json["evBatteryName"],
        evBatteryCapacity: json["evBatteryCapacity"],
      );

  Map<String, dynamic> toJson() => {
        "evBatteryName": evBatteryName,
        "evBatteryCapacity": evBatteryCapacity,
      };
}

class Insurance {
  String? insuranceId;
  double? insuredAmt;
  String? invoiceNo;
  DateTime? insuredDate;
  DateTime? expiryDate;
  String? insuranceCompanyName;

  Insurance({
    this.insuranceId,
    this.insuredAmt,
    this.invoiceNo,
    this.insuredDate,
    this.expiryDate,
    this.insuranceCompanyName,
  });

  factory Insurance.fromJson(Map<String, dynamic> json) => Insurance(
        insuranceId: json["insuranceId"],
        insuredAmt: json["insuredAmt"],
        invoiceNo: json["invoiceNo"],
        insuredDate: json["insuredDate"] == null
            ? null
            : DateTime.parse(json["insuredDate"]),
        expiryDate: json["expiryDate"] == null
            ? null
            : DateTime.parse(json["expiryDate"]),
        insuranceCompanyName: json["insuranceCompanyName"],
      );

  Map<String, dynamic> toJson() => {
        "insuranceId": insuranceId,
        "insuredAmt": insuredAmt,
        "invoiceNo": invoiceNo,
        "insuredDate": insuredDate?.toIso8601String(),
        "expiryDate": expiryDate?.toIso8601String(),
        "insuranceCompanyName": insuranceCompanyName,
      };
}

class ItemDetail {
  String? partNo;
  String? itemName;
  String? categoryId;
  String? hsnSacCode;
  VehicleDetails? mainSpecValue;
  VehicleDetails? specificationsValue;
  double? unitRate;
  int? quantity;
  double? value;
  double? discount;
  double? taxableValue;
  List<GstDetail>? gstDetails;
  List<dynamic>? taxes;
  List<dynamic>? incentives;
  double? invoiceValue;
  double? finalInvoiceValue;
  String? stockId;

  ItemDetail({
    this.partNo,
    this.itemName,
    this.categoryId,
    this.hsnSacCode,
    this.mainSpecValue,
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
    this.stockId,
  });

  factory ItemDetail.fromJson(Map<String, dynamic> json) => ItemDetail(
        partNo: json["partNo"],
        itemName: json["itemName"],
        categoryId: json["categoryId"],
        hsnSacCode: json["hsnSacCode"],
        mainSpecValue: json["mainSpecValue"] == null
            ? null
            : VehicleDetails.fromJson(json["mainSpecValue"]),
        specificationsValue: json["specificationsValue"] == null
            ? null
            : VehicleDetails.fromJson(json["specificationsValue"]),
        unitRate: json["unitRate"]?.toDouble(),
        quantity: json["quantity"],
        value: json["value"]?.toDouble(),
        discount: json["discount"],
        taxableValue: json["taxableValue"]?.toDouble(),
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
        stockId: json["stockId"],
      );

  Map<String, dynamic> toJson() => {
        "partNo": partNo,
        "itemName": itemName,
        "categoryId": categoryId,
        "hsnSacCode": hsnSacCode,
        "mainSpecValue": mainSpecValue?.toJson(),
        "specificationsValue": specificationsValue?.toJson(),
        "unitRate": unitRate,
        "quantity": quantity,
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
        "stockId": stockId,
      };
}

class GstDetail {
  String? gstName;
  int? percentage;
  double? gstAmount;

  GstDetail({
    this.gstName,
    this.percentage,
    this.gstAmount,
  });

  factory GstDetail.fromJson(Map<String, dynamic> json) => GstDetail(
        gstName: json["gstName"],
        percentage: json["percentage"],
        gstAmount: json["gstAmount"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "gstName": gstName,
        "percentage": percentage,
        "gstAmount": gstAmount,
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

class Loaninfo {
  String? loanId;
  String? bankName;
  double? loanAmt;

  Loaninfo({
    this.loanId,
    this.bankName,
    this.loanAmt,
  });

  factory Loaninfo.fromJson(Map<String, dynamic> json) => Loaninfo(
        loanId: json["loanId"],
        bankName: json["bankName"],
        loanAmt: json["loanAmt"],
      );

  Map<String, dynamic> toJson() => {
        "loanId": loanId,
        "bankName": bankName,
        "loanAmt": loanAmt,
      };
}

class MandatoryAddons {
  String? tools;
  String? manualBook;
  String? duplicateKey;

  MandatoryAddons({
    this.tools,
    this.manualBook,
    this.duplicateKey,
  });

  factory MandatoryAddons.fromJson(Map<String, dynamic> json) =>
      MandatoryAddons(
        tools: json["Tools"],
        manualBook: json["Manual Book"],
        duplicateKey: json["Duplicate key"],
      );

  Map<String, dynamic> toJson() => {
        "Tools": tools,
        "Manual Book": manualBook,
        "Duplicate key": duplicateKey,
      };
}

class PaidDetail {
  String? paymentId;
  DateTime? paymentDate;
  double? paidAmount;
  String? paymentType;

  PaidDetail({
    this.paymentId,
    this.paymentDate,
    this.paidAmount,
    this.paymentType,
  });

  factory PaidDetail.fromJson(Map<String, dynamic> json) => PaidDetail(
        paymentId: json["paymentId"],
        paymentDate: json["paymentDate"] == null
            ? null
            : DateTime.parse(json["paymentDate"]),
        paidAmount: json["paidAmount"],
        paymentType: json["paymentType"],
      );

  Map<String, dynamic> toJson() => {
        "paymentId": paymentId,
        "paymentDate":
            "${paymentDate!.year.toString().padLeft(4, '0')}-${paymentDate!.month.toString().padLeft(2, '0')}-${paymentDate!.day.toString().padLeft(2, '0')}",
        "paidAmount": paidAmount,
        "paymentType": paymentType,
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
