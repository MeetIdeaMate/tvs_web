import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/components/custom_form_field.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/input_validation.dart';
import 'package:tlbilling/view/transport/create_transport_dialog_bloc.dart';

class CreateTransportDialog extends StatefulWidget {
  const CreateTransportDialog({super.key});

  @override
  State<CreateTransportDialog> createState() =>
      _CreateTransportDialogDialogState();
}

class _CreateTransportDialogDialogState extends State<CreateTransportDialog> {
  final _appColors = AppColors();
  final _createTransportBlocImpl = CreateTransportBlocImpl();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _appColors.whiteColor,
      surfaceTintColor: _appColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.all(10),
      title: _buildTransportFormTitle(),
      actions: [
        _buildSaveButton(),
      ],
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.4,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: _buildTransportCreateForm(),
        ),
      ),
    );
  }

  _buildTransportFormTitle() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppConstants.addTransport,
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

  _buildTransportCreateForm() {
    return SingleChildScrollView(
      child: Form(
        key: _createTransportBlocImpl.transportFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppWidgetUtils.buildSizedBox(custHeight: 10),
            transportNameFeilds(),
            AppWidgetUtils.buildSizedBox(custHeight: 13),
            mobNoAndCityFeilds(),
            AppWidgetUtils.buildSizedBox(custHeight: 13),
          ],
        ),
      ),
    );
  }

  _buildSaveButton() {
    return CustomActionButtons(
      buttonText: AppConstants.addTransport,
      onPressed: () {
        if (_createTransportBlocImpl.transportFormKey.currentState!
            .validate()) {}
      },
    );
  }

  transportNameFeilds() {
    return CustomFormField(
        width: MediaQuery.sizeOf(context).width * 0.188,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[a-z A-Z 0-9 @]")),
        ],
        requiredLabelText:
            AppWidgetUtils.labelTextWithRequired(AppConstants.transportName),
        validator: (value) {
          return InputValidations.nameValidation(value ?? '');
        },
        hintText: AppConstants.hintName,
        controller: _createTransportBlocImpl.transportNameController);
  }

  mobNoAndCityFeilds() {
    return Row(
      children: [
        Expanded(
          child: CustomFormField(
              inputFormat: [FilteringTextInputFormatter.digitsOnly],
              requiredLabelText: AppWidgetUtils.labelTextWithRequired(
                  AppConstants.mobileNumber),
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                return InputValidations.mobileNumberValidation(value ?? '');
              },
              hintText: AppConstants.hintMobileNo,
              controller: _createTransportBlocImpl.transportMobNoController),
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
              controller: _createTransportBlocImpl.transportCityController),
        ),
      ],
    );
  }
}
