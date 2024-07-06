import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/models/get_model/get_all_sales_list_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlbilling/view/sales/payment_history.dart';
import 'package:tlbilling/view/sales/sales_view_bloc.dart';
import 'package:tlds_flutter/components/tlds_date_picker.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:toastification/toastification.dart';

class PaymentDailog extends StatefulWidget {
  final SalesViewBlocImpl salesViewBloc;
  final double? totalInvAmt;
  final Content? salesdata;
  const PaymentDailog(
      {super.key,
      required this.salesViewBloc,
      required this.totalInvAmt,
      required this.salesdata});

  @override
  State<PaymentDailog> createState() => _PaymentDailogState();
}

class _PaymentDailogState extends State<PaymentDailog> {
  final _appColors = AppColors();
  bool _isLoading = false;

  void _isLoadingState({required bool state}) {
    setState(() {
      _isLoading = state;
    });
  }

  List<String>? _paymentsListFuture;

  @override
  void initState() {
    super.initState();

    widget.salesViewBloc.getPaymentsList().then((value) {
      setState(() {
        _paymentsListFuture = value?.configuration ?? [];
      });
    });
    widget.salesViewBloc.totalInvAmtPaymentController.text =
        widget.salesdata?.pendingAmt?.toString() ?? '';
    widget.salesViewBloc.paymentDateTextController.text =
        DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  @override
  void dispose() {
    widget.salesViewBloc.paidAmountTextController.clear();
    widget.salesViewBloc.balanceAmtController.clear();
    widget.salesViewBloc.paymentDateTextController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: AppWidgetUtils.buildLoading(),
      color: _appColors.whiteColor,
      child: StreamBuilder<bool>(
          stream: widget.salesViewBloc.paymentDialogStream,
          builder: (context, snapshot) {
            return AlertDialog(
              backgroundColor: _appColors.whiteColor,
              surfaceTintColor: _appColors.whiteColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.all(10),
              title: _buildPaymentFormTitle(),
              actions: [
                _buildSaveButton(),
              ],
              content: SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.4,
                child: _buildPaymentForm(),
              ),
            );
          }),
    );
  }

  _buildPaymentFormTitle() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppConstants.payments,
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

  _buildSaveButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildShowHistoryButton(),
        CustomActionButtons(
            onPressed: widget.salesdata?.paymentStatus == 'PENDING'
                ? () {
                    if (widget.salesViewBloc.paidAmtFormKey.currentState!
                        .validate()) {
                      _isLoadingState(state: true);
                      widget.salesViewBloc.salesPaymentUpdate(
                          AppUtils.appToAPIDateFormat(widget
                              .salesViewBloc.paymentDateTextController.text),
                          widget.salesViewBloc.selectedPaymentName ?? 'CASH',
                          double.tryParse(widget.salesViewBloc
                                  .paidAmountTextController.text) ??
                              0,
                          widget.salesdata?.salesId ?? '',
                          widget.salesViewBloc.reasonTextEditingController.text,
                          (statusCode) {
                        if (statusCode == 200 || statusCode == 201) {
                          _isLoadingState(state: false);
                          Navigator.pop(context);
                          widget.salesViewBloc
                              .pageNumberUpdateStreamController(0);
                          AppWidgetUtils.buildToast(
                              context,
                              ToastificationType.success,
                              AppConstants.paymentUpdate,
                              Icon(Icons.check_circle_outline_rounded,
                                  color: _appColors.successColor),
                              AppConstants.paymentUpdateSuccessfully,
                              _appColors.successLightColor);
                          widget.salesViewBloc.paidAmountTextController.clear();
                          widget.salesViewBloc.balanceAmtController.clear();
                          widget.salesViewBloc.paymentDateTextController
                              .clear();
                        } else {
                          _isLoadingState(state: false);
                          AppWidgetUtils.buildToast(
                              context,
                              ToastificationType.success,
                              AppConstants.paymentUpdate,
                              Icon(Icons.check_circle_outline_rounded,
                                  color: _appColors.successColor),
                              AppConstants.somethingWentWrong,
                              _appColors.successLightColor);
                        }
                      });
                    }
                  }
                : () {},
            buttonText: AppConstants.save),
      ],
    );
  }

  _buildShowHistoryButton() {
    return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) =>
                PaymentHistoryDialog(salesdata: widget.salesdata),
          );
        },
        icon: const Icon(Icons.history));
  }

  _buildPaymentForm() {
    return SingleChildScrollView(
      child: Form(
        key: widget.salesViewBloc.paidAmtFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // AppWidgetUtils.buildSizedBox(custHeight: 10),
            totalInvAmt(),
            //  AppWidgetUtils.buildSizedBox(custHeight: 5),
            paymentDetails(),
            AppWidgetUtils.buildSizedBox(custHeight: 8),
            _buildReason(),
          ],
        ),
      ),
    );
  }

  totalInvAmt() {
    return Row(
      children: [
        Expanded(
          child: TldsInputFormField(
            readOnly: true,
            labelText: AppConstants.pendingInvAmt,
            controller: widget.salesViewBloc.totalInvAmtPaymentController,
            enabled: true,
            validator: (value) {
              var values = double.tryParse(value.toString()) ?? 0;
              if ((values <= 0)) {
                return 'dont pay payment is completed';
              }
              return null;
            },
          ),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 5),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TldsDatePicker(
              requiredLabelText:
                  AppWidgetUtils.labelTextWithRequired(AppConstants.date),
              controller: widget.salesViewBloc.paymentDateTextController,
              height: 70,
              hintText: AppConstants.date,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Select date';
                }
                return null;
              },
            ),
          ),
        )
      ],
    );
  }

  _buildReason() {
    return TldsInputFormField(
      maxLine: 100,
      height: 80,
      controller: widget.salesViewBloc.reasonTextEditingController,
      hintText: AppConstants.reason,
      labelText: AppConstants.reason,
    );
  }

  paymentDetails() {
    return Column(
      children: [
        _paymentsListFuture?.isEmpty == true
            ? const Center(child: Text('No payments available'))
            : TldsDropDownButtonFormField(
                labelText: AppConstants.paymentTypes,
                dropDownItems: _paymentsListFuture ?? [],
                dropDownValue: widget.salesViewBloc.selectedPaymentName,
                hintText: '',
                width: double.infinity,
                onChange: (value) {
                  widget.salesViewBloc.selectedPaymentName = value;
                  widget.salesViewBloc.paymentStreamController(true);
                },
              ),
        AppWidgetUtils.buildSizedBox(custWidth: 8),
        Row(
          children: [
            Expanded(
              child: TldsInputFormField(
                requiredLabelText:
                    AppWidgetUtils.labelTextWithRequired(AppConstants.paidAmt),
                controller: widget.salesViewBloc.paidAmountTextController,
                hintText: AppConstants.amount,
                inputFormatters: TlInputFormatters.onlyAllowDecimalNumbers,
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return AppConstants.enterAmt;
                  }
                  return null;
                },
                onChanged: (value) {
                  double totalInv = double.tryParse(widget
                          .salesViewBloc.totalInvAmtPaymentController.text) ??
                      0;
                  double paidAmt = double.tryParse(
                          widget.salesViewBloc.paidAmountTextController.text) ??
                      0;

                  if (paidAmt > totalInv) {
                    widget.salesViewBloc.paidAmountTextController.text = '';
                    widget.salesViewBloc.balanceAmtController.text = '';
                  }
                  double balanceAmt = totalInv - paidAmt;
                  widget.salesViewBloc.balanceAmtController.text =
                      balanceAmt.toString();
                },
              ),
            ),
            AppWidgetUtils.buildSizedBox(custWidth: 8),
            balanceAmt(),
          ],
        ),
        Visibility(
          visible: ['UPI ', 'CARD', 'CHEQUE']
              .contains(widget.salesViewBloc.selectedPaymentName),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: SizedBox(
              child: TldsInputFormField(
                controller: widget.salesViewBloc.paymentIdTextControler,
                hintText: '${widget.salesViewBloc.selectedPaymentName} ID',
              ),
            ),
          ),
        ),
      ],
    );
  }

  balanceAmt() {
    return Expanded(
      child: TldsInputFormField(
          height: 50,
          labelText: AppConstants.balanceAmt,
          enabled: true,
          readOnly: true,
          controller: widget.salesViewBloc.balanceAmtController),
    );
  }
}
