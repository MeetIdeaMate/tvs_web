import 'package:tlbilling/models/get_model/get_all_customers_model.dart';

class GetAllInsuranceByPaginationModel {
  List<GetAllCustomersModel>? getAllCustomersModel;
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

  GetAllInsuranceByPaginationModel({
    this.getAllCustomersModel,
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

  factory GetAllInsuranceByPaginationModel.fromJson(
          Map<String, dynamic> json) =>
      GetAllInsuranceByPaginationModel(
        getAllCustomersModel: json["content"] == null
            ? []
            : List<GetAllCustomersModel>.from(
                json["content"]!.map((x) => GetAllCustomersModel.fromJson(x))),
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
        "content": getAllCustomersModel == null
            ? []
            : List<dynamic>.from(getAllCustomersModel!.map((x) => x.toJson())),
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
