import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlbilling/components/custom_pagenation.dart';
import 'package:tlbilling/models/get_model/get_all_employee_by_pagination.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/employee/create_employee_dialog.dart';
import 'package:tlbilling/view/employee/employee_view_bloc.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';

class EmployeeView extends StatefulWidget {
  const EmployeeView({super.key});

  @override
  State<EmployeeView> createState() => _EmployeeViewState();
}

class _EmployeeViewState extends State<EmployeeView> {
  final _employeeViewBloc = EmployeeViewBlocImpl();
  final _appColors = AppColors();
  final List<String>? city = ['kvp', 'chennai'];

  Future<void> getBranchName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _employeeViewBloc.isMainBranch = prefs.getBool('mainBranch');
      if (_employeeViewBloc.isMainBranch ?? false) {
        _employeeViewBloc.employeeBranch = AppConstants.allBranch;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getBranchName();
    _employeeViewBloc.employeeWorktype = AppConstants.allWorkType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppWidgetUtils.buildHeaderText(AppConstants.employee),
            AppWidgetUtils.buildSizedBox(custHeight: 26),
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
        _buildEmpNameSearchFilter(),
        // _buildEmpCityDropdown(),
        _buildEmpWorkTypeDropdown(),
        if (_employeeViewBloc.isMainBranch ?? false) _buildEmpBranchDropdown(),
        const Spacer(),
        _buildAddEmployeebutton(context)
      ],
    );
  }

  _buildEmpNameSearchFilter() {
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
                    _employeeViewBloc.pageNumberUpdateStreamController(0);
                  }
                } else {
                  _employeeViewBloc.empNameAndMobNoFilterController.clear();
                  _employeeViewBloc.employeeTableViewStream(false);
                  _employeeViewBloc.pageNumberUpdateStreamController(0);
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
            _employeeViewBloc.pageNumberUpdateStreamController(0);
          }
        });
      },
    );
  }

  _buildDropDown(
      {List<String>? dropDownItems,
      String? hintText,
      String? selectedvalue,
      Function(String?)? onChange}) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: TldsDropDownButtonFormField(
        width: MediaQuery.of(context).size.width * 0.1,
        height: 40,
        dropDownItems: dropDownItems!,
        dropDownValue: selectedvalue,
        hintText: hintText,
        onChange: onChange ??
            (String? newValue) {
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
    return FutureBuilder<List<String>>(
      future: _employeeViewBloc.getConfigByIdModel(
          configId: AppConstants.designation),
      builder: (context, snapshot) {
        List<String> designationList = snapshot.data ?? [];
        designationList.insert(0, AppConstants.allWorkType);
        return _buildDropDown(
          dropDownItems:
              (snapshot.hasData && (snapshot.data?.isNotEmpty == true))
                  ? designationList
                  : List.empty(),
          hintText: (snapshot.connectionState == ConnectionState.waiting)
              ? AppConstants.loading
              : (snapshot.hasError || snapshot.data == null)
                  ? AppConstants.errorLoading
                  : AppConstants.exSelect,
          selectedvalue: _employeeViewBloc.employeeWorktype,
          onChange: (value) {
            _employeeViewBloc.employeeWorktype = value;
            _employeeViewBloc.employeeTableViewStream(true);
            _employeeViewBloc.pageNumberUpdateStreamController(0);
            _employeeViewBloc.getEmployeesList();
          },
        );
      },
    );
  }

  _buildEmpBranchDropdown() {
    return FutureBuilder(
        future: _employeeViewBloc.getBranchName(),
        builder: (context, snapshot) {
          List<String>? branchNameList = snapshot.data?.result?.getAllBranchList
              ?.map((e) => e.branchName)
              .where((branchName) => branchName != null)
              .cast<String>()
              .toList();
          branchNameList?.insert(0, AppConstants.allBranch);
          return _buildDropDown(
            dropDownItems: (snapshot.hasData &&
                    (snapshot.data?.result?.getAllBranchList?.isNotEmpty ==
                        true))
                ? branchNameList
                : List.empty(),
            hintText: (snapshot.connectionState == ConnectionState.waiting)
                ? AppConstants.loading
                : (snapshot.hasError || snapshot.data == null)
                    ? AppConstants.errorLoading
                    : AppConstants.branchName,
            selectedvalue: _employeeViewBloc.employeeBranch,
            onChange: (value) {
              _employeeViewBloc.employeeBranch = value;
              _employeeViewBloc.employeeTableViewStream(true);
              _employeeViewBloc.getEmployeesList();
              _employeeViewBloc.pageNumberUpdateStreamController(0);
            },
          );
        });
  }

  _buildAddEmployeebutton(BuildContext context) {
    return AppWidgetUtils.buildAddbutton(
      context,
      flex: 1,
      onPressed: () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return CreateEmployeeDialog(employeeViewBloc: _employeeViewBloc);
          },
        );
      },
      text: AppConstants.addEmployee,
    );
  }

  _buildEmployeeTableView(BuildContext context) {
    return Expanded(
      child: StreamBuilder<int>(
        stream: _employeeViewBloc.pageNumberStream,
        initialData: _employeeViewBloc.currentPage,
        builder: (context, streamSnapshot) {
          int currentPage = streamSnapshot.data ?? 0;
          if (currentPage < 0) currentPage = 0;
          _employeeViewBloc.currentPage = currentPage;
          return FutureBuilder<GetAllEmployeesByPaginationModel>(
            future: _employeeViewBloc.getEmployeesList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: AppWidgetUtils.buildLoading());
              } else if (!snapshot.hasData ||
                  snapshot.data?.content?.isEmpty == true) {
                return Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AppConstants.imgNoData),
                        AppWidgetUtils.buildSizedBox(custHeight: 8),
                        Text(
                          AppConstants.noDataAvailable,
                          style: TextStyle(color: _appColors.grey),
                        )
                      ],
                    ),
                  ),
                );
              }
              GetAllEmployeesByPaginationModel employeeListmodel =
                  snapshot.data!;
              List<Content> userData = snapshot.data?.content ?? [];
              return Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: DataTable(
                          dividerThickness: 0.01,
                          columns: [
                            _buildEmployeeTableHeader(AppConstants.sno),
                            _buildEmployeeTableHeader(AppConstants.empName),
                            _buildEmployeeTableHeader(
                                AppConstants.mobileNumber),
                            _buildEmployeeTableHeader(AppConstants.city),
                            _buildEmployeeTableHeader(AppConstants.workType),
                            _buildEmployeeTableHeader(AppConstants.branchName),
                            _buildEmployeeTableHeader(AppConstants.action),
                          ],
                          rows: userData.asMap().entries.map((entry) {
                            return DataRow(
                              color: MaterialStateColor.resolveWith((states) {
                                return entry.key % 2 == 0
                                    ? Colors.white
                                    : _appColors.transparentBlueColor;
                              }),
                              cells: [
                                _buildTableRow('${entry.key + 1}'),
                                _buildTableRow(entry.value.employeeName),
                                _buildTableRow(entry.value.mobileNumber),
                                _buildTableRow(entry.value.city),
                                _buildTableRow(entry.value.designation),
                                _buildTableRow(entry.value.branchName),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: SvgPicture.asset(
                                            AppConstants.icEdit),
                                        onPressed: () {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return CreateEmployeeDialog(
                                                  employeeViewBloc:
                                                      _employeeViewBloc,
                                                  employeeId:
                                                      entry.value.employeeId ??
                                                          '');
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  CustomPagination(
                    itemsOnLastPage: employeeListmodel.totalElements ?? 0,
                    currentPage: currentPage,
                    totalPages: employeeListmodel.totalPages ?? 0,
                    onPageChanged: (pageValue) {
                      _employeeViewBloc
                          .pageNumberUpdateStreamController(pageValue);
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  DataCell _buildTableRow(String? text) => DataCell(Text(
        text ?? '',
        style: const TextStyle(fontSize: 14),
      ));

  _buildEmployeeTableHeader(String headerValue) {
    return DataColumn(
      label: Text(
        headerValue,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
