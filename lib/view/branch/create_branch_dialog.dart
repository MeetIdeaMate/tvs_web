import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/components/custom_dropdown_button_form_field.dart';
import 'package:tlbilling/components/custom_form_field.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/input_validation.dart';
import 'package:tlbilling/view/branch/create_branch_dialog_bloc.dart';

class CreateBranchDialog extends StatefulWidget {
  const CreateBranchDialog({super.key});

  @override
  State<CreateBranchDialog> createState() => _CreateBranchDialogState();
}

class _CreateBranchDialogState extends State<CreateBranchDialog> {
  final _appColors = AppColors();
  final _createBranchDialogBlocImpl = CreateBranchDialogBlocImpl();
  final List<String> _city = ['kvp', 'chennai'];
  final List<String> _mainBranch = ['madurai', 'kovilpatti'];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _appColors.whiteColor,
      surfaceTintColor: _appColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.all(10),
      title: _buildBranchFormTitle(),
      actions: [
        _buildSaveButton(),
      ],
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: _buildBranchCreateForm(),
        ),
      ),
    );
  }

  _buildBranchFormTitle() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppWidgetUtils.buildText(
              text: AppConstants.addBranch,
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

  _buildSaveButton() {
    return CustomActionButtons(
      buttonText: AppConstants.addBranch,
      onPressed: () {
        if (_createBranchDialogBlocImpl.branchFormKey.currentState!
            .validate()) {
          // ignore: avoid_print
          print('customer created success');
        }
      },
    );
  }

  _buildBranchCreateForm() {
    return Form(
      key: _createBranchDialogBlocImpl.branchFormKey,
      child: Column(
        children: [
          AppWidgetUtils.buildSizedBox(custHeight: 10),
          _buildBranchNameAndCityFields(),
          AppWidgetUtils.buildSizedBox(custHeight: 13),
          _buildMobNoPinCodeAndAddressFields(),
          AppWidgetUtils.buildSizedBox(custHeight: 13),
          _buildSelectBranchMainBranchFields(),
        ],
      ),
    );
  }

  _buildBranchNameAndCityFields() {
    return Row(
      children: [
        Expanded(
          child: CustomFormField(
              requiredLabelText:
                  AppWidgetUtils.labelTextWithRequired(AppConstants.branchName),
              validator: (value) {
                return InputValidations.branchValidation(value ?? '');
              },
              hintText: AppConstants.hintbranch,
              controller: _createBranchDialogBlocImpl.branchNameController),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        Expanded(
          child: CustomDropDownButtonFormField(
            // height: 72,
            requiredLabelText:
                AppWidgetUtils.labelTextWithRequired(AppConstants.city),
            dropDownItems: _city,
            hintText: AppConstants.exSelect,
            validator: (value) {
              return InputValidations.nameValidation(value ?? '');
            },
            onChange: (String? newValue) {
              _createBranchDialogBlocImpl.selectedCity = newValue ?? '';
            },
          ),
        ),
      ],
    );
  }

  _buildMobNoPinCodeAndAddressFields() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              CustomFormField(
                  requiredLabelText: AppWidgetUtils.labelTextWithRequired(
                      AppConstants.mobileNumber),
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    return InputValidations.mobileNumberValidation(value ?? '');
                  },
                  hintText: AppConstants.hintMobileNo,
                  controller: _createBranchDialogBlocImpl.mobileNoController),
              AppWidgetUtils.buildSizedBox(custHeight: 10),
              CustomFormField(
                  labelText: AppConstants.pinCode,
                  maxLength: 6,
                  validator: (value) {
                    return InputValidations.pinCodeValidation(value ?? '');
                  },
                  hintText: AppConstants.hintPinCode,
                  controller: _createBranchDialogBlocImpl.pinCodeController),
            ],
          ),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        Expanded(
          child: CustomFormField(
              requiredLabelText:
                  AppWidgetUtils.labelTextWithRequired(AppConstants.address),
              height: 128,
              maxLine: 100,
              validator: (value) {
                return InputValidations.addressValidation(value ?? '');
              },
              hintText: AppConstants.hintAddress,
              controller: _createBranchDialogBlocImpl.addressController),
        ),
      ],
    );
  }

  _buildSelectBranchMainBranchFields() {
    return Row(
      children: [
        _buildSelectBranchRadioButton(),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        Expanded(
          child: CustomDropDownButtonFormField(
            // height: 72,
            requiredLabelText:
                AppWidgetUtils.labelTextWithRequired(AppConstants.mainBranch),
            dropDownItems: _mainBranch,
            hintText: AppConstants.exSelect,
            validator: (value) {
              return InputValidations.branchValidation(value ?? '');
            },
            onChange: (String? newValue) {
              _createBranchDialogBlocImpl.selectedBranch = newValue ?? '';
            },
          ),
        ),
      ],
    );
  }

  _buildSelectBranchRadioButton() {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Radio(
                    value: AppConstants.mainBranch,
                    groupValue: _createBranchDialogBlocImpl.selectedBranch,
                    onChanged: (String? value) {
                      setState(() {
                        _createBranchDialogBlocImpl.selectedBranch = value;
                      });
                    }),
                Text(AppConstants.mainBranch,
                    style:
                        TextStyle(fontSize: 13, color: _appColors.blackColor))
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Radio(
                    value: AppConstants.subBranch,
                    groupValue: _createBranchDialogBlocImpl.selectedBranch,
                    onChanged: (String? value) {
                      setState(() {
                        _createBranchDialogBlocImpl.selectedBranch = value;
                      });
                    }),
                Text(AppConstants.subBranch,
                    style:
                        TextStyle(fontSize: 13, color: _appColors.blackColor))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
