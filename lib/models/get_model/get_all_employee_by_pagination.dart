import 'dart:convert';

GetAllEmployeesByPaginationModel getAllEmployeesByPaginationModelFromJson(
        String str) =>
    GetAllEmployeesByPaginationModel.fromJson(json.decode(str));

String getAllEmployeesByPaginationModelToJson(
        GetAllEmployeesByPaginationModel data) =>
    json.encode(data.toJson());

class GetAllEmployeesByPaginationModel {
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

  GetAllEmployeesByPaginationModel({
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

  factory GetAllEmployeesByPaginationModel.fromJson(
          Map<String, dynamic> json) =>
      GetAllEmployeesByPaginationModel(
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
  String? address;
  int? age;
  String? branchId;
  String? branchName;
  String? city;
  DateTime? dateOfBirth;
  String? designation;
  String? emailId;
  String? employeeId;
  String? employeeName;
  String? gender;
  String? id;
  String? mobileNumber;

  Content({
    this.address,
    this.age,
    this.branchId,
    this.branchName,
    this.city,
    this.dateOfBirth,
    this.designation,
    this.emailId,
    this.employeeId,
    this.employeeName,
    this.gender,
    this.id,
    this.mobileNumber,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        address: json["address"],
        age: json["age"],
        branchId: json["branchId"],
        branchName: json["branchName"],
        city: json["city"],
        dateOfBirth: json["dateOfBirth"] == null
            ? null
            : DateTime.parse(json["dateOfBirth"]),
        designation: json["designation"],
        emailId: json["emailId"],
        employeeId: json["employeeId"],
        employeeName: json["employeeName"],
        gender: json["gender"],
        id: json["id"],
        mobileNumber: json["mobileNumber"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "age": age,
        "branchId": branchId,
        "branchName": branchName,
        "city": city,
        "dateOfBirth":
            "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
        "designation": designation,
        "emailId": emailId,
        "employeeId": employeeId,
        "employeeName": employeeName,
        "gender": gender,
        "id": id,
        "mobileNumber": mobileNumber,
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
