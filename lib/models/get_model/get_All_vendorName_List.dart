import 'dart:convert';

List<GetAllVendorNameList> getAllVendorNameListFromJson(String str) =>
    List<GetAllVendorNameList>.from(
        json.decode(str).map((x) => GetAllVendorNameList.fromJson(x)));

String getAllVendorNameListToJson(List<GetAllVendorNameList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllVendorNameList {
  String? accountNo;
  String? address;
  String? city;
  String? createdBy;
  DateTime? createdDateTime;
  String? emailId;
  String? gstNumber;
  String? id;
  String? ifscCode;
  String? mobileNo;
  String? updatedBy;
  DateTime? updatedDateTime;
  String? vendorId;
  String? vendorName;

  GetAllVendorNameList({
    this.accountNo,
    this.address,
    this.city,
    this.createdBy,
    this.createdDateTime,
    this.emailId,
    this.gstNumber,
    this.id,
    this.ifscCode,
    this.mobileNo,
    this.updatedBy,
    this.updatedDateTime,
    this.vendorId,
    this.vendorName,
  });

  factory GetAllVendorNameList.fromJson(Map<String, dynamic> json) =>
      GetAllVendorNameList(
        accountNo: json["accountNo"],
        address: json["address"],
        city: json["city"],
        createdBy: json["createdBy"],
        createdDateTime: json["createdDateTime"] == null
            ? null
            : DateTime.parse(json["createdDateTime"]),
        emailId: json["emailId"],
        gstNumber: json["gstNumber"],
        id: json["id"],
        ifscCode: json["ifscCode"],
        mobileNo: json["mobileNo"],
        updatedBy: json["updatedBy"],
        updatedDateTime: json["updatedDateTime"] == null
            ? null
            : DateTime.parse(json["updatedDateTime"]),
        vendorId: json["vendorId"],
        vendorName: json["vendorName"],
      );

  Map<String, dynamic> toJson() => {
        "accountNo": accountNo,
        "address": address,
        "city": city,
        "createdBy": createdBy,
        "createdDateTime": createdDateTime?.toIso8601String(),
        "emailId": emailId,
        "gstNumber": gstNumber,
        "id": id,
        "ifscCode": ifscCode,
        "mobileNo": mobileNo,
        "updatedBy": updatedBy,
        "updatedDateTime": updatedDateTime?.toIso8601String(),
        "vendorId": vendorId,
        "vendorName": vendorName,
      };
}
