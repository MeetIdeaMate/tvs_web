// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/sales/add_sales_bloc.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';

class CustomerDetails extends StatefulWidget {
  AddSalesBlocImpl addSalesBloc;
  CustomerDetails({
    super.key,
    required this.addSalesBloc,
  });

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  final _appColors = AppColors();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        Text(
          AppConstants.customerDetails,
          style: TextStyle(
              color: _appColors.primaryColor,
              fontSize: 17,
              fontWeight: FontWeight.bold),
        ),
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        _buildSelectCustomerAndAddCustomer(),
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        _buildSelectedCustomerDetails(),
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        Text(
          AppConstants.paymentDetails,
          style: TextStyle(
              color: _appColors.primaryColor,
              fontSize: 17,
              fontWeight: FontWeight.bold),
        ),
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        _buildPaymentMethodSelection(context),
        const Spacer(),
        CustomActionButtons(onPressed: () {}, buttonText: AppConstants.save)
      ],
    );
  }

  Widget _buildPaymentMethodSelection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildPaymentOptions(),
        if (widget.addSalesBloc.selectedPaymentOption == AppConstants.credit)
          Expanded(
            child: TldsDropDownButtonFormField(
              height: 40,
              width: MediaQuery.sizeOf(context).width * 0.21,
              hintText: AppConstants.creditType,
              dropDownItems: const [],
              onChange: (String? newValue) {},
            ),
          ),
        if (widget.addSalesBloc.selectedPaymentOption == AppConstants.loan)
          Expanded(
            child: TldsDropDownButtonFormField(
              height: 40,
              width: MediaQuery.sizeOf(context).width * 0.21,
              hintText: AppConstants.selectBank,
              dropDownItems: const [],
              onChange: (String? newValue) {},
            ),
          ),
      ],
    );
  }

  Widget _buildSelectedCustomerDetails() {
    return Container(
      padding: const EdgeInsets.all(15),
      height: 200,
      width: 450,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: _appColors.whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ajith Kumar',
            style: TextStyle(color: _appColors.primaryColor, fontSize: 20),
          ),
          AppWidgetUtils.buildSizedBox(custHeight: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCustomerData('+91 9876543210', AppConstants.icCall),
                  AppWidgetUtils.buildSizedBox(custHeight: 10),
                  _buildCustomerData('876543235SBI', AppConstants.icBank),
                  AppWidgetUtils.buildSizedBox(custHeight: 10),
                  _buildCustomerData(
                      '37,/A  SBI Opposite \n ,KovilpattiTamilnadu',
                      AppConstants.icLocation),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCustomerData(
                      'ajith@techlambdas.com', AppConstants.icMail),
                  AppWidgetUtils.buildSizedBox(custHeight: 10),
                  _buildCustomerData('345-67-78999-6789', AppConstants.icCard),
                  AppWidgetUtils.buildSizedBox(custHeight: 10),
                  _buildCustomerData('Thoothukudi', AppConstants.icCity),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerData(String? textValue, String svgPath) {
    return Row(
      children: [
        SvgPicture.asset(
          svgPath,
          color: _appColors.primaryColor,
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 10),
        Text(textValue ?? '')
      ],
    );
  }

  Widget _buildSelectCustomerAndAddCustomer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TldsDropDownButtonFormField(
            height: 40,
            width: MediaQuery.sizeOf(context).width * 0.21,
            hintText: AppConstants.selectCustomer,
            dropDownItems: const [],
            onChange: (String? newValue) {},
          ),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 10),
        CustomElevatedButton(
          height: 40,
          width: MediaQuery.sizeOf(context).width * 0.12,
          text: AppConstants.addNew,
          fontSize: 16,
          buttonBackgroundColor: _appColors.primaryColor,
          fontColor: _appColors.whiteColor,
          suffixIcon: SvgPicture.asset(AppConstants.icHumanAdd),
        )
      ],
    );
  }

  Widget _buildCustomRadioTile({
    required String value,
    required String? groupValue,
    required ValueChanged<String?> onChanged,
    required IconData icon,
    required String label,
  }) {
    bool isSelected = value == groupValue;

    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        width: 180,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : _appColors.greyColor,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                icon,
                color:
                    isSelected ? _appColors.primaryColor : _appColors.greyColor,
              ),
            ),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                    fontSize: 16.0,
                    color: isSelected
                        ? _appColors.primaryColor
                        : _appColors.greyColor),
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildCustomRadioTile(
          value: AppConstants.credit,
          groupValue: widget.addSalesBloc.selectedPaymentOption,
          onChanged: (value) {
            setState(() {
              widget.addSalesBloc.selectedPaymentOption = value!;
            });
          },
          icon: Icons.credit_card,
          label: AppConstants.credit.toUpperCase(),
        ),
        _buildCustomRadioTile(
          value: AppConstants.loan,
          groupValue: widget.addSalesBloc.selectedPaymentOption,
          onChanged: (value) {
            setState(() {
              widget.addSalesBloc.selectedPaymentOption = value!;
            });
          },
          icon: Icons.monetization_on,
          label: AppConstants.loan.toUpperCase(),
        ),
        _buildCustomRadioTile(
          value: AppConstants.partPayment,
          groupValue: widget.addSalesBloc.selectedPaymentOption,
          onChanged: (value) {
            setState(() {
              widget.addSalesBloc.selectedPaymentOption = value!;
            });
          },
          icon: Icons.payment,
          label: AppConstants.partPayment.toUpperCase(),
        ),
      ],
    );
  }
}
