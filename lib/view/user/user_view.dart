import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/components/custom_dropdown_button_form_field.dart';
import 'package:tlbilling/components/custom_form_field.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/action_dialog/delete_dialog.dart';
import 'package:tlbilling/view/user/create_user_dialog.dart';
import 'package:tlbilling/view/user/user_view_bloc.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  final _appColors = AppColors();
  final _userViewBlocImpl = UserViewBlocImpl();
  List<String>? designation = [
    'Receptionist',
    'Receptionist1',
    'Receptionist2'
  ];
  List<Map<String, String>> rowData = [
    {
      AppConstants.sno: '1',
      AppConstants.username: 'MuthuLakshmi',
      AppConstants.mobileNumber: '1234567890',
      AppConstants.designation: 'Chennai',
      AppConstants.passwordLable: '0987',
    },
    {
      AppConstants.sno: '1',
      AppConstants.username: 'MuthuLakshmi',
      AppConstants.mobileNumber: '1234567890',
      AppConstants.designation: 'Chennai',
      AppConstants.passwordLable: '321',
    },
    {
      AppConstants.sno: '1',
      AppConstants.username: 'MuthuLakshmi',
      AppConstants.mobileNumber: '1234567890',
      AppConstants.designation: 'Chennai',
      AppConstants.passwordLable: '123',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppWidgetUtils.buildHeaderText(AppConstants.transport),
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
            _buildUserTableView(context)
          ],
        ),
      ),
    );
  }

  _buildsearchFiltersAndAddButton(BuildContext context) {
    return Row(
      children: [
        _buildUserNameAndMobNoFilter(),
        AppWidgetUtils.buildSizedBox(custWidth: 5),
        _buildDesignationFilter(),
        const Spacer(),
        const Spacer(),
        AppWidgetUtils.buildAddbutton(
          flex: 1,
          context,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return const CreateUserDialog();
              },
            );
          },
          text: AppConstants.addUser,
        )
      ],
    );
  }

  _buildDesignationFilter() {
    return CustomDropDownButtonFormField(
      width: MediaQuery.sizeOf(context).width * 0.15,
      height: 40,
      dropDownItems: designation ?? [],
      hintText: AppConstants.exSelect,
      onChange: (String? newValue) {
        _userViewBlocImpl.selectedDestination = newValue;
      },
    );
  }

  _buildUserNameAndMobNoFilter() {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: CustomFormField(
        hintText: AppConstants.userFilterHint,
        controller: _userViewBlocImpl.searchUserNameAndMobNoController,
        height: 40,
        width: MediaQuery.of(context).size.width * 0.19,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[a-z A-Z 0-9]")),
        ],
        hintColor: AppColors().hintColor,
        suffixIcon: IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(AppConstants.icSearch),
        ),
      ),
    );
  }

  _buildUserTableView(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          dividerThickness: 0.01,
          columns: [
            _builduserTableHeader(
              AppConstants.sno,
            ),
            _builduserTableHeader(
              AppConstants.username,
            ),
            _builduserTableHeader(
              AppConstants.mobileNumber,
            ),
            _builduserTableHeader(
              AppConstants.designation,
            ),
            _builduserTableHeader(
              AppConstants.passwordLable,
            ),
            _builduserTableHeader(
              AppConstants.action,
            ),
          ],
          rows: List.generate(rowData.length, (index) {
            final data = rowData[index];

            final color = index.isEven
                ? _appColors.whiteColor
                : _appColors.transparentBlueColor;
            return DataRow(
              color: MaterialStateColor.resolveWith((states) => color),
              cells: [
                _buildTableRow(data, AppConstants.sno),
                _buildTableRow(data, AppConstants.username),
                _buildTableRow(data, AppConstants.mobileNumber),
                _buildTableRow(data, AppConstants.designation),
                _buildTableRow(data, AppConstants.passwordLable),
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

  _builduserTableHeader(
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
