import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tlbilling/components/custom_dropdown_button_form_field.dart';
import 'package:tlbilling/components/custom_pagenation.dart';
import 'package:tlbilling/models/get_model/get_all_branches_by_pagination.dart';
import 'package:tlbilling/utils/app_colors.dart';

//import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/action_dialog/delete_dialog.dart';
import 'package:tlbilling/view/branch/branch_details.dart';
import 'package:tlbilling/view/branch/branch_view_bloc.dart';
import 'package:tlbilling/view/branch/create_branch_dialog.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:toastification/toastification.dart';

class BranchView extends StatefulWidget {
  const BranchView({super.key});

  @override
  State<BranchView> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<BranchView> {
  final _branchViewBlocImpl = BranchViewBlocImpl();
  final _appColors = AppColors();
  List<String>? city = [
    'All',
    'kvp',
    'chennai',
  ];

  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
      inAsyncCall: _branchViewBlocImpl.isAsyncCall,
      color: _appColors.whiteColor,
      progressIndicator: AppWidgetUtils.buildLoading(),
      child: Scaffold(
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
      ),
    );
  }

  _buildsearchFiltersAndAddButton(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
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
        _branchViewBlocImpl.branchTablePageStream(0);
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
    return FutureBuilder(
      future: null,
      builder: (context, snapshot) {
        return TldsDropDownButtonFormField(
          width: MediaQuery.of(context).size.width * 0.1,
          height: 40,
          dropDownItems: city!,
          hintText: AppConstants.exSelect,
          onChange: (String? newValue) {
            _branchViewBlocImpl.selectedCity = newValue;
            _branchViewBlocImpl.branchTablePageStream(0);
          },
        );
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
                _searchFilters();
                _checkController(hintText);
              }
            : () {
                textController.clear();
                _searchFilters();
                _checkController(hintText);
              },
        icon: Icon(
          iconData,
          color: iconColor,
        ),
      ),
      onSubmit: (p0) {
        _searchFilters();
        _checkController(hintText);
      },
    );
  }

  void _searchFilters() {
    _branchViewBlocImpl.branchTablePageStream(0);
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
      child: StreamBuilder(
        stream: _branchViewBlocImpl.branchTablePageStreamController,
        initialData: _branchViewBlocImpl.currentPage,
        builder: (context, streamSnapshot) {
          int currentPage = streamSnapshot.data ?? 0;
          if (currentPage < 0) currentPage = 0;
          _branchViewBlocImpl.currentPage = currentPage;
          return FutureBuilder(
            future: _branchViewBlocImpl.getBranchList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: AppWidgetUtils.buildLoading());
              } else if (snapshot.hasError) {
                return const Center(
                    child: Text(AppConstants.somethingWentWrong));
              } else if (!snapshot.hasData) {
                return Center(child: SvgPicture.asset(AppConstants.imgNoData));
              }
              GetAllBranchesByPaginationModel? getAllBranchesByPaginationModel =
                  snapshot.data!;

              List<BranchDetail> userData = snapshot.data?.branchDetail ?? [];

              return Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: DataTable(
                          dividerThickness: 0.01,
                          columns: [
                            _buildBranchTableHeader(AppConstants.sno),
                            _buildBranchTableHeader(AppConstants.empName),
                            _buildBranchTableHeader(AppConstants.mobileNumber),
                            _buildBranchTableHeader(AppConstants.city),
                            _buildBranchTableHeader(AppConstants.pinCode),
                            _buildBranchTableHeader(AppConstants.subBranch),
                            _buildBranchTableHeader(AppConstants.action),
                          ],
                          rows: userData.asMap().entries.map((entry) {
                            return DataRow(
                              color: MaterialStateColor.resolveWith((states) {
                                return entry.key.isEven
                                    ? Colors.white
                                    : _appColors.transparentBlueColor;
                              }),
                              cells: [
                                _buildTableRow('${entry.key + 1}'),
                                _buildTableRow(entry.value.branchName ?? ''),
                                _buildTableRow(entry.value.mobileNo ?? ''),
                                _buildTableRow(entry.value.city ?? ''),
                                _buildTableRow(entry.value.pinCode ?? ''),
                                DataCell(
                                  IconButton(
                                    icon: SvgPicture.asset(
                                      AppConstants.icBranch,
                                      colorFilter: ColorFilter.mode(
                                          _appColors.green, BlendMode.srcIn),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return BranchDetails(
                                              subBranches:
                                                  entry.value.subBranches,
                                              mainBranchName:
                                                  entry.value.branchName);
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
                                        icon: SvgPicture.asset(
                                            AppConstants.icEdit),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                CreateBranchDialog(
                                                    branchId:
                                                        entry.value.branchId),
                                          ).then((value) => _branchViewBlocImpl
                                              .branchTablePageStream(0));
                                        },
                                      ),
                                      IconButton(
                                          icon: SvgPicture.asset(
                                              AppConstants.icdelete),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return _deleteDialog(entry);
                                              },
                                            );
                                          }),
                                    ],
                                  ),
                                )
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  CustomPagination(
                    itemsOnLastPage:
                        getAllBranchesByPaginationModel.totalElements ?? 0,
                    currentPage: currentPage,
                    totalPages: getAllBranchesByPaginationModel.totalPages ?? 0,
                    onPageChanged: (pageValue) {
                      _branchViewBlocImpl.branchTablePageStream(pageValue);
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

  DeleteDialog _deleteDialog(MapEntry<int, BranchDetail> entry) {
    return DeleteDialog(
      content: AppConstants.deleteMsg,
      onPressed: () {
        _isLoading(true);
        _branchViewBlocImpl.deleteBranch((statusCode) {
          if (statusCode == 200 || statusCode == 201) {
            Navigator.pop(context);
            AppWidgetUtils.buildToast(
                context,
                ToastificationType.success,
                AppConstants.branchDeleted,
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: _appColors.successColor,
                ),
                AppConstants.branchDeletedSuccessFully,
                _appColors.successLightColor);
            _isLoading(false);
          } else {
            AppWidgetUtils.buildToast(
                context,
                ToastificationType.error,
                AppConstants.branchDeleted,
                Icon(
                  Icons.error_outline_outlined,
                  color: _appColors.errorColor,
                ),
                AppConstants.somethingWentWrong,
                _appColors.errorLightColor);
            _isLoading(false);
          }
        }, entry.value.branchId ?? '');
      },
    );
  }

  _isLoading(bool state) {
    setState(() {
      _branchViewBlocImpl.isAsyncCall = state;
    });
  }
}
