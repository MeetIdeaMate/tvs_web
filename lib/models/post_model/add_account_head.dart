import 'dart:convert';

AccountHeadModel accountHeadModelFromJson(String str) =>
    AccountHeadModel.fromJson(json.decode(str));

String accountHeadModelToJson(AccountHeadModel data) =>
    json.encode(data.toJson());

class AccountHeadModel {
  String? accountHeadCode;
  String? accountHeadName;
  String? accountType;
  bool? activeStatus;
  bool? cashierOps;
  double? maxAmount;
  double? minAmount;
  bool? needPrinting;
  String? pricingFormat;
  String? printingTemplate;
  String? ptVariables;
  String? transferFrom;
  String? transferTo;

  AccountHeadModel({
    this.accountHeadCode,
    this.accountHeadName,
    this.accountType,
    this.activeStatus,
    this.cashierOps,
    this.maxAmount,
    this.minAmount,
    this.needPrinting,
    this.pricingFormat,
    this.printingTemplate,
    this.ptVariables,
    this.transferFrom,
    this.transferTo,
  });

  factory AccountHeadModel.fromJson(Map<String, dynamic> json) =>
      AccountHeadModel(
        accountHeadCode: json["accountHeadCode"],
        accountHeadName: json["accountHeadName"],
        accountType: json["accountType"],
        activeStatus: json["activeStatus"],
        cashierOps: json["cashierOps"],
        maxAmount: json["maxAmount"].toDouble(),
        minAmount: json["minAmount"].toDouble(),
        needPrinting: json["needPrinting"],
        pricingFormat: json["pricingFormat"],
        printingTemplate: json["printingTemplate"],
        ptVariables: json["ptVariables"],
        transferFrom: json["transferFrom"],
        transferTo: json["transferTo"],
      );

  Map<String, dynamic> toJson() => {
        "accountHeadCode": accountHeadCode,
        "accountHeadName": accountHeadName,
        "accountType": accountType,
        "activeStatus": activeStatus,
        "cashierOps": cashierOps,
        "maxAmount": maxAmount,
        "minAmount": minAmount,
        "needPrinting": needPrinting,
        "pricingFormat": pricingFormat,
        "printingTemplate": printingTemplate,
        "ptVariables": ptVariables,
        "transferFrom": transferFrom,
        "transferTo": transferTo,
      };
}
