import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:tlbilling/models/get_model/get_all_sales_list_model.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';

class SalesPdfPrinter {
  static Future<Uint8List> generatePdf(Content sale) async {
    final pdf = pw.Document();
    final header = await imageFromAssetBundle(AppConstants.imgPdfHeader);

    final pw.Font regularFont =
        pw.Font.ttf(await rootBundle.load("assets/fonts/Roboto-Regular.ttf"));

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
                    child: _buildTitleText('INVOICE', regularFont),
                  ),
                  pw.SizedBox(height: 18),
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _buildNormalText('To', regularFont),
                          _buildNormalText(
                              sale.customerName ?? '', regularFont),
                          _buildNormalText(sale.customerId ?? '', regularFont),
                          _buildNormalText(sale.mobileNo ?? '', regularFont),
                          _buildNormalText(
                              'Bill Type: ${sale.billType}', regularFont),
                        ],
                      ),
                      _buildNormalText(
                          'INVOICE DATE: ${AppUtils.apiToAppDateFormat(sale.invoiceDate.toString())}',
                          regularFont),
                    ],
                  ),
                  pw.SizedBox(height: 18),
                  pw.Table(
                    border:
                        pw.TableBorder.all(color: PdfColors.black, width: 0.5),
                    children: [
                      pw.TableRow(
                        children: [
                          _buildText('Particulors', regularFont),
                          _buildText('Qty', regularFont),
                          _buildText('Rate', regularFont),
                          _buildText('HSN code', regularFont),
                          _buildText('Disc', regularFont),
                          _buildText('Taxable value', regularFont),
                        ],
                      ),
                      ...sale.itemDetails!.map((item) {
                        return pw.TableRow(
                          children: [
                            _buildText(item.itemName ?? '', regularFont),
                            _buildText(item.quantity.toString(), regularFont),
                            _buildText(
                                AppUtils.formatCurrency(item.unitRate ?? 0),
                                regularFont),
                            _buildText(item.hsnSacCode ?? '', regularFont),
                            _buildText(
                                AppUtils.formatCurrency(
                                    item.discount?.toDouble() ?? 0),
                                regularFont),
                            _buildText(
                                AppUtils.formatCurrency(
                                    item.taxableValue?.toDouble() ?? 0),
                                regularFont),
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
                          ...sale.itemDetails!.map((item) {
                            return pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                _buildNormalText(
                                    "Sub Total :${AppUtils.formatCurrency(item.taxableValue ?? 0)}",
                                    regularFont),
                                _buildNormalText(
                                    _formatGstDetails(
                                        sale, 'SGST', regularFont),
                                    regularFont),
                                _buildNormalText(
                                    _formatGstDetails(
                                        sale, 'CGST', regularFont),
                                    regularFont),
                                _buildNormalText(
                                    "Net Amount : ${AppUtils.formatCurrency(
                                        item.finalInvoiceValue ?? 0)}",
                                    regularFont),
                              ],
                            );
                          })
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 18),
                  pw.Table(
                    border:
                        pw.TableBorder.all(color: PdfColors.black, width: 0.5),
                    children: [
                      pw.TableRow(
                        children: [
                          _buildText('Part No', regularFont),
                          _buildText('Frame Number', regularFont),
                          _buildText('Engine Number', regularFont),
                          // _buildText('CWI BookltNo'),
                          // _buildText('Key No'),
                        ],
                      ),
                      ...sale.itemDetails!.map((item) {
                        return pw.TableRow(
                          children: [
                            _buildText(item.partNo ?? '', regularFont),
                            _buildText(item.mainSpecValue?.engineNumber ?? '',
                                regularFont),
                            _buildText(item.mainSpecValue?.frameNumber ?? '',
                                regularFont),
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
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _buildNormalText('Mandatory Addons:', regularFont),
                          pw.SizedBox(height: 18),
                          ...sale.itemDetails!.map((item) {
                            return pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                if (sale.mandatoryAddons != null &&
                                    sale.mandatoryAddons!.addonsMap.isNotEmpty)
                                  ...sale.mandatoryAddons!.addonsMap.entries
                                      .map((entry) => pw.Text(
                                            '${entry.key} : ${entry.value}',
                                            style: pw.TextStyle(
                                              fontSize: 10,
                                              color: PdfColors.black,
                                              font: regularFont,
                                            ),
                                          )),
                              ],
                            );
                          })
                        ],
                      ),
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

  static pw.Widget _buildText(String text, pw.Font regularFont) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
            fontSize: 9, color: PdfColors.black, font: regularFont),
      ),
    );
  }

  static pw.Widget _buildTitleText(String text, pw.Font regularFont) {
    return pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 18,
        fontWeight: pw.FontWeight.bold,
        font: regularFont,
      ),
    );
  }

  static pw.Widget _buildNormalText(String text, pw.Font regularFont) {
    return pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 10,
        color: PdfColors.black,
        fontWeight: pw.FontWeight.bold,
        font: regularFont,
      ),
    );
  }

  static String _formatGstDetails(
      Content sale, String gstName, pw.Font regularFont) {
    final gstDetail = sale.itemDetails!
        .expand((item) => item.gstDetails!)
        .firstWhere((element) => element.gstName == gstName,
            orElse: () => GstDetail(gstName: gstName, gstAmount: 0));

    return '${gstDetail.gstName} (${gstDetail.percentage}%): ${AppUtils.formatCurrency(gstDetail.gstAmount ?? 0)}';
  }
}
