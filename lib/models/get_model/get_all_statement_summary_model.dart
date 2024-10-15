class StatementSummary {
  String? id;
  String? statementId;
  List<BankStatementSummaryList>? bankStatementSummaryList;

  StatementSummary({
    this.id,
    this.statementId,
    this.bankStatementSummaryList,
  });

  factory StatementSummary.fromJson(Map<String, dynamic> json) =>
      StatementSummary(
        id: json["id"],
        statementId: json["statementId"],
        bankStatementSummaryList: json["bankStatementSummaryList"] == null
            ? []
            : List<BankStatementSummaryList>.from(
                json["bankStatementSummaryList"]!
                    .map((x) => BankStatementSummaryList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "statementId": statementId,
        "bankStatementSummaryList": bankStatementSummaryList == null
            ? []
            : List<dynamic>.from(
                bankStatementSummaryList!.map((x) => x.toJson())),
      };
}

class BankStatementSummaryList {
  String? description;
  String? accountType;
  double? amount;
  String? accountHeadName;
  double? applicationAmt;
  List<SummaryDetail>? summaryDetails;
  bool? missMatch;

  BankStatementSummaryList({
    this.description,
    this.accountType,
    this.amount,
    this.accountHeadName,
    this.applicationAmt,
    this.summaryDetails,
    this.missMatch,
  });

  factory BankStatementSummaryList.fromJson(Map<String, dynamic> json) =>
      BankStatementSummaryList(
        description: json["description"],
        accountType: json["accountType"],
        amount: json["amount"]?.toDouble(),
        accountHeadName: json["accountHeadName"],
        applicationAmt: json["applicationAmt"],
        summaryDetails: json["summaryDetails"] == null
            ? []
            : List<SummaryDetail>.from(
                json["summaryDetails"]!.map((x) => SummaryDetail.fromJson(x))),
        missMatch: json["missMatch"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "accountType": accountType,
        "amount": amount,
        "accountHeadName": accountHeadName,
        "applicationAmt": applicationAmt,
        "summaryDetails": summaryDetails == null
            ? []
            : List<dynamic>.from(summaryDetails!.map((x) => x.toJson())),
        "missMatch": missMatch,
      };
}

class SummaryDetail {
  String? summaryId;
  String? date;
  String? cheque;
  double? amount;
  String? salesBillNo;
  String? partyName;
  String? accountHead;
  double? applicationAmt;
  String? applicationTransactRefId;
  String? description;
  bool? updated;
  bool? missMatch;

  SummaryDetail({
    this.summaryId,
    this.date,
    this.cheque,
    this.amount,
    this.salesBillNo,
    this.partyName,
    this.accountHead,
    this.applicationAmt,
    this.applicationTransactRefId,
    this.description,
    this.updated,
    this.missMatch,
  });

  factory SummaryDetail.fromJson(Map<String, dynamic> json) => SummaryDetail(
        summaryId: json["summaryId"],
        date: json["date"],
        cheque: json["cheque"],
        amount: json["amount"]?.toDouble(),
        salesBillNo: json["salesBillNo"],
        partyName: json["partyName"],
        accountHead: json["accountHead"],
        applicationAmt: json["applicationAmt"],
        applicationTransactRefId: json["applicationTransactRefId"],
        description: json["description"],
        updated: json["updated"],
        missMatch: json["missMatch"],
      );

  Map<String, dynamic> toJson() => {
        "summaryId": summaryId,
        "date": date,
        "cheque": cheque,
        "amount": amount,
        "salesBillNo": salesBillNo,
        "partyName": partyName,
        "accountHead": accountHead,
        "applicationAmt": applicationAmt,
        "applicationTransactRefId": applicationTransactRefId,
        "description": description,
        "updated": updated,
        "missMatch": missMatch,
      };
}
