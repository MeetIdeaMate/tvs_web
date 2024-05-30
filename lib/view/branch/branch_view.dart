import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tlbilling/components/custom_dropdown_button_form_field.dart';
import 'package:tlbilling/models/get_model/get_all_branches_by_pagination.dart';
import 'package:tlbilling/utils/app_colors.dart';

//import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/action_dialog/delete_dialog.dart';
import 'package:tlbilling/view/branch/branch_details.dart';
import 'package:tlbilling/view/branch/branch_view_bloc.dart';
import 'package:tlbilling/view/branch/create_branch_dialog.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';

class BranchView extends StatefulWidget {
  const BranchView({super.key});

  @override
  State<BranchView> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<BranchView> {
  final _branchViewBlocImpl = BranchViewBlocImpl();
  final _appColors = AppColors();
  List<String>? city = [
    'kvp',
    'chennai',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppWidgetUtils.buildHeaderText(AppConstants.branch),
            AppWidgetUtils.buildSizedBox(custHeight: 28),
            _buildsearchFiltersAndAddButton(context),
            AppWidgetUtils.buildSizedBox(custHeight: 28),
            _buildBranchTableView(context)
          ],
        ),
      ),
    );
  }

  _buildsearchFiltersAndAddButton(BuildContext context) {
    return Row(
      children: [
        _buildBranchNameFilter(),
        AppWidgetUtils.buildSizedBox(custWidth: 5),
        _buildPinCodeFilter(),
        AppWidgetUtils.buildSizedBox(custWidth: 5),
        _buildCityFilter(),
        const Spacer(),
        _buildAddBranchButton(context)
      ],
    );
  }

  _buildAddBranchButton(BuildContext context) {
    return AppWidgetUtils.buildAddbutton(flex: 1, context, onPressed: () {
      return showDialog(
        context: context,
        builder: (context) {
          return const CreateBranchDialog();
        },
      ).then((value) {
        _branchViewBlocImpl.branchTableStream(true);
      });
    }, text: AppConstants.addBranch);
  }

  _buildBranchNameFilter() {
    return StreamBuilder(
      stream: _branchViewBlocImpl.branchNameStreamController,
      builder: (context, snapshot) {
        return _buildFormField(_branchViewBlocImpl.filterBranchnameController,
            AppConstants.branchName);
      },
    );
  }

  _buildPinCodeFilter() {
    return StreamBuilder(
      stream: _branchViewBlocImpl.pinCodeStreamController,
      builder: (context, snapshot) {
        return _buildFormField(
            _branchViewBlocImpl.filterpinCodeController, AppConstants.pinCode);
      },
    );
  }

  _buildCityFilter() {
    return CustomDropDownButtonFormField(
      width: MediaQuery.of(context).size.width * 0.1,
      height: 40,
      dropDownItems: city!,
      hintText: AppConstants.exSelect,
      onChange: (String? newValue) {
        _branchViewBlocImpl.selectedCity = newValue;
      },
    );
  }

  Widget _buildFormField(
      TextEditingController textController, String hintText) {
    final bool isTextEmpty = textController.text.isEmpty;
    final IconData iconData = isTextEmpty ? Icons.search : Icons.close;
    final Color iconColor = isTextEmpty ? _appColors.primaryColor : Colors.red;
    return TldsInputFormField(
      width: 203,
      height: 40,
      controller: textController,
      hintText: hintText,
      suffixIcon: IconButton(
        onPressed: iconData == Icons.search
            ? () {
                //add search cont here
                _checkController(hintText);
              }
            : () {
                textController.clear();
                _checkController(hintText);
              },
        icon: Icon(
          iconData,
          color: iconColor,
        ),
      ),
      onSubmit: (p0) {
        //add search cont here
        _checkController(hintText);
      },
    );
  }

  void _checkController(String hintText) {
    if (AppConstants.branchName == hintText) {
      _branchViewBlocImpl.branchNameStream(true);
    } else if (AppConstants.pinCode == hintText) {
      _branchViewBlocImpl.pinCodeStream(true);
    }
  }

  _buildBranchTableView(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: _branchViewBlocImpl.branchTableStreamController,
          builder: (context, snapshot) {
            return FutureBuilder(
              future: _branchViewBlocImpl.getBranchList(),
              builder: (context, snapshot) {
                List<BranchDetail>? branchDetail = snapshot.data?.branchDetail;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: AppWidgetUtils.buildLoading(),
                  );
                } else if (snapshot.hasData) {
                  if (branchDetail?.isNotEmpty == true) {
                    return DataTable(
                        dividerThickness: 0.01,
                        columns: [
                          _buildBranchTableHeader(AppConstants.sno),
                          _buildBranchTableHeader(AppConstants.branchName),
                          _buildBranchTableHeader(AppConstants.mobileNumber),
                          _buildBranchTableHeader(AppConstants.city),
                          _buildBranchTableHeader(AppConstants.pinCode),
                          _buildBranchTableHeader(AppConstants.subBranch),
                          _buildBranchTableHeader(AppConstants.action),
                        ],
                        rows: branchDetail
                                ?.asMap()
                                .entries
                                .map((branchData) => DataRow(
                                      color: MaterialStateProperty.resolveWith(
                                          (states) {
                                        if (branchData.key.isEven) {
                                          return _appColors.whiteColor;
                                        } else {
                                          return _appColors
                                              .transparentBlueColor;
                                        }
                                      }),
                                      cells: [
                                        DataCell(Text('${branchData.key + 1}')),
                                        _buildTableRow(
                                            branchData.value.branchName ?? ''),
                                        _buildTableRow(
                                            branchData.value.mobileNo ?? ''),
                                        _buildTableRow(
                                            branchData.value.city ?? ''),
                                        _buildTableRow(
                                            branchData.value.pinCode ?? ''),
                                        DataCell(
                                          IconButton(
                                            icon: SvgPicture.asset(
                                              AppConstants.icBranch,
                                              colorFilter: ColorFilter.mode(
                                                  _appColors.green,
                                                  BlendMode.srcIn),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return BranchDetails(
                                                      subBranches: branchData
                                                          .value.subBranches,
                                                      mainBranchName: branchData
                                                          .value.branchName);
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        DataCell(
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              IconButton(
                                                icon: SvgPicture.asset(
                                                    AppConstants.icEdit),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        CreateBranchDialog(
                                                            branchId: branchData
                                                                .value
                                                                .branchId),
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                  icon: SvgPicture.asset(
                                                      AppConstants.icdelete),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return DeleteDialog(
                                                          content: AppConstants
                                                              .deleteMsg,
                                                          onPressed: () {},
                                                        );
                                                      },
                                                    );
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ))
                                .toList() ??
                            []);
                  } else {
                    return Center(
                      child: SvgPicture.asset(AppConstants.noDataStore),
                    );
                  }
                }
                return Center(
                  child: SvgPicture.asset(AppConstants.noDataStore),
                );
              },
            );
          },
        ),
      ),
    );
  }

  DataCell _buildTableRow(String text) => DataCell(Text(
        text,
        style: const TextStyle(fontSize: 14),
      ));

  _buildBranchTableHeader(
    String headerValue,
  ) {
    return DataColumn(
      label: Text(
        headerValue,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
