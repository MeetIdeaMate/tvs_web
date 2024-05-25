import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlds_flutter/export.dart';

class PurchaseTable extends StatefulWidget {
  const PurchaseTable({super.key});

  @override
  State<PurchaseTable> createState() => _PurchaseTableState();
}

class _PurchaseTableState extends State<PurchaseTable> {
  final _appColors = AppColor();
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
              ),
            )));
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
