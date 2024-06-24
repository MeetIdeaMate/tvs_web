import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:tlbilling/models/get_model/get_all_purchase_model.dart';
import 'package:tlbilling/utils/app_utils.dart';

class PurchaseInvoicePrint {
  Future<void> printDocument(PurchaseBill purchaseData) async {
    try {
      final pdf = pw.Document();

      final pw.Font regularFont =
          pw.Font.ttf(await rootBundle.load("assets/fonts/Roboto-Regular.ttf"));

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4.landscape,
          build: (pw.Context context) {
            return [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Container(
                          height: 60,
                          padding: const pw.EdgeInsets.all(5),
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.black),
                          ),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('Techlambdas',
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                      font: regularFont)),
                              pw.Text('Address 1',
                                  style: pw.TextStyle(
                                      fontSize: 8, font: regularFont)),
                              pw.Text('Address 2',
                                  style: pw.TextStyle(
                                      fontSize: 8, font: regularFont)),
                              pw.Text('Phone: +91 9876543210',
                                  style: pw.TextStyle(
                                      fontSize: 8, font: regularFont)),
                            ],
                          ),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Container(
                          height: 60,
                          padding: const pw.EdgeInsets.all(5),
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.black),
                          ),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('Vendor Details',
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                      font: regularFont)),
                              pw.Text(
                                  'Vendor: ${purchaseData.vendorName ?? ''}',
                                  style: pw.TextStyle(
                                      fontSize: 8, font: regularFont)),
                              pw.Text(
                                  'Vendor ID: ${purchaseData.vendorId ?? ''}',
                                  style: pw.TextStyle(
                                      fontSize: 8, font: regularFont)),
                            ],
                          ),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Container(
                          height: 60,
                          padding: const pw.EdgeInsets.all(5),
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.black),
                          ),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('Invoice Details',
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                      font: regularFont)),
                              pw.Text(
                                  'Invoice No: ${purchaseData.pInvoiceNo ?? ''}',
                                  style: pw.TextStyle(
                                      fontSize: 8, font: regularFont)),
                              pw.Text(
                                  'Invoice Date: ${AppUtils.apiToAppDateFormat(purchaseData.pInvoiceDate.toString())}',
                                  style: pw.TextStyle(
                                      fontSize: 8, font: regularFont)),
                              pw.Text(
                                  'Purchase No: ${purchaseData.purchaseNo ?? ''}',
                                  style: pw.TextStyle(
                                      fontSize: 8, font: regularFont)),
                              pw.Text(
                                  'Purchase Order Ref: ${purchaseData.pOrderRefNo ?? ''}',
                                  style: pw.TextStyle(
                                      fontSize: 8, font: regularFont)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  pw.SizedBox(height: 40),
                  pw.Table.fromTextArray(
                    headers: [
                      'S.No',
                      'Part No',
                      'Item Name',
                      'HSN Code',
                      'Qty',
                      'Unit Rate',
                      'Total Value',
                      'Discount',
                      'Taxable Value',
                      'CGST %',
                      'CGST Value',
                      'SGST %',
                      'SGST Value',
                      'IGST %',
                      'IGST Value',
                      'TCS Value',
                      'Invoice Value',
                      'Emps Incentive',
                      'State Incentive',
                      'Final Inv Amount',
                    ],
                    cellAlignment: pw.Alignment.center,
                    headerStyle: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 8,
                        font: regularFont),
                    cellStyle: pw.TextStyle(fontSize: 8, font: regularFont),
                    data: purchaseData.itemDetails
                            ?.asMap()
                            .entries
                            .map((entry) {
                          final index = entry.key + 1;
                          final item = entry.value;

                          double cgstPercent = 0;
                          double cgstValue = 0;
                          double sgstPercent = 0;
                          double sgstValue = 0;
                          double igstPercent = 0;
                          double igstValue = 0;

                          double empsIncentive = item.incentives
                                  ?.firstWhere(
                                      (incentive) =>
                                          incentive.incentiveName ==
                                          'EMPS 2024 Incentive',
                                      orElse: () => Incentive(
                                          incentiveName: '',
                                          incentiveAmount: 0))
                                  .incentiveAmount ??
                              0.0;
                          double stateIncentive = item.incentives
                                  ?.firstWhere(
                                      (incentive) =>
                                          incentive.incentiveName ==
                                          'StateIncentive',
                                      orElse: () => Incentive(
                                          incentiveName: '',
                                          incentiveAmount: 0))
                                  .incentiveAmount ??
                              0.0;

                          double tcsValue = item.taxes
                                  ?.firstWhere(
                                      (tax) => tax.taxName == 'TcsValue',
                                      orElse: () =>
                                          Tax(taxName: '', taxAmount: 0))
                                  .taxAmount ??
                              0.0;

                          if (item.gstDetails != null) {
                            for (var gstDetail in item.gstDetails ?? []) {
                              if (gstDetail.gstName == 'CGST') {
                                cgstPercent = gstDetail.percentage ?? 0;
                                cgstValue = gstDetail.gstAmount ?? 0;
                              } else if (gstDetail.gstName == 'SGST') {
                                sgstPercent = gstDetail.percentage ?? 0;
                                sgstValue = gstDetail.gstAmount ?? 0;
                              } else if (gstDetail.gstName == 'IGST') {
                                igstPercent = gstDetail.percentage ?? 0;
                                igstValue = gstDetail.gstAmount ?? 0;
                              }
                            }
                          }

                          return [
                            '$index',
                            item.partNo ?? '',
                            item.itemName ?? '',
                            item.hsnSacCode ?? '',
                            '${item.quantity ?? ''}',
                            AppUtils.formatCurrency(item.unitRate ?? 0),
                            AppUtils.formatCurrency(
                                (item.quantity ?? 0) * (item.unitRate ?? 0)),
                            AppUtils.formatCurrency(item.discount ?? 0),
                            AppUtils.formatCurrency(item.taxableValue ?? 0),
                            '$cgstPercent %',
                            AppUtils.formatCurrency(cgstValue),
                            '$sgstPercent %',
                            AppUtils.formatCurrency(sgstValue),
                            '$igstPercent %',
                            AppUtils.formatCurrency(igstValue),
                            AppUtils.formatCurrency(tcsValue),
                            AppUtils.formatCurrency(item.invoiceValue ?? 0),
                            AppUtils.formatCurrency(empsIncentive),
                            AppUtils.formatCurrency(stateIncentive),
                            AppUtils.formatCurrency(
                                item.finalInvoiceValue ?? 0),
                          ];
                        }).toList() ??
                        [],
                  ),
                  pw.SizedBox(height: 40),
                  pw.Text('Vehicle Details',
                      style: pw.TextStyle(
                          fontSize: 13,
                          fontWeight: pw.FontWeight.bold,
                          font: regularFont)),
                  pw.SizedBox(height: 20),
                  pw.Wrap(
                    spacing: 50,
                    runSpacing: 30,
                    children: purchaseData.itemDetails?.map((item) {
                          return pw.Container(
                            width: 400,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(item.itemName ?? '',
                                        style: pw.TextStyle(
                                            fontSize: 10,
                                            fontWeight: pw.FontWeight.bold,
                                            font: regularFont)),
                                    pw.SizedBox(width: 10),
                                    pw.Text(item.partNo ?? '',
                                        style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.bold,
                                            font: regularFont)),
                                  ],
                                ),
                                pw.SizedBox(height: 10),
                                pw.Table.fromTextArray(
                                  headers: [
                                    'S.No',
                                    'Engine No',
                                    'Frame No',
                                    '',
                                  ],
                                  cellAlignment: pw.Alignment.center,
                                  headerStyle: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 8,
                                      font: regularFont),
                                  cellStyle: pw.TextStyle(
                                      fontSize: 8, font: regularFont),
                                  data: item.mainSpecValues
                                          ?.asMap()
                                          .entries
                                          .map((entry) {
                                        final index = entry.key + 1;
                                        final spec = entry.value;
                                        return [
                                          '$index',
                                          (spec.engineNumber ?? ''),
                                          (spec.frameNumber ?? ''),
                                          (''),
                                        ];
                                      }).toList() ??
                                      [],
                                ),
                                pw.SizedBox(height: 10),
                              ],
                            ),
                          );
                        }).toList() ??
                        [],
                  ),
                ],
              )
            ];
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      print('Error generating PDF: $e');
    }
  }
}
