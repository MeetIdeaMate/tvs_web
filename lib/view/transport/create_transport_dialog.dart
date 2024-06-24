import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/input_validation.dart';
import 'package:tlbilling/view/transport/create_transport_dialog_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_formaters.dart';
import 'package:tlds_flutter/export.dart' as tlds;
import 'package:toastification/toastification.dart';

class CreateTransportDialog extends StatefulWidget {
  final String? transportId;

  const CreateTransportDialog({super.key, this.transportId});

  @override
  State<CreateTransportDialog> createState() =>
      _CreateTransportDialogDialogState();
}

class _CreateTransportDialogDialogState extends State<CreateTransportDialog> {
  final _appColors = AppColors();
  final _createTransportBlocImpl = CreateTransportBlocImpl();

  @override
  void initState() {
    super.initState();
    _createTransportBlocImpl
        .getTransportDetailById(widget.transportId ?? '')
        .then((value) {
      _createTransportBlocImpl.transportNameController.text =
          value?.transportName ?? '';
      _createTransportBlocImpl.transportMobNoController.text =
          value?.mobileNo ?? '';
      _createTransportBlocImpl.transportCityController.text = value?.city ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
      inAsyncCall: _createTransportBlocImpl.isAsyncCall,
      progressIndicator: AppWidgetUtils.buildLoading(),
      color: _appColors.whiteColor,
      child: AlertDialog(
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
            .validate()) {
          _isLoading(true);
          if (widget.transportId != null) {
            _createTransportBlocImpl.editTransport(
              widget.transportId ?? '',
              (statusCode) {
                if (statusCode == 200 || statusCode == 201) {
                  _isLoading(false);
                  Navigator.pop(context);
                  AppWidgetUtils.buildToast(
                      context,
                      ToastificationType.success,
                      AppConstants.transportUpdate,
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: _appColors.successColor,
                      ),
                      AppConstants.transportUpdatedSuccessFully,
                      _appColors.successLightColor);
                } else {
                  _isLoading(false);
                  AppWidgetUtils.buildToast(
                      context,
                      ToastificationType.error,
                      AppConstants.transportUpdate,
                      Icon(
                        Icons.error_outline_outlined,
                        color: _appColors.errorColor,
                      ),
                      AppConstants.somethingWentWrong,
                      _appColors.errorLightColor);
                }
              },
            );
          } else {
            _createTransportBlocImpl.addTransport(
              (statusCode) {
                if (statusCode == 200 || statusCode == 201) {
                  _isLoading(false);
                  Navigator.pop(context);
                  AppWidgetUtils.buildToast(
                      context,
                      ToastificationType.success,
                      AppConstants.transportCreated,
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: _appColors.successColor,
                      ),
                      AppConstants.transportCreatedSuccessFully,
                      _appColors.successLightColor);
                } else {
                  _isLoading(false);
                  AppWidgetUtils.buildToast(
                      context,
                      ToastificationType.error,
                      AppConstants.transportCreated,
                      Icon(
                        Icons.error_outline_outlined,
                        color: _appColors.errorColor,
                      ),
                      AppConstants.somethingWentWrong,
                      _appColors.errorLightColor);
                }
              },
            );
          }
        }
      },
    );
  }

  transportNameFeilds() {
    return TldsInputFormField(
        width: MediaQuery.sizeOf(context).width * 0.188,
        inputFormatters: tlds.TldsInputFormatters.onlyAllowAlphabetAndNumber,
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
          child: TldsInputFormField(
              requiredLabelText: AppWidgetUtils.labelTextWithRequired(
                  AppConstants.mobileNumber),
              maxLength: 10,
              counterText: '',
              inputFormatters: TldsInputFormatters.onlyAllowNumbers,
              validator: (value) {
                return InputValidations.mobileNumberValidation(value ?? '');
              },
              hintText: AppConstants.hintMobileNo,
              controller: _createTransportBlocImpl.transportMobNoController),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        Expanded(
          child: TldsInputFormField(
              requiredLabelText:
                  AppWidgetUtils.labelTextWithRequired(AppConstants.city),
              validator: (value) {
                return InputValidations.cityValidation(value ?? '');
              },
              inputFormatters: TldsInputFormatters.allowAlphabetsAndSpaces,
              hintText: AppConstants.hintCity,
              controller: _createTransportBlocImpl.transportCityController),
        ),
      ],
    );
  }

  _isLoading(bool state) {
    setState(() {
      _createTransportBlocImpl.isAsyncCall = state;
    });
  }
}
