class UserUpdateModel {
  String? id;
  String? userId;
  String? userName;
  String? mobileNumber;
  String? password;
  String? designation;
  DateTime? createdDateTime;
  dynamic createdBy;
  DateTime? updatedDateTime;
  dynamic updatedBy;

  UserUpdateModel({
    this.id,
    this.userId,
    this.userName,
    this.mobileNumber,
    this.password,
    this.designation,
    this.createdDateTime,
    this.createdBy,
    this.updatedDateTime,
    this.updatedBy,
  });

  factory UserUpdateModel.fromJson(Map<String, dynamic> json) =>
      UserUpdateModel(
        id: json["id"],
        userId: json["userId"],
        userName: json["userName"],
        mobileNumber: json["mobileNumber"],
        password: json["password"],
        designation: json["designation"],
        createdDateTime: json["createdDateTime"] == null
            ? null
            : DateTime.parse(json["createdDateTime"]),
        createdBy: json["createdBy"],
        updatedDateTime: json["updatedDateTime"] == null
            ? null
            : DateTime.parse(json["updatedDateTime"]),
        updatedBy: json["updatedBy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "userName": userName,
        "mobileNumber": mobileNumber,
        "password": password,
        "designation": designation,
        "createdDateTime": createdDateTime?.toIso8601String(),
        "createdBy": createdBy,
        "updatedDateTime": updatedDateTime?.toIso8601String(),
        "updatedBy": updatedBy,
      };
}
