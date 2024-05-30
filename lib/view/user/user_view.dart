import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/components/custom_dropdown_button_form_field.dart';
import 'package:tlbilling/components/custom_form_field.dart';
import 'package:tlbilling/components/custom_pagenation.dart';
import 'package:tlbilling/models/user_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/user/create_user_dialog.dart';
import 'package:tlbilling/view/user/user_active_inactive_dialog.dart';
import 'package:tlbilling/view/user/user_view_bloc.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  final _appColors = AppColors();
  final _userViewBlocImpl = UserViewBlocImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppWidgetUtils.buildHeaderText(AppConstants.user),
            AppWidgetUtils.buildSizedBox(custHeight: 28),
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
        const Spacer(),
        const Spacer(),
        AppWidgetUtils.buildAddbutton(
          flex: 1,
          context,
          onPressed: () {
            showDialog(
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

  _buildDesignationFilter() {
    return FutureBuilder<List<String>>(
      future: _userViewBlocImpl.getConfigByIdModel(
          configId: AppConstants.designation),
      builder: (context, snapshot) {
        List<String> designationList = snapshot.data ?? [];
        designationList.insert(0, AppConstants.all);

        return CustomDropDownButtonFormField(
          width: MediaQuery.sizeOf(context).width * 0.15,
          height: 40,
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
            return CustomFormField(
              hintText: AppConstants.userName,
              controller: _userViewBlocImpl.searchUserNameAndMobNoController,
              height: 40,
              width: MediaQuery.of(context).size.width * 0.19,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-z A-Z 0-9]")),
              ],
              hintColor: AppColors().hintColor,
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
                    //  _userViewBlocImpl.pageNumberUpdateStreamController(0);
                  }
                },
                icon: Icon(
                  iconPath,
                  color: iconColor,
                ),
              ),
              onSubmit: (value) {
                if (value.isNotEmpty) {
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
                                            DataCell(
                                              _buildUserActiveInActiveSwitch(
                                                  entry),
                                              // Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment.start,
                                              //   children: [
                                              //     IconButton(
                                              //       icon: SvgPicture.asset(
                                              //           AppConstants.icEdit),
                                              //       onPressed: () {},
                                              //     ),
                                              //     IconButton(
                                              //         icon: SvgPicture.asset(
                                              //             AppConstants
                                              //                 .icdelete),
                                              //         onPressed: () {
                                              //           showDialog(
                                              //             context: context,
                                              //             builder: (context) {
                                              //               return DeleteDialog(
                                              //                 content:
                                              //                     AppConstants
                                              //                         .deleteMsg,
                                              //                 onPressed: () {},
                                              //               );
                                              //             },
                                              //           );
                                              //         }),
                                              //   ],
                                              // ),
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
          context: context,
          builder: (context) {
            return UserActiveInActiveDialog(
              userStatus: entry.value.userStatus,
              userId: entry.value.userId,
            );
          },
        ).then((value) {
          _userViewBlocImpl.getUserList();
          _userViewBlocImpl.usersListStream(true);
        });
      },
    );
  }
}
