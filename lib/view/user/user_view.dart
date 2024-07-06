import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlbilling/components/custom_dropdown_button_form_field.dart';
import 'package:tlbilling/components/custom_pagenation.dart';
import 'package:tlbilling/models/user_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/user/create_user_dialog.dart';
import 'package:tlbilling/view/user/user_active_inactive_dialog.dart';
import 'package:tlbilling/view/user/user_view_bloc.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:tlds_flutter/export.dart' as tlds;

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  final _appColors = AppColors();
  final _userViewBlocImpl = UserViewBlocImpl();
  Future<void> getBranchName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userViewBlocImpl.branchName = prefs.getString('branchName') ?? '';
      _userViewBlocImpl.isMainBranch = prefs.getBool('mainBranch');
      if (_userViewBlocImpl.isMainBranch ?? false) {
        _userViewBlocImpl.branchId = AppConstants.allBranch;
      }
    });
  }

  @override
  void initState() {
    getBranchName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppWidgetUtils.buildHeaderText(AppConstants.user),
            AppWidgetUtils.buildSizedBox(custHeight: 26),
            _buildsearchFiltersAndAddButton(context),
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
        AppWidgetUtils.buildSizedBox(custWidth: 5),
        if (_userViewBlocImpl.isMainBranch ?? false) _buildBranchDropdown(),
        if (_userViewBlocImpl.isMainBranch == false) const Spacer(),
        const Spacer(),
        AppWidgetUtils.buildAddbutton(
          flex: 1,
          context,
          onPressed: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return CreateUserDialog(userViewBloc: _userViewBlocImpl);
              },
            );
          },
          text: AppConstants.addUser,
        )
      ],
    );
  }

  _buildBranchDropdown() {
    return FutureBuilder(
      future: _userViewBlocImpl.getBranchName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text(AppConstants.loading));
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data?.result?.getAllBranchList == null) {
          return const Text(AppConstants.loading);
        } else {
          final branchMap = {
            for (var branch in snapshot.data!.result!.getAllBranchList!)
              if (branch.branchName != null) branch.branchName!: branch.branchId
          };
          final branchNameList = branchMap.keys.toList();
          branchNameList.insert(0, AppConstants.allBranch);
          return _buildDropDown(
            dropDownItems:
                (branchNameList.isNotEmpty) ? branchNameList : List.empty(),
            hintText: AppConstants.branchName,
            selectedvalue: _userViewBlocImpl.branchId,
            onChange: (value) {
              _userViewBlocImpl.branchId = branchMap[value];
              _userViewBlocImpl.branchName = value;
              _userViewBlocImpl.pageNumberUpdateStreamController(0);
            },
          );
        }
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
        width: MediaQuery.sizeOf(context).width * 0.15,
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

  _buildDesignationFilter() {
    return FutureBuilder<List<String>>(
      future: _userViewBlocImpl.getConfigByIdModel(
          configId: AppConstants.designation),
      builder: (context, snapshot) {
        List<String> designationList = snapshot.data ?? [];
        designationList.insert(0, AppConstants.allDesignation);
        return CustomDropDownButtonFormField(
          width: MediaQuery.sizeOf(context).width * 0.15,
          height: 40,
          dropDownValue: AppConstants.allDesignation,
          dropDownItems:
              (snapshot.hasData && (snapshot.data?.isNotEmpty == true))
                  ? designationList
                  : List.empty(),
          hintText: (snapshot.connectionState == ConnectionState.waiting)
              ? AppConstants.loading
              : (snapshot.hasError || snapshot.data == null)
                  ? AppConstants.errorLoading
                  : AppConstants.exSelect,
          onChange: (String? newValue) {
            _userViewBlocImpl.selectedDestination = newValue;
            _userViewBlocImpl.usersListStream(true);
            _userViewBlocImpl.pageNumberUpdateStreamController(0);
            _userViewBlocImpl.getUserList();
          },
        );
      },
    );
  }

  _buildUserNameAndMobNoFilter() {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: StreamBuilder<bool>(
          stream: _userViewBlocImpl.userListStream,
          builder: (context, snapshot) {
            bool isTextEmpty =
                _userViewBlocImpl.searchUserNameAndMobNoController.text.isEmpty;
            IconData iconPath = isTextEmpty ? Icons.search : Icons.close;
            Color iconColor =
                isTextEmpty ? _appColors.primaryColor : _appColors.red;
            return TldsInputFormField(
              hintText: AppConstants.userName,
              controller: _userViewBlocImpl.searchUserNameAndMobNoController,
              height: 40,
              isSearch: true,
              width: MediaQuery.of(context).size.width * 0.19,
              inputFormatters: tlds.TldsInputFormatters.allowAlphabetsAndSpaces,
              suffixIcon: IconButton(
                onPressed: () {
                  if (iconPath == Icons.search) {
                    if (_userViewBlocImpl
                        .searchUserNameAndMobNoController.text.isNotEmpty) {
                      _userViewBlocImpl.usersListStream(true);
                      _userViewBlocImpl.pageNumberUpdateStreamController(0);
                      _userViewBlocImpl.getUserList();
                    }
                  } else {
                    _userViewBlocImpl.searchUserNameAndMobNoController.clear();
                    _userViewBlocImpl.usersListStream(false);
                    _userViewBlocImpl.pageNumberUpdateStreamController(0);
                  }
                },
                icon: Icon(
                  iconPath,
                  color: iconColor,
                ),
              ),
              onSubmit: (value) {
                if (value.isNotEmpty) {
                  _userViewBlocImpl.pageNumberUpdateStreamController(0);
                  _userViewBlocImpl.usersListStream(true);
                  _userViewBlocImpl.getUserList();
                }
              },
            );
          }),
    );
  }

  _buildUserTableView(BuildContext context) {
    return Expanded(
      child: StreamBuilder<int>(
          stream: _userViewBlocImpl.pageNumberStream,
          builder: (context, streamSnapshot) {
            int currentPage = streamSnapshot.data ?? 0;
            if (currentPage < 0) currentPage = 0;
            _userViewBlocImpl.currentPage = currentPage;
            return FutureBuilder(
              future: _userViewBlocImpl.getUserList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: AppWidgetUtils.buildLoading(),
                  );
                } else if (snapshot.hasData) {
                  UsersListModel userList = snapshot.data!;
                  List<UserDetailsList>? userData = snapshot.data?.content;
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
                                  if (_userViewBlocImpl.isMainBranch ?? false)
                                    _builduserTableHeader(
                                      AppConstants.branchName,
                                    ),
                                  _builduserTableHeader(
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
                                                entry.value.userName),
                                            _buildTableRow(
                                                entry.value.mobileNumber),
                                            _buildTableRow(
                                                entry.value.designation),
                                            if (_userViewBlocImpl
                                                    .isMainBranch ??
                                                false)
                                              _buildTableRow(
                                                  entry.value.branchName),
                                            DataCell(
                                              _buildUserActiveInActiveSwitch(
                                                  entry),
                                            ),
                                          ],
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                        CustomPagination(
                          itemsOnLastPage: userList.totalElements ?? 0,
                          currentPage: currentPage,
                          totalPages: userList.totalPages ?? 0,
                          onPageChanged: (pageValue) {
                            _userViewBlocImpl
                                .pageNumberUpdateStreamController(pageValue);
                          },
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
        overflow: TextOverflow.ellipsis,
        text ?? '',
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

  Widget _buildUserActiveInActiveSwitch(MapEntry<int, UserDetailsList> entry) {
    return Switch(
      value: entry.value.userStatus == 'ACTIVE' ? true : false,
      onChanged: (value) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return UserActiveInActiveDialog(
              userViewBlocImpl: _userViewBlocImpl,
              userStatus: entry.value.userStatus,
              userId: entry.value.userId,
            );
          },
        );
      },
    );
  }
}
