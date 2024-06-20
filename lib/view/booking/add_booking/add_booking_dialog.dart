import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/booking/add_booking/add_booking_dialog_bloc.dart';
import 'package:tlbilling/view/customer/create_customer_dialog.dart';
import 'package:tlds_flutter/components/tlds_date_picker.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_formaters.dart';

class AddBookingDialog extends StatefulWidget {
  const AddBookingDialog({super.key});

  @override
  State<AddBookingDialog> createState() => _AddBookingDialogState();
}

class _AddBookingDialogState extends State<AddBookingDialog> {
  final _appColors = AppColors();
  final _addBookingDialogBloc = AddBookingDialogBlocImpl();

  @override
  void initState() {
    super.initState();
    _getBranchId();
  }

  _getBranchId() async {
    setState(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _addBookingDialogBloc.branchId = prefs.getString(AppConstants.branchId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildDateCustomerNameAndAddCustomer(),
            _buildVehicleNameList(),
            _buildAdditionalInfoField(),
            _buildPaymentTypeAndAmount(),
            _buildExecutiveFromAndTargetInvoiceDate(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppWidgetUtils.buildCustomDmSansTextWidget(AppConstants.newBooking,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: _appColors.primaryColor),
        IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close))
      ],
    );
  }

  Widget _buildDateCustomerNameAndAddCustomer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildDatePicker(),
        _buildCustomerNameDropdown(),
        _buildAddNewCustomerButton(),
      ],
    );
  }

  Widget _buildDatePicker() {
    return TldsDatePicker(
      labelText: AppConstants.date,
      firstDate: DateTime(2000, 1, 1),
      height: 40,
      suffixIcon: SvgPicture.asset(
        AppConstants.icDate,
        colorFilter: ColorFilter.mode(
          _appColors.primaryColor,
          BlendMode.srcIn,
        ),
      ),
      fontSize: 14,
      width: 150,
      hintText: AppConstants.fromDate,
      controller: _addBookingDialogBloc.bookingDateTextController,
    );
  }

  Widget _buildCustomerNameDropdown() {
    return FutureBuilder(
      future: _addBookingDialogBloc.getCustomerNames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text(AppConstants.loading));
        } else if (snapshot.hasError) {
          return const Center(child: Text(AppConstants.errorLoading));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text(AppConstants.noData));
        }
        final customerList =
            snapshot.data?.result?.getAllCustomerNameList ?? [];
        final customerNamesSet =
            customerList.map((result) => result.customerName ?? "").toSet();
        List<String> customerNamesList = customerNamesSet.toList();
        return _buildCustomTyAhead(
            width: 200,
            labelText: AppConstants.customerName,
            textEditingController:
                _addBookingDialogBloc.customerNameTextController,
            hintText: AppConstants.select,
            errorText: 'Select Customer',
            list: customerNamesList);
      },
    );
  }

  Widget _buildAddNewCustomerButton() {
    return CustomElevatedButton(
      height: 40,
      width: 189,
      text: AppConstants.addCustomer,
      fontSize: 14,
      buttonBackgroundColor: _appColors.primaryColor,
      fontColor: _appColors.whiteColor,
      suffixIcon: SvgPicture.asset(AppConstants.icAdd),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const CreateCustomerDialog(),
        );
      },
    );
  }

  Widget _buildVehicleNameList() {
    return FutureBuilder(
      future: _addBookingDialogBloc.getVehicleList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text(AppConstants.loading));
        } else if (snapshot.hasError) {
          return const Center(child: Text(AppConstants.errorLoading));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text(AppConstants.noData));
        }
        List<String> vehicleNameList =
            snapshot.data?.map((e) => e.itemName ?? '').toList() ?? [];
        return _buildCustomTyAhead(
            width: MediaQuery.sizeOf(context).width,
            labelText: AppConstants.vehicleName,
            textEditingController:
                _addBookingDialogBloc.vehicleNameTextController,
            hintText: AppConstants.select,
            errorText: 'Select vehicle',
            list: vehicleNameList);
      },
    );
  }

  Widget _buildAdditionalInfoField() {
    return _buildFormField(_addBookingDialogBloc.additionalInfoTextController,
        AppConstants.bookingId, TldsInputFormatters.onlyAllowAlphabets,
        width: MediaQuery.sizeOf(context).width,
        labelText: AppConstants.additionalInfo);
  }

  Widget _buildPaymentTypeAndAmount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildPaymentType(),
        AppWidgetUtils.buildSizedBox(custWidth: 18),
        _buildAmountFiled(),
      ],
    );
  }

  Widget _buildPaymentType() {
    return FutureBuilder(
      future: _addBookingDialogBloc.getPaymentsList(),
      builder: (context, snapshot) {
        List<String> paymentTypesList = snapshot.data?.configuration ?? [];
        return TldsDropDownButtonFormField(
          labelText: AppConstants.paymentType,
          height: 40,
          width: 200,
          hintText: AppConstants.payments,
          dropDownItems: paymentTypesList,
          dropDownValue: _addBookingDialogBloc.selectedPaymentType,
          onChange: (String? newValue) {
            _addBookingDialogBloc.selectedPaymentType = newValue ?? '';
          },
        );
      },
    );
  }

  Widget _buildAmountFiled() {
    return _buildFormField(_addBookingDialogBloc.amountTextController,
        AppConstants.bookingId, TldsInputFormatters.onlyAllowNumbers,
        width: 200, labelText: AppConstants.amount);
  }

  Widget _buildExecutiveFromAndTargetInvoiceDate() {
    return Row(children: [
      _buildExecutiveFrom(),
      _buildTargetInvoiceDate(),
    ]);
  }

  Widget _buildExecutiveFrom() {
    return FutureBuilder(
      future: _addBookingDialogBloc.getPaymentsList(),
      builder: (context, snapshot) {
        List<String> paymentTypesList = snapshot.data?.configuration ?? [];
        return TldsDropDownButtonFormField(
          labelText: AppConstants.paymentType,
          height: 40,
          width: 200,
          hintText: AppConstants.payments,
          dropDownItems: paymentTypesList,
          dropDownValue: _addBookingDialogBloc.selectedPaymentType,
          onChange: (String? newValue) {
            _addBookingDialogBloc.selectedPaymentType = newValue ?? '';
          },
        );
      },
    );
  }

  Widget _buildTargetInvoiceDate() {
    return TldsDatePicker(
      labelText: AppConstants.date,
      firstDate: DateTime(2000, 1, 1),
      height: 40,
      suffixIcon: SvgPicture.asset(
        AppConstants.icDate,
        colorFilter: ColorFilter.mode(
          _appColors.primaryColor,
          BlendMode.srcIn,
        ),
      ),
      fontSize: 14,
      width: 150,
      hintText: AppConstants.fromDate,
      controller: _addBookingDialogBloc.targetInvoiceDateTextController,
    );
  }

  Widget _buildCustomTyAhead(
      {TextEditingController? textEditingController,
      List<String>? list,
      String? errorText,
      String? labelText,
      double? width,
      String? hintText}) {
    return TypeAheadField(
      controller: textEditingController,
      itemBuilder: (context, String suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      onSelected: (String suggestion) {
        textEditingController?.text = suggestion;
      },
      suggestionsCallback: (pattern) {
        return list
            ?.where((customer) =>
                customer.toLowerCase().contains(pattern.toLowerCase()))
            .toList();
      },
      builder: (context, controller, focusNode) {
        return TldsInputFormField(
          suffixIcon: const Icon(Icons.arrow_drop_down),
          width: width,
          height: 40,
          focusNode: focusNode,
          labelText: labelText,
          hintText: hintText,
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return errorText;
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildFormField(TextEditingController textController, String hintText,
      List<TextInputFormatter>? inputFormatters,
      {String? labelText, double? width}) {
    return TldsInputFormField(
      maxLine: 10,
      labelText: labelText,
      width: width,
      height: 40,
      inputFormatters: inputFormatters,
      controller: textController,
      hintText: hintText,
      isSearch: true,
      onSubmit: (p0) {},
    );
  }
}
