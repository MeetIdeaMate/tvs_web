import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/components/custom_form_field.dart';
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
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';
import 'package:tlds_flutter/util/app_colors.dart';
import 'package:toastification/toastification.dart';

class SalesViewScreen extends StatefulWidget {
  const SalesViewScreen({super.key});

  @override
  State<SalesViewScreen> createState() => _SalesViewScreenState();
}

class _SalesViewScreenState extends State<SalesViewScreen>
    with TickerProviderStateMixin {
  final _salesViewBloc = SalesViewBlocImpl();
  final _appColors = AppColor();

  @override
  void initState() {
    super.initState();
    _salesViewBloc.salesTabController = TabController(length: 4, vsync: this);
    _salesViewBloc.salesDetailsTabController =
        TabController(length: 2, vsync: this);
    getBranchName();
  }

  @override
  void dispose() {
    _salesViewBloc.salesBillCancelReasonTextController.clear();
    super.dispose();
  }

  Future<void> getBranchName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // _salesViewBloc.branchId = prefs.getString('branchName') ?? '';
      _salesViewBloc.isMainBranch = prefs.getBool('mainBranch');
    });
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
            AppWidgetUtils.buildSizedBox(custWidth: 5),
            buildSearchField(
              searchStream: _salesViewBloc.paymentTypeStream,
              searchController: _salesViewBloc.paymentTypeTextController,
              hintText: AppConstants.paymentType,
              searchStreamController:
                  _salesViewBloc.paymentTypeStreamController,
              inputFormatters: TlInputFormatters.onlyAllowAlphabets,
            ),
            AppWidgetUtils.buildSizedBox(custWidth: 5),
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
            AppWidgetUtils.buildSizedBox(custWidth: 5),
            if (_salesViewBloc.isMainBranch ?? false) _buildBranchDropdown()
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

  _buildBranchDropdown() {
    return FutureBuilder(
        future: _salesViewBloc.getBranchName(),
        builder: (context, snapshot) {
          List<String>? branchNameList = snapshot.data?.result?.getAllBranchList
              ?.map((e) => e.branchName)
              .where((branchName) => branchName != null)
              .cast<String>()
              .toList();
          branchNameList?.insert(0, AppConstants.allBranch);
          return _buildDropDown(
            dropDownItems: (snapshot.hasData &&
                    (snapshot.data?.result?.getAllBranchList?.isNotEmpty ==
                        true))
                ? branchNameList
                : List.empty(),
            hintText: (snapshot.connectionState == ConnectionState.waiting)
                ? AppConstants.loading
                : (snapshot.hasError || snapshot.data == null)
                    ? AppConstants.errorLoading
                    : AppConstants.branchName,
            selectedvalue: AppConstants.allBranch,
            onChange: (value) {
              _salesViewBloc.branchId = value;

              _salesViewBloc.pageNumberUpdateStreamController(0);
            },
          );
        });
  }

  _buildDropDown(
      {List<String>? dropDownItems,
      String? hintText,
      String? selectedvalue,
      Function(String?)? onChange}) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: TldsDropDownButtonFormField(
        width: MediaQuery.of(context).size.width * 0.1,
        height: 40,
        dropDownItems: dropDownItems!,
        dropDownValue: selectedvalue,
        hintText: hintText,
        onChange: onChange ??
            (String? newValue) {
              selectedvalue = newValue ?? '';
            },
      ),
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
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: SvgPicture.asset(AppConstants.imgNoData)),
                  const Text('No Sales data')
                ],
              );
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
                            _buildVehicleTableHeader(AppConstants.customerName),
                            _buildVehicleTableHeader(AppConstants.mobileNumber),
                            _buildVehicleTableHeader(AppConstants.categoryName),
                            _buildVehicleTableHeader(AppConstants.paymentType),
                            _buildVehicleTableHeader(
                                AppConstants.totalInvAmount),
                            _buildVehicleTableHeader(AppConstants.netAmt),
                            if (!iscancelled)
                              _buildVehicleTableHeader(AppConstants.paidAmt),
                            if (!iscancelled && paymentStatus != 'COMPLETED')
                              _buildVehicleTableHeader(
                                  AppConstants.pendingInvAmt),
                            if (paymentStatus ==
                                DateFormat('yyyy-MM-dd').format(DateTime.now()))
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
                              color: WidgetStateColor.resolveWith((states) {
                                return entry.key % 2 == 0
                                    ? Colors.white
                                    : _appColors.transparentBlueColor;
                              }),
                              cells: [
                                DataCell(Text('${entry.key + 1}')),
                                DataCell(Text(entry.value.invoiceNo ?? '')),
                                DataCell(Text(AppUtils.apiToAppDateFormat(
                                    entry.value.invoiceDate.toString()))),
                                DataCell(Text(entry.value.customerName ?? '')),
                                DataCell(Text(entry.value.mobileNo ?? '')),
                                DataCell(Text(entry.value.invoiceType ?? '')),
                                DataCell(Text(entry.value.billType.toString())),
                                DataCell(Text(AppUtils.formatCurrency(
                                    entry.value.totalInvoiceAmt?.toDouble() ??
                                        0))),
                                DataCell(Text(AppUtils.formatCurrency(
                                    entry.value.netAmt?.toDouble() ?? 0))),
                                if (!iscancelled)
                                  DataCell(Text(AppUtils.formatCurrency(
                                      entry.value.totalPaidAmt?.toDouble() ??
                                          0))),
                                if (!iscancelled &&
                                    paymentStatus != 'COMPLETED')
                                  DataCell(Text(AppUtils.formatCurrency(
                                      entry.value.pendingAmt?.toDouble() ??
                                          0))),
                                if (paymentStatus ==
                                    DateFormat('yyyy-MM-dd')
                                        .format(DateTime.now()))
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
                                              barrierDismissible: false,
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
                                    icon: SvgPicture.asset(
                                      AppConstants.icPrint,
                                      colorFilter: const ColorFilter.mode(
                                          Colors.black, BlendMode.srcIn),
                                    ),
                                  )),
                                DataCell(
                                  PopupMenuButton(
                                    itemBuilder: (context) {
                                      return [
                                        if (paymentStatus != 'COMPLETED' &&
                                            paymentStatus != '')
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
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) =>
                                              _buildSalesBillCancelDialog(
                                                  context, entry),
                                        ).then((value) {
                                          _salesViewBloc
                                              .salesBillCancelReasonTextController
                                              .clear();
                                        });
                                      } else if (value == 'view') {
                                        showDialog(
                                          barrierDismissible: false,
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

  Widget _buildSalesBillCancelDialog(
      BuildContext context, MapEntry<int, Content> entry) {
    return AlertDialog(
      surfaceTintColor: _appColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Form(
        key: _salesViewBloc.salesCancelFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cancel,
              color: _appColors.errorColor,
              size: 35,
            ),
            AppWidgetUtils.buildSizedBox(custHeight: 10),
            const Text(
              'Are you sure you want to cancel the sales bill?',
              style: TextStyle(fontSize: 16),
            ),
            CustomFormField(
              hintText: AppConstants.enterCancelReason,
              maxLine: 300,
              height: 80,
              controller: _salesViewBloc.salesBillCancelReasonTextController,
              validator: (value) {
                if (value!.isEmpty) {
                  return AppConstants.enterCancelReason;
                }
                return null;
              },
            )
          ],
        ),
      ),
      actions: [
        CustomActionButtons(
            onPressed: () {
              if (_salesViewBloc.salesCancelFormKey.currentState!.validate()) {
                _salesViewBloc.salesBillCancel((statusCode) {
                  if (statusCode == 200 || statusCode == 201) {
                    Navigator.pop(context);
                    _salesViewBloc.pageNumberUpdateStreamController(0);
                    AppWidgetUtils.buildToast(
                        context,
                        ToastificationType.success,
                        AppConstants.salesCancelled,
                        Icon(
                          Icons.check_circle_outline_rounded,
                          color: _appColors.successColor,
                        ),
                        AppConstants.salesCancelledDes,
                        _appColors.successLightColor);
                    _salesViewBloc.salesBillCancelReasonTextController.clear();
                  } else {
                    AppWidgetUtils.buildToast(
                        context,
                        ToastificationType.error,
                        AppConstants.salesCancelledErr,
                        Icon(
                          Icons.error_outline_outlined,
                          color: _appColors.errorColor,
                        ),
                        AppConstants.somethingWentWrong,
                        _appColors.errorLightColor);
                  }
                }, entry.value.salesId,
                    _salesViewBloc.salesBillCancelReasonTextController.text);
              }
            },
            buttonText: AppConstants.submit)
      ],
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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppConstants.vehicleDetails,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _appColors.primaryColor)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            content: SizedBox(
              width: 650,
              height: 400,
              child: Column(
                children: [
                  TabBar(
                    controller: _salesViewBloc.salesDetailsTabController,
                    tabs: const [
                      Tab(text: AppConstants.vehicleDetails),
                      Tab(text: AppConstants.paymentDetails),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _salesViewBloc.salesDetailsTabController,
                      children: [
                        _buildVehicleDetails(entry),
                        _paymentDetailsTab(entry),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _buildVehicleDetails(MapEntry<int, Content> entry) {
    return SizedBox(
      width: 400,
      height: 300,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: entry.value.itemDetails?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                final item = entry.value.itemDetails![index];
                return Column(
                  children: [
                    ListTile(
                        title: Text(item.itemName ?? ''),
                        subtitle: Text(item.partNo ?? ''),
                        trailing: Badge(
                          label: Text(item.quantity.toString()),
                        )),
                    if (entry.value.invoiceType != 'Accessories')
                      ListTile(
                        title: const Text(AppConstants.engineNumber),
                        subtitle: Text(entry.value.itemDetails?[index]
                                .mainSpecValue?.engineNumber ??
                            ''),
                      ),
                    if (entry.value.invoiceType != 'Accessories')
                      ListTile(
                        title: const Text(AppConstants.frameNumber),
                        subtitle: Text(entry.value.itemDetails?[index]
                                .mainSpecValue?.frameNumber ??
                            ''),
                      ),
                    if (item.gstDetails != null && item.gstDetails!.isNotEmpty)
                      ListTile(
                        title: const Text('GST Details'),
                        subtitle: Text(
                          item.gstDetails!
                              .map((gst) =>
                                  "${gst.gstName}: ${AppUtils.formatCurrency(gst.gstAmount ?? 0)}")
                              .join(', '),
                        ),
                      ),
                    Visibility(
                      visible: (item.discount ?? 0) < 0,
                      child: ListTile(
                        title: const Text(AppConstants.discount),
                        subtitle:
                            Text(AppUtils.formatCurrency(item.discount ?? 0)),
                      ),
                    ),
                    ListTile(
                      title: const Text(AppConstants.discount),
                      subtitle:
                          Text(AppUtils.formatCurrency(item.discount ?? 0)),
                    ),
                    if (entry.value.invoiceType != 'Accessories')
                      const Divider()
                  ],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerRight,
            child: Text(
              "Final Invoice Amount: ${AppUtils.formatCurrency(entry.value.itemDetails!.fold(0, (sum, item) => sum + (item.finalInvoiceValue ?? 0)))}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  SizedBox _paymentDetailsTab(MapEntry<int, Content> entry) {
    return SizedBox(
      width: 400,
      height: 300,
      child: ListView.builder(
        itemCount: entry.value.paidDetails?.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(AppUtils.formatCurrency(
                entry.value.paidDetails?[index].paidAmount ?? 0)),
            subtitle: Text(entry.value.paidDetails?[index].paymentType ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppUtils.apiToAppDateFormat(
                    entry.value.paidDetails?[index].paymentDate.toString() ??
                        '')),
                AppWidgetUtils.buildSizedBox(custWidth: 10),
                entry.value.paidDetails![index].cancelled!
                    ? const Text(
                        AppConstants.cancelled,
                        style: TextStyle(color: Colors.red),
                      )
                    : entry.value.paymentStatus == 'PENDING'
                        ? IconButton(
                            onPressed: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => AlertDialog(
                                  surfaceTintColor: _appColors.whiteColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  content: Form(
                                    key: _salesViewBloc.salesCancelFormKey,
                                    child: Column(
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
                                          AppConstants.salesCancelDialogMessage,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        AppWidgetUtils.buildSizedBox(
                                            custHeight: 10),
                                        CustomFormField(
                                          hintText:
                                              AppConstants.enterCancelReason,
                                          maxLine: 300,
                                          height: 80,
                                          controller: _salesViewBloc
                                              .salesBillCancelReasonTextController,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return AppConstants
                                                  .enterCancelReason;
                                            }
                                            return null;
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    CustomActionButtons(
                                        onPressed: () {
                                          if (_salesViewBloc
                                              .salesCancelFormKey.currentState!
                                              .validate()) {
                                            _salesViewBloc.salesBillPaymentCancel(
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
                                                    ToastificationType.success,
                                                    AppConstants.salesCancelled,
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
                                                    ToastificationType.error,
                                                    AppConstants
                                                        .salesCancelledErr,
                                                    Icon(
                                                      Icons
                                                          .error_outline_outlined,
                                                      color:
                                                          _appColors.errorColor,
                                                    ),
                                                    AppConstants
                                                        .somethingWentWrong,
                                                    _appColors.errorLightColor);
                                              }
                                            },
                                                entry.value.salesId,
                                                entry.value.paidDetails?[index]
                                                    .paymentId,
                                                _salesViewBloc
                                                    .salesBillCancelReasonTextController
                                                    .text);
                                          }
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
                        : const SizedBox()
              ],
            ),
          );
        },
      ),
    );
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
