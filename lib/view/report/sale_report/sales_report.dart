import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/components/custom_table_view.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart' as tlbilling_widget;
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/report/sale_report/sales_accessories_report_bloc.dart';
import 'package:tlbilling/view/report/sale_report/sales_report_bloc.dart';
import 'package:tlbilling/view/report/sale_report/sales_vehicles_report_bloc.dart';
import 'package:tlds_flutter/components/tlds_date_picker.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';

class Salesreport extends StatefulWidget {
  const Salesreport({super.key});

  @override
  State<Salesreport> createState() => _SalesreportState();
}

class _SalesreportState extends State<Salesreport>
    with SingleTickerProviderStateMixin {
  final _appColors = AppColors();
  final _saledReportBlocImpl = SaledReportBlocImpl();
  final _salesVehicleReportBlocImpl = SalesVehicleReportBlocImpl();
  final _salesAccessoriesBlocImpl = SalesAccessoriesReportBlocImpl();

  @override
  void initState() {
    super.initState();
    _saledReportBlocImpl.salesScreenTabController =
        TabController(length: 2, vsync: this);
    _saledReportBlocImpl.salesScreenTabController.addListener(() {
      _saledReportBlocImpl.tabChangeStreamControll(true);
    });
  }

  final List<String> vehicles = [
    'Toyota Camry',
    'Honda Accord',
    'BMW 3 Series',
    'Mercedes-Benz C-Class',
    'Audi A4',
  ];
  final List<String> columnHeaders = [
    'S.No',
    'date',
    'Vehicle Name',
    'HSN code',
    'Qty',
    'Unit Rate',
    'Total Value',
    'Taxable Value',
    'CGST ₹',
    'SGST ₹',
    'Tot Inv Value',
  ];

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
      'CGST ₹': '2250',
      'SGST ₹': '2250',
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
      'CGST ₹': '1575',
      'SGST ₹': '1575',
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
      'CGST ₹': '4320',
      'SGST ₹': '4320',
      'Tot Inv Value': '95040',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTabBar(),
        AppWidgetUtils.buildSizedBox(custHeight: 16),
        _buildTabBarView(),
      ],
    );
  }

  _buildTabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TabBar(
            controller: _saledReportBlocImpl.salesScreenTabController,
            tabs: const [
              Tab(text: AppConstants.vehicle),
              Tab(text: AppConstants.accessories),
            ],
          ),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 20),
        StreamBuilder<bool>(
            stream: _saledReportBlocImpl.tabChangeStreamController,
            builder: (context, snapshot) {
              return Expanded(
                child: AppWidgetUtils.buildHeaderText(_totalAmountText(),
                    fontSize: 18),
              );
            }),
        AppWidgetUtils.buildSizedBox(custWidth: 10),
        Expanded(
            child: AppWidgetUtils.buildHeaderText(
                'Over All sales amount: 10000',
                fontSize: 18))
      ],
    );
  }

  String _totalAmountText() {
    if (_saledReportBlocImpl.salesScreenTabController.index == 0) {
      return 'Over All vehicle Total amount: 10000';
    } else {
      return 'Over All accessories Total amount: 10000';
    }
  }

  _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _saledReportBlocImpl.salesScreenTabController,
        children: [
          //vehicles
          searchAndTableView(
              vehicleOrAccessoriesHintName: AppConstants.vehicle,
              vehicleOrAccessoriesDropDownValues:
                  _salesVehicleReportBlocImpl.vehicleType,
              vehicleOrAccessoriesDropDownOnChange: (value) {
                _salesVehicleReportBlocImpl.vehicleType = value;
              },
              vehicleOrAccessoriesList: vehicles,
              branchDropdownList: vehicles,
              selectedBranchName: _salesVehicleReportBlocImpl.selectedBranch,
              branchOnChange: (value) {
                _salesVehicleReportBlocImpl.selectedBranch = value;
              },
              paymentTypeDropDownList: vehicles,
              paymentdropDownValue:
                  _salesVehicleReportBlocImpl.selectedPaymentType,
              paymentOnChange: (value) {
                _salesVehicleReportBlocImpl.selectedPaymentType = value;
              },
              fromDateController: _salesVehicleReportBlocImpl.fromDateTextEdit,
              fromDateonSuccessCallBack: () {},
              toDateController: _salesVehicleReportBlocImpl.toDateTextEdit,
              toDateonSuccessCallBack: () {},
              buttonOnPressed: () {},
              columnHeaders: columnHeaders,
              rowData: rowData),
          // accessaries
          searchAndTableView(
              vehicleOrAccessoriesHintName: AppConstants.accessories,
              vehicleOrAccessoriesDropDownValues:
                  _salesAccessoriesBlocImpl.accessoriesType,
              vehicleOrAccessoriesDropDownOnChange: (value) {
                _salesAccessoriesBlocImpl.accessoriesType = value;
              },
              vehicleOrAccessoriesList: vehicles,
              branchDropdownList: vehicles,
              selectedBranchName: _salesAccessoriesBlocImpl.selectedBranch,
              branchOnChange: (value) {
                _salesAccessoriesBlocImpl.selectedBranch = value;
              },
              paymentTypeDropDownList: vehicles,
              paymentdropDownValue:
                  _salesAccessoriesBlocImpl.selectedPaymentType,
              paymentOnChange: (value) {
                _salesAccessoriesBlocImpl.selectedPaymentType = value;
              },
              fromDateController: _salesAccessoriesBlocImpl.fromDateTextEdit,
              fromDateonSuccessCallBack: () {},
              toDateController: _salesAccessoriesBlocImpl.toDateTextEdit,
              toDateonSuccessCallBack: () {},
              buttonOnPressed: () {},
              columnHeaders: columnHeaders,
              rowData: rowData)
        ],
      ),
    );
  }

  searchAndTableView(
      {required List<String> vehicleOrAccessoriesList,
      String? vehicleOrAccessoriesHintName,
      Function(String?)? vehicleOrAccessoriesDropDownOnChange,
      String? vehicleOrAccessoriesDropDownValues,
      String? selectedBranchName,
      Function(String?)? branchOnChange,
      required List<String> branchDropdownList,
      required List<String> paymentTypeDropDownList,
      dynamic Function(String?)? paymentOnChange,
      String? paymentdropDownValue,
      required TextEditingController fromDateController,
      Function()? fromDateonSuccessCallBack,
      required TextEditingController toDateController,
      Function()? toDateonSuccessCallBack,
      Function()? buttonOnPressed,
      required List<String> columnHeaders,
      required List<Map<String, String>> rowData}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 27),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: TldsDropDownButtonFormField(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.1,
                    dropDownItems: vehicleOrAccessoriesList,
                    dropDownValue: vehicleOrAccessoriesDropDownValues,
                    hintText: vehicleOrAccessoriesHintName,
                    onChange: vehicleOrAccessoriesDropDownOnChange),
              ),
              tlbilling_widget.AppWidgetUtils.buildSizedBox(custWidth: 5),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: TldsDropDownButtonFormField(
                    height: 40,
                    dropDownItems: branchDropdownList,
                    hintText: AppConstants.selectedBranch,
                    dropDownValue: selectedBranchName,
                    onChange: branchOnChange,
                  ),
                ),
              ),
              tlbilling_widget.AppWidgetUtils.buildSizedBox(custWidth: 5),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: TldsDropDownButtonFormField(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.1,
                  dropDownItems: paymentTypeDropDownList,
                  dropDownValue: paymentdropDownValue,
                  hintText: AppConstants.paymentType,
                  onChange: paymentOnChange,
                ),
              ),
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
                  onSuccessCallBack: fromDateonSuccessCallBack,
                  controller: fromDateController),
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
                  onSuccessCallBack: toDateonSuccessCallBack,
                  controller: toDateController),
              tlbilling_widget.AppWidgetUtils.buildSizedBox(custWidth: 5),
              const Spacer(),
              Expanded(
                flex: 0,
                child: CustomElevatedButton(
                    height: 40,
                    text: AppConstants.pdfGeneration,
                    fontSize: 16,
                    buttonBackgroundColor: AppColors().primaryColor,
                    fontColor: AppColors().whiteColor,
                    suffixIcon: SvgPicture.asset(AppConstants.icPdfPrint),
                    onPressed: buttonOnPressed),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child:
                CustomTableView(columnHeaders: columnHeaders, rowData: rowData),
          )
        ],
      ),
    );
  }
}
