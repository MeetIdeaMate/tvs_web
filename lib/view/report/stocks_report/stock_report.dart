import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/components/custom_table_view.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart' as tlbilling_widget;
import 'package:tlbilling/view/report/stocks_report/stock_report_bloc.dart';
import 'package:tlbilling/view/report/stocks_report/stocks_accessories_bloc.dart';
import 'package:tlbilling/view/report/stocks_report/stocks_vehicles_report.dart';
import 'package:tlds_flutter/export.dart';

class StockReport extends StatefulWidget {
  const StockReport({super.key});

  @override
  State<StockReport> createState() => _StockReportState();
}

class _StockReportState extends State<StockReport>
    with SingleTickerProviderStateMixin {
  final _appColors = AppColors();

  final _stocksReportBlocImpl = StocksReportBlocImpl();
  final _stocksVehiclesReportBlocImpl = StocksVehicleReportBlocImpl();
  final _stocksAccessoriesReportBlocImpl = StocksAccessoriesReportBlocImpl();

  @override
  void initState() {
    super.initState();
    _stocksReportBlocImpl.stockReportTabController =
        TabController(length: 2, vsync: this);
    _stocksReportBlocImpl.stockReportTabController.addListener(() {});
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
    'Vehicle Name',
    'Variant',
    'HSN Code',
    'Qty',
  ];

  List<Map<String, String>> rowData = [
    {
      'S.No': '1',
      'Vehicle Name': 'Toyota Camry',
      'Variant': 'Base',
      'HSN Code': '87089900',
      'Qty': '10',
    },
    {
      'S.No': '2',
      'Vehicle Name': 'Honda Accord',
      'Variant': 'Sport',
      'HSN Code': '87089900',
      'Qty': '5',
    },
    {
      'S.No': '3',
      'Vehicle Name': 'BMW 3 Series',
      'Variant': 'Luxury',
      'HSN Code': '87089900',
      'Qty': '8',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTabBar(),
        tlbilling_widget.AppWidgetUtils.buildSizedBox(custHeight: 16),
        _buildTabBarView(),
      ],
    );
  }

  _buildTabBar() {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: TabBar(
            controller: _stocksReportBlocImpl.stockReportTabController,
            tabs: const [
              Tab(text: AppConstants.vehicle),
              Tab(text: AppConstants.accessories),
            ],
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          ),
        ),
      ],
    );
  }

  _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _stocksReportBlocImpl.stockReportTabController,
        children: [
          // Vehicles
          _buildVehicleReportView(),
          // Accessories

          _buildAccessoriesReportView()
        ],
      ),
    );
  }

  Widget _buildAccessoriesReportView() {
    return FutureBuilder(
      future: Future.wait([
        _stocksReportBlocImpl.getBranchName(),
        _stocksReportBlocImpl.getBranchName()
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text(AppConstants.noData));
        } else {
          final branchList = snapshot.data![0].result!.getAllBranchList!
              .map((item) => item.branchName ?? '')
              .toList();
          branchList.insert(0, AppConstants.all);

          final vehicleTypes = snapshot.data![0].result!.getAllBranchList!
              .map((item) => item.branchName ?? '')
              .toList();
          vehicleTypes.insert(0, AppConstants.all);

          return searchAndTableView(
            vehicleOrAccessoriesHintName: AppConstants.accessoriesType,
            vehicleOrAccessoriesDropDownValue:
                _stocksAccessoriesReportBlocImpl.selectedAccessories,
            vehicleOrAccessoriesDropDownItems: vehicleTypes,
            vehicleOrAccessoriesOnChange: (value) {
              _stocksAccessoriesReportBlocImpl.selectedAccessories = value;
            },
            selectedBranchName: _stocksAccessoriesReportBlocImpl.selectedBranch,
            branchList: branchList,
            branchOnChange: (value) {
              _stocksAccessoriesReportBlocImpl.selectedBranch = value;
            },
            fromDateController:
                _stocksAccessoriesReportBlocImpl.fromDateTextEdit,
            fromDateonSuccessCallBack: () {},
            toDateController: _stocksAccessoriesReportBlocImpl.toDateTextEdit,
            buttonOnPressed: () {},
            toDateonSuccessCallBack: () {},
            columnHeaders: columnHeaders,
            rowData: rowData,
          );
        }
      },
    );
  }

  Widget _buildVehicleReportView() {
    return FutureBuilder(
      future: Future.wait([
        _stocksReportBlocImpl.getBranchName(),
        _stocksReportBlocImpl.getBranchName(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text(AppConstants.noData));
        } else {
          final branchList = snapshot.data![0].result!.getAllBranchList!
              .map((item) => item.branchName ?? '')
              .toList();
          branchList.insert(0, AppConstants.all);

          final vehicleTypes = snapshot.data![0].result!.getAllBranchList!
              .map((item) => item.branchName ?? '')
              .toList();
          vehicleTypes.insert(0, AppConstants.all);

          return searchAndTableView(
            vehicleOrAccessoriesHintName: AppConstants.vehicleType,
            vehicleOrAccessoriesDropDownValue:
                _stocksVehiclesReportBlocImpl.vehicleType,
            vehicleOrAccessoriesDropDownItems: vehicleTypes,
            vehicleOrAccessoriesOnChange: (value) {
              _stocksVehiclesReportBlocImpl.vehicleType = value;
            },
            selectedBranchName: _stocksVehiclesReportBlocImpl.selectedBranch,
            branchList: branchList,
            branchOnChange: (value) {
              _stocksVehiclesReportBlocImpl.selectedBranch = value;
            },
            fromDateController: _stocksVehiclesReportBlocImpl.fromDateTextEdit,
            fromDateonSuccessCallBack: () {},
            toDateController: _stocksVehiclesReportBlocImpl.toDateTextEdit,
            buttonOnPressed: () {},
            toDateonSuccessCallBack: () {},
            columnHeaders: columnHeaders,
            rowData: rowData,
          );
        }
      },
    );
  }

  searchAndTableView(
      {required List<String> vehicleOrAccessoriesDropDownItems,
      String? vehicleOrAccessoriesHintName,
      Function(String?)? vehicleOrAccessoriesOnChange,
      String? vehicleOrAccessoriesDropDownValue,
      required List<String> branchList,
      String? selectedBranchName,
      Function(String?)? branchOnChange,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TldsDropDownButtonFormField(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.15,
                  dropDownItems: vehicleOrAccessoriesDropDownItems,
                  hintText: vehicleOrAccessoriesHintName,
                  dropDownValue: AppConstants.all,
                  onChange: vehicleOrAccessoriesOnChange),
              tlbilling_widget.AppWidgetUtils.buildSizedBox(custWidth: 5),
              Expanded(
                child: TldsDropDownButtonFormField(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.15,
                    dropDownItems: branchList,
                    hintText: AppConstants.selectedBranch,
                    dropDownValue: AppConstants.all,
                    onChange: branchOnChange),
              ),
              tlbilling_widget.AppWidgetUtils.buildSizedBox(custWidth: 5),
              TldsDatePicker(
                  style: TextStyle(color: _appColors.red, fontSize: 20),
                  firstDate: DateTime(2000, 1, 1),
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
                firstDate: DateTime(2000, 1, 1),
                fontSize: 14,
                height: 40,
                suffixIcon: SvgPicture.asset(
                  AppConstants.icDate,
                  colorFilter: ColorFilter.mode(
                      _appColors.primaryColor, BlendMode.srcIn),
                ),
                width: MediaQuery.of(context).size.width * 0.1,
                hintText: AppConstants.toDate,
                controller: toDateController,
                onSuccessCallBack: toDateonSuccessCallBack,
              ),
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
