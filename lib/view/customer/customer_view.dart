import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/customer/create_customer_dialog.dart';

import 'package:tlbilling/view/customer/customer_view_bloc.dart';

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
        AppWidgetUtils.buildSearchField(AppConstants.customerName,
            _customerScreenBlocImpl.custNameFilterController, context),
        AppWidgetUtils.buildSearchField(AppConstants.mobileNumber,
            _customerScreenBlocImpl.custMobileNoController, context),
        AppWidgetUtils.buildSearchField(AppConstants.city,
            _customerScreenBlocImpl.custCityTextController, context),
        const Spacer(),
        _buildAddCustomerBotton(context)
      ],
    );
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
              AppConstants.panNo,
            ),
            _buildTableHeader(
              AppConstants.city,
            ),
            _buildTableHeader(
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
                DataCell(Text(data[AppConstants.sno]!)),
                DataCell(Text(data[AppConstants.customerName]!)),
                DataCell(Text(data[AppConstants.mobileNumber]!)),
                DataCell(Text(data[AppConstants.panNo]!)),
                DataCell(Text(data[AppConstants.city]!)),
                DataCell(
                  IconButton(
                    icon: SvgPicture.asset(AppConstants.icEdit),
                    onPressed: () {},
                  ),
                ),
              ],
            );
          }),
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
