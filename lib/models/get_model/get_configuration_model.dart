import 'dart:convert';

GetConfigurationModel getConfigurationModelFromJson(String str) =>
    GetConfigurationModel.fromJson(json.decode(str));

String getConfigurationModelToJson(GetConfigurationModel data) =>
    json.encode(data.toJson());

class GetConfigurationModel {
  String? configId;
  String? configType;
  List<String>? configuration;
  String? createdBy;
  DateTime? createdDateTime;
  String? defaultValue;
  String? id;
  String? updatedBy;
  String? inputType;
  DateTime? updatedDateTime;

  GetConfigurationModel(
      {this.configId,
      this.configType,
      this.configuration,
      this.createdBy,
      this.createdDateTime,
      this.defaultValue,
      this.id,
      this.updatedBy,
      this.updatedDateTime,
      this.inputType});

  factory GetConfigurationModel.fromJson(Map<String, dynamic> json) =>
      GetConfigurationModel(
        configId: json["configId"],
        configType: json["configType"],
        configuration: json["configuration"] == null
            ? []
            : List<String>.from(json["configuration"]!.map((x) => x)),
        createdBy: json["createdBy"],
        createdDateTime: json["createdDateTime"] == null
            ? null
            : DateTime.parse(json["createdDateTime"]),
        defaultValue: json["defaultValue"],
        inputType: json["inputType"],
        id: json["id"],
        updatedBy: json["updatedBy"],
        updatedDateTime: json["updatedDateTime"] == null
            ? null
            : DateTime.parse(json["updatedDateTime"]),
      );

  Map<String, dynamic> toJson() => {
        "configId": configId,
        "configType": configType,
        "configuration": configuration == null
            ? []
            : List<dynamic>.from(configuration!.map((x) => x)),
        "createdBy": createdBy,
        "createdDateTime": createdDateTime?.toIso8601String(),
        "defaultValue": defaultValue,
        "inputType": inputType,
        "id": id,
        "updatedBy": updatedBy,
        "updatedDateTime": updatedDateTime?.toIso8601String(),
      };
}
