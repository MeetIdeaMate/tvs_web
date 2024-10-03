import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/models/post_model/add_sales_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlbilling/view/sales/add_sales_bloc.dart';
import 'package:tlbilling/view/sales/insurance_entry_bloc.dart';
import 'package:tlbilling/view/sales/insurance_entry_dialog.dart';
import 'package:tlbilling/view/sales/sales_view_bloc.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:toastification/toastification.dart';

class PaymentMethods extends StatefulWidget {
  final AddSalesBlocImpl addSalesBloc;
  final SalesViewBlocImpl salesViewBloc;

  const PaymentMethods({
    super.key,
    required this.addSalesBloc,
    required this.salesViewBloc,
  });

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  List<String>? _paymentsListFuture;
  final _insuranceBloc = InsuranceEntryBlocImpl();

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

  final _appColors = AppColors();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 45, right: 30, left: 30, bottom: 20),
      child: StreamBuilder(
          stream: widget.addSalesBloc.paymentDetailsStream,
          builder: (context, snapshot) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInsuranceEntryDialog(context),
                  AppWidgetUtils.buildSizedBox(custHeight: 10),
                  _buildPaymentDetailTile(
                      'RTO',
                      TldsInputFormField(
                        hintText: AppConstants.rupeeHint,
                        width: 100,
                        height: 40,
                        inputFormatters:
                            TlInputFormatters.onlyAllowDecimalNumbers,
                        controller: widget.addSalesBloc.rtoAmountTextController,
                        onChanged: (value) {
                          _updateOtherAmountDetails();
                        },
                      )),
                  _buildPaymentDetailTile(
                      'Manditory Fitting',
                      TldsInputFormField(
                        hintText: AppConstants.rupeeHint,
                        width: 100,
                        height: 40,
                        inputFormatters:
                            TlInputFormatters.onlyAllowDecimalNumbers,
                        controller: widget
                            .addSalesBloc.manditoryFittingAmountTextControler,
                        onChanged: (p0) {
                          _updateOtherAmountDetails();
                        },
                      )),
                  _buildPaymentDetailTile(
                      'Optional Acc',
                      TldsInputFormField(
                        hintText: AppConstants.rupeeHint,
                        width: 100,
                        height: 40,
                        inputFormatters:
                            TlInputFormatters.onlyAllowDecimalNumbers,
                        controller: widget
                            .addSalesBloc.optionlFittingAmountTextController,
                        onChanged: (p0) {
                          _updateOtherAmountDetails();
                        },
                      )),
                  _buildPaymentDetailTile(
                      'Other',
                      TldsInputFormField(
                        hintText: AppConstants.rupeeHint,
                        width: 100,
                        height: 40,
                        inputFormatters:
                            TlInputFormatters.onlyAllowDecimalNumbers,
                        controller:
                            widget.addSalesBloc.otherAmountTextController,
                        onChanged: (p0) {
                          _updateOtherAmountDetails();
                        },
                      )),
                  _buildPaymentDetailTile(
                      'Discount',
                      TldsInputFormField(
                        hintText: AppConstants.rupeeHint,
                        width: 100,
                        height: 40,
                        inputFormatters:
                            TlInputFormatters.onlyAllowDecimalNumbers,
                        controller:
                            widget.addSalesBloc.discountAmountTextController,
                        onChanged: (p0) {
                          _updateOtherAmountDetails();
                        },
                      )),
                  AppWidgetUtils.buildSizedBox(custHeight: 10),
                  _buildToBePayed(),
                  AppWidgetUtils.buildSizedBox(custHeight: 10),
                  _buildPaymentDetails(),
                ],
              ),
            );
          }),
    );
  }

  Widget _buildToBePayed() {
    return StreamBuilder(
        stream: widget.addSalesBloc.paymentDetailsStream,
        builder: (context, snapshot) {
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
                AppUtils.formatCurrency(widget.addSalesBloc.toBePayed ?? 0.00),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          );
        });
  }

  Widget _buildInsuranceEntryDialog(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          border: Border.all(color: Colors.black12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        hoverColor: _appColors.bgHighlightColor,
        title: const Text(
          'InSurance Entry',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        onTap: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog.adaptive(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                title: const Text('Insurance Entry'),
                actions: [
                  CustomActionButtons(
                      onPressed: () {
                        if (_insuranceBloc.insuranceFormKey.currentState!
                            .validate()) {
                          Navigator.pop(context);
                          setState(() {
                            _insuranceBloc.isInsuranceEntryDone = true;
                          });
                        }
                      },
                      buttonText: 'Submit')
                ],
                content: InsuranceEntryDialog(_insuranceBloc)),
          );
        },
        trailing: Icon(
          size: 24,
          _insuranceBloc.isInsuranceEntryDone ?? false
              ? Icons.check_circle
              : Icons.info_rounded,
          color: _insuranceBloc.isInsuranceEntryDone ?? false
              ? Colors.green
              : Colors.red,
        ),
      ),
    );
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
                        double toBePayed = widget.addSalesBloc.toBePayed ?? 0;

                        if (paidAmount != null && paidAmount >= toBePayed) {
                          paidAmount = toBePayed;
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
                                                                          .toBePayed ??
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
      if (_insuranceBloc.isInsuranceEntryDone == false) {
        AppWidgetUtils.buildToast(
          context,
          ToastificationType.error,
          'Insurance Entry',
          Icon(Icons.not_interested_rounded, color: _appColors.errorColor),
          'Please enter the insurance details before saving the sales bill!',
          _appColors.errorLightColor,
        );
      } else if (widget.addSalesBloc.paymentFormKey.currentState!.validate()) {
        widget.addSalesBloc.addNewSalesDeatils(salesPostObject(), (statusCode) {
          if (statusCode == 200 || statusCode == 201) {
            Navigator.pop(context);
            widget.salesViewBloc.pageNumberUpdateStreamController(0);
            AppWidgetUtils.buildToast(
              context,
              ToastificationType.success,
              AppConstants.salesBillScc,
              Icon(Icons.check_circle_outline_rounded, color: _appColors.successColor),
              AppConstants.salesBillDescScc,
              _appColors.successLightColor,
            );
          } else {
            AppWidgetUtils.buildToast(
              context,
              ToastificationType.error,
              AppConstants.salesBillerr,
              Icon(Icons.not_interested_rounded, color: _appColors.errorColor),
              AppConstants.salesBillDescerr,
              _appColors.errorLightColor,
            );
          }
        });
      }
    },
    buttonText: AppConstants.save,
  );
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
            addOns: widget.addSalesBloc.previousValuesAddOns,
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
    final insuranceData = InsuranceObj(
      insuranceCompanyName:
          _insuranceBloc.insuranceCompanyNameTextController.text,
      insuranceNo: _insuranceBloc.insureNumberTextController.text,
      insuredAmt:
          double.tryParse(_insuranceBloc.insureAmountTextController.text) ??
              0.0,
      insuredDate: AppUtils.appToAPIDateFormat(
          _insuranceBloc.insureDateTextController.text),
      ownDmgExpiryDate: AppUtils.appToAPIDateFormat(
          _insuranceBloc.ownEmgDateExpTextController.text),
      thirdPartyExpiryDate: AppUtils.appToAPIDateFormat(
          _insuranceBloc.thirdPartyExpTextController.text),
      premiumAmt:
          double.tryParse(_insuranceBloc.premiumAmountTextController.text) ??
              0.0,
    );
    return AddSalesModel(
      insurance: insuranceData,
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
      roundOffAmt:
          double.parse(widget.addSalesBloc.totalInvAmount?.toString() ?? '') -
              double.parse(
                  widget.addSalesBloc.totalInvAmount?.round().toString() ?? ''),
      totalQty: totalQty,
      others:
          double.tryParse(widget.addSalesBloc.otherAmountTextController.text),
      mandatoryFitting: double.tryParse(
          widget.addSalesBloc.manditoryFittingAmountTextControler.text),
      optionFitting: double.tryParse(
          widget.addSalesBloc.optionlFittingAmountTextController.text),
      rtoCharges:
          double.tryParse(widget.addSalesBloc.rtoAmountTextController.text),
    );
  }

  void _updateOtherAmountDetails() {
    double rtoAmount =
        double.tryParse(widget.addSalesBloc.rtoAmountTextController.text) ?? 0;
    double manditoryFittingAmount = double.tryParse(
            widget.addSalesBloc.manditoryFittingAmountTextControler.text) ??
        0;
    double optionalAcc = double.tryParse(
            widget.addSalesBloc.optionlFittingAmountTextController.text) ??
        0;
    double otherAmount =
        double.tryParse(widget.addSalesBloc.otherAmountTextController.text) ??
            0;

    double discountAmount = double.tryParse(
            widget.addSalesBloc.discountAmountTextController.text) ??
        0;
    double tobepayedAmount = widget.addSalesBloc.exShowrRomPrice ?? 0;

    double totalAmount = rtoAmount +
        manditoryFittingAmount +
        optionalAcc +
        otherAmount +
        tobepayedAmount;

    if (discountAmount > 0) {
      totalAmount -= discountAmount;
    }

    widget.addSalesBloc.toBePayed = totalAmount;

    widget.addSalesBloc.paymentDetailsStreamController(true);

    // Print total amount for debugging
    print('Total Amount after discount: $totalAmount');
  }
}
