import 'dart:convert';

ParentResponseModel parentResponseModelFromJson(String str) =>
    ParentResponseModel.fromJson(json.decode(str));

String parentResponseModelToJson(ParentResponseModel data) =>
    json.encode(data.toJson());

class ParentResponseModel {
  ResultObj? result;
  dynamic error;
  String? status;
  int? statusCode;

  ParentResponseModel({
    this.result,
    this.error,
    this.status,
    this.statusCode,
  });

  factory ParentResponseModel.fromJson(Map<String, dynamic> json) =>
      ParentResponseModel(
        result:
            json["result"] == null ? null : ResultObj.fromJson(json["result"]),
        error: json["error"],
        status: json["status"],
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "result": result?.toJson(),
        "error": error,
        "status": status,
        "statusCode": statusCode,
      };
}

class ResultObj {
  ResultObj();

  factory ResultObj.fromJson(Map<String, dynamic> json) => ResultObj();

  Map<String, dynamic> toJson() => {};
}
