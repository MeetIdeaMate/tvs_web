import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/components/custom_pagenation.dart';
import 'package:tlbilling/models/get_model/get_all_vendor_by_pagination_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart' as tlbilling_widget;
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/report/stocks_report/stock_report_bloc.dart';
import 'package:tlbilling/view/report/stocks_report/stocks_accessories_bloc.dart';
import 'package:tlbilling/view/report/stocks_report/stocks_vehicles_report.dart';
import 'package:tlds_flutter/components/tlds_date_picker.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';

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
          return const Text(AppConstants.loading);
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
            vehicleOrAccessoriesHintName:
                (snapshot.connectionState == ConnectionState.waiting)
                    ? AppConstants.loading
                    : (snapshot.hasError || snapshot.data == null)
                        ? AppConstants.errorLoading
                        : AppConstants.exSelect,
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
          return const Text(AppConstants.loading);
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
            vehicleOrAccessoriesHintName:
                (snapshot.connectionState == ConnectionState.waiting)
                    ? AppConstants.loading
                    : (snapshot.hasError || snapshot.data == null)
                        ? AppConstants.errorLoading
                        : AppConstants.exSelect,
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
          );
        }
      },
    );
  }

  searchAndTableView({
    required List<String> vehicleOrAccessoriesDropDownItems,
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
  }) {
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
          tlbilling_widget.AppWidgetUtils.buildSizedBox(custHeight: 16),
          _buildReportTableView(context)
        ],
      ),
    );
  }

  Widget _buildReportTableView(BuildContext context) {
    return Expanded(
      child: StreamBuilder<int>(
        stream: _stocksVehiclesReportBlocImpl.pageNumberStream,
        initialData: _stocksVehiclesReportBlocImpl.currentPage,
        builder: (context, streamSnapshot) {
          int currentPage = streamSnapshot.data ?? 0;
          if (currentPage < 0) currentPage = 0;
          _stocksVehiclesReportBlocImpl.currentPage = currentPage;
          return FutureBuilder<GetAllVendorByPagination?>(
            future: _stocksVehiclesReportBlocImpl.getPurchaseReport(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return AppWidgetUtils.buildLoading();
              } else if (snapshot.hasError) {
                return const Center(
                    child: Text(AppConstants.somethingWentWrong));
              } else if (!snapshot.hasData) {
                return Center(child: SvgPicture.asset(AppConstants.imgNoData));
              } else {
                GetAllVendorByPagination? employeeListmodel = snapshot.data;
                List<Content>? userData = snapshot.data?.content ?? [];

                return Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            dividerThickness: 0.01,
                            columns: columnHeaders
                                .map((header) => DataColumn(
                                      label: Text(
                                        header,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ))
                                .toList(),
                            rows: userData.asMap().entries.map((entry) {
                              return DataRow(
                                color: MaterialStateColor.resolveWith((states) {
                                  return entry.key % 2 == 0
                                      ? Colors.white
                                      : _appColors.transparentBlueColor;
                                }),
                                cells: [
                                  _buildTableRow('${entry.key + 1}'),
                                  _buildTableRow(entry.value.city),
                                  _buildTableRow(entry.value.city),
                                  _buildTableRow(entry.value.accountNo),
                                  _buildTableRow(entry.value.accountNo),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    CustomPagination(
                      itemsOnLastPage: employeeListmodel?.totalElements ?? 0,
                      currentPage: currentPage,
                      totalPages: employeeListmodel?.totalPages ?? 0,
                      onPageChanged: (pageValue) {
                        _stocksVehiclesReportBlocImpl
                            .pageNumberUpdateStreamController(pageValue);
                      },
                    ),
                  ],
                );
              }
            },
          );
        },
      ),
    );
  }

  DataCell _buildTableRow(String? text) => DataCell(Text(
        text ?? '',
        style: const TextStyle(fontSize: 14),
      ));
}
