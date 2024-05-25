import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/components/custom_dropdown_button_form_field.dart';
import 'package:tlbilling/components/custom_form_field.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/input_validation.dart';
import 'package:tlbilling/view/employee/create_employee_dialog.dart';
import 'package:tlbilling/view/user/create_user_dialog_bloc.dart';

class CreateUserDialog extends StatefulWidget {
  const CreateUserDialog({super.key});

  @override
  State<CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  final _appColors = AppColors();
  final _createUserDialogBlocImpl = CreateUserDialogBlocImpl();
  List<String>? username = ['muthu', 'Laskhu'];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _appColors.whiteColor,
      surfaceTintColor: _appColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.all(10),
      title: _buildUserFormTitle(),
      actions: [
        _buildSaveButton(),
      ],
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.4,
        height: 250,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: _buildUserCreateForm(),
        ),
      ),
    );
  }

  _buildUserFormTitle() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppWidgetUtils.buildText(
              text: AppConstants.addUser,
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

  _buildUserCreateForm() {
    return Form(
      key: _createUserDialogBlocImpl.userFormKey,
      child: Column(
        children: [
          AppWidgetUtils.buildSizedBox(custHeight: 10),
          _buildUserNameAndMobNoFields(),
          AppWidgetUtils.buildSizedBox(custHeight: 13),
          _buildDesignationAndPasswordFields(),
        ],
      ),
    );
  }

  _buildUserNameAndMobNoFields() {
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: CustomDropDownButtonFormField(
                  height: 48,
                  requiredLabelText: AppWidgetUtils.labelTextWithRequired(
                      AppConstants.username),
                  dropDownItems: username!,
                  hintText: AppConstants.exSelect,
                  validator: (value) {
                    return InputValidations.userNameValidation(value ?? '');
                  },
                  onChange: (String? newValue) {
                    _createUserDialogBlocImpl.selectedUserName = newValue;
                  },
                ),
              ),
              AppWidgetUtils.buildSizedBox(custWidth: 6),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: IconButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(_appColors.primaryColor),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const CreateEmployeeDialog(),
                      );
                    },
                    icon: SvgPicture.asset(
                      AppConstants.icaddUser,
                    )),
              ),
            ],
          ),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        Expanded(
          child: CustomFormField(
              inputFormat: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 10,
              suffixIcon: SvgPicture.asset(
                colorFilter:
                    ColorFilter.mode(_appColors.primaryColor, BlendMode.srcIn),
                AppConstants.icCall,
                fit: BoxFit.none,
              ),
              requiredLabelText: AppWidgetUtils.labelTextWithRequired(
                  AppConstants.mobileNumber),
              validator: (value) {
                return InputValidations.mobileNumberValidation(value ?? '');
              },
              hintText: AppConstants.hintMobileNo,
              controller: _createUserDialogBlocImpl.mobileNoTextController),
        ),
      ],
    );
  }

  _buildDesignationAndPasswordFields() {
    return Row(
      children: [
        Expanded(
          child: CustomDropDownButtonFormField(
            height: 48,
            requiredLabelText:
                AppWidgetUtils.labelTextWithRequired(AppConstants.designation),
            dropDownItems: username!,
            validator: (value) {
              return InputValidations.designationValidation(value ?? '');
            },
            hintText: AppConstants.exSelect,
            onChange: (String? newValue) {
              _createUserDialogBlocImpl.selectedDesignation = newValue;
            },
          ),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        Expanded(
            child: StreamBuilder<bool>(
                stream: _createUserDialogBlocImpl.passwordVisibleStream,
                builder: (context, snapshot) {
                  return CustomFormField(
                    labelText: AppConstants.passwordLable,
                    controller: _createUserDialogBlocImpl.passwordController,
                    hintText: AppConstants.passwordLable,
                    obscure: !_createUserDialogBlocImpl.ispasswordVisible,
                    suffixIcon: IconButton(
                      onPressed: () {
                        _createUserDialogBlocImpl.ispasswordVisible =
                            !_createUserDialogBlocImpl.ispasswordVisible;
                        _createUserDialogBlocImpl
                            .passwordVisbleStreamControler(true);
                      },
                      icon: Icon(
                          _createUserDialogBlocImpl.ispasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: _appColors.greyColor),
                    ),
                    validator: (validation) =>
                        InputValidations.passwordValidation(validation!),
                  );
                })),
      ],
    );
  }

  _buildSaveButton() {
    return CustomActionButtons(
      buttonText: AppConstants.addUser,
      onPressed: () {
        if (_createUserDialogBlocImpl.userFormKey.currentState!.validate()) {}
      },
    );
  }
}
