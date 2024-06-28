import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:tlbilling/models/get_model/get_all_sales_list_model.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_utils.dart';

class SalesPdfPrinter {
  static Future<Uint8List> generatePdf(Content sale) async {
    final pdf = pw.Document();
    final header = await imageFromAssetBundle(AppConstants.imgPdfHeader);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.portrait,
        margin: const pw.EdgeInsets.all(2),
        header: (context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: PdfColors.black,
                width: 0.5,
              ),
            ),
            height: 100,
            child: pw.Image(header, fit: pw.BoxFit.fitWidth),
          );
        },
        build: (pw.Context context) {
          return [
            pw.Padding(
              padding:
                  const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: pw.Column(
                children: [
                  pw.Center(
                    child: _buildTitleText('VEHICLE INVOICE'),
                  ),
                  pw.SizedBox(height: 18),
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _buildNormalText('To'),
                          _buildNormalText(sale.customerName ?? ''),
                          _buildNormalText(sale.customerId ?? ''),
                          _buildNormalText(sale.mobileNo ?? ''),
                          _buildNormalText('Bill Type: ${sale.billType}'),
                        ],
                      ),
                      _buildNormalText('INVOICE DATE: ${sale.invoiceDate}'),
                    ],
                  ),
                  pw.SizedBox(height: 18),
                  pw.Table(
                    border:
                        pw.TableBorder.all(color: PdfColors.black, width: 0.5),
                    children: [
                      pw.TableRow(
                        children: [
                          _buildText('Particulors'),
                          _buildText('Qty'),
                          _buildText('Rate'),
                          _buildText('HSN code'),
                          _buildText('Disc'),
                          _buildText('Taxable value'),
                        ],
                      ),

                      // Generate table rows for each item in the sale
                      ...sale.itemDetails!.map((item) {
                        return pw.TableRow(
                          children: [
                            _buildText(item.itemName ?? ''),
                            _buildText(item.quantity.toString()),
                            _buildText(
                                AppUtils.formatCurrency(item.unitRate ?? 0)),
                            _buildText(item.hsnSacCode ?? ''),
                            _buildText(AppUtils.formatCurrency(
                                item.discount?.toDouble() ?? 0)),
                            _buildText(AppUtils.formatCurrency(
                                item.taxableValue?.toDouble() ?? 0)),
                          ],
                        );
                      }),
                    ],
                  ),
                  pw.SizedBox(height: 18),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _buildNormalText('Sub total:'),
                          _buildNormalText('SGST %'),
                          _buildNormalText('CGST %'),
                          _buildNormalText('Net Amount:'),
                        ],
                      ),
                      ...sale.itemDetails!.map((item) {
                        return pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _buildNormalText(item.taxableValue.toString()),
                            _buildNormalText(sale.itemDetails!
                                .map((item) => item.gstDetails?.firstWhere(
                                    (element) => element.gstName == 'CGST',
                                    orElse: () => GstDetail(
                                        gstName: 'CGST', gstAmount: 0)))
                                .toString()),
                            _buildNormalText(sale.itemDetails!
                                .map((item) => item.gstDetails?.firstWhere(
                                    (element) => element.gstName == 'SGST',
                                    orElse: () => GstDetail(
                                        gstName: 'SGST', gstAmount: 0)))
                                .toString()),
                            _buildNormalText(item.finalInvoiceValue.toString()),
                          ],
                        );
                      })
                    ],
                  ),
                  pw.SizedBox(height: 18),
                  pw.Table(
                    border:
                        pw.TableBorder.all(color: PdfColors.black, width: 0.5),
                    children: [
                      pw.TableRow(
                        children: [
                          _buildText('Part No'),
                          _buildText('Frame Number'),
                          _buildText('Engine Number'),
                          // _buildText('CWI BookltNo'),
                          // _buildText('Key No'),
                        ],
                      ),
                      ...sale.itemDetails!.map((item) {
                        return pw.TableRow(
                          children: [
                            _buildText(item.partNo ?? ''),
                            _buildText(item.mainSpecValue?.engineNumber ?? ''),
                            _buildText(item.mainSpecValue?.frameNumber ?? ''),
                          ],
                        );
                      }),
                    ],
                  ),
                  pw.SizedBox(height: 18),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _buildNormalText('Ex Showroom Price:'),
                          _buildNormalText('Booking No:'),
                          _buildNormalText('Received \n1.Tools:'),
                          _buildNormalText('2.Manual Book - HardCopy: '),
                          _buildNormalText('3.Duplicate Keys:'),
                        ],
                      ),
                      ...sale.itemDetails!.map((item) {
                        return pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _buildNormalText(sale.roundOffAmt.toString()),
                            _buildNormalText('3905\n\n'),
                            _buildNormalText(sale.mandatoryAddons?.tools ?? ''),
                            _buildNormalText(
                                sale.mandatoryAddons?.manualBook ?? ''),
                            _buildNormalText(
                                sale.mandatoryAddons?.duplicateKey ?? ''),
                          ],
                        );
                      })
                    ],
                  ),
                  pw.SizedBox(height: 18),
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader() {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          color: PdfColors.black,
          width: 0.5,
        ),
      ),
      child: pw.Padding(
        padding: const pw.EdgeInsets.all(16),
        child: pw.Center(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              _buildTitleText('HAASAINI'),
              _buildSubtitleText('MOTORS'),
              pw.SizedBox(height: 8),
              pw.Center(
                child: pw.Text(
                  'HAASINI MOTORS PRIVATE LIMITED\n46 THANJAVUR ROAD, PALAIYAM, PATTUKOTTAI - 614601,\nPh: 9585011115',
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static pw.Widget _buildText(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 9, color: PdfColors.black),
      ),
    );
  }

  static pw.Widget _buildTitleText(String text) {
    return pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 18,
        fontWeight: pw.FontWeight.bold,
      ),
    );
  }

  static pw.Widget _buildSubtitleText(String text) {
    return pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 12,
        fontWeight: pw.FontWeight.bold,
      ),
    );
  }

  static pw.Widget _buildNormalText(String text) {
    return pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 10,
        color: PdfColors.black,
        fontWeight: pw.FontWeight.bold,
      ),
    );
  }
}
