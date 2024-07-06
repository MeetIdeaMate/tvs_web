import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tlbilling/components/custom_pagenation.dart';
import 'package:tlbilling/models/get_model/get_all_vendor_by_pagination_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlbilling/view/vendor/create_vendor_dialog.dart';
import 'package:tlbilling/view/vendor/vendor_view_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_formaters.dart';

class VendorView extends StatefulWidget {
  const VendorView({super.key});

  @override
  State<VendorView> createState() => _VendorViewState();
}

class _VendorViewState extends State<VendorView> {
  final _appColors = AppColors();
  final _vendorViewBlocImpl = VendorViewBlocImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppWidgetUtils.buildHeaderText(AppConstants.vendor),
            AppWidgetUtils.buildSizedBox(custHeight: 26),
            _buildSearchFilterAddButton(context),
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
        _buildVendorNameSearch(),
        _buildMobileNoSearch(),
        _buildCitySearch(),
        const Spacer(),
        AppWidgetUtils.buildAddbutton(
          context,
          text: AppConstants.addVendor,
          onPressed: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return CreateVendorDialog(
                    vendorViewBlocImpl: _vendorViewBlocImpl);
              },
            );
          },
        )
      ],
    );
  }

  StreamBuilder<bool> _buildCitySearch() {
    return buildSearchField(
        inputFormatters: TlInputFormatters.onlyAllowAlphabetsAndSpaces,
        hintText: AppConstants.city,
        searchController: _vendorViewBlocImpl.vendorCitySearchController,
        searchStream: _vendorViewBlocImpl.vendorCitySearchStream,
        searchStreamController:
            _vendorViewBlocImpl.vendorCitySearchStreamController);
  }

  StreamBuilder<bool> _buildMobileNoSearch() {
    return buildSearchField(
        inputFormatters: TldsInputFormatters.phoneNumberInputFormatter,
        hintText: AppConstants.mobileNumber,
        searchController: _vendorViewBlocImpl.vendorMobNoSearchController,
        searchStream: _vendorViewBlocImpl.vendorMobileNoSearchStream,
        searchStreamController:
            _vendorViewBlocImpl.vendorMobileNoSearchStreamController);
  }

  StreamBuilder<bool> _buildVendorNameSearch() {
    return buildSearchField(
        inputFormatters: TlInputFormatters.onlyAllowAlphabetsAndSpaces,
        hintText: AppConstants.vendorName,
        searchController: _vendorViewBlocImpl.vendorNameSearchController,
        searchStream: _vendorViewBlocImpl.vendorNameStream,
        searchStreamController: _vendorViewBlocImpl.vendorNameStreamController);
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
                  _vendorViewBlocImpl.pageNumberUpdateStreamController(0);
                  _vendorViewBlocImpl.getAllVendorByPagination();
                }
              } else {
                searchController.clear();
                searchStreamController!(false);
                _vendorViewBlocImpl.pageNumberUpdateStreamController(0);
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
              _vendorViewBlocImpl.pageNumberUpdateStreamController(0);
              _vendorViewBlocImpl.getAllVendorByPagination();
            }
          },
        );
      },
    );
  }

  _buildVendorTableView(BuildContext context) {
    return Expanded(
      child: StreamBuilder<int>(
          stream: _vendorViewBlocImpl.pageNumberStream,
          initialData: _vendorViewBlocImpl.currentPage,
          builder: (context, streamSnapshot) {
            int currentPage = streamSnapshot.data ?? 0;
            if (currentPage < 0) currentPage = 0;
            _vendorViewBlocImpl.currentPage = currentPage;

            return FutureBuilder<GetAllVendorByPagination>(
              future: _vendorViewBlocImpl.getAllVendorByPagination(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: AppWidgetUtils.buildLoading());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text(AppConstants.somethingWentWrong));
                } else if (!snapshot.hasData) {
                  return Center(
                      child: SvgPicture.asset(AppConstants.imgNoData));
                }
                GetAllVendorByPagination vendorListModel = snapshot.data!;
                List<Content> vendorData = snapshot.data?.content ?? [];
                return Column(
                  children: [
                    Expanded(
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
                                AppConstants.gstNo,
                              ),
                              _buildVendorTableHeader(
                                AppConstants.city,
                              ),
                              _buildVendorTableHeader(
                                AppConstants.action,
                              ),
                            ],
                            rows: vendorData.asMap().entries.map((entry) {
                              return DataRow(
                                color: MaterialStateColor.resolveWith((states) {
                                  return entry.key % 2 == 0
                                      ? Colors.white
                                      : _appColors.transparentBlueColor;
                                }),
                                cells: [
                                  DataCell(Text('${entry.key + 1}')),
                                  DataCell(Text(entry.value.vendorName ?? '')),
                                  DataCell(Text(entry.value.mobileNo ?? '')),
                                  DataCell(Text(entry.value.gstNumber ?? '')),
                                  DataCell(Text(entry.value.city ?? '')),
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
                                                return CreateVendorDialog(
                                                  vendorViewBlocImpl:
                                                      _vendorViewBlocImpl,
                                                  vendorId:
                                                      entry.value.vendorId,
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
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
                        _vendorViewBlocImpl
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
