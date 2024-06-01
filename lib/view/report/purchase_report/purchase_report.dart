import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/components/custom_table_view.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart' as tlbilling_widget;
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/report/purchase_report/purchase_accessories_bloc.dart';
import 'package:tlbilling/view/report/purchase_report/purchase_report_bloc.dart';
import 'package:tlbilling/view/report/purchase_report/purchase_vechicle_bloc.dart';
import 'package:tlds_flutter/components/tlds_date_picker.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';

class PurchaseReport extends StatefulWidget {
  const PurchaseReport({super.key});

  @override
  State<PurchaseReport> createState() => _PurchaseReportState();
}

class _PurchaseReportState extends State<PurchaseReport>
    with SingleTickerProviderStateMixin {
  final _appColors = AppColors();
  final _purchaseReportBlocImpl = PurchaseReportBlocImpl();
  final _purchaseVechicleBlocImpl = PurchaseVehiclesReportBlocImpl();
  final _purchaseAccessoriesBlocImpl = PurchaseAccessoriesReportBlocImpl();

  @override
  void initState() {
    super.initState();
    _purchaseReportBlocImpl.purchaseReportTabController =
        TabController(length: 2, vsync: this);
    _purchaseReportBlocImpl.purchaseReportTabController.addListener(() {
      _purchaseReportBlocImpl.tabChangeStreamControll(true);
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
    },
    {
      'S.No': '',
      'Date': '',
      'Vehicle Name': '',
      'HSN Code': '',
      'Qty': '10',
      'Unit Rate': '',
      'Total Value': '50000',
      'Taxable Value': '45000',
      'CGST ₹': '₹ 2250',
      'SGST ₹': '₹ 2250',
      'Tot Inv Value': '₹ 49500',
    }
  ];

  Map<String, String> total = {
    'S.No': '',
    'Date': '',
    'Vehicle Name': '',
    'HSN Code': '',
    'Qty': '10',
    'Unit Rate': '',
    'Total Value': '50000',
    'Taxable Value': '45000',
    'CGST ₹': '₹ 2250',
    'SGST ₹': '₹ 2250',
    'Tot Inv Value': '₹ 49500',
  };

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
      children: [
        Expanded(
          child: TabBar(
            controller: _purchaseReportBlocImpl.purchaseReportTabController,
            tabs: const [
              Tab(text: AppConstants.vehicle),
              Tab(text: AppConstants.accessories),
            ],
          ),
        ),
        StreamBuilder<bool>(
            stream: _purchaseReportBlocImpl.tabChangeStreamController,
            builder: (context, snapshot) {
              return Expanded(
                child: Center(
                  child: AppWidgetUtils.buildHeaderText(
                    _getHeaderText(),
                    fontSize: 18,
                  ),
                ),
              );
            }),
      ],
    );
  }

  String _getHeaderText() {
    if (_purchaseReportBlocImpl.purchaseReportTabController.index == 0) {
      return 'Over All vehicle purchase amount: 10000';
    } else {
      return 'Over All accessories purchase amount: 10000';
    }
  }

  _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _purchaseReportBlocImpl.purchaseReportTabController,
        children: [
          //vehicles
          _buildVehicleReportView(),
          // accessaries
          _buildAccessoriesReportView()
        ],
      ),
    );
  }

  Widget _buildAccessoriesReportView() {
    return FutureBuilder(
      future: _purchaseReportBlocImpl.getBranchName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text(AppConstants.noData));
        } else {
          final vehicleTypes = snapshot.data!.result!.getAllBranchList!
              .map((item) => item.branchName ?? '')
              .toList();

          return searchAndTableView(
              dropDownHintText: AppConstants.accessories,
              dropDownItems: vehicleTypes,
              fromDateController: _purchaseAccessoriesBlocImpl.fromDateTextEdit,
              toDateControler: _purchaseAccessoriesBlocImpl.toDateTextEdit,
              buttonOnPressed: () {},
              dropDownOnChange: (value) {
                _purchaseVechicleBlocImpl.selectedVehiclesType = value;
              },
              dropDownValue:
                  _purchaseAccessoriesBlocImpl.selectedAccessoriesType,
              columnHeaders: columnHeaders,
              rowData: rowData);
        }
      },
    );
  }

  Widget _buildVehicleReportView() {
    return FutureBuilder(
      future: _purchaseReportBlocImpl.getBranchName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text(AppConstants.noData));
        } else {
          final vehicleTypes = snapshot.data!.result!.getAllBranchList!
              .map((item) => item.branchName ?? '')
              .toList();

          return searchAndTableView(
              dropDownHintText: AppConstants.vehicleType,
              dropDownItems: vehicleTypes,
              fromDateController: _purchaseVechicleBlocImpl.fromDateTextEdit,
              toDateControler: _purchaseVechicleBlocImpl.toDateTextEdit,
              buttonOnPressed: () {},
              dropDownOnChange: (value) {
                _purchaseVechicleBlocImpl.selectedVehiclesType = value;
              },
              dropDownValue: _purchaseVechicleBlocImpl.selectedVehiclesType,
              columnHeaders: columnHeaders,
              rowData: rowData);
        }
      },
    );
  }

  searchAndTableView(
      {List<String>? dropDownItems,
      String? dropDownHintText,
      String? dropDownValue,
      Function(String?)? dropDownOnChange,
      required TextEditingController fromDateController,
      required TextEditingController toDateControler,
      Function()? buttonOnPressed,
      required List<String> columnHeaders,
      required List<Map<String, String>> rowData,
      Function()? fromDateOnSuccessCallBack,
      Function()? toDateOnSuccessCallBack}) {
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
                  dropDownItems: dropDownItems ?? [],
                  hintText: dropDownHintText,
                  dropDownValue: dropDownValue,
                  onChange: dropDownOnChange,
                ),
              ),
              tlbilling_widget.AppWidgetUtils.buildSizedBox(custWidth: 5),
              TldsDatePicker(
                  height: 40,
                  onSuccessCallBack: fromDateOnSuccessCallBack,
                  suffixIcon: SvgPicture.asset(
                    AppConstants.icDate,
                    colorFilter: ColorFilter.mode(
                        _appColors.primaryColor, BlendMode.srcIn),
                  ),
                  fontSize: 14,
                  width: MediaQuery.of(context).size.width * 0.1,
                  hintText: AppConstants.fromDate,
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
                  onSuccessCallBack: toDateOnSuccessCallBack,
                  controller: toDateControler),
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
