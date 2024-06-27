class AddVocuhar {
  String approvedPay;
  double paidAmount;
  String paidTo;
  String reason;
  String voucherDate;

  AddVocuhar(
      {required this.approvedPay,
      required this.paidAmount,
      required this.paidTo,
      required this.reason,
      required this.voucherDate});

  Map<String, dynamic> toJson() {
    return {
      "approvedPay": approvedPay,
      "paidAmount": paidAmount,
      "paidTo": paidTo,
      "reason": reason,
      "voucherDate": voucherDate,
    };
  }
}
