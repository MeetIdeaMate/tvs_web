import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/models/get_model/get_all_branches_by_pagination.dart';
import 'package:tlbilling/models/get_model/get_all_transfer_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlbilling/view/transfer/new_transfer/new_transfer.dart';
import 'package:tlbilling/view/transfer/transfer_view_bloc.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';
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
    getBranchId();
    _transferViewBloc.getBranchesList().then((value) {
      for (BranchDetail element in value ?? []) {
        if (_transferViewBloc.branchId == element.branchId) {
          setState(() {
            _transferViewBloc.selectedFromBranch = element.branchName;
          });
        }
      }
    });
  }

  Future<void> getBranchId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _transferViewBloc.branchId = prefs.getString('branchId') ?? '';
      _transferViewBloc.isMainbranch = prefs.getBool('mainBranch');
    });
    _transferViewBloc.getBranchesList().then((value) {
      for (BranchDetail element in value ?? []) {
        if (_transferViewBloc.branchId == element.branchId) {
          setState(() {
            _transferViewBloc.selectedFromBranch = element.branchName;
            _transferViewBloc.fromBranchId = element.branchId;
          });
        }
      }
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
          ],
        ),
        _buildNewTransfer()
      ],
    );
  }

  Widget _buildFromAndToBranchDropdown() {
    return Column(
      children: [
        FutureBuilder(
          future: _transferViewBloc.getBranchesList(),
          builder: (context, futureSnapshot) {
            List<String> branchNameList = [AppConstants.allBranch];
            branchNameList.addAll(
                futureSnapshot.data?.map((e) => e.branchName ?? '').toList() ??
                    []);
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: AppWidgetUtils.buildLoading(),
              );
            } else if (!futureSnapshot.hasData ||
                futureSnapshot.data?.isEmpty == true) {
              return Center(child: SvgPicture.asset(AppConstants.imgNoData));
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder(
                    stream:
                        _transferViewBloc.fromBranchNameListStreamController,
                    builder: (context, snapshot) {
                      for (BranchDetail element in futureSnapshot.data ?? []) {
                        if (element.branchId == _transferViewBloc.branchId) {
                          _transferViewBloc.selectedFromBranch =
                              element.branchName;
                          _transferViewBloc.fromBranchId = element.branchId;
                        }
                      }
                      _refreshToBranchList(branchNameList);
                      return IgnorePointer(
                        ignoring: _transferViewBloc.isMainbranch == false
                            ? true
                            : false,
                        child: TldsDropDownButtonFormField(
                          height: 40,
                          width: 150,
                          hintText: AppConstants.fromBranch,
                          dropDownItems: branchNameList,
                          dropDownValue: _transferViewBloc.selectedFromBranch,
                          onChange: (String? newValue) async {
                            _transferViewBloc.selectedFromBranch =
                                newValue ?? '';
                            if (newValue == AppConstants.allBranch) {
                              _transferViewBloc.fromBranchId = null;
                            } else {
                              for (var element in futureSnapshot.data ?? []) {
                                if (element.branchName == newValue) {
                                  _transferViewBloc.fromBranchId =
                                      element.branchId;
                                }
                              }
                            }
                            _transferViewBloc.toBranchList = [];
                            _transferViewBloc.toBranchNameListStream(false);
                            await Future.delayed(Duration.zero);
                            _refreshToBranchList(branchNameList);
                            _transferViewBloc.tableRefreshStream(true);
                          },
                        ),
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
                          if (newValue == AppConstants.allBranch) {
                            _transferViewBloc.toBranchId = null;
                          } else {
                            for (var element in futureSnapshot.data ?? []) {
                              if (element.branchName == newValue) {
                                _transferViewBloc.toBranchId = element.branchId;
                              }
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
          },
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
              builder: (context) => NewTransfer(
                transferViewBloc: _transferViewBloc,
              ),
            ));
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
                  child: Badge(
                isLabelVisible:
                    (_transferViewBloc.transferedBadgeCount ?? 0) > 0,
                label: Text(_transferViewBloc.transferedBadgeCount.toString()),
                child: const Text(AppConstants.transferredSm),
              )),
              Tab(
                  child: Badge(
                isLabelVisible: (_transferViewBloc.receivedBadgeCount ?? 0) > 0,
                label: Text(_transferViewBloc.receivedBadgeCount.toString()),
                child: const Text(
                  AppConstants.receivedSm,
                ),
              )),
            ],
          ),
        );
      },
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
    return StreamBuilder(
      stream: _transferViewBloc.tableRefreshStreamController,
      builder: (context, snapshot) {
        return FutureBuilder(
          future: _transferViewBloc.getTransferList(() {
            switch (_transferViewBloc.transferScreenTabController.index) {
              case 0:
                return AppConstants.transferred;
              case 1:
                return AppConstants.received;
              default:
                return '';
            }
          }()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return AppWidgetUtils.buildLoading();
            }
            if (!snapshot.hasData || snapshot.data?.isEmpty == true) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: SvgPicture.asset(AppConstants.imgNoData)),
                  AppWidgetUtils.buildSizedBox(custHeight: 8),
                  Center(
                    child: Text(
                      AppConstants.noTransferDataAvailable,
                      style: TextStyle(color: _appColors.grey),
                    ),
                  ),
                ],
              );
            } else {
              var transferList = snapshot.data;
              _transferViewBloc.transferedBadgeCount =
                  transferList?.where((transfer) {
                return transfer.transferStatus == AppConstants.initiated;
              }).length;
              _transferViewBloc.receivedBadgeCount =
                  transferList?.where((transfer) {
                return transfer.transferStatus == AppConstants.noTApproved;
              }).length;
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
                            columns: _tableHeaders(),
                            rows: _tableRows(snapshot),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        );
      },
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
                          color: entry.value.transferStatus ==
                                      AppConstants.completed.toUpperCase() ||
                                  entry.value.transferStatus ==
                                      AppConstants.approved.toUpperCase()
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
                          surfaceTintColor: _appColors.whiteColor,
                          itemBuilder: (context) {
                            return <PopupMenuEntry>[
                              const PopupMenuItem(
                                  value: 'option0',
                                  child: Text(AppConstants.view)),
                              if (_transferViewBloc
                                      .transferScreenTabController.index !=
                                  0)
                                const PopupMenuItem(
                                    value: 'option1',
                                    child: Text(AppConstants.approveItem)),
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

                              case 'option1':
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      surfaceTintColor: _appColors.whiteColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(AppConstants.imgShied),
          AppWidgetUtils.buildSizedBox(custHeight: 8),
          AppWidgetUtils.buildCustomDmSansTextWidget(
              AppConstants.youWantToUpdateTheStatus,
              color: _appColors.greyColor,
              fontSize: 20),
          AppWidgetUtils.buildSizedBox(custHeight: 16),
          CustomActionButtons(
              onPressed: () {
                _transferViewBloc.stockTransferApproval(
                  transferId,
                  (statusCode) {
                    if (statusCode == 200 || statusCode == 201) {
                      Navigator.pop(context);
                      _transferViewBloc.tableRefreshStream(true);
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
            children: transferItems?.map((transferStockDet) {
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
                }).toList() ??
                [],
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
              color: data.transferStatus ==
                          AppConstants.completed.toUpperCase() ||
                      data.transferStatus == AppConstants.approved.toUpperCase()
                  ? _appColors.successColor
                  : _appColors.yellowColor),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 4),
        data.transferStatus == AppConstants.completed.toUpperCase() ||
                data.transferStatus == AppConstants.approved.toUpperCase()
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
}
