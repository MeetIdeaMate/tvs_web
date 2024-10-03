import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tlbilling/models/get_model/get_all_customers_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/insuranse/insuranse_view_bloc.dart';
import 'package:tlbilling/components/custom_pagenation.dart';
import 'package:tlbilling/models/get_model/get_all_insurance_by_pagination_model.dart';

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
            _buildSearchFilterAddButton(context),
            AppWidgetUtils.buildSizedBox(custHeight: 28),
            _buildTabBar(context),
            AppWidgetUtils.buildSizedBox(custHeight: 15),
            _buildTabBarView(context),
          ],
        ),
      ),
    );
  }

  _buildSearchFilterAddButton(BuildContext context) {
    return Row(
      children: [
        _buildInvoiceNoSearch(),
        _buildMobileNoSearch(),
        _buildCustomerNameSearch(),
      ],
    );
  }

  Widget _buildInvoiceNoSearch() {
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
                  _insuranceViewBlocImpl.pageNumberUpdateStreamController(0);
                }
              } else {
                searchController.clear();
                searchStreamController(false);
                _insuranceViewBlocImpl.pageNumberUpdateStreamController(0);
              }
            },
            icon: Icon(iconPath, color: iconColor),
          ),
          onSubmit: (value) {
            if (value.isNotEmpty) {
              searchStreamController(true);
              _insuranceViewBlocImpl.pageNumberUpdateStreamController(0);
            }
          },
        );
      },
    );
  }

  _buildTabBar(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
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
          _buildInsuranceTableView(context, AppConstants.pending),
          _buildInsuranceTableView(context, AppConstants.completed),
        ],
      ),
    );
  }

  Widget _buildInsuranceTableView(BuildContext context, String status) {
    return StreamBuilder<int>(
      stream: _insuranceViewBlocImpl.pageNumberStream,
      initialData: _insuranceViewBlocImpl.currentPage,
      builder: (context, streamSnapshot) {
        int currentPage = streamSnapshot.data ?? 0;
        if (currentPage < 0) currentPage = 0;
        _insuranceViewBlocImpl.currentPage = currentPage;

        return FutureBuilder<GetAllInsuranceByPaginationModel?>(
          future: _insuranceViewBlocImpl.getAllInsuranceByPagination(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: AppWidgetUtils.buildLoading());
            } else if (snapshot.hasError) {
              return const Center(child: Text(AppConstants.somethingWentWrong));
            } else if (snapshot.hasData) {
              if (snapshot.data?.insuranceDataList?.isEmpty ?? false) {
                return Center(
                  child: SvgPicture.asset(AppConstants.imgNoData),
                );
              }
            }

            GetAllInsuranceByPaginationModel insuranceListModel =
                snapshot.data!;

            print('insuranceListModel $insuranceListModel');

            List<InsuranceDataList> insuranceData =
                snapshot.data?.insuranceDataList ?? [];

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        dividerThickness: 0.01,
                        columns: [
                          _buildInsuranceTableHeader(AppConstants.sno),
                          _buildInsuranceTableHeader(AppConstants.invoiceNo),
                          _buildInsuranceTableHeader(AppConstants.insuredDate),
                          _buildInsuranceTableHeader(AppConstants.vehicleNo),
                          _buildInsuranceTableHeader(AppConstants.insuranceNo),
                          _buildInsuranceTableHeader(
                              AppConstants.insuranceCompanyName),
                          _buildInsuranceTableHeader(AppConstants.customerName),
                          _buildInsuranceTableHeader(AppConstants.mobileNo),
                          _buildInsuranceTableHeader(
                              AppConstants.thirdPartyExpiryDate),
                        ],
                        rows: insuranceData.asMap().entries.map((entry) {
                          return DataRow(
                            color: WidgetStateColor.resolveWith((states) {
                              return entry.key % 2 == 0
                                  ? Colors.white
                                  : _appColors.transparentBlueColor;
                            }),
                            cells: [
                              DataCell(Text('${entry.key + 1}')),
                              DataCell(Text(entry.value.invoiceNo ?? '')),
                              DataCell(
                                  Text(entry.value.insuredDate.toString())),
                              DataCell(Text(entry.value.vehicleNo ?? '')),
                              DataCell(Text(entry.value.insuranceNo ?? '')),
                              DataCell(
                                  Text(entry.value.insuranceCompanyName ?? '')),
                              DataCell(Text(entry.value.customerName ?? '')),
                              DataCell(Text(entry.value.mobileNo ?? '')),
                              DataCell(Text(
                                  entry.value.thirdPartyExpiryDate.toString())),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                CustomPagination(
                  itemsOnLastPage: insuranceListModel.totalElements ?? 0,
                  currentPage: currentPage,
                  totalPages: insuranceListModel.totalPages ?? 0,
                  onPageChanged: (pageValue) {
                    _insuranceViewBlocImpl
                        .pageNumberUpdateStreamController(pageValue);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  DataColumn _buildInsuranceTableHeader(String text) {
    return DataColumn(
      label: Expanded(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
