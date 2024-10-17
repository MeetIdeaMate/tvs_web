class Statement {
  String? id;
  String? statementId;
  String? accountNumber;
  String? customerName;
  String? fromDate;
  String? toDate;
  double? openingBalance;
  List<Transaction>? transactions;
  double? closingBalance;
  String? statementDate;
  String? fileName;

  Statement({
    this.id,
    this.statementId,
    this.accountNumber,
    this.customerName,
    this.fromDate,
    this.toDate,
    this.openingBalance,
    this.transactions,
    this.closingBalance,
    this.statementDate,
    this.fileName,
  });

  factory Statement.fromJson(Map<String, dynamic> json) => Statement(
        id: json["id"],
        statementId: json["statementId"],
        accountNumber: json["accountNumber"],
        customerName: json["customerName"],
        fromDate: json["fromDate"],
        toDate: json["toDate"],
        openingBalance: json["openingBalance"],
        transactions: json["transactions"] == null
            ? []
            : List<Transaction>.from(
                json["transactions"]!.map((x) => Transaction.fromJson(x))),
        closingBalance: json["closingBalance"],
        statementDate: json["statementDate"],
        fileName: json["fileName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "statementId": statementId,
        "accountNumber": accountNumber,
        "customerName": customerName,
        "fromDate": fromDate,
        "toDate": toDate,
        "openingBalance": openingBalance,
        "transactions": transactions == null
            ? []
            : List<dynamic>.from(transactions!.map((x) => x.toJson())),
        "closingBalance": closingBalance,
        "statementDate": statementDate,
        "fileName": fileName,
      };
}

class Transaction {
  String? transactionId;
  String? date;
  String? description;
  double? debit;
  double? credit;
  double? balance;
  String? paymentType;

  Transaction({
    this.transactionId,
    this.date,
    this.description,
    this.debit,
    this.credit,
    this.balance,
    this.paymentType,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        transactionId: json["transactionId"],
        date: json["date"],
        description: json["description"],
        debit: json["debit"],
        credit: json["credit"],
        balance: json["balance"],
        paymentType: json["paymentType"],
      );

  Map<String, dynamic> toJson() => {
        "transactionId": transactionId,
        "date": "$date",
        "description": description,
        "debit": debit,
        "credit": credit,
        "balance": balance,
        "paymentType": paymentType,
      };
}
