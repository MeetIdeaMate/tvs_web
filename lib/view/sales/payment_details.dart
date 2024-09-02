import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:tlbilling/api_service/service_locator.dart';
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
  const PaymentDetails({
    super.key,
  });

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  List<String>? _paymentsListFuture;

  final _salesViewBloc = getIt<SalesViewBlocImpl>();
  final _addSalesViewBloc = getIt<AddSalesBlocImpl>();

  @override
  void initState() {
    super.initState();
    getbranchId();

    _addSalesViewBloc.getPaymentsList().then((value) {
      setState(() {
        _paymentsListFuture = value?.configuration ?? [];
        _checkedList =
            List<bool>.filled(_paymentsListFuture?.length ?? 0, false);
      });
    });
  }

  Future<void> getbranchId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _addSalesViewBloc.branchId = prefs.getString(AppConstants.branchId);
  }

  final _appColors = AppColors();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 45, right: 30, left: 30, bottom: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomerDetails(),
            if (_addSalesViewBloc.selectedVehicleAndAccessories !=
                AppConstants.accessories)
              _buildGstDetails(),
            AppWidgetUtils.buildSizedBox(custHeight: 30),
            _buildHeadingText(AppConstants.paymentDetails),
            _buildPaymentDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildGstDetails() {
    return StreamBuilder<bool>(
        stream: _addSalesViewBloc.gstDetailsStream,
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
      controller: _addSalesViewBloc.hsnCodeTextController,
      onChanged: (hsn) {},
      height: 70,
      validator: (value) {
        if (value!.isEmpty) {
          return AppConstants.enterHsnCode;
        }
        return null;
      },
      focusNode: _addSalesViewBloc.hsnCodeFocus,
      onSubmit: (value) {
        FocusScope.of(context).requestFocus(_addSalesViewBloc.cgstFocus);
      },
    );
  }

  Widget _buildGstRadioBtns() {
    return StreamBuilder<bool>(
      stream: _addSalesViewBloc.gstRadioBtnRefreashStream,
      builder: (context, snapshot) {
        return Row(
          children: [
            Row(
              children: _addSalesViewBloc.gstTypeOptions.map((gstTypeOption) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: gstTypeOption,
                        groupValue: _addSalesViewBloc.selectedGstType,
                        onChanged: (String? value) {
                          _addSalesViewBloc.selectedGstType = value;
                          FocusScope.of(context)
                              .requestFocus(_addSalesViewBloc.igstFocus);
                          _addSalesViewBloc
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
            if (_addSalesViewBloc.selectedGstType == AppConstants.gstPercent)
              _buildGstPercentFields()
            else if (_addSalesViewBloc.selectedGstType ==
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
              controller: _addSalesViewBloc.cgstPresentageTextController,
              focusNode: _addSalesViewBloc.cgstFocus,
              height: 40,
              maxLength: 5,
              counterText: '',
              onChanged: (cgst) {
                _calculateGST();
                double cgstPercentage = double.tryParse(cgst) ?? 0;
                if (cgstPercentage > 100) {
                  _addSalesViewBloc.cgstPresentageTextController.clear();
                }
              },
              onSubmit: (value) {
                FocusScope.of(context)
                    .requestFocus(_addSalesViewBloc.discountFocus);
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
              controller: _addSalesViewBloc.cgstPresentageTextController,
            ),
          ),
        ],
      ),
    );
  }

  void _calculateGST() {
    double totalValues = _addSalesViewBloc.taxableValue ?? 0;
    double cgstPercent =
        double.tryParse(_addSalesViewBloc.cgstPresentageTextController.text) ??
            0;
    double sgstPercent =
        double.tryParse(_addSalesViewBloc.cgstPresentageTextController.text) ??
            0;
    _addSalesViewBloc.taxableValue = totalValues;
    _addSalesViewBloc.cgstAmount = (totalValues / 100) * cgstPercent;
    _addSalesViewBloc.sgstAmount = (totalValues / 100) * sgstPercent;
    double cgstAmt =
        double.tryParse(_addSalesViewBloc.cgstAmount.toString()) ?? 0;
    double taxableValue = _addSalesViewBloc.taxableValue ?? 0;
    double gstAmt = cgstAmt + cgstAmt;
    _addSalesViewBloc.invAmount = taxableValue + (gstAmt);
    _updateTotalInvoiceAmount();

    _addSalesViewBloc.paymentDetailsStreamController(true);
    _addSalesViewBloc.gstRadioBtnRefreashStreamController(true);
  }

  void _updateTotalInvoiceAmount() {
    double? empsIncValue =
        double.tryParse(_addSalesViewBloc.empsIncentiveTextController.text) ??
            0.0;
    double? stateIncValue =
        double.tryParse(_addSalesViewBloc.stateIncentiveTextController.text) ??
            0.0;
    double totalIncentive = empsIncValue + stateIncValue;
    if ((_addSalesViewBloc.invAmount ?? 0) != -1) {
      _addSalesViewBloc.totalInvAmount =
          (_addSalesViewBloc.invAmount ?? 0) - totalIncentive;
    } else {
      _addSalesViewBloc.totalInvAmount = 0.0;
    }
    double advanceAmt = _addSalesViewBloc.advanceAmt ?? 0;
    double totalInvAmt = _addSalesViewBloc.totalInvAmount ?? 0;
    _addSalesViewBloc.toBePayedAmt = totalInvAmt - advanceAmt;
    _addSalesViewBloc.toBePayedAmt =
        double.parse(_addSalesViewBloc.toBePayedAmt?.round().toString() ?? '');
    _addSalesViewBloc.paymentDetailsStreamController(true);
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
              controller: _addSalesViewBloc.igstPresentageTextController,
              focusNode: _addSalesViewBloc.igstFocus,
              height: 40,
              maxLength: 5,
              counterText: '',
              onChanged: (igst) {
                double igstPercent = double.tryParse(igst) ?? 0;
                if (igstPercent > 100) {
                  _addSalesViewBloc.igstPresentageTextController.clear();
                }
                double igstPersent = double.parse(igst);
                _addSalesViewBloc.paymentDetailsStreamController(true);
                _addSalesViewBloc.gstRadioBtnRefreashStreamController(true);
                double unitRate = _addSalesViewBloc.totalUnitRate ?? 0;
                _addSalesViewBloc.paymentDetailsStreamController(true);
                _addSalesViewBloc.igstAmount = (unitRate / 10) * igstPersent;
                _addSalesViewBloc.paymentDetailsStreamController(true);
                double taxableValue = _addSalesViewBloc.taxableValue ?? 0;
                _addSalesViewBloc.paymentDetailsStreamController(true);
                _addSalesViewBloc.invAmount =
                    taxableValue + (_addSalesViewBloc.sgstAmount ?? 0 * 2);
                _addSalesViewBloc.paymentDetailsStreamController(true);
                _updateTotalInvoiceAmount();
                _addSalesViewBloc.paymentDetailsStreamController(true);
              },
              onSubmit: (value) {
                FocusScope.of(context)
                    .requestFocus(_addSalesViewBloc.discountFocus);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails() {
    return StreamBuilder<bool>(
        stream: _addSalesViewBloc.paymentDetailsStream,
        builder: (context, snapshot) {
          return SizedBox(
            // padding: const EdgeInsets.all(12),
            width: MediaQuery.sizeOf(context).width * 0.36,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTotalValue(),
                if (_addSalesViewBloc.selectedVehicleAndAccessories !=
                    AppConstants.accessories)
                  _buildDiscountfield(context),
                if (_addSalesViewBloc.selectedVehicleAndAccessories ==
                    AppConstants.accessories)
                  _buildPaymentDetailTile(
                      AppConstants.discount,
                      subTitle: AppConstants.discountB,
                      Text(
                        AppUtils.formatCurrency(
                            _addSalesViewBloc.totalDiscount ?? 0.0),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                _buildTaxableValueText(),
                _buildgstSubText(),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                _buildgstAmountText(),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                if (_addSalesViewBloc.selectedVehicleAndAccessories !=
                    AppConstants.accessories)
                  _buildInvoiceText(),
                if (_addSalesViewBloc.selectedVehicleAndAccessories !=
                    AppConstants.accessories)
                  _buildEmpsInsentive(context),
                if (_addSalesViewBloc.selectedVehicleAndAccessories !=
                    AppConstants.accessories)
                  _buildStateInsentive(),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                _buildTotalInvAmtText(),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                if (_addSalesViewBloc.selectedVehicleAndAccessories !=
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
          AppUtils.formatCurrency(_addSalesViewBloc.toBePayedAmt ?? 0.00),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  StreamBuilder<bool> _buildAdvAmount() {
    return StreamBuilder<bool>(
        stream: _addSalesViewBloc.advanceAmountRefreshStream,
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
                AppUtils.formatCurrency(_addSalesViewBloc.advanceAmt ?? 0),
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
        AppUtils.formatCurrency(_addSalesViewBloc.totalInvAmount ?? 0.0),
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
        focusNode: _addSalesViewBloc.stateIncentiveFocus,
        width: 100,
        height: 40,
        controller: _addSalesViewBloc.stateIncentiveTextController,
        onChanged: (stateInc) {
          double? stateIncentive = double.tryParse(stateInc);
          double totalInvAmount = _addSalesViewBloc.totalInvAmount ?? 0;

          if (stateIncentive != null && stateIncentive >= totalInvAmount) {
            stateIncentive = 0;
            _addSalesViewBloc.stateIncentiveTextController.text =
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
        focusNode: _addSalesViewBloc.empsIncentiveFocus,
        width: 100,
        height: 40,
        controller: _addSalesViewBloc.empsIncentiveTextController,
        onChanged: (empsInc) {
          double? empsIncentive = double.tryParse(empsInc);
          double totalInvAmount = _addSalesViewBloc.totalInvAmount ?? 0;

          if (empsIncentive != null && empsIncentive >= totalInvAmount) {
            empsIncentive = 0;
            _addSalesViewBloc.empsIncentiveTextController.text =
                empsIncentive.toString();
          }

          _updateTotalInvoiceAmount();
        },
        onSubmit: (value) {
          FocusScope.of(context)
              .requestFocus(_addSalesViewBloc.stateIncentiveFocus);
        },
      ),
    );
  }

  Widget _buildInvoiceText() {
    return _buildPaymentDetailTile(
        AppConstants.invoiceValue,
        subTitle: AppConstants.invoiceValueThree,
        Text(
          AppUtils.formatCurrency(_addSalesViewBloc.invAmount ?? 0.0),
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
              visible:
                  _addSalesViewBloc.selectedGstType == AppConstants.igstPercent,
              child: _buildPaymentDetailTile(
                  AppConstants.igstAmount,
                  Text(
                    AppUtils.formatCurrency(
                        _addSalesViewBloc.igstAmount ?? 0.0),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  )),
            ),
            Visibility(
              visible:
                  _addSalesViewBloc.selectedGstType == AppConstants.gstPercent,
              child: _buildPaymentDetailTile(
                  AppConstants.cgstAmount,
                  Text(
                    AppUtils.formatCurrency(
                        _addSalesViewBloc.cgstAmount ?? 0.0),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  )),
            ),
            Visibility(
              visible:
                  _addSalesViewBloc.selectedGstType == AppConstants.gstPercent,
              child: _buildPaymentDetailTile(
                  AppConstants.sgstAmount,
                  Text(
                    AppUtils.formatCurrency(
                        _addSalesViewBloc.sgstAmount ?? 0.0),
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
          AppUtils.formatCurrency(_addSalesViewBloc.taxableValue ?? 0.0),
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
        controller: _addSalesViewBloc.discountTextController,
        focusNode: _addSalesViewBloc.discountFocus,
        onChanged: (discount) {
          double? discountAmount = double.tryParse(discount);
          double totalValue = _addSalesViewBloc.totalValue ?? 0;

          if (discountAmount != null && discountAmount >= totalValue) {
            discountAmount = 0;
            _addSalesViewBloc.discountTextController.text =
                discountAmount.toStringAsFixed(2);
          }

          _addSalesViewBloc.taxableValue = totalValue - (discountAmount ?? 0);
          _addSalesViewBloc.totalInvAmount =
              (_addSalesViewBloc.invAmount ?? 0) - (discountAmount ?? 0);

          _calculateGST();
          _updateTotalInvoiceAmount();

          _addSalesViewBloc.paymentDetailsStreamController(true);
        },
        onSubmit: (value) {
          FocusScope.of(context)
              .requestFocus(_addSalesViewBloc.empsIncentiveFocus);
        },
      ),
    );
  }

  Widget _buildTotalValue() {
    return _buildPaymentDetailTile(
        AppConstants.totalValue,
        Text(
          AppUtils.formatCurrency(_addSalesViewBloc.totalValue ?? 0.0),
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
        stream: _addSalesViewBloc.paymentOptionStream,
        builder: (context, snapshot) {
          return FutureBuilder(
            future: _addSalesViewBloc.getPaymentmethods(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  height: 150,
                  child: ListView.separated(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) => _buildCustomRadioTile(
                      value: snapshot.data?[index].toString() ?? '',
                      groupValue: _addSalesViewBloc.selectedPaymentOption,
                      onChanged: (value) {
                        setState(() {});
                        _addSalesViewBloc.selectedPaymentOption = value!;
                        _addSalesViewBloc.paymentOptionStreamController(true);
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
        stream: _addSalesViewBloc.isSplitPaymentStream,
        builder: (context, snapshot) {
          return !_addSalesViewBloc.isSplitPayment
              ? Column(
                  children: [
                    _paymentsListFuture?.isEmpty == true
                        ? const Center(child: Text('No payments available'))
                        : TldsDropDownButtonFormField(
                            dropDownItems: _paymentsListFuture ?? [],
                            dropDownValue:
                                _addSalesViewBloc.selectedPaymentList,
                            hintText: '',
                            width: double.infinity,
                            onChange: (value) {
                              _addSalesViewBloc.selectedPaymentList = value;
                              _addSalesViewBloc
                                  .selectedPaymentListStreamController(true);
                            },
                          ),
                    TldsInputFormField(
                      controller: _addSalesViewBloc.paidAmountController,
                      hintText: AppConstants.amount,
                      inputFormatters:
                          TlInputFormatters.onlyAllowDecimalNumbers,
                      onChanged: (value) {
                        double? paidAmount = double.tryParse(value);
                        double toBePaidAmt =
                            _addSalesViewBloc.toBePayedAmt ?? 0;

                        if (paidAmount != null && paidAmount >= toBePaidAmt) {
                          paidAmount = toBePaidAmt;
                          _addSalesViewBloc.paidAmountController.text =
                              paidAmount.toStringAsFixed(2);
                          //    _addSalesViewBloc.paidAmountControllerStreamController.add(true);
                        }
                      },
                    ),
                    StreamBuilder<bool>(
                      stream: _addSalesViewBloc.selectedPaymentListStream,
                      builder: (context, snapshot) {
                        return Visibility(
                          visible: ['UPI', 'CARD', 'CHEQUE']
                              .contains(_addSalesViewBloc.selectedPaymentList),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 13),
                            child: SizedBox(
                              child: TldsInputFormField(
                                controller: _addSalesViewBloc
                                    .paymentTypeIdTextController,
                                hintText:
                                    '${_addSalesViewBloc.selectedPaymentList} ID',
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
      visible: _addSalesViewBloc.selectedPaymentOption == 'Pay',
      child: Column(
        children: [
          StreamBuilder<bool>(
            stream: _addSalesViewBloc.isSplitPaymentStream,
            builder: (context, snapshot) {
              return Row(
                children: [
                  Switch(
                    value: _addSalesViewBloc.isSplitPayment,
                    onChanged: (value) {
                      _addSalesViewBloc.isSplitPayment = value;
                      _addSalesViewBloc.isSplitPaymentStreamController(true);
                      _addSalesViewBloc.paidAmountController.clear();

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
              stream: _addSalesViewBloc.isSplitPaymentStream,
              builder: (context, snapshot) {
                return _addSalesViewBloc.isSplitPayment
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
                                          text: _addSalesViewBloc
                                              .splitPaymentAmt[index]);

                                  TextEditingController idController =
                                      TextEditingController(
                                          text: _addSalesViewBloc
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
                                                stream: _addSalesViewBloc
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
                                                        _addSalesViewBloc
                                                                .splitPaymentAmt[
                                                            index] = '';
                                                        _addSalesViewBloc
                                                                .splitPaymentId[
                                                            index] = '';
                                                      }
                                                      _addSalesViewBloc
                                                                  .paymentName[
                                                              index] =
                                                          _paymentsListFuture?[
                                                                  index] ??
                                                              '';
                                                      _addSalesViewBloc
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
                                              stream: _addSalesViewBloc
                                                  .splitPaymentCheckBoxStream,
                                              builder: (context, snapshot) {
                                                return Visibility(
                                                  visible: _checkedList[index],
                                                  child: Expanded(
                                                    child: StreamBuilder<bool>(
                                                        stream: _addSalesViewBloc
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
                                                              _addSalesViewBloc
                                                                      .splitPaymentAmt[
                                                                  index] = value;

                                                              double
                                                                  totalSplitPaymentAmt =
                                                                  0;
                                                              _addSalesViewBloc
                                                                  .splitPaymentAmt
                                                                  .forEach((key,
                                                                      amt) {
                                                                totalSplitPaymentAmt +=
                                                                    double.tryParse(
                                                                            amt) ??
                                                                        0;
                                                              });

                                                              if (totalSplitPaymentAmt >
                                                                  (_addSalesViewBloc
                                                                          .toBePayedAmt ??
                                                                      0)) {
                                                                setState(() {});
                                                                _addSalesViewBloc
                                                                        .splitPaymentAmt[
                                                                    index] = '';
                                                              }

                                                              _addSalesViewBloc
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
                                          stream: _addSalesViewBloc
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
                                                      _addSalesViewBloc
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
    for (int i = 0; i < _addSalesViewBloc.splitPaymentAmt.length; i++) {
      _addSalesViewBloc.splitPaymentAmt[i] = '';
      _addSalesViewBloc.splitPaymentId[i] = '';
      _checkedList[i] = false;
    }
    _addSalesViewBloc.splitPaymentCheckBoxStreamController(true);
  }

  _buildSaveBtn() {
    return CustomActionButtons(
        onPressed: () {
          if (_addSalesViewBloc.paymentFormKey.currentState!.validate()) {
            _addSalesViewBloc.addNewSalesDeatils(salesPostObject(),
                (statusCode) {
              if (statusCode == 200 || statusCode == 201) {
                Navigator.pop(context);
                _salesViewBloc.pageNumberUpdateStreamController(0);
                AppWidgetUtils.buildToast(
                    context,
                    ToastificationType.success,
                    AppConstants.salesBillScc,
                    Icon(Icons.check_circle_outline_rounded,
                        color: _appColors.successColor),
                    AppConstants.salesBillDescScc,
                    _appColors.successLightColor);
              } else {}
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
    for (var addon in _addSalesViewBloc.selectedMandatoryAddOns.keys) {
      mandatoryAddonsMap[addon] =
          _addSalesViewBloc.selectedMandatoryAddOns[addon]!;
    }

    if (_addSalesViewBloc.selectedVehicleAndAccessories == 'E-Vehicle') {
      for (var battery in _addSalesViewBloc.batteryDetailsMap.keys) {
        eVehicleComponents[battery] =
            _addSalesViewBloc.batteryDetailsMap[battery]!;
      }
    }

    if (_addSalesViewBloc.selectedVehicleAndAccessories == 'Accessories') {
      totalQty = int.tryParse(_addSalesViewBloc.totalQty.toString());
    } else {
      totalQty = _addSalesViewBloc.selectedVehiclesList?.length;
    }

    if (_addSalesViewBloc.selectedGstType == 'GST %') {
      gstDetails.add(
        GstDetail(
            gstAmount: _addSalesViewBloc.cgstAmount ?? 0,
            gstName: 'CGST',
            percentage: double.tryParse(
                    _addSalesViewBloc.cgstPresentageTextController.text) ??
                0),
      );
      gstDetails.add(
        GstDetail(
            gstAmount: _addSalesViewBloc.cgstAmount ?? 0,
            gstName: 'SGST',
            percentage: double.tryParse(
                    _addSalesViewBloc.cgstPresentageTextController.text) ??
                0),
      );
    }
    if (_addSalesViewBloc.selectedGstType == 'IGST %') {
      gstDetails.add(
        GstDetail(
            gstAmount: _addSalesViewBloc.igstAmount ?? 0,
            gstName: 'IGST',
            percentage: double.tryParse(
                    _addSalesViewBloc.igstPresentageTextController.text) ??
                0),
      );
    }
    for (int i = 0; i < _checkedList.length; i++) {
      if (_checkedList[i]) {
        String paymentType = _addSalesViewBloc.paymentName[i] ?? '';
        String paidAmount = _addSalesViewBloc.splitPaymentAmt[i] ?? '0';
        String paidId = _addSalesViewBloc.splitPaymentId[i] ?? '0';

        final paidDetail = PaidDetail(
            paidAmount: double.tryParse(paidAmount) ?? 0,
            paymentReference: paidId,
            paymentDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            paymentType: paymentType);

        paidDetails.add(paidDetail);
      }
    }
    if (_addSalesViewBloc.paidAmountController.text != '') {
      paidDetails.add(PaidDetail(
          paymentType: _addSalesViewBloc.selectedPaymentList,
          paidAmount: double.tryParse(
            _addSalesViewBloc.paidAmountController.text,
          ),
          paymentDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          paymentReference:
              _addSalesViewBloc.paymentTypeIdTextController.text));
    }

    List<Incentive> insentive = [];
    if (_addSalesViewBloc.stateIncentiveTextController.text.isNotEmpty) {
      insentive.add(Incentive(
          incentiveAmount: double.tryParse(
                  _addSalesViewBloc.stateIncentiveTextController.text) ??
              0,
          incentiveName: 'STATE INCENTIVE',
          percentage: 0));
    }

    if (_addSalesViewBloc.empsIncentiveTextController.text.isNotEmpty) {
      insentive.add(Incentive(
          incentiveAmount: double.tryParse(
                  _addSalesViewBloc.empsIncentiveTextController.text) ??
              0,
          incentiveName: 'EMPS INCENTIVE',
          percentage: 0));
    }

    List<Tax> tax = [];
    if (_addSalesViewBloc.selectedVehiclesList!.isNotEmpty) {
      for (var itemData in _addSalesViewBloc.selectedVehiclesList!) {
        final itemDetail = SalesItemDetail(
            categoryId: itemData.categoryId ?? '',
            discount: double.tryParse(
                    _addSalesViewBloc.discountTextController.text) ??
                0,
            finalInvoiceValue: _addSalesViewBloc.totalInvAmount ?? 0,
            gstDetails: gstDetails,
            hsnSacCode: _addSalesViewBloc.hsnCodeTextController.text,
            incentives: insentive,
            invoiceValue: _addSalesViewBloc.invAmount ?? 0,
            itemName: itemData.itemName ?? '',
            mainSpecValue: {
              'engineNo': itemData.mainSpecValue?.engineNo ?? '',
              'frameNo': itemData.mainSpecValue?.frameNo ?? ''
            },
            partNo: itemData.partNo ?? '',
            quantity: _addSalesViewBloc.selectedVehiclesList?.length,
            specificationsValue: {},
            stockId: itemData.stockId ?? '',
            taxableValue: _addSalesViewBloc.taxableValue ?? 0,
            taxes: tax,
            unitRate: double.tryParse(_addSalesViewBloc.unitRates[0] ?? ''),
            value: _addSalesViewBloc.totalValue ?? 0);
        itemdetails.add(itemDetail);
      }
    }

    if (_addSalesViewBloc.accessoriesItemList?.isNotEmpty ?? false) {
      for (var itemData in _addSalesViewBloc.accessoriesItemList!) {
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
        billType: _addSalesViewBloc.selectedPaymentOption,
        bookingNo: _addSalesViewBloc.bookingId,
        branchId: _addSalesViewBloc.branchId ?? '',
        customerId: _addSalesViewBloc.selectedCustomerId ?? '',
        evBattery: eVehicleComponents,
        invoiceDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        invoiceType: _addSalesViewBloc.selectedVehicleAndAccessories,
        itemDetails: itemdetails,
        mandatoryAddons: mandatoryAddonsMap,
        netAmt: double.parse(
            _addSalesViewBloc.totalInvAmount?.round().toString() ?? ''),
        paidDetails: paidDetails,
        roundOffAmt:
            double.parse(_addSalesViewBloc.totalInvAmount?.toString() ?? '') -
                double.parse(
                    _addSalesViewBloc.totalInvAmount?.round().toString() ?? ''),
        totalQty: totalQty);
  }
}
