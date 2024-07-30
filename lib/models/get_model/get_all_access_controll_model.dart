// To parse this JSON data, do
//
//     final getAllAccessControlModel = getAllAccessControlModelFromJson(jsonString);

import 'dart:convert';

GetAllAccessControlModel getAllAccessControlModelFromJson(String str) =>
    GetAllAccessControlModel.fromJson(json.decode(str));

String getAllAccessControlModelToJson(GetAllAccessControlModel data) =>
    json.encode(data.toJson());

class GetAllAccessControlModel {
  List<AccessControlList>? accessControlList;

  GetAllAccessControlModel({
    this.accessControlList,
  });

  factory GetAllAccessControlModel.fromJson(Map<String, dynamic> json) =>
      GetAllAccessControlModel(
        accessControlList: json["accessControlList"] == null
            ? []
            : List<AccessControlList>.from(json["accessControlList"]!
                .map((x) => AccessControlList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "accessControlList": accessControlList == null
            ? []
            : List<dynamic>.from(accessControlList!.map((x) => x.toJson())),
      };
}

class AccessControlList {
  String? id;
  dynamic departmentId;
  String? userId;
  dynamic role;
  List<MenuList>? menus;
  List<UiComponent>? uiComponents;
  DateTime? createdDateTime;
  String? createdBy;
  DateTime? updatedDateTime;
  String? updatedBy;

  AccessControlList({
    this.id,
    this.departmentId,
    this.userId,
    this.role,
    this.menus,
    this.uiComponents,
    this.createdDateTime,
    this.createdBy,
    this.updatedDateTime,
    this.updatedBy,
  });

  factory AccessControlList.fromJson(Map<String, dynamic> json) =>
      AccessControlList(
        id: json["id"],
        departmentId: json["departmentId"],
        userId: json["userId"],
        role: json["role"],
        menus: json["menus"] == null
            ? []
            : List<MenuList>.from(
                json["menus"]!.map((x) => MenuList.fromJson(x))),
        uiComponents: json["uiComponents"] == null
            ? []
            : List<UiComponent>.from(
                json["uiComponents"]!.map((x) => UiComponent.fromJson(x))),
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
        "departmentId": departmentId,
        "userId": userId,
        "role": role,
        "menus": menus == null
            ? []
            : List<dynamic>.from(menus!.map((x) => x.toJson())),
        "uiComponents": uiComponents == null
            ? []
            : List<dynamic>.from(uiComponents!.map((x) => x.toJson())),
        "createdDateTime": createdDateTime?.toIso8601String(),
        "createdBy": createdBy,
        "updatedDateTime": updatedDateTime?.toIso8601String(),
        "updatedBy": updatedBy,
      };
}

class MenuList {
  String? menuName;
  List<String>? accessLevels;

  MenuList({
    this.menuName,
    this.accessLevels,
  });

  factory MenuList.fromJson(Map<String, dynamic> json) => MenuList(
        menuName: json["menuName"],
        accessLevels: json["accessLevels"] == null
            ? []
            : List<String>.from(json["accessLevels"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "menuName": menuName,
        "accessLevels": accessLevels == null
            ? []
            : List<dynamic>.from(accessLevels!.map((x) => x)),
      };
}

class UiComponent {
  String? componentName;
  List<String>? accessLevels;

  UiComponent({
    this.componentName,
    this.accessLevels,
  });

  factory UiComponent.fromJson(Map<String, dynamic> json) => UiComponent(
        componentName: json["componentName"],
        accessLevels: json["accessLevels"] == null
            ? []
            : List<String>.from(json["accessLevels"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "componentName": componentName,
        "accessLevels": accessLevels == null
            ? []
            : List<dynamic>.from(accessLevels!.map((x) => x)),
      };
}
