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
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_formaters.dart';
import 'package:toastification/toastification.dart';

class PaymentDetails extends StatefulWidget {
  final AddSalesBlocImpl addSalesBloc;

  const PaymentDetails({
    super.key,
    required this.addSalesBloc,
  });

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getbranchId();
  }

  Future<void> getbranchId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    widget.addSalesBloc.branchId = prefs.getString(AppConstants.branchId);
  }

  final _appColors = AppColors();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 45, right: 30, left: 30),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeadingText(AppConstants.gstDetails),
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        _buildHsnCodeField(),
        AppWidgetUtils.buildSizedBox(custHeight: 18),
        _buildGstRadioBtns(),
      ],
    );
  }

  Widget _buildHsnCodeField() {
    return TldsInputFormField(
      inputFormatters: TlInputFormatters.onlyAllowNumbers,
      hintText: AppConstants.hsnCode,
      labelText: AppConstants.hsnCode,
      controller: widget.addSalesBloc.hsnCodeTextController,
      onChanged: (hsn) {},
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
                          //   print('Selected GST Type: $value');

                          widget.addSalesBloc.selectedGstType = value;
                          FocusScope.of(context)
                              .requestFocus(widget.addSalesBloc.igstFocus);
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
              onChanged: (cgst) {
                _calculateGST();
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
    print('gstAmt: $gstAmt');

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
              onChanged: (igst) {
                double igstPersent = double.parse(igst);
                widget.addSalesBloc.paymentDetailsStreamController(true);
                widget.addSalesBloc.gstRadioBtnRefreashStreamController(true);
                double unitRate = widget.addSalesBloc.totalUnitRate ?? 0;
                widget.addSalesBloc.paymentDetailsStreamController(true);
                widget.addSalesBloc.igstAmount = (unitRate / 10) * igstPersent;
                widget.addSalesBloc.paymentDetailsStreamController(true);
                double taxableValue = widget.addSalesBloc.taxableValue ?? 0;
                widget.addSalesBloc.paymentDetailsStreamController(true);
                widget.addSalesBloc.invAmount =
                    taxableValue + (widget.addSalesBloc.sgstAmount ?? 0 * 2);
                widget.addSalesBloc.paymentDetailsStreamController(true);
                _updateTotalInvoiceAmount();
                widget.addSalesBloc.paymentDetailsStreamController(true);

                // print('IGST changed: $igst');
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
    return StreamBuilder(
        stream: widget.addSalesBloc.paymentDetailsStream,
        builder: (context, snapshot) {
          return Container(
            padding: const EdgeInsets.all(12),
            width: MediaQuery.sizeOf(context).width * 0.36,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPaymentDetailTile(
                    AppConstants.totalValue,
                    Text(
                      widget.addSalesBloc.selectedVehiclesList!.isNotEmpty
                          ? AppUtils.formatCurrency(
                              widget.addSalesBloc.totalValue ?? 0.0)
                          : '₹0.0',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subTitle: AppConstants.totalValueA),
                _buildPaymentDetailTile(
                  AppConstants.discount,
                  subTitle: AppConstants.discountB,
                  TldsInputFormField(
                    hintText: AppConstants.rupeeHint,
                    inputFormatters:
                        TldsInputFormatters.onlyAllowDecimalNumbers,
                    width: 100,
                    height: 40,
                    controller: widget.addSalesBloc.discountTextController,
                    focusNode: widget.addSalesBloc.discountFocus,
                    onChanged: (discount) {
                      double? discountAmount = double.tryParse(discount);

                      if (widget.addSalesBloc.totalValue != 0) {
                        widget.addSalesBloc.taxableValue =
                            (widget.addSalesBloc.totalValue ?? 0) -
                                (discountAmount ?? 0);

                        widget.addSalesBloc.totalInvAmount =
                            ((widget.addSalesBloc.invAmount ?? 0) -
                                (discountAmount ?? 0));
                      }
                      _calculateGST();
                      _updateTotalInvoiceAmount();

                      widget.addSalesBloc.paymentDetailsStreamController(true);
                    },
                    onSubmit: (value) {
                      FocusScope.of(context)
                          .requestFocus(widget.addSalesBloc.empsIncentiveFocus);
                    },
                  ),
                ),
                _buildPaymentDetailTile(
                    AppConstants.taxableValue,
                    subTitle: AppConstants.taxableValueAB,
                    Text(
                      AppUtils.formatCurrency(
                          widget.addSalesBloc.taxableValue ?? 0.0),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                Text(
                  AppConstants.gstThree,
                  style: TextStyle(
                      color: _appColors.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                Container(
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
                    )),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                _buildPaymentDetailTile(
                    AppConstants.invoiceValue,
                    subTitle: AppConstants.invoiceValueThree,
                    Text(
                      AppUtils.formatCurrency(
                          widget.addSalesBloc.invAmount ?? 0.0),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                _buildPaymentDetailTile(
                    AppConstants.empsIncentive,
                    subTitle: AppConstants.empsIncentiveFour,
                    TldsInputFormField(
                      hintText: AppConstants.rupeeHint,
                      inputFormatters:
                          TldsInputFormatters.onlyAllowDecimalNumbers,
                      focusNode: widget.addSalesBloc.empsIncentiveFocus,
                      width: 100,
                      height: 40,
                      controller:
                          widget.addSalesBloc.empsIncentiveTextController,
                      onChanged: (empsInc) {
                        _updateTotalInvoiceAmount();
                      },
                      onSubmit: (value) {
                        FocusScope.of(context).requestFocus(
                            widget.addSalesBloc.stateIncentiveFocus);
                      },
                    )),
                _buildPaymentDetailTile(
                    AppConstants.stateIncentive,
                    subTitle: AppConstants.stateIncentiveFive,
                    TldsInputFormField(
                      hintText: AppConstants.rupeeHint,
                      inputFormatters:
                          TldsInputFormatters.onlyAllowDecimalNumbers,
                      focusNode: widget.addSalesBloc.stateIncentiveFocus,
                      width: 100,
                      height: 40,
                      controller:
                          widget.addSalesBloc.stateIncentiveTextController,
                      onChanged: (stateInc) {
                        _updateTotalInvoiceAmount();
                      },
                    )),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                ListTile(
                  title: const Text(AppConstants.totalInvoiceAmount,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    AppConstants.totalInvoiceAmountCalTwo,
                    style: TextStyle(color: _appColors.grey),
                  ),
                  trailing: Text(
                    AppUtils.formatCurrency(
                        widget.addSalesBloc.totalInvAmount ?? 0.0),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                Container(
                  decoration: BoxDecoration(
                      color: _appColors.amountBgColor,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(5),
                  child: ListTile(
                    title: Text(
                      AppConstants.bookAdvAmt,
                      style: TextStyle(
                          fontSize: 16, color: _appColors.primaryColor),
                    ),
                    // tileColor: _appColors.primaryColor,
                    trailing: Text(
                      '₹0.0',
                      style: TextStyle(
                          color: _appColors.primaryColor, fontSize: 16),
                    ),
                  ),
                ),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                Container(
                  decoration: BoxDecoration(
                      color: _appColors.transparentGreenColor,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(5),
                  child: ListTile(
                    title: const Text(
                      AppConstants.toBePayed,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    // tileColor: _appColors.primaryColor,
                    trailing: Text(
                      AppUtils.formatCurrency(
                          widget.addSalesBloc.totalInvAmount ?? 0.00),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                _buildPaymentOptions(),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                _buildSplitPayment(),
                _buildSaveBtn(),
              ],
            ),
          );
        });
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
                  height: 250,
                  child: ListView.separated(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) => _buildCustomRadioTile(
                      value: snapshot.data?[index].toString() ?? '',
                      groupValue: widget.addSalesBloc.selectedPaymentOption,
                      onChanged: (value) {
                        widget.addSalesBloc.selectedPaymentOption = value!;
                        widget.addSalesBloc.paymentOptionStreamController(true);
                        print(widget.addSalesBloc.selectedPaymentOption);
                      },
                      icon: Icons.payment,
                      label: snapshot.data?[index].toUpperCase() ?? '',
                    ),
                    separatorBuilder: (BuildContext context, int index) {
                      return AppWidgetUtils.buildSizedBox(custHeight: 8);
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
        width: 180,
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
  _buildSplitPayment() {
    return Visibility(
      visible: widget.addSalesBloc.selectedPaymentOption == 'Credit',
      child: Column(
        children: [
          StreamBuilder<bool>(
            stream: widget.addSalesBloc.isSplitPaymentStream,
            builder: (context, snapshot) {
              return Row(
                children: [
                  Switch(
                    value: snapshot.data ?? widget.addSalesBloc.isSplitPayment,
                    onChanged: (value) {
                      setState(() {
                        widget.addSalesBloc.isSplitPayment = value;
                      });
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
          Visibility(
            visible: widget.addSalesBloc.isSplitPayment,
            child: SizedBox(
              height: 400,
              child: FutureBuilder(
                future: widget.addSalesBloc.getPaymentsList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text(AppConstants.loading);
                  } else if (snapshot.hasError) {
                    return const Center(child: Text(AppConstants.errorLoading));
                  } else if (!snapshot.hasData) {
                    return const Center(
                        child: Text('No payment configurations available'));
                  } else {
                    if (_checkedList.isEmpty) {
                      _checkedList = List<bool>.filled(
                          snapshot.data?.configuration?.length ?? 0, false);
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.configuration?.length,
                      itemBuilder: (context, index) {
                        bool isVisible = snapshot.data?.configuration?[index] ==
                                'CHEQUE' ||
                            snapshot.data?.configuration?[index] == 'CARD' ||
                            snapshot.data?.configuration?[index] == 'UPI';
                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CheckboxListTile(
                                    title: Text(
                                        snapshot.data?.configuration?[index] ??
                                            ''),
                                    value: _checkedList[index],
                                    onChanged: (newValue) {
                                      _checkedList[index] = newValue ?? false;
                                      widget.addSalesBloc.paymentName[index] =
                                          snapshot.data
                                                  ?.configuration?[index] ??
                                              '';
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  ),
                                ),
                                AppWidgetUtils.buildSizedBox(custHeight: 10),
                                Visibility(
                                  visible: _checkedList[index],
                                  child: Expanded(
                                    child: TldsInputFormField(
                                      controller: TextEditingController(),
                                      hintText: 'Paid Amount',
                                      onChanged: (value) {
                                        widget.addSalesBloc
                                            .splitPaymentAmt[index] = value;
                                        widget.addSalesBloc
                                            .isSplitPaymentStreamController(
                                                true);
                                        print(widget.addSalesBloc
                                            .splitPaymentAmt[index] = value);
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            AppWidgetUtils.buildSizedBox(custHeight: 10),
                            Visibility(
                              visible: _checkedList[index] && isVisible,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 13),
                                child: SizedBox(
                                  child: TldsInputFormField(
                                    controller: TextEditingController(),
                                    hintText:
                                        '${snapshot.data?.configuration?[index]} ID',
                                  ),
                                ),
                              ),
                            ),
                            //  AppWidgetUtils.buildSizedBox(custHeight: 10),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
          AppWidgetUtils.buildSizedBox(custHeight: 10),
        ],
      ),
    );
  }

  _buildSaveBtn() {
    return CustomActionButtons(
        onPressed: () {
          if (widget.addSalesBloc.paymentFormKey.currentState!.validate()) {
            var salesObject = salesPostObject();

            // // Print the sales object before posting
            // print('Sales Object: $salesObject');

            widget.addSalesBloc.addNewSalesDeatils(salesPostObject(),
                (statusCode) {
              if (statusCode == 200 || statusCode == 201) {
                Navigator.of(context);
                AppWidgetUtils.buildToast(
                    context,
                    ToastificationType.success,
                    AppConstants.salesBillScc,
                    Icon(Icons.check_circle_outline_rounded,
                        color: _appColors.successColor),
                    AppConstants.salesBillDescScc,
                    _appColors.successLightColor);
              } else {
                AppWidgetUtils.buildToast(
                    context,
                    ToastificationType.error,
                    AppConstants.salesBillerr,
                    Icon(Icons.not_interested_rounded,
                        color: _appColors.errorColor),
                    AppConstants.salesBillDescerr,
                    _appColors.errorLightColor);
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
    List<PaidDetail> paidDetails = [];
    for (var addon in widget.addSalesBloc.selectedMandatoryAddOns.keys) {
      mandatoryAddonsMap[addon] =
          widget.addSalesBloc.selectedMandatoryAddOns[addon]!;
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

        final paidDetail = PaidDetail(
            paidAmount: double.tryParse(paidAmount) ?? 0,
            paymentDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            paymentType: paymentType);

        paidDetails.add(paidDetail);
      }
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
            quantity: itemData.quantity ?? 0,
            specificationsValue: {},
            stockId: itemData.stockId ?? '',
            taxableValue: itemData.purchaseItem?.taxableValue ?? 0,
            taxes: tax,
            unitRate: itemData.purchaseItem?.unitRate ?? 1,
            value: itemData.purchaseItem?.value ?? 0);
        itemdetails.add(itemDetail);
      }
    }

    if (widget.addSalesBloc.slectedAccessoriesList!.isNotEmpty) {
      for (var itemData in widget.addSalesBloc.slectedAccessoriesList!) {
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
            mainSpecValue: {},
            partNo: itemData.partNo ?? '',
            quantity: itemData.quantity ?? 0,
            specificationsValue: {},
            stockId: itemData.stockId ?? '',
            taxableValue: itemData.purchaseItem?.taxableValue ?? 0,
            taxes: tax,
            unitRate: itemData.purchaseItem?.unitRate ?? 1,
            value: itemData.purchaseItem?.value ?? 0);
        itemdetails.add(itemDetail);
      }
    }

    return AddSalesModel(
        billType: widget.addSalesBloc.selectedPaymentOption,
        branchId: widget.addSalesBloc.branchId ?? '',
        customerId: widget.addSalesBloc.selectedCustomerId ?? '',
        evBattery: EvBatteryObj(
            evBatteryCapacity: 50,
            evBatteryName:
                widget.addSalesBloc.batteryDetailsMap['Battery Name']),
        invoiceDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        invoiceType: widget.addSalesBloc.selectedVehicleAndAccessories,
        itemDetails: itemdetails,
        // loaninfo: Loaninfo(bankName: '', loanAmt: 0, loanId: ''),
        mandatoryAddons: mandatoryAddonsMap,
        netAmt: 0,
        paidDetails: paidDetails,
        paymentStatus: 'COMPLETED',
        roundOffAmt:
            double.parse(widget.addSalesBloc.totalInvAmount.toString()),
        totalQty: widget.addSalesBloc.selectedVehiclesList?.length ??
            widget.addSalesBloc.slectedAccessoriesList?.length ??
            0);
  }
}
