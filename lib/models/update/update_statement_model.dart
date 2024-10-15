class UpdateStatementModel {
  double amount;
  String checkNo;
  String summaryId;
  String description;

  UpdateStatementModel(
      {required this.amount,
      required this.checkNo,
      required this.summaryId,
      required this.description});
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'checkNo': checkNo,
      'summaryId': summaryId,
      'description': description,
    };
  }
}
