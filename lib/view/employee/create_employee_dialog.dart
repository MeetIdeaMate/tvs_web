import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/components/custom_dropdown_button_form_field.dart';
import 'package:tlbilling/components/custom_form_field.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/input_validation.dart';
import 'package:tlbilling/view/employee/create_employee_dialog_bloc.dart';
import 'package:toastification/toastification.dart';

class CreateEmployeeDialog extends StatefulWidget {
  const CreateEmployeeDialog({super.key});

  @override
  State<CreateEmployeeDialog> createState() => _CreateEmployeeDialogState();
}

class _CreateEmployeeDialogState extends State<CreateEmployeeDialog> {
  final List<String>? empType = ['labor', 'supervisor'];
  final List<String>? empBranch = ['kvp', 'chennai'];
  final List<String>? empGender = ['male', 'Female', 'others'];
  final List<String>? city = ['kvp', 'chennai'];

  final _appColors = AppColors();
  final _createEmployeeDialogBlocImpl = CreateEmployeeDialogBlocImpl();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _appColors.whiteColor,
      surfaceTintColor: _appColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.all(10),
      title: _buildEmployeeFormTitle(),
      actions: [
        _buildSaveButton(),
      ],
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: _buildEmployeeCreateForm(),
        ),
      ),
    );
  }

  _buildEmployeeFormTitle() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppWidgetUtils.buildText(
              text: AppConstants.addEmployee,
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

  _buildEmployeeCreateForm() {
    return Form(
      key: _createEmployeeDialogBlocImpl.empFormkey,
      child: Column(
        children: [
          AppWidgetUtils.buildSizedBox(custHeight: 10),
          _buildEmpNameAndEmailFields(),
          //AppWidgetUtils.buildSizedBox(custHeight: 13),
          _empTypeAndBranchFields(),
          AppWidgetUtils.buildSizedBox(custHeight: 13),
          _buildAgeGenderAndCityFields(),
          AppWidgetUtils.buildSizedBox(custHeight: 13),
          _buildMobNoAndAddressFields(),
        ],
      ),
    );
  }

  _buildEmpNameAndEmailFields() {
    return Row(
      children: [
        Expanded(
          child: CustomFormField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[A-Z a-z @]'))
              ],
              height: 70,
              suffixIcon: SvgPicture.asset(
                colorFilter:
                    ColorFilter.mode(_appColors.primaryColor, BlendMode.srcIn),
                AppConstants.icPerson,
                fit: BoxFit.none,
              ),
              requiredLabelText:
                  AppWidgetUtils.labelTextWithRequired(AppConstants.empName),
              validator: (value) {
                return InputValidations.nameValidation(value ?? '');
              },
              hintText: AppConstants.hintName,
              controller: _createEmployeeDialogBlocImpl.empNameController),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: CustomFormField(
                suffixIcon: SvgPicture.asset(
                  colorFilter: ColorFilter.mode(
                      _appColors.primaryColor, BlendMode.srcIn),
                  AppConstants.icMail,
                  fit: BoxFit.none,
                ),
                validator: (value) {
                  return InputValidations.mailValidation(value ?? '');
                },
                labelText: AppConstants.emailAddress,
                hintText: AppConstants.hintMail,
                controller: _createEmployeeDialogBlocImpl.empEmailController),
          ),
        ),
      ],
    );
  }

  _empTypeAndBranchFields() {
    return Row(
      children: [
        Expanded(
          child: CustomDropDownButtonFormField(
            height: 70,
            requiredLabelText:
                AppWidgetUtils.labelTextWithRequired(AppConstants.empType),
            dropDownItems: empType!,
            validator: (value) {
              return InputValidations.empTypeValidation(value ?? '');
            },
            hintText: AppConstants.exSelect,
            onChange: (String? newValue) {
              _createEmployeeDialogBlocImpl.selectedEmpType = newValue ?? '';
            },
          ),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        Expanded(
          child: CustomDropDownButtonFormField(
            height: 70,
            requiredLabelText:
                AppWidgetUtils.labelTextWithRequired(AppConstants.branch),
            dropDownItems: empBranch!,
            hintText: AppConstants.exSelect,
            validator: (value) {
              return InputValidations.branchValidation(value ?? '');
            },
            onChange: (String? newValue) {
              _createEmployeeDialogBlocImpl.selectedEmpBranch = newValue ?? '';
            },
          ),
        )
      ],
    );
  }

  _buildAgeGenderAndCityFields() {
    return Row(
      children: [
        Expanded(
          child: CustomFormField(
              maxLength: 2,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              labelText: AppConstants.age,
              hintText: AppConstants.hintAge,
              controller: _createEmployeeDialogBlocImpl.empAgeController),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 12),
        Expanded(
          child: CustomDropDownButtonFormField(
            //height: 50,
            requiredLabelText:
                AppWidgetUtils.labelTextWithRequired(AppConstants.gender),
            dropDownItems: empGender!,
            hintText: AppConstants.exSelect,
            validator: (value) {
              return InputValidations.genderValidation(value ?? '');
            },
            onChange: (String? newValue) {
              _createEmployeeDialogBlocImpl.selectEmpGender = newValue ?? '';
            },
          ),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 12),
        Expanded(
          flex: 2,
          child: CustomDropDownButtonFormField(
            // height: 50,
            // width: MediaQuery.sizeOf(context).width * 0.3,
            // width: 235,
            requiredLabelText:
                AppWidgetUtils.labelTextWithRequired(AppConstants.city),
            dropDownItems: city!,
            hintText: AppConstants.exSelect,
            validator: (value) {
              return InputValidations.cityValidation(value ?? '');
            },
            onChange: (String? newValue) {
              _createEmployeeDialogBlocImpl.selectEmpCity = newValue ?? '';
            },
          ),
        )
      ],
    );
  }

  _buildMobNoAndAddressFields() {
    return Row(
      children: [
        Expanded(
          child: CustomFormField(
              suffixIcon: SvgPicture.asset(
                colorFilter:
                    ColorFilter.mode(_appColors.primaryColor, BlendMode.srcIn),
                AppConstants.icCall,
                fit: BoxFit.none,
              ),
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              requiredLabelText: AppWidgetUtils.labelTextWithRequired(
                  AppConstants.mobileNumber),
              validator: (value) {
                return InputValidations.mobileNumberValidation(value ?? '');
              },
              hintText: AppConstants.exMobNo,
              controller: _createEmployeeDialogBlocImpl.empMobNoController),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        Expanded(
          child: CustomFormField(
              requiredLabelText:
                  AppWidgetUtils.labelTextWithRequired(AppConstants.address),
              validator: (value) {
                return InputValidations.addressValidation(value ?? '');
              },
              hintText: AppConstants.typeHere,
              controller: _createEmployeeDialogBlocImpl.empaddressController),
        ),
      ],
    );
  }

  _buildSaveButton() {
    return CustomActionButtons(
      buttonText: AppConstants.addEmployee,
      onPressed: () {
        if (_createEmployeeDialogBlocImpl.empFormkey.currentState!
            .validate()) {}
      },
    );
  }
}
