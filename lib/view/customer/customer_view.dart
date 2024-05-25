import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/models/get_model/get_all_customers_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlbilling/view/customer/create_customer_dialog.dart';
import 'package:tlbilling/view/customer/customer_view_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';

class CustomerView extends StatefulWidget {
  const CustomerView({super.key});

  @override
  State<CustomerView> createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView> {
  List<Map<String, String>> rowData = [
    {
      AppConstants.sno: '1',
      AppConstants.customerName: 'MuthuLakshmi',
      AppConstants.mobileNumber: '1234567890',
      AppConstants.panNo: 'ABCD1234E',
      AppConstants.city: 'Chennai',
    },
    {
      AppConstants.sno: '2',
      AppConstants.customerName: 'Lakshu',
      AppConstants.mobileNumber: '9876543210',
      AppConstants.panNo: 'WXYZ5678F',
      AppConstants.city: 'kovilpatti',
    },
  ];

  final _appColors = AppColors();
  final _customerScreenBlocImpl = CustomerViewBlocImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppWidgetUtils.buildHeaderText(AppConstants.customer),

            AppWidgetUtils.buildSizedBox(custHeight: 28),
            _buildsearchAndAddButton(context),
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
            _buildDataTable(context)
          ],
        ),
      ),
    );
  }

  _buildsearchAndAddButton(BuildContext context) {
    return Row(
      children: [
        StreamBuilder(
          stream: _customerScreenBlocImpl.customerNameStreamController,
          builder: (context, snapshot) {
            return _buildFormField(
                _customerScreenBlocImpl.custNameFilterController,
                AppConstants.customerName);
          },
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 5),
        StreamBuilder(
          stream: _customerScreenBlocImpl.customerMobileNumberStreamController,
          builder: (context, snapshot) {
            return _buildFormField(
                _customerScreenBlocImpl.custMobileNoController,
                AppConstants.mobileNumber);
          },
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 5),
        StreamBuilder(
          stream: _customerScreenBlocImpl.customerCityStreamController,
          builder: (context, snapshot) {
            return _buildFormField(
                _customerScreenBlocImpl.custCityTextController,
                AppConstants.city);
          },
        ),
        const Spacer(),
        _buildAddCustomerBotton(context)
      ],
    );
  }

  Widget _buildFormField(
      TextEditingController textController, String hintText) {
    final bool isTextEmpty = textController.text.isEmpty;
    final IconData iconData = isTextEmpty ? Icons.search : Icons.close;
    final Color iconColor = isTextEmpty ? _appColors.primaryColor : Colors.red;
    return TldsInputFormField(
      width: MediaQuery.sizeOf(context).width * 0.18,
      height: 40,
      controller: textController,
      hintText: hintText,
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
      onSubmit: (p0) {
        _searchData();
        _checkController(hintText);
      },
    );
  }

  void _searchData() {
    _customerScreenBlocImpl.getAllCustomersByPagination();
    _customerScreenBlocImpl.customerTableStream(true);
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

  _buildAddCustomerBotton(BuildContext context) {
    return AppWidgetUtils.buildAddbutton(context, onPressed: () {
      showDialog(
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
        child: StreamBuilder(
          stream: _customerScreenBlocImpl.customerTableStreamController,
          builder: (context, snapshot) {
            return FutureBuilder(
              future: _customerScreenBlocImpl.getAllCustomersByPagination(),
              builder: (context, snapshot) {
                List<GetAllCustomersModel>? customerDetails =
                    snapshot.data?.getAllCustomersModel;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: AppWidgetUtils.buildLoading(),
                  );
                } else if (snapshot.hasData) {
                  if (customerDetails?.isEmpty ?? false) {
                    return Center(
                      child: SvgPicture.asset(AppConstants.imgNoData),
                    );
                  } else {
                    return DataTable(
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
                          AppConstants.panNo,
                        ),
                        _buildTableHeader(
                          AppConstants.city,
                        ),
                        _buildTableHeader(
                          AppConstants.action,
                        ),
                      ],
                      rows: customerDetails
                              ?.asMap()
                              .entries
                              .map((entry) => DataRow(
                                      color: MaterialStateProperty.resolveWith(
                                          (states) {
                                        if (entry.key % 2 == 0) {
                                          return _appColors.whiteColor;
                                        } else {
                                          return _appColors
                                              .transparentBlueColor;
                                        }
                                      }),
                                      cells: [
                                        DataCell(Text('${entry.key + 1}')),
                                        DataCell(Text(
                                            entry.value.customerName ?? '')),
                                        DataCell(
                                            Text(entry.value.mobileNo ?? '')),
                                        DataCell(
                                            Text(entry.value.accountNo ?? '')),
                                        DataCell(Text(entry.value.city ?? '')),
                                        DataCell(
                                          IconButton(
                                            icon: SvgPicture.asset(
                                                AppConstants.icEdit),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return CreateCustomerDialog(
                                                      customerId: entry
                                                          .value.customerId);
                                                },
                                              ).then((value) {
                                                if (entry.value.customerId !=
                                                    null) {
                                                  _customerScreenBlocImpl
                                                      .customerTableStream(
                                                          true);
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ]))
                              .toList() ??
                          [],
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
