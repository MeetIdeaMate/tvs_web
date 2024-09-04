import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlbilling/utils/input_validation.dart';
import 'package:tlbilling/view/customer/create_customer_dialog_bloc.dart';
import 'package:tlbilling/view/customer/customer_view_bloc.dart';
import 'package:tlbilling/view/sales/add_sales_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_formaters.dart';
import 'package:tlds_flutter/export.dart' as tlds;
import 'package:toastification/toastification.dart';

class CreateCustomerDialog extends StatefulWidget {
  final String? customerId;
  final AddSalesBlocImpl? bloc;
  final CustomerViewBlocImpl? customerScreenBlocImpl;
  const CreateCustomerDialog(
      {super.key, this.customerId, this.bloc, this.customerScreenBlocImpl});

  @override
  State<CreateCustomerDialog> createState() => _CreateCustomerDialogState();
}

class _CreateCustomerDialogState extends State<CreateCustomerDialog> {
  final _appColors = AppColors();
  final _createCustomerDialogBlocImpl = CreateCustomerDialogBlocImpl();
  bool? isAsyncCall = false;

  @override
  void initState() {
    super.initState();
    _loadCustomerDetails();
    getbranchId();
  }

  Future<void> getbranchId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _createCustomerDialogBlocImpl.branchId =
        prefs.getString(AppConstants.branchId);
  }

  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
        inAsyncCall: isAsyncCall,
        color: _appColors.whiteColor,
        progressIndicator: AppWidgetUtils.buildLoading(),
        child: AlertDialog(
          backgroundColor: _appColors.whiteColor,
          surfaceTintColor: _appColors.whiteColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
        ));
  }

  _buildCustomerFormTitle() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppWidgetUtils.buildText(
              text: widget.customerId == null
                  ? AppConstants.addCustomer
                  : AppConstants.updateCustomer,
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
        key: _createCustomerDialogBlocImpl.customerFormKey,
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
            // CustomElevatedButton(
            //   text: AppConstants.uploadCustomerPhoto,
            //   fontSize: 16,
            //   buttonBackgroundColor: _appColors.primaryColor,
            //   fontColor: _appColors.whiteColor,
            //   preffixIcon: SvgPicture.asset(AppConstants.icCamera),
            // ),
            // AppWidgetUtils.buildSizedBox(custHeight: 13),
          ],
        ),
      ),
    );
  }

  _buildAddressFields() {
    return TldsInputFormField(
      maxLine: 100,
      height: 92,
      controller: _createCustomerDialogBlocImpl.customerAddressTextController,
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
      child: TldsInputFormField(
          maxLength: 10,
          counterText: '',
          requiredLabelText:
              AppWidgetUtils.labelTextWithRequired(AppConstants.mobileNumber),
          validator: (value) {
            return InputValidations.mobileNumberValidation(value ?? '');
          },
          inputFormatters: tlds.TldsInputFormatters.onlyAllowNumbers,
          hintText: AppConstants.hintMobileNo,
          controller:
              _createCustomerDialogBlocImpl.customerMobileNoTextController),
    );
  }

  _buildNameField() {
    return Expanded(
      child: TldsInputFormField(
          inputFormatters: tlds.TldsInputFormatters.allowAlphabetsAndSpaces,
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
          child: TldsInputFormField(
              validator: (value) {
                return InputValidations.mailValidation(value ?? '');
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r"^[a-z0-9.@]+")),
              ],
              hintText: AppConstants.hintMail,
              labelText: AppConstants.mailid,
              controller:
                  _createCustomerDialogBlocImpl.customerMailIdTextController),
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
              controller:
                  _createCustomerDialogBlocImpl.customerCitytextcontroller),
        )
      ],
    );
  }

  aadharAndPanNoFields() {
    return Row(
      children: [
        Expanded(
          child: TldsInputFormField(
              inputFormatters: TlInputFormatters.onlyAllowNumbers,
              validator: (value) {
                return InputValidations.aadharValidation(value!);
              },
              maxLength: 12,
              counterText: '',
              hintText: AppConstants.hintAadharNo,
              labelText: AppConstants.aadharNo,
              controller:
                  _createCustomerDialogBlocImpl.customerAadharNoTextController),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        Expanded(
          child: TldsInputFormField(
              onChanged: (String value) {
                AppUtils.toUppercase(
                    value: value,
                    textEditingController: _createCustomerDialogBlocImpl
                        .customerAccNoTextController);
              },
              maxLength: 10,
              counterText: '',
              hintText: AppConstants.hintPanNo,
              labelText: AppConstants.panNo,
              inputFormatters: TlInputFormatters.onlyAllowAlphabetAndNumber,
              validator: (value) {
                return InputValidations.panValidation(value!);
              },
              controller:
                  _createCustomerDialogBlocImpl.customerAccNoTextController),
        )
      ],
    );
  }

  _buildSaveButton() {
    return CustomActionButtons(
      buttonText: widget.customerId == null
          ? AppConstants.addCustomer
          : AppConstants.updateCustomer,
      onPressed: () {
        if (_createCustomerDialogBlocImpl.customerFormKey.currentState!
            .validate()) {
          _isLoading(true);
          if (widget.customerId != null) {
            return _createCustomerDialogBlocImpl.updateCustomer(
              widget.customerId ?? '',
              (statusCode) {
                if (statusCode == 200 || statusCode == 201) {
                  _isLoading(false);
                  widget.customerScreenBlocImpl?.customerTableStream(true);
                  widget.customerScreenBlocImpl
                      ?.pageNumberUpdateStreamController(0);
                  Navigator.pop(context);
                  AppWidgetUtils.buildToast(
                      context,
                      ToastificationType.success,
                      AppConstants.customerUpdate,
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: _appColors.successColor,
                      ),
                      AppConstants.customerUpdateSuccessfully,
                      _appColors.successLightColor);
                } else {
                  _isLoading(false);
                }
              },
            );
          } else {
            return _createCustomerDialogBlocImpl
                .addCustomer((statusCode, customerName, customerId) {
              if (statusCode == 200 || statusCode == 201) {
                _isLoading(false);
                widget.customerScreenBlocImpl?.customerTableStream(true);
                widget.customerScreenBlocImpl
                    ?.pageNumberUpdateStreamController(0);
                Navigator.pop(context);

                AppWidgetUtils.buildToast(
                    context,
                    ToastificationType.success,
                    AppConstants.customerCreate,
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: _appColors.successColor,
                    ),
                    AppConstants.customerCreatedSuccessfully,
                    _appColors.successLightColor);
                widget.bloc?.selectedCustomerDetailsStreamController(true);
                widget.bloc?.selectedCustomer = customerName ?? '';
                widget.bloc?.selectedCustomerId = customerId ?? '';
                widget.bloc?.customerNameStreamcontroller(true);
                widget.bloc?.selectedCustomerDetailsStreamController(true);
                widget.customerScreenBlocImpl?.customerTableStream(true);
                widget.customerScreenBlocImpl
                    ?.pageNumberUpdateStreamController(0);
              } else {
                _isLoading(false);
              }
            });
          }
        }
      },
    );
  }

  _isLoading(bool? isLoadingState) {
    setState(() {
      isAsyncCall = isLoadingState;
    });
  }

  void _loadCustomerDetails() async {
    _createCustomerDialogBlocImpl
        .getCustomerDetails(widget.customerId ?? '')
        .then((customerData) {
      _createCustomerDialogBlocImpl.customerNameTextController.text =
          customerData?.customerName ?? '';
      _createCustomerDialogBlocImpl.customerMailIdTextController.text =
          customerData?.emailId ?? '';
      _createCustomerDialogBlocImpl.customerCitytextcontroller.text =
          customerData?.city ?? '';
      _createCustomerDialogBlocImpl.customerMobileNoTextController.text =
          customerData?.mobileNo ?? '';
      _createCustomerDialogBlocImpl.customerAadharNoTextController.text =
          customerData?.aadharNo ?? '';
      _createCustomerDialogBlocImpl.customerAddressTextController.text =
          customerData?.address ?? '';
      _createCustomerDialogBlocImpl.customerAccNoTextController.text =
          customerData?.accountNo ?? '';
    });
  }
}
