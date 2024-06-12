import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/components/custom_pagenation.dart';
import 'package:tlbilling/models/get_model/get_all_purchase_model.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_purchase.dart';
import 'package:tlbilling/view/purchase/purchase_view_bloc.dart';
import 'package:tlbilling/view/purchase/vehicle_details_dialog.dart';
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
            AppWidgetUtils.buildSizedBox(custHeight: 26),
            _buildSearchFilters(),
            AppWidgetUtils.buildSizedBox(
                custHeight: MediaQuery.sizeOf(context).height * 0.02),
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
                  AppConstants.invoiceNo,
                  TlInputFormatters.onlyAllowAlphabetAndNumber,
                );
              },
            ),
            AppWidgetUtils.buildSizedBox(
              custWidth: MediaQuery.sizeOf(context).width * 0.01,
            ),
            StreamBuilder(
              stream: _purchaseViewBloc.partNoSearchFieldControllerStream,
              builder: (context, snapshot) {
                return _buildFormField(
                  _purchaseViewBloc.partNoSearchFieldController,
                  AppConstants.partNo,
                  TlInputFormatters.onlyAllowNumbers,
                );
              },
            ),
            AppWidgetUtils.buildSizedBox(
              custWidth: MediaQuery.sizeOf(context).width * 0.01,
            ),
            StreamBuilder(
              stream: _purchaseViewBloc.vehicleSearchFieldControllerStream,
              builder: (context, snapshot) {
                return _buildFormField(
                  _purchaseViewBloc.vehicleSearchFieldController,
                  AppConstants.vehicleNumber,
                  TlInputFormatters.onlyAllowAlphabetAndNumber,
                );
              },
            ),
            AppWidgetUtils.buildSizedBox(
              custWidth: MediaQuery.sizeOf(context).width * 0.01,
            ),
            StreamBuilder(
              stream: _purchaseViewBloc.purchaseRefSearchFieldControllerStream,
              builder: (context, snapshot) {
                return _buildFormField(
                  _purchaseViewBloc.purchaseRefSearchFieldController,
                  AppConstants.hsnCode,
                  TlInputFormatters.onlyAllowNumbers,
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
                    )).then((value) {
                  _purchaseViewBloc.getAllPurchaseList();
                  _purchaseViewBloc.pageNumberUpdateStreamController(0);
                });
              },
            )
          ],
        )
      ],
    );
  }

  Widget _buildFormField(TextEditingController textController, String hintText,
      List<TextInputFormatter>? inputFormatters) {
    final bool isTextEmpty = textController.text.isEmpty;
    final IconData iconData = isTextEmpty ? Icons.search : Icons.close;
    final Color iconColor = isTextEmpty ? _appColors.primaryColor : Colors.red;
    return TldsInputFormField(
      inputFormatters: inputFormatters,
      width: 203,
      height: 40,
      controller: textController,
      hintText: hintText,
      isSearch: true,
      suffixIcon: IconButton(
        onPressed: iconData == Icons.search
            ? () {
                //add search cont here
                _checkController(hintText);
              }
            : () {
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
      _purchaseViewBloc.getAllPurchaseList();
      _purchaseViewBloc.pageNumberUpdateStreamController(0);
      _purchaseViewBloc.invoiceSearchFieldStreamController(true);
    } else if (AppConstants.vehicleNumber == hintText) {
      _purchaseViewBloc.getAllPurchaseList();
      _purchaseViewBloc.pageNumberUpdateStreamController(0);
      _purchaseViewBloc.vehicleSearchFieldStreamController(true);
    } else if (AppConstants.partNo == hintText) {
      _purchaseViewBloc.getAllPurchaseList();
      _purchaseViewBloc.pageNumberUpdateStreamController(0);
      _purchaseViewBloc.partNoSearchFieldStreamController(true);
    } else if (AppConstants.hsnCode == hintText) {
      _purchaseViewBloc.getAllPurchaseList();
      _purchaseViewBloc.pageNumberUpdateStreamController(0);
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
          _buildPurchseBillTableView(context),
          _buildPurchseBillTableView(context),
        ],
      ),
    );
  }

  _buildPurchseBillTableView(BuildContext context) {
    return StreamBuilder<int>(
      stream: _purchaseViewBloc.pageNumberStream,
      initialData: _purchaseViewBloc.currentPage,
      builder: (context, streamSnapshot) {
        int currentPage = streamSnapshot.data ?? 0;
        if (currentPage < 0) currentPage = 0;
        _purchaseViewBloc.currentPage = currentPage;
        return FutureBuilder(
          future: _purchaseViewBloc.getAllPurchaseList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: AppWidgetUtils.buildLoading());
            } else if (snapshot.hasData) {
              GetAllPurchaseByPageNation employeeListmodel = snapshot.data!;
              List<PurchaseBill> purchasedata = snapshot.data?.content ?? [];
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          dividerThickness: 0.01,
                          columns: [
                            _buildVehicleTableHeader(AppConstants.sno),
                            _buildVehicleTableHeader(AppConstants.purchaseID),
                            _buildVehicleTableHeader(AppConstants.purchaseRef),
                            _buildVehicleTableHeader(AppConstants.invoiceNo),
                            _buildVehicleTableHeader(AppConstants.invoiceDate),
                            _buildVehicleTableHeader(AppConstants.vendorName),
                            _buildVehicleTableHeader(AppConstants.quantity),
                            _buildVehicleTableHeader(AppConstants.branchName),
                            _buildVehicleTableHeader(
                                AppConstants.totalInvAmount),
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
                                _buildTableRow(entry.value.pOrderRefNo),
                                _buildTableRow(entry.value.purchaseNo),
                                _buildTableRow(entry.value.pInvoiceNo),
                                _buildTableRow(AppUtils.apiToAppDateFormat(
                                    entry.value.pInvoiceDate.toString())),
                                _buildTableRow(entry.value.vendorName),
                                _buildTableRow(entry.value.totalQty.toString()),
                                _buildTableRow(
                                    entry.value.branchName.toString()),
                                _buildTableRow(AppUtils.formatCurrency(entry
                                        .value.finalTotalInvoiceAmount
                                        ?.toDouble() ??
                                    0.0)),
                                DataCell(
                                  _buildPopMenuItem(context, entry),
                                )
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
                    onPageChanged: (pageValue) {
                      _purchaseViewBloc
                          .pageNumberUpdateStreamController(pageValue);
                    },
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

  Widget _buildPopMenuItem(
      BuildContext context, MapEntry<int, PurchaseBill> entry) {
    return Row(
      children: [
        PopupMenuButton(
          surfaceTintColor: _appColors.whiteColor,
          icon: const Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            const PopupMenuItem(
              value: 'option1',
              child: Text('View'),
            ),
            const PopupMenuItem(
              value: 'option2',
              child: Text('Re-Entry'),
            ),
            const PopupMenuItem(
              value: 'option3',
              child: Text('Print'),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'option1':
                showDialog(
                  context: context,
                  builder: (context) {
                    return VehicleDetailsDialog(
                        purchaseBills: entry.value.itemDetails);
                  },
                );
                break;
              case 'option2':
                break;
            }
          },
        ),
      ],
    );
  }

  DataCell _buildTableRow(String? text) => DataCell(Text(
        text ?? '',
        style: const TextStyle(fontSize: 14),
      ));

  _buildVehicleTableHeader(String headerValue) {
    return DataColumn(
      label: Text(
        headerValue,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
