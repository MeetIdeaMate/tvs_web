class BookingModel {
  String additionalInfo;
  String bookingDate;
  String customerId;
  String executiveId;
  PaidDetail paidDetail;
  String partNo;
  String targetInvoiceDate;
  String branchId;

  BookingModel(
      {required this.additionalInfo,
      required this.bookingDate,
      required this.customerId,
      required this.executiveId,
      required this.paidDetail,
      required this.partNo,
      required this.targetInvoiceDate,
      required this.branchId});

  Map<String, dynamic> toJson() {
    return {
      'additionalInfo': additionalInfo,
      'bookingDate': bookingDate,
      'customerId': customerId,
      'executiveId': executiveId,
      'paidDetail': paidDetail.toJson(),
      'partNo': partNo,
      'targetInvoiceDate': targetInvoiceDate,
      'branchId': branchId
    };
  }
}

class PaidDetail {
  double paidAmount;
  String paymentDate;
  String paymentType;

  PaidDetail({
    required this.paidAmount,
    required this.paymentDate,
    required this.paymentType,
  });

  Map<String, dynamic> toJson() {
    return {
      'paidAmount': paidAmount,
      'paymentDate': paymentDate,
      'paymentType': paymentType,
    };
  }
}
