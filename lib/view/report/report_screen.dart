import 'package:flutter/material.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/report/purchase_report/purchase_report.dart';
import 'package:tlbilling/view/report/report_screen_bloc.dart';
import 'package:tlbilling/view/report/sale_report/sales_report.dart';
import 'package:tlbilling/view/report/stocks_report/stock_report.dart';
// Assuming this import exists

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String? selectedReport = 'one';
  final _reportScreenBlocImpl = ReportScreenBlocImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: StreamBuilder<bool>(
              stream: _reportScreenBlocImpl.dropDownChangeStream,
              builder: (context, snapshot) {
                return DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedReport,
                    items: <DropdownMenuItem<String>>[
                      DropdownMenuItem(
                        value: 'one',
                        child: AppWidgetUtils.buildHeaderText(
                            AppConstants.purchaseReport,
                            fontSize: 18),
                      ),
                      DropdownMenuItem(
                        value: 'two',
                        child: AppWidgetUtils.buildHeaderText(
                            AppConstants.salesReport,
                            fontSize: 18),
                      ),
                      DropdownMenuItem(
                        value: 'three',
                        child: AppWidgetUtils.buildHeaderText(
                            AppConstants.stocksReport,
                            fontSize: 18),
                      ),
                    ],
                    onChanged: (String? value) {
                      selectedReport = value;
                      _reportScreenBlocImpl
                          .dropDownChangeStreamController(true);
                    },
                  ),
                );
              }),
        ),
      ),
      body: StreamBuilder<bool>(
          stream: _reportScreenBlocImpl.dropDownChangeStream,
          builder: (context, snapshot) {
            return _buildReportBody();
          }),
    );
  }

  Widget _buildReportBody() {
    switch (selectedReport) {
      case 'one':
        return const PurchaseReport();
      case 'two':
        return const Salesreport();
      case 'three':
        return const StockReport();
      default:
        return Container();
    }
  }
}
