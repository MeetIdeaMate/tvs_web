import 'package:flutter/material.dart';
import 'package:tlbilling/dash_board/file_upload_dilaog.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';

class UploadedStatements extends StatefulWidget {
  const UploadedStatements({super.key});

  @override
  State<UploadedStatements> createState() => _UploadedStatementsState();
}

class _UploadedStatementsState extends State<UploadedStatements> {
  final _appColors = AppColors();

  @override
  Widget build(BuildContext context) {
    return AppWidgetUtils.buildAddbutton(
      context,
      width: MediaQuery.of(context).size.width * 0.17,
      text: AppConstants.uploadStatement,
      onPressed: () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const FileUploadDialog();
          },
        );
      },
    );
  }
}
