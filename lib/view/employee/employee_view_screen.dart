import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tlbilling/components/custom_dropdown_button_form_field.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/action_dialog/delete_dialog.dart';
import 'package:tlbilling/view/employee/create_employee_dialog.dart';
import 'package:tlbilling/view/employee/employee_view_bloc.dart';

class EmployeeView extends StatefulWidget {
  const EmployeeView({super.key});

  @override
  State<EmployeeView> createState() => _EmployeeViewState();
}

class _EmployeeViewState extends State<EmployeeView> {
  final _employeeViewBloc = EmployeeViewBlocImpl();
  final _appColors = AppColors();
  final List<String>? city = ['kvp', 'chennai'];
  List<Map<String, String>> rowData = [
    {
      AppConstants.sno: '1',
      AppConstants.empName: 'MuthuLakshmi',
      AppConstants.mobileNumber: '1234567890',
      AppConstants.city: 'Chennai',
      AppConstants.workType: 'manager',
      AppConstants.branchName: 'kovilPatti',
    },
    {
      AppConstants.sno: '2',
      AppConstants.empName: 'MahaLakshmi',
      AppConstants.mobileNumber: '1234567890',
      AppConstants.city: 'madurai',
      AppConstants.workType: 'machanic',
      AppConstants.branchName: 'madurai',
    },
    {
      AppConstants.sno: '3',
      AppConstants.empName: 'MuthuLakshmi',
      AppConstants.mobileNumber: '1234567890',
      AppConstants.city: 'Chennai',
      AppConstants.workType: 'manager',
      AppConstants.branchName: 'kovilPatti',
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
            AppWidgetUtils.buildHeaderText(AppConstants.employee),
            AppWidgetUtils.buildSizedBox(custHeight: 28),
            _buildFiltersAndAddEmpButton(context),
            AppWidgetUtils.buildSizedBox(custHeight: 28),
            _buildEmployeeTableView(context)
          ],
        ),
      ),
    );
  }

  _buildFiltersAndAddEmpButton(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildEmpNameOrSearchFilter(),
        _buildEmpCityDropdown(),
        _buildEmpWorkTypeDropdown(),
        _buildEmpBranchDropdown(),
        const Spacer(),
        _buildAddEmployeebutton(context)
      ],
    );
  }

  _buildEmpNameOrSearchFilter() {
    return AppWidgetUtils.buildSearchField(AppConstants.mobileNumber,
        _employeeViewBloc.empNameAndMobNoFilterController, context);
  }

  _buildDropDown(
      {List<String>? dropDownItems, String? hintText, String? selectedvalue}) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: CustomDropDownButtonFormField(
        width: MediaQuery.of(context).size.width * 0.1,
        height: 40,
        dropDownItems: dropDownItems!,
        hintText: hintText,
        onChange: (String? newValue) {
          selectedvalue = newValue ?? '';
        },
      ),
    );
  }

  _buildEmpCityDropdown() {
    return _buildDropDown(
        dropDownItems: city,
        hintText: AppConstants.allCity,
        selectedvalue: _employeeViewBloc.employeeCity);
  }

  _buildEmpWorkTypeDropdown() {
    return _buildDropDown(
        dropDownItems: city,
        hintText: AppConstants.workType,
        selectedvalue: _employeeViewBloc.employeeWorktype);
  }

  _buildEmpBranchDropdown() {
    return _buildDropDown(
        dropDownItems: city,
        hintText: AppConstants.branchName,
        selectedvalue: _employeeViewBloc.employeeBranch);
  }

  _buildAddEmployeebutton(BuildContext context) {
    return AppWidgetUtils.buildAddbutton(
      context,
      flex: 1,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return const CreateEmployeeDialog();
          },
        );
      },
      text: AppConstants.addEmployee,
    );
  }

  _buildEmployeeTableView(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          dividerThickness: 0.01,
          columns: [
            _buildEmployeeTableHeader(
              AppConstants.sno,
            ),
            _buildEmployeeTableHeader(
              AppConstants.empName,
            ),
            _buildEmployeeTableHeader(
              AppConstants.mobileNumber,
            ),
            _buildEmployeeTableHeader(
              AppConstants.city,
            ),
            _buildEmployeeTableHeader(
              AppConstants.workType,
            ),
            _buildEmployeeTableHeader(
              AppConstants.branchName,
            ),
            _buildEmployeeTableHeader(
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
                _buildTableRow(data, AppConstants.empName),
                _buildTableRow(data, AppConstants.mobileNumber),
                _buildTableRow(data, AppConstants.city),
                _buildTableRow(data, AppConstants.workType),
                _buildTableRow(data, AppConstants.branchName),
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

  _buildEmployeeTableHeader(
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
