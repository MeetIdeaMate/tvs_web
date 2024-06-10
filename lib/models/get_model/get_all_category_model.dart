// To parse this JSON data, do
//
//     final getAllCategoryListModel = getAllCategoryListModelFromJson(jsonString);

import 'dart:convert';

GetAllCategoryListModel getAllCategoryListModelFromJson(String str) =>
    GetAllCategoryListModel.fromJson(json.decode(str));

String getAllCategoryListModelToJson(GetAllCategoryListModel data) =>
    json.encode(data.toJson());

class GetAllCategoryListModel {
  List<CategoryItems>? category;
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

  GetAllCategoryListModel({
    this.category,
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

  factory GetAllCategoryListModel.fromJson(Map<String, dynamic> json) =>
      GetAllCategoryListModel(
        category: json["content"] == null
            ? []
            : List<CategoryItems>.from(
                json["content"]!.map((x) => CategoryItems.fromJson(x))),
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
        "content": category == null
            ? []
            : List<dynamic>.from(category!.map((x) => x.toJson())),
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

class CategoryItems {
  String? categoryId;
  String? categoryName;
  String? createdBy;
  DateTime? createdDateTime;
  String? hsnSacCode;
  String? id;
  Incentive? incentive;
  MainSpec? mainSpec;
  MainSpec? specification;
  Incentive? taxes;
  String? updatedBy;
  DateTime? updatedDateTime;

  CategoryItems({
    this.categoryId,
    this.categoryName,
    this.createdBy,
    this.createdDateTime,
    this.hsnSacCode,
    this.id,
    this.incentive,
    this.mainSpec,
    this.specification,
    this.taxes,
    this.updatedBy,
    this.updatedDateTime,
  });

  factory CategoryItems.fromJson(Map<String, dynamic> json) => CategoryItems(
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        createdBy: json["createdBy"],
        createdDateTime: json["createdDateTime"] == null
            ? null
            : DateTime.parse(json["createdDateTime"]),
        hsnSacCode: json["hsnSacCode"],
        id: json["id"],
        incentive: json["incentive"] == null
            ? null
            : Incentive.fromJson(json["incentive"]),
        mainSpec: json["mainSpec"] == null
            ? null
            : MainSpec.fromJson(json["mainSpec"]),
        specification: json["specification"] == null
            ? null
            : MainSpec.fromJson(json["specification"]),
        taxes: json["taxes"] == null ? null : Incentive.fromJson(json["taxes"]),
        updatedBy: json["updatedBy"],
        updatedDateTime: json["updatedDateTime"] == null
            ? null
            : DateTime.parse(json["updatedDateTime"]),
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "categoryName": categoryName,
        "createdBy": createdBy,
        "createdDateTime": createdDateTime?.toIso8601String(),
        "hsnSacCode": hsnSacCode,
        "id": id,
        "incentive": incentive?.toJson(),
        "mainSpec": mainSpec?.toJson(),
        "specification": specification?.toJson(),
        "taxes": taxes?.toJson(),
        "updatedBy": updatedBy,
        "updatedDateTime": updatedDateTime?.toIso8601String(),
      };
}

class Incentive {
  int? additionalProp1;
  int? additionalProp2;
  int? additionalProp3;

  Incentive({
    this.additionalProp1,
    this.additionalProp2,
    this.additionalProp3,
  });

  factory Incentive.fromJson(Map<String, dynamic> json) => Incentive(
        additionalProp1: json["additionalProp1"],
        additionalProp2: json["additionalProp2"],
        additionalProp3: json["additionalProp3"],
      );

  Map<String, dynamic> toJson() => {
        "additionalProp1": additionalProp1,
        "additionalProp2": additionalProp2,
        "additionalProp3": additionalProp3,
      };
}

class MainSpec {
  String? additionalProp1;
  String? additionalProp2;
  String? additionalProp3;

  MainSpec({
    this.additionalProp1,
    this.additionalProp2,
    this.additionalProp3,
  });

  factory MainSpec.fromJson(Map<String, dynamic> json) => MainSpec(
        additionalProp1: json["additionalProp1"],
        additionalProp2: json["additionalProp2"],
        additionalProp3: json["additionalProp3"],
      );

  Map<String, dynamic> toJson() => {
        "additionalProp1": additionalProp1,
        "additionalProp2": additionalProp2,
        "additionalProp3": additionalProp3,
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
