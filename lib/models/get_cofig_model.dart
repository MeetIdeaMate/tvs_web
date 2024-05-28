class ConfigModel {
  String? id;
  String? configId;
  List<String>? configuration;
  String? defaultValue;
  String? configType;
  dynamic createdDateTime;
  dynamic createdBy;
  dynamic updatedDateTime;
  dynamic updatedBy;

  ConfigModel({
    this.id,
    this.configId,
    this.configuration,
    this.defaultValue,
    this.configType,
    this.createdDateTime,
    this.createdBy,
    this.updatedDateTime,
    this.updatedBy,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
        id: json["id"],
        configId: json["configId"],
        configuration: json["configuration"] == null
            ? []
            : List<String>.from(json["configuration"]!.map((x) => x)),
        defaultValue: json["defaultValue"],
        configType: json["configType"],
        createdDateTime: json["createdDateTime"],
        createdBy: json["createdBy"],
        updatedDateTime: json["updatedDateTime"],
        updatedBy: json["updatedBy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "configId": configId,
        "configuration": configuration == null
            ? []
            : List<dynamic>.from(configuration!.map((x) => x)),
        "defaultValue": defaultValue,
        "configType": configType,
        "createdDateTime": createdDateTime,
        "createdBy": createdBy,
        "updatedDateTime": updatedDateTime,
        "updatedBy": updatedBy,
      };
}
