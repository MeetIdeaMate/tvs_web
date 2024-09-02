import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlbilling/api_service/service_locator.dart';
import 'package:tlbilling/components/custom_pagenation.dart';
import 'package:tlbilling/models/get_model/get_all_customer_by_pagination_model.dart';
import 'package:tlbilling/models/get_model/get_all_customers_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlbilling/view/customer/create_customer_dialog.dart';
import 'package:tlbilling/view/customer/customer_view_bloc.dart';
import 'package:tlbilling/view/useraccess/access_level_shared_pref.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_formaters.dart';

class CustomerView extends StatefulWidget {
  const CustomerView({super.key});

  @override
  State<CustomerView> createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView> {
  final _appColors = AppColors();
  final _customerScreenBlocImpl = getIt<CustomerViewBlocImpl>();

  @override
  void initState() {
    getBranchName();
    super.initState();
  }

  Future<void> getBranchName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _customerScreenBlocImpl.branchName = AppConstants.allBranch;
      _customerScreenBlocImpl.isMainBranch = prefs.getBool('mainBranch');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppWidgetUtils.buildHeaderText(AppConstants.customer),
            AppWidgetUtils.buildSizedBox(custHeight: 26),
            _buildsearchAndAddButton(context),
            AppWidgetUtils.buildSizedBox(custHeight: 28),
            if (AccessLevel.canView(AppConstants.customer))
              _buildDataTable(context)
          ],
        ),
      ),
    );
  }

  _buildsearchAndAddButton(BuildContext context) {
    return Row(
      children: [
        if (AccessLevel.canView(AppConstants.customer)) ...[
          StreamBuilder(
            stream: _customerScreenBlocImpl.customerNameStreamController,
            builder: (context, snapshot) {
              return _buildFormField(
                  inputFormatters: TldsInputFormatters.allowAlphabetsAndSpaces,
                  _customerScreenBlocImpl.customerNameFilterController,
                  AppConstants.customerName);
            },
          ),
          AppWidgetUtils.buildSizedBox(custWidth: 5),
          StreamBuilder(
            stream:
                _customerScreenBlocImpl.customerMobileNumberStreamController,
            builder: (context, snapshot) {
              return _buildFormField(
                _customerScreenBlocImpl.customerMobileNoController,
                AppConstants.mobileNumber,
                inputFormatters: TlInputFormatters.onlyAllowNumbers,
              );
            },
          ),
          AppWidgetUtils.buildSizedBox(custWidth: 5),
          StreamBuilder(
            stream: _customerScreenBlocImpl.customerCityStreamController,
            builder: (context, snapshot) {
              return _buildFormField(
                  inputFormatters: TldsInputFormatters.allowAlphabetsAndSpaces,
                  _customerScreenBlocImpl.customerCityTextController,
                  AppConstants.city);
            },
          ),
          AppWidgetUtils.buildSizedBox(custWidth: 20),
          if (_customerScreenBlocImpl.isMainBranch == false) const Spacer(),
        ],
        if (AccessLevel.canAdd(AppConstants.customer))
          _buildAddCustomerButton(context)
      ],
    );
  }

  _buildBranchDropdown() {
    return FutureBuilder(
        future: _customerScreenBlocImpl.getBranchName(),
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
            selectedvalue: _customerScreenBlocImpl.branchName,
            onChange: (value) {
              _customerScreenBlocImpl.branchName = value;

              _customerScreenBlocImpl.pageNumberUpdateStreamController(0);
            },
          );
        });
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

  Widget _buildFormField(TextEditingController textController, String hintText,
      {List<TextInputFormatter>? inputFormatters}) {
    final bool isTextEmpty = textController.text.isEmpty;
    final IconData iconData = isTextEmpty ? Icons.search : Icons.close;
    final Color iconColor = isTextEmpty ? _appColors.primaryColor : Colors.red;
    return TldsInputFormField(
      inputFormatters: inputFormatters,
      width: MediaQuery.sizeOf(context).width * 0.18,
      height: 40,
      controller: textController,
      hintText: hintText,
      isSearch: true,
      suffixIcon: IconButton(
        onPressed: iconData == Icons.search
            ? () {
                _searchData();
                _checkController(hintText);
              }
            : () {
                textController.clear();
                _searchData();
                _checkController(hintText);
              },
        icon: Icon(
          iconData,
          color: iconColor,
        ),
      ),
      onSubmit: (value) {
        if (value.isNotEmpty) {
          _searchData();
          _checkController(hintText);
        }
      },
    );
  }

  void _searchData() {
    _customerScreenBlocImpl.getAllCustomersByPagination();
    _customerScreenBlocImpl.customerTableStream(true);
    _customerScreenBlocImpl.pageNumberUpdateStreamController(0);
  }

  void _checkController(String hintText) {
    if (hintText == AppConstants.city) {
      _customerScreenBlocImpl.customerCityStream(true);
    } else if (hintText == AppConstants.mobileNumber) {
      _customerScreenBlocImpl.customerMobileNumberStream(true);
    } else if (hintText == AppConstants.customerName) {
      _customerScreenBlocImpl.customerNameStream(true);
    }
  }

  _buildAddCustomerButton(BuildContext context) {
    return AppWidgetUtils.buildAddbutton(context, onPressed: () {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const CreateCustomerDialog();
        },
      );
    }, text: AppConstants.addCustomer, flex: 2);
  }

  _buildDataTable(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<int>(
          stream: _customerScreenBlocImpl.pageNumberStream,
          builder: (context, streamSnapshot) {
            int currentPage = streamSnapshot.data ?? 0;
            if (currentPage < 0) currentPage = 0;
            _customerScreenBlocImpl.currentPage = currentPage;
            return FutureBuilder(
              future: _customerScreenBlocImpl.getAllCustomersByPagination(),
              builder: (context, snapshot) {
                GetAllCustomersByPaginationModel? customerList = snapshot.data;
                List<GetAllCustomersModel>? customerDetails =
                    snapshot.data?.getAllCustomersModel;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: AppWidgetUtils.buildLoading(),
                  );
                } else if (snapshot.hasData) {
                  if (!snapshot.hasData ||
                      snapshot.data?.getAllCustomersModel?.isEmpty == true) {
                    return Center(
                      child: SvgPicture.asset(AppConstants.imgNoData),
                    );
                  } else {
                    return Column(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: SingleChildScrollView(
                              child: DataTable(
                                dividerThickness: 0.01,
                                columns: [
                                  _buildTableHeader(
                                    AppConstants.sno,
                                  ),
                                  _buildTableHeader(
                                    AppConstants.customerName,
                                  ),
                                  _buildTableHeader(
                                    AppConstants.mobileNumber,
                                  ),
                                  _buildTableHeader(
                                    AppConstants.city,
                                  ),
                                  if (AccessLevel.canPUpdate(
                                      AppConstants.customer))
                                    _buildTableHeader(
                                      AppConstants.action,
                                    ),
                                ],
                                rows: customerDetails
                                        ?.asMap()
                                        .entries
                                        .map((entry) => DataRow(
                                                color: WidgetStateProperty
                                                    .resolveWith((states) {
                                                  if (entry.key % 2 == 0) {
                                                    return _appColors
                                                        .whiteColor;
                                                  } else {
                                                    return _appColors
                                                        .transparentBlueColor;
                                                  }
                                                }),
                                                cells: [
                                                  DataCell(
                                                      Text('${entry.key + 1}')),
                                                  DataCell(Text(entry
                                                          .value.customerName ??
                                                      '')),
                                                  DataCell(Text(
                                                      entry.value.mobileNo ??
                                                          '')),
                                                  DataCell(Text(
                                                      entry.value.city ?? '')),
                                                  if (AccessLevel.canPUpdate(
                                                      AppConstants.customer))
                                                    DataCell(
                                                      IconButton(
                                                        icon: SvgPicture.asset(
                                                            AppConstants
                                                                .icEdit),
                                                        onPressed: () {
                                                          showDialog(
                                                            barrierDismissible:
                                                                false,
                                                            context: context,
                                                            builder: (context) {
                                                              return CreateCustomerDialog(
                                                                  customerId: entry
                                                                      .value
                                                                      .customerId);
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                ]))
                                        .toList() ??
                                    [],
                              ),
                            ),
                          ),
                        ),
                        CustomPagination(
                          itemsOnLastPage: customerList?.totalElements ?? 0,
                          currentPage: currentPage,
                          totalPages: customerList?.totalPages ?? 0,
                          onPageChanged: (pageValue) {
                            _customerScreenBlocImpl
                                .pageNumberUpdateStreamController(pageValue);
                          },
                        ),
                      ],
                    );
                  }
                } else {
                  return Center(
                    child: SvgPicture.asset(AppConstants.imgNoData),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  DataColumn _buildTableHeader(String headerValue) => DataColumn(
        label: Text(
          headerValue,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
}
