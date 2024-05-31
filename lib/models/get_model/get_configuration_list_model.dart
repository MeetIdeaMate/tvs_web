class GetAllConfigurationListModel {
  String? id;
  String? configId;
  List<String>? configuration;
  String? defaultValue;
  DateTime? createdDateTime;
  String? createdBy;
  DateTime? updatedDateTime;
  String? updatedBy;

  GetAllConfigurationListModel({
    this.id,
    this.configId,
    this.configuration,
    this.defaultValue,
    this.createdDateTime,
    this.createdBy,
    this.updatedDateTime,
    this.updatedBy,
  });

  factory GetAllConfigurationListModel.fromJson(Map<String, dynamic> json) =>
      GetAllConfigurationListModel(
        id: json["id"],
        configId: json["configId"],
        configuration: json["configuration"] == null
            ? []
            : List<String>.from(json["configuration"]!.map((x) => x)),
        defaultValue: json["defaultValue"],
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
        "configId": configId,
        "configuration": configuration == null
            ? []
            : List<dynamic>.from(configuration!.map((x) => x)),
        "defaultValue": defaultValue,
        "createdDateTime": createdDateTime?.toIso8601String(),
        "createdBy": createdBy,
        "updatedDateTime": updatedDateTime?.toIso8601String(),
        "updatedBy": updatedBy,
      };
}
