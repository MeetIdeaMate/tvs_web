class UsersListModel {
  List<UserDetailsList>? content;
  Pageable? pageable;
  int? totalPages;
  int? totalElements;
  bool? last;
  Sort? sort;
  int? numberOfElements;
  bool? first;
  int? size;
  int? number;
  bool? empty;

  UsersListModel({
    this.content,
    this.pageable,
    this.totalPages,
    this.totalElements,
    this.last,
    this.sort,
    this.numberOfElements,
    this.first,
    this.size,
    this.number,
    this.empty,
  });

  factory UsersListModel.fromJson(Map<String, dynamic> json) => UsersListModel(
        content: json["content"] == null
            ? []
            : List<UserDetailsList>.from(
                json["content"]!.map((x) => UserDetailsList.fromJson(x))),
        pageable: json["pageable"] == null
            ? null
            : Pageable.fromJson(json["pageable"]),
        totalPages: json["totalPages"],
        totalElements: json["totalElements"],
        last: json["last"],
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        numberOfElements: json["numberOfElements"],
        first: json["first"],
        size: json["size"],
        number: json["number"],
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
        "sort": sort?.toJson(),
        "numberOfElements": numberOfElements,
        "first": first,
        "size": size,
        "number": number,
        "empty": empty,
      };
}

class UserDetailsList {
  String? id;
  String? userId;
  String? userName;
  String? mobileNumber;
  String? password;
  String? branchName;
  String? designation;
  DateTime? createdDateTime;
  String? createdBy;
  DateTime? updatedDateTime;
  String? updatedBy;
  String? userStatus;

  UserDetailsList({
    this.id,
    this.userId,
    this.userName,
    this.mobileNumber,
    this.password,
    this.designation,
    this.branchName,
    this.createdDateTime,
    this.createdBy,
    this.updatedDateTime,
    this.updatedBy,
    this.userStatus,
  });

  factory UserDetailsList.fromJson(Map<String, dynamic> json) =>
      UserDetailsList(
        id: json["id"],
        userId: json["userId"],
        userName: json["userName"],
        mobileNumber: json["mobileNumber"],
        password: json["password"],
        designation: json["designation"],
        branchName: json['branchName'],
        createdDateTime: json["createdDateTime"] == null
            ? null
            : DateTime.parse(json["createdDateTime"]),
        createdBy: json["createdBy"],
        updatedDateTime: json["updatedDateTime"] == null
            ? null
            : DateTime.parse(json["updatedDateTime"]),
        updatedBy: json["updatedBy"],
        userStatus: json["userStatus"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "userName": userName,
        "mobileNumber": mobileNumber,
        "password": password,
        "designation": designation,
        'branchName': branchName,
        "createdDateTime": createdDateTime?.toIso8601String(),
        "createdBy": createdBy,
        "updatedDateTime": updatedDateTime?.toIso8601String(),
        "updatedBy": updatedBy,
        "userStatus": userStatus,
      };
}

class Pageable {
  Sort? sort;
  int? pageNumber;
  int? pageSize;
  int? offset;
  bool? unpaged;
  bool? paged;

  Pageable({
    this.sort,
    this.pageNumber,
    this.pageSize,
    this.offset,
    this.unpaged,
    this.paged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        offset: json["offset"],
        unpaged: json["unpaged"],
        paged: json["paged"],
      );

  Map<String, dynamic> toJson() => {
        "sort": sort?.toJson(),
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "offset": offset,
        "unpaged": unpaged,
        "paged": paged,
      };
}

class Sort {
  bool? sorted;
  bool? unsorted;
  bool? empty;

  Sort({
    this.sorted,
    this.unsorted,
    this.empty,
  });

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        sorted: json["sorted"],
        unsorted: json["unsorted"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "sorted": sorted,
        "unsorted": unsorted,
        "empty": empty,
      };
}
