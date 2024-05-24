import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/components/custom_table_view.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/view/report/purchase_report.dart/purchase_report_bloc.dart';
import 'package:tlds_flutter/export.dart';
import 'package:tlbilling/utils/app_util_widgets.dart' as tlbillingWidget;

class PurchaseReport extends StatefulWidget {
  const PurchaseReport({super.key});

  @override
  State<PurchaseReport> createState() => _PurchaseReportState();
}

class _PurchaseReportState extends State<PurchaseReport> {
  final _purchaseReportBlocImpl = PurchaseReportBlocImpl();
  final _appColors = AppColor();
  final List<String> vehicles = [
    'Toyota Camry',
    'Honda Accord',
    'BMW 3 Series',
    'Mercedes-Benz C-Class',
    'Audi A4',
  ];

  final List<String> columnHeaders = [
    'S.No',
    'Part Number',
    'Vehicle Name',
    'HSN Code',
    'Quantity',
    'Unit Rate',
    'Total Value',
    'Discount',
    'Taxable Value',
    'CGST %',
    'CGST ₹',
    'SGST %',
    'SGST ₹',
  ];

  List<Map<String, String>> rowData = [
    {
      AppConstants.sno: '1',
      AppConstants.partNumber: 'PN001',
      AppConstants.vehicleName: 'Toyota Camry',
      AppConstants.hsnCode: '87089900',
      AppConstants.quantity: '10',
      AppConstants.unitRate: '5000',
      AppConstants.totalValue: '50000',
      AppConstants.discount: '1000',
      AppConstants.taxableValue: '49000',
      AppConstants.cgstPercent: '9%',
      AppConstants.cgstAmount: '4410',
      AppConstants.sgstPercent: '9%',
      AppConstants.sgstAmount: '4410',
    },
    {
      AppConstants.sno: '2',
      AppConstants.partNumber: 'PN002',
      AppConstants.vehicleName: 'Honda Accord',
      AppConstants.hsnCode: '87089900',
      AppConstants.quantity: '5',
      AppConstants.unitRate: '7000',
      AppConstants.totalValue: '35000',
      AppConstants.discount: '500',
      AppConstants.taxableValue: '34500',
      AppConstants.cgstPercent: '9%',
      AppConstants.cgstAmount: '3105',
      AppConstants.sgstPercent: '9%',
      AppConstants.sgstAmount: '3105',
    },
    {
      AppConstants.sno: '3',
      AppConstants.partNumber: 'PN003',
      AppConstants.vehicleName: 'BMW 3 Series',
      AppConstants.hsnCode: '87089900',
      AppConstants.quantity: '8',
      AppConstants.unitRate: '12000',
      AppConstants.totalValue: '96000',
      AppConstants.discount: '2000',
      AppConstants.taxableValue: '94000',
      AppConstants.cgstPercent: '9%',
      AppConstants.cgstAmount: '8460',
      AppConstants.sgstPercent: '9%',
      AppConstants.sgstAmount: '8460',
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilters(context),
        // _buildDataTable(context)
        CustomTableView(
          columnHeaders: columnHeaders,
          rowData: rowData,
        )
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Row(children: [
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
                controller: _purchaseReportBlocImpl.selectedVehicleName),
            AppWidgetUtils.buildSizedBox(custWidth: 5),
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
                controller: _purchaseReportBlocImpl.fromDateEditText),
            AppWidgetUtils.buildSizedBox(custWidth: 5),
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
                controller: _purchaseReportBlocImpl.toDateEditText),
            tlbillingWidget.AppWidgetUtils.buildSizedBox(custWidth: 5),
          ],
        ),
      ),
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: TldsDropDownButtonFormField(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.08,
                dropDownItems: vehicles,
                hintText: AppConstants.billType,
                onChange: (value) {
                  setState(() {
                    _purchaseReportBlocImpl.selectedBillType = value;
                  });
                },
              ),
            ),
            tlbillingWidget.AppWidgetUtils.buildSizedBox(custWidth: 20),
            const Spacer(),
            tlbillingWidget.AppWidgetUtils.buildAddbutton(
                width: MediaQuery.of(context).size.width * 0.1,
                context,
                onPressed: () {},
                text: AppConstants.pdfGeneration)
          ],
        ),
      )
    ]);
  }

  // _buildDataTable(BuildContext context) {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.vertical,
  //     child: SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       child: DataTable(
  //         dividerThickness: 0.01,
  //         columns: [
  //           _buildTableHeader(AppConstants.sno),
  //           _buildTableHeader(AppConstants.partNumber),
  //           _buildTableHeader(AppConstants.vehicleName),
  //           _buildTableHeader(AppConstants.hsnCode),
  //           _buildTableHeader(AppConstants.quantity),
  //           _buildTableHeader(AppConstants.unitRate),
  //           _buildTableHeader(AppConstants.totalValue),
  //           _buildTableHeader(AppConstants.discount),
  //           _buildTableHeader(AppConstants.taxableValue),
  //           _buildTableHeader(AppConstants.cgstPercent),
  //           _buildTableHeader(AppConstants.cgstAmount),
  //           _buildTableHeader(AppConstants.sgstPercent),
  //           _buildTableHeader(AppConstants.sgstAmount),
  //         ],
  //         rows: List.generate(rowData.length, (index) {
  //           final data = rowData[index];
  //           final color =
  //               index.isEven ? Colors.white : Colors.blue.withOpacity(0.1);
  //           return DataRow(
  //             color: MaterialStateColor.resolveWith((states) => color),
  //             cells: [
  //               DataCell(Text(data[AppConstants.sno]!)),
  //               DataCell(Text(data[AppConstants.partNumber]!)),
  //               DataCell(Text(data[AppConstants.vehicleName]!)),
  //               DataCell(Text(data[AppConstants.hsnCode]!)),
  //               DataCell(Text(data[AppConstants.quantity]!)),
  //               DataCell(Text(data[AppConstants.unitRate]!)),
  //               DataCell(Text(data[AppConstants.totalValue]!)),
  //               DataCell(Text(data[AppConstants.discount]!)),
  //               DataCell(Text(data[AppConstants.taxableValue]!)),
  //               DataCell(Text(data[AppConstants.cgstPercent]!)),
  //               DataCell(Text(data[AppConstants.cgstAmount]!)),
  //               DataCell(Text(data[AppConstants.sgstPercent]!)),
  //               DataCell(Text(data[AppConstants.sgstAmount]!)),
  //             ],
  //           );
  //         }),
  //       ),
  //     ),
  //   );
  // }

  // DataColumn _buildTableHeader(String headerValue) => DataColumn(
  //       label: Text(
  //         headerValue,
  //         style: const TextStyle(fontWeight: FontWeight.bold),
  //       ),
  //     );
}
