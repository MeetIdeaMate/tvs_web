class GetAllStatementInfo {
  String? statementId;
  String? fileName;
  String? fromDate;
  String? toDate;

  GetAllStatementInfo({
    this.statementId,
    this.fileName,
    this.fromDate,
    this.toDate,
  });

  factory GetAllStatementInfo.fromJson(Map<String, dynamic> json) =>
      GetAllStatementInfo(
        statementId: json["statementId"],
        fileName: json["fileName"],
        fromDate: json["fromDate"],
        toDate: json["toDate"],
      );

  Map<String, dynamic> toJson() => {
        "statementId": statementId,
        "fileName": fileName,
        "fromDate": fromDate,
        "toDate": toDate,
      };
}
