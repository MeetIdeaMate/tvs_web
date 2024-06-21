import 'package:flutter/material.dart';
import 'package:tlbilling/models/get_model/get_all_purchase_model.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlds_flutter/util/app_colors.dart';

class VehicleDetailsDialog extends StatelessWidget {
  final List<ItemDetail>? purchaseBills;
  final bool showDetailsTable;
  const VehicleDetailsDialog({
    super.key,
    required this.purchaseBills,
    required this.showDetailsTable,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: AppColor().whiteColor,
      backgroundColor: AppColor().whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Vehicle Details',
            style: TextStyle(color: AppColor().primaryColor),
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
        height: 400,
        width: 530,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: purchaseBills!.map((purchaseBill) {
              return ExpansionTile(
                title: Text(purchaseBill.itemName ?? 'N/A'),
                subtitle: Text(purchaseBill.partNo ?? 'N/A'),
                expandedAlignment: Alignment.topLeft,
                dense: true,
                children: showDetailsTable
                    ? [
                        DataTable(
                          columns: [
                            const DataColumn(
                              label: Text(
                                AppConstants.sno,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            _buildVehicleTableHeader(AppConstants.engineNumber),
                            _buildVehicleTableHeader(AppConstants.frameNumber),
                          ],
                          rows: purchaseBill.mainSpecValues!
                              .asMap()
                              .entries
                              .map((entry) {
                            final index = entry.key;
                            final value = entry.value;
                            return DataRow(
                              color: MaterialStateColor.resolveWith((states) {
                                return entry.key % 2 == 0
                                    ? Colors.white
                                    : AppColor().transparentBlueColor;
                              }),
                              cells: [
                                _buildTableRow((index + 1).toString()),
                                _buildTableRow(value.engineNumber),
                                _buildTableRow(value.frameNumber),
                              ],
                            );
                          }).toList(),
                        ),
                      ]
                    : [],
              );
            }).toList(),
          ),
        ),
      ),
    );
 
 
  }

  DataColumn _buildVehicleTableHeader(String headerValue) {
    return DataColumn(
      label: Text(
        headerValue,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  DataCell _buildTableRow(String? text) => DataCell(
        Text(
          text ?? '',
          style: const TextStyle(fontSize: 14),
        ),
      );
}
