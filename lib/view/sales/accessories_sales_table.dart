import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlbilling/view/sales/accessories_sales_entry_dialog.dart';
import 'package:tlbilling/view/sales/add_sales_bloc.dart';

class AccessoiresSalesTable extends StatefulWidget {
  final AddSalesBlocImpl addSalesBloc;
  const AccessoiresSalesTable({super.key, required this.addSalesBloc});

  @override
  State<AccessoiresSalesTable> createState() => _AccessoiresSalesTableState();
}

class _AccessoiresSalesTableState extends State<AccessoiresSalesTable> {
  final _appColors = AppColors();

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
      stream: widget.addSalesBloc.refreshsalesDataTable,
      builder: (context, snapshot) {
        if (widget.addSalesBloc.accessoriesItemList?.isEmpty ?? false) {
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
                      if (widget.addSalesBloc.selectedGstType !=
                          AppConstants.igstAmount)
                        _buildAccessoriesTableHeader(AppConstants.cgstPercent),
                      if (widget.addSalesBloc.selectedGstType !=
                          AppConstants.igstAmount)
                        _buildAccessoriesTableHeader(AppConstants.cgstAmount),
                      if (widget.addSalesBloc.selectedGstType !=
                          AppConstants.igstAmount)
                        _buildAccessoriesTableHeader(AppConstants.sgstPercent),
                      if (widget.addSalesBloc.selectedGstType !=
                          AppConstants.igstAmount)
                        _buildAccessoriesTableHeader(AppConstants.sgstAmount),
                      if (widget.addSalesBloc.selectedGstType !=
                          AppConstants.gstPercent)
                        _buildAccessoriesTableHeader(AppConstants.igstPercent),
                      if (widget.addSalesBloc.selectedGstType !=
                          AppConstants.gstPercent)
                        _buildAccessoriesTableHeader(AppConstants.igstAmount),
                      _buildAccessoriesTableHeader(AppConstants.invValue),
                      _buildAccessoriesTableHeader(AppConstants.action),
                    ],
                    rows: [
                      ...widget.addSalesBloc.accessoriesItemList!
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
                        widget.addSalesBloc.totalQty = totalQuantity;
                        widget.addSalesBloc.totalValue = totalValue;
                        widget.addSalesBloc.totalDiscount = totalDiscount;
                        widget.addSalesBloc.taxableValue = totalTaxableValue;
                        widget.addSalesBloc.cgstAmount = totalCgstValue;
                        widget.addSalesBloc.sgstAmount = totalSgstValue;
                        widget.addSalesBloc.igstAmount = totalIgstValue;
                        widget.addSalesBloc.totalInvAmount = totalInvoiceValue;
                        widget.addSalesBloc.toBePayedAmt = totalInvoiceValue;

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
                            if (widget.addSalesBloc.selectedGstType !=
                                AppConstants.igstAmount)
                              DataCell(Text(cgstPercent.toString())),
                            if (widget.addSalesBloc.selectedGstType !=
                                AppConstants.igstAmount)
                              DataCell(Text(AppUtils.formatCurrency(cgstValue)
                                  .toString())),
                            if (widget.addSalesBloc.selectedGstType !=
                                AppConstants.igstAmount)
                              DataCell(Text(sgstPercent.toString())),
                            if (widget.addSalesBloc.selectedGstType !=
                                AppConstants.igstAmount)
                              DataCell(Text(AppUtils.formatCurrency(cgstValue)
                                  .toString())),
                            if (widget.addSalesBloc.selectedGstType !=
                                AppConstants.gstPercent)
                              DataCell(Text(igstPercent.toString())),
                            if (widget.addSalesBloc.selectedGstType !=
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
                                        addSalesBloc: widget.addSalesBloc,
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
                          if (widget.addSalesBloc.selectedGstType !=
                              AppConstants.igstAmount)
                            const DataCell(Text('')),
                          if (widget.addSalesBloc.selectedGstType !=
                              AppConstants.igstAmount)
                            DataCell(Text(
                                AppUtils.formatCurrency(totalCgstValue)
                                    .toString())),
                          if (widget.addSalesBloc.selectedGstType !=
                              AppConstants.igstAmount)
                            const DataCell(Text('')),
                          if (widget.addSalesBloc.selectedGstType !=
                              AppConstants.igstAmount)
                            DataCell(Text(
                                AppUtils.formatCurrency(totalSgstValue)
                                    .toString())),
                          if (widget.addSalesBloc.selectedGstType !=
                              AppConstants.gstPercent)
                            const DataCell(Text('')),
                          if (widget.addSalesBloc.selectedGstType !=
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
                  visible: widget.addSalesBloc.isAccessoriestable == false,
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
      visible: widget.addSalesBloc.accessoriesItemList?.isNotEmpty ?? false,
      child: SizedBox(
        width: 500,
        child: Row(
          children: [
            Checkbox(
              value: widget.addSalesBloc.isTableDataVerifited,
              onChanged: (value) {
                setState(() {
                  widget.addSalesBloc.isTableDataVerifited = value!;
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
      visible: widget.addSalesBloc.isAccessoriestable == false,
      child: Visibility(
          visible: widget.addSalesBloc.isTableDataVerifited ?? false,
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
                    widget.addSalesBloc.isAccessoriestable = true;
                    widget.addSalesBloc.screenChangeStreamController(true);
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
