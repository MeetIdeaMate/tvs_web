import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/models/get_model/get_all_booking_list_with_pagination.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlbilling/view/booking/add_booking/add_booking_dialog.dart';
import 'package:tlbilling/view/booking/booking_list_bloc.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_formaters.dart';

class BookingList extends StatefulWidget {
  const BookingList({super.key});

  @override
  State<BookingList> createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
  final _appColors = AppColors();
  final _bookingListBloc = BookingListBlocImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppWidgetUtils.buildCustomDmSansTextWidget(AppConstants.booking,
            color: _appColors.primaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Center(
          child: Column(
            children: [
              _buildSearchFieldsAndAddBookButton(),
              _buildBookingListTable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchFieldsAndAddBookButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _bookingIdField(),
            _buildDefaultWidth(),
            _buildCustomerNameField(),
            _buildDefaultWidth(),
            _buildPaymentTypeDropdown(),
          ],
        ),
        _buildAddBookButton(),
      ],
    );
  }

  _bookingIdField() {
    return StreamBuilder(
      stream: _bookingListBloc.bookingIdFieldStreamController,
      builder: (context, snapshot) {
        return _buildFormField(
          _bookingListBloc.bookingIdTextController,
          AppConstants.bookingId,
          TldsInputFormatters.onlyAllowAlphabets,
        );
      },
    );
  }

  Widget _buildCustomerNameField() {
    return StreamBuilder(
      stream: _bookingListBloc.customerFieldStreamController,
      builder: (context, snapshot) {
        return _buildFormField(
          _bookingListBloc.customerTextController,
          AppConstants.customerName,
          TldsInputFormatters.onlyAllowAlphabets,
        );
      },
    );
  }

  Widget _buildPaymentTypeDropdown() {
    return FutureBuilder(
      future: _bookingListBloc.getPaymentsList(),
      builder: (context, snapshot) {
        List<String> paymentTypesList = snapshot.data?.configuration ?? [];
        return TldsDropDownButtonFormField(
          height: 40,
          width: 203,
          hintText: AppConstants.payments,
          dropDownItems: paymentTypesList,
          dropDownValue: _bookingListBloc.selectedPaymentType,
          onChange: (String? newValue) {
            _bookingListBloc.selectedPaymentType = newValue ?? '';
          },
        );
      },
    );
  }

  Widget _buildAddBookButton() {
    return CustomElevatedButton(
      height: 40,
      width: 189,
      text: AppConstants.addBook,
      fontSize: 14,
      buttonBackgroundColor: _appColors.primaryColor,
      fontColor: _appColors.whiteColor,
      suffixIcon: SvgPicture.asset(AppConstants.icAdd),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const AddBookingDialog(),
        );
      },
    );
  }

  Widget _buildFormField(TextEditingController textController, String hintText,
      List<TextInputFormatter>? inputFormatters) {
    final bool isTextEmpty = textController.text.isEmpty;
    final IconData iconData = isTextEmpty ? Icons.search : Icons.close;
    final Color iconColor = isTextEmpty ? _appColors.primaryColor : Colors.red;
    return TldsInputFormField(
      width: 203,
      height: 40,
      inputFormatters: inputFormatters,
      controller: textController,
      hintText: hintText,
      isSearch: true,
      suffixIcon: IconButton(
        onPressed: iconData == Icons.search
            ? () {
                _searchFilters();
                _checkController(hintText);
              }
            : () {
                textController.clear();
                _searchFilters();
                _checkController(hintText);
              },
        icon: Icon(
          iconData,
          color: iconColor,
        ),
      ),
      onSubmit: (p0) {
        _searchFilters();
        _checkController(hintText);
      },
    );
  }

  void _searchFilters() {}

  void _checkController(String hintText) {
    if (AppConstants.bookingId == hintText) {
      _bookingListBloc.bookingIdFieldStream(true);
    } else if (AppConstants.customerName == hintText) {
      _bookingListBloc.customerFieldStream(true);
    }
  }

  Widget _buildBookingListTable() {
    return StreamBuilder(
      stream: null,
      builder: (context, snapshot) {
        return FutureBuilder(
          future: _bookingListBloc.getBookingListWithPagination(),
          builder: (context, snapshot) {
            List<BookingDetails> bookingDetails =
                snapshot.data?.bookingDetails ?? [];
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: AppWidgetUtils.buildLoading());
            } else /*if(snapshot.hasData)*/ {
              return Expanded(
                  child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                      columns: _buildBookingListTableColumns(),
                      rows: _buildBookingListTableRows(bookingDetails)),
                ),
              ));
            }
          },
        );
      },
    );
  }

  List<DataColumn> _buildBookingListTableColumns() {
    return [
      _buildTableHeader(AppConstants.sno, flex: 1),
      _buildTableHeader(AppConstants.bookingId, flex: 2),
      _buildTableHeader(AppConstants.date, flex: 2),
      _buildTableHeader(AppConstants.customerName, flex: 2),
      _buildTableHeader(AppConstants.vehicleName, flex: 2),
      _buildTableHeader(AppConstants.additionalInfo, flex: 2),
      _buildTableHeader(AppConstants.paymentType, flex: 2),
      _buildTableHeader(AppConstants.amount, flex: 2),
      _buildTableHeader(AppConstants.executiveName, flex: 2),
      _buildTableHeader(AppConstants.targetInvDate, flex: 2),
      _buildTableHeader(AppConstants.action, flex: 2),
    ];
  }

  List<DataRow> _buildBookingListTableRows(List<BookingDetails> bookingDetails) {
    return
      bookingDetails.asMap().entries.map((entry) {
        return DataRow(
          color: MaterialStateColor.resolveWith((states) {
        if (entry.key % 2 == 0) {
          return Colors.white;
        } else {
          return _appColors.transparentBlueColor;
        }
      }),
          cells: [
            DataCell(Text('${entry.key + 1}')),
            DataCell(Text(entry.value.bookingNo ?? '')),
            DataCell(Text(AppUtils.apiToAppDateFormat(entry.value.bookingDate.toString()))),
            DataCell(Text(entry.value.customerName ?? '')),
            DataCell(Text(entry.value.itemName ?? '')),
            DataCell(Text(entry.value.additionalInfo ?? '')),
            DataCell(Text(entry.value.paidDetail?.paymentType ?? '')),
            DataCell(Text(AppUtils.formatCurrency(entry.value.paidDetail?.paidAmount?.toDouble() ?? 0))),
            DataCell(Text(entry.value.executiveName?? '')),
            DataCell(Text(AppUtils.apiToAppDateFormat(entry.value.bookingDate.toString()))),
            const DataCell(Text(AppConstants.action)),
          ],
        );
      }).toList();
  }

  DataColumn _buildTableHeader(String headerValue, {int flex = 1}) =>
      DataColumn(
        label: Expanded(
          child: Text(
            headerValue,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );

  Widget _buildDefaultWidth({double? width}) {
    return AppWidgetUtils.buildSizedBox(
        custWidth: width ?? MediaQuery.sizeOf(context).width * 0.01);
  }

  Widget _buildDefaultHeight({double? height}) {
    return AppWidgetUtils.buildSizedBox(
        custHeight: height ?? MediaQuery.sizeOf(context).height * 0.02);
  }
}
