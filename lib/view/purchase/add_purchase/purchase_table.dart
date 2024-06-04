import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_vehicle_and_accesories/add_vehicle_and_accessories_bloc.dart';
import 'package:tlds_flutter/export.dart';

class PurchaseTable extends StatefulWidget {
  AddVehicleAndAccessoriesBlocImpl purchaseBloc;

  PurchaseTable({super.key, required this.purchaseBloc});

  @override
  State<PurchaseTable> createState() => _PurchaseTableState();
}

class _PurchaseTableState extends State<PurchaseTable> {
  final _appColors = AppColor();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.sizeOf(context).width * 0.64,
        decoration: BoxDecoration(
            border: Border(
          right: BorderSide(color: _appColors.greyColor),
          top: BorderSide(color: _appColors.greyColor),
        )),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAddedVehicleAndAccessoriesTable(),
              _buildPreviewAndActionButton()
            ],
          ),
        ));
  }

  Widget _buildAddedVehicleAndAccessoriesTable() {
    return StreamBuilder<bool>(
        stream: widget.purchaseBloc.refreshPurchaseDataTable,
        builder: (context, snapshot) {
          return Expanded(
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: DataTable(
                        key: UniqueKey(),
                        dividerThickness: 0.01,
                        columns: [
                          _buildVehicleTableHeader(AppConstants.invoiceNo),
                          _buildVehicleTableHeader(AppConstants.invoiceDate),
                          _buildVehicleTableHeader(AppConstants.vendorName),
                          _buildVehicleTableHeader(AppConstants.purchaseRef),
                          _buildVehicleTableHeader(AppConstants.gstType),
                          _buildVehicleTableHeader(AppConstants.carrier),
                          _buildVehicleTableHeader(AppConstants.carrierNumber),
                          _buildVehicleTableHeader(AppConstants.action),
                        ],
                        rows: List.generate(
                            widget.purchaseBloc.purchaseBillDataList.length,
                            (index) {
                          final data =
                              widget.purchaseBloc.purchaseBillDataList[index];

                          final color = index.isEven
                              ? _appColors.whiteColor
                              : _appColors.transparentBlueColor;
                          return DataRow(
                            color: MaterialStateColor.resolveWith(
                                (states) => color),
                            cells: [
                              DataCell(Text(data.invoiceNo ?? '')),
                              DataCell(Text(data.invoiceDate ?? '')),
                              DataCell(Text(data.vendorName ?? '')),
                              DataCell(Text(data.purchaseRef ?? '')),
                              DataCell(Text(data.gstType ?? '')),
                              DataCell(Text(data.carrierName ?? '')),
                              DataCell(Text(data.carrierNumber ?? '')),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon:
                                          SvgPicture.asset(AppConstants.icEdit),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  )));
        });
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
          text: 'Preview',
          fontSize: 16,
          buttonBackgroundColor: _appColors.primaryColor,
          fontColor: _appColors.whiteColor,
        ),
        CustomActionButtons(onPressed: () {}, buttonText: 'Save')
      ],
    );
  }
}
