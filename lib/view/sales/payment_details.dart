import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/models/post_model/add_sales_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlbilling/view/sales/add_sales_bloc.dart';
import 'package:tlbilling/view/sales/customer_details.dart';
import 'package:tlbilling/view/sales/sales_view_bloc.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_formaters.dart';
import 'package:toastification/toastification.dart';

class PaymentDetails extends StatefulWidget {
  final AddSalesBlocImpl addSalesBloc;
  final SalesViewBlocImpl salesViewBloc;

  const PaymentDetails({
    super.key,
    required this.addSalesBloc,
    required this.salesViewBloc,
  });

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  List<String>? _paymentsListFuture;

  @override
  void initState() {
    super.initState();
    getbranchId();

    widget.addSalesBloc.getPaymentsList().then((value) {
      setState(() {
        _paymentsListFuture = value?.configuration ?? [];
        _checkedList =
            List<bool>.filled(_paymentsListFuture?.length ?? 0, false);
      });
    });
  }

  Future<void> getbranchId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    widget.addSalesBloc.branchId = prefs.getString(AppConstants.branchId);
  }

  bool _isLoading = false;

  void _isLoadingState({required bool state}) {
    setState(() {
      _isLoading = state;
    });
  }

  final _appColors = AppColors();
  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: AppWidgetUtils.buildLoading(),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 45, right: 30, left: 30, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomerDetails(
                addSalesBloc: widget.addSalesBloc,
              ),
              if (widget.addSalesBloc.selectedVehicleAndAccessories !=
                  AppConstants.accessories)
                _buildGstDetails(),
              AppWidgetUtils.buildSizedBox(custHeight: 30),
              _buildHeadingText(AppConstants.paymentDetails),
              _buildPaymentDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGstDetails() {
    return StreamBuilder<bool>(
        stream: widget.addSalesBloc.gstDetailsStream,
        builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeadingText(AppConstants.gstDetails),
              AppWidgetUtils.buildSizedBox(custHeight: 10),
              _buildHsnCodeField(),
              AppWidgetUtils.buildSizedBox(custHeight: 10),
              _buildGstRadioBtns(),
            ],
          );
        });
  }

  Widget _buildHsnCodeField() {
    return TldsInputFormField(
      inputFormatters: TlInputFormatters.onlyAllowNumbers,
      hintText: AppConstants.hsnCode,
      labelText: AppConstants.hsnCode,
      controller: widget.addSalesBloc.hsnCodeTextController,
      onChanged: (hsn) {},
      height: 70,
      validator: (value) {
        if (value!.isEmpty) {
          return AppConstants.enterHsnCode;
        }
        return null;
      },
      focusNode: widget.addSalesBloc.hsnCodeFocus,
      onSubmit: (value) {
        FocusScope.of(context).requestFocus(widget.addSalesBloc.cgstFocus);
      },
    );
  }

  Widget _buildGstRadioBtns() {
    return StreamBuilder<bool>(
      stream: widget.addSalesBloc.gstRadioBtnRefreashStream,
      builder: (context, snapshot) {
        return Row(
          children: [
            Row(
              children: widget.addSalesBloc.gstTypeOptions.map((gstTypeOption) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: gstTypeOption,
                        groupValue: widget.addSalesBloc.selectedGstType,
                        onChanged: (String? value) {
                          widget.addSalesBloc.selectedGstType = value;
                          FocusScope.of(context)
                              .requestFocus(widget.addSalesBloc.igstFocus);
                          widget.addSalesBloc.sgstAmount = 0.0;
                          widget.addSalesBloc.cgstAmount = 0.0;
                          widget.addSalesBloc.cgstPresentageTextController
                              .clear();
                          widget.addSalesBloc.igstAmount = 0.0;
                          widget.addSalesBloc.igstPresentageTextController
                              .clear();
                          _calculateGST();
                          _updateTotalInvoiceAmount();

                          widget.addSalesBloc
                              .paymentDetailsStreamController(true);

                          widget.addSalesBloc
                              .gstRadioBtnRefreashStreamController(true);
                        },
                      ),
                      Text(gstTypeOption),
                    ],
                  ),
                );
              }).toList(),
            ),
            AppWidgetUtils.buildSizedBox(custWidth: 10),
            if (widget.addSalesBloc.selectedGstType == AppConstants.gstPercent)
              _buildGstPercentFields()
            else if (widget.addSalesBloc.selectedGstType ==
                AppConstants.igstPercent)
              _buildIgstPercentField(),
          ],
        );
      },
    );
  }

  Widget _buildGstPercentFields() {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: TldsInputFormField(
              inputFormatters: TlInputFormatters.onlyAllowDecimalNumbers,
              hintText: AppConstants.cgstPercent,
              controller: widget.addSalesBloc.cgstPresentageTextController,
              focusNode: widget.addSalesBloc.cgstFocus,
              height: 40,
              maxLength: 5,
              counterText: '',
              onChanged: (cgst) {
                _calculateGST();
                double cgstPercentage = double.tryParse(cgst) ?? 0;
                if (cgstPercentage > 100) {
                  widget.addSalesBloc.cgstPresentageTextController.clear();
                }
              },
              onSubmit: (value) {
                FocusScope.of(context)
                    .requestFocus(widget.addSalesBloc.discountFocus);
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TldsInputFormField(
              enabled: false,
              height: 40,
              inputFormatters: TlInputFormatters.onlyAllowDecimalNumbers,
              hintText: AppConstants.sgstPercent,
              controller: widget.addSalesBloc.cgstPresentageTextController,
            ),
          ),
        ],
      ),
    );
  }

  void _calculateGST() {
    double totalValues = widget.addSalesBloc.taxableValue ?? 0;
    double cgstPercent = double.tryParse(
            widget.addSalesBloc.cgstPresentageTextController.text) ??
        0;
    double sgstPercent = double.tryParse(
            widget.addSalesBloc.cgstPresentageTextController.text) ??
        0;
    widget.addSalesBloc.taxableValue = totalValues;
    widget.addSalesBloc.cgstAmount = (totalValues / 100) * cgstPercent;
    widget.addSalesBloc.sgstAmount = (totalValues / 100) * sgstPercent;
    double cgstAmt =
        double.tryParse(widget.addSalesBloc.cgstAmount.toString()) ?? 0;
    double taxableValue = widget.addSalesBloc.taxableValue ?? 0;
    double gstAmt = cgstAmt + cgstAmt;
    widget.addSalesBloc.invAmount = taxableValue + (gstAmt);
    _updateTotalInvoiceAmount();

    widget.addSalesBloc.paymentDetailsStreamController(true);
    widget.addSalesBloc.gstRadioBtnRefreashStreamController(true);
  }

  void _updateTotalInvoiceAmount() {
    double? empsIncValue =
        double.tryParse(widget.addSalesBloc.empsIncentiveTextController.text) ??
            0.0;
    double? stateIncValue = double.tryParse(
            widget.addSalesBloc.stateIncentiveTextController.text) ??
        0.0;
    double totalIncentive = empsIncValue + stateIncValue;
    if ((widget.addSalesBloc.invAmount ?? 0) != -1) {
      widget.addSalesBloc.totalInvAmount =
          (widget.addSalesBloc.invAmount ?? 0) - totalIncentive;
    } else {
      widget.addSalesBloc.totalInvAmount = 0.0;
    }
    double advanceAmt = widget.addSalesBloc.advanceAmt ?? 0;
    double totalInvAmt = widget.addSalesBloc.totalInvAmount ?? 0;
    widget.addSalesBloc.toBePayedAmt = totalInvAmt - advanceAmt;
    widget.addSalesBloc.toBePayedAmt = double.parse(
        widget.addSalesBloc.toBePayedAmt?.round().toString() ?? '');
    widget.addSalesBloc.paymentDetailsStreamController(true);
  }

  Widget _buildHeadingText(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
          color: _appColors.primaryColor),
    );
  }

  Widget _buildIgstPercentField() {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: TldsInputFormField(
              inputFormatters: TlInputFormatters.onlyAllowDecimalNumbers,
              hintText: AppConstants.igstPercent,
              controller: widget.addSalesBloc.igstPresentageTextController,
              focusNode: widget.addSalesBloc.igstFocus,
              height: 40,
              maxLength: 5,
              counterText: '',
              onChanged: (igst) {
                double igstPercent = double.tryParse(igst) ?? 0;
                if (igstPercent > 100) {
                  widget.addSalesBloc.igstPresentageTextController.clear();
                }
                double igstPersent = double.parse(igst);
                widget.addSalesBloc.paymentDetailsStreamController(true);
                widget.addSalesBloc.gstRadioBtnRefreashStreamController(true);
                double unitRate = widget.addSalesBloc.totalUnitRate ?? 0;
                widget.addSalesBloc.paymentDetailsStreamController(true);

                widget.addSalesBloc.paymentDetailsStreamController(true);
                double taxableValue = widget.addSalesBloc.taxableValue ?? 0;
                widget.addSalesBloc.igstAmount =
                    (taxableValue / 100) * igstPersent;
                widget.addSalesBloc.paymentDetailsStreamController(true);
                widget.addSalesBloc.invAmount =
                    taxableValue + (widget.addSalesBloc.igstAmount ?? 0);
                widget.addSalesBloc.paymentDetailsStreamController(true);
                _updateTotalInvoiceAmount();
                widget.addSalesBloc.paymentDetailsStreamController(true);
              },
              onSubmit: (value) {
                FocusScope.of(context)
                    .requestFocus(widget.addSalesBloc.discountFocus);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails() {
    return StreamBuilder<bool>(
        stream: widget.addSalesBloc.paymentDetailsStream,
        builder: (context, snapshot) {
          return SizedBox(
            // padding: const EdgeInsets.all(12),
            width: MediaQuery.sizeOf(context).width * 0.36,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTotalValue(),
                if (widget.addSalesBloc.selectedVehicleAndAccessories !=
                    AppConstants.accessories)
                  _buildDiscountfield(context),
                if (widget.addSalesBloc.selectedVehicleAndAccessories ==
                    AppConstants.accessories)
                  _buildPaymentDetailTile(
                      AppConstants.discount,
                      subTitle: AppConstants.discountB,
                      Text(
                        AppUtils.formatCurrency(
                            widget.addSalesBloc.totalDiscount ?? 0.0),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                _buildTaxableValueText(),
                _buildgstSubText(),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                _buildgstAmountText(),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                if (widget.addSalesBloc.selectedVehicleAndAccessories !=
                    AppConstants.accessories)
                  _buildInvoiceText(),
                if (widget.addSalesBloc.selectedVehicleAndAccessories !=
                    AppConstants.accessories)
                  _buildEmpsInsentive(context),
                if (widget.addSalesBloc.selectedVehicleAndAccessories !=
                    AppConstants.accessories)
                  _buildStateInsentive(),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                _buildTotalInvAmtText(),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                if (widget.addSalesBloc.selectedVehicleAndAccessories !=
                    'Accessories')
                  _buildAdvAmount(),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                _buildToBePaidAmt(),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                _buildHeadingText(AppConstants.paymentMethod),
                AppWidgetUtils.buildSizedBox(custHeight: 5),
                _buildPaymentOptions(),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                _buildSplitPayment(),
                _buildSaveBtn(),
              ],
            ),
          );
        });
  }

  Container _buildToBePaidAmt() {
    return Container(
      decoration: BoxDecoration(
          color: _appColors.transparentGreenColor,
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(5),
      child: ListTile(
        title: const Text(
          AppConstants.toBePayed,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          AppUtils.formatCurrency(widget.addSalesBloc.toBePayedAmt ?? 0.00),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  StreamBuilder<bool> _buildAdvAmount() {
    return StreamBuilder<bool>(
        stream: widget.addSalesBloc.advanceAmountRefreshStream,
        builder: (context, snapshot) {
          return Container(
            decoration: BoxDecoration(
                color: _appColors.amountBgColor,
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(5),
            child: ListTile(
              title: Text(
                AppConstants.bookAdvAmt,
                style: TextStyle(fontSize: 16, color: _appColors.primaryColor),
              ),
              trailing: Text(
                AppUtils.formatCurrency(widget.addSalesBloc.advanceAmt ?? 0),
                style: TextStyle(color: _appColors.primaryColor, fontSize: 16),
              ),
            ),
          );
        });
  }

  ListTile _buildTotalInvAmtText() {
    return ListTile(
      title: const Text(AppConstants.totalInvoiceAmount,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      subtitle: Text(
        AppConstants.totalInvoiceAmountCalTwo,
        style: TextStyle(color: _appColors.grey),
      ),
      trailing: Text(
        AppUtils.formatCurrency(widget.addSalesBloc.totalInvAmount ?? 0.0),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStateInsentive() {
    return _buildPaymentDetailTile(
      AppConstants.stateIncentive,
      subTitle: AppConstants.stateIncentiveFive,
      TldsInputFormField(
        hintText: AppConstants.rupeeHint,
        inputFormatters: TldsInputFormatters.onlyAllowDecimalNumbers,
        focusNode: widget.addSalesBloc.stateIncentiveFocus,
        width: 100,
        height: 40,
        controller: widget.addSalesBloc.stateIncentiveTextController,
        onChanged: (stateInc) {
          double? stateIncentive = double.tryParse(stateInc);
          double totalInvAmount = widget.addSalesBloc.totalInvAmount ?? 0;

          if (stateIncentive != null && stateIncentive >= totalInvAmount) {
            stateIncentive = 0;
            widget.addSalesBloc.stateIncentiveTextController.text =
                stateIncentive.toString();
          }

          _updateTotalInvoiceAmount();
        },
      ),
    );
  }

  Widget _buildEmpsInsentive(BuildContext context) {
    return _buildPaymentDetailTile(
      AppConstants.empsIncentive,
      subTitle: AppConstants.empsIncentiveFour,
      TldsInputFormField(
        hintText: AppConstants.rupeeHint,
        inputFormatters: TldsInputFormatters.onlyAllowDecimalNumbers,
        focusNode: widget.addSalesBloc.empsIncentiveFocus,
        width: 100,
        height: 40,
        controller: widget.addSalesBloc.empsIncentiveTextController,
        onChanged: (empsInc) {
          double? empsIncentive = double.tryParse(empsInc);
          double totalInvAmount = widget.addSalesBloc.totalInvAmount ?? 0;

          if (empsIncentive != null && empsIncentive >= totalInvAmount) {
            empsIncentive = 0;
            widget.addSalesBloc.empsIncentiveTextController.text =
                empsIncentive.toString();
          }

          _updateTotalInvoiceAmount();
        },
        onSubmit: (value) {
          FocusScope.of(context)
              .requestFocus(widget.addSalesBloc.stateIncentiveFocus);
        },
      ),
    );
  }

  Widget _buildInvoiceText() {
    return _buildPaymentDetailTile(
        AppConstants.invoiceValue,
        subTitle: AppConstants.invoiceValueThree,
        Text(
          AppUtils.formatCurrency(widget.addSalesBloc.invAmount ?? 0.0),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ));
  }

  Container _buildgstAmountText() {
    return Container(
        decoration: BoxDecoration(
            color: _appColors.amountBgColor,
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Visibility(
              visible: widget.addSalesBloc.selectedGstType ==
                  AppConstants.igstPercent,
              child: _buildPaymentDetailTile(
                  AppConstants.igstAmount,
                  Text(
                    AppUtils.formatCurrency(
                        widget.addSalesBloc.igstAmount ?? 0.0),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  )),
            ),
            Visibility(
              visible: widget.addSalesBloc.selectedGstType ==
                  AppConstants.gstPercent,
              child: _buildPaymentDetailTile(
                  AppConstants.cgstAmount,
                  Text(
                    AppUtils.formatCurrency(
                        widget.addSalesBloc.cgstAmount ?? 0.0),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  )),
            ),
            Visibility(
              visible: widget.addSalesBloc.selectedGstType ==
                  AppConstants.gstPercent,
              child: _buildPaymentDetailTile(
                  AppConstants.sgstAmount,
                  Text(
                    AppUtils.formatCurrency(
                        widget.addSalesBloc.sgstAmount ?? 0.0),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ));
  }

  Text _buildgstSubText() {
    return Text(
      AppConstants.gstThree,
      style: TextStyle(
          color: _appColors.primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTaxableValueText() {
    return _buildPaymentDetailTile(
        AppConstants.taxableValue,
        subTitle: AppConstants.taxableValueAB,
        Text(
          AppUtils.formatCurrency(widget.addSalesBloc.taxableValue ?? 0.0),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ));
  }

  Widget _buildDiscountfield(BuildContext context) {
    return _buildPaymentDetailTile(
      AppConstants.discount,
      subTitle: AppConstants.discountB,
      TldsInputFormField(
        hintText: AppConstants.rupeeHint,
        inputFormatters: TldsInputFormatters.onlyAllowDecimalNumbers,
        width: 100,
        height: 40,
        controller: widget.addSalesBloc.discountTextController,
        focusNode: widget.addSalesBloc.discountFocus,
        onChanged: (discount) {
          double? discountAmount = double.tryParse(discount);
          double totalValue = widget.addSalesBloc.totalValue ?? 0;

          if (discountAmount != null && discountAmount >= totalValue) {
            discountAmount = 0;
            widget.addSalesBloc.discountTextController.text =
                discountAmount.toStringAsFixed(2);
          }

          widget.addSalesBloc.taxableValue = totalValue - (discountAmount ?? 0);
          widget.addSalesBloc.totalInvAmount =
              (widget.addSalesBloc.invAmount ?? 0) - (discountAmount ?? 0);

          _calculateGST();
          _updateTotalInvoiceAmount();

          widget.addSalesBloc.paymentDetailsStreamController(true);
        },
        onSubmit: (value) {
          FocusScope.of(context)
              .requestFocus(widget.addSalesBloc.empsIncentiveFocus);
        },
      ),
    );
  }

  Widget _buildTotalValue() {
    return _buildPaymentDetailTile(
        AppConstants.totalValue,
        Text(
          AppUtils.formatCurrency(widget.addSalesBloc.totalValue ?? 0.0),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subTitle: AppConstants.totalValueA);
  }

  Widget _buildPaymentDetailTile(String? title, Widget? textField,
      {String? subTitle}) {
    return ListTile(
        title: Row(
          children: [
            Text(
              title ?? '',
              style: TextStyle(color: _appColors.greyColor),
            ),
            AppWidgetUtils.buildSizedBox(custWidth: 5),
            Text(
              subTitle ?? '',
              style: TextStyle(color: _appColors.greyColor, fontSize: 14),
            ),
          ],
        ),
        trailing: textField ?? const SizedBox.shrink());
  }

  Widget _buildPaymentOptions() {
    return StreamBuilder<bool>(
        stream: widget.addSalesBloc.paymentOptionStream,
        builder: (context, snapshot) {
          return FutureBuilder(
            future: widget.addSalesBloc.getPaymentmethods(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  height: 150,
                  child: ListView.separated(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) => _buildCustomRadioTile(
                      value: snapshot.data?[index].toString() ?? '',
                      groupValue: widget.addSalesBloc.selectedPaymentOption,
                      onChanged: (value) {
                        setState(() {});
                        widget.addSalesBloc.selectedPaymentOption = value!;
                        widget.addSalesBloc.paymentOptionStreamController(true);
                      },
                      icon: Icons.payment,
                      label: snapshot.data?[index].toUpperCase() ?? '',
                    ),
                    separatorBuilder: (BuildContext context, int index) {
                      return AppWidgetUtils.buildSizedBox(custHeight: 5);
                    },
                  ),
                );
              } else {
                return const Center(
                  child: Text('No Payment Methods Available'),
                );
              }
            },
          );
        });
  }

  Widget _buildCustomRadioTile({
    required String value,
    required String? groupValue,
    required ValueChanged<String?> onChanged,
    required IconData icon,
    required String label,
  }) {
    bool isSelected = value == groupValue;

    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : _appColors.greyColor,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                icon,
                color:
                    isSelected ? _appColors.primaryColor : _appColors.greyColor,
              ),
            ),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                    fontSize: 16.0,
                    color: isSelected
                        ? _appColors.primaryColor
                        : _appColors.greyColor),
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  List<bool> _checkedList = [];

  _buildPaiddetails() {
    return StreamBuilder<bool>(
        stream: widget.addSalesBloc.isSplitPaymentStream,
        builder: (context, snapshot) {
          return !widget.addSalesBloc.isSplitPayment
              ? Column(
                  children: [
                    _paymentsListFuture?.isEmpty == true
                        ? const Center(child: Text('No payments available'))
                        : TldsDropDownButtonFormField(
                            dropDownItems: _paymentsListFuture ?? [],
                            dropDownValue:
                                widget.addSalesBloc.selectedPaymentList,
                            hintText: '',
                            width: double.infinity,
                            onChange: (value) {
                              widget.addSalesBloc.selectedPaymentList = value;
                              widget.addSalesBloc
                                  .selectedPaymentListStreamController(true);
                            },
                          ),
                    TldsInputFormField(
                      controller: widget.addSalesBloc.paidAmountController,
                      hintText: AppConstants.amount,
                      inputFormatters:
                          TlInputFormatters.onlyAllowDecimalNumbers,
                      onChanged: (value) {
                        double? paidAmount = double.tryParse(value);
                        double toBePaidAmt =
                            widget.addSalesBloc.toBePayedAmt ?? 0;

                        if (paidAmount != null && paidAmount >= toBePaidAmt) {
                          paidAmount = toBePaidAmt;
                          widget.addSalesBloc.paidAmountController.text =
                              paidAmount.toStringAsFixed(2);
                          //    widget.addSalesBloc.paidAmountControllerStreamController.add(true);
                        }
                      },
                    ),
                    StreamBuilder<bool>(
                      stream: widget.addSalesBloc.selectedPaymentListStream,
                      builder: (context, snapshot) {
                        return Visibility(
                          visible: [
                            'UPI',
                            'CARD',
                            'CHEQUE'
                          ].contains(widget.addSalesBloc.selectedPaymentList),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 13),
                            child: SizedBox(
                              child: TldsInputFormField(
                                controller: widget
                                    .addSalesBloc.paymentTypeIdTextController,
                                hintText:
                                    '${widget.addSalesBloc.selectedPaymentList} ID',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                )
              : const SizedBox();
        });
  }

  _buildSplitPayment() {
    return Visibility(
      visible: widget.addSalesBloc.selectedPaymentOption == 'Pay',
      child: Column(
        children: [
          StreamBuilder<bool>(
            stream: widget.addSalesBloc.isSplitPaymentStream,
            builder: (context, snapshot) {
              return Row(
                children: [
                  Switch(
                    value: widget.addSalesBloc.isSplitPayment,
                    onChanged: (value) {
                      widget.addSalesBloc.isSplitPayment = value;
                      widget.addSalesBloc.isSplitPaymentStreamController(true);
                      widget.addSalesBloc.paidAmountController.clear();

                      if (!value) {
                        clearSplitPaymentData();
                      }
                    },
                  ),
                  const Text(
                    AppConstants.splitPayment,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              );
            },
          ),
          StreamBuilder<bool>(
              stream: widget.addSalesBloc.isSplitPaymentStream,
              builder: (context, snapshot) {
                return widget.addSalesBloc.isSplitPayment
                    ? SizedBox(
                        child: _paymentsListFuture?.isEmpty == true
                            ? const Center(child: Text('No payments available'))
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: _paymentsListFuture?.length,
                                itemBuilder: (context, index) {
                                  bool isVisible =
                                      _paymentsListFuture?[index] == 'CHEQUE' ||
                                          _paymentsListFuture?[index] ==
                                              'CARD' ||
                                          _paymentsListFuture?[index] == 'UPI';

                                  if (_checkedList.length <= index) {
                                    _checkedList.add(false);
                                  }

                                  TextEditingController paidAmountController =
                                      TextEditingController(
                                          text: widget.addSalesBloc
                                              .splitPaymentAmt[index]);

                                  TextEditingController idController =
                                      TextEditingController(
                                          text: widget.addSalesBloc
                                              .splitPaymentId[index]);

                                  return Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: StreamBuilder<bool>(
                                                stream: widget.addSalesBloc
                                                    .splitPaymentCheckBoxStream,
                                                builder: (context, snapshot) {
                                                  return CheckboxListTile(
                                                    title: Text(
                                                        _paymentsListFuture?[
                                                                index] ??
                                                            ''),
                                                    value: _checkedList[index],
                                                    onChanged: (newValue) {
                                                      _checkedList[index] =
                                                          newValue ?? false;
                                                      if (!(newValue ??
                                                          false)) {
                                                        paidAmountController
                                                            .clear();
                                                        idController.clear();
                                                        widget.addSalesBloc
                                                                .splitPaymentAmt[
                                                            index] = '';
                                                        widget.addSalesBloc
                                                                .splitPaymentId[
                                                            index] = '';
                                                      }
                                                      widget.addSalesBloc
                                                                  .paymentName[
                                                              index] =
                                                          _paymentsListFuture?[
                                                                  index] ??
                                                              '';
                                                      widget.addSalesBloc
                                                          .splitPaymentCheckBoxStreamController(
                                                              true);
                                                    },
                                                    controlAffinity:
                                                        ListTileControlAffinity
                                                            .leading,
                                                  );
                                                }),
                                          ),
                                          const SizedBox(height: 10),
                                          StreamBuilder<bool>(
                                              stream: widget.addSalesBloc
                                                  .splitPaymentCheckBoxStream,
                                              builder: (context, snapshot) {
                                                return Visibility(
                                                  visible: _checkedList[index],
                                                  child: Expanded(
                                                    child: StreamBuilder<bool>(
                                                        stream: widget
                                                            .addSalesBloc
                                                            .selectedPaidAmtStream,
                                                        builder: (context,
                                                            snapshot) {
                                                          return TldsInputFormField(
                                                            controller:
                                                                paidAmountController,
                                                            hintText:
                                                                'Paid Amount',
                                                            inputFormatters:
                                                                TlInputFormatters
                                                                    .onlyAllowDecimalNumbers,
                                                            onChanged: (value) {
                                                              widget.addSalesBloc
                                                                      .splitPaymentAmt[
                                                                  index] = value;

                                                              double
                                                                  totalSplitPaymentAmt =
                                                                  0;
                                                              widget
                                                                  .addSalesBloc
                                                                  .splitPaymentAmt
                                                                  .forEach((key,
                                                                      amt) {
                                                                totalSplitPaymentAmt +=
                                                                    double.tryParse(
                                                                            amt) ??
                                                                        0;
                                                              });

                                                              if (totalSplitPaymentAmt >
                                                                  (widget.addSalesBloc
                                                                          .toBePayedAmt ??
                                                                      0)) {
                                                                setState(() {});
                                                                widget.addSalesBloc
                                                                        .splitPaymentAmt[
                                                                    index] = '';
                                                              }

                                                              widget
                                                                  .addSalesBloc
                                                                  .selectedPaidAmtStreamController(
                                                                      true);
                                                            },
                                                          );
                                                        }),
                                                  ),
                                                );
                                              })
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      StreamBuilder<bool>(
                                          stream: widget.addSalesBloc
                                              .splitPaymentCheckBoxStream,
                                          builder: (context, snapshot) {
                                            return Visibility(
                                              visible: _checkedList[index] &&
                                                  isVisible,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 13),
                                                child: SizedBox(
                                                  child: TldsInputFormField(
                                                    controller: idController,
                                                    hintText:
                                                        '${_paymentsListFuture?[index]} ID',
                                                    onChanged: (value) {
                                                      widget.addSalesBloc
                                                              .splitPaymentId[
                                                          index] = value;
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ],
                                  );
                                },
                              ),
                      )
                    : const SizedBox();
              }),
          _buildPaiddetails(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void clearSplitPaymentData() {
    for (int i = 0; i < widget.addSalesBloc.splitPaymentAmt.length; i++) {
      widget.addSalesBloc.splitPaymentAmt[i] = '';
      widget.addSalesBloc.splitPaymentId[i] = '';
      _checkedList[i] = false;
    }
    widget.addSalesBloc.splitPaymentCheckBoxStreamController(true);
  }

  _buildSaveBtn() {
    return CustomActionButtons(
        onPressed: () {
          if (widget.addSalesBloc.paymentFormKey.currentState!.validate()) {
            _isLoadingState(state: true);
            widget.addSalesBloc.addNewSalesDeatils(salesPostObject(),
                (statusCode) {
              if (statusCode == 200 || statusCode == 201) {
                _isLoadingState(state: false);
                Navigator.pop(context);
                widget.salesViewBloc.pageNumberUpdateStreamController(0);
                AppWidgetUtils.buildToast(
                    context,
                    ToastificationType.success,
                    AppConstants.salesBillScc,
                    Icon(Icons.check_circle_outline_rounded,
                        color: _appColors.successColor),
                    AppConstants.salesBillDescScc,
                    _appColors.successLightColor);
              } else {
                _isLoadingState(state: false);
              }
            });
          }
        },
        buttonText: AppConstants.save);
  }

  salesPostObject() {
    List<SalesItemDetail> itemdetails = [];
    List<GstDetail> gstDetails = [];
    Map<String, String> mandatoryAddonsMap = {};
    Map<String, String> eVehicleComponents = {};

    int? totalQty = 0;

    List<PaidDetail> paidDetails = [];
    for (var addon in widget.addSalesBloc.selectedMandatoryAddOns.keys) {
      mandatoryAddonsMap[addon] =
          widget.addSalesBloc.selectedMandatoryAddOns[addon]!;
    }

    if (widget.addSalesBloc.selectedVehicleAndAccessories == 'E-Vehicle') {
      for (var battery in widget.addSalesBloc.batteryDetailsMap.keys) {
        eVehicleComponents[battery] =
            widget.addSalesBloc.batteryDetailsMap[battery]!;
      }
    }

    if (widget.addSalesBloc.selectedVehicleAndAccessories == 'Accessories') {
      totalQty = int.tryParse(widget.addSalesBloc.totalQty.toString());
    } else {
      totalQty = widget.addSalesBloc.selectedVehiclesList?.length;
    }

    if (widget.addSalesBloc.selectedGstType == 'GST %') {
      gstDetails.add(
        GstDetail(
            gstAmount: widget.addSalesBloc.cgstAmount ?? 0,
            gstName: 'CGST',
            percentage: double.tryParse(
                    widget.addSalesBloc.cgstPresentageTextController.text) ??
                0),
      );
      gstDetails.add(
        GstDetail(
            gstAmount: widget.addSalesBloc.cgstAmount ?? 0,
            gstName: 'SGST',
            percentage: double.tryParse(
                    widget.addSalesBloc.cgstPresentageTextController.text) ??
                0),
      );
    }
    if (widget.addSalesBloc.selectedGstType == 'IGST %') {
      gstDetails.add(
        GstDetail(
            gstAmount: widget.addSalesBloc.igstAmount ?? 0,
            gstName: 'IGST',
            percentage: double.tryParse(
                    widget.addSalesBloc.igstPresentageTextController.text) ??
                0),
      );
    }
    for (int i = 0; i < _checkedList.length; i++) {
      if (_checkedList[i]) {
        String paymentType = widget.addSalesBloc.paymentName[i] ?? '';
        String paidAmount = widget.addSalesBloc.splitPaymentAmt[i] ?? '0';
        String paidId = widget.addSalesBloc.splitPaymentId[i] ?? '0';

        final paidDetail = PaidDetail(
            paidAmount: double.tryParse(paidAmount) ?? 0,
            paymentReference: paidId,
            paymentDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            paymentType: paymentType);

        paidDetails.add(paidDetail);
      }
    }
    if (widget.addSalesBloc.paidAmountController.text != '') {
      paidDetails.add(PaidDetail(
          paymentType: widget.addSalesBloc.selectedPaymentList,
          paidAmount: double.tryParse(
            widget.addSalesBloc.paidAmountController.text,
          ),
          paymentDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          paymentReference:
              widget.addSalesBloc.paymentTypeIdTextController.text));
    }

    List<Incentive> insentive = [];
    if (widget.addSalesBloc.stateIncentiveTextController.text.isNotEmpty) {
      insentive.add(Incentive(
          incentiveAmount: double.tryParse(
                  widget.addSalesBloc.stateIncentiveTextController.text) ??
              0,
          incentiveName: 'STATE INCENTIVE',
          percentage: 0));
    }

    if (widget.addSalesBloc.empsIncentiveTextController.text.isNotEmpty) {
      insentive.add(Incentive(
          incentiveAmount: double.tryParse(
                  widget.addSalesBloc.empsIncentiveTextController.text) ??
              0,
          incentiveName: 'EMPS INCENTIVE',
          percentage: 0));
    }

    List<Tax> tax = [];
    if (widget.addSalesBloc.selectedVehiclesList!.isNotEmpty) {
      for (var itemData in widget.addSalesBloc.selectedVehiclesList!) {
        final itemDetail = SalesItemDetail(
            categoryId: itemData.categoryId ?? '',
            discount: double.tryParse(
                    widget.addSalesBloc.discountTextController.text) ??
                0,
            finalInvoiceValue: widget.addSalesBloc.totalInvAmount ?? 0,
            gstDetails: gstDetails,
            hsnSacCode: widget.addSalesBloc.hsnCodeTextController.text,
            incentives: insentive,
            invoiceValue: widget.addSalesBloc.invAmount ?? 0,
            itemName: itemData.itemName ?? '',
            mainSpecValue: {
              'engineNo': itemData.mainSpecValue?.engineNo ?? '',
              'frameNo': itemData.mainSpecValue?.frameNo ?? ''
            },
            partNo: itemData.partNo ?? '',
            quantity: widget.addSalesBloc.selectedVehiclesList?.length,
            specificationsValue: {},
            stockId: itemData.stockId ?? '',
            taxableValue: widget.addSalesBloc.taxableValue ?? 0,
            taxes: tax,
            unitRate: double.tryParse(widget.addSalesBloc.unitRates[0] ?? ''),
            value: widget.addSalesBloc.totalValue ?? 0);
        itemdetails.add(itemDetail);
      }
    }

    if (widget.addSalesBloc.accessoriesItemList?.isNotEmpty ?? false) {
      for (var itemData in widget.addSalesBloc.accessoriesItemList!) {
        final itemDetail = SalesItemDetail(
            categoryId: itemData.categoryId ?? '',
            discount: itemData.discount ?? 0,
            finalInvoiceValue: itemData.finalInvoiceValue,
            gstDetails: itemData.gstDetails,
            hsnSacCode: itemData.hsnSacCode,
            incentives: itemData.incentives,
            invoiceValue: itemData.invoiceValue ?? 0,
            itemName: itemData.itemName ?? '',
            mainSpecValue: itemData.mainSpecValue,
            partNo: itemData.partNo ?? '',
            quantity: itemData.quantity ?? 0,
            specificationsValue: itemData.specificationsValue,
            stockId: itemData.stockId ?? '',
            taxableValue: itemData.taxableValue,
            taxes: itemData.taxes,
            unitRate: itemData.unitRate ?? 0,
            value: itemData.value ?? 0);
        itemdetails.add(itemDetail);
      }
    }

    return AddSalesModel(
        billType: widget.addSalesBloc.selectedPaymentOption,
        bookingNo: widget.addSalesBloc.bookingId,
        branchId: widget.addSalesBloc.branchId ?? '',
        customerId: widget.addSalesBloc.selectedCustomerId ?? '',
        evBattery: eVehicleComponents,
        invoiceDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        invoiceType: widget.addSalesBloc.selectedVehicleAndAccessories,
        itemDetails: itemdetails,
        mandatoryAddons: mandatoryAddonsMap,
        netAmt: double.parse(
            widget.addSalesBloc.totalInvAmount?.round().toString() ?? ''),
        paidDetails: paidDetails,
        roundOffAmt: double.parse(
                widget.addSalesBloc.totalInvAmount?.toString() ?? '') -
            double.parse(
                widget.addSalesBloc.totalInvAmount?.round().toString() ?? ''),
        totalQty: totalQty);
  }
}
