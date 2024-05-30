class AddVendorModel {
  String accountNo;
  String address;
  String city;
  String emailId;
  String gstNumber;
  String ifscCode;
  String mobileNo;
  String vendorName;

  AddVendorModel(
      {required this.accountNo,
      required this.address,
      required this.city,
      required this.emailId,
      required this.gstNumber,
      required this.ifscCode,
      required this.mobileNo,
      required this.vendorName});

  Map<String, dynamic> toJson() {
    return {
      "accountNo": accountNo,
      "address": address,
      "city": city,
      "emailId": emailId,
      "gstNumber": gstNumber,
      "ifscCode": ifscCode,
      "mobileNo": mobileNo,
      "vendorName": vendorName
    };
  }
}
