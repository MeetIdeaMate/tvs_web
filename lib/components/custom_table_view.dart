import 'package:flutter/material.dart';

class CustomTableView extends StatelessWidget {
  final List<String> columnHeaders;
  final List<DataRow> rows;

  const CustomTableView({
    super.key,
    required this.columnHeaders,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        dividerThickness: 0.01,
        columns: _buildColumns(),
        rows: rows,
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
}
