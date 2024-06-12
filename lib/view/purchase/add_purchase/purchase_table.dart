import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/models/post_model/add_purchase_model.dart';
import 'package:tlbilling/models/purchase_bill_data.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_vehicle_and_accesories/add_vehicle_and_accessories_bloc.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_vehicle_and_accesories/purchase_table_preview.dart';
import 'package:tlds_flutter/export.dart';
import 'package:toastification/toastification.dart';

class PurchaseTable extends StatefulWidget {
  final AddVehicleAndAccessoriesBlocImpl purchaseBloc;

  const PurchaseTable({super.key, required this.purchaseBloc});

  @override
  State<PurchaseTable> createState() => _PurchaseTableState();
}

class _PurchaseTableState extends State<PurchaseTable> {
  final _appColors = AppColor();

  @override
  void initState() {
    super.initState();
    getbranchId();
  }

  Future<void> getbranchId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    widget.purchaseBloc.branchId = prefs.getString(AppConstants.branchId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.64,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: _appColors.greyColor),
          top: BorderSide(color: _appColors.greyColor),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildAddedVehicleAndAccessoriesTable(),
            _buildPreviewAndActionButton()
          ],
        ),
      ),
    );
  }

  Widget _buildAddedVehicleAndAccessoriesTable() {
    return StreamBuilder<bool>(
      stream: widget.purchaseBloc.refreshPurchaseDataTable,
      builder: (context, snapshot) {
        if (widget.purchaseBloc.purchaseBillDataList.isEmpty) {
          return Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: SvgPicture.asset(AppConstants.imgNoData)),
              Text('Add Purchase Value to the table to view',
                  style: TextStyle(
                    color: AppColors().greyColor,
                  ))
            ],
          ));
        }
        final totals =
            _calculateTotals(widget.purchaseBloc.purchaseBillDataList);
        return Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                key: UniqueKey(),
                dividerThickness: 0.01,
                columns: [
                  _buildVehicleTableHeader(AppConstants.sno),
                  _buildVehicleTableHeader(AppConstants.partNo),
                  _buildVehicleTableHeader(AppConstants.vehicleName),
                  _buildVehicleTableHeader(AppConstants.hsnCode),
                  _buildVehicleTableHeader(AppConstants.quantity),
                  _buildVehicleTableHeader(AppConstants.unitRate),
                  _buildVehicleTableHeader(AppConstants.totalValue),
                  _buildVehicleTableHeader(AppConstants.discountAmount),
                  _buildVehicleTableHeader(AppConstants.taxableValue),
                  if (widget.purchaseBloc.selectedGstType !=
                      AppConstants.igstAmount)
                    _buildVehicleTableHeader(AppConstants.cgstPercent),
                  if (widget.purchaseBloc.selectedGstType !=
                      AppConstants.igstAmount)
                    _buildVehicleTableHeader(AppConstants.cgstAmount),
                  if (widget.purchaseBloc.selectedGstType !=
                      AppConstants.igstAmount)
                    _buildVehicleTableHeader(AppConstants.sgstPercent),
                  if (widget.purchaseBloc.selectedGstType !=
                      AppConstants.igstAmount)
                    _buildVehicleTableHeader(AppConstants.sgstAmount),
                  if (widget.purchaseBloc.selectedGstType !=
                      AppConstants.gstPercent)
                    _buildVehicleTableHeader(AppConstants.igstPercent),
                  if (widget.purchaseBloc.selectedGstType !=
                      AppConstants.gstPercent)
                    _buildVehicleTableHeader(AppConstants.igstAmount),
                  _buildVehicleTableHeader(AppConstants.tcsValue),
                  _buildVehicleTableHeader(AppConstants.invValue),
                  _buildVehicleTableHeader(AppConstants.empsInc),
                  _buildVehicleTableHeader(AppConstants.stateInc),
                  _buildVehicleTableHeader(AppConstants.totInvVal),
                  _buildVehicleTableHeader(AppConstants.vehicle),
                  _buildVehicleTableHeader(AppConstants.action),
                ],
                rows: [
                  ...widget.purchaseBloc.purchaseBillDataList
                      .expand((billData) {
                    return billData.vehicleDetails!
                        .asMap()
                        .entries
                        .map((entry) {
                      final data = entry.value;
                      final index = entry.key;

                      final color = index.isEven
                          ? _appColors.whiteColor
                          : _appColors.transparentBlueColor;
                      return DataRow(
                        color:
                            MaterialStateColor.resolveWith((states) => color),
                        cells: [
                          DataCell(Text((index + 1).toString())),
                          DataCell(Text(data.partNo ?? '')),
                          DataCell(Text(data.vehicleName)),
                          DataCell(Text(data.hsnCode.toString())),
                          DataCell(Text(data.qty.toString())),
                          DataCell(
                              Text(AppUtils.formatCurrency(data.unitRate))),
                          DataCell(Text(AppUtils.formatCurrency(
                              data.totalValue?.toDouble() ?? 0.0))),
                          DataCell(Text(AppUtils.formatCurrency(
                              data.discountValue ?? 0.0))),
                          DataCell(Text(AppUtils.formatCurrency(
                              data.taxableValue ?? 0.0))),
                          if (widget.purchaseBloc.selectedGstType !=
                              AppConstants.igstAmount)
                            DataCell(Text(data.cgstPercentage.toString())),
                          if (widget.purchaseBloc.selectedGstType !=
                              AppConstants.igstAmount)
                            DataCell(Text(AppUtils.formatCurrency(
                                data.cgstAmount ?? 0.0))),
                          if (widget.purchaseBloc.selectedGstType !=
                              AppConstants.igstAmount)
                            DataCell(Text(data.sgstPercentage.toString())),
                          if (widget.purchaseBloc.selectedGstType !=
                              AppConstants.igstAmount)
                            DataCell(Text(AppUtils.formatCurrency(
                                data.sgstAmount ?? 0.0))),
                          if (widget.purchaseBloc.selectedGstType !=
                              AppConstants.gstPercent)
                            DataCell(Text(data.igstPercentage.toString())),
                          if (widget.purchaseBloc.selectedGstType !=
                              AppConstants.gstPercent)
                            DataCell(Text(AppUtils.formatCurrency(
                                data.igstAmount ?? 0.0))),
                          DataCell(Text(
                              AppUtils.formatCurrency(data.tcsValue ?? 0.0))),
                          DataCell(Text(
                              AppUtils.formatCurrency(data.totalValue ?? 0.0))),
                          DataCell(Text(AppUtils.formatCurrency(
                              data.empsIncentive ?? 0.0))),
                          DataCell(Text(AppUtils.formatCurrency(
                              data.stateIncentive ?? 0.0))),
                          DataCell(Text(AppUtils.formatCurrency(
                              data.totalInvoiceValue ?? 0.0))),
                          DataCell(
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog.adaptive(
                                      surfaceTintColor: AppColors().whiteColor,
                                      backgroundColor: AppColors().whiteColor,
                                      title: const Text(
                                          AppConstants.engineDetails),
                                      content: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.8,
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: DataTable(
                                                  columns: const [
                                                    DataColumn(
                                                        label: Text('S.No')),
                                                    DataColumn(
                                                        label: Text(
                                                            'Engine Number')),
                                                    DataColumn(
                                                        label: Text(
                                                            'Frame Number')),
                                                  ],
                                                  rows: List.generate(
                                                    data.engineDetails.length,
                                                    (index) => DataRow(
                                                      cells: [
                                                        DataCell(Text(
                                                            (index + 1)
                                                                .toString())),
                                                        DataCell(Text(data
                                                            .engineDetails[
                                                                index]
                                                            .engineNo)),
                                                        DataCell(Text(data
                                                            .engineDetails[
                                                                index]
                                                            .frameNo)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.table_chart_outlined,
                                color: _appColors.primaryColor,
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: SvgPicture.asset(AppConstants.icEdit),
                                  onPressed: () {
                                    _editPurchaseBillRow(data);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList();
                  }),
                  DataRow(
                    color: MaterialStateColor.resolveWith(
                        (states) => Colors.greenAccent.shade200),
                    cells: [
                      const DataCell(Text('Total')),
                      const DataCell(Text('')),
                      const DataCell(Text('')),
                      const DataCell(Text('')),
                      DataCell(Text(totals['qty'].toString())),
                      const DataCell(Text('')),
                      DataCell(
                          Text(AppUtils.formatCurrency(totals['totalValue']!))),
                      DataCell(Text(
                          AppUtils.formatCurrency(totals['discountValue']!))),
                      DataCell(Text(
                          AppUtils.formatCurrency(totals['taxableValue']!))),
                      const DataCell(Text('')),
                      DataCell(
                          Text(AppUtils.formatCurrency(totals['cgstAmount']!))),
                      const DataCell(Text('')),
                      DataCell(
                          Text(AppUtils.formatCurrency(totals['sgstAmount']!))),
                      if (widget.purchaseBloc.selectedGstType !=
                          AppConstants.gstPercent)
                        const DataCell(Text('')),
                      if (widget.purchaseBloc.selectedGstType !=
                          AppConstants.gstPercent)
                        DataCell(Text(
                            AppUtils.formatCurrency(totals['igstAmount']!))),
                      DataCell(
                          Text(AppUtils.formatCurrency(totals['tcsValue']!))),
                      DataCell(
                          Text(AppUtils.formatCurrency(totals['totalValue']!))),
                      DataCell(Text(
                          AppUtils.formatCurrency(totals['empsIncentive']!))),
                      DataCell(Text(
                          AppUtils.formatCurrency(totals['stateIncentive']!))),
                      DataCell(Text(AppUtils.formatCurrency(
                          totals['totalInvoiceValue']!))),
                      const DataCell(Text('')),
                      const DataCell(Text('')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Map<String, double> _calculateTotals(List<PurchaseBillData> dataList) {
    double qtyTotal = 0;
    double totalValueTotal = 0.0;
    double discountValueTotal = 0.0;
    double taxableValueTotal = 0.0;
    double cgstAmountTotal = 0.0;
    double sgstAmountTotal = 0.0;
    double igstAmountTotal = 0.0;
    double tcsValueTotal = 0.0;
    double empsIncentiveTotal = 0.0;
    double stateIncentiveTotal = 0.0;
    double totalInvoiceValueTotal = 0.0;

    for (var billData in dataList) {
      for (var vehicleDetail in billData.vehicleDetails!) {
        qtyTotal += vehicleDetail.qty;
        totalValueTotal += vehicleDetail.totalValue?.toDouble() ?? 0.0;
        discountValueTotal += vehicleDetail.discountValue ?? 0.0;
        taxableValueTotal += vehicleDetail.taxableValue ?? 0.0;
        cgstAmountTotal += vehicleDetail.cgstAmount ?? 0.0;
        sgstAmountTotal += vehicleDetail.sgstAmount ?? 0.0;
        igstAmountTotal += vehicleDetail.igstAmount ?? 0.0;
        tcsValueTotal += vehicleDetail.tcsValue ?? 0.0;
        empsIncentiveTotal += vehicleDetail.empsIncentive ?? 0.0;
        stateIncentiveTotal += vehicleDetail.stateIncentive ?? 0.0;
        totalInvoiceValueTotal += vehicleDetail.totalInvoiceValue ?? 0.0;
      }
    }

    return {
      'qty': qtyTotal,
      'totalValue': totalValueTotal,
      'discountValue': discountValueTotal,
      'taxableValue': taxableValueTotal,
      'cgstAmount': cgstAmountTotal,
      'sgstAmount': sgstAmountTotal,
      'igstAmount': igstAmountTotal,
      'tcsValue': tcsValueTotal,
      'empsIncentive': empsIncentiveTotal,
      'stateIncentive': stateIncentiveTotal,
      'totalInvoiceValue': totalInvoiceValueTotal,
    };
  }

  _buildVehicleTableHeader(String headerValue) => DataColumn(
        label: Text(
          headerValue,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      );

  Widget _buildPreviewAndActionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomElevatedButton(
          text: AppConstants.preview,
          fontSize: 16,
          buttonBackgroundColor: _appColors.primaryColor,
          fontColor: _appColors.whiteColor,
          onPressed: () {
            Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      PurchaseTablePreview(
                    purchaseBloc: widget.purchaseBloc,
                  ),
                ));
          },
        ),
        CustomActionButtons(
            onPressed: () {
              if (widget.purchaseBloc.purchaseBillDataList.isNotEmpty) {
                _isLoadingState(state: true);
                widget.purchaseBloc.addNewPurchaseDetails(_purchasePostData(),
                    (statusCode) {
                  if (statusCode == 201 || statusCode == 200) {
                    Navigator.pop(context);
                    _isLoadingState(state: false);
                    AppWidgetUtils.buildToast(
                        context,
                        ToastificationType.success,
                        AppConstants.purchaseBillScc,
                        Icon(Icons.check_circle_outline_rounded,
                            color: _appColors.successColor),
                        AppConstants.purchaseBillDescScc,
                        _appColors.successLightColor);
                  } else {
                    _isLoadingState(state: false);
                    AppWidgetUtils.buildToast(
                        context,
                        ToastificationType.error,
                        AppConstants.purchaseBillerr,
                        Icon(Icons.not_interested_rounded,
                            color: _appColors.errorColor),
                        AppConstants.purchaseBillDescerr,
                        _appColors.errorLightColor);
                  }
                });
              } else {
                AppWidgetUtils.buildToast(
                    context,
                    ToastificationType.error,
                    AppConstants.purchaseBillEmpty,
                    Icon(Icons.not_interested_rounded,
                        color: _appColors.errorColor),
                    AppConstants.purchaseBillDesEmptycerr,
                    _appColors.errorLightColor);
              }
            },
            buttonText: AppConstants.save)
      ],
    );
  }

  AddPurchaseModel _purchasePostData() {
    SpecificationsValue _specValue = SpecificationsValue(specs: {});
    List<Map<String, dynamic>> _mainSpecInfos = [];
    // Collecting engine details
    for (var mainSpecValue in widget.purchaseBloc.purchaseBillDataList) {
      for (var vehicle in mainSpecValue.vehicleDetails!) {
        for (var element in vehicle.engineDetails) {
          _mainSpecInfos.add({
            'engineNo': element.engineNo,
            'frameNo': element.frameNo,
          });
        }
      }
    }
    final List<GstDetail> gstDetailsList = [];
    final List<Incentive> incentivesList = [];
    final List<Tax> taxDetailsList = [];
    // Collecting GST, Tax and Incentive details
    for (var gstDetails in widget.purchaseBloc.purchaseBillDataList) {
      for (var vehicle in gstDetails.vehicleDetails!) {
        if (vehicle.gstType == AppConstants.gstPercent) {
          gstDetailsList.add(GstDetail(
              gstAmount: vehicle.cgstAmount ?? 0.0,
              gstName: "CGST",
              percentage: vehicle.cgstPercentage ?? 0.0));
          gstDetailsList.add(GstDetail(
              gstAmount: vehicle.sgstAmount ?? 0.0,
              gstName: "SGST",
              percentage: vehicle.sgstPercentage ?? 0.0));
        }
        if (vehicle.gstType == AppConstants.igstPercent) {
          gstDetailsList.add(GstDetail(
              gstAmount: vehicle.igstAmount ?? 0.0,
              gstName: "IGST",
              percentage: vehicle.igstPercentage ?? 0.0));
        }

        if (vehicle.incentiveType == AppConstants.empsIncetive) {
          incentivesList.add(Incentive(
              incentiveAmount: vehicle.empsIncentive ?? 0.0,
              incentiveName: 'EMPS 2024 INCENTIVE',
              percentage: 0));
        }

        if (vehicle.incentiveType == AppConstants.stateIncetive) {
          incentivesList.add(Incentive(
              incentiveAmount: vehicle.stateIncentive ?? 0.0,
              incentiveName: 'STATE INCENTIVE',
              percentage: 0));
        }

        if (vehicle.tcsValue != null) {
          taxDetailsList.add(Tax(
              percentage: 0,
              taxAmount: vehicle.tcsValue ?? 0.0,
              taxName: 'TCS VALUE'));
        }
      }
    }

    List<ItemDetail> _itemDetailsList = [];

    for (var itemData in widget.purchaseBloc.purchaseBillDataList) {
      for (var vehicleData in itemData.vehicleDetails!) {
        final _itemDetail = ItemDetail(
          categoryId: vehicleData.categoryId.toString(),
          discount: 0,
          gstDetails: gstDetailsList,
          incentives: incentivesList,
          itemName: vehicleData.vehicleName,
          mainSpecInfos: _mainSpecInfos,
          partNo: vehicleData.partNo.toString(),
          quantity: vehicleData.qty,
          specificationsValue: _specValue,
          taxes: taxDetailsList,
          unitRate: vehicleData.unitRate,
        );
        _itemDetailsList.add(_itemDetail);
      }
    }

    int totalQty = _itemDetailsList.fold(0, (sum, item) => sum + item.quantity);

    final purchaseData = AddPurchaseModel(
      branchId: widget.purchaseBloc.branchId.toString(),
      itemDetails: _itemDetailsList,
      pInvoiceDate: AppUtils.appToAPIDateFormat(
          widget.purchaseBloc.invoiceDateController.text),
      pInvoiceNo: widget.purchaseBloc.invoiceNumberController.text,
      pOrderRefNo: widget.purchaseBloc.purchaseRefController.text,
      totalQty: totalQty,
      vendorId: widget.purchaseBloc.selectedVendorId.toString(),
    );

    return purchaseData;
  }

  void _isLoadingState({required bool state}) {
    setState(() {
      widget.purchaseBloc.isAddPurchseBillLoading = state;
    });
  }

  void _editPurchaseBillRow(VehicleDetails data) {
    setState(() {
      widget.purchaseBloc.partNumberController.text = data.partNo.toString();
      widget.purchaseBloc.vehicleNameTextController.text = data.vehicleName;
      widget.purchaseBloc.hsnCodeController.text = data.hsnCode.toString();
      widget.purchaseBloc.unitRateController.text = data.unitRate.toString();
      widget.purchaseBloc.engineDetailsStreamController(true);
      for (var engineDetailsMap in data.engineDetails) {
        widget.purchaseBloc.engineDetailsList.add(engineDetailsMap);
        widget.purchaseBloc.refreshEngineDetailsListStramController(true);
      }
      widget.purchaseBloc.selectedGstType = data.gstType;
      print('*****************GST Type = > ${data.gstType}');
      if (data.gstType == AppConstants.gstPercent) {
        widget.purchaseBloc.selectedGstType = data.gstType;
        widget.purchaseBloc.gstRadioBtnRefreshStreamController(true);
        widget.purchaseBloc.cgstPresentageTextController.text =
            data.cgstPercentage.toString();
        widget.purchaseBloc.sgstPresentageTextController.text =
            data.sgstPercentage.toString();
      } else {
        widget.purchaseBloc.selectedGstType = data.gstType;
        widget.purchaseBloc.gstRadioBtnRefreshStreamController(true);
        widget.purchaseBloc.igstPresentageTextController.text =
            data.igstPercentage.toString();
      }
    });
  }
}
