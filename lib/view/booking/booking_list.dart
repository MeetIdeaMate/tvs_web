import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
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
        title: AppWidgetUtils.buildCustomDmSansTextWidget(AppConstants.booking),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Center(
          child: Column(
            children: [
              _buildSearchFieldsAndAddBookButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchFieldsAndAddBookButton() {
    return Row(
      children: [
        _bookingIdField(),
        _buildDefaultWidth(),
        _buildCustomerNameField(),
        _buildDefaultWidth(),
        _buildPaymentTypeDropdown(),
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

  Widget _buildDefaultWidth({double? width}) {
    return AppWidgetUtils.buildSizedBox(
        custWidth: width ?? MediaQuery.sizeOf(context).width * 0.01);
  }

  Widget _buildDefaultHeight({double? height}) {
    return AppWidgetUtils.buildSizedBox(
        custHeight: height ?? MediaQuery.sizeOf(context).height * 0.02);
  }
}
