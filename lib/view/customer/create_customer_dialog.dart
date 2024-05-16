import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/components/custom_action_button.dart';

import 'package:tlbilling/components/custom_elevated_button.dart';

import 'package:tlbilling/components/custom_form_field.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/input_validation.dart';
import 'package:tlbilling/view/customer/create_customer_dialog_bloc.dart';

class CreateCustomerDialog extends StatefulWidget {
  const CreateCustomerDialog({super.key});

  @override
  State<CreateCustomerDialog> createState() => _CreateCustomerDialogState();
}

class _CreateCustomerDialogState extends State<CreateCustomerDialog> {
  final _appColors = AppColors();
  final _createCustomerDialogBlocImpl = CreateCustomerDialogBlocImpl();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _appColors.whiteColor,
      surfaceTintColor: _appColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.all(10),
      title: _buildCustomerFormTitle(),
      actions: [
        _buildSaveButton(),
      ],
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.4,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: _buildCustomerCreateForm(),
        ),
      ),
    );
  }

  _buildCustomerFormTitle() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppWidgetUtils.buildText(
              text: AppConstants.addCustomer,
              fontSize: 22,
              color: _appColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  _buildCustomerCreateForm() {
    return SingleChildScrollView(
      child: Form(
        key: _createCustomerDialogBlocImpl.custFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppWidgetUtils.buildSizedBox(custHeight: 10),
            nameAndMobileNumberFeilds(),
            AppWidgetUtils.buildSizedBox(custHeight: 13),
            mailIdAndCityFeilds(),
            AppWidgetUtils.buildSizedBox(custHeight: 13),
            aadharAndPanNoFields(),
            AppWidgetUtils.buildSizedBox(custHeight: 13),
            _buildAddressFields(),
            AppWidgetUtils.buildSizedBox(custHeight: 13),
            CustomElevatedButton(
              text: AppConstants.uploadCustomerPhoto,
              fontSize: 16,
              buttonBackgroundColor: _appColors.primaryColor,
              fontColor: _appColors.whiteColor,
              preffixIcon: SvgPicture.asset(AppConstants.icCamera),
            ),
            AppWidgetUtils.buildSizedBox(custHeight: 13),
          ],
        ),
      ),
    );
  }

  _buildAddressFields() {
    return CustomFormField(
      maxLine: 100,
      height: 92,
      // validator: (value) {
      //   return InputValidations.addressValidation(value ?? '');
      // },
      controller: _createCustomerDialogBlocImpl.custAddressTextController,
      hintText: AppConstants.hintAddress,
      labelText: AppConstants.address,
    );
  }

  nameAndMobileNumberFeilds() {
    return Row(
      children: [
        _buildNameField(),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        _buildMobileNofield()
      ],
    );
  }

  _buildMobileNofield() {
    return Expanded(
      child: CustomFormField(
          maxLength: 10,
          requiredLabelText:
              AppWidgetUtils.labelTextWithRequired(AppConstants.mobileNumber),
          validator: (value) {
            return InputValidations.mobileNumberValidation(value ?? '');
          },
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          hintText: AppConstants.hintMobileNo,
          controller: _createCustomerDialogBlocImpl.custMobileNoTextController),
    );
  }

  _buildNameField() {
    return Expanded(
      child: CustomFormField(
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[a-z A-Z @]")),
          ],
          requiredLabelText:
              AppWidgetUtils.labelTextWithRequired(AppConstants.name),
          validator: (value) {
            return InputValidations.nameValidation(value ?? '');
          },
          hintText: AppConstants.hintName,
          controller: _createCustomerDialogBlocImpl.customerNameTextController),
    );
  }

  mailIdAndCityFeilds() {
    return Row(
      children: [
        Expanded(
          child: CustomFormField(
              validator: (value) {
                return InputValidations.mailValidation(value ?? '');
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r"^[a-z0-9.@]+")),
              ],
              hintText: AppConstants.hintMail,
              labelText: AppConstants.mailid,
              controller:
                  _createCustomerDialogBlocImpl.custMailIdTextController),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        Expanded(
          child: CustomFormField(
              requiredLabelText:
                  AppWidgetUtils.labelTextWithRequired(AppConstants.city),
              validator: (value) {
                return InputValidations.cityValidation(value ?? '');
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-z A-Z ]")),
              ],
              hintText: AppConstants.hintCity,
              controller: _createCustomerDialogBlocImpl.custCitytextcontroller),
        )
      ],
    );
  }

  aadharAndPanNoFields() {
    return Row(
      children: [
        Expanded(
          child: CustomFormField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                return InputValidations.aadharValidation(value!);
              },
              maxLength: 16,
              hintText: AppConstants.hintAatharNo,
              labelText: AppConstants.aadharNo,
              controller:
                  _createCustomerDialogBlocImpl.custAadharNoTextController),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        Expanded(
          child: CustomFormField(
              maxLength: 10,
              hintText: AppConstants.hintPanNo,
              labelText: AppConstants.panNo,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[A-Z 0-9]")),
              ],
              validator: (value) {
                return InputValidations.panValidation(value!);
              },
              controller:
                  _createCustomerDialogBlocImpl.custAccNoTextController),
        )
      ],
    );
  }

  _buildSaveButton() {
    return CustomActionButtons(
      buttonText: AppConstants.addCustomer,
      onPressed: () {
        if (_createCustomerDialogBlocImpl.custFormKey.currentState!
            .validate()) {
          // ignore: avoid_print
          print('customer created success');
        }
      },
    );
  }
}
