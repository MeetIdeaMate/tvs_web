import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/models/get_model/get_all_transfer_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlbilling/view/transfer/new_transfer/new_transfer.dart';
import 'package:tlbilling/view/transfer/transfer_view_bloc.dart';
import 'package:tlds_flutter/components/tlds_date_picker.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:toastification/toastification.dart';

class TransferView extends StatefulWidget {
  const TransferView({super.key});

  @override
  State<TransferView> createState() => _TransferViewState();
}

class _TransferViewState extends State<TransferView>
    with SingleTickerProviderStateMixin {
  final _transferViewBloc = TransferViewBlocImpl();
  final _appColors = AppColors();

  @override
  void initState() {
    super.initState();
    _transferViewBloc.transferScreenTabController =
        TabController(length: 2, vsync: this);
    _getBranchId();
  }

  Future<void> _getBranchId() async {
    setState(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _transferViewBloc.sharePrefBranchId =
          prefs.getString(AppConstants.branchId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(21, 28, 21, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppWidgetUtils.buildHeaderText(AppConstants.transfer),
            AppWidgetUtils.buildSizedBox(custHeight: 26),
            _buildSearchFilter(),
            _buildDefaultHeight(),
            _buildTabBar(),
            _buildTabBarView(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            FutureBuilder(
              future: _transferViewBloc.getTransferStatus(),
              builder: (context, snapshot) {
                var transferStatusList = snapshot.data?.configuration;
                transferStatusList?.insert(0, AppConstants.allStatus);
                _transferViewBloc.transferStatus = transferStatusList?.first;
                return TldsDropDownButtonFormField(
                  height: 40,
                  width: 150,
                  hintText: AppConstants.select,
                  dropDownItems: transferStatusList ?? [],
                  dropDownValue: _transferViewBloc.transferStatus,
                  onChange: (String? newValue) {
                    _transferViewBloc.transferStatus = newValue ?? '';
                    _transferViewBloc.tableRefreshStream(true);
                  },
                );
              },
            ),
            _buildDefaultWidth(),
            _buildFromAndToBranchDropdown(),
            // _buildDefaultWidth(),
            // _buildFromDateAndToDate(),
          ],
        ),
        Row(
          children: [_buildNewTransfer()],
        )
      ],
    );
  }

  Widget _buildFromAndToBranchDropdown() {
    return FutureBuilder(
      future: _transferViewBloc.getBranchesList(),
      builder: (context, futureSnapshot) {
        List<String> branchNameList =
            futureSnapshot.data?.map((e) => e.branchName ?? '').toList() ?? [];
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: AppWidgetUtils.buildLoading(),
          );
        } else if (futureSnapshot.hasData) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder(
                stream: _transferViewBloc.fromBranchNameListStreamController,
                builder: (context, snapshot) {
                  for (var element in futureSnapshot.data ?? []) {
                    if (element.branchId == _transferViewBloc.branchId) {
                      _transferViewBloc.selectedFromBranch = element.branchName;
                      _transferViewBloc.fromBranchId = element.branchId;
                    }
                  }
                  _refreshToBranchList(branchNameList);
                  return TldsDropDownButtonFormField(
                    height: 40,
                    width: 150,
                    hintText: AppConstants.fromBranch,
                    dropDownItems: branchNameList,
                    dropDownValue: _transferViewBloc.selectedFromBranch,
                    onChange: (String? newValue) async {
                      _transferViewBloc.selectedFromBranch = newValue ?? '';
                      for (var element in futureSnapshot.data ?? []) {
                        if (element.branchName == newValue) {
                          _transferViewBloc.fromBranchId = element.branchId;
                        }
                      }
                      _transferViewBloc.toBranchList = [];
                      _transferViewBloc.toBranchNameListStream(false);
                      await Future.delayed(Duration.zero);
                      _refreshToBranchList(branchNameList);
                      _transferViewBloc.tableRefreshStream(true);
                    },
                  );
                },
              ),
              _buildDefaultWidth(),
              StreamBuilder(
                stream: _transferViewBloc.toBranchNameListStreamController,
                builder: (context, snapshot) {
                  return TldsDropDownButtonFormField(
                    height: 40,
                    width: 150,
                    hintText: AppConstants.toBranch,
                    dropDownItems: _transferViewBloc.toBranchList,
                    dropDownValue: _transferViewBloc.selectedToBranch,
                    onChange: (String? newValue) {
                      _transferViewBloc.selectedToBranch = newValue ?? '';
                      for (var element in futureSnapshot.data ?? []) {
                        if (element.branchName == newValue) {
                          _transferViewBloc.toBranchId = element.branchId;
                        }
                      }
                      _transferViewBloc.tableRefreshStream(true);
                    },
                  );
                },
              )
            ],
          );
        }
        return Center(
          child: SvgPicture.asset(AppConstants.imgNoData),
        );
      },
    );
  }

  Widget _buildFromDateAndToDate() {
    return Row(
      children: [
        TldsDatePicker(
          firstDate: DateTime(2000, 1, 1),
          height: 40,
          onChanged: (p0) {
            _transferViewBloc.tableRefreshStream(true);
          },
          suffixIcon: SvgPicture.asset(
            AppConstants.icDate,
            colorFilter: ColorFilter.mode(
              _appColors.primaryColor,
              BlendMode.srcIn,
            ),
          ),
          fontSize: 14,
          width: 150,
          hintText: AppConstants.fromDate,
          controller: _transferViewBloc.fromDateTextController,
        ),
        _buildDefaultWidth(),
        TldsDatePicker(
          firstDate: DateTime(2000, 1, 1),
          height: 40,
          onChanged: (p0) {
            _transferViewBloc.tableRefreshStream(true);
          },
          suffixIcon: SvgPicture.asset(
            AppConstants.icDate,
            colorFilter: ColorFilter.mode(
              _appColors.primaryColor,
              BlendMode.srcIn,
            ),
          ),
          fontSize: 14,
          width: 150,
          hintText: AppConstants.toDate,
          controller: _transferViewBloc.toDateTextController,
        ),
      ],
    );
  }

  void _refreshToBranchList(List<String> branchNameList) {
    _transferViewBloc.toBranchList = branchNameList
        .where((element) => element != _transferViewBloc.selectedFromBranch)
        .toList();
    _transferViewBloc.selectedToBranch = null;
    _transferViewBloc.toBranchNameListStream(true);
  }

  Widget _buildNewTransfer() {
    return CustomElevatedButton(
      height: 40,
      width: 189,
      text: AppConstants.newTransfer,
      fontSize: 16,
      buttonBackgroundColor: _appColors.primaryColor,
      fontColor: _appColors.whiteColor,
      suffixIcon: SvgPicture.asset(AppConstants.icAdd),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewTransfer(),
            )).then((value) {
          _transferViewBloc.tabBarStream(true);
          _transferViewBloc.tableRefreshStream(true);
        });
      },
    );
  }

  Widget _buildTabBar() {
    return StreamBuilder(
      stream: _transferViewBloc.tabBarStreamController,
      builder: (context, snapshot) {
        return SizedBox(
          width: 300,
          child: TabBar(
            controller: _transferViewBloc.transferScreenTabController,
            tabs: [
              Tab(
                  //text: AppConstants.vehicle,
                  child: _buildTabBarRow('Transferred',
                      _transferViewBloc.transferListCount ?? '')),
              Tab(
                  //text: AppConstants.accessories,
                  child: _buildTabBarRow(
                      'Received', _transferViewBloc.receivedListCount ?? '')),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabBarRow(String title, String count) {
    return Row(
      children: [
        Text(title),
        AppWidgetUtils.buildSizedBox(custWidth: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: _appColors.red,
          ),
          width: 24,
          height: 24,
          child: Center(
            child: Text(
              count,
              style: GoogleFonts.nunitoSans(color: _appColors.whiteColor),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTabBarView() {
    _transferViewBloc.tableRefreshStream(true);
    return Expanded(
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _transferViewBloc.transferScreenTabController,
        children: [
          _buildTransferTableView(context),
          _buildTransferTableView(context),
        ],
      ),
    );
  }

  _buildTransferTableView(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: StreamBuilder(
              stream: _transferViewBloc.tableRefreshStreamController,
              builder: (context, snapshot) {
                return FutureBuilder(
                  future: _transferViewBloc.getTransferList(
                      _transferViewBloc.transferScreenTabController.index == 0
                          ? AppConstants.transferred
                          : AppConstants.received),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: AppWidgetUtils.buildLoading(),
                      );
                    } else if (snapshot.hasData) {
                      if (snapshot.data?.isEmpty == true) {
                        return Center(
                          child: SvgPicture.asset(AppConstants.imgNoData),
                        );
                      } else {
                        return DataTable(
                            key: UniqueKey(),
                            dividerThickness: 0.01,
                            columns: _tableHeaders(),
                            rows: _tableRows(snapshot));
                      }
                    }
                    return Center(
                      child: SvgPicture.asset(AppConstants.imgNoData),
                    );
                  },
                );
              },
            )),
      ),
    );
  }

  List<DataColumn> _tableHeaders() {
    return [
      _buildTransferTableHeader(
        AppConstants.sno,
      ),
      _buildTransferTableHeader(AppConstants.transferId),
      _buildTransferTableHeader(AppConstants.transferDate),
      _buildTransferTableHeader(AppConstants.fromBranch),
      _buildTransferTableHeader(AppConstants.toBranch),
      _buildTransferTableHeader(AppConstants.totalQty),
      _buildTransferTableHeader(AppConstants.status),
      _buildTransferTableHeader(AppConstants.action),
    ];
  }

  List<DataRow> _tableRows(AsyncSnapshot<List<GetAllTransferModel>?> snapshot) {
    return snapshot.data
            ?.asMap()
            .entries
            .map(
              (entry) => DataRow(
                color: MaterialStateColor.resolveWith((states) {
                  _transferViewBloc.transferListCount =
                      snapshot.data?.length.toString();
                  _transferViewBloc.receivedListCount =
                      snapshot.data?.length.toString();
                  _transferViewBloc.tabBarStream(true);
                  if (entry.key % 2 == 0) {
                    return Colors.white;
                  } else {
                    return _appColors.transparentBlueColor;
                  }
                }),
                cells: [
                  DataCell(Text('${entry.key + 1}')),
                  DataCell(Text(entry.value.transferId ?? '')),
                  DataCell(Text(AppUtils.apiToAppDateFormat(
                      entry.value.transferDate.toString()))),
                  DataCell(Text(entry.value.fromBranchName ?? '')),
                  DataCell(Text(entry.value.toBranchName ?? '')),
                  DataCell(Text(entry.value.totalQuantity.toString())),
                  DataCell(
                    Chip(
                      label: _buildTransferStatus(entry.value),
                      side: BorderSide(
                          color: entry.value.transferStatus == 'COMPLETED' ||
                                  entry.value.transferStatus == 'APPROVED'
                              ? _appColors.successColor
                              : _appColors.yellowColor),
                      surfaceTintColor: _appColors.whiteColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                  DataCell(
                    Row(
                      children: [
                        PopupMenuButton(
                          itemBuilder: (context) {
                            return <PopupMenuEntry>[
                              const PopupMenuItem(
                                  value: 'option0', child: Text('View')),
                              const PopupMenuItem(
                                  value: 'option1',
                                  child: Text(AppConstants.cancel)),
                              const PopupMenuItem(
                                  value: 'option2', child: Text('Approved')),
                            ];
                          },
                          onSelected: (value) {
                            switch (value) {
                              case 'option0':
                                showDialog(
                                    context: context,
                                    builder: (context) => _buildVehicleDetails(
                                          entry.value.transferItems,
                                        ));
                                break;
                              case 'option2':
                                showDialog(
                                  context: context,
                                  builder: (context) => _buildApproveDialog(
                                    entry.value.transferId.toString(),
                                  ),
                                ).then((value) =>
                                    _transferViewBloc.tableRefreshStream(true));
                                break;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
            .toList() ??
        [];
  }

  Widget _buildApproveDialog(String transferId) {
    return AlertDialog(
      surfaceTintColor: _appColors.whiteColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(AppConstants.imgShied),
          AppWidgetUtils.buildCustomDmSansTextWidget(
              AppConstants.youWantToUpdateTheStatus,
              color: _appColors.greyColor,
              fontSize: 14),
          AppWidgetUtils.buildSizedBox(custHeight: 8),
          CustomActionButtons(
              onPressed: () {
                _transferViewBloc.stockTransferApproval(
                  transferId,
                  (statusCode) {
                    if (statusCode == 200 || statusCode == 201) {
                      Navigator.pop(context);
                      AppWidgetUtils.buildToast(
                          context,
                          ToastificationType.success,
                          AppConstants.stockTransferUpdate,
                          Icon(Icons.check_circle_outline_rounded,
                              color: _appColors.successColor),
                          AppConstants.stockTransferUpdateSuccessfully,
                          _appColors.successLightColor);
                    } else {
                      AppWidgetUtils.buildToast(
                          context,
                          ToastificationType.error,
                          AppConstants.stockTransferUpdate,
                          Icon(Icons.warning_amber,
                              color: _appColors.errorColor),
                          AppConstants.somethingWentWrong,
                          _appColors.errorLightColor);
                    }
                  },
                );
              },
              buttonText: AppConstants.save)
        ],
      ),
    );
  }

  Widget _buildVehicleDetails(List<TransferItem>? transferItems) {
    return AlertDialog(
      surfaceTintColor: _appColors.whiteColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppConstants.vehicleDetails,
            style: TextStyle(color: _appColors.primaryColor),
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
        width: 530,
        height: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: transferItems!.map((transferStockDet) {
              return ExpansionTile(
                title: Text(transferStockDet.itemName ?? 'N/A'),
                subtitle: Text(transferStockDet.partNo ?? 'N/A'),
                expandedAlignment: Alignment.topLeft,
                dense: true,
                children: [
                  DataTable(
                      columns: _tableHeadersForVehicleDetails(),
                      rows: _tableRowsForVehicleDetails(transferItems)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _tableHeadersForVehicleDetails() {
    return [
      _buildTransferTableHeader(
        AppConstants.sno,
      ),
      _buildTransferTableHeader(AppConstants.frameNumber),
      _buildTransferTableHeader(AppConstants.engineNumber),
    ];
  }

  List<DataRow> _tableRowsForVehicleDetails(List<TransferItem>? transferItems) {
    return transferItems
            ?.asMap()
            .entries
            .map(
              (entry) => DataRow(
                color: MaterialStateColor.resolveWith((states) {
                  if (entry.key % 2 == 0) {
                    return Colors.white;
                  } else {
                    return _appColors.transparentBlueColor;
                  }
                }),
                cells: [
                  DataCell(Text('${entry.key + 1}')),
                  DataCell(Text(entry.value.mainSpecValue?.frameNo ?? '')),
                  DataCell(Text(entry.value.mainSpecValue?.engineNo ?? '')),
                ],
              ),
            )
            .toList() ??
        [];
  }

  Widget _buildTransferStatus(GetAllTransferModel data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          data.transferStatus ?? '',
          style: TextStyle(
              color: data.transferStatus == 'COMPLETED' ||
                      data.transferStatus == 'APPROVED'
                  ? _appColors.successColor
                  : _appColors.yellowColor),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 4),
        data.transferStatus == 'COMPLETED' || data.transferStatus == 'APPROVED'
            ? Icon(
                Icons.check,
                color: _appColors.successColor,
              )
            : Icon(
                Icons.info_outline,
                color: _appColors.yellowColor,
              ),
      ],
    );
  }

  _buildTransferTableHeader(String headerValue) => DataColumn(
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

  Widget _buildFormField(TextEditingController textController, String hintText,
      List<TextInputFormatter>? inputFormatters) {
    final bool isTextEmpty = textController.text.isEmpty;
    final IconData iconData = isTextEmpty ? Icons.search : Icons.close;
    final Color iconColor = isTextEmpty ? _appColors.primaryColor : Colors.red;
    return TldsInputFormField(
      width: 203,
      height: 40,
      controller: textController,
      hintText: hintText,
      isSearch: true,
      inputFormatters: inputFormatters,
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

  void _checkController(String transporterName) {
    if (AppConstants.transporterName == transporterName) {
      _transferViewBloc.transporterNameStreamController(true);
    } else {
      _transferViewBloc.vehicleNameSearchStreamController(true);
    }
  }
}
