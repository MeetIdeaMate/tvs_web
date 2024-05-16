import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tlbilling/components/custom_dropdown_button_form_field.dart';
import 'package:tlbilling/utils/app_colors.dart';
//import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/action_dialog/delete_dialog.dart';
import 'package:tlbilling/view/branch/branch_details.dart';
import 'package:tlbilling/view/branch/branch_view_bloc.dart';
import 'package:tlbilling/view/branch/create_branch_dialog.dart';

class BranchView extends StatefulWidget {
  const BranchView({super.key});

  @override
  State<BranchView> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<BranchView> {
  final _branchViewBlocImpl = BranchViewBlocImpl();
  final _appColors = AppColors();
  final List<Map<String, String>> _rowData = [
    {
      AppConstants.sno: '1',
      AppConstants.branchName: 'MuthuLakshmi',
      AppConstants.mobileNumber: '1234567890',
      AppConstants.city: 'ABCD1234E',
      AppConstants.pinCode: 'ABCD1234E',
    },
    {
      AppConstants.sno: '2',
      AppConstants.branchName: 'MuthuLakshmi',
      AppConstants.mobileNumber: '1234567890',
      AppConstants.city: 'ABCD1234E',
      AppConstants.pinCode: 'ABCD1234E',
    },
    {
      AppConstants.sno: '3',
      AppConstants.branchName: 'MuthuLakshmi',
      AppConstants.mobileNumber: '1234567890',
      AppConstants.city: 'ABCD1234E',
      AppConstants.pinCode: 'ABCD1234E',
    },
    {
      AppConstants.sno: '4',
      AppConstants.branchName: 'MuthuLakshmi',
      AppConstants.mobileNumber: '1234567890',
      AppConstants.city: 'ABCD1234E',
      AppConstants.pinCode: 'ABCD1234E',
    },
  ];
  // final _appColors = AppColors();
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

            // Center(
            //   child: Column(
            //     children: [
            //       SvgPicture.asset(AppConstants.imgNoData),
            //       _buildText(
            //           name: AppConstants.noDataStore,
            //           color: _appcolors.greyColor,
            //           fontWeight: FontWeight.bold,
            //           fontSize: 15)
            //     ],
            //   ),
            // )

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
        _buildAddBranchbutton(context)
      ],
    );
  }

  _buildAddBranchbutton(BuildContext context) {
    return AppWidgetUtils.buildAddbutton(flex: 1, context, onPressed: () {
      return showDialog(
        context: context,
        builder: (context) {
          return const CreateBranchDialog();
        },
      );
    }, text: AppConstants.addBranch);
  }

  _buildBranchNameFilter() {
    return AppWidgetUtils.buildSearchField(AppConstants.branchName,
        _branchViewBlocImpl.filterBranchnameController, context);
  }

  _buildPinCodeFilter() {
    return AppWidgetUtils.buildSearchField(AppConstants.pinCode,
        _branchViewBlocImpl.filterBranchnameController, context);
  }

  _buildCityFilter() {
    return Expanded(
      child: CustomDropDownButtonFormField(
        //    width: MediaQuery.of(context).size.width * 0.1,
        height: 40,
        dropDownItems: city!,
        hintText: AppConstants.exSelect,
        onChange: (String? newValue) {
          _branchViewBlocImpl.selectedCity = newValue;
        },
      ),
    );
  }

  _buildBranchTableView(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          dividerThickness: 0.01,
          columns: [
            _buildBranchTableHeader(
              AppConstants.sno,
            ),
            _buildBranchTableHeader(
              AppConstants.branchName,
            ),
            _buildBranchTableHeader(
              AppConstants.mobileNumber,
            ),
            _buildBranchTableHeader(
              AppConstants.city,
            ),
            _buildBranchTableHeader(
              AppConstants.pinCode,
            ),
            _buildBranchTableHeader(
              AppConstants.subBranch,
            ),
            _buildBranchTableHeader(
              AppConstants.action,
            ),
          ],
          rows: List.generate(_rowData.length, (index) {
            final data = _rowData[index];

            final color = index.isEven
                ? _appColors.whiteColor
                : _appColors.transparentBlueColor;
            return DataRow(
              color: MaterialStateColor.resolveWith((states) => color),
              cells: [
                _buildTableRow(data, AppConstants.sno),
                _buildTableRow(data, AppConstants.branchName),
                _buildTableRow(data, AppConstants.mobileNumber),
                _buildTableRow(data, AppConstants.city),
                _buildTableRow(data, AppConstants.pinCode),
                DataCell(
                  IconButton(
                    icon: SvgPicture.asset(
                      AppConstants.icBranch,
                      colorFilter:
                          ColorFilter.mode(_appColors.green, BlendMode.srcIn),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const BranchDetails();
                        },
                      );
                    },
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(AppConstants.icEdit),
                        onPressed: () {},
                      ),
                      IconButton(
                          icon: SvgPicture.asset(AppConstants.icdelete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return DeleteDialog(
                                  content: AppConstants.deleteMsg,
                                  onPressed: () {},
                                );
                              },
                            );
                          }),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  DataCell _buildTableRow(Map<String, String> data, String? text) =>
      DataCell(Text(
        data[text]!,
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
