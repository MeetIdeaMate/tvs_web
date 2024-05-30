class GetVendorById {
  String? id;
  String? vendorId;
  String? vendorName;
  String? mobileNo;
  String? accountNo;
  String? ifscCode;
  String? city;
  String? emailId;
  String? gstNumber;
  String? address;
  dynamic createdDateTime;
  dynamic createdBy;
  dynamic updatedDateTime;
  dynamic updatedBy;

  GetVendorById({
    this.id,
    this.vendorId,
    this.vendorName,
    this.mobileNo,
    this.accountNo,
    this.ifscCode,
    this.city,
    this.emailId,
    this.gstNumber,
    this.address,
    this.createdDateTime,
    this.createdBy,
    this.updatedDateTime,
    this.updatedBy,
  });

  factory GetVendorById.fromJson(Map<String, dynamic> json) => GetVendorById(
        id: json["id"],
        vendorId: json["vendorId"],
        vendorName: json["vendorName"],
        mobileNo: json["mobileNo"],
        accountNo: json["accountNo"],
        ifscCode: json["ifscCode"],
        city: json["city"],
        emailId: json["emailId"],
        gstNumber: json["gstNumber"],
        address: json["address"],
        createdDateTime: json["createdDateTime"],
        createdBy: json["createdBy"],
        updatedDateTime: json["updatedDateTime"],
        updatedBy: json["updatedBy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vendorId": vendorId,
        "vendorName": vendorName,
        "mobileNo": mobileNo,
        "accountNo": accountNo,
        "ifscCode": ifscCode,
        "city": city,
        "emailId": emailId,
        "gstNumber": gstNumber,
        "address": address,
        "createdDateTime": createdDateTime,
        "createdBy": createdBy,
        "updatedDateTime": updatedDateTime,
        "updatedBy": updatedBy,
      };
}
