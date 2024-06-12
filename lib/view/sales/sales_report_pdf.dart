import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:printing/printing.dart';
import 'package:tlbilling/utils/app_constants.dart';

class SalesPdfPrinter {
  static Future<Uint8List> generatePdf() async {
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
                          _buildNormalText(
                              'KARIYAYAN C \nS/O CHELLAYAN\nNO 53 NORTH STREET\nBALATHALI\nPATTUKOTTAI,THANJAVUR - 614601\nTamil Nadu'),
                          _buildNormalText('Mob: 9655515001'),
                          _buildNormalText('Bill Type : Credit'),
                        ],
                      ),
                      _buildNormalText('INVOICE DATE: 28-05-2024')
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
                      pw.TableRow(
                        children: [
                          _buildText('APACHE-TVS\nAPACHE RTR 160'),
                          _buildText('1'),
                          _buildText(' 1,05,460.94'),
                          _buildText('87654324'),
                          _buildText('0.00'),
                          _buildText(' 1,05,460.94')
                        ],
                      ),
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
                          _buildNormalText('SGST % (14 %):'),
                          _buildNormalText('CGST % (14 %):'),
                          _buildNormalText('Net Amount:'),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _buildNormalText('14,764.53'),
                          _buildNormalText('14,764.53'),
                          _buildNormalText('14,764.53'),
                          _buildNormalText('1,34,990.00'),
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
                          _buildText('Part Description'),
                          _buildText('Frame Number'),
                          _buildText('Engine Number'),
                          _buildText('CWI BookltNo'),
                          _buildText('Key No'),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          _buildText(
                              'APACHE-TVS APACHE RTR 1604V-OBDIIARM 2CH BT M.BLK'),
                          _buildText('MD637GE5XR2C05053'),
                          _buildText('GE5CR2004773'),
                          _buildText('87654324'),
                          _buildText('12345'),
                        ],
                      ),
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
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _buildNormalText('1,34,990.00'),
                          _buildNormalText('3905\n\n'),
                          _buildNormalText('(Y / N)'),
                          _buildNormalText('(Y / N)'),
                          _buildNormalText('(Y / N)'),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 18),
                ],
              ),
            )
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
