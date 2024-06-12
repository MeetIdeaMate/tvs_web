import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/models/get_model/get_all_sales_list_model.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/sales/add_sales.dart';
import 'package:tlbilling/view/sales/sales_report_pdf.dart';
import 'package:tlbilling/view/sales/sales_view_bloc.dart';
import 'package:tlds_flutter/util/app_colors.dart';

class SalesViewScreen extends StatefulWidget {
  const SalesViewScreen({super.key});

  @override
  State<SalesViewScreen> createState() => _SalesViewScreenState();
}

class _SalesViewScreenState extends State<SalesViewScreen>
    with SingleTickerProviderStateMixin {
  final _salesViewBloc = SalesViewBlocImpl();
  final _appColors = AppColor();
  List<Map<String, String>> rowData = [
    {
      AppConstants.sno: '1',
      AppConstants.invoiceNo: 'INV-1234',
      AppConstants.invoiceDate: '16-05-24',
      AppConstants.customerId: 'CUS-4567',
      AppConstants.customerName: 'Ajith Kumar',
      AppConstants.mobileNumber: '+91 9876543210',
      AppConstants.paymentType: 'CASH',
      AppConstants.totalInvAmount: '₹ 1,000,00',
      AppConstants.pendingInvAmt: '₹ 1,000,00',
      AppConstants.balanceAmt: '₹ 1,000,00',
      AppConstants.status: 'Pending',
      AppConstants.createdBy: 'Admin',
    },
    {
      AppConstants.sno: '2',
      AppConstants.invoiceNo: 'INV-1234',
      AppConstants.invoiceDate: '16-05-24',
      AppConstants.customerId: 'CUS-4567',
      AppConstants.customerName: 'Senthil',
      AppConstants.mobileNumber: '+91 4567898768',
      AppConstants.paymentType: 'CASH',
      AppConstants.totalInvAmount: '₹ 1,000,00',
      AppConstants.pendingInvAmt: '₹ 1,000,00',
      AppConstants.balanceAmt: '₹ 1,000,00',
      AppConstants.status: 'Completed',
      AppConstants.createdBy: 'Admin',
    },
  ];

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
                searchStreamController: _salesViewBloc.invoiceNoStreamController
                //inputFormatters: TlInputFormatters.onlyAllowAlphabetAndNumber,
                ),
            AppWidgetUtils.buildSizedBox(
              custWidth: MediaQuery.sizeOf(context).width * 0.01,
            ),
            buildSearchField(
                searchStream: _salesViewBloc.paymentTypeStream,
                searchController: _salesViewBloc.paymentTypeTextController,
                hintText: AppConstants.paymentType,
                searchStreamController:
                    _salesViewBloc.paymentTypeStreamController
                //     inputFormatters: TlInputFormatters.onlyAllowAlphabets,
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
                        _salesViewBloc.customerNameStreamController
                    //  inputFormatters: TlInputFormatters.onlyAllowAlphabets,
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
                      builder: (context) => const AddSales(),
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

                  _salesViewBloc.getSalesList();
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
              _salesViewBloc.getSalesList();
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
          Tab(text: AppConstants.all),
          Tab(text: AppConstants.today),
          Tab(text: AppConstants.pending),
          Tab(text: AppConstants.completed),
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
          _buildCustomerTableView(context),
          _buildCustomerTableView(context),
          _buildCustomerTableView(context),
          _buildCustomerTableView(context),
        ],
      ),
    );
  }

  _buildCustomerTableView(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: StreamBuilder<int>(
          stream: _salesViewBloc.pageNumberStream,
          initialData: _salesViewBloc.currentPage,
          builder: (context, streamSnapshot) {
            int currentPage = streamSnapshot.data ?? 0;
            if (currentPage < 0) currentPage = 0;
            _salesViewBloc.currentPage = currentPage;
            return Column(
              children: [
                Expanded(
                  child: FutureBuilder(
                    future: _salesViewBloc.getSalesList(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: AppWidgetUtils.buildLoading());
                      } else if (!snapshot.hasData) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppConstants.imgNoData),
                          ],
                        );
                      }
                      List<SalesList> salesList =
                          snapshot.data?.salesList ?? [];
                      return DataTable(
                        key: UniqueKey(),
                        dividerThickness: 0.01,
                        columns: [
                          _buildVehicleTableHeader(
                            AppConstants.sno,
                          ),
                          _buildVehicleTableHeader(AppConstants.invoiceNo),
                          _buildVehicleTableHeader(AppConstants.invoiceDate),
                          _buildVehicleTableHeader(AppConstants.customerId),
                          _buildVehicleTableHeader(AppConstants.customerName),
                          _buildVehicleTableHeader(AppConstants.mobileNumber),
                          _buildVehicleTableHeader(AppConstants.paymentType),
                          _buildVehicleTableHeader(AppConstants.totalInvAmount),
                          _buildVehicleTableHeader(AppConstants.pendingInvAmt),
                          _buildVehicleTableHeader(AppConstants.balanceAmt),
                          _buildVehicleTableHeader(AppConstants.status),
                          _buildVehicleTableHeader(AppConstants.createdBy),
                          _buildVehicleTableHeader(AppConstants.action),
                          _buildVehicleTableHeader(AppConstants.print),
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
                              DataCell(
                                  Text(entry.value.invoiceDate.toString())),
                              DataCell(Text(entry.value.customerId ?? '')),
                              DataCell(Text(entry.value.customerId ?? '')),
                              DataCell(Text(entry.value.customerId ?? '')),
                              DataCell(Text(entry.value.totalCgst.toString())),
                              DataCell(
                                  Text(entry.value.totalInvoiceAmt.toString())),
                              DataCell(Text(entry.value.totalQty.toString())),
                              DataCell(Text(entry.value.totalSgst.toString())),
                              DataCell(Chip(
                                  label: Text(entry.value.billType ?? ''))),
                              DataCell(
                                  Text(entry.value.totalTaxableAmt.toString())),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon:
                                          SvgPicture.asset(AppConstants.icEdit),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(IconButton(
                                  onPressed: () async {
                                    final pdfData =
                                        await SalesPdfPrinter.generatePdf();
                                    await Printing.layoutPdf(
                                      onLayout: (PdfPageFormat format) async {
                                        return pdfData;
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.print))),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),

                //     CustomPagination(
                //   itemsOnLastPage: _salesViewBloc.totalElements ?? 0,
                //   currentPage: currentPage,
                //   totalPages: employeeListmodel.totalPages ?? 0,
                //   onPageChanged: (pageValue) {
                //     _employeeViewBloc
                //         .pageNumberUpdateStreamController(pageValue);
                //   },
                // ),
              ],
            );
          }),
    );
  }

  _buildVehicleTableHeader(String headerValue) => DataColumn(
        label: Text(
          headerValue,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      );
}
