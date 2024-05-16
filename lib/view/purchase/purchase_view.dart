import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_purchase.dart';
import 'package:tlbilling/view/purchase/purchase_view_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:tlds_flutter/util/app_colors.dart';

class PurchaseView extends StatefulWidget {
  const PurchaseView({super.key});

  @override
  State<PurchaseView> createState() => _PurchaseViewState();
}

class _PurchaseViewState extends State<PurchaseView>
    with SingleTickerProviderStateMixin {
  final _appColors = AppColor();
  final _purchaseViewBloc = PurchaseViewBlocImpl();
  List<Map<String, String>> rowData = [
    {
      AppConstants.sno: '1',
      AppConstants.invoiceNo: 'INV-1234',
      AppConstants.partNo: 'K61916304K',
      AppConstants.vehicleDescription: 'TVS JUPITER-OBDIIA WALN',
      AppConstants.hsnCode: '87112019',
      AppConstants.quantity: '2',
      AppConstants.totalInvAmount: '₹ 1,000,00',
    },
    {
      AppConstants.sno: '2',
      AppConstants.invoiceNo: 'INV-1235',
      AppConstants.partNo: 'K61916304K',
      AppConstants.vehicleDescription: 'TVS JUPITER-OBDIIA WALN',
      AppConstants.hsnCode: '87112019',
      AppConstants.quantity: '1',
      AppConstants.totalInvAmount: '₹ 1,000,00',
    },
  ];

  @override
  void initState() {
    super.initState();
    _purchaseViewBloc.vehicleAndAccessoriesTabController =
        TabController(length: 2, vsync: this);
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
            AppWidgetUtils.buildHeaderText(AppConstants.purchase),
            _buildSearchFilters(),
            AppWidgetUtils.buildSizedBox(
                custHeight: MediaQuery
                    .sizeOf(context)
                    .height * 0.02),
            _buildTabBar(),
            _buildTabBarView(),
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
            StreamBuilder(
              stream: _purchaseViewBloc.invoiceSearchFieldControllerStream,
              builder: (context, snapshot) {
                return _buildFormField(
                    _purchaseViewBloc.invoiceSearchFieldController,
                    AppConstants.invoiceNo);
              },
            ),
            AppWidgetUtils.buildSizedBox(
              custWidth: MediaQuery
                  .sizeOf(context)
                  .width * 0.01,
            ),
            StreamBuilder(
              stream: _purchaseViewBloc.partNoSearchFieldControllerStream,
              builder: (context, snapshot) {
                return _buildFormField(
                    _purchaseViewBloc.partNoSearchFieldController,
                    AppConstants.partNo);
              },
            ),
            AppWidgetUtils.buildSizedBox(
              custWidth: MediaQuery
                  .sizeOf(context)
                  .width * 0.01,
            ),
            StreamBuilder(
              stream: _purchaseViewBloc.vehicleSearchFieldControllerStream,
              builder: (context, snapshot) {
                return _buildFormField(
                    _purchaseViewBloc.vehicleSearchFieldController,
                    AppConstants.vehicleNumber);
              },
            ),
            AppWidgetUtils.buildSizedBox(
              custWidth: MediaQuery
                  .sizeOf(context)
                  .width * 0.01,
            ),
            StreamBuilder(
              stream: _purchaseViewBloc.hsnCodeSearchFieldControllerStream,
              builder: (context, snapshot) {
                return _buildFormField(
                    _purchaseViewBloc.hsnCodeSearchFieldController,
                    AppConstants.hsnCode);
              },
            ),
          ],
        ),
        Row(
          children: [
            CustomElevatedButton(
              height: 40,
              width: 189,
              text: AppConstants.addPurchase,
              fontSize: 16,
              buttonBackgroundColor: _appColors.primaryColor,
              fontColor: _appColors.whiteColor,
              suffixIcon: SvgPicture.asset(AppConstants.icAdd),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddPurchase(),
                    ));
              },
            )
          ],
        )
      ],
    );
  }

  Widget _buildFormField(TextEditingController textController,
      String hintText) {
    final bool isTextEmpty =
        textController.text.isEmpty;
    final IconData iconData = isTextEmpty ? Icons.search : Icons.close;
    final Color iconColor =
    isTextEmpty ? _appColors.primaryColor : Colors.red;
    return TldsInputFormField(
      width: 203,
      height: 40,
      controller: textController,
      hintText: hintText,
      suffixIcon: IconButton(
        onPressed: iconData == Icons.search ? () {
          //add search cont here
          _checkController(hintText);
        } : () {
          textController.clear();
          _checkController(hintText);
        },
        icon: Icon(
          iconData,
          color: iconColor,
        ),
      ),
      onSubmit: (p0) {
        //add search cont here
        _checkController(hintText);
      },
    );
  }

  void _checkController(String hintText) {
    if (AppConstants.invoiceNo == hintText) {
      _purchaseViewBloc.invoiceSearchFieldStreamController(true);
    } else if (AppConstants.vehicleNumber == hintText) {
      _purchaseViewBloc.vehicleSearchFieldStreamController(true);
    }else if(AppConstants.partNo == hintText){
      _purchaseViewBloc.partNoSearchFieldStreamController(true);
    }else if(AppConstants.hsnCode == hintText){
      _purchaseViewBloc.hsnCodeSearchFieldStreamController(true);
    }
  }

  Widget _buildTabBar() {
    return SizedBox(
      width: 250,
      child: TabBar(
        controller: _purchaseViewBloc.vehicleAndAccessoriesTabController,
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
        controller: _purchaseViewBloc.vehicleAndAccessoriesTabController,
        children: [
          _buildCustomerTableView(context),
          _buildCustomerTableView(context),
        ],
      ),
    );
  }

  _buildCustomerTableView(BuildContext context) {
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: DataTable(
        key: UniqueKey(),
        dividerThickness: 0.01,
        columns: [
          _buildVehicleTableHeader(
            AppConstants.sno,
          ),
          _buildVehicleTableHeader(AppConstants.invoiceNo),
          _buildVehicleTableHeader(AppConstants.partNo),
          _buildVehicleTableHeader(AppConstants.vehicleDescription),
          _buildVehicleTableHeader(AppConstants.hsnCode),
          _buildVehicleTableHeader(AppConstants.quantity),
          _buildVehicleTableHeader(AppConstants.totalInvAmount),
          _buildVehicleTableHeader(AppConstants.action),
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
              DataCell(Text(data[AppConstants.invoiceNo]!)),
              DataCell(Text(data[AppConstants.partNo]!)),
              DataCell(Text(data[AppConstants.vehicleDescription]!)),
              DataCell(Text(data[AppConstants.hsnCode]!)),
              DataCell(Text(data[AppConstants.quantity]!)),
              DataCell(Text(data[AppConstants.totalInvAmount]!)),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(AppConstants.icEdit),
                      onPressed: () {},
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

  _buildVehicleTableHeader(String headerValue) =>
      DataColumn(
        label: Text(
          headerValue,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      );
}
