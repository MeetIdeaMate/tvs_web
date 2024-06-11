import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';

class PdfPrinter {
  static Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.portrait,
        margin: const pw.EdgeInsets.all(2),
        header: (pw.Context context) => _buildHeader(),
        build: (pw.Context context) {
          List<Map<String, String>> rowData = [
            {
              'S.No': '1',
              'Date': '2024-05-01',
              'Vehicle Name': 'Toyota Camry',
              'HSN Code': '87089900',
              'Qty': '10',
              'Unit Rate': '5000',
              'Total Value': '50000',
              'Taxable Value': '45000',
              'CGST ': '2250',
              'SGST ': '2250',
              'Tot Inv Value': '49500',
            },
            {
              'S.No': '2',
              'Date': '2024-05-02',
              'Vehicle Name': 'Honda Accord',
              'HSN Code': '87089900',
              'Qty': '5',
              'Unit Rate': '7000',
              'Total Value': '35000',
              'Taxable Value': '31500',
              'CGST ': '1575',
              'SGST ': '1575',
              'Tot Inv Value': '34650',
            },
            {
              'S.No': '3',
              'Date': '2024-05-03',
              'Vehicle Name': 'BMW 3 Series',
              'HSN Code': '87089900',
              'Qty': '8',
              'Unit Rate': '12000',
              'Total Value': '96000',
              'Taxable Value': '86400',
              'CGST ': '4320',
              'SGST ': '4320',
              'Tot Inv Value': '95040',
            }
          ];
          List<String> columnHeaders = [
            'S.No',
            'Date',
            'Vehicle Name',
            'HSN Code',
            'Qty',
            'Unit Rate',
            'Total Value',
            'Taxable Value',
            'CGST ',
            'SGST ',
            'Tot Inv Value'
          ];

          final List<pw.TableRow> tableRows = [];
          tableRows.add(pw.TableRow(
            children:
                columnHeaders.map((header) => _buildText(header)).toList(),
          ));

          int serialNumber = 0;
          for (final report in rowData) {
            serialNumber++;
            tableRows.add(pw.TableRow(children: [
              _buildText(serialNumber.toString()),
              _buildText(report['Date'] ?? ''),
              _buildText(report['Vehicle Name'] ?? ''),
              _buildText(report['HSN Code'] ?? ''),
              _buildText(report['Qty'] ?? ''),
              _buildText(report['Unit Rate'] ?? ''),
              _buildText(report['Total Value'] ?? ''),
              _buildText(report['Taxable Value'] ?? ''),
              _buildText(report['CGST '] ?? ''),
              _buildText(report['SGST '] ?? ''),
              _buildText(report['Tot Inv Value'] ?? ''),
            ]));
          }

          return [
            pw.Padding(
                padding:
                    const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                child: pw.Column(children: [
                  pw.Center(
                    child: _buildTitleText('Sales report'),
                  ),
                  pw.SizedBox(height: 18),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        _buildNormalText('Type: Vehicle'),
                        _buildNormalText('Date: 01-01-2024 - 24-05-2024')
                      ]),
                  pw.SizedBox(height: 18),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        _buildNormalText('Variant Type: All'),
                        pw.SizedBox(width: 10),
                        _buildNormalText('Branch: Haasini'),
                        _buildNormalText('Overall Amount: 1,00,00,000')
                      ]),
                  pw.SizedBox(height: 18),
                  pw.Table(
                    children: tableRows,
                    border: pw.TableBorder.all(),
                  )
                ]))
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
      style: const pw.TextStyle(
        fontSize: 12,
        color: PdfColors.black,
      ),
    );
  }
}
