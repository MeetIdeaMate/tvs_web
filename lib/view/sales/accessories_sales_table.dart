import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/api_service/service_locator.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlbilling/view/sales/accessories_sales_entry_dialog.dart';
import 'package:tlbilling/view/sales/add_sales_bloc.dart';

class AccessoiresSalesTable extends StatefulWidget {
  const AccessoiresSalesTable({super.key});

  @override
  State<AccessoiresSalesTable> createState() => _AccessoiresSalesTableState();
}

class _AccessoiresSalesTableState extends State<AccessoiresSalesTable> {
  final _appColors = AppColors();
  final _addSalesBloc = getIt<AddSalesBlocImpl>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAddedAccessoriesAndAccessoriesTable(),
          _buildNextButton()
        ],
      ),
    );
  }

  Widget _buildAddedAccessoriesAndAccessoriesTable() {
    return StreamBuilder<bool>(
      stream: _addSalesBloc.refreshsalesDataTable,
      builder: (context, snapshot) {
        if (_addSalesBloc.accessoriesItemList?.isEmpty ?? false) {
          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: SvgPicture.asset(AppConstants.imgNoData)),
                Text(AppConstants.salessnodateMsg,
                    style: TextStyle(
                      color: _appColors.greyColor,
                    ))
              ],
            ),
          );
        }

        double totalQuantity = 0;
        double totalUnitRate = 0;
        double totalValue = 0;
        double totalDiscount = 0;
        double totalTaxableValue = 0;
        double totalCgstValue = 0;
        double totalSgstValue = 0;
        double totalIgstValue = 0;
        double totalInvoiceValue = 0;

        double cgstPercent = 0;
        double cgstValue = 0;
        double sgstPercent = 0;
        double sgstValue = 0;
        double igstPercent = 0;
        double igstValue = 0;

        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    key: UniqueKey(),
                    dividerThickness: 0.01,
                    columns: [
                      _buildAccessoriesTableHeader(AppConstants.sno),
                      _buildAccessoriesTableHeader(AppConstants.materialNumber),
                      _buildAccessoriesTableHeader(AppConstants.materialName),
                      _buildAccessoriesTableHeader(AppConstants.hsnCode),
                      _buildAccessoriesTableHeader(AppConstants.quantity),
                      _buildAccessoriesTableHeader(AppConstants.unitRate),
                      _buildAccessoriesTableHeader(AppConstants.totalValue),
                      _buildAccessoriesTableHeader(AppConstants.discountAmount),
                      _buildAccessoriesTableHeader(AppConstants.taxableValue),
                      if (_addSalesBloc.selectedGstType !=
                          AppConstants.igstAmount)
                        _buildAccessoriesTableHeader(AppConstants.cgstPercent),
                      if (_addSalesBloc.selectedGstType !=
                          AppConstants.igstAmount)
                        _buildAccessoriesTableHeader(AppConstants.cgstAmount),
                      if (_addSalesBloc.selectedGstType !=
                          AppConstants.igstAmount)
                        _buildAccessoriesTableHeader(AppConstants.sgstPercent),
                      if (_addSalesBloc.selectedGstType !=
                          AppConstants.igstAmount)
                        _buildAccessoriesTableHeader(AppConstants.sgstAmount),
                      if (_addSalesBloc.selectedGstType !=
                          AppConstants.gstPercent)
                        _buildAccessoriesTableHeader(AppConstants.igstPercent),
                      if (_addSalesBloc.selectedGstType !=
                          AppConstants.gstPercent)
                        _buildAccessoriesTableHeader(AppConstants.igstAmount),
                      _buildAccessoriesTableHeader(AppConstants.invValue),
                      _buildAccessoriesTableHeader(AppConstants.action),
                    ],
                    rows: [
                      ..._addSalesBloc.accessoriesItemList!
                          .asMap()
                          .entries
                          .map((entry) {
                        if (entry.value.gstDetails != null) {
                          for (var gstDetail in entry.value.gstDetails ?? []) {
                            if (gstDetail.gstName == 'CGST') {
                              cgstPercent = gstDetail.percentage ?? 0;
                              cgstValue = gstDetail.gstAmount ?? 0;
                            } else if (gstDetail.gstName == 'SGST') {
                              sgstPercent = gstDetail.percentage ?? 0;
                              sgstValue = gstDetail.gstAmount ?? 0;
                            } else if (gstDetail.gstName == 'IGST') {
                              igstPercent = gstDetail.percentage ?? 0;
                              igstValue = gstDetail.gstAmount ?? 0;
                            }
                          }
                        }

                        totalQuantity += entry.value.quantity ?? 0;
                        totalUnitRate += entry.value.unitRate ?? 0;
                        totalValue += entry.value.value ?? 0;
                        totalDiscount += entry.value.discount ?? 0;
                        totalTaxableValue += entry.value.taxableValue ?? 0;
                        totalCgstValue += cgstValue;
                        totalSgstValue += sgstValue;
                        totalIgstValue += igstValue;
                        totalInvoiceValue += entry.value.invoiceValue ?? 0;
                        _addSalesBloc.totalQty = totalQuantity;
                        _addSalesBloc.totalValue = totalValue;
                        _addSalesBloc.totalDiscount = totalDiscount;
                        _addSalesBloc.taxableValue = totalTaxableValue;
                        _addSalesBloc.cgstAmount = totalCgstValue;
                        _addSalesBloc.sgstAmount = totalSgstValue;
                        _addSalesBloc.igstAmount = totalIgstValue;
                        _addSalesBloc.totalInvAmount = totalInvoiceValue;
                        _addSalesBloc.toBePayedAmt = double.tryParse(
                            totalInvoiceValue.round().toString());

                        return DataRow(
                          color: WidgetStateColor.resolveWith((states) {
                            return Colors.white;
                          }),
                          cells: [
                            DataCell(Text('${entry.key + 1}')),
                            DataCell(Text(entry.value.partNo ?? '')),
                            DataCell(Text(entry.value.itemName ?? '')),
                            DataCell(Text(entry.value.hsnSacCode ?? '')),
                            DataCell(Text(entry.value.quantity.toString())),
                            DataCell(Text(AppUtils.formatCurrency(
                                    entry.value.unitRate ?? 0)
                                .toString())),
                            DataCell(Text(
                                AppUtils.formatCurrency(entry.value.value ?? 0)
                                    .toString())),
                            DataCell(Text(AppUtils.formatCurrency(
                                    entry.value.discount ?? 0)
                                .toString())),
                            DataCell(Text(AppUtils.formatCurrency(
                                    entry.value.taxableValue ?? 0)
                                .toString())),
                            if (_addSalesBloc.selectedGstType !=
                                AppConstants.igstAmount)
                              DataCell(Text(cgstPercent.toString())),
                            if (_addSalesBloc.selectedGstType !=
                                AppConstants.igstAmount)
                              DataCell(Text(AppUtils.formatCurrency(cgstValue)
                                  .toString())),
                            if (_addSalesBloc.selectedGstType !=
                                AppConstants.igstAmount)
                              DataCell(Text(sgstPercent.toString())),
                            if (_addSalesBloc.selectedGstType !=
                                AppConstants.igstAmount)
                              DataCell(Text(AppUtils.formatCurrency(cgstValue)
                                  .toString())),
                            if (_addSalesBloc.selectedGstType !=
                                AppConstants.gstPercent)
                              DataCell(Text(igstPercent.toString())),
                            if (_addSalesBloc.selectedGstType !=
                                AppConstants.gstPercent)
                              DataCell(Text(AppUtils.formatCurrency(igstValue)
                                  .toString())),
                            DataCell(Text(AppUtils.formatCurrency(
                                    entry.value.invoiceValue ?? 0)
                                .toString())),
                            DataCell(IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return AccessoriesSalesEntryDialog(
                                        editValues: entry.value,
                                        editIndex: entry.key,
                                        totalQty: totalQuantity,
                                      );
                                    },
                                  );
                                },
                                icon: SvgPicture.asset(AppConstants.icEdit))),
                          ],
                        );
                      }),
                      DataRow(
                        color: WidgetStateColor.resolveWith((states) {
                          return _appColors.tableTotalAmtRowColor;
                        }),
                        cells: [
                          const DataCell(Text('')),
                          const DataCell(Text('')),
                          const DataCell(Text('')),
                          const DataCell(Text('')),
                          DataCell(Text(totalQuantity.toString())),
                          DataCell(Text(AppUtils.formatCurrency(totalUnitRate)
                              .toString())),
                          DataCell(Text(
                              AppUtils.formatCurrency(totalValue).toString())),
                          DataCell(Text(AppUtils.formatCurrency(totalDiscount)
                              .toString())),
                          DataCell(Text(
                              AppUtils.formatCurrency(totalTaxableValue)
                                  .toString())),
                          if (_addSalesBloc.selectedGstType !=
                              AppConstants.igstAmount)
                            const DataCell(Text('')),
                          if (_addSalesBloc.selectedGstType !=
                              AppConstants.igstAmount)
                            DataCell(Text(
                                AppUtils.formatCurrency(totalCgstValue)
                                    .toString())),
                          if (_addSalesBloc.selectedGstType !=
                              AppConstants.igstAmount)
                            const DataCell(Text('')),
                          if (_addSalesBloc.selectedGstType !=
                              AppConstants.igstAmount)
                            DataCell(Text(
                                AppUtils.formatCurrency(totalSgstValue)
                                    .toString())),
                          if (_addSalesBloc.selectedGstType !=
                              AppConstants.gstPercent)
                            const DataCell(Text('')),
                          if (_addSalesBloc.selectedGstType !=
                              AppConstants.gstPercent)
                            DataCell(Text(
                                AppUtils.formatCurrency(totalIgstValue)
                                    .toString())),
                          DataCell(Text(
                              AppUtils.formatCurrency(totalInvoiceValue)
                                  .toString())),
                          const DataCell(Text('')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                  visible: _addSalesBloc.isAccessoriestable == false,
                  child: _buildSalestableVerifyCheckBox())
            ],
          ),
        );
      },
    );
  }

  _buildAccessoriesTableHeader(String headerValue) => DataColumn(
        label: Text(
          headerValue,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      );

  Widget _buildSalestableVerifyCheckBox() {
    return Visibility(
      visible: _addSalesBloc.accessoriesItemList?.isNotEmpty ?? false,
      child: SizedBox(
        width: 500,
        child: Row(
          children: [
            Checkbox(
              value: _addSalesBloc.isTableDataVerifited,
              onChanged: (value) {
                setState(() {
                  _addSalesBloc.isTableDataVerifited = value!;
                });
              },
            ),
            AppWidgetUtils.buildSizedBox(custWidth: 10),
            const Text(AppConstants.salesTableverifyMsg),
          ],
        ),
      ),
    );
  }

  _buildNextButton() {
    return Visibility(
      visible: _addSalesBloc.isAccessoriestable == false,
      child: Visibility(
          visible: _addSalesBloc.isTableDataVerifited ?? false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
                    side: WidgetStateProperty.all(
                      BorderSide(
                        color: _appColors.primaryColor,
                      ),
                    ),
                    backgroundColor:
                        WidgetStateProperty.all(_appColors.primaryColor),
                  ),
                  onPressed: () {
                    _addSalesBloc.isAccessoriestable = true;
                    _addSalesBloc.screenChangeStreamController(true);
                  },
                  child: Text(
                    AppConstants.next,
                    style: TextStyle(color: _appColors.whiteColor),
                  )),
            ],
          )),
    );
  }
}
