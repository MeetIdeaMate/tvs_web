import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlds_flutter/export.dart';

class DetailStockView extends StatefulWidget {
  const DetailStockView({super.key});

  @override
  State<DetailStockView> createState() => _DetailStockViewState();
}

class _DetailStockViewState extends State<DetailStockView> {
  final _appColors = AppColor();
  List<Map<String, String>> rowData = [
    {
      AppConstants.sno: '1',
      AppConstants.engineNumber: 'DG5BR1029320',
      AppConstants.frameNumber: 'MD26CG5BR1C0023',
      AppConstants.color: 'WALNUT BROWN',
      AppConstants.hsnCode: '87112019',
      AppConstants.branchCode: 'Main Branch',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TVS JUPITER-OBDIIA WALN  ${rowData.length}',
          style: GoogleFonts.poppins(color: _appColors.primaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: _buildStockTableView(context),
      ),
    );
  }

  _buildStockTableView(BuildContext context) {
    return Expanded(
        child: SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: DataTable(
        key: UniqueKey(),
        dividerThickness: 0.01,
        columns: [
          _buildVehicleTableHeader(
            AppConstants.sno,
          ),
          _buildVehicleTableHeader(AppConstants.engineNumber),
          _buildVehicleTableHeader(AppConstants.frameNumber),
          _buildVehicleTableHeader(AppConstants.color),
          _buildVehicleTableHeader(AppConstants.hsnCode),
          _buildVehicleTableHeader(AppConstants.branchCode),
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
              DataCell(Text(data[AppConstants.engineNumber]!)),
              DataCell(Text(data[AppConstants.frameNumber]!)),
              DataCell(Text(data[AppConstants.color]!)),
              DataCell(Text(data[AppConstants.hsnCode]!)),
              DataCell(Text(data[AppConstants.branchCode]!)),
            ],
          );
        }),
      ),
    ));
  }

  _buildVehicleTableHeader(String headerValue) => DataColumn(
        label: Text(
          headerValue,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      );
}
