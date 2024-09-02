import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tlbilling/api_service/service_locator.dart';
import 'package:tlbilling/components/custom_dropdown_button_form_field.dart';
import 'package:tlbilling/components/custom_pagenation.dart';
import 'package:tlbilling/models/get_model/get_all_account_head_by_pagination_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlbilling/view/account_head/account_head_view_bloc.dart';
import 'package:tlbilling/view/account_head/create_account_head.dart';

class AccountHeadView extends StatefulWidget {
  const AccountHeadView({super.key});

  @override
  State<AccountHeadView> createState() => _AccountHeadViewState();
}

class _AccountHeadViewState extends State<AccountHeadView> {
  final _appColors = AppColors();
  final _accountHeadViewImpl = getIt<AccountViewBlocImpl>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppWidgetUtils.buildHeaderText(AppConstants.accountHead),
            AppWidgetUtils.buildSizedBox(custHeight: 26),
            _buildSearchFilterAddButton(context),
            AppWidgetUtils.buildSizedBox(custHeight: 28),
            _buildAccountHeadTableView(context)
          ],
        ),
      ),
    );
  }

  _buildSearchFilterAddButton(BuildContext context) {
    return Row(
      children: [
        buildSearchField(
            hintText: AppConstants.accCode,
            inputFormatters: TlInputFormatters.onlyAllowAlphabetAndNumber,
            searchController: _accountHeadViewImpl.accCodeTextEditController,
            searchStream: _accountHeadViewImpl.accCodeTextEditStream,
            searchStreamController:
                _accountHeadViewImpl.accCodeTextEditStreamController),
        buildSearchField(
            hintText: AppConstants.name,
            inputFormatters: TlInputFormatters.onlyAllowAlphabets,
            searchController: _accountHeadViewImpl.nameTextEditController,
            searchStream: _accountHeadViewImpl.nameTextEditStream,
            searchStreamController:
                _accountHeadViewImpl.nameTextEditStreamController),
        _buildTypesFilter(),
        const Spacer(),
        const Spacer(),
        AppWidgetUtils.buildAddbutton(
          context,
          text: AppConstants.addNew,
          onPressed: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return const CreateAccountHead();
              },
            );
          },
        )
      ],
    );
  }

  StreamBuilder<bool> buildSearchField(
      {Stream<bool>? searchStream,
      TextEditingController? searchController,
      Function(bool)? searchStreamController,
      String? hintText,
      List<TextInputFormatter>? inputFormatters}) {
    return StreamBuilder(
      stream: searchStream,
      builder: (context, snapshot) {
        bool isTextEmpty = searchController!.text.isEmpty;
        IconData iconPath = isTextEmpty ? Icons.search : Icons.close;
        Color iconColor =
            isTextEmpty ? _appColors.primaryColor : _appColors.red;
        return AppWidgetUtils.buildSearchField(
          inputFormatters: inputFormatters,
          hintText,
          searchController,
          context,
          suffixIcon: IconButton(
            onPressed: () {
              if (iconPath == Icons.search) {
                if (searchController.text.isNotEmpty) {
                  searchStreamController!(true);
                  _accountHeadViewImpl.pageNumberUpdateStreamController(0);
                  _accountHeadViewImpl.getAccountHead();
                }
              } else {
                searchController.clear();
                searchStreamController!(false);
                _accountHeadViewImpl.pageNumberUpdateStreamController(0);
                _accountHeadViewImpl.getAccountHead();
              }
            },
            icon: Icon(
              iconPath,
              color: iconColor,
            ),
          ),
          onSubmit: (value) {
            if (value.isNotEmpty) {
              searchStreamController!(true);
              _accountHeadViewImpl.pageNumberUpdateStreamController(0);
              _accountHeadViewImpl.getAccountHead();
            }
          },
        );
      },
    );
  }

  _buildTypesFilter() {
    return FutureBuilder<List<String>>(
      future: _accountHeadViewImpl.getConfigByIdModel(
          configId: AppConstants.accountType),
      builder: (context, snapshot) {
        List<String> designationList = snapshot.data ?? [];
        designationList.insert(0, AppConstants.alltype);
        return CustomDropDownButtonFormField(
          width: MediaQuery.sizeOf(context).width * 0.15,
          height: 40,
          dropDownValue: _accountHeadViewImpl.selectedType,
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
            _accountHeadViewImpl.selectedType = newValue;
            _accountHeadViewImpl.pageNumberUpdateStreamController(0);
          },
        );
      },
    );
  }

  _buildAccountHeadTableView(BuildContext context) {
    return Expanded(
      child: StreamBuilder<int>(
          stream: _accountHeadViewImpl.pageNumberStream,
          initialData: _accountHeadViewImpl.currentPage,
          builder: (context, streamSnapshot) {
            int currentPage = streamSnapshot.data ?? 0;
            if (currentPage < 0) currentPage = 0;
            _accountHeadViewImpl.currentPage = currentPage;

            return FutureBuilder<GetAllAccountHeadPagination?>(
              future: _accountHeadViewImpl.getAccountHead(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: AppWidgetUtils.buildLoading());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text(AppConstants.somethingWentWrong));
                }
                if (!snapshot.hasData ||
                    snapshot.data?.content?.isEmpty == true) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(child: SvgPicture.asset(AppConstants.imgNoData)),
                      AppWidgetUtils.buildSizedBox(custHeight: 8),
                      Center(
                        child: Text(
                          AppConstants.noVendorDataAvailable,
                          style: TextStyle(color: _appColors.grey),
                        ),
                      ),
                    ],
                  );
                }
                GetAllAccountHeadPagination vendorListModel = snapshot.data!;
                List<GetAllAccount> vendorData = snapshot.data?.content ?? [];
                return Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: DataTable(
                            dividerThickness: 0.01,
                            columns: [
                              AppWidgetUtils.buildTableHeader(
                                AppConstants.sno,
                              ),
                              AppWidgetUtils.buildTableHeader(
                                AppConstants.code,
                              ),
                              AppWidgetUtils.buildTableHeader(
                                AppConstants.name,
                              ),
                              AppWidgetUtils.buildTableHeader(
                                AppConstants.type,
                              ),
                              AppWidgetUtils.buildTableHeader(
                                AppConstants.pricingFormat,
                              ),
                              AppWidgetUtils.buildTableHeader(
                                AppConstants.form,
                              ),
                              AppWidgetUtils.buildTableHeader(
                                AppConstants.action,
                              ),
                            ],
                            rows: vendorData.asMap().entries.map((entry) {
                              return DataRow(
                                color: WidgetStateColor.resolveWith((states) {
                                  return entry.key % 2 == 0
                                      ? Colors.white
                                      : _appColors.transparentBlueColor;
                                }),
                                cells: [
                                  DataCell(Text('${entry.key + 1}')),
                                  DataCell(
                                      Text(entry.value.accountHeadCode ?? '')),
                                  DataCell(
                                      Text(entry.value.accountHeadName ?? '')),
                                  DataCell(Text(entry.value.accountType ?? '')),
                                  DataCell(
                                      Text(entry.value.pricingFormat ?? '')),
                                  DataCell(
                                      Text(entry.value.transferFrom ?? '')),
                                  DataCell(
                                    PopupMenuButton(
                                      itemBuilder: (context) {
                                        return [
                                          const PopupMenuItem(
                                            value: 'cancel',
                                            child: Text('Cancel'),
                                          ),
                                          const PopupMenuItem(
                                            value: 'Edit',
                                            child: Text('Edit'),
                                          ),
                                        ];
                                      },
                                      onSelected: (value) {
                                        if (value == 'cancel') {
                                        } else if (value == 'Edit') {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return CreateAccountHead(
                                                accountCode:
                                                    entry.value.accountHeadCode,
                                                accountId: entry.value.id,
                                              );
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }).toList()),
                      ),
                    ),
                    CustomPagination(
                      itemsOnLastPage: vendorListModel.totalElements ?? 0,
                      currentPage: currentPage,
                      totalPages: vendorListModel.totalPages ?? 0,
                      onPageChanged: (pageValue) {
                        _accountHeadViewImpl
                            .pageNumberUpdateStreamController(pageValue);
                      },
                    ),
                  ],
                );
              },
            );
          }),
    );
  }
}
