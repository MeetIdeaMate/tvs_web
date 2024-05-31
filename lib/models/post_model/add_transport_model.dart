import 'dart:convert';

AddTransportModel addTransportModelFromJson(String str) =>
    AddTransportModel.fromJson(json.decode(str));

String addTransportModelToJson(AddTransportModel data) =>
    json.encode(data.toJson());

class AddTransportModel {
  String? city;
  String? mobileNo;
  String? transportName;

  AddTransportModel({
    this.city,
    this.mobileNo,
    this.transportName,
  });

  factory AddTransportModel.fromJson(Map<String, dynamic> json) =>
      AddTransportModel(
        city: json["city"],
        mobileNo: json["mobileNo"],
        transportName: json["transportName"],
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "mobileNo": mobileNo,
        "transportName": transportName,
      };
}
