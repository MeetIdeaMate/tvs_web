import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tlbilling/components/custom_pagenation.dart';
import 'package:tlbilling/models/get_model/get_all_stocks_by_id_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/purchase/vehicle_details_dialog.dart';
import 'package:tlbilling/view/stocks/stocks_view_bloc.dart';
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
            _buildStocksFilters(),
            _buildDefaultHeight(),
            _buildTabBar(),
            _buildTabBarView(),
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
      ],
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
          future: _stocksViewBloc.getAllStockByPagenation(
              _stocksViewBloc.stocksTableTableController.index == 0
                  ? AppConstants.vehicle
                  : AppConstants.accessories),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: AppWidgetUtils.buildLoading());
            } else if (snapshot.hasData) {
              GetAllStocksByPagenation employeeListmodel = snapshot.data!;
              List<StockDetailsList> purchasedata =
                  snapshot.data?.content ?? [];
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: DataTable(
                          dividerThickness: 0.01,
                          columns: [
                            _buildVehicleTableHeader(AppConstants.sno),
                            _buildVehicleTableHeader(AppConstants.branch),
                            _buildVehicleTableHeader(AppConstants.partNo),
                            _buildVehicleTableHeader(AppConstants.vehicleName),
                            _buildVehicleTableHeader(AppConstants.hsnCode),
                            _buildVehicleTableHeader(AppConstants.quantity),
                            _buildVehicleTableHeader(AppConstants.action),
                          ],
                          rows: purchasedata.asMap().entries.map((entry) {
                            return DataRow(
                              color: MaterialStateColor.resolveWith((states) {
                                return entry.key % 2 == 0
                                    ? Colors.white
                                    : _appColors.transparentBlueColor;
                              }),
                              cells: [
                                _buildTableRow('${entry.key + 1}'),
                                _buildTableRow(entry.value.branchName),
                                _buildTableRow(entry.value.partNo),
                                _buildTableRow(entry.value.itemName),
                                _buildTableRow(entry.value.hsnSacCode),
                                _buildTableRow(entry.value.quantity.toString()),
                                DataCell(IconButton(
                                    onPressed: () {
                                      // showDialog(
                                      //   context: context,
                                      //   builder: (context) {
                                      //     return _buildStockDetailsDialog(entry.value);
                                      //   },
                                      // );
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
                  CustomPagination(
                    itemsOnLastPage: employeeListmodel.totalElements ?? 0,
                    currentPage: currentPage,
                    totalPages: employeeListmodel.totalPages ?? 0,
                    onPageChanged: (pageValue) {},
                  ),
                ],
              );
            } else {
              return Center(child: SvgPicture.asset(AppConstants.imgNoData));
            }
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

//  Widget _buildStockDetailsDialog(StockDetailsList stockDetails) {
//   return AlertDialog(
//     surfaceTintColor: AppColor().whiteColor,
//     backgroundColor: AppColor().whiteColor,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//     title: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           'Vehicle Details',
//           style: TextStyle(color: AppColor().primaryColor),
//         ),
//         IconButton(
//           icon: const Icon(Icons.close),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ],
//     ),
//     content: SizedBox(
//       height: 400,
//       width: 530,
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ExpansionTile(
//               title: Text(stockDetails.itemName ?? 'N/A'),
//               subtitle: Text(stockDetails.partNo ?? 'N/A'),
//               expandedAlignment: Alignment.topLeft,
//               dense: true,
//               children: [
//                 DataTable(
//                   columns: [
//                     DataColumn(
//                       label: Text(
//                         AppConstants.sno,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     _buildVehicleTableHeader(AppConstants.engineNumber),
//                     _buildVehicleTableHeader(AppConstants.frameNumber),
//                   ],
//                   rows: stockDetails.mainSpecValue

//                       .map((entry) {
//                     final index = entry.key;
//                     final value = entry.value;
//                     return DataRow(
//                       color: MaterialStateColor.resolveWith((states) {
//                         return index % 2 == 0
//                             ? Colors.white
//                             : AppColor().transparentBlueColor;
//                       }),
//                       cells: [
//                         _buildTableRow((index + 1).toString()),
//                         _buildTableRow(value.engineNumber ?? 'N/A'),
//                         _buildTableRow(value.frameNumber ?? 'N/A'),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
}
