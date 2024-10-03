import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlbilling/view/sales/insurance_entry_bloc.dart';
import 'package:tlds_flutter/components/tlds_date_picker.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';

class InsuranceEntryDialog extends StatefulWidget {
  final InsuranceEntryBlocImpl insuranceBloc;
  const InsuranceEntryDialog(this.insuranceBloc, {super.key});

  @override
  State<InsuranceEntryDialog> createState() => _InsuranceEntryDialogState();
}

class _InsuranceEntryDialogState extends State<InsuranceEntryDialog> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Form(
        key: widget.insuranceBloc.insuranceFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TldsInputFormField(
              height: 70,
              inputFormatters: TlInputFormatters.onlyAllowAlphabetsAndSpaces,
              hintText: 'Insurance Company Name',
              labelText: 'Company Name',
              controller:
                  widget.insuranceBloc.insuranceCompanyNameTextController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the insurance company name';
                }
                return null;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TldsDatePicker(
                    suffixIcon: SvgPicture.asset(AppConstants.icDate),
                    height: 70,
                    hintText: 'Insure Date',
                    labelText: 'Insure Date',
                    controller: widget.insuranceBloc.insureDateTextController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an insure date';
                      }
                      return null;
                    },
                  ),
                ),
                AppWidgetUtils.buildSizedBox(custWidth: 10),
                Expanded(
                  child: TldsInputFormField(
                    height: 70,
                    inputFormatters:
                        TlInputFormatters.onlyAllowAlphabetAndNumber,
                    hintText: 'Insurance No',
                    labelText: 'Insurance No',
                    controller: widget.insuranceBloc.insureNumberTextController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the insurance number';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TldsInputFormField(
                    height: 70,
                    inputFormatters: TlInputFormatters.onlyAllowDecimalNumbers,
                    hintText: '0.00',
                    labelText: 'Insured Amt',
                    controller: widget.insuranceBloc.insureAmountTextController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the insured amount';
                      }
                      return null;
                    },
                  ),
                ),
                AppWidgetUtils.buildSizedBox(custWidth: 10),
                Expanded(
                  child: TldsInputFormField(
                    height: 70,
                    inputFormatters: TlInputFormatters.onlyAllowDecimalNumbers,
                    hintText: '0.00',
                    labelText: 'Premium Amount',
                    controller:
                        widget.insuranceBloc.premiumAmountTextController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the premium amount';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TldsDatePicker(
                    suffixIcon: SvgPicture.asset(AppConstants.icDate),
                    height: 70,
                    hintText: 'Select Date',
                    labelText: 'OwnDmg Expiry Date',
                    controller:
                        widget.insuranceBloc.ownEmgDateExpTextController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an OwnDmg expiry date';
                      }
                      return null;
                    },
                  ),
                ),
                AppWidgetUtils.buildSizedBox(custWidth: 10),
                Expanded(
                  child: TldsDatePicker(
                    suffixIcon: SvgPicture.asset(AppConstants.icDate),
                    height: 70,
                    hintText: 'Select Date',
                    labelText: 'ThirdParty Expiry Date',
                    controller:
                        widget.insuranceBloc.thirdPartyExpTextController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a ThirdParty expiry date';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
