import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/dash_board/matched_dialog.dart';
import 'package:tlbilling/dash_board/statement_compare_bloc.dart';
import 'package:tlbilling/dash_board/update_statement_dialog.dart';
import 'package:tlbilling/models/get_model/get_all_statement_summary_model.dart';
import 'package:tlbilling/models/get_model/get_statement_by_id_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlds_flutter/components/tlds_date_picker.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';

class StatementView extends StatefulWidget {
  final String? statementId;
  const StatementView({super.key, required this.statementId});

  @override
  State<StatementView> createState() => _StatementViewState();
}

class _StatementViewState extends State<StatementView> {
  final _appColors = AppColors();
  final _statementCompareBloc = StatementCompareBlocImpl();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildFiltersAndSummarizeChip(),
            const SizedBox(height: 20),
            _buildStatementTable(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        AppConstants.statementCompare,
        style: TextStyle(color: _appColors.primaryColor),
      ),
    );
  }

  _buildFiltersAndSummarizeChip() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateFilter(),
        _buildChip(),
      ],
    );
  }

  _buildChip() {
    return StreamBuilder<bool>(
        stream: _statementCompareBloc.matchedChipStream,
        builder: (context, snapshot) {
          return GestureDetector(
            onTap: !_statementCompareBloc.isSummarize
                ? () {
                    _statementCompareBloc.isSummarize = true;
                    _statementCompareBloc.tableRefreshStreamController(true);
                    _statementCompareBloc.matchedChipStreamController(true);
                  }
                : _statementCompareBloc.isMissMatch
                    ? () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return const MatchedDialog();
                          },
                        );
                      }
                    : null,
            child: SizedBox(
              child: Chip(
                label: Text(!_statementCompareBloc.isSummarize
                    ? AppConstants.summarize
                    : AppConstants.matched),
                labelStyle: TextStyle(color: _appColors.whiteColor),
                backgroundColor: _statementCompareBloc.isSummarize
                    ? _statementCompareBloc.isMissMatch
                        ? _appColors.green
                        : _appColors.grey
                    : _appColors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          );
        });
  }

  _buildDateFilter() {
    return StreamBuilder<bool>(
        stream: _statementCompareBloc.matchedChipStream,
        builder: (context, snapshot) {
          return Expanded(
            child: Visibility(
              visible: (_statementCompareBloc.summaryDetails?.isEmpty ?? false),
              child: Row(
                children: [
                  _buildfromDate(context),
                  AppWidgetUtils.buildSizedBox(custWidth: 10),
                  _buildToDate(context),
                  AppWidgetUtils.buildSizedBox(custWidth: 10),
                  _buildAccountTypeFilter()
                ],
              ),
            ),
          );
        });
  }

  _buildAccountTypeFilter() {
    return Visibility(
      visible: (_statementCompareBloc.summaryDetails?.isEmpty ?? false) &&
          _statementCompareBloc.isSummarize,
      child: FutureBuilder(
        future: _statementCompareBloc.getConfigByIdModel(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text(AppConstants.loading);
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text(AppConstants.noData);
          } else {
            return TldsDropDownButtonFormField(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.2,
              dropDownValue: _statementCompareBloc.accountType,
              dropDownItems: snapshot.data ?? [],
              hintText: "AccountType",
              onChange: (String? newValue) {
                _statementCompareBloc.accountType = newValue;
                _statementCompareBloc.tableRefreshStreamController(true);
              },
            );
          }
        },
      ),
    );
  }

  _buildToDate(BuildContext context) {
    return TldsDatePicker(
      controller: _statementCompareBloc.toDateController,
      hintText: AppConstants.toDate,
      width: MediaQuery.of(context).size.width * 0.2,
      firstDate: DateTime(2000),
      onSuccessCallBack: () {
        _statementCompareBloc.tableRefreshStreamController(true);
      },
    );
  }

  _buildfromDate(BuildContext context) {
    return TldsDatePicker(
      controller: _statementCompareBloc.fromDateController,
      hintText: AppConstants.fromDate,
      width: MediaQuery.of(context).size.width * 0.2,
      firstDate: DateTime(2000),
      onSuccessCallBack: () {
        _statementCompareBloc.tableRefreshStreamController(true);
      },
    );
  }

  _buildStatementTable() {
    return Expanded(
      child: StreamBuilder<bool>(
          stream: _statementCompareBloc.tableRefreshStream,
          builder: (context, snapshot) {
            if (_statementCompareBloc.summaryDetails?.isNotEmpty ?? false) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: AppWidgetUtils.buildLoading());
              }
              return _buildDataTable(_statementCompareBloc.summaryDetails!);
            }
            return _buildFetchTableData();
          }),
    );
  }

  FutureBuilder<Object> _buildFetchTableData() {
    return FutureBuilder(
      future: _statementCompareBloc.isSummarize ||
              _statementCompareBloc.isUpdated
          ? _statementCompareBloc.getStatementSummary(
              widget.statementId ?? '', _statementCompareBloc.accountType ?? '')
          : _statementCompareBloc.getStatementById(widget.statementId ?? ''),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: AppWidgetUtils.buildLoading());
        } else if (snapshot.hasError) {
          return const Center(child: Text(AppConstants.somethingWentWrong));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text(AppConstants.noData));
        }
        final data = snapshot.data;

        if (_statementCompareBloc.isSummarize) {
          if (data is StatementSummary) {
            final summary = data.bankStatementSummaryList ?? [];

            if (_statementCompareBloc.isUpdated) {
              _statementCompareBloc.isUpdated = false;
              final summaryDetails = summary
                  .where((e) =>
                      e.accountHeadName ==
                          _statementCompareBloc.selectedAccountHead &&
                      e.accountType == _statementCompareBloc.accountType)
                  .expand((e) => e.summaryDetails ?? [])
                  .cast<SummaryDetail>()
                  .toList();

              _statementCompareBloc.summaryDetails = summaryDetails;
              _statementCompareBloc.tableRefreshStreamController(true);
            }
            _statementCompareBloc.bankStatmentDetails =
                data.bankStatementSummaryList ?? [];
            return _buildDataTable(summary);
          } else {
            return const Center(child: Text(AppConstants.noData));
          }
        } else {
          if (data is Statement) {
            final transactions = data.transactions ?? [];
            return _buildDataTable(transactions);
          } else {
            return const Center(child: Text(AppConstants.noData));
          }
        }
      },
    );
  }

  _buildDataRow(int index, dynamic rowData) {
    if (_statementCompareBloc.isSummarize &&
        (_statementCompareBloc.summaryDetails?.isEmpty ?? false)) {
      if (rowData is BankStatementSummaryList) {
        return _buildStatementSummaryList(rowData, index);
      }
    } else if (rowData is SummaryDetail) {
      return _buildSummaryDetails(rowData, index);
    } else {
      if (rowData is Transaction) {
        return _buildTransactionData(index, rowData);
      }
    }
  }

  DataRow _buildStatementSummaryList(
      BankStatementSummaryList rowData, int index) {
    bool allRowsMissMatch = _statementCompareBloc.bankStatmentDetails!
        .every((rowData) => rowData.missMatch == false);
    _statementCompareBloc.isMissMatch = allRowsMissMatch;
    _statementCompareBloc.matchedChipStreamController(true);
    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (rowData.missMatch ?? false) {
          return _appColors.missMatchRowColor;
        }
        return null;
      }),
      cells: [
        DataCell(
          Text((index + 1).toString()),
        ),
        DataCell(Text(rowData.description ?? '')),
        DataCell(Text(rowData.amount?.toStringAsFixed(2) ?? '')),
        DataCell(Text(rowData.accountHeadName ?? '')),
        DataCell(Text(rowData.accountType ?? '')),
        DataCell(Text(rowData.applicationAmt?.toStringAsFixed(2) ?? '')),
        DataCell(InkWell(
          onTap: rowData.missMatch ?? false
              ? () {
                  _statementCompareBloc.selectedAccountHead =
                      rowData.accountHeadName ?? '';
                  _statementCompareBloc.summaryDetails = rowData.summaryDetails;
                  _statementCompareBloc.tableRefreshStreamController(true);
                  _statementCompareBloc.isMissMatch = false;
                  _statementCompareBloc.matchedChipStreamController(true);
                }
              : () {},
          child: SvgPicture.asset(
            AppConstants.icCompare,
            colorFilter: ColorFilter.mode(
                rowData.missMatch ?? false
                    ? _appColors.primaryColor
                    : _appColors.greyColor,
                BlendMode.srcIn),
          ),
        ))
      ],
    );
  }

  DataRow _buildTransactionData(int index, Transaction rowData) {
    return DataRow(
      cells: [
        DataCell(Text((index + 1).toString())),
        DataCell(Text(AppUtils.apiToAppDateFormat(rowData.date ?? ''))),
        DataCell(Text(rowData.description ?? '')),
        const DataCell(Text('')),
        DataCell(Text(rowData.debit?.toStringAsFixed(2) ?? '0')),
        DataCell(Text(rowData.credit?.toStringAsFixed(2) ?? '0')),
        DataCell(Text(rowData.balance?.toStringAsFixed(2) ?? '0')),
      ],
    );
  }

  DataRow _buildSummaryDetails(SummaryDetail rowData, int index) {
    bool allRowsMissMatch = _statementCompareBloc.summaryDetails!
        .every((rowData) => rowData.missMatch == false);
    _statementCompareBloc.isMissMatch = allRowsMissMatch;
    _statementCompareBloc.matchedChipStreamController(true);
    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (rowData.missMatch ?? false) {
          return _appColors.missMatchRowColor;
        }
        return null;
      }),
      cells: [
        DataCell(Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: rowData.updated ?? false
                ? _appColors.tableUpdatedRecordColor
                : null,
            width: double.infinity,
            child: Text((index + 1).toString()))),
        DataCell(Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: rowData.updated ?? false
                ? _appColors.tableUpdatedRecordColor
                : null,
            width: double.infinity,
            child: Text(AppUtils.apiToAppDateFormat(rowData.date ?? '')))),
        DataCell(Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: rowData.updated ?? false
                ? _appColors.tableUpdatedRecordColor
                : null,
            width: double.infinity,
            child: Text(rowData.description ?? ''))),
        DataCell(Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: rowData.updated ?? false
                ? _appColors.tableUpdatedRecordColor
                : null,
            width: double.infinity,
            child: Text(rowData.cheque ?? ''))),
        DataCell(Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: rowData.updated ?? false
                ? _appColors.tableUpdatedRecordColor
                : null,
            width: double.infinity,
            child: Text(rowData.amount?.toStringAsFixed(0).toString() ?? ''))),
        DataCell(Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: _appColors.tableApplocationRecordColor,
            width: double.infinity,
            child: Text(rowData.salesBillNo ?? ''))),
        DataCell(Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: _appColors.tableApplocationRecordColor,
            width: double.infinity,
            child: Text(rowData.partyName ?? ''))),
        DataCell(Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: _appColors.tableApplocationRecordColor,
            width: double.infinity,
            child: Text(rowData.applicationTransactRefId ?? ''))),
        DataCell(Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: _appColors.tableApplocationRecordColor,
            width: double.infinity,
            child: Text(rowData.applicationAmt?.toStringAsFixed(2) ?? ''))),
        DataCell(InkWell(
          onTap: rowData.missMatch ?? false
              ? () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return UpdateStatementDialog(
                          statementCompareblocImpl: _statementCompareBloc,
                          date: rowData.date ?? '',
                          amount: rowData.applicationAmt ?? 0,
                          summaryId: rowData.summaryId ?? '',
                          statemetId: widget.statementId ?? '');
                    },
                  );
                }
              : () {},
          child: SvgPicture.asset(
            AppConstants.icTally,
            colorFilter: ColorFilter.mode(
                rowData.missMatch ?? false
                    ? _appColors.primaryColor
                    : _appColors.greyColor,
                BlendMode.srcIn),
          ),
        ))
      ],
    );
  }

  _buildDataTable(List<dynamic> data) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: _statementCompareBloc.summaryDetails?.isEmpty ?? false
              ? MediaQuery.of(context).size.width
              : null,
          child: DataTable(
            headingRowHeight: 40,
            columnSpacing: 10,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent),
            ),
            headingRowColor:
                WidgetStatePropertyAll(_appColors.bgHighlightColor),
            columns: _buildheader(),
            rows: List.generate(data.length, (index) {
              final statementData = data[index];

              return _buildDataRow(index, statementData);
            }),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildheader() {
    if (_statementCompareBloc.isSummarize &&
        (_statementCompareBloc.summaryDetails?.isEmpty ?? false)) {
      return _buildBankSummaryListHeader();
    } else if (_statementCompareBloc.summaryDetails?.isNotEmpty ?? false) {
      return _buildSummeryDetailsHeader();
    } else {
      return _buildTransactionHeader();
    }
  }

  List<DataColumn> _buildTransactionHeader() {
    return [
      AppWidgetUtils.buildTableHeader(AppConstants.sno),
      AppWidgetUtils.buildTableHeader(AppConstants.date),
      AppWidgetUtils.buildTableHeader(AppConstants.describtion),
      AppWidgetUtils.buildTableHeader(AppConstants.cheque),
      AppWidgetUtils.buildTableHeader(AppConstants.debit),
      AppWidgetUtils.buildTableHeader(AppConstants.credit),
      AppWidgetUtils.buildTableHeader(AppConstants.balanceAmt),
    ];
  }

  List<DataColumn> _buildSummeryDetailsHeader() {
    return [
      AppWidgetUtils.buildTableHeader(AppConstants.sno),
      AppWidgetUtils.buildTableHeader(AppConstants.date),
      AppWidgetUtils.buildTableHeader(AppConstants.describtion),
      AppWidgetUtils.buildTableHeader(AppConstants.cheque),
      AppWidgetUtils.buildTableHeader(AppConstants.amount),
      AppWidgetUtils.buildTableHeader(AppConstants.salesBillNo),
      AppWidgetUtils.buildTableHeader(AppConstants.partyName),
      AppWidgetUtils.buildTableHeader(AppConstants.transactionId),
      AppWidgetUtils.buildTableHeader(AppConstants.applicationAmt),
      AppWidgetUtils.buildTableHeader(AppConstants.tally),
    ];
  }

  List<DataColumn> _buildBankSummaryListHeader() {
    return [
      AppWidgetUtils.buildTableHeader(AppConstants.sno),
      AppWidgetUtils.buildTableHeader(AppConstants.describtion),
      AppWidgetUtils.buildTableHeader(AppConstants.amount),
      AppWidgetUtils.buildTableHeader(AppConstants.accountHead),
      AppWidgetUtils.buildTableHeader(AppConstants.applicationAmt),
      AppWidgetUtils.buildTableHeader(AppConstants.accountType),
      AppWidgetUtils.buildTableHeader(AppConstants.compare)
    ];
  }
}
