import 'package:flutter/material.dart';
import 'package:tlbilling/utils/app_colors.dart';

class CustomTableView extends StatelessWidget {
  final List<String> columnHeaders;
  final List<Map<String, String>> rowData;

  const CustomTableView({
    super.key,
    required this.columnHeaders,
    required this.rowData,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        dividerThickness: 0.01,
        columns: _buildColumns(),
        rows: _buildRows(),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return columnHeaders
        .map((header) => DataColumn(
                label: Text(
              header,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )))
        .toList();
  }

  List<DataRow> _buildRows() {
    return rowData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final isLastRow = index == rowData.length - 1;
      final color =
          isLastRow ? AppColors().tableTotalAmtRowColor : AppColors.white12;

      return DataRow(
        color: MaterialStateColor.resolveWith((states) => color),
        cells: _buildCells(data),
      );
    }).toList();
  }

  List<DataCell> _buildCells(Map<String, String> data) {
    return columnHeaders
        .map((header) => DataCell(Text(data[header] ?? '')))
        .toList();
  }
}
