// To parse this JSON data, do
//
//     final getBookingDetailsByIdModel = getBookingDetailsByIdModelFromJson(jsonString);

import 'dart:convert';

GetBookingDetailsByIdModel getBookingDetailsByIdModelFromJson(String str) => GetBookingDetailsByIdModel.fromJson(json.decode(str));

String getBookingDetailsByIdModelToJson(GetBookingDetailsByIdModel data) => json.encode(data.toJson());

class GetBookingDetailsByIdModel {
    String? additionalInfo;
    String? address;
    DateTime? bookingDate;
    String? bookingNo;
    bool? cancelled;
    String? categoryId;
    String? categoryName;
    String? customerId;
    String? customerName;
    String? executiveId;
    String? executiveName;
    String? itemName;
    String? mobileNo;
    PaidDetail? paidDetail;
    String? partNo;

    GetBookingDetailsByIdModel({
        this.additionalInfo,
        this.address,
        this.bookingDate,
        this.bookingNo,
        this.cancelled,
        this.categoryId,
        this.categoryName,
        this.customerId,
        this.customerName,
        this.executiveId,
        this.executiveName,
        this.itemName,
        this.mobileNo,
        this.paidDetail,
        this.partNo,
    });

    factory GetBookingDetailsByIdModel.fromJson(Map<String, dynamic> json) => GetBookingDetailsByIdModel(
        additionalInfo: json["additionalInfo"],
        address: json["address"],
        bookingDate: json["bookingDate"] == null ? null : DateTime.parse(json["bookingDate"]),
        bookingNo: json["bookingNo"],
        cancelled: json["cancelled"],
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        customerId: json["customerId"],
        customerName: json["customerName"],
        executiveId: json["executiveId"],
        executiveName: json["executiveName"],
        itemName: json["itemName"],
        mobileNo: json["mobileNo"],
        paidDetail: json["paidDetail"] == null ? null : PaidDetail.fromJson(json["paidDetail"]),
        partNo: json["partNo"],
    );

    Map<String, dynamic> toJson() => {
        "additionalInfo": additionalInfo,
        "address": address,
        "bookingDate": "${bookingDate!.year.toString().padLeft(4, '0')}-${bookingDate!.month.toString().padLeft(2, '0')}-${bookingDate!.day.toString().padLeft(2, '0')}",
        "bookingNo": bookingNo,
        "cancelled": cancelled,
        "categoryId": categoryId,
        "categoryName": categoryName,
        "customerId": customerId,
        "customerName": customerName,
        "executiveId": executiveId,
        "executiveName": executiveName,
        "itemName": itemName,
        "mobileNo": mobileNo,
        "paidDetail": paidDetail?.toJson(),
        "partNo": partNo,
    };
}

class PaidDetail {
    int? paidAmount;
    DateTime? paymentDate;
    String? paymentId;
    String? paymentType;

    PaidDetail({
        this.paidAmount,
        this.paymentDate,
        this.paymentId,
        this.paymentType,
    });

    factory PaidDetail.fromJson(Map<String, dynamic> json) => PaidDetail(
        paidAmount: json["paidAmount"],
        paymentDate: json["paymentDate"] == null ? null : DateTime.parse(json["paymentDate"]),
        paymentId: json["paymentId"],
        paymentType: json["paymentType"],
    );

    Map<String, dynamic> toJson() => {
        "paidAmount": paidAmount,
        "paymentDate": "${paymentDate!.year.toString().padLeft(4, '0')}-${paymentDate!.month.toString().padLeft(2, '0')}-${paymentDate!.day.toString().padLeft(2, '0')}",
        "paymentId": paymentId,
        "paymentType": paymentType,
    };
}
