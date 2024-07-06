// To parse this JSON data, do
//
//     final getBookingListWithPagination = getBookingListWithPaginationFromJson(jsonString);

import 'dart:convert';

GetBookingListWithPagination getBookingListWithPaginationFromJson(String str) =>
    GetBookingListWithPagination.fromJson(json.decode(str));

String getBookingListWithPaginationToJson(GetBookingListWithPagination data) =>
    json.encode(data.toJson());

class GetBookingListWithPagination {
  List<BookingDetails>? bookingDetails;
  Pageable? pageable;
  int? totalPages;
  int? totalElements;
  bool? last;
  int? size;
  int? number;
  Sort? sort;
  int? numberOfElements;
  bool? first;
  bool? empty;

  GetBookingListWithPagination({
    this.bookingDetails,
    this.pageable,
    this.totalPages,
    this.totalElements,
    this.last,
    this.size,
    this.number,
    this.sort,
    this.numberOfElements,
    this.first,
    this.empty,
  });

  factory GetBookingListWithPagination.fromJson(Map<String, dynamic> json) =>
      GetBookingListWithPagination(
        bookingDetails: json["content"] == null
            ? []
            : List<BookingDetails>.from(
                json["content"]!.map((x) => BookingDetails.fromJson(x))),
        pageable: json["pageable"] == null
            ? null
            : Pageable.fromJson(json["pageable"]),
        totalPages: json["totalPages"],
        totalElements: json["totalElements"],
        last: json["last"],
        size: json["size"],
        number: json["number"],
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        numberOfElements: json["numberOfElements"],
        first: json["first"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "content": bookingDetails == null
            ? []
            : List<dynamic>.from(bookingDetails!.map((x) => x.toJson())),
        "pageable": pageable?.toJson(),
        "totalPages": totalPages,
        "totalElements": totalElements,
        "last": last,
        "size": size,
        "number": number,
        "sort": sort?.toJson(),
        "numberOfElements": numberOfElements,
        "first": first,
        "empty": empty,
      };
}

class BookingDetails {
  String? bookingNo;
  DateTime? bookingDate;
  String? customerId;
  String? customerName;
  String? mobileNo;
  String? address;
  String? partNo;
  String? categoryId;
  String? categoryName;
  String? itemName;
  String? additionalInfo;
  PaidDetail? paidDetail;
  String? executiveId;
  String? executiveName;
  bool? cancelled;
  String? branchName;
  DateTime? targetInvoiceDate;

  BookingDetails({
    this.bookingNo,
    this.bookingDate,
    this.customerId,
    this.customerName,
    this.mobileNo,
    this.address,
    this.partNo,
    this.categoryId,
    this.categoryName,
    this.itemName,
    this.additionalInfo,
    this.paidDetail,
    this.executiveId,
    this.executiveName,
    this.cancelled,
    this.branchName,
    this.targetInvoiceDate,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) => BookingDetails(
      bookingNo: json["bookingNo"],
      bookingDate: json["bookingDate"] == null
          ? null
          : DateTime.parse(json["bookingDate"]),
      customerId: json["customerId"],
      customerName: json["customerName"],
      mobileNo: json["mobileNo"],
      address: json["address"],
      partNo: json["partNo"],
      categoryId: json["categoryId"],
      categoryName: json["categoryName"],
      itemName: json["itemName"],
      additionalInfo: json["additionalInfo"],
      targetInvoiceDate: json["targetInvoiceDate"] == null
          ? null
          : DateTime.parse(json["targetInvoiceDate"]),
      paidDetail: json["paidDetail"] == null
          ? null
          : PaidDetail.fromJson(json["paidDetail"]),
      executiveId: json["executiveId"],
      executiveName: json["executiveName"],
      cancelled: json["cancelled"],
      branchName: json['branchName']);

  Map<String, dynamic> toJson() => {
        "bookingNo": bookingNo,
        "bookingDate":
            "${bookingDate!.year.toString().padLeft(4, '0')}-${bookingDate!.month.toString().padLeft(2, '0')}-${bookingDate!.day.toString().padLeft(2, '0')}",
        "customerId": customerId,
        "customerName": customerName,
        "mobileNo": mobileNo,
        "address": address,
        "partNo": partNo,
        "categoryId": categoryId,
        "categoryName": categoryName,
        "itemName": itemName,
        "additionalInfo": additionalInfo,
        "paidDetail": paidDetail?.toJson(),
        "executiveId": executiveId,
        "executiveName": executiveName,
        "cancelled": cancelled,
        'branchName': branchName,
        "targetInvoiceDate":
            "${targetInvoiceDate!.year.toString().padLeft(4, '0')}-${targetInvoiceDate!.month.toString().padLeft(2, '0')}-${targetInvoiceDate!.day.toString().padLeft(2, '0')}",
      };
}

class PaidDetail {
  dynamic paymentId;
  DateTime? paymentDate;
  int? paidAmount;
  String? paymentType;

  PaidDetail({
    this.paymentId,
    this.paymentDate,
    this.paidAmount,
    this.paymentType,
  });

  factory PaidDetail.fromJson(Map<String, dynamic> json) => PaidDetail(
        paymentId: json["paymentId"],
        paymentDate: json["paymentDate"] == null
            ? null
            : DateTime.parse(json["paymentDate"]),
        paidAmount: json["paidAmount"],
        paymentType: json["paymentType"],
      );

  Map<String, dynamic> toJson() => {
        "paymentId": paymentId,
        "paymentDate":
            "${paymentDate!.year.toString().padLeft(4, '0')}-${paymentDate!.month.toString().padLeft(2, '0')}-${paymentDate!.day.toString().padLeft(2, '0')}",
        "paidAmount": paidAmount,
        "paymentType": paymentType,
      };
}

class Pageable {
  Sort? sort;
  int? offset;
  int? pageNumber;
  int? pageSize;
  bool? paged;
  bool? unpaged;

  Pageable({
    this.sort,
    this.offset,
    this.pageNumber,
    this.pageSize,
    this.paged,
    this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        offset: json["offset"],
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        paged: json["paged"],
        unpaged: json["unpaged"],
      );

  Map<String, dynamic> toJson() => {
        "sort": sort?.toJson(),
        "offset": offset,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "paged": paged,
        "unpaged": unpaged,
      };
}

class Sort {
  bool? empty;
  bool? sorted;
  bool? unsorted;

  Sort({
    this.empty,
    this.sorted,
    this.unsorted,
  });

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        empty: json["empty"],
        sorted: json["sorted"],
        unsorted: json["unsorted"],
      );

  Map<String, dynamic> toJson() => {
        "empty": empty,
        "sorted": sorted,
        "unsorted": unsorted,
      };
}
