import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:flutter_svg/svg.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/components/custom_pagenation.dart';
import 'package:tlbilling/models/get_model/get_all_sales_list_model.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlbilling/view/sales/add_sales.dart';
import 'package:tlbilling/view/sales/payment_dialog.dart';
import 'package:tlbilling/view/sales/sales_report_pdf.dart';
import 'package:tlbilling/view/sales/sales_view_bloc.dart';
import 'package:tlds_flutter/util/app_colors.dart';
import 'package:toastification/toastification.dart';

class SalesViewScreen extends StatefulWidget {
  const SalesViewScreen({super.key});

  @override
  State<SalesViewScreen> createState() => _SalesViewScreenState();
}

class _SalesViewScreenState extends State<SalesViewScreen>
    with SingleTickerProviderStateMixin {
  final _salesViewBloc = SalesViewBlocImpl();
  final _appColors = AppColor();
  @override
  void initState() {
    super.initState();
    _salesViewBloc.salesTabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 21,
          vertical: 28,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppWidgetUtils.buildHeaderText(AppConstants.sales),
            AppWidgetUtils.buildSizedBox(custHeight: 26),
            _buildSearchFilters(),
            AppWidgetUtils.buildSizedBox(
                custHeight: MediaQuery.sizeOf(context).height * 0.02),
            _buildTabBar(),
            _buildTabBarView()
          ],
        ),
      ),
    );
  }

  Widget _buildSearchFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildSearchField(
                searchStream: _salesViewBloc.invoiceNoStream,
                searchController: _salesViewBloc.invoiceNoTextController,
                hintText: AppConstants.invoiceNo,
                searchStreamController:
                    _salesViewBloc.invoiceNoStreamController),
            AppWidgetUtils.buildSizedBox(
              custWidth: MediaQuery.sizeOf(context).width * 0.01,
            ),
            buildSearchField(
              searchStream: _salesViewBloc.paymentTypeStream,
              searchController: _salesViewBloc.paymentTypeTextController,
              hintText: AppConstants.paymentType,
              searchStreamController:
                  _salesViewBloc.paymentTypeStreamController,
              inputFormatters: TlInputFormatters.onlyAllowAlphabets,
            ),
            AppWidgetUtils.buildSizedBox(
              custWidth: MediaQuery.sizeOf(context).width * 0.01,
            ),
            StreamBuilder<bool>(
              stream: _salesViewBloc.customerNameStream,
              builder: (context, snapshot) {
                return buildSearchField(
                  searchController: _salesViewBloc.customerNameTextController,
                  hintText: AppConstants.customerName,
                  searchStream: _salesViewBloc.customerNameStream,
                  searchStreamController:
                      _salesViewBloc.customerNameStreamController,
                  inputFormatters: TlInputFormatters.onlyAllowAlphabets,
                );
              },
            ),
          ],
        ),
        Row(
          children: [
            CustomElevatedButton(
              height: 40,
              width: 189,
              text: AppConstants.addSales,
              fontSize: 16,
              buttonBackgroundColor: _appColors.primaryColor,
              fontColor: _appColors.whiteColor,
              suffixIcon: SvgPicture.asset(AppConstants.icAdd),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddSales(salesViewBloc: _salesViewBloc),
                    ));
              },
            )
          ],
        )
      ],
    );
  }

  StreamBuilder<bool> buildSearchField(
      {Stream<bool>? searchStream,
      TextEditingController? searchController,
      Function(bool)? searchStreamController,
      String? hintText,
      List<TextInputFormatter>? inputFormatters}) {
    return StreamBuilder(
      stream: searchStream,
      builder: (context, snapshot) {
        bool isTextEmpty = searchController!.text.isEmpty;
        IconData iconPath = isTextEmpty ? Icons.search : Icons.close;
        Color iconColor = isTextEmpty ? _appColors.primaryColor : Colors.red;

        return AppWidgetUtils.buildSearchField(
          hintText,
          searchController,
          context,
          inputFormatters: inputFormatters,
          suffixIcon: IconButton(
            onPressed: () {
              if (iconPath == Icons.search) {
                if (searchController.text.isNotEmpty) {
                  searchStreamController!(true);
                  _salesViewBloc.pageNumberUpdateStreamController(0);

                  //  _salesViewBloc.getSalesList('');
                }
              } else {
                searchController.clear();
                searchStreamController!(false);
                _salesViewBloc.pageNumberUpdateStreamController(0);
              }
            },
            icon: Icon(
              iconPath,
              color: iconColor,
            ),
          ),
          onSubmit: (value) {
            if (value.isNotEmpty) {
              searchStreamController!(true);
              _salesViewBloc.pageNumberUpdateStreamController(0);
              //   _salesViewBloc.getSalesList('');
            }
          },
        );
      },
    );
  }

  Widget _buildTabBar() {
    return SizedBox(
      width: 420,
      child: TabBar(
        controller: _salesViewBloc.salesTabController,
        tabs: const [
          //   Tab(text: AppConstants.all),
          Tab(text: AppConstants.today),
          Tab(text: AppConstants.pending),
          Tab(text: AppConstants.completed),
          Tab(text: AppConstants.cancelled),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _salesViewBloc.salesTabController,
        children: [
          // _buildSalesTableView(context),
          _buildSalesTableView(
              context, DateFormat('yyyy-MM-dd').format(DateTime.now()), false),
          _buildSalesTableView(context, 'PENDING', false),
          _buildSalesTableView(context, 'COMPLETED', false),
          _buildSalesTableView(context, '', true),
        ],
      ),
    );
  }

  Widget _buildSalesTableView(
      BuildContext context, String paymentStatus, bool iscancelled) {
    return StreamBuilder<int>(
      stream: _salesViewBloc.pageNumberStream,
      initialData: _salesViewBloc.currentPage,
      builder: (context, streamSnapshot) {
        int currentPage = streamSnapshot.data ?? 0;
        if (currentPage < 0) currentPage = 0;
        _salesViewBloc.currentPage = currentPage;
        return FutureBuilder(
          future: _salesViewBloc.getSalesList(paymentStatus, iscancelled),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: AppWidgetUtils.buildLoading());
            } else if (!snapshot.hasData ||
                snapshot.data?.content?.isEmpty == true) {
              return Center(child: SvgPicture.asset(AppConstants.imgNoData));
            }
            List<Content> salesList = snapshot.data?.content ?? [];
            GetAllSales salesDetails = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          key: UniqueKey(),
                          dividerThickness: 0.01,
                          columns: [
                            _buildVehicleTableHeader(AppConstants.sno),
                            _buildVehicleTableHeader(AppConstants.invoiceNo),
                            _buildVehicleTableHeader(AppConstants.invoiceDate),
                            // _buildVehicleTableHeader(AppConstants.customerId),
                            _buildVehicleTableHeader(AppConstants.customerName),
                            _buildVehicleTableHeader(AppConstants.mobileNumber),
                            _buildVehicleTableHeader(AppConstants.paymentType),
                            _buildVehicleTableHeader(
                                AppConstants.totalInvAmount),
                            if (!iscancelled)
                              _buildVehicleTableHeader(AppConstants.paidAmt),
                            if (!iscancelled)
                              _buildVehicleTableHeader(
                                  AppConstants.pendingInvAmt),
                            // _buildVehicleTableHeader(AppConstants.balanceAmt),
                            if (!iscancelled)
                              _buildVehicleTableHeader(AppConstants.status),
                            _buildVehicleTableHeader(AppConstants.createdBy),
                            if (!iscancelled)
                              _buildVehicleTableHeader(AppConstants.pay),
                            if (!iscancelled)
                              _buildVehicleTableHeader(AppConstants.print),
                            _buildVehicleTableHeader(AppConstants.action),
                          ],
                          rows: salesList.asMap().entries.map((entry) {
                            return DataRow(
                              color: MaterialStateColor.resolveWith((states) {
                                return entry.key % 2 == 0
                                    ? Colors.white
                                    : _appColors.transparentBlueColor;
                              }),
                              cells: [
                                DataCell(Text('${entry.key + 1}')),
                                DataCell(Text(entry.value.invoiceNo ?? '')),
                                DataCell(Text(AppUtils.apiToAppDateFormat(
                                    entry.value.invoiceDate.toString()))),
                                //  DataCell(Text(entry.value.customerId ?? '')),
                                DataCell(Text(entry.value.customerName ?? '')),
                                DataCell(Text(entry.value.mobileNo ?? '')),
                                DataCell(Text(entry.value.billType.toString())),
                                DataCell(Text(AppUtils.formatCurrency(
                                    entry.value.totalInvoiceAmt?.toDouble() ??
                                        0))),
                                if (!iscancelled)
                                  DataCell(Text(AppUtils.formatCurrency(
                                      entry.value.totalPaidAmt?.toDouble() ??
                                          0))),
                                if (!iscancelled)
                                  DataCell(Text(AppUtils.formatCurrency(
                                      entry.value.pendingAmt?.toDouble() ??
                                          0))),
                                // DataCell(Text(AppUtils.formatCurrency(
                                //     entry.value.pendingAmt!.toDouble()))),
                                if (!iscancelled)
                                  DataCell(Chip(
                                      side: BorderSide(
                                          color: entry.value.paymentStatus ==
                                                  'COMPLETED'
                                              ? _appColors.successColor
                                              : _appColors.yellowColor),
                                      backgroundColor: _appColors.whiteColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      label: Text(
                                        entry.value.paymentStatus == 'COMPLETED'
                                            ? AppConstants.completed
                                            : AppConstants.pending,
                                        style: TextStyle(
                                            color: entry.value.paymentStatus ==
                                                    'COMPLETED'
                                                ? _appColors.successColor
                                                : _appColors.yellowColor),
                                      ))),
                                DataCell(
                                    Text(entry.value.createdByName.toString())),
                                if (!iscancelled)
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: SvgPicture.asset(
                                              AppConstants.icpayment),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return PaymentDailog(
                                                  salesdata: entry.value,
                                                  salesViewBloc: _salesViewBloc,
                                                  totalInvAmt: entry
                                                      .value.totalInvoiceAmt,
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                if (!iscancelled)
                                  DataCell(IconButton(
                                    onPressed: () async {
                                      final pdfData =
                                          await SalesPdfPrinter.generatePdf(
                                              entry.value);
                                      await Printing.layoutPdf(
                                        onLayout: (PdfPageFormat format) async {
                                          return pdfData;
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.print),
                                  )),
                                DataCell(
                                  PopupMenuButton(
                                    itemBuilder: (context) {
                                      return [
                                        const PopupMenuItem(
                                          value: 'cancel',
                                          child: Text('Cancel'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'view',
                                          child: Text('View'),
                                        ),
                                      ];
                                    },
                                    onSelected: (value) {
                                      if (value == 'cancel') {
                                      } else if (value == 'view') {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return _buildPaymentDetailsListView(
                                                entry);
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                CustomPagination(
                  itemsOnLastPage: salesDetails.totalElements ?? 0,
                  currentPage: currentPage,
                  totalPages: salesDetails.totalPages ?? 0,
                  onPageChanged: (pageValue) {
                    _salesViewBloc.pageNumberUpdateStreamController(pageValue);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPaymentDetailsListView(MapEntry<int, Content> entry) {
    return StreamBuilder<bool>(
        stream: _salesViewBloc.paymentDetailsListStream,
        builder: (context, snapshot) {
          return AlertDialog(
            surfaceTintColor: _appColors.whiteColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(
              AppConstants.paymentDetails,
              style: TextStyle(
                color: _appColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 400,
                  height: 300,
                  child: ListView.builder(
                    itemCount: entry.value.paidDetails?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(AppUtils.formatCurrency(
                            entry.value.paidDetails?[index].paidAmount ?? 0)),
                        subtitle: Text(
                            entry.value.paidDetails?[index].paymentType ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(AppUtils.apiToAppDateFormat(entry
                                    .value.paidDetails?[index].paymentDate
                                    .toString() ??
                                '')),
                            AppWidgetUtils.buildSizedBox(custWidth: 10),
                            entry.value.paidDetails![index].cancelled!
                                ? const Text(
                                    AppConstants.cancelled,
                                    style: TextStyle(color: Colors.red),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          surfaceTintColor:
                                              _appColors.whiteColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.cancel,
                                                color: _appColors.errorColor,
                                                size: 35,
                                              ),
                                              AppWidgetUtils.buildSizedBox(
                                                  custHeight: 10),
                                              const Text(
                                                'Are you sure you want to cancel the sales payment?',
                                                style: TextStyle(fontSize: 16),
                                              )
                                            ],
                                          ),
                                          actions: [
                                            CustomActionButtons(
                                                onPressed: () {
                                                  _salesViewBloc
                                                      .salesBillCancel(
                                                          (statusCode) {
                                                    if (statusCode == 200 ||
                                                        statusCode == 201) {
                                                      Navigator.pop(context);
                                                      _salesViewBloc
                                                          .pageNumberUpdateStreamController(
                                                              0);
                                                      _salesViewBloc
                                                          .paymentDetailsListStreamController(
                                                              true);
                                                      Navigator.pop(context);
                                                      AppWidgetUtils.buildToast(
                                                          context,
                                                          ToastificationType
                                                              .success,
                                                          AppConstants
                                                              .salesCancelled,
                                                          Icon(
                                                            Icons
                                                                .check_circle_outline_rounded,
                                                            color: _appColors
                                                                .successColor,
                                                          ),
                                                          AppConstants
                                                              .salesCancelledDes,
                                                          _appColors
                                                              .successLightColor);
                                                    } else {
                                                      AppWidgetUtils.buildToast(
                                                          context,
                                                          ToastificationType
                                                              .error,
                                                          AppConstants
                                                              .salesCancelledErr,
                                                          Icon(
                                                            Icons
                                                                .error_outline_outlined,
                                                            color: _appColors
                                                                .errorColor,
                                                          ),
                                                          AppConstants
                                                              .somethingWentWrong,
                                                          _appColors
                                                              .errorLightColor);
                                                    }
                                                  },
                                                          entry.value.salesId,
                                                          entry
                                                              .value
                                                              .paidDetails?[
                                                                  index]
                                                              .paymentId);
                                                },
                                                buttonText: AppConstants.submit)
                                          ],
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.cancel,
                                      color: _appColors.errorColor,
                                    ),
                                  )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  _buildVehicleTableHeader(String headerValue) => DataColumn(
        label: Expanded(
          child: Text(
            headerValue,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      );
}
