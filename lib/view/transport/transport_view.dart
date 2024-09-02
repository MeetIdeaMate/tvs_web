import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/api_service/service_locator.dart';
import 'package:tlbilling/components/custom_pagenation.dart';
import 'package:tlbilling/models/get_model/get_transport_by_pagination.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';

import 'package:tlbilling/view/transport/create_transport_dialog.dart';

import 'package:tlbilling/view/transport/transport_view_bloc.dart';
import 'package:tlbilling/view/useraccess/access_level_shared_pref.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_formaters.dart';

class TransportView extends StatefulWidget {
  const TransportView({super.key});

  @override
  State<TransportView> createState() => _TransportViewState();
}

class _TransportViewState extends State<TransportView> {
  final _appColors = AppColors();
  final _transportBlocImpl = getIt<TransportBlocImpl>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppWidgetUtils.buildHeaderText(AppConstants.transport),
            AppWidgetUtils.buildSizedBox(custHeight: 26),
            _buildsearchFiltersAndAddButton(context),
            AppWidgetUtils.buildSizedBox(custHeight: 28),
            if (AccessLevel.canView(AppConstants.transport))
              _buildTransportTableView(context)
          ],
        ),
      ),
    );
  }

  _buildsearchFiltersAndAddButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (AccessLevel.canView(AppConstants.transport)) ...[
          StreamBuilder(
            stream: _transportBlocImpl.transportNameStreamController,
            builder: (context, snapshot) {
              return _buildFormField(
                  inputFormatters: TldsInputFormatters.onlyAllowAlphabets,
                  _transportBlocImpl.transportNameSearchController,
                  AppConstants.transportName);
            },
          ),
          AppWidgetUtils.buildSizedBox(custWidth: 10),
          StreamBuilder(
            stream: _transportBlocImpl.transportMobileNumberStreamController,
            builder: (context, snapshot) {
              return _buildFormField(
                  inputFormatters:
                      TldsInputFormatters.phoneNumberInputFormatter,
                  _transportBlocImpl.transportMobNoSearchController,
                  AppConstants.mobileNumber);
            },
          ),
          AppWidgetUtils.buildSizedBox(custWidth: 10),
          StreamBuilder(
            stream: _transportBlocImpl.transportCityStreamController,
            builder: (context, snapshot) {
              return _buildFormField(
                  inputFormatters: TldsInputFormatters.allowAlphabetsAndSpaces,
                  _transportBlocImpl.transportCitySearchController,
                  AppConstants.city);
            },
          ),
        ],
        if (AccessLevel.canAdd(AppConstants.transport)) ...[
          const Spacer(),
          AppWidgetUtils.buildAddbutton(
            context,
            text: AppConstants.addTransport,
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return const CreateTransportDialog();
                },
              );
            },
          )
        ]
      ],
    );
  }

  Widget _buildFormField(TextEditingController textController, String hintText,
      {List<TextInputFormatter>? inputFormatters}) {
    final bool isTextEmpty = textController.text.isEmpty;
    final IconData iconData = isTextEmpty ? Icons.search : Icons.close;
    final Color iconColor = isTextEmpty ? _appColors.primaryColor : Colors.red;
    return TldsInputFormField(
      inputFormatters: inputFormatters,
      width: MediaQuery.sizeOf(context).width * 0.15,
      height: 40,
      controller: textController,
      hintText: hintText,
      isSearch: true,
      suffixIcon: IconButton(
        onPressed: iconData == Icons.search
            ? () {
                _searchControllers();
                _checkController(hintText);
              }
            : () {
                _searchControllers();
                textController.clear();
                _checkController(hintText);
              },
        icon: Icon(
          iconData,
          color: iconColor,
        ),
      ),
      onSubmit: (p0) {
        _searchControllers();
        _checkController(hintText);
      },
    );
  }

  void _checkController(String hintText) {
    if (AppConstants.city == hintText) {
      _transportBlocImpl.transportCityStream(true);
    } else if (AppConstants.mobileNumber == hintText) {
      _transportBlocImpl.transportMobileNumberStream(true);
    } else if (AppConstants.transportName == hintText) {
      _transportBlocImpl.transportNameStream(true);
    }
  }

  void _searchControllers() {
    _transportBlocImpl.tablePageNoStream(0);
  }

  _buildTransportTableView(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: _transportBlocImpl.tablePageNoStreamController,
        initialData: _transportBlocImpl.currentPage,
        builder: (context, streamSnapshot) {
          int currentPage = streamSnapshot.data ?? 0;
          if (currentPage < 0) currentPage = 0;
          _transportBlocImpl.currentPage = currentPage;
          return FutureBuilder(
            future: _transportBlocImpl.getAllTransportByPagination(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: AppWidgetUtils.buildLoading());
              } else if (snapshot.hasError) {
                return const Center(
                    child: Text(AppConstants.somethingWentWrong));
              } else if (!snapshot.hasData ||
                  snapshot.data?.transportDetails?.isEmpty == true) {
                return Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AppConstants.imgNoData),
                        AppWidgetUtils.buildSizedBox(custHeight: 8),
                        Text(
                          AppConstants.noTransportDataAvailable,
                          style: TextStyle(color: _appColors.grey),
                        )
                      ],
                    ),
                  ),
                );
              }

              GetTransportByPaginationModel? getTransportByPaginationModel =
                  snapshot.data!;
              List<TransportDetails> userData =
                  getTransportByPaginationModel.transportDetails ?? [];

              return Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: DataTable(
                          dividerThickness: 0.01,
                          columns: [
                            _buildTransportTableHeader(AppConstants.sno),
                            _buildTransportTableHeader(AppConstants.empName),
                            _buildTransportTableHeader(
                                AppConstants.mobileNumber),
                            _buildTransportTableHeader(AppConstants.city),
                            if (AccessLevel.canFUpdate(AppConstants.transport))
                              _buildTransportTableHeader(AppConstants.action),
                          ],
                          rows: userData.asMap().entries.map((entry) {
                            return DataRow(
                              color: WidgetStateColor.resolveWith((states) {
                                return entry.key % 2 == 0
                                    ? Colors.white
                                    : _appColors.transparentBlueColor;
                              }),
                              cells: [
                                _buildTableRow('${entry.key + 1}'),
                                _buildTableRow(entry.value.transportName),
                                _buildTableRow(entry.value.mobileNo),
                                _buildTableRow(entry.value.city),
                                if (AccessLevel.canFUpdate(
                                    AppConstants.transport))
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
                                                  return CreateTransportDialog(
                                                      transportId: entry
                                                          .value.transportId);
                                                },
                                              );
                                            }),
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
                    itemsOnLastPage:
                        getTransportByPaginationModel.totalElements ?? 0,
                    currentPage: currentPage,
                    totalPages: getTransportByPaginationModel.totalPages ?? 0,
                    onPageChanged: (pageValue) {
                      _transportBlocImpl.tablePageNoStream(pageValue);
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

  _buildTransportTableHeader(String headerValue) => DataColumn(
        label: Text(
          headerValue,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );

  DataCell _buildTableRow(String? text) => DataCell(Text(
        text ?? '',
        style: const TextStyle(fontSize: 14),
      ));
}
