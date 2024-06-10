import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/stocks/detail_stock_view.dart';
import 'package:tlbilling/view/stocks/stocks_view_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';

class StocksView extends StatefulWidget {
  const StocksView({super.key});

  @override
  State<StocksView> createState() => _StocksViewState();
}

class _StocksViewState extends State<StocksView>
    with SingleTickerProviderStateMixin {
  final _appColors = AppColors();
  final _stocksViewBloc = StocksViewBlocImpl();
  List<Map<String, String>> rowData = [
    {
      AppConstants.sno: '2',
      AppConstants.partNo: 'K61916304K',
      AppConstants.vehicleName: 'TVS JUPITER-OBDIIA WALN',
      AppConstants.hsnCode: '87112019',
      AppConstants.quantity: '1',
      AppConstants.totalInvAmount: '₹ 1,000,00',
    },
  ];

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
    ));
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
                },
                icon: Icon(
                  iconData,
                  color: iconColor,
                ),
              ),
              onSubmit: (p0) {
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
                },
                icon: Icon(
                  iconData,
                  color: iconColor,
                ),
              ),
              onSubmit: (p0) {
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
        _buildStockTableView(context),
        _buildStockTableView(context),
      ],
    ));
  }

  _buildStockTableView(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: DataTable(
        key: UniqueKey(),
        dividerThickness: 0.01,
        columns: [
          _buildStockTableHeader(
            AppConstants.sno,
          ),
          _buildStockTableHeader(AppConstants.partNo),
          _buildStockTableHeader(AppConstants.vehicleName),
          _buildStockTableHeader(AppConstants.hsnCode),
          _buildStockTableHeader(AppConstants.quantity),
          _buildStockTableHeader(AppConstants.action),
        ],
        rows: List.generate(rowData.length, (index) {
          final data = rowData[index];

          final color = index.isEven
              ? _appColors.whiteColor
              : _appColors.transparentBlueColor;
          return DataRow(
            color: MaterialStateColor.resolveWith((states) => color),
            cells: [
              DataCell(Text(data[AppConstants.sno]!)),
              DataCell(Text(data[AppConstants.partNo]!)),
              DataCell(Text(data[AppConstants.vehicleName]!)),
              DataCell(Text(data[AppConstants.hsnCode]!)),
              DataCell(Text(data[AppConstants.quantity]!)),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(AppConstants.icMore),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DetailStockView(),
                            ));
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  _buildStockTableHeader(String headerValue) => DataColumn(
        label: Text(
          headerValue,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      );

  Widget _buildDefaultWidth() {
    return AppWidgetUtils.buildSizedBox(
        custWidth: MediaQuery.sizeOf(context).width * 0.01);
  }

  Widget _buildDefaultHeight() {
    return AppWidgetUtils.buildSizedBox(
        custHeight: MediaQuery.sizeOf(context).height * 0.02);
  }
}
