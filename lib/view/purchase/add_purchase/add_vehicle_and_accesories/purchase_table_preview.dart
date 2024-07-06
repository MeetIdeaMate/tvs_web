import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/models/purchase_bill_data.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_vehicle_and_accesories/add_vehicle_and_accessories_bloc.dart';
import 'package:tlds_flutter/export.dart';

class PurchaseTablePreview extends StatefulWidget {
  final AddVehicleAndAccessoriesBlocImpl purchaseBloc;
  const PurchaseTablePreview({super.key, required this.purchaseBloc});

  @override
  State<PurchaseTablePreview> createState() => _PurchaseTablePreviewState();
}

class _PurchaseTablePreviewState extends State<PurchaseTablePreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Table Preview'),
      ),
      body: Column(
        children: [
          Expanded(child: _buildAddedVehicleAndAccessoriesTable()),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColor().grey,
              ),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.purchaseBloc.purchaseBillDataList.length,
              itemBuilder: (BuildContext context, int index) {
                final billData =
                    widget.purchaseBloc.purchaseBillDataList[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                          billData.vehicleDetails?.first.vehicleName ?? ''),
                      subtitle:
                          Text(billData.vehicleDetails?.first.partNo ?? ''),
                    ),
                    SizedBox(
                      height: 100,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('S.No')),
                          DataColumn(label: Text('Engine No')),
                          DataColumn(label: Text('Frame No')),
                        ],
                        rows: billData.vehicleDetails?.expand((vehicle) {
                              return vehicle.engineDetails
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final engineDetail = entry.value;
                                final sNo = entry.key + 1;
                                return DataRow(cells: [
                                  DataCell(Text(sNo.toString())),
                                  DataCell(Text(engineDetail.engineNo)),
                                  DataCell(Text(engineDetail.frameNo)),
                                ]);
                              }).toList();
                            }).toList() ??
                            [],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddedVehicleAndAccessoriesTable() {
    return StreamBuilder<bool>(
      stream: widget.purchaseBloc.refreshPurchaseDataTable,
      builder: (context, snapshot) {
        if (widget.purchaseBloc.purchaseBillDataList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppConstants.imgNoData),
                Text(
                  'Add Purchase Value to the table to view',
                  style: TextStyle(
                    color: AppColors().greyColor,
                  ),
                ),
              ],
            ),
          );
        }
        final totals =
            _calculateTotals(widget.purchaseBloc.purchaseBillDataList);
        return SingleChildScrollView(
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
                _buildVehicleTableHeader(AppConstants.discountPresentage),
                _buildVehicleTableHeader(AppConstants.discountAmount),
                _buildVehicleTableHeader(AppConstants.taxableValue),
                _buildVehicleTableHeader(AppConstants.cgstPercent),
                _buildVehicleTableHeader(AppConstants.cgstAmount),
                _buildVehicleTableHeader(AppConstants.sgstPercent),
                _buildVehicleTableHeader(AppConstants.sgstAmount),
                _buildVehicleTableHeader(AppConstants.igstPercent),
                _buildVehicleTableHeader(AppConstants.igstAmount),
                _buildVehicleTableHeader(AppConstants.tcsValue),
                _buildVehicleTableHeader(AppConstants.invValue),
                _buildVehicleTableHeader(AppConstants.empsInc),
                _buildVehicleTableHeader(AppConstants.stateInc),
                _buildVehicleTableHeader(AppConstants.totInvVal),
              ],
              rows: [
                ...widget.purchaseBloc.purchaseBillDataList.expand((billData) {
                  return billData.vehicleDetails!.asMap().entries.map((entry) {
                    final data = entry.value;
                    final index = entry.key;

                    final color = index.isEven
                        ? AppColor().whiteColor
                        : AppColor().transparentBlueColor;
                    return DataRow(
                      color: MaterialStateColor.resolveWith((states) => color),
                      cells: [
                        DataCell(Text((index + 1).toString())),
                        DataCell(Text(data.partNo ?? '')),
                        DataCell(Text(data.vehicleName)),
                        DataCell(Text(data.hsnCode.toString())),
                        DataCell(Text(data.qty.toString())),
                        DataCell(Text(AppUtils.formatCurrency(data.unitRate))),
                        DataCell(Text(AppUtils.formatCurrency(
                            data.totalValue?.toDouble() ?? 0.0))),
                        DataCell(Text(data.discountPresentage.toString())),
                        DataCell(Text(AppUtils.formatCurrency(
                            data.discountValue ?? 0.0))),
                        DataCell(Text(
                            AppUtils.formatCurrency(data.taxableValue ?? 0.0))),
                        DataCell(Text(data.cgstPercentage.toString())),
                        DataCell(Text(
                            AppUtils.formatCurrency(data.cgstAmount ?? 0.0))),
                        DataCell(Text(data.sgstPercentage.toString())),
                        DataCell(Text(
                            AppUtils.formatCurrency(data.sgstAmount ?? 0.0))),
                        DataCell(Text(data.igstPercentage.toString())),
                        DataCell(Text(
                            AppUtils.formatCurrency(data.igstAmount ?? 0.0))),
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
                    const DataCell(Text('')),
                    DataCell(Text(
                        AppUtils.formatCurrency(totals['discountValue']!))),
                    DataCell(
                        Text(AppUtils.formatCurrency(totals['taxableValue']!))),
                    const DataCell(Text('')),
                    DataCell(
                        Text(AppUtils.formatCurrency(totals['cgstAmount']!))),
                    const DataCell(Text('')),
                    DataCell(
                        Text(AppUtils.formatCurrency(totals['sgstAmount']!))),
                    const DataCell(Text('')),
                    DataCell(
                        Text(AppUtils.formatCurrency(totals['igstAmount']!))),
                    DataCell(
                        Text(AppUtils.formatCurrency(totals['tcsValue']!))),
                    DataCell(
                        Text(AppUtils.formatCurrency(totals['totalValue']!))),
                    DataCell(Text(
                        AppUtils.formatCurrency(totals['empsIncentive']!))),
                    DataCell(Text(
                        AppUtils.formatCurrency(totals['stateIncentive']!))),
                    DataCell(Text(
                        AppUtils.formatCurrency(totals['totalInvoiceValue']!))),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  DataCell _buildTableRow(String? text) => DataCell(Text(
        text ?? '',
        style: const TextStyle(fontSize: 14),
      ));

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

  _buildVehicleTableHeader(String headerValue) {
    return DataColumn(
      label: Text(
        headerValue,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
