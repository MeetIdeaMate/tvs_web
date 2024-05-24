import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tlbilling/components/custom_dropdown_button_form_field.dart';
import 'package:tlbilling/models/get_all_employee_model.dart';
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
    return StreamBuilder(
      stream: _employeeViewBloc.employeeTableStream,
      builder: (context, snapshot) {
        bool isTextEmpty =
            _employeeViewBloc.empNameAndMobNoFilterController.text.isEmpty;
        IconData iconPath = isTextEmpty ? Icons.search : Icons.close;
        Color iconColor =
            isTextEmpty ? _appColors.primaryColor : _appColors.red;

        return AppWidgetUtils.buildSearchField(AppConstants.empName,
            _employeeViewBloc.empNameAndMobNoFilterController, context,
            suffixIcon: IconButton(
              onPressed: () {
                if (iconPath == Icons.search) {
                  if (_employeeViewBloc
                      .empNameAndMobNoFilterController.text.isNotEmpty) {
                    _employeeViewBloc.employeeTableViewStream(true);
                    _employeeViewBloc.getEmployeesList();
                  }
                } else {
                  _employeeViewBloc.empNameAndMobNoFilterController.clear();
                  _employeeViewBloc.employeeTableViewStream(false);
                }
              },
              icon: Icon(
                iconPath,
                color: iconColor,
              ),
            ), onSubmit: (value) {
          if (value.isNotEmpty) {
            _employeeViewBloc.employeeTableViewStream(true);
            _employeeViewBloc.getEmployeesList();
          }
        });
      },
    );
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
      child: StreamBuilder<bool>(
          stream: _employeeViewBloc.employeeTableStream,
          builder: (context, snapshot) {
            return FutureBuilder(
              future: _employeeViewBloc.getEmployeesList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: AppWidgetUtils.buildLoading(),
                  );
                } else if (snapshot.hasData) {
                  List<EmployeeListModel>? userData =
                      snapshot.data?.result?.employeeListModel;
                  if (userData != null && userData.isNotEmpty) {
                    return Column(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: SingleChildScrollView(
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
                                rows: userData
                                    .asMap()
                                    .entries
                                    .map((entry) => DataRow(
                                          color: MaterialStateColor.resolveWith(
                                              (states) {
                                            if (entry.key % 2 == 0) {
                                              return Colors.white;
                                            } else {
                                              return _appColors
                                                  .transparentBlueColor;
                                            }
                                          }),
                                          cells: [
                                            _buildTableRow('${entry.key + 1}'),
                                            _buildTableRow(
                                                entry.value.employeeName),
                                            _buildTableRow(
                                                entry.value.mobileNumber),
                                            _buildTableRow(entry.value.city),
                                            _buildTableRow(
                                                entry.value.designation),
                                            _buildTableRow(
                                                entry.value.branchName),
                                            DataCell(
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  IconButton(
                                                    icon: SvgPicture.asset(
                                                        AppConstants.icEdit),
                                                    onPressed: () {},
                                                  ),
                                                  IconButton(
                                                      icon: SvgPicture.asset(
                                                          AppConstants
                                                              .icdelete),
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return DeleteDialog(
                                                              content:
                                                                  AppConstants
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
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }
                return Center(child: SvgPicture.asset(AppConstants.imgNoData));
              },
            );
          }),
    );
  }

  DataCell _buildTableRow(String? text) => DataCell(Text(
        text ?? '',
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
