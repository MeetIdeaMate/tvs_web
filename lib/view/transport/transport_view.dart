import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';

import 'package:tlbilling/view/transport/create_transport_dialog.dart';

import 'package:tlbilling/view/transport/transport_view_bloc.dart';

class TransportView extends StatefulWidget {
  const TransportView({super.key});

  @override
  State<TransportView> createState() => _TransportViewState();
}

class _TransportViewState extends State<TransportView> {
  List<Map<String, String>> rowData = [
    {
      AppConstants.sno: '1',
      AppConstants.transportName: 'MuthuLakshmi',
      AppConstants.mobileNumber: '1234567890',
      AppConstants.city: 'Chennai',
    },
    {
      AppConstants.sno: '2',
      AppConstants.transportName: 'Lakshu',
      AppConstants.mobileNumber: '9876543210',
      AppConstants.city: 'kovilpatti',
    },
  ];

  final _appColors = AppColors();
  final _transportBlocImpl = TransportBlocImpl();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppWidgetUtils.buildHeaderText(AppConstants.transport),
            AppWidgetUtils.buildSizedBox(custHeight: 28),
            _buildsearchFiltersAndAddButton(context),
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
            _buildTransportTableView(context)
          ],
        ),
      ),
    );
  }

  _buildsearchFiltersAndAddButton(BuildContext context) {
    return Row(
      children: [
        AppWidgetUtils.buildSearchField(AppConstants.transportName,
            _transportBlocImpl.transportNameSearchController, context),
        AppWidgetUtils.buildSearchField(AppConstants.mobileNumber,
            _transportBlocImpl.transportMobNoSearchController, context),
        AppWidgetUtils.buildSearchField(AppConstants.city,
            _transportBlocImpl.transportCitySearchController, context),
        const Spacer(),
        AppWidgetUtils.buildAddbutton(
          context,
          text: AppConstants.addTransport,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return const CreateTransportDialog();
              },
            );
          },
        )
      ],
    );
  }

  _buildTransportTableView(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          key: UniqueKey(),
          dividerThickness: 0.01,
          columns: [
            _buildTransportTableHeader(
              AppConstants.sno,
            ),
            _buildTransportTableHeader(AppConstants.transportName),
            _buildTransportTableHeader(AppConstants.mobileNumber),
            _buildTransportTableHeader(AppConstants.city),
            _buildTransportTableHeader(AppConstants.action),
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
                DataCell(Text(data[AppConstants.transportName]!)),
                DataCell(Text(data[AppConstants.mobileNumber]!)),
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

  _buildTransportTableHeader(String headerValue) => DataColumn(
        label: Text(
          headerValue,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
}
