import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlbilling/view/voucher_receipt/new_receipt/new_receipt_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_formaters.dart';

class NewReceipt extends StatefulWidget {
  const NewReceipt({super.key});

  @override
  State<NewReceipt> createState() => _NewReceiptState();
}

class _NewReceiptState extends State<NewReceipt> {
  final _newReceiptBloc = NewReceiptBlocImpl();
  final _appColors = AppColors();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: _appColors.whiteColor,
      backgroundColor: _appColors.whiteColor,
      content: SingleChildScrollView(
        child: Form(
          key: _newReceiptBloc.formKey,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                const Divider(),
                _buildDefaultHeight(),
                _buildCustomerNameField(),
                //    _buildDefaultHeight(),
                _buildProductAndDate(),
                //    _buildDefaultHeight(),
                _buildColorAndPaymentType(),
                //    _buildDefaultHeight(),
                _buildReceivedFromAndAmount(),
              ],
            ),
          ),
        ),
      ),
      actions: [_buildActionButton()],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppWidgetUtils.buildCustomDmSansTextWidget(AppConstants.newVoucher,
            fontSize: 20, fontWeight: FontWeight.w700),
        IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close))
      ],
    );
  }

  Widget _buildCustomerNameField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FutureBuilder(
              future: _newReceiptBloc.getAllCustomerList(),
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
                final customerNamesSet = customerList
                    .map((result) => result.customerName ?? "")
                    .toSet();
                List<String> customerNamesList = customerNamesSet.toList();

                return _buildCustomTyAhead(
                    width: MediaQuery.sizeOf(context).width * 0.40,
                    labelText: AppConstants.customerName,
                    textEditingController:
                        _newReceiptBloc.customerNameController,
                    hintText: AppConstants.select,
                    errorText: 'Select Customer',
                    list: customerNamesList);
              },
            )
          ],
        ),
      ],
    );
  }

  Widget _buildProductAndDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCustomTyAhead(
            width: MediaQuery.sizeOf(context).width * 0.19,
            labelText: AppConstants.product,
            textEditingController: _newReceiptBloc.productController,
            errorText: 'Select Product',
            hintText: AppConstants.select,
            list: _newReceiptBloc.customerList),
        TldsInputFormField(
          controller: _newReceiptBloc.newReceiptDateController,
          requiredLabelText: AppWidgetUtils.buildCustomDmSansTextWidget(
              AppConstants.date,
              fontSize: 14),
          height: 70,
          width: MediaQuery.sizeOf(context).width * 0.19,
          hintText: 'dd/mm/yyyy',
          suffixIcon: IconButton(
              onPressed: () => _selectDate(
                  context, _newReceiptBloc.newReceiptDateController),
              icon: SvgPicture.asset(AppConstants.icDate)),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Enter Appointment Date';
            }
            return null;
          },
          onTap: () =>
              _selectDate(context, _newReceiptBloc.newReceiptDateController),
        )
      ],
    );
  }

  Widget _buildColorAndPaymentType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCustomTyAhead(
            width: MediaQuery.sizeOf(context).width * 0.19,
            labelText: AppConstants.color,
            textEditingController: _newReceiptBloc.colorController,
            hintText: AppConstants.select,
            errorText: 'Select Color',
            list: _newReceiptBloc.customerList),
        FutureBuilder(
          future: _newReceiptBloc.getConfigById(),
          builder: (context, snapshot) {
            return _buildCustomTyAhead(
                width: MediaQuery.sizeOf(context).width * 0.19,
                labelText: AppConstants.paymentType,
                textEditingController: _newReceiptBloc.paymentTypeController,
                hintText: AppConstants.select,
                errorText: 'Select PaymentType',
                list: snapshot.data);
          },
        ),
      ],
    );
  }

  Widget _buildReceivedFromAndAmount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: FutureBuilder(
            future: _newReceiptBloc.getEmployeeName(),
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
              return _buildCustomTyAhead(
                  width: MediaQuery.sizeOf(context).width * 0.19,
                  labelText: AppConstants.receivedFrom,
                  textEditingController: _newReceiptBloc.receivedFromController,
                  hintText: AppConstants.select,
                  errorText: 'Select Received From',
                  list: employeeNamesList);
            },
          ),
        ),
        TldsInputFormField(
          controller: _newReceiptBloc.receivedAmountController,
          height: 50,
          maxLength: 15,
          counterText: '',
          inputFormatters: TldsInputFormatters.onlyAllowDecimalAfterTwoDigits,
          width: MediaQuery.sizeOf(context).width * 0.19,
          labelText: AppConstants.amount,
          hintText: AppConstants.amount,
        )
      ],
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
          height: 70,
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

  Widget _buildActionButton() {
    return CustomActionButtons(
        onPressed: () {
          if (_newReceiptBloc.formKey.currentState!.validate()) {}
        },
        buttonText: AppConstants.save);
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController date) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date.text.isEmpty
          ? DateTime.now()
          : AppUtils.appStringToDateTime(date.text),
      firstDate: DateTime(0001, 01, 01),
      lastDate: DateTime(9999, 12, 31),
    );
    if (picked != null) {
      final formattedDate = AppUtils.apiToAppDateFormat(picked.toString());
      date.text = formattedDate;
    }
  }

  // ignore: unused_element
  Widget? _buildDefaultWidth({double? width}) {
    return AppWidgetUtils.buildSizedBox(
        custWidth: width ?? MediaQuery.sizeOf(context).width * 0.01);
  }

  Widget _buildDefaultHeight({double? height}) {
    return AppWidgetUtils.buildSizedBox(
        custHeight: height ?? MediaQuery.sizeOf(context).height * 0.01);
  }
}
