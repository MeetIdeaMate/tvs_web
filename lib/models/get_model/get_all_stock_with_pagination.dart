class GetAllStocksByPagenation {
  List<StockDetailsList>? stockDetailsList;
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
    this.stockDetailsList,
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

  factory GetAllStocksByPagenation.fromJson(Map<String, dynamic> json) =>
      GetAllStocksByPagenation(
        stockDetailsList: json["content"] == null
            ? []
            : List<StockDetailsList>.from(
                json["content"]!.map((x) => StockDetailsList.fromJson(x))),
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
        "content": stockDetailsList == null
            ? []
            : List<dynamic>.from(stockDetailsList!.map((x) => x.toJson())),
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

class StockDetailsList {
  String? branchId;
  String? branchName;
  String? categoryId;
  String? categoryName;
  String? hsnSacCode;
  String? itemName;
  String? partNo;
  List<StockItem>? stockItems;
  String? stockStatus;
  int? totalQuantity;

  StockDetailsList({
    this.branchId,
    this.branchName,
    this.categoryId,
    this.categoryName,
    this.hsnSacCode,
    this.itemName,
    this.partNo,
    this.stockItems,
    this.stockStatus,
    this.totalQuantity,
  });

  factory StockDetailsList.fromJson(Map<String, dynamic> json) =>
      StockDetailsList(
        branchId: json["branchId"],
        branchName: json["branchName"],
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        hsnSacCode: json["hsnSacCode"],
        itemName: json["itemName"],
        partNo: json["partNo"],
        stockItems: json["stockItems"] == null
            ? []
            : List<StockItem>.from(
                json["stockItems"]!.map((x) => StockItem.fromJson(x))),
        stockStatus: json["stockStatus"],
        totalQuantity: json["totalQuantity"],
      );

  Map<String, dynamic> toJson() => {
        "branchId": branchId,
        "branchName": branchName,
        "categoryId": categoryId,
        "categoryName": categoryName,
        "hsnSacCode": hsnSacCode,
        "itemName": itemName,
        "partNo": partNo,
        "stockItems": stockItems == null
            ? []
            : List<dynamic>.from(stockItems!.map((x) => x.toJson())),
        "stockStatus": stockStatus,
        "totalQuantity": totalQuantity,
      };
}

class StockItem {
  MainSpecValue? mainSpecValue;
  int? quantity;
  String? stockId;

  StockItem({
    this.mainSpecValue,
    this.quantity,
    this.stockId,
  });

  factory StockItem.fromJson(Map<String, dynamic> json) => StockItem(
        mainSpecValue: json["mainSpecValue"] == null
            ? null
            : MainSpecValue.fromJson(json["mainSpecValue"]),
        quantity: json["quantity"],
        stockId: json["stockId"],
      );

  Map<String, dynamic> toJson() => {
        "mainSpecValue": mainSpecValue?.toJson(),
        "quantity": quantity,
        "stockId": stockId,
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
