import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/components/custom_pagenation.dart';
import 'package:tlbilling/models/get_model/get_all_vendor_by_pagination_model.dart';
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

  final StreamController<int> _pageNumberStreamController =
      StreamController<int>.broadcast();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _purchaseReportBlocImpl.purchaseReportTabController =
        TabController(length: 2, vsync: this);
    _purchaseReportBlocImpl.purchaseReportTabController.addListener(() {
      _purchaseReportBlocImpl.tabChangeStreamControll(true);
    });
    _pageNumberStreamController.add(0);
  }

  final List<String> columnHeaders = [
    'S.No',
    'Date',
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

  @override
  void dispose() {
    _pageNumberStreamController.close();
    super.dispose();
  }

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
                  child: tlbilling_widget.AppWidgetUtils.buildHeaderText(
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
          // accessories
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
            vehicleTypes.insert(0, AppConstants.all);

            return searchAndTableView(
              dropDownHintText: AppConstants.accessories,
              dropDownItems: vehicleTypes,
              fromDateController: _fromDateController,
              toDateControler: _toDateController,
              buttonOnPressed: () {},
              dropDownOnChange: (value) {
                _purchaseVechicleBlocImpl.selectedVehiclesType = value;
              },
              dropDownValue:
                  _purchaseAccessoriesBlocImpl.selectedAccessoriesType,
              fromDateOnSuccessCallBack: () {},
              toDateOnSuccessCallBack: () {},
            );
          }
        });
  }

  Widget _buildVehicleReportView() {
    return FutureBuilder(
      future: _purchaseReportBlocImpl.getBranchName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text(AppConstants.noData));
        } else {
          final vehicleTypes = snapshot.data!.result!.getAllBranchList!
              .map((item) => item.branchName ?? '')
              .toList();
          vehicleTypes.insert(0, AppConstants.all);

          return searchAndTableView(
            dropDownHintText: AppConstants.vehicleType,
            dropDownItems: vehicleTypes,
            fromDateController: _fromDateController,
            toDateControler: _toDateController,
            buttonOnPressed: () {},
            dropDownOnChange: (value) {
              _purchaseVechicleBlocImpl.selectedVehiclesType = value;
            },
            dropDownValue: _purchaseVechicleBlocImpl.selectedVehiclesType,
            fromDateOnSuccessCallBack: () {},
            toDateOnSuccessCallBack: () {},
          );
        }
      },
    );
  }

  Widget searchAndTableView({
    List<String>? dropDownItems,
    String? dropDownHintText,
    String? dropDownValue,
    Function(String?)? dropDownOnChange,
    required TextEditingController fromDateController,
    required TextEditingController toDateControler,
    required Function()? buttonOnPressed,
    required Function()? fromDateOnSuccessCallBack,
    required Function()? toDateOnSuccessCallBack,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 27),
      child: Column(
        children: [
          Row(
            children: [
              TldsDropDownButtonFormField(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.1,
                dropDownItems: dropDownItems ?? [],
                hintText: dropDownHintText,
                dropDownValue: dropDownValue ?? AppConstants.all,
                onChange: dropDownOnChange,
              ),
              tlbilling_widget.AppWidgetUtils.buildSizedBox(custWidth: 5),
              TldsDatePicker(
                firstDate: DateTime(2000, 1, 1),
                height: 40,
                onSuccessCallBack: fromDateOnSuccessCallBack,
                suffixIcon: SvgPicture.asset(
                  AppConstants.icDate,
                  colorFilter: ColorFilter.mode(
                    _appColors.primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
                fontSize: 14,
                width: MediaQuery.of(context).size.width * 0.1,
                hintText: AppConstants.fromDate,
                controller: fromDateController,
              ),
              tlbilling_widget.AppWidgetUtils.buildSizedBox(custWidth: 5),
              TldsDatePicker(
                firstDate: DateTime(2000, 1, 1),
                fontSize: 14,
                height: 40,
                suffixIcon: SvgPicture.asset(
                  AppConstants.icDate,
                  colorFilter: ColorFilter.mode(
                    _appColors.primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.1,
                hintText: AppConstants.toDate,
                onSuccessCallBack: toDateOnSuccessCallBack,
                controller: toDateControler,
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
                  onPressed: buttonOnPressed,
                ),
              ),
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
        stream: _purchaseVechicleBlocImpl.pageNumberStream,
        initialData: _purchaseVechicleBlocImpl.currentPage,
        builder: (context, streamSnapshot) {
          int currentPage = streamSnapshot.data ?? 0;
          if (currentPage < 0) currentPage = 0;
          _purchaseVechicleBlocImpl.currentPage = currentPage;
          return FutureBuilder<GetAllVendorByPagination?>(
            future: _purchaseVechicleBlocImpl.getPurchaseReport(),
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
                        _pageNumberStreamController.add(pageValue);
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
