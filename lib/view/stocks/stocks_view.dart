import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlbilling/components/custom_pagenation.dart';
import 'package:tlbilling/models/get_model/get_all_branches_by_pagination.dart';
import 'package:tlbilling/models/get_model/get_all_stock_with_pagination.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlbilling/view/stocks/stocks_view_bloc.dart';
import 'package:tlbilling/view/useraccess/access_level_shared_pref.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:tlds_flutter/util/app_colors.dart';

class StocksView extends StatefulWidget {
  const StocksView({super.key});

  @override
  State<StocksView> createState() => _StocksViewState();
}

class _StocksViewState extends State<StocksView>
    with SingleTickerProviderStateMixin {
  final _appColors = AppColors();
  final _stocksViewBloc = StocksViewBlocImpl();

  @override
  void initState() {
    super.initState();
    _stocksViewBloc.stocksTableTableController =
        TabController(length: 2, vsync: this);
    getBranchId();
  }

  Future<void> getBranchId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _stocksViewBloc.branchId = prefs.getString('branchId') ?? '';
    _stocksViewBloc.isMainBranch = prefs.getBool('mainBranch') ?? false;
    _stocksViewBloc.getBranchesList().then((value) {
      for (BranchDetail element in value ?? []) {
        if (_stocksViewBloc.branchId == element.branchId) {
          setState(() {
            _stocksViewBloc.selectedBranch = AppConstants.allBranch;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 21),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppWidgetUtils.buildHeaderText(AppConstants.stocks),
            AppWidgetUtils.buildSizedBox(custHeight: 26),
            if (AccessLevel.canView(AppConstants.stocks)) ...[
              _buildStocksFilters(),
              _buildDefaultHeight(),
              _buildTabBar(),
              _buildTabBarView(),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildStocksFilters() {
    return Row(
      children: [
        StreamBuilder(
          stream: _stocksViewBloc.partNumberSearchControllerStream,
          builder: (context, snapshot) {
            final bool isTextEmpty =
                _stocksViewBloc.partNumberSearchController.text.isEmpty;
            final IconData iconData = isTextEmpty ? Icons.search : Icons.close;
            final Color iconColor =
                isTextEmpty ? _appColors.primaryColor : Colors.red;
            return TldsInputFormField(
              inputFormatters: TlInputFormatters.onlyAllowAlphabetAndNumber,
              width: 203,
              height: 40,
              controller: _stocksViewBloc.partNumberSearchController,
              hintText: AppConstants.partNo,
              isSearch: true,
              suffixIcon: IconButton(
                onPressed: () {
                  isTextEmpty
                      ? null
                      : _stocksViewBloc.partNumberSearchController.clear();
                  _stocksViewBloc.partNumberSearchStreamController(true);

                  _stocksViewBloc.getAllStockByPagenation('');
                  _stocksViewBloc.pageNumberUpdateStreamController(0);
                },
                icon: Icon(
                  iconData,
                  color: iconColor,
                ),
              ),
              onSubmit: (p0) {
                _stocksViewBloc.getAllStockByPagenation('');
                _stocksViewBloc.pageNumberUpdateStreamController(0);
                _stocksViewBloc.partNumberSearchStreamController(true);
              },
            );
          },
        ),
        _buildDefaultWidth(),
        StreamBuilder(
          stream: _stocksViewBloc.vehicleNameSearchControllerStream,
          builder: (context, snapshot) {
            final bool isTextEmpty =
                _stocksViewBloc.vehicleNameSearchController.text.isEmpty;
            final IconData iconData = isTextEmpty ? Icons.search : Icons.close;
            final Color iconColor =
                isTextEmpty ? _appColors.primaryColor : Colors.red;
            return TldsInputFormField(
              inputFormatters: TlInputFormatters.onlyAllowAlphabetsAndSpaces,
              width: 203,
              height: 40,
              isSearch: true,
              controller: _stocksViewBloc.vehicleNameSearchController,
              hintText: AppConstants.vehicleName,
              suffixIcon: IconButton(
                onPressed: () {
                  isTextEmpty
                      ? null
                      : _stocksViewBloc.vehicleNameSearchController.clear();
                  _stocksViewBloc.vehicleNameSearchStreamController(true);
                  _stocksViewBloc.getAllStockByPagenation('');
                  _stocksViewBloc.pageNumberUpdateStreamController(0);
                },
                icon: Icon(
                  iconData,
                  color: iconColor,
                ),
              ),
              onSubmit: (p0) {
                _stocksViewBloc.getAllStockByPagenation('');
                _stocksViewBloc.pageNumberUpdateStreamController(0);
                _stocksViewBloc.vehicleNameSearchStreamController(true);
              },
            );
          },
        ),
        _buildDefaultWidth(),
        if (_stocksViewBloc.isMainBranch ?? false) _buildBranchList()
      ],
    );
  }

  Widget _buildBranchList() {
    return FutureBuilder(
      future: _stocksViewBloc.getBranchesList(),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: AppWidgetUtils.buildLoading(),
          );
        } else if (futureSnapshot.hasData) {
          List<BranchDetail> branches = futureSnapshot.data ?? [];
          List<String> branchNameList =
              branches.map((e) => e.branchName ?? '').toList();
          branchNameList.insert(0, AppConstants.allBranch);

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder(
                stream: _stocksViewBloc.branchNameDropdownStream,
                builder: (context, snapshot) {
                  return TldsDropDownButtonFormField(
                    height: 40,
                    width: 300,
                    hintText: AppConstants.fromBranch,
                    dropDownItems: branchNameList,
                    dropDownValue: _stocksViewBloc.selectedBranch,
                    onChange: (String? newValue) async {
                      _stocksViewBloc.selectedBranch = newValue ?? '';
                      if (newValue == AppConstants.allBranch) {
                        _stocksViewBloc.branchId = '';
                      } else {
                        BranchDetail? selectedBranch = branches.firstWhere(
                          (branch) => branch.branchName == newValue,
                        );
                        _stocksViewBloc.branchId =
                            selectedBranch.branchId ?? '';
                      }
                      _stocksViewBloc.branchNameDropdownStreamController(true);
                      _stocksViewBloc.pageNumberUpdateStreamController(0);
                    },
                  );
                },
              ),
            ],
          );
        }
        return const Text('No Data');
      },
    );
  }

  Widget _buildTabBar() {
    return SizedBox(
      width: 250,
      child: TabBar(
        controller: _stocksViewBloc.stocksTableTableController,
        tabs: const [
          Tab(text: AppConstants.vehicle),
          Tab(text: AppConstants.accessories),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _stocksViewBloc.stocksTableTableController,
        children: [
          _buildStockListTableView(context),
          _buildStockListTableView(context)
        ],
      ),
    );
  }

  Widget _buildDefaultWidth() {
    return AppWidgetUtils.buildSizedBox(
        custWidth: MediaQuery.sizeOf(context).width * 0.01);
  }

  Widget _buildDefaultHeight() {
    return AppWidgetUtils.buildSizedBox(
        custHeight: MediaQuery.sizeOf(context).height * 0.02);
  }

  Widget _buildStockListTableView(BuildContext context) {
    return StreamBuilder<int>(
      stream: _stocksViewBloc.pageNumberStream,
      initialData: _stocksViewBloc.currentPage,
      builder: (context, streamSnapshot) {
        int currentPage = streamSnapshot.data ?? 0;
        if (currentPage < 0) currentPage = 0;
        _stocksViewBloc.currentPage = currentPage;
        return FutureBuilder(
          future: _stocksViewBloc.getAllStockByPagenation(() {
            switch (_stocksViewBloc.stocksTableTableController.index) {
              case 0:
                return AppConstants.vehicle;
              case 1:
                return AppConstants.accessories;
              default:
                return '';
            }
          }()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: AppWidgetUtils.buildLoading());
            } else if (snapshot.hasError) {
              return const Center(child: Text(AppConstants.somethingWentWrong));
            } else if (!snapshot.hasData ||
                snapshot.data?.stockDetailsList?.isEmpty == true) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppConstants.imgNoData),
                    AppWidgetUtils.buildSizedBox(custHeight: 8),
                    Text(
                      AppConstants.noStockDataAvailable,
                      style: TextStyle(color: _appColors.grey),
                    )
                  ],
                ),
              );
            }
            GetAllStocksByPagenation stockListModel = snapshot.data!;
            List<StockDetailsList> purchasedata =
                stockListModel.stockDetailsList ?? [];
            return Column(
              children: [
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          dividerThickness: 0.01,
                          columns: [
                            _buildVehicleTableHeader(AppConstants.sno),
                            _buildVehicleTableHeader(AppConstants.branch),
                            _buildVehicleTableHeader(AppConstants.partNo),
                            _buildVehicleTableHeader(AppConstants.vehicleName),
                            _buildVehicleTableHeader(AppConstants.categoryName),
                            _buildVehicleTableHeader(AppConstants.stockStatus),
                            _buildVehicleTableHeader(AppConstants.quantity),
                            _buildVehicleTableHeader(AppConstants.action),
                          ],
                          rows: purchasedata.asMap().entries.map((entry) {
                            return DataRow(
                              color: WidgetStateColor.resolveWith((states) {
                                return entry.key % 2 == 0
                                    ? Colors.white
                                    : _appColors.transparentBlueColor;
                              }),
                              cells: [
                                _buildTableRow('${entry.key + 1}'),
                                _buildTableRow(entry.value.branchName),
                                _buildTableRow(entry.value.partNo),
                                _buildTableRow(entry.value.itemName),
                                _buildTableRow(entry.value.categoryName),
                                //  _buildTableRow(entry.value.stockStatus),
                                DataCell(Chip(
                                    side: BorderSide(
                                        color: entry.value.stockStatus ==
                                                AppConstants.available
                                            ? _appColors.successColor
                                            : _appColors.yellowColor),
                                    backgroundColor: _appColors.whiteColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    label: Text(
                                      entry.value.stockStatus ==
                                              AppConstants.available
                                          ? AppConstants.available
                                          : AppConstants.transfer,
                                      style: TextStyle(
                                          color: entry.value.stockStatus ==
                                                  AppConstants.available
                                              ? _appColors.successColor
                                              : _appColors.yellowColor),
                                    ))),
                                _buildTableRow(
                                    entry.value.totalQuantity.toString()),
                                DataCell(IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return _buildStockDetailsDialog(
                                              entry.value);
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.table_chart_outlined,
                                      color: AppColor().primaryColor,
                                    ))),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                CustomPagination(
                  itemsOnLastPage: stockListModel.totalElements ?? 0,
                  currentPage: currentPage,
                  totalPages: stockListModel.totalPages ?? 0,
                  onPageChanged: (pageValue) {
                    _stocksViewBloc.pageNumberUpdateStreamController(pageValue);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  DataCell _buildTableRow(String? text) => DataCell(Text(
        text ?? '',
        style: const TextStyle(fontSize: 14),
      ));

  DataColumn _buildVehicleTableHeader(String headerValue) {
    return DataColumn(
      label: Text(
        headerValue,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStockDetailsDialog(StockDetailsList stockDetails) {
    return AlertDialog(
      surfaceTintColor: AppColor().whiteColor,
      backgroundColor: AppColor().whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppConstants.vehicleDetails,
            style: TextStyle(color: AppColor().primaryColor),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      content: SizedBox(
        height: 400,
        width: 530,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpansionTile(
                title: Text(
                  stockDetails.itemName ?? 'N/A',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(stockDetails.partNo ?? 'N/A'),
                expandedAlignment: Alignment.topLeft,
                dense: true,
                children: _stocksViewBloc.stocksTableTableController.index == 0
                    ? [
                        DataTable(
                          columns: [
                            const DataColumn(
                              label: Text(
                                AppConstants.sno,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            _buildVehicleTableHeader(AppConstants.engineNumber),
                            _buildVehicleTableHeader(AppConstants.frameNumber),
                          ],
                          rows: stockDetails.stockItems!
                              .asMap()
                              .entries
                              .map((entry) {
                            final index = entry.key;
                            final value = entry.value;
                            return DataRow(
                              color: WidgetStateColor.resolveWith((states) {
                                return index % 2 == 0
                                    ? Colors.white
                                    : AppColor().transparentBlueColor;
                              }),
                              cells: [
                                _buildTableRow((index + 1).toString()),
                                _buildTableRow(
                                    value.mainSpecValue?.engineNo ?? 'N/A'),
                                _buildTableRow(
                                    value.mainSpecValue?.frameNo ?? 'N/A'),
                              ],
                            );
                          }).toList(),
                        )
                      ]
                    : [],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
