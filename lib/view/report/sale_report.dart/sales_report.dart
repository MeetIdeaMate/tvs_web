import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/components/custom_table_view.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart' as tlbilling_widget;
import 'package:tlbilling/view/report/sale_report.dart/sales_report_bloc.dart';
import 'package:tlds_flutter/components/tlds_date_picker.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';

class Salesreport extends StatefulWidget {
  const Salesreport({super.key});

  @override
  State<Salesreport> createState() => _SalesreportState();
}

class _SalesreportState extends State<Salesreport> {
  final _appColors = AppColors();
  final _saledReportBlocImpl = SaledReportBlocImpl();

  final List<String> columnHeaders = [
    'S.No',
    'Part Number',
    'Vehicle Name',
    'Engine Number',
    'Frame Number',
    'Color',
    'HSN Code',
    'Quantity',
    'Unit Rate',
    'Total Value',
    'Discount',
    'Taxable Value',
  ];

  List<Map<String, String>> rowData = [
    {
      AppConstants.sno: '1',
      AppConstants.partNumber: 'PN001',
      AppConstants.vehicleName: 'Toyota Camry',
      AppConstants.engineNumber: 'EN001',
      AppConstants.frameNumber: 'FR001',
      AppConstants.color: 'White',
      AppConstants.hsnCode: '87089900',
      AppConstants.quantity: '10',
      AppConstants.unitRate: '5000',
      AppConstants.totalValue: '50000',
      AppConstants.discount: '1000',
      AppConstants.taxableValue: '49000',
    },
    {
      AppConstants.sno: '2',
      AppConstants.partNumber: 'PN002',
      AppConstants.vehicleName: 'Honda Accord',
      AppConstants.engineNumber: 'EN002',
      AppConstants.frameNumber: 'FR002',
      AppConstants.color: 'Black',
      AppConstants.hsnCode: '87089900',
      AppConstants.quantity: '5',
      AppConstants.unitRate: '7000',
      AppConstants.totalValue: '35000',
      AppConstants.discount: '500',
      AppConstants.taxableValue: '34500',
    },
    {
      AppConstants.sno: '3',
      AppConstants.partNumber: 'PN003',
      AppConstants.vehicleName: 'BMW 3 Series',
      AppConstants.engineNumber: 'EN003',
      AppConstants.frameNumber: 'FR003',
      AppConstants.color: 'Blue',
      AppConstants.hsnCode: '87089900',
      AppConstants.quantity: '8',
      AppConstants.unitRate: '12000',
      AppConstants.totalValue: '96000',
      AppConstants.discount: '2000',
      AppConstants.taxableValue: '94000',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  TldsInputFormField(
                      suffixIcon: SvgPicture.asset(
                        AppConstants.icSearch,
                        fit: BoxFit.none,
                      ),
                      width: MediaQuery.of(context).size.width * 0.14,
                      hintText: AppConstants.vehicleName,
                      fontSize: 14,
                      height: 40,
                      controller: _saledReportBlocImpl.customerNameEditText),
                  tlbilling_widget.AppWidgetUtils.buildSizedBox(custWidth: 5),
                  TldsDatePicker(
                      height: 40,
                      suffixIcon: SvgPicture.asset(
                        AppConstants.icDate,
                        colorFilter: ColorFilter.mode(
                            _appColors.primaryColor, BlendMode.srcIn),
                      ),
                      fontSize: 14,
                      width: MediaQuery.of(context).size.width * 0.1,
                      hintText: AppConstants.fromDate,
                      controller: _saledReportBlocImpl.fromDateEditText),
                  tlbilling_widget.AppWidgetUtils.buildSizedBox(custWidth: 5),
                  TldsDatePicker(
                      fontSize: 14,
                      height: 40,
                      suffixIcon: SvgPicture.asset(
                        AppConstants.icDate,
                        colorFilter: ColorFilter.mode(
                            _appColors.primaryColor, BlendMode.srcIn),
                      ),
                      width: MediaQuery.of(context).size.width * 0.1,
                      hintText: AppConstants.toDate,
                      controller: _saledReportBlocImpl.toDateEditText),
                  tlbilling_widget.AppWidgetUtils.buildSizedBox(custWidth: 5),
                ],
              ),
            ),
          ],
        ),
        CustomTableView(columnHeaders: columnHeaders, rowData: rowData)
      ],
    );
  }
}
