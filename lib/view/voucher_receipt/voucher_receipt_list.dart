import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/components/custom_pagenation.dart';
import 'package:tlbilling/models/get_model/get_all_vendor_by_pagination_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/voucher_receipt/new_receipt/new_receipt.dart';
import 'package:tlbilling/view/voucher_receipt/new_voucher/new_voucher.dart';
import 'package:tlbilling/view/voucher_receipt/voucher_list_bloc.dart';
import 'package:tlbilling/view/voucher_receipt/vouecher_receipt_list_bloc.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';

class VoucherReceiptList extends StatefulWidget {
  const VoucherReceiptList({super.key});

  @override
  State<VoucherReceiptList> createState() => _VoucherReceiptListState();
}

class _VoucherReceiptListState extends State<VoucherReceiptList>
    with SingleTickerProviderStateMixin {
  final _appColors = AppColors();
  final _voucherReceiptBloc = VoucherReceiptListBlocImpl();
  final _voucherListBlocImpl = VoucherListBlocImpl();

  @override
  void initState() {
    super.initState();
    _voucherReceiptBloc.receiptVoucherTabController =
        TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 21,
          vertical: 28,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderText(),
            _buildTabBar(),
            _buildDefaultHeight(),
            _buildSearchFilters(),
            _buildDefaultHeight(),
            Expanded(
              child: _buildTabBarView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return AppWidgetUtils.buildCustomDmSansTextWidget(AppConstants.receipt,
        color: _appColors.primaryColor,
        fontSize: 22,
        fontWeight: FontWeight.w700);
  }

  Widget _buildTabBar() {
    return SizedBox(
      width: 250,
      child: TabBar(
        isScrollable: false,
        physics: const NeverScrollableScrollPhysics(),
        controller: _voucherReceiptBloc.receiptVoucherTabController,
        tabs: const [
          Tab(text: AppConstants.receipt),
          Tab(text: AppConstants.voucher),
        ],
      ),
    );
  }

  Widget _buildSearchFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            StreamBuilder(
              stream: _voucherReceiptBloc.receiptIdStream,
              builder: (context, snapshot) {
                return _buildFormField(
                    _voucherReceiptBloc.receiptIdTextController,
                    AppConstants.receiptId);
              },
            ),
            AppWidgetUtils.buildSizedBox(custWidth: 15),
            FutureBuilder(
              future: _voucherReceiptBloc.getEmployeeName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text(AppConstants.loading));
                } else if (snapshot.hasError) {
                  return const Center(child: Text(AppConstants.errorLoading));
                } else if (!snapshot.hasData ||
                    snapshot.data!.result == null ||
                    snapshot.data!.result!.employeeListModel == null) {
                  return const Center(child: Text(AppConstants.noData));
                }

                final employeesList = snapshot.data!.result!.employeeListModel;
                final employeeNamesSet = employeesList!
                    .map((result) => result.employeeName ?? "")
                    .toSet();
                List<String> employeeNamesList = employeeNamesSet.toList();
                employeeNamesList.insert(0, AppConstants.all);
                return TldsDropDownButtonFormField(
                  height: 40,
                  width: MediaQuery.sizeOf(context).width * 0.15,
                  dropDownItems: employeeNamesList,
                  dropDownValue: AppConstants.all,
                  hintText: AppConstants.employee,
                  onChange: (String? value) {
                    _voucherReceiptBloc.selectedEmployee = value;
                  },
                );
              },
            ),
          ],
        ),
        _buildAddButton(),
      ],
    );
  }

  Widget _buildAddButton() {
    return CustomElevatedButton(
      height: 40,
      width: MediaQuery.sizeOf(context).width * 0.12,
      text: AppConstants.add,
      fontSize: 16,
      buttonBackgroundColor: _appColors.primaryColor,
      fontColor: _appColors.whiteColor,
      suffixIcon: SvgPicture.asset(AppConstants.icAdd),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            if (_voucherReceiptBloc.receiptVoucherTabController.index == 0) {
              return const NewReceipt();
            } else {
              return NewVoucher(blocInstance: _voucherReceiptBloc);
            }
          },
        );
      },
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _voucherReceiptBloc.receiptVoucherTabController,
      children: [
        _buildTransferTableView(context),
        _buildVoucherTableView(context),
      ],
    );
  }

  Widget _buildTransferTableView(BuildContext context) {
    return StreamBuilder<int>(
      stream: _voucherListBlocImpl.pageNumberStream,
      initialData: _voucherListBlocImpl.currentPage,
      builder: (context, streamSnapshot) {
        int currentPage = streamSnapshot.data ?? 0;
        if (currentPage < 0) currentPage = 0;
        _voucherListBlocImpl.currentPage = currentPage;
        return FutureBuilder<GetAllVendorByPagination?>(
          future: _voucherListBlocImpl.getVocherReport(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: AppWidgetUtils.buildLoading());
            } else if (snapshot.hasError) {
              return const Center(child: Text(AppConstants.somethingWentWrong));
            } else if (!snapshot.hasData) {
              return Center(child: SvgPicture.asset(AppConstants.imgNoData));
            }
            GetAllVendorByPagination receiptListModel = snapshot.data!;

            List<Content> receiptData = snapshot.data?.content ?? [];

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        dividerThickness: 0.01,
                        columns: [
                          _buildTransferTableHeader(AppConstants.sno),
                          _buildTransferTableHeader(AppConstants.receiptNumber),
                          _buildTransferTableHeader(AppConstants.receiptDate),
                          _buildTransferTableHeader(AppConstants.vehicleName),
                          _buildTransferTableHeader(AppConstants.color),
                          _buildTransferTableHeader(AppConstants.receivedFrom),
                          _buildTransferTableHeader(AppConstants.paymentType),
                          _buildTransferTableHeader(AppConstants.amount),
                          _buildTransferTableHeader(AppConstants.print),
                          _buildTransferTableHeader(AppConstants.action),
                        ],
                        rows: receiptData.asMap().entries.map((entry) {
                          return DataRow(
                            color: MaterialStateColor.resolveWith((states) {
                              return entry.key % 2 == 0
                                  ? Colors.white
                                  : _appColors.transparentBlueColor;
                            }),
                            cells: [
                              _buildTableRow('${entry.key + 1}'),
                              _buildTableRow(entry.value.city),
                              _buildTableRow(entry.value.ifscCode),
                              _buildTableRow(entry.value.vendorName),
                              _buildTableRow(entry.value.mobileNo),
                              _buildTableRow(entry.value.address),
                              _buildTableRow(entry.value.id),
                              _buildTableRow(entry.value.vendorName),
                              DataCell(IconButton(
                                  onPressed: () {},
                                  icon:
                                      SvgPicture.asset(AppConstants.icPrint))),
                              DataCell(Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: SvgPicture.asset(AppConstants.icEdit),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: SvgPicture.asset(
                                        AppConstants.icFilledClose),
                                  )
                                ],
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                CustomPagination(
                  itemsOnLastPage: receiptListModel.totalElements ?? 0,
                  currentPage: currentPage,
                  totalPages: receiptListModel.totalPages ?? 0,
                  onPageChanged: (pageValue) {
                    _voucherListBlocImpl
                        .pageNumberUpdateStreamController(pageValue);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  DataCell _buildTableRow(String? text) => DataCell(Text(
        text ?? '',
        style: const TextStyle(fontSize: 14),
      ));

  Widget _buildVoucherTableView(BuildContext context) {
    return StreamBuilder<int>(
      stream: _voucherReceiptBloc.pageNumberStream,
      initialData: _voucherReceiptBloc.currentPage,
      builder: (context, streamSnapshot) {
        int currentPage = streamSnapshot.data ?? 0;
        if (currentPage < 0) currentPage = 0;
        _voucherReceiptBloc.currentPage = currentPage;
        return FutureBuilder<GetAllVendorByPagination?>(
          future: _voucherReceiptBloc.getVocherReport(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: AppWidgetUtils.buildLoading());
            } else if (snapshot.hasError) {
              return const Center(child: Text(AppConstants.somethingWentWrong));
            } else if (!snapshot.hasData) {
              return Center(child: SvgPicture.asset(AppConstants.imgNoData));
            }
            GetAllVendorByPagination voucherListModel = snapshot.data!;
            List<Content> voucherData = snapshot.data?.content ?? [];

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      key: UniqueKey(),
                      dividerThickness: 0.01,
                      columns: [
                        _buildTransferTableHeader(AppConstants.sno),
                        _buildTransferTableHeader(AppConstants.voucherId,
                            flex: 2),
                        _buildTransferTableHeader(AppConstants.voucherDate,
                            flex: 2),
                        _buildTransferTableHeader(AppConstants.giver, flex: 2),
                        _buildTransferTableHeader(AppConstants.receiver,
                            flex: 2),
                        _buildTransferTableHeader(AppConstants.amount, flex: 2),
                        _buildTransferTableHeader(AppConstants.print, flex: 2),
                        _buildTransferTableHeader(AppConstants.action, flex: 2),
                      ],
                      rows: voucherData.asMap().entries.map((entry) {
                        final data = entry.value;
                        final color = entry.key.isEven
                            ? _appColors.whiteColor
                            : _appColors.transparentBlueColor;
                        return DataRow(
                          color:
                              MaterialStateColor.resolveWith((states) => color),
                          cells: [
                            _buildTableRow('${entry.key + 1}'),
                            _buildTableRow(data.address),
                            _buildTableRow(data.city),
                            _buildTableRow(data.ifscCode),
                            _buildTableRow(data.vendorId),
                            _buildTableRow(data.city),
                            DataCell(IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset(AppConstants.icPrint))),
                            DataCell(Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: SvgPicture.asset(AppConstants.icEdit),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: SvgPicture.asset(
                                      AppConstants.icFilledClose),
                                )
                              ],
                            )),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                CustomPagination(
                  itemsOnLastPage: voucherListModel.totalElements ?? 0,
                  currentPage: currentPage,
                  totalPages: voucherListModel.totalPages ?? 0,
                  onPageChanged: (pageValue) {
                    _voucherReceiptBloc
                        .pageNumberUpdateStreamController(pageValue);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  DataColumn _buildTransferTableHeader(String headerValue, {int flex = 1}) =>
      DataColumn(
          label: AppWidgetUtils.buildCustomDmSansTextWidget(headerValue,
              fontSize: 14, fontWeight: FontWeight.w700));

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
      isSearch: true,
      suffixIcon: IconButton(
        onPressed: iconData == Icons.search
            ? () {
                //add search cont here
                _checkController(hintText);
              }
            : () {
                textController.clear();
                _checkController(hintText);
              },
        icon: Icon(
          iconData,
          color: iconColor,
        ),
      ),
      onSubmit: (p0) {
        //add search cont here
        _checkController(hintText);
      },
    );
  }

  void _checkController(String hintText) {
    if (AppConstants.receiptId == hintText) {
      _voucherReceiptBloc.receiptIdStreamController(true);
    }
  }

  Widget _buildDefaultHeight() {
    return AppWidgetUtils.buildSizedBox(
        custHeight: MediaQuery.sizeOf(context).height * 0.02);
  }
}
