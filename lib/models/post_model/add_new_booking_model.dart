class BookingModel {
  String? additionalInfo;
  String? bookingDate;
  String? customerId;
  String? executiveId;
  PaidDetail? paidDetail;
  String? partNo;
  String? targetInvoiceDate;
  String? branchId;

  BookingModel({
    this.additionalInfo,
    this.bookingDate,
    this.customerId,
    this.executiveId,
    this.paidDetail,
    this.partNo,
    this.targetInvoiceDate,
    this.branchId,
  });

  Map<String, dynamic> toJson() {
    return {
      'additionalInfo': additionalInfo,
      'bookingDate': bookingDate,
      'customerId': customerId,
      'executiveId': executiveId,
      'paidDetail': paidDetail?.toJson(), 
      'partNo': partNo,
      'targetInvoiceDate': targetInvoiceDate,
      'branchId': branchId,
    };
  }
}

class PaidDetail {
  double? paidAmount;
  String? paymentDate;
  String? paymentType;

  PaidDetail({
    this.paidAmount,
    this.paymentDate,
    this.paymentType,
  });

  Map<String, dynamic> toJson() {
    return {
      'paidAmount': paidAmount,
      'paymentDate': paymentDate,
      'paymentType': paymentType,
    };
  }
}
