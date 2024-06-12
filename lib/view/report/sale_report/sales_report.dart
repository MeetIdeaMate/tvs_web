import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/components/custom_pagenation.dart';
import 'package:tlbilling/models/get_model/get_all_vendor_by_pagination_model.dart';
import 'package:tlbilling/models/parent_response_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart' as tlbilling_widget;
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/report/report_generate_pdf_dialog.dart';
import 'package:tlbilling/view/report/sale_report/sales_accessories_report_bloc.dart';
import 'package:tlbilling/view/report/sale_report/sales_report_bloc.dart';
import 'package:tlbilling/view/report/sale_report/sales_vehicles_report_bloc.dart';
import 'package:tlds_flutter/components/tlds_date_picker.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';

class SalesReport extends StatefulWidget {
  const SalesReport({super.key});

  @override
  State<SalesReport> createState() => _SalesReportState();
}

class _SalesReportState extends State<SalesReport>
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
            controller: _saledReportBlocImpl.salesScreenTabController,
            tabs: const [
              Tab(text: AppConstants.vehicle),
              Tab(text: AppConstants.accessories),
            ],
          ),
        ),
        StreamBuilder<bool>(
            stream: _saledReportBlocImpl.tabChangeStreamController,
            builder: (context, snapshot) {
              return Expanded(
                child: Center(
                  child: tlbilling_widget.AppWidgetUtils.buildHeaderText(
                    _totalAmountText(),
                    fontSize: 18,
                  ),
                ),
              );
            }),
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
        children: [_buildVehiclesReportView(), _buildAccessoriesReportView()],
      ),
    );
  }

  Widget _buildVehiclesReportView() {
    return FutureBuilder<List<ParentResponseModel>>(
      future: Future.wait([
        _saledReportBlocImpl.getBranchName(),
        _saledReportBlocImpl.getBranchName(),
        _saledReportBlocImpl.getConfigById(configId: 'Payments'),
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(' ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text(AppConstants.noData));
        } else {
          final branchList = snapshot.data![0].result!.getAllBranchList!
              .map((item) => item.branchName ?? '')
              .toList();
          branchList.insert(0, AppConstants.all);

          final paymentTypes =
              snapshot.data![2].result!.getConfigModel!.configuration ?? [];

          paymentTypes.insert(0, AppConstants.all);

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
              vehicleOrAccessoriesDropDownValues:
                  _salesVehicleReportBlocImpl.vehicleType,
              vehicleOrAccessoriesDropDownOnChange: (value) {
                _salesVehicleReportBlocImpl.vehicleType = value;
              },
              vehicleOrAccessoriesList: vehicleTypes,
              branchDropdownList: branchList,
              selectedBranchName: _salesVehicleReportBlocImpl.selectedBranch,
              branchOnChange: (value) {
                _salesVehicleReportBlocImpl.selectedBranch = value;
              },
              paymentTypeDropDownList: paymentTypes,
              paymentdropDownValue:
                  _salesVehicleReportBlocImpl.selectedPaymentType,
              paymentOnChange: (value) {
                _salesVehicleReportBlocImpl.selectedPaymentType = value;
              },
              fromDateController: _salesVehicleReportBlocImpl.fromDateTextEdit,
              fromDateonSuccessCallBack: () {},
              toDateController: _salesVehicleReportBlocImpl.toDateTextEdit,
              toDateonSuccessCallBack: () {},
              buttonOnPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const GeneratePdfDialog();
                  },
                );
              },
              columnHeaders: columnHeaders,
              rowData: rowData);
        }
      },
    );
  }

  Widget _buildAccessoriesReportView() {
    return FutureBuilder<List<ParentResponseModel>>(
      future: Future.wait([
        _saledReportBlocImpl.getBranchName(),
        _saledReportBlocImpl.getBranchName(),
        _saledReportBlocImpl.getConfigById(configId: 'Payments'),
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

          final paymentTypes =
              snapshot.data![2].result!.getConfigModel!.configuration ?? [];

          paymentTypes.insert(0, AppConstants.all);

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
            vehicleOrAccessoriesDropDownValues:
                _salesAccessoriesBlocImpl.accessoriesType,
            vehicleOrAccessoriesDropDownOnChange: (value) {
              _salesAccessoriesBlocImpl.accessoriesType = value;
            },
            vehicleOrAccessoriesList: vehicleTypes,
            branchDropdownList: branchList,
            selectedBranchName: _salesAccessoriesBlocImpl.selectedBranch,
            branchOnChange: (value) {
              _salesAccessoriesBlocImpl.selectedBranch = value;
            },
            paymentTypeDropDownList: paymentTypes,
            paymentdropDownValue: _salesAccessoriesBlocImpl.selectedPaymentType,
            paymentOnChange: (value) {
              _salesAccessoriesBlocImpl.selectedPaymentType = value;
            },
            fromDateController: _salesAccessoriesBlocImpl.fromDateTextEdit,
            fromDateonSuccessCallBack: () {},
            toDateController: _salesAccessoriesBlocImpl.toDateTextEdit,
            toDateonSuccessCallBack: () {},
            buttonOnPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const GeneratePdfDialog();
                },
              );
            },
            columnHeaders: columnHeaders,
            rowData: rowData,
          );
        }
      },
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
              TldsDropDownButtonFormField(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.1,
                  dropDownItems: vehicleOrAccessoriesList.toSet().toList(),
                  dropDownValue:
                      vehicleOrAccessoriesDropDownValues ?? AppConstants.all,
                  hintText: vehicleOrAccessoriesHintName,
                  onChange: vehicleOrAccessoriesDropDownOnChange),
              tlbilling_widget.AppWidgetUtils.buildSizedBox(custWidth: 5),
              Expanded(
                child: TldsDropDownButtonFormField(
                  height: 40,
                  dropDownItems: branchDropdownList.toSet().toList(),
                  hintText: AppConstants.selectedBranch,
                  dropDownValue: selectedBranchName ?? AppConstants.all,
                  onChange: branchOnChange,
                ),
              ),
              tlbilling_widget.AppWidgetUtils.buildSizedBox(custWidth: 5),
              TldsDropDownButtonFormField(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.1,
                dropDownItems: paymentTypeDropDownList.toSet().toList(),
                dropDownValue: paymentdropDownValue ?? AppConstants.all,
                hintText: AppConstants.paymentType,
                onChange: paymentOnChange,
              ),
              tlbilling_widget.AppWidgetUtils.buildSizedBox(custWidth: 5),
              TldsDatePicker(
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
                    buttonBackgroundColor: _appColors.primaryColor,
                    fontColor: _appColors.whiteColor,
                    suffixIcon: SvgPicture.asset(AppConstants.icPdfPrint),
                    onPressed: buttonOnPressed),
              )
            ],
          ),
          tlbilling_widget.AppWidgetUtils.buildSizedBox(custHeight: 10),
          _buildPurchaseTableView(context)
        ],
      ),
    );
  }

  Widget _buildPurchaseTableView(BuildContext context) {
    return Expanded(
      child: StreamBuilder<int>(
        stream: _salesVehicleReportBlocImpl.pageNumberStream,
        initialData: _salesVehicleReportBlocImpl.currentPage,
        builder: (context, streamSnapshot) {
          int currentPage = streamSnapshot.data ?? 0;
          if (currentPage < 0) currentPage = 0;
          _salesVehicleReportBlocImpl.currentPage = currentPage;
          return FutureBuilder<GetAllVendorByPagination?>(
            future: _salesVehicleReportBlocImpl.getPurchaseReport(),
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
                                  _buildTableRow(entry.value.city),
                                  _buildTableRow(entry.value.mobileNo),
                                  _buildTableRow(entry.value.vendorName),
                                  _buildTableRow(entry.value.city),
                                  _buildTableRow(entry.value.vendorId),
                                  _buildTableRow(entry.value.city),
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
                        _salesVehicleReportBlocImpl
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
