// To parse this JSON data, do
//
//     final getTransportByPaginationModel = getTransportByPaginationModelFromJson(jsonString);

import 'dart:convert';

GetTransportByPaginationModel getTransportByPaginationModelFromJson(
        String str) =>
    GetTransportByPaginationModel.fromJson(json.decode(str));

String getTransportByPaginationModelToJson(
        GetTransportByPaginationModel data) =>
    json.encode(data.toJson());

class GetTransportByPaginationModel {
  List<TransportDetails>? transportDetails;
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

  GetTransportByPaginationModel({
    this.transportDetails,
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

  factory GetTransportByPaginationModel.fromJson(Map<String, dynamic> json) =>
      GetTransportByPaginationModel(
        transportDetails: json["content"] == null
            ? []
            : List<TransportDetails>.from(
                json["content"]!.map((x) => TransportDetails.fromJson(x))),
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
        "content": transportDetails == null
            ? []
            : List<dynamic>.from(transportDetails!.map((x) => x.toJson())),
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

class TransportDetails {
  String? city;
  String? createdBy;
  DateTime? createdDateTime;
  String? id;
  String? mobileNo;
  String? transportId;
  String? transportName;
  String? updatedBy;
  DateTime? updatedDateTime;

  TransportDetails({
    this.city,
    this.createdBy,
    this.createdDateTime,
    this.id,
    this.mobileNo,
    this.transportId,
    this.transportName,
    this.updatedBy,
    this.updatedDateTime,
  });

  factory TransportDetails.fromJson(Map<String, dynamic> json) => TransportDetails(
        city: json["city"],
        createdBy: json["createdBy"],
        createdDateTime: json["createdDateTime"] == null
            ? null
            : DateTime.parse(json["createdDateTime"]),
        id: json["id"],
        mobileNo: json["mobileNo"],
        transportId: json["transportId"],
        transportName: json["transportName"],
        updatedBy: json["updatedBy"],
        updatedDateTime: json["updatedDateTime"] == null
            ? null
            : DateTime.parse(json["updatedDateTime"]),
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "createdBy": createdBy,
        "createdDateTime": createdDateTime?.toIso8601String(),
        "id": id,
        "mobileNo": mobileNo,
        "transportId": transportId,
        "transportName": transportName,
        "updatedBy": updatedBy,
        "updatedDateTime": updatedDateTime?.toIso8601String(),
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
