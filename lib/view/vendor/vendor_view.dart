import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/vendor/create_vendor_dialog.dart';
import 'package:tlbilling/view/vendor/vendor_view_bloc.dart';

class VendorView extends StatefulWidget {
  const VendorView({super.key});

  @override
  State<VendorView> createState() => _VendorViewState();
}

class _VendorViewState extends State<VendorView> {
  List<Map<String, String>> rowData = [
    {
      AppConstants.sno: '1',
      AppConstants.customerName: 'MuthuLakshmi',
      AppConstants.mobileNumber: '1234567890',
      AppConstants.panNo: 'ABCD1234E',
      AppConstants.gstNo: 'ABCD1234E',
      AppConstants.city: 'Chennai',
    },
    {
      AppConstants.sno: '2',
      AppConstants.customerName: 'Lakshu',
      AppConstants.mobileNumber: '9876543210',
      AppConstants.panNo: 'WXYZ5678F',
      AppConstants.gstNo: 'ABCD1234E',
      AppConstants.city: 'kovilpatti',
    },
  ];
  final _appColors = AppColors();
  final _vendarViewBlocImpl = VendarViewBlocImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppWidgetUtils.buildHeaderText(AppConstants.vendor),
            AppWidgetUtils.buildSizedBox(custHeight: 28),

            _buildSearchFilterAddButton(context),
            // Center(
            //   child: Column(
            //     children: [
            //       SvgPicture.asset(AppConstants.imgNoData),
            //       _buildText(
            //           name: AppConstants.noDataStore,
            //           color: _appColors.greyColor,
            //           fontWeight: FontWeight.bold,
            //           fontSize: 15)
            //     ],
            //   ),
            // ),
            AppWidgetUtils.buildSizedBox(custHeight: 28),

            _buildVendorTableView(context)
          ],
        ),
      ),
    );
  }

  _buildSearchFilterAddButton(BuildContext context) {
    return Row(
      children: [
        AppWidgetUtils.buildSearchField(AppConstants.vendorName,
            _vendarViewBlocImpl.vendorNameSearchController, context),
        AppWidgetUtils.buildSearchField(AppConstants.mobileNumber,
            _vendarViewBlocImpl.vendorMobNoSearchController, context),
        AppWidgetUtils.buildSearchField(AppConstants.city,
            _vendarViewBlocImpl.vendorCitySearchController, context),
        const Spacer(),
        AppWidgetUtils.buildAddbutton(
          context,
          text: AppConstants.addVendor,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return const CreateVendorDialog();
              },
            );
          },
        )
      ],
    );
  }

  _buildVendorTableView(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          dividerThickness: 0.01,
          columns: [
            _buildVendorTableHeader(
              AppConstants.sno,
            ),
            _buildVendorTableHeader(
              AppConstants.vendorName,
            ),
            _buildVendorTableHeader(
              AppConstants.mobileNumber,
            ),
            _buildVendorTableHeader(
              AppConstants.panNo,
            ),
            _buildVendorTableHeader(
              AppConstants.gstNo,
            ),
            _buildVendorTableHeader(
              AppConstants.city,
            ),
            _buildVendorTableHeader(
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
                DataCell(Text(data[AppConstants.gstNo]!)),
                DataCell(Text(data[AppConstants.city]!)),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(AppConstants.icEdit),
                        onPressed: () {},
                      ),
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

  _buildVendorTableHeader(
    String headerValue,
  ) =>
      DataColumn(
        label: Text(
          headerValue,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
}
