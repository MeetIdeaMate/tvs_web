class AddEmployeeModel {
  String address;
  int age;
  String branchId;
  String city;
  String designation;
  String emailId;
  String employeeName;
  String gender;
  String mobileNumber;

  AddEmployeeModel(
      {required this.address,
      required this.age,
      required this.branchId,
      required this.city,
      required this.designation,
      required this.emailId,
      required this.employeeName,
      required this.gender,
      required this.mobileNumber});

  Map<String, dynamic> toJson() {
    return {
      "address": address,
      "age": age,
      "branchId": branchId,
      "city": city,
      "designation": designation,
      "emailId": emailId,
      "employeeName": employeeName,
      "gender": gender,
      "mobileNumber": mobileNumber
    };
  }
}
