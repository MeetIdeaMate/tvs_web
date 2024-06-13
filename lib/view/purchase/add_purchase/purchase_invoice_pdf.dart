import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:tlbilling/models/get_model/get_all_purchase_model.dart';

class PurchaseInvoicePrint {
  Future<void> printDocument(PurchaseBill purchaseData) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        orientation: pw.PageOrientation.landscape,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Container(
                    width: 150,
                    padding: const pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.black),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Techlambdas',
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold)),
                        pw.Text(' Address  1',
                            style: const pw.TextStyle(fontSize: 8)),
                        pw.Text(' Address  2',
                            style: const pw.TextStyle(fontSize: 8)),
                        pw.Text('Phone: +91 9876543210',
                            style: const pw.TextStyle(fontSize: 8)),
                      ],
                    ),
                  ),
                  pw.Container(
                    width: 150,
                    padding: const pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.black),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Vendor Details',
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Vendor: ${purchaseData.vendorName ?? ''}',
                            style: const pw.TextStyle(fontSize: 8)),
                        pw.Text('Vendor ID: ${purchaseData.vendorId ?? ''}',
                            style: const pw.TextStyle(fontSize: 8)),
                      ],
                    ),
                  ),
                  pw.Container(
                    width: 150,
                    padding: const pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.black),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Invoice Details',
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Invoice No: ${purchaseData.pInvoiceNo ?? ''}',
                            style: const pw.TextStyle(fontSize: 8)),
                        pw.Text(
                            'Invoice Date: ${purchaseData.pInvoiceDate?.toIso8601String() ?? ''}',
                            style: const pw.TextStyle(fontSize: 8)),
                        pw.Text('Purchase No: ${purchaseData.purchaseNo ?? ''}',
                            style: const pw.TextStyle(fontSize: 8)),
                        pw.Text(
                            'Purchase Order Ref: ${purchaseData.pOrderRefNo ?? ''}',
                            style: const pw.TextStyle(fontSize: 8)),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
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
                headerStyle:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
                cellStyle: const pw.TextStyle(fontSize: 8),
                data: purchaseData.itemDetails!.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final item = entry.value;
                  return [
                    '$index',
                    item.partNo ?? '',
                    item.itemName ?? '',
                    item.hsnSacCode ?? '',
                    '${item.quantity ?? ''}',
                    '${item.unitRate ?? ''}',
                    '${(item.quantity ?? 0) * (item.unitRate ?? 0)}',
                    '${item.discount ?? ''}',
                    '${item.taxableValue ?? ''}',
                    '${item.gstDetails?.first.percentage ?? ''}',
                    '${item.gstDetails?.first.gstAmount ?? ''}',
                    '${item.gstDetails?.last.percentage ?? ''}',
                    '${item.gstDetails?.last.gstAmount ?? ''}',
                    '', // IGST %
                    '', // IGST Value
                    '${item.finalInvoiceValue ?? ''}',
                    '${item.invoiceValue ?? ''}',
                    '${item.finalInvoiceValue ?? ''}',
                    '', // State Incentive
                    '${item.finalInvoiceValue ?? ''}',
                  ];
                }).toList(),
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: purchaseData.itemDetails!.map((item) {
                  return pw.Container(
                    margin: const pw.EdgeInsets.only(right: 10),
                    width: 300,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.black),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(item.itemName ?? '',
                                style: pw.TextStyle(
                                    fontSize: 8,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(width: 10),
                            pw.Text(item.partNo ?? '',
                                style: pw.TextStyle(
                                    fontSize: 8,
                                    fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                        pw.SizedBox(height: 10),
                        pw.Table.fromTextArray(
                          headers: [
                            'S.No',
                            'Engine No',
                            'Frame No',
                          ],
                          cellAlignment: pw.Alignment.center,
                          headerStyle: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8),
                          cellStyle: const pw.TextStyle(fontSize: 8),
                          data:
                              item.mainSpecValues!.asMap().entries.map((entry) {
                            final index = entry.key + 1;
                            final spec = entry.value;
                            return [
                              '$index',
                              (spec.engineNumber ?? ''),
                              (spec.frameNumber ?? ''),
                            ];
                          }).toList(),
                        ),
                        pw.SizedBox(height: 10),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
