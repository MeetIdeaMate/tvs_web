import 'package:flutter/material.dart';
import 'package:tlbilling/models/parent_response_model.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/report/purchase_report/purchase_report.dart';
import 'package:tlbilling/view/report/report_screen_bloc.dart';
import 'package:tlbilling/view/report/sale_report/sales_report.dart';
import 'package:tlbilling/view/report/stocks_report/stock_report.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String? selectedReport = 'Purchase Report';
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
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    FutureBuilder<ParentResponseModel>(
                      future: _reportScreenBlocImpl.getConfigByIdModel(
                          configId: 'Report Types'),
                      builder: (context, futureSnapshot) {
                        if (futureSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text(
                            AppConstants.loading,
                            style: TextStyle(fontSize: 15),
                          );
                        } else if (futureSnapshot.hasError) {
                          return Text('${futureSnapshot.error}');
                        } else if (!futureSnapshot.hasData) {
                          return const Text(AppConstants.noData);
                        } else {
                          List<String> reportTypes = futureSnapshot.data?.result
                                  ?.getConfigurationModel?.configuration ??
                              [];
                          return DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedReport,
                              items: reportTypes.map((report) {
                                return DropdownMenuItem<String>(
                                  value: report,
                                  child: AppWidgetUtils.buildHeaderText(report,
                                      fontSize: 18),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                selectedReport = value;
                                _reportScreenBlocImpl
                                    .dropDownChangeStreamController(true);
                              },
                            ),
                          );
                        }
                      },
                    ),
                    const Spacer(),
                    _buildAppBarTitle()
                  ],
                ),
              );
            },
          ),
        ),
      ),
      body: StreamBuilder<bool>(
        stream: _reportScreenBlocImpl.dropDownChangeStream,
        builder: (context, snapshot) {
          return _buildReportBody();
        },
      ),
    );
  }

  Widget _buildReportBody() {
    switch (selectedReport) {
      case 'Purchase Report':
        return const PurchaseReport();
      case 'Sales Report':
        return const SalesReport();
      case 'Stocks Report':
        return const StockReport();
      default:
        return Container();
    }
  }

  Widget _buildAppBarTitle() {
    switch (selectedReport) {
      case 'Purchase Report':
        return Expanded(
          flex: 3,
          child: AppWidgetUtils.buildHeaderText(
              'Over All purchase amount: 10000',
              fontSize: 18),
        );
      case 'Sales Report':
        return Expanded(
          flex: 3,
          child: AppWidgetUtils.buildHeaderText('Over All sales amount: 10000',
              fontSize: 18),
        );
      case 'Stock Report':
        return Expanded(
          flex: 3,
          child: AppWidgetUtils.buildHeaderText('Over All stock amount: 10000',
              fontSize: 18),
        );
      default:
        return const Text('');
    }
  }
}
