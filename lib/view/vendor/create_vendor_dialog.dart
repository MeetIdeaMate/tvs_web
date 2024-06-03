import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/components/custom_form_field.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlbilling/utils/input_validation.dart';
import 'package:tlbilling/view/vendor/create_vendor_dialog_bloc.dart';
import 'package:tlbilling/view/vendor/vendor_view_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:tlds_flutter/export.dart' as tlds;
import 'package:toastification/toastification.dart';

class CreateVendorDialog extends StatefulWidget {
  final String? vendorId;
  final VendorViewBlocImpl? vendorViewBlocImpl;

  const CreateVendorDialog({super.key, this.vendorViewBlocImpl, this.vendorId});

  @override
  State<CreateVendorDialog> createState() => _CreateVendorDialogState();
}

class _CreateVendorDialogState extends State<CreateVendorDialog> {
  final _appColors = AppColors();
  final _createVendorDialogBlocImpl = CreateVendorDialogBlocImpl();
  bool _isLoading = false;

  void _isLoadingState({required bool state}) {
    setState(() {
      _isLoading = state;
    });
  }

  @override
  void initState() {
    super.initState();
    _buildGetVendorDetailsById();
  }

  void _buildGetVendorDetailsById() {
    _createVendorDialogBlocImpl
        .getVendorById(widget.vendorId ?? '')
        .then((value) {
      _createVendorDialogBlocImpl.vendorAccNoController.text =
          value?.accountNo ?? '';
      _createVendorDialogBlocImpl.vendorAddressController.text =
          value?.address ?? '';
      _createVendorDialogBlocImpl.vendorCityController.text = value?.city ?? '';
      _createVendorDialogBlocImpl.vendorEmailIdcontroller.text =
          value?.emailId ?? '';
      _createVendorDialogBlocImpl.vendorMobNoController.text =
          value?.mobileNo ?? '';
      _createVendorDialogBlocImpl.vendorGstNoController.text =
          value?.gstNumber ?? '';
      _createVendorDialogBlocImpl.vendorIFSCCodeController.text =
          value?.ifscCode ?? '';
      _createVendorDialogBlocImpl.vendorNameTextController.text =
          value?.vendorName ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: AppWidgetUtils.buildLoading(),
      child: AlertDialog(
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
      ),
    );
  }

  _buildVendorFormTitle() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                widget.vendorId == null
                    ? AppConstants.addVendor
                    : AppConstants.updateVendor,
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
            _gstNoAndNoFields(),
            AppWidgetUtils.buildSizedBox(custHeight: 13),
            _accNoAndIFSCNoFields(),
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
          child: TldsInputFormField(
              inputFormatters: tlds.TldsInputFormatters.onlyAllowAlphabets,
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
          child: TldsInputFormField(
              maxLength: 10,
              counterText: '',
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
        _buildEmailFields(),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        Expanded(
          child: TldsInputFormField(
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

  _gstNoAndNoFields() {
    return Row(
      children: [
        Expanded(
          child: TldsInputFormField(
              maxLength: 15,
              counterText: '',
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9 A-Z a-z]")),
              ],
              requiredLabelText:
                  AppWidgetUtils.labelTextWithRequired(AppConstants.gstNo),
              validator: (value) {
                return InputValidations.gstNumberValidation(value ?? '');
              },
              hintText: AppConstants.hintGst,
              controller: _createVendorDialogBlocImpl.vendorGstNoController),
        ),
      ],
    );
  }

  _buildEmailFields() {
    return Expanded(
      child: TldsInputFormField(
          inputFormatters: TlInputFormatters.emailFormat,
          labelText: AppConstants.emailAddress,
          hintText: AppConstants.hintMail,
          controller: _createVendorDialogBlocImpl.vendorEmailIdcontroller),
    );
  }

  _buildAddressFields() {
    return TldsInputFormField(
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
      buttonText: widget.vendorId != null
          ? AppConstants.updateVendor
          : AppConstants.addVendor,
      onPressed: () {
        if (_createVendorDialogBlocImpl.vendorFormKey.currentState!
            .validate()) {
          if (widget.vendorId != null) {
            _buildUpdateVendor();
          } else {
            _buildCreateVendor();
          }
        }
      },
    );
  }

  void _buildUpdateVendor() {
    _createVendorDialogBlocImpl.updateVendor(widget.vendorId ?? '',
        (statusCode) {
      if (statusCode == 200 || statusCode == 201) {
        _isLoadingState(state: false);

        Navigator.pop(context);
        AppWidgetUtils.buildToast(
            context,
            ToastificationType.success,
            AppConstants.vendorUpdate,
            Icon(
              Icons.check_circle_outline_rounded,
              color: _appColors.successColor,
            ),
            AppConstants.vendorUpdateSuccessfully,
            _appColors.successLightColor);
        widget.vendorViewBlocImpl?.pageNumberUpdateStreamController(0);
      } else {
        _isLoadingState(state: false);
        AppWidgetUtils.buildToast(
            context,
            ToastificationType.error,
            AppConstants.vendorUpdate,
            Icon(
              Icons.error_outline_outlined,
              color: _appColors.errorColor,
            ),
            AppConstants.somethingWentWrong,
            _appColors.errorLightColor);
      }
    });
  }

  void _buildCreateVendor() {
    _createVendorDialogBlocImpl.addVendor((statusCode) {
      _isLoadingState(state: true);

      if (statusCode == 200 || statusCode == 201) {
        _isLoadingState(state: false);

        Navigator.pop(context);
        AppWidgetUtils.buildToast(
            context,
            ToastificationType.success,
            AppConstants.vendorCreate,
            Icon(
              Icons.check_circle_outline_rounded,
              color: _appColors.successColor,
            ),
            AppConstants.vendorCreatedSuccessfully,
            _appColors.successLightColor);
        widget.vendorViewBlocImpl?.pageNumberUpdateStreamController(0);
      } else {
        _isLoadingState(state: false);
        AppWidgetUtils.buildToast(
            context,
            ToastificationType.error,
            AppConstants.employeeCreate,
            Icon(
              Icons.error_outline_outlined,
              color: _appColors.errorColor,
            ),
            AppConstants.somethingWentWrong,
            _appColors.errorLightColor);
      }
    });
  }

  _accNoAndIFSCNoFields() {
    return Row(
      children: [
        Expanded(
          child: TldsInputFormField(
              inputFormatters: TlInputFormatters.onlyAllowNumbers,
              maxLength: 18,
              counterText: '',
              //   minLength : 7,
              labelText: AppConstants.accNo,
              hintText: AppConstants.hintAccNo,
              controller: _createVendorDialogBlocImpl.vendorAccNoController),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        Expanded(
          child: TldsInputFormField(
              maxLength: 11,
              counterText: '',
              inputFormatters: TlInputFormatters.onlyAllowAlphabetAndNumber,
              labelText: AppConstants.ifscNo,
              hintText: AppConstants.enterIfscCode,
              controller: _createVendorDialogBlocImpl.vendorIFSCCodeController),
        ),
      ],
    );
  }
}
