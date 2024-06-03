import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/insuranse/insuranse_view_bloc.dart';

class InsuranseView extends StatefulWidget {
  const InsuranseView({super.key});

  @override
  State<InsuranseView> createState() => _InsuranseViewState();
}

class _InsuranseViewState extends State<InsuranseView>
    with SingleTickerProviderStateMixin {
  final _appColors = AppColors();
  final _insuranceViewBlocImpl = InsuranceViewBlocImpl();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      _insuranceViewBlocImpl.tabChangeStreamControll(true);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> _insuranceList = [
    {
      'Invoice No': 'INV001',
      'Invoice Date': '2024-06-01',
      'Vehicle No': 'ABC123',
      'Customer ID': 'CUST001',
      'Customer Name': 'John Doe',
      'Mobile No': '1234567890',
      'Status': 'Active',
      'Created By': 'Admin',
    },
    {
      'Invoice No': 'INV002',
      'Invoice Date': '2024-06-02',
      'Vehicle No': 'XYZ456',
      'Customer ID': 'CUST002',
      'Customer Name': 'Jane Smith',
      'Mobile No': '9876543210',
      'Status': 'Inactive',
      'Created By': 'Manager',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppWidgetUtils.buildHeaderText(AppConstants.insurance),
            AppWidgetUtils.buildSizedBox(custHeight: 26),
            _buildSearchFilter(context),
            AppWidgetUtils.buildSizedBox(custHeight: 28),
            _buildTabBar(context),
            AppWidgetUtils.buildSizedBox(custHeight: 15),
            _buildTabBarView(context),
          ],
        ),
      ),
    );
  }

  _buildTabBar(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.2,
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: AppConstants.pending),
          Tab(text: AppConstants.completed),
        ],
      ),
    );
  }

  _buildTabBarView(BuildContext context) {
    return Expanded(
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          _buildInsuranceTableView(context),
          _buildInsuranceTableView(context),
        ],
      ),
    );
  }

  _buildSearchFilter(BuildContext context) {
    return Row(
      children: [
        _buildInvoiceSearch(),
        _buildMobileNoSearch(),
        _buildCustomerNameSearch(),
      ],
    );
  }

  Widget _buildInvoiceSearch() {
    return buildSearchField(
      hintText: AppConstants.invoiceNo,
      searchController: _insuranceViewBlocImpl.invoiceNoSearchController,
      searchStream: _insuranceViewBlocImpl.invoiceNoStream,
      searchStreamController: _insuranceViewBlocImpl.invoiceNoStreamController,
    );
  }

  Widget _buildMobileNoSearch() {
    return buildSearchField(
      hintText: AppConstants.mobileNumber,
      searchController: _insuranceViewBlocImpl.mobileNumberSearchController,
      searchStream: _insuranceViewBlocImpl.mobileNumberSearchStream,
      searchStreamController:
          _insuranceViewBlocImpl.mobileNumberSearchStreamController,
    );
  }

  Widget _buildCustomerNameSearch() {
    return buildSearchField(
      hintText: AppConstants.customerName,
      searchController: _insuranceViewBlocImpl.customerNameSearchController,
      searchStream: _insuranceViewBlocImpl.customerNameSearchStream,
      searchStreamController:
          _insuranceViewBlocImpl.customerNameSearchStreamController,
    );
  }

  Widget buildSearchField({
    required Stream<bool> searchStream,
    required TextEditingController searchController,
    required Function(bool) searchStreamController,
    required String hintText,
  }) {
    return StreamBuilder(
      stream: searchStream,
      builder: (context, snapshot) {
        bool isTextEmpty = searchController.text.isEmpty;
        IconData iconPath = isTextEmpty ? Icons.search : Icons.close;
        Color iconColor =
            isTextEmpty ? _appColors.primaryColor : _appColors.red;

        return AppWidgetUtils.buildSearchField(
          hintText,
          searchController,
          context,
          suffixIcon: IconButton(
            onPressed: () {
              if (iconPath == Icons.search) {
                if (searchController.text.isNotEmpty) {
                  searchStreamController(true);
                }
              } else {
                searchController.clear();
                searchStreamController(false);
              }
            },
            icon: Icon(
              iconPath,
              color: iconColor,
            ),
          ),
          onSubmit: (value) {
            if (value.isNotEmpty) {
              searchStreamController(true);
            }
          },
        );
      },
    );
  }

  Widget _buildInsuranceTableView(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        dividerThickness: 0.01,
        columns: [
          _buildinsuranseTableHeader(AppConstants.invoiceNo),
          _buildinsuranseTableHeader(AppConstants.invoiceDate),
          _buildinsuranseTableHeader(AppConstants.vehicleNo),
          _buildinsuranseTableHeader(AppConstants.customerID),
          _buildinsuranseTableHeader(AppConstants.customerName),
          _buildinsuranseTableHeader(AppConstants.mobileNo),
          _buildinsuranseTableHeader(AppConstants.status),
          _buildinsuranseTableHeader(AppConstants.createdBy),
          _buildinsuranseTableHeader(AppConstants.action),
        ],
        rows: _insuranceList.map((rowData) {
          final bool isEven = _insuranceList.indexOf(rowData).isEven;
          return DataRow(
            color: MaterialStateColor.resolveWith((states) {
              return isEven ? Colors.white : _appColors.transparentBlueColor;
            }),
            cells: [
              DataCell(Text(rowData[AppConstants.invoiceNo] ?? '')),
              DataCell(Text(rowData[AppConstants.invoiceDate] ?? '')),
              DataCell(Text(rowData[AppConstants.vehicleNo] ?? '')),
              DataCell(Text(rowData[AppConstants.customerID] ?? '')),
              DataCell(Text(rowData[AppConstants.customerName] ?? '')),
              DataCell(Text(rowData[AppConstants.mobileNo] ?? '')),
              DataCell(
                Chip(
                  label: const Text(
                    'Pending',
                    style: TextStyle(
                      color: Colors.yellow,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.yellow, width: 1),
                  ),
                ),
              ),
              DataCell(Text(rowData[AppConstants.createdBy] ?? '')),
              DataCell(SvgPicture.asset(AppConstants.icEdit)),
            ],
          );
        }).toList(),
      ),
    );
  }

  DataColumn _buildinsuranseTableHeader(String headerValue) => DataColumn(
        label: Text(
          headerValue,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
}
