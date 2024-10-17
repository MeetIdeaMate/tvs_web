import 'package:flutter/material.dart';
import 'package:tlbilling/dash_board/file_upload_dilaog.dart';
import 'package:tlbilling/dash_board/statement_compare_view.dart';
import 'package:tlbilling/dash_board/uploaded_statement_bloc.dart';
import 'package:tlbilling/models/get_model/get_all_statement_list_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';

class UploadedStatements extends StatefulWidget {
  const UploadedStatements({super.key});

  @override
  State<UploadedStatements> createState() => _UploadedStatementsState();
}

class _UploadedStatementsState extends State<UploadedStatements> {
  final _appColors = AppColors();
  final _uploadedStatementBloc = UploadedStatementBlocImpl();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildBoxDecoration(),
      padding: const EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width * 0.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppWidgetUtils.buildHeaderText(
              AppConstants.recentlyUploadedStatement),
          AppWidgetUtils.buildSizedBox(custHeight: 16),
          _buildFetchUploadedData(),
          AppWidgetUtils.buildSizedBox(custHeight: 16),
          _buildUploadButton(context)
        ],
      ),
    );
  }

  Column _buildUploadButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppWidgetUtils.buildAddbutton(
          context,
          width: double.infinity,
          flex: 0,
          text: AppConstants.uploadStatement,
          onPressed: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return FileUploadDialog(
                  uploadedStatementBloc: _uploadedStatementBloc,
                );
              },
            );
          },
        ),
      ],
    );
  }

  Expanded _buildFetchUploadedData() {
    return Expanded(
      child: StreamBuilder<bool>(
          stream: _uploadedStatementBloc.tablerefreshStream,
          builder: (context, snapshot) {
            return FutureBuilder(
              future: _uploadedStatementBloc.getAllStatement(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: AppWidgetUtils.buildLoading());
                } else if (snapshot.data?.isEmpty ?? false) {
                  return const Center(child: Text(AppConstants.noData));
                }
                List<GetAllStatementInfo> statementInfo = snapshot.data ?? [];

                return _buildListView(statementInfo);
              },
            );
          }),
    );
  }

  _buildListView(List<GetAllStatementInfo> statementInfo) {
    return ListView.builder(
      itemCount: statementInfo.length,
      itemBuilder: (context, index) {
        final statement = statementInfo[index];
        _uploadedStatementBloc.statementId = statement.statementId;
        return Column(
          children: [
            _buildOnClickStatement(context, statement),
            const Divider(),
          ],
        );
      },
    );
  }

  _buildOnClickStatement(BuildContext context, GetAllStatementInfo statement) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return StatementView(
              statementId: _uploadedStatementBloc.statementId,
            );
          },
        ));
      },
      child: _buildListTile(statement),
    );
  }

  _buildListTile(GetAllStatementInfo statement) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _appColors.primaryColor,
        child: const Icon(Icons.description, color: Colors.white),
      ),
      title: Text(statement.fileName ?? ''),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppUtils.apiToAppDateFormat(statement.fromDate ?? '')),
          Text(AppUtils.apiToAppDateFormat(statement.toDate ?? '')),
        ],
      ),
    );
  }

  _buildBoxDecoration() {
    return BoxDecoration(
      boxShadow: const [
        BoxShadow(
          spreadRadius: -5,
          offset: Offset(-2, 2),
          blurStyle: BlurStyle.outer,
          color: Colors.black,
          blurRadius: 10,
        ),
      ],
      color: _appColors.whiteColor,
      borderRadius: BorderRadius.circular(10),
    );
  }
}
