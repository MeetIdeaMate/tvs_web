class GetAllAccountHeadPagination {
  List<GetAllAccount>? content;
  Pageable? pageable;
  bool? last;
  int? totalElements;
  int? totalPages;
  int? size;
  int? number;
  Sort? sort;
  bool? first;
  int? numberOfElements;
  bool? empty;

  GetAllAccountHeadPagination({
    this.content,
    this.pageable,
    this.last,
    this.totalElements,
    this.totalPages,
    this.size,
    this.number,
    this.sort,
    this.first,
    this.numberOfElements,
    this.empty,
  });

  factory GetAllAccountHeadPagination.fromJson(Map<String, dynamic> json) =>
      GetAllAccountHeadPagination(
        content: json["content"] == null
            ? []
            : List<GetAllAccount>.from(
                json["content"]!.map((x) => GetAllAccount.fromJson(x))),
        pageable: json["pageable"] == null
            ? null
            : Pageable.fromJson(json["pageable"]),
        last: json["last"],
        totalElements: json["totalElements"],
        totalPages: json["totalPages"],
        size: json["size"],
        number: json["number"],
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        first: json["first"],
        numberOfElements: json["numberOfElements"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "content": content == null
            ? []
            : List<dynamic>.from(content!.map((x) => x.toJson())),
        "pageable": pageable?.toJson(),
        "last": last,
        "totalElements": totalElements,
        "totalPages": totalPages,
        "size": size,
        "number": number,
        "sort": sort?.toJson(),
        "first": first,
        "numberOfElements": numberOfElements,
        "empty": empty,
      };
}

class GetAllAccount {
  String? id;
  String? accountHeadCode;
  String? accountHeadName;
  String? accountType;
  String? pricingFormat;
  int? minAmount;
  int? maxAmount;
  bool? cashierOps;
  String? transferFrom;
  String? transferTo;
  bool? needPrinting;
  String? printingTemplate;
  String? ptVariables;
  bool? activeStatus;
  DateTime? createdDateTime;
  String? createdBy;
  DateTime? updatedDateTime;
  String? updatedBy;
  dynamic lastApprovedBy;

  GetAllAccount({
    this.id,
    this.accountHeadCode,
    this.accountHeadName,
    this.accountType,
    this.pricingFormat,
    this.minAmount,
    this.maxAmount,
    this.cashierOps,
    this.transferFrom,
    this.transferTo,
    this.needPrinting,
    this.printingTemplate,
    this.ptVariables,
    this.activeStatus,
    this.createdDateTime,
    this.createdBy,
    this.updatedDateTime,
    this.updatedBy,
    this.lastApprovedBy,
  });

  factory GetAllAccount.fromJson(Map<String, dynamic> json) => GetAllAccount(
        id: json["id"],
        accountHeadCode: json["accountHeadCode"],
        accountHeadName: json["accountHeadName"],
        accountType: json["accountType"],
        pricingFormat: json["pricingFormat"],
        minAmount: json["minAmount"],
        maxAmount: json["maxAmount"],
        cashierOps: json["cashierOps"],
        transferFrom: json["transferFrom"],
        transferTo: json["transferTo"],
        needPrinting: json["needPrinting"],
        printingTemplate: json["printingTemplate"],
        ptVariables: json["ptVariables"],
        activeStatus: json["activeStatus"],
        createdDateTime: json["createdDateTime"] == null
            ? null
            : DateTime.parse(json["createdDateTime"]),
        createdBy: json["createdBy"],
        updatedDateTime: json["updatedDateTime"] == null
            ? null
            : DateTime.parse(json["updatedDateTime"]),
        updatedBy: json["updatedBy"],
        lastApprovedBy: json["lastApprovedBy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "accountHeadCode": accountHeadCode,
        "accountHeadName": accountHeadName,
        "accountType": accountType,
        "pricingFormat": pricingFormat,
        "minAmount": minAmount,
        "maxAmount": maxAmount,
        "cashierOps": cashierOps,
        "transferFrom": transferFrom,
        "transferTo": transferTo,
        "needPrinting": needPrinting,
        "printingTemplate": printingTemplate,
        "ptVariables": ptVariables,
        "activeStatus": activeStatus,
        "createdDateTime": createdDateTime?.toIso8601String(),
        "createdBy": createdBy,
        "updatedDateTime": updatedDateTime?.toIso8601String(),
        "updatedBy": updatedBy,
        "lastApprovedBy": lastApprovedBy,
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
