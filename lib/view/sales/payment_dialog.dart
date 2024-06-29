import 'dart:html';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlbilling/view/sales/sales_view_bloc.dart';
import 'package:tlds_flutter/components/tlds_date_picker.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';

class PaymentDailog extends StatefulWidget {
  final SalesViewBlocImpl salesViewBloc;
  const PaymentDailog(
      {super.key, required this.salesViewBloc, int? totalInvAmt});

  @override
  State<PaymentDailog> createState() => _PaymentDailogState();
}

class _PaymentDailogState extends State<PaymentDailog> {
  final _appColors = AppColors();
  bool _isLoading = false;

  void _isLoadingState({required bool state}) {
    setState(() {
      _isLoading = state;
      widget.salesViewBloc.totalInvAmtPaymentController.text =
          totalInvAmt.toString();
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
  }

  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: AppWidgetUtils.buildLoading(),
      color: _appColors.whiteColor,
      child: AlertDialog(
        backgroundColor: _appColors.whiteColor,
        surfaceTintColor: _appColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.all(10),
        title: _buildPaymentFormTitle(),
        actions: [
          _buildSaveButton(),
        ],
        content: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.4,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: _buildPaymentForm(),
          ),
        ),
      ),
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
    return CustomActionButtons(onPressed: () {}, buttonText: AppConstants.save);
  }

  _buildPaymentForm() {
    return SingleChildScrollView(
      child: Form(
        key: widget.salesViewBloc.paidAmtFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppWidgetUtils.buildSizedBox(custHeight: 10),
            totalInvAmt(),
            AppWidgetUtils.buildSizedBox(custHeight: 13),
            paymentDetails(),
            AppWidgetUtils.buildSizedBox(custHeight: 13),
            // balanceAmt(),
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
            labelText: AppConstants.totalInvAmount,
            controller: widget.salesViewBloc.totalInvAmtPaymentController,
            enabled: true,
          ),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 5),
        Expanded(
          child: TldsDatePicker(
            requiredLabelText:
                AppWidgetUtils.labelTextWithRequired(AppConstants.date),
            controller: widget.salesViewBloc.paymentDateTextController,
            height: 50,
          ),
        )
      ],
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
                // height: 40,
                width: double.infinity,
                onChange: (value) {
                  setState(() {
                    widget.salesViewBloc.selectedPaymentName = value;
                  });

                  //  widget.addSalesBloc.isSplitPaymentStreamController(true);
                },
              ),
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
                  double balanceAmt = totalInv - paidAmt;
                  widget.salesViewBloc.balanceAmtController.text =
                      balanceAmt.toString();
                },
              ),
            ),
            AppWidgetUtils.buildSizedBox(custWidth: 5),
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
          controller: widget.salesViewBloc.balanceAmtController),
    );
  }
}
