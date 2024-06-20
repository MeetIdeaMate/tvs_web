// To parse this JSON data, do
//
//     final getAllStocksByPagenation = getAllStocksByPagenationFromJson(jsonString);

import 'dart:convert';

GetAllStocksByPagenation getAllStocksByPagenationFromJson(String str) => GetAllStocksByPagenation.fromJson(json.decode(str));

String getAllStocksByPagenationToJson(GetAllStocksByPagenation data) => json.encode(data.toJson());

class GetAllStocksByPagenation {
    List<StockDetailsList>? content;
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

    GetAllStocksByPagenation({
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

    factory GetAllStocksByPagenation.fromJson(Map<String, dynamic> json) => GetAllStocksByPagenation(
        content: json["content"] == null ? [] : List<StockDetailsList>.from(json["content"]!.map((x) => StockDetailsList.fromJson(x))),
        empty: json["empty"],
        first: json["first"],
        last: json["last"],
        number: json["number"],
        numberOfElements: json["numberOfElements"],
        pageable: json["pageable"] == null ? null : Pageable.fromJson(json["pageable"]),
        size: json["size"],
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        totalElements: json["totalElements"],
        totalPages: json["totalPages"],
    );

    Map<String, dynamic> toJson() => {
        "content": content == null ? [] : List<dynamic>.from(content!.map((x) => x.toJson())),
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

class StockDetailsList {
    String? branchId;
    String? branchName;
    String? categoryId;
    String? categoryName;
    String? hsnSacCode;
    String? itemName;
    MainSpecValue? mainSpecValue;
    String? partNo;
    PurchaseItem? purchaseItem;
    int? quantity;
    SpecificationsValue? specificationsValue;
    String? stockId;
    String? stockStatus;

    StockDetailsList({
        this.branchId,
        this.branchName,
        this.categoryId,
        this.categoryName,
        this.hsnSacCode,
        this.itemName,
        this.mainSpecValue,
        this.partNo,
        this.purchaseItem,
        this.quantity,
        this.specificationsValue,
        this.stockId,
        this.stockStatus,
    });

    factory StockDetailsList.fromJson(Map<String, dynamic> json) => StockDetailsList(
        branchId: json["branchId"],
        branchName: json["branchName"],
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        hsnSacCode: json["hsnSacCode"],
        itemName: json["itemName"],
        mainSpecValue: json["mainSpecValue"] == null ? null : MainSpecValue.fromJson(json["mainSpecValue"]),
        partNo: json["partNo"],
        purchaseItem: json["purchaseItem"] == null ? null : PurchaseItem.fromJson(json["purchaseItem"]),
        quantity: json["quantity"],
        specificationsValue: json["specificationsValue"] == null ? null : SpecificationsValue.fromJson(json["specificationsValue"]),
        stockId: json["stockId"],
        stockStatus: json["stockStatus"],
    );

    Map<String, dynamic> toJson() => {
        "branchId": branchId,
        "branchName": branchName,
        "categoryId": categoryId,
        "categoryName": categoryName,
        "hsnSacCode": hsnSacCode,
        "itemName": itemName,
        "mainSpecValue": mainSpecValue?.toJson(),
        "partNo": partNo,
        "purchaseItem": purchaseItem?.toJson(),
        "quantity": quantity,
        "specificationsValue": specificationsValue?.toJson(),
        "stockId": stockId,
        "stockStatus": stockStatus,
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

class PurchaseItem {
    double? discount;
    double? finalInvoiceValue;
    List<GstDetail>? gstDetails;
    List<Incentive>? incentives;
    double? invoiceValue;
    double? taxableValue;
    List<Tax>? taxes;
    double? unitRate;
    double? value;

    PurchaseItem({
        this.discount,
        this.finalInvoiceValue,
        this.gstDetails,
        this.incentives,
        this.invoiceValue,
        this.taxableValue,
        this.taxes,
        this.unitRate,
        this.value,
    });

    factory PurchaseItem.fromJson(Map<String, dynamic> json) => PurchaseItem(
        discount: json["discount"],
        finalInvoiceValue: json["finalInvoiceValue"],
        gstDetails: json["gstDetails"] == null ? [] : List<GstDetail>.from(json["gstDetails"]!.map((x) => GstDetail.fromJson(x))),
        incentives: json["incentives"] == null ? [] : List<Incentive>.from(json["incentives"]!.map((x) => Incentive.fromJson(x))),
        invoiceValue: json["invoiceValue"],
        taxableValue: json["taxableValue"],
        taxes: json["taxes"] == null ? [] : List<Tax>.from(json["taxes"]!.map((x) => Tax.fromJson(x))),
        unitRate: json["unitRate"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "discount": discount,
        "finalInvoiceValue": finalInvoiceValue,
        "gstDetails": gstDetails == null ? [] : List<dynamic>.from(gstDetails!.map((x) => x.toJson())),
        "incentives": incentives == null ? [] : List<dynamic>.from(incentives!.map((x) => x.toJson())),
        "invoiceValue": invoiceValue,
        "taxableValue": taxableValue,
        "taxes": taxes == null ? [] : List<dynamic>.from(taxes!.map((x) => x.toJson())),
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

class SpecificationsValue {
    SpecificationsValue();

    factory SpecificationsValue.fromJson(Map<String, dynamic> json) => SpecificationsValue(
    );

    Map<String, dynamic> toJson() => {
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
