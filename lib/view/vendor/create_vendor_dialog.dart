import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/components/custom_form_field.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/input_validation.dart';
import 'package:tlbilling/view/vendor/create_vendor_dialog_bloc.dart';

class CreateVendorDialog extends StatefulWidget {
  const CreateVendorDialog({super.key});

  @override
  State<CreateVendorDialog> createState() => _CreateVendorDialogState();
}

class _CreateVendorDialogState extends State<CreateVendorDialog> {
  final _appColors = AppColors();
  final _createVendorDialogBlocImpl = CreateVendorDialogBlocImpl();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _appColors.whiteColor,
      surfaceTintColor: _appColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.all(10),
      title: _buildVendorFormTitle(),
      actions: [
        _buildSaveButton(),
      ],
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.4,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: _buildVendorCreateForm(),
        ),
      ),
    );
  }

  _buildVendorFormTitle() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppConstants.addVendor,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _appColors.primaryColor)),
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

  _buildVendorCreateForm() {
    return SingleChildScrollView(
      child: Form(
        key: _createVendorDialogBlocImpl.vendorFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppWidgetUtils.buildSizedBox(custHeight: 10),
            _nameAndMobileNumberFeilds(),
            AppWidgetUtils.buildSizedBox(custHeight: 13),
            _panNoAndCityFeilds(),
            AppWidgetUtils.buildSizedBox(custHeight: 13),
            _gstNoAndFaxNoFields(),
            AppWidgetUtils.buildSizedBox(custHeight: 13),
            _buildTelePhNoFields(),
            AppWidgetUtils.buildSizedBox(custHeight: 13),
            _buildAddressFields(),
            AppWidgetUtils.buildSizedBox(custHeight: 13),
          ],
        ),
      ),
    );
  }

  _nameAndMobileNumberFeilds() {
    return Row(
      children: [
        Expanded(
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
              controller: _createVendorDialogBlocImpl.vendorNameTextController),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        Expanded(
          child: CustomFormField(
              maxLength: 10,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              requiredLabelText: AppWidgetUtils.labelTextWithRequired(
                  AppConstants.mobileNumber),
              validator: (value) {
                return InputValidations.mobileNumberValidation(value ?? '');
              },
              hintText: AppConstants.hintMobileNo,
              controller: _createVendorDialogBlocImpl.vendorMobNoController),
        ),
      ],
    );
  }

  _panNoAndCityFeilds() {
    return Row(
      children: [
        Expanded(
          child: CustomFormField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[A-Z 0-9]")),
              ],
              labelText: AppConstants.panNo,
              validator: (value) {
                return InputValidations.panValidation(value ?? '');
              },
              hintText: AppConstants.hintPanNo,
              controller: _createVendorDialogBlocImpl.vendorPanNoController),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        Expanded(
          child: CustomFormField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-z A-Z ]")),
              ],
              requiredLabelText:
                  AppWidgetUtils.labelTextWithRequired(AppConstants.city),
              validator: (value) {
                return InputValidations.cityValidation(value ?? '');
              },
              hintText: AppConstants.hintCity,
              controller: _createVendorDialogBlocImpl.vendorCityController),
        ),
      ],
    );
  }

  _gstNoAndFaxNoFields() {
    return Row(
      children: [
        Expanded(
          child: CustomFormField(
              maxLength: 15,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9A-Z]")),
              ],
              requiredLabelText:
                  AppWidgetUtils.labelTextWithRequired(AppConstants.gstNo),
              validator: (value) {
                return InputValidations.gstNumberValidation(value ?? '');
              },
              hintText: AppConstants.hintGst,
              controller: _createVendorDialogBlocImpl.vendorGstNoController),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        Expanded(
          child: CustomFormField(
              maxLength: 12,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9 - ]")),
              ],
              labelText: AppConstants.fax,
              hintText: AppConstants.hintPanNo,
              controller: _createVendorDialogBlocImpl.vendorFaxController),
        ),
      ],
    );
  }

  _buildTelePhNoFields() {
    return CustomFormField(
        labelText: AppConstants.telephoneNumber,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        // requiredLabelText: AppWidgetUtils.labelTextWithRequired(
        //     AppConstants.mobileNumber),
        // validator: (value) {
        //   return InputValidations.mobileNumberValidation(value ?? '');
        // },
        hintText: AppConstants.hintTelephoneNumber,
        controller: _createVendorDialogBlocImpl.vendorTelephoneNoController);
  }

  _buildAddressFields() {
    return CustomFormField(
        maxLine: 100,
        height: 80,
        labelText: AppConstants.address,
        // validator: (value) {
        //   return InputValidations.nameValidation(value ?? '');
        // },
        hintText: AppConstants.hintAddress,
        controller: _createVendorDialogBlocImpl.vendorAddressController);
  }

  _buildSaveButton() {
    return CustomActionButtons(
      buttonText: AppConstants.addVendor,
      onPressed: () {
        if (_createVendorDialogBlocImpl.vendorFormKey.currentState!
            .validate()) {}
      },
    );
  }
}
