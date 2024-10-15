import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/dash_board/statement_compare_bloc.dart';
import 'package:tlbilling/dash_board/update_statement_dialog_bloc.dart';
import 'package:tlbilling/models/update/update_statement_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlds_flutter/components/tlds_date_picker.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_formaters.dart';

class UpdateStatementDialog extends StatefulWidget {
  final String statemetId;
  final String summaryId;
  final String date;
  final double amount;
  final StatementCompareBlocImpl statementCompareblocImpl;
  const UpdateStatementDialog(
      {super.key,
      required this.statemetId,
      required this.summaryId,
      required this.date,
      required this.statementCompareblocImpl,
      required this.amount});

  @override
  State<UpdateStatementDialog> createState() => _UpdateStatementDialogState();
}

class _UpdateStatementDialogState extends State<UpdateStatementDialog> {
  final _appColors = AppColors();
  final _updateStatementBloc = UpdateStatementDialogBlocImpl();

  @override
  void initState() {
    _updateStatementBloc.amountTextEditController.text =
        widget.amount.toString();
    _updateStatementBloc.dateTextEditController.text =
        AppUtils.apiToAppDateFormat(widget.date);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _updateStatementBloc.loadingStream,
        builder: (context, snapshot) {
          return BlurryModalProgressHUD(
            inAsyncCall: snapshot.data ?? false,
            progressIndicator: AppWidgetUtils.buildLoading(),
            child: AlertDialog(
              backgroundColor: _appColors.whiteColor,
              surfaceTintColor: _appColors.whiteColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.all(10),
              title: AppWidgetUtils.buildDialogFormTitle(
                  context, AppConstants.updateStatement),
              actions: [_buildSaveButton()],
              content: _buildFormContent(context),
            ),
          );
        });
  }

  _buildSaveButton() {
    return CustomActionButtons(
        onPressed: () async {
          if (_updateStatementBloc.formKey.currentState?.validate() ?? false) {
            _updateStatementBloc.loadingStreamController(true);
            bool success = await _buildpostData();
            if (success) {
              _buildRefreshData();
            } else {
              _updateStatementBloc.loadingStreamController(false);
            }
          }
        },
        buttonText: AppConstants.update);
  }

  void _buildRefreshData() {
    _updateStatementBloc.loadingStreamController(false);
    Navigator.pop(context);
    AppWidgetUtils.showSuccessToast(AppConstants.statementUpdated);
    widget.statementCompareblocImpl.isUpdated = true;
    widget.statementCompareblocImpl.tableRefreshStreamController(true);
  }

  Future<bool> _buildpostData() async {
    bool success = await _updateStatementBloc.updateStatementSummary(
        widget.statemetId,
        UpdateStatementModel(
            amount: double.tryParse(
                    _updateStatementBloc.amountTextEditController.text) ??
                0,
            checkNo: _updateStatementBloc.chequeTextEditingController.text,
            summaryId: widget.summaryId,
            description:
                _updateStatementBloc.descriptionTextEditController.text));
    return success;
  }

  _buildFormContent(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.3,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _updateStatementBloc.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDatePicker(),
              AppWidgetUtils.buildSizedBox(custHeight: 5),
              _buildDescriptionField(),
              AppWidgetUtils.buildSizedBox(custHeight: 5),
              _buildChequeAndAmt()
            ],
          ),
        ),
      ),
    );
  }

  Row _buildChequeAndAmt() {
    return Row(
      children: [
        _buildChequeField(),
        AppWidgetUtils.buildSizedBox(custWidth: 5),
        _buildAmtField(),
      ],
    );
  }

  Expanded _buildAmtField() {
    return Expanded(
      child: TldsInputFormField(
        controller: _updateStatementBloc.amountTextEditController,
        hintText: AppConstants.amount,
        inputFormatters: TldsInputFormatters.onlyAllowDecimalAfterTwoDigits,
        labelText: AppConstants.amount,
        validator: (value) {
          if (value?.isEmpty ?? false) {
            return AppConstants.requiredField;
          }
          return null;
        },
      ),
    );
  }

  Expanded _buildChequeField() {
    return Expanded(
      child: TldsInputFormField(
        controller: _updateStatementBloc.chequeTextEditingController,
        hintText: AppConstants.cheque,
        inputFormatters: TldsInputFormatters.onlyAllowAlphabetAndNumber,
        labelText: AppConstants.cheque,
      ),
    );
  }

  TldsInputFormField _buildDescriptionField() {
    return TldsInputFormField(
      maxLine: 100,
      height: 92,
      controller: _updateStatementBloc.descriptionTextEditController,
      hintText: AppConstants.describtion,
      labelText: AppConstants.describtion,
      validator: (value) {
        if (value?.isEmpty ?? false) {
          return AppConstants.requiredField;
        }
        return null;
      },
    );
  }

  TldsDatePicker _buildDatePicker() {
    return TldsDatePicker(
      controller: _updateStatementBloc.dateTextEditController,
      firstDate: DateTime(2000),
      enabled: true,
      requiredLabelText: const Text(AppConstants.date),
      validator: (value) {
        if (value?.isEmpty ?? false) {
          return AppConstants.requiredField;
        }
        return null;
      },
    );
  }
}
