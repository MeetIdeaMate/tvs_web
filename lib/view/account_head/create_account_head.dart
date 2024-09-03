import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/account_head/account_head_view_bloc.dart';
import 'package:tlbilling/view/account_head/create_account_head_bloc.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_formaters.dart';
import 'package:toastification/toastification.dart';

class CreateAccountHead extends StatefulWidget {
  final String? accountCode;

  final String? accountId;

  final AccountViewBlocImpl? accountHeadBloc;
  const CreateAccountHead(
      {super.key, this.accountCode, this.accountId, this.accountHeadBloc});

  @override
  State<CreateAccountHead> createState() => _CreateAccountHeadState();
}

class _CreateAccountHeadState extends State<CreateAccountHead> {
  final AppColors _appColors = AppColors();
  final _createAccountBlocImpl = CreateAccountBlocImpl();

  bool isLoading = false;

  void _isLoadingState({required bool state}) {
    setState(() {
      isLoading = state;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.accountCode != null) {
      _getEditAccountDetailsById();
    }
  }

  void _getEditAccountDetailsById() {
    _createAccountBlocImpl
        .getAccountHeadById(widget.accountCode ?? '')
        .then((value) {
      _createAccountBlocImpl.accountCodeTextEditController.text =
          value?.accountHeadCode ?? '';

      _createAccountBlocImpl.accountNameTextEditController.text =
          value?.accountHeadName ?? '';

      _createAccountBlocImpl.selectedAccountHeadType = value?.accountType ?? '';

      _createAccountBlocImpl.selectedPricingFormat = value?.pricingFormat ?? '';

      _createAccountBlocImpl.flatAmtTextEditController.text =
          value?.maxAmount?.toStringAsFixed(2) ?? '';

      _createAccountBlocImpl.selectedTransferFrom = value?.transferFrom ?? '';

      _createAccountBlocImpl.isPrint = value?.needPrinting ?? false;

      _createAccountBlocImpl.iscashierRequired = value?.cashierOps ?? false;

      _createAccountBlocImpl.checkBoxOnChangeStreamController(true);
      _createAccountBlocImpl.radioOnchangeStreamController(true);
      _createAccountBlocImpl.transfterFromStreamController(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
      inAsyncCall: false,
      progressIndicator: AppWidgetUtils.buildLoading(),
      child: AlertDialog(
        backgroundColor: _appColors.whiteColor,
        surfaceTintColor: _appColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.all(10),
        title: AppWidgetUtils.buildDialogFormTitle(
            context,
            widget.accountCode?.isNotEmpty ?? false
                ? AppConstants.updateAccountHead
                : AppConstants.newAccountHead),
        actions: [
          _buildSaveButton(),
        ],
        content: SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: _buildAccountHeadCreateForm(),
          ),
        ),
      ),
    );
  }

  _buildAccountHeadCreateForm() {
    return SingleChildScrollView(
      child: Form(
        key: _createAccountBlocImpl.formkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppWidgetUtils.buildSizedBox(custHeight: 10),
            _buildAccCodeAndAccNameFields(),
            _buildAccHeadtypeAndPricingFormat(),
            AppWidgetUtils.buildSizedBox(custHeight: 13),
            _buildFlatAmtAndCheckBox(),
            AppWidgetUtils.buildSizedBox(custHeight: 13),
            _buildTransferForm(),
            AppWidgetUtils.buildSizedBox(custHeight: 13),
          ],
        ),
      ),
    );
  }

  _buildAccCodeAndAccNameFields() {
    return StreamBuilder<bool>(
        stream: _createAccountBlocImpl.radioOnchangeStream,
        builder: (context, snapshot) {
          return Row(
            children: [
              _buildAccCodeFields(),
              AppWidgetUtils.buildSizedBox(custWidth: 14),
              _buildAccNameFields(),
            ],
          );
        });
  }

  _buildAccCodeFields() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: TldsInputFormField(
            inputFormatters: TldsInputFormatters.onlyAllowAlphabetAndNumber,
            requiredLabelText: AppWidgetUtils.labelTextWithRequired(
              AppConstants.accountCode,
            ),
            hintText: AppConstants.exPan,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppConstants.requiredField;
              }
              return null;
            },
            controller: _createAccountBlocImpl.accountCodeTextEditController),
      ),
    );
  }

  _buildAccNameFields() {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: TldsInputFormField(
            inputFormatters: TldsInputFormatters.onlyAllowAlphabets,
            requiredLabelText: AppWidgetUtils.labelTextWithRequired(
              AppConstants.accountName,
            ),
            hintText: AppConstants.exName,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppConstants.requiredField;
              }
              return null;
            },
            controller: _createAccountBlocImpl.accountNameTextEditController),
      ),
    );
  }

  _buildAccHeadtypeAndPricingFormat() {
    return StreamBuilder<bool>(
        stream: _createAccountBlocImpl.radioOnchangeStream,
        builder: (context, snapshot) {
          return Row(
            children: [
              _buildAccountHeadType(),
              AppWidgetUtils.buildSizedBox(custWidth: 14),
              _buildAccountPricingFormat()
            ],
          );
        });
  }

  _buildAccountHeadType() {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(AppConstants.accountHeadtype,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Row(
            children: [
              _buildRadioButton(AppConstants.creditC,
                  _createAccountBlocImpl.selectedAccountHeadType ?? '',
                  (value) {
                _createAccountBlocImpl.selectedAccountHeadType = value;
                _createAccountBlocImpl.radioOnchangeStreamController(true);
              }),
              _buildRadioButton(AppConstants.debitC,
                  _createAccountBlocImpl.selectedAccountHeadType ?? '',
                  (value) {
                _createAccountBlocImpl.selectedAccountHeadType = value;
                _createAccountBlocImpl.radioOnchangeStreamController(true);
              }),
            ],
          ),
        ],
      ),
    );
  }

  _buildAccountPricingFormat() {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppConstants.pricingFormat,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              _buildRadioButton(AppConstants.flatC,
                  _createAccountBlocImpl.selectedPricingFormat ?? '', (value) {
                _createAccountBlocImpl.selectedPricingFormat = value;
                _createAccountBlocImpl.radioOnchangeStreamController(true);
              }),
              _buildRadioButton(AppConstants.variableC,
                  _createAccountBlocImpl.selectedPricingFormat ?? '', (value) {
                _createAccountBlocImpl.selectedPricingFormat = value;
                _createAccountBlocImpl.radioOnchangeStreamController(true);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadioButton(
      String text, String groupValue, Function(String?) onChanged) {
    return SizedBox(
      width: 150,
      child: ListTile(
        title: Text(text),
        leading: Radio<String>(
          value: text,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
      ),
    );
  }

  _buildFlatAmtAndCheckBox() {
    return Row(
      children: [
        _buildFlatAmt(),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        _buildCashierAndPrintCheckBox()
      ],
    );
  }

  _buildFlatAmt() {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: TldsInputFormField(
            requiredLabelText:
                AppWidgetUtils.labelTextWithRequired(AppConstants.enterFlatAmt),
            inputFormatters: TldsInputFormatters.onlyAllowDecimalAfterTwoDigits,
            hintText: AppConstants.rupeeHint,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppConstants.requiredField;
              }
              return null;
            },
            controller: _createAccountBlocImpl.flatAmtTextEditController),
      ),
    );
  }

  _buildCashierAndPrintCheckBox() {
    return StreamBuilder<bool>(
        stream: _createAccountBlocImpl.checkBoxOnChangeStream,
        builder: (context, snapshot) {
          return Flexible(
            child: Row(
              children: [
                _buildCheckBox(AppConstants.cashierRequired,
                    _createAccountBlocImpl.iscashierRequired ?? false),
                _buildCheckBox(AppConstants.print,
                    _createAccountBlocImpl.isPrint ?? false),
              ],
            ),
          );
        });
  }

  Widget _buildCheckBox(
    String text,
    bool value,
  ) {
    return SizedBox(
      width: 150,
      child: ListTile(
        title: Text(text),
        leading: Checkbox(
            value: value,
            onChanged: (newValue) {
              if (text == AppConstants.cashierRequired) {
                _createAccountBlocImpl.iscashierRequired = newValue;
                _createAccountBlocImpl.checkBoxOnChangeStreamController(true);
              } else if (text == AppConstants.print) {
                _createAccountBlocImpl.isPrint = newValue;
                _createAccountBlocImpl.checkBoxOnChangeStreamController(true);
              }
            }),
      ),
    );
  }

  _buildTransferForm() {
    return Flexible(
      child: FutureBuilder<List<String>>(
        future: _createAccountBlocImpl.getConfigByIdModel(
            configId: AppConstants.designation),
        builder: (context, snapshot) {
          List<String> designationList = snapshot.data ?? [];

          return StreamBuilder<bool>(
              stream: _createAccountBlocImpl.transfterFromStream,
              builder: (context, streamSnapshot) {
                return TldsDropDownButtonFormField(
                  width: double.infinity,
                  requiredLabelText: AppWidgetUtils.labelTextWithRequired(
                      AppConstants.transferForm),
                  dropDownValue: _createAccountBlocImpl.selectedTransferFrom,
                  dropDownItems:
                      (snapshot.hasData && (snapshot.data?.isNotEmpty == true))
                          ? designationList
                          : List.empty(),
                  hintText:
                      (snapshot.connectionState == ConnectionState.waiting)
                          ? AppConstants.loading
                          : (snapshot.hasError || snapshot.data == null)
                              ? AppConstants.errorLoading
                              : AppConstants.exSelect,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppConstants.requiredField;
                    }
                    return null;
                  },
                  onChange: (String? newValue) {
                    _createAccountBlocImpl.selectedTransferFrom = newValue;
                  },
                );
              });
        },
      ),
    );
  }

  _buildSaveButton() {
    return CustomActionButtons(
      buttonText: widget.accountCode?.isNotEmpty ?? false
          ? AppConstants.updateAccountHead
          : AppConstants.newAccountHead,
      onPressed: () {
        if (_createAccountBlocImpl.formkey.currentState!.validate()) {
          _isLoadingState(state: true);
          if (widget.accountCode != null) {
            return _createAccountBlocImpl.updateAccountHead((statusCode) {
              if (statusCode == 200 || statusCode == 201) {
                _isLoadingState(state: false);

                Navigator.pop(context);

                widget.accountHeadBloc?.pageNumberUpdateStreamController(0);

                AppWidgetUtils.buildToast(
                    context,
                    ToastificationType.success,
                    AppConstants.accountHeadUpdate,
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: _appColors.successColor,
                    ),
                    AppConstants.accountHeadUpdateSuccessfully,
                    _appColors.successLightColor);
              } else {
                _isLoadingState(state: false);
              }
            }, widget.accountId ?? '');
          } else {
            return _createAccountBlocImpl.addAccountHead((statusCode) {
              if (statusCode == 200 || statusCode == 201) {
                _isLoadingState(state: false);

                Navigator.pop(context);
                widget.accountHeadBloc?.pageNumberUpdateStreamController(0);

                AppWidgetUtils.buildToast(
                    context,
                    ToastificationType.success,
                    AppConstants.accountHeadCreated,
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: _appColors.successColor,
                    ),
                    AppConstants.accountHeadCreatedSuccessfully,
                    _appColors.successLightColor);
              } else {
                _isLoadingState(state: false);
              }
            });
          }
        }
      },
    );
  }
}
