import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/voucher_receipt/new_voucher/new_voucher_dart.dart';
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
            _buildTabBarView(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return AppWidgetUtils.buildCustomNunitoSansTextWidget(AppConstants.receipt,
        color: _appColors.primaryColor,
        fontSize: 28,
        fontWeight: FontWeight.w700);
  }

  Widget _buildTabBar() {
    return SizedBox(
      width: 250,
      child: TabBar(
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
      children: [
        Row(
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
            TldsDropDownButtonFormField(
              height: 40,
              width: MediaQuery.sizeOf(context).width * 0.15,
              dropDownItems: _voucherReceiptBloc.employeeList,
              dropDownValue: _voucherReceiptBloc.selectedEmployee,
              hintText: AppConstants.employee,
              onChange: (String? value) {
                _voucherReceiptBloc.selectedEmployee = value;
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
          builder: (context) => NewVoucher(blocInstance: _voucherReceiptBloc),
        );
      },
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _voucherReceiptBloc.receiptVoucherTabController,
        children: [
          _buildTransferTableView(context),
          _buildVoucherTableView(context),
        ],
      ),
    );
  }

  _buildTransferTableView(BuildContext context) {
    return Expanded(
        child: SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            key: UniqueKey(),
            dividerThickness: 0.01,
            columns: [
              _buildTransferTableHeader(
                AppConstants.sno,
              ),
              _buildTransferTableHeader(AppConstants.receiptNumber, flex: 2),
              _buildTransferTableHeader(AppConstants.receiptDate, flex: 2),
              _buildTransferTableHeader(AppConstants.vehicleName, flex: 2),
              _buildTransferTableHeader(AppConstants.color, flex: 2),
              _buildTransferTableHeader(AppConstants.receivedFrom, flex: 2),
              _buildTransferTableHeader(AppConstants.paymentType, flex: 2),
              _buildTransferTableHeader(AppConstants.amount, flex: 2),
              _buildTransferTableHeader(AppConstants.print, flex: 2),
              _buildTransferTableHeader(AppConstants.action, flex: 2),
            ],
            rows: List.generate(_voucherReceiptBloc.rowData.length, (index) {
              final data = _voucherReceiptBloc.rowData[index];

              final color = index.isEven
                  ? _appColors.whiteColor
                  : _appColors.transparentBlueColor;
              return DataRow(
                color: MaterialStateColor.resolveWith((states) => color),
                cells: [
                  DataCell(Text(data[AppConstants.sno] ?? '')),
                  DataCell(Text(data[AppConstants.receiptNumber] ?? '')),
                  DataCell(Text(data[AppConstants.receiptDate] ?? '')),
                  DataCell(Text(data[AppConstants.vehicleName] ?? '')),
                  DataCell(Text(data[AppConstants.color] ?? '')),
                  DataCell(Text(data[AppConstants.receivedFrom] ?? '')),
                  DataCell(Text(data[AppConstants.paymentType] ?? '')),
                  DataCell(Text(data[AppConstants.amount] ?? '')),
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
                        icon: SvgPicture.asset(AppConstants.icFilledClose),
                      )
                    ],
                  )),
                ],
              );
            }),
          ),
        ),
      ),
    ));
  }

  _buildVoucherTableView(BuildContext context) {
    return Expanded(
        child: SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            key: UniqueKey(),
            dividerThickness: 0.01,
            columns: [
              _buildTransferTableHeader(
                AppConstants.sno,
              ),
              _buildTransferTableHeader(AppConstants.voucherId, flex: 2),
              _buildTransferTableHeader(AppConstants.voucherDate, flex: 2),
              _buildTransferTableHeader(AppConstants.giver, flex: 2),
              _buildTransferTableHeader(AppConstants.receiver, flex: 2),
              _buildTransferTableHeader(AppConstants.amount, flex: 2),
              _buildTransferTableHeader(AppConstants.print, flex: 2),
              _buildTransferTableHeader(AppConstants.action, flex: 2),
            ],
            rows:
                List.generate(_voucherReceiptBloc.voucherData.length, (index) {
              final data = _voucherReceiptBloc.voucherData[index];

              final color = index.isEven
                  ? _appColors.whiteColor
                  : _appColors.transparentBlueColor;
              return DataRow(
                color: MaterialStateColor.resolveWith((states) => color),
                cells: [
                  DataCell(Text(data[AppConstants.sno] ?? '')),
                  DataCell(Text(data[AppConstants.voucherId] ?? '')),
                  DataCell(Text(data[AppConstants.voucherDate] ?? '')),
                  DataCell(Text(data[AppConstants.giver] ?? '')),
                  DataCell(Text(data[AppConstants.receiver] ?? '')),
                  DataCell(Text(data[AppConstants.amount] ?? '')),
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
                        icon: SvgPicture.asset(AppConstants.icFilledClose),
                      )
                    ],
                  )),
                ],
              );
            }),
          ),
        ),
      ),
    ));
  }

  _buildTransferTableHeader(String headerValue, {int flex = 1}) => DataColumn(
      label: AppWidgetUtils.buildCustomInterTextWidget(headerValue,
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

  Widget _buildDefaultWidth() {
    return AppWidgetUtils.buildSizedBox(
        custWidth: MediaQuery.sizeOf(context).width * 0.01);
  }

  Widget _buildDefaultHeight() {
    return AppWidgetUtils.buildSizedBox(
        custHeight: MediaQuery.sizeOf(context).height * 0.02);
  }
}
