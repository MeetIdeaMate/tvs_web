import 'package:flutter/material.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/useraccess/access_control_view.dart';

class AccessControlViewScreen extends StatefulWidget {
  const AccessControlViewScreen({super.key});

  @override
  State<AccessControlViewScreen> createState() =>
      _AccessControlViewScreenState();
}

class _AccessControlViewScreenState extends State<AccessControlViewScreen> {
  final _appColors = AppColors();
  final _accessViewControlBloc = AccessControlViewBlocImpl();

  @override
  void dispose() {
    _accessViewControlBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Tooltip(
        message: 'Update access data',
        child: FloatingActionButton(
          backgroundColor: _appColors.primaryColor,
          shape: const CircleBorder(),
          child: Icon(
            Icons.cloud_upload,
            color: _appColors.whiteColor,
          ),
          onPressed: () {
            // Add your onPressed code here
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppWidgetUtils.buildHeaderText(AppConstants.accessControl),
            AppWidgetUtils.buildSizedBox(custHeight: 26),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DataTable(
                    dividerThickness: 0.01,
                    columns: const [
                      DataColumn(label: Text('Screen Name')),
                      DataColumn(label: Text('Hide')),
                      DataColumn(label: Text('View')),
                      DataColumn(label: Text('Add')),
                      DataColumn(label: Text('P-Update')),
                      DataColumn(label: Text('F-Update')),
                      DataColumn(label: Text('Delete')),
                    ],
                    rows: List.generate(
                        _accessViewControlBloc.screenNameList.length, (index) {
                      return DataRow(
                        color: MaterialStateColor.resolveWith((states) {
                          return index % 2 == 0
                              ? Colors.white
                              : _appColors.transparentBlueColor;
                        }),
                        cells: [
                          DataCell(Text(_accessViewControlBloc.screenNameList[index])),
                          DataCell(StreamBuilder<List<bool>>(
                            stream: _accessViewControlBloc.hideChecksStream,
                            builder: (context, snapshot) {
                              bool value = snapshot.data?[index] ?? false;
                              return Checkbox(
                                value: value,
                                onChanged: (bool? newValue) {
                                  _accessViewControlBloc.updateHideCheck(
                                      index, newValue ?? false);
                                },
                              );
                            },
                          )),
                          DataCell(StreamBuilder<List<bool>>(
                            stream: _accessViewControlBloc.viewChecksStream,
                            builder: (context, snapshot) {
                              bool isHideChecked = snapshot.data?[index] ?? false;
                              bool isDisabled = _accessViewControlBloc.isHideChecked(index);
                              return Checkbox(
                                value: isHideChecked && !isDisabled,
                                onChanged: isDisabled ? null : (bool? newValue) {
                                  _accessViewControlBloc.updateViewCheck(
                                      index, newValue ?? false);
                                },
                              );
                            },
                          )),
                          DataCell(StreamBuilder<List<bool>>(
                            stream: _accessViewControlBloc.addChecksStream,
                            builder: (context, snapshot) {
                              bool isHideChecked = snapshot.data?[index] ?? false;
                              bool isDisabled = _accessViewControlBloc.isHideChecked(index);
                              return Checkbox(
                                value: isHideChecked && !isDisabled,
                                onChanged: isDisabled ? null : (bool? newValue) {
                                  _accessViewControlBloc.updateAddCheck(
                                      index, newValue ?? false);
                                },
                              );
                            },
                          )),
                          DataCell(StreamBuilder<List<bool>>(
                            stream: _accessViewControlBloc.pUpdateChecksStream,
                            builder: (context, snapshot) {
                              bool isHideChecked = snapshot.data?[index] ?? false;
                              bool isDisabled = _accessViewControlBloc.isHideChecked(index);
                              return Checkbox(
                                value: isHideChecked && !isDisabled,
                                onChanged: isDisabled ? null : (bool? newValue) {
                                  _accessViewControlBloc.updatePUpdateCheck(
                                      index, newValue ?? false);
                                },
                              );
                            },
                          )),
                          DataCell(StreamBuilder<List<bool>>(
                            stream: _accessViewControlBloc.fUpdateChecksStream,
                            builder: (context, snapshot) {
                              bool isHideChecked = snapshot.data?[index] ?? false;
                              bool isDisabled = _accessViewControlBloc.isHideChecked(index);
                              return Checkbox(
                                value: isHideChecked && !isDisabled,
                                onChanged: isDisabled ? null : (bool? newValue) {
                                  _accessViewControlBloc.updateFUpdateCheck(
                                      index, newValue ?? false);
                                },
                              );
                            },
                          )),
                          DataCell(StreamBuilder<List<bool>>(
                            stream: _accessViewControlBloc.deleteChecksStream,
                            builder: (context, snapshot) {
                              bool isHideChecked = snapshot.data?[index] ?? false;
                              bool isDisabled = _accessViewControlBloc.isHideChecked(index);
                              return Checkbox(
                                value: isHideChecked && !isDisabled,
                                onChanged: isDisabled ? null : (bool? newValue) {
                                  _accessViewControlBloc.updateDeleteCheck(
                                      index, newValue ?? false);
                                },
                              );
                            },
                          )),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
