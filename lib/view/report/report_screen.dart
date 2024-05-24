import 'package:flutter/material.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/report/purchase_report.dart/purchase_report.dart';
import 'package:tlbilling/view/report/report_screen_bloc.dart';
import 'package:tlbilling/view/report/sale_report.dart/sales_report.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with SingleTickerProviderStateMixin {
  final _reportScreenBlocImpl = ReportScreenBlocImpl();
  String? selectedReport;

  @override
  void initState() {
    super.initState();
    _reportScreenBlocImpl.reportScreenTabController =
        TabController(length: 2, vsync: this);
    // _reportScreenBlocImpl.reportScreenTabController
    //     .addListener(_updateHeaderText);
    _reportScreenBlocImpl.reportScreenTabController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Theme(
          data: ThemeData.light(),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedReport,
              items: <DropdownMenuItem<String>>[
                DropdownMenuItem(
                  value: 'one',
                  child: AppWidgetUtils.buildHeaderText('purchase Report'),
                ),
                DropdownMenuItem(
                  value: 'two',
                  child: AppWidgetUtils.buildHeaderText('sales Report'),
                ),
                DropdownMenuItem(
                  value: 'three',
                  child: AppWidgetUtils.buildHeaderText('stocks Report'),
                ),
              ],
              onChanged: (String? value) {
                setState(() => selectedReport = value);
                if (selectedReport == 'one') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PurchaseReport()),
                  );
                } else if (selectedReport == 'two') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Salesreport()),
                  );
                } else if (selectedReport == 'three') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PurchaseReport()),
                  );
                }
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTabBar(),
            AppWidgetUtils.buildSizedBox(custHeight: 16),
            _buildTabBarView(),
          ],
        ),
      ),
    );
  }

  String _getHeaderText() {
    if (_reportScreenBlocImpl.reportScreenTabController.index == 0) {
      return 'Over All vechile Total amount: 10000';
    } else {
      return 'Over All accessories Total amount: 10000';
    }
  }

  String _overAllAmount() {
    if (_reportScreenBlocImpl.reportScreenTabController.index == 0) {
      return 'OverAll  sales amount: 10000';
    } else {
      return 'Over All accessories Total amount: 10000';
    }
  }

  _buildTabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TabBar(
            controller: _reportScreenBlocImpl.reportScreenTabController,
            tabs: const [
              Tab(text: AppConstants.vehicle),
              Tab(text: AppConstants.accessories),
            ],
          ),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 20),
        Expanded(
          child: AppWidgetUtils.buildHeaderText(_getHeaderText(), fontSize: 18),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 10),
        Expanded(
            child:
                AppWidgetUtils.buildHeaderText(_overAllAmount(), fontSize: 18))
      ],
    );
  }

  _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _reportScreenBlocImpl.reportScreenTabController,
        children: const [PurchaseReport(), Salesreport()],
      ),
    );
  }
}
