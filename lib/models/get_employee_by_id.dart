class GetEmployeeById {
  String? id;
  String? employeeId;
  String? employeeName;
  String? gender;
  String? designation;
  dynamic branchId;
  dynamic branchName;
  String? emailId;
  String? mobileNumber;
  int? age;
  DateTime? dateOfBirth;
  String? city;
  String? address;

  GetEmployeeById({
    this.id,
    this.employeeId,
    this.employeeName,
    this.gender,
    this.designation,
    this.branchId,
    this.branchName,
    this.emailId,
    this.mobileNumber,
    this.age,
    this.dateOfBirth,
    this.city,
    this.address,
  });

  factory GetEmployeeById.fromJson(Map<String, dynamic> json) =>
      GetEmployeeById(
        id: json["id"],
        employeeId: json["employeeId"],
        employeeName: json["employeeName"],
        gender: json["gender"],
        designation: json["designation"],
        branchId: json["branchId"],
        branchName: json["branchName"],
        emailId: json["emailId"],
        mobileNumber: json["mobileNumber"],
        age: json["age"],
        dateOfBirth: json["dateOfBirth"] == null
            ? null
            : DateTime.parse(json["dateOfBirth"]),
        city: json["city"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employeeId": employeeId,
        "employeeName": employeeName,
        "gender": gender,
        "designation": designation,
        "branchId": branchId,
        "branchName": branchName,
        "emailId": emailId,
        "mobileNumber": mobileNumber,
        "age": age,
        "dateOfBirth":
            "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
        "city": city,
        "address": address,
      };
}
