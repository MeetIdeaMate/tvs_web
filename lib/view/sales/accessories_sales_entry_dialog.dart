import 'package:flutter/material.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/models/get_model/get_all_stocks_model.dart';
import 'package:tlbilling/models/post_model/add_sales_model.dart' as sales;
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlbilling/view/sales/add_sales_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';

class AccessoriesSalesEntryDialog extends StatefulWidget {
  final GetAllStockDetails? accessoriesDetails;
  final AddSalesBlocImpl addSalesBloc;
  final sales.SalesItemDetail? editValues;
  final int? editIndex;
  final int? selectedItemTndex;
  final double? totalQty;

  const AccessoriesSalesEntryDialog(
      {super.key,
      this.accessoriesDetails,
      required this.addSalesBloc,
      this.editValues,
      this.editIndex,
      this.selectedItemTndex,
      this.totalQty});

  @override
  State<AccessoriesSalesEntryDialog> createState() =>
      _AccessoriesSalesEntryDialogState();
}

class _AccessoriesSalesEntryDialogState
    extends State<AccessoriesSalesEntryDialog> {
  final AppColors _appColors = AppColors();

  @override
  void initState() {
    super.initState();

    widget.addSalesBloc.hsnCodeTextController.text =
        widget.accessoriesDetails?.hsnSacCode ?? '';

    if (widget.editValues != null) {
      widget.addSalesBloc.quantityTextController.text =
          widget.editValues?.quantity.toString() ?? '';
      widget.addSalesBloc.discountTextController.text =
          widget.editValues?.discount.toString() ?? '0';
      widget.addSalesBloc.unitRateTextController.text =
          widget.editValues?.unitRate.toString() ?? '';
      widget.addSalesBloc.hsnCodeTextController.text =
          widget.editValues?.hsnSacCode.toString() ?? '';

      if (widget.editValues?.gstDetails != null) {
        for (var gstDetail in widget.editValues!.gstDetails!) {
          if (gstDetail.gstName == 'CGST') {
            widget.addSalesBloc.cgstPresentageTextController.text =
                gstDetail.percentage.toString();
          } else if (gstDetail.gstName == 'SGST') {
            widget.addSalesBloc.cgstPresentageTextController.text =
                gstDetail.percentage.toString();
          } else if (gstDetail.gstName == 'IGST') {
            widget.addSalesBloc.igstPresentageTextController.text =
                gstDetail.percentage.toString();
          }
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();

    widget.addSalesBloc.discountTextController.clear();
    widget.addSalesBloc.quantityTextController.clear();
    widget.addSalesBloc.hsnCodeTextController.clear();
    widget.addSalesBloc.unitRateTextController.clear();
    widget.addSalesBloc.cgstPresentageTextController.clear();
    widget.addSalesBloc.igstPresentageTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: _appColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.all(10),
      title: _buildTitle(),
      content: _buildAccessoriesEntryForm(),
      actions: [_buildSubmitButton()],
    );
  }

  _buildTitle() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    widget.editValues != null
                        ? widget.editValues?.itemName ?? ''
                        : widget.accessoriesDetails?.itemName ?? '',
                    style:
                        TextStyle(fontSize: 15, color: _appColors.blackColor)),
                AppWidgetUtils.buildSizedBox(custHeight: 5),
                Text(
                    widget.editValues != null
                        ? widget.editValues?.partNo ?? ''
                        : widget.accessoriesDetails?.partNo ?? '',
                    style:
                        TextStyle(fontSize: 13, color: _appColors.hintColor)),
              ],
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

  _buildAccessoriesEntryForm() {
    return Form(
      key: widget.addSalesBloc.accessoriesEntryFormkey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHsnCodeField(),
          //     AppWidgetUtils.buildSizedBox(custHeight: 8),
          _buildQtyUnitRateDiscount(),
          //   AppWidgetUtils.buildSizedBox(custHeight: 8),
          _buildGstRadioBtns(),
        ],
      ),
    );
  }

  Widget _buildHsnCodeField() {
    return TldsInputFormField(
      inputFormatters: TlInputFormatters.onlyAllowNumbers,
      hintText: AppConstants.hsnCode,
      labelText: AppConstants.hsnCode,
      controller: widget.addSalesBloc.hsnCodeTextController,
      onChanged: (hsn) {},
      //   readOnly: true,
      height: 70,
      validator: (value) {
        if (value!.isEmpty) {
          return AppConstants.enterHsnCode;
        }
        return null;
      },
      focusNode: widget.addSalesBloc.hsnCodeFocus,
      onSubmit: (value) {
        FocusScope.of(context).requestFocus(widget.addSalesBloc.quantityFocus);
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
                double cgstPercentage = double.tryParse(cgst) ?? 0;
                _buildPaymentCalculation();
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

                _buildPaymentCalculation();
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

  _buildQtyUnitRateDiscount() {
    return Row(
      children: [
        // AppWidgetUtils.buildSizedBox(custWidth: 10),
        Expanded(
          child: StreamBuilder<bool>(
              stream: widget.addSalesBloc.unitRateChangeStream,
              builder: (context, snapshot) {
                return TldsInputFormField(
                  inputFormatters: TlInputFormatters.onlyAllowDecimalNumbers,
                  hintText: AppConstants.quantity,
                  controller: widget.addSalesBloc.quantityTextController,
                  focusNode: widget.addSalesBloc.quantityFocus,
                  requiredLabelText: AppWidgetUtils.labelTextWithRequired(
                      (AppConstants.quantity)),
                  height: 70,
                  onChanged: (quantity) {
                    int quantityValue = int.tryParse(
                            widget.addSalesBloc.quantityTextController.text) ??
                        0;
                    int currentQty = widget.addSalesBloc.accessoriesQty[
                                    widget.accessoriesDetails?.stockId ?? ''] ==
                                null ||
                            widget.addSalesBloc.accessoriesQty[
                                    widget.accessoriesDetails?.stockId ?? ''] ==
                                0
                        ? widget.accessoriesDetails?.quantity ?? 0
                        : widget.addSalesBloc.accessoriesQty[
                                widget.accessoriesDetails?.stockId ?? ''] ??
                            0;

                    int currentQtyEdit =
                        widget.addSalesBloc.totalAccessoriesQty[
                                widget.editValues?.stockId ?? ''] ??
                            0;
                    widget.addSalesBloc.availableAccListStream(true);
                    if (widget.editValues != null) {
                      if (quantityValue > currentQtyEdit ||
                          quantityValue == 0) {
                        widget.addSalesBloc.quantityTextController.clear();
                      }
                    } else {
                      if (quantityValue > currentQty || quantityValue == 0) {
                        widget.addSalesBloc.quantityTextController.clear();
                      }
                    }

                    _buildPaymentCalculation();
                  },
                  onSubmit: (value) {
                    FocusScope.of(context)
                        .requestFocus(widget.addSalesBloc.unitRateFocus);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppConstants.enterQuantity;
                    }
                    return null;
                  },
                );
              }),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 10),
        Expanded(
          child: TldsInputFormField(
            inputFormatters: TlInputFormatters.onlyAllowDecimalNumbers,
            hintText: AppConstants.unitRate,
            controller: widget.addSalesBloc.unitRateTextController,
            focusNode: widget.addSalesBloc.unitRateFocus,
            requiredLabelText:
                AppWidgetUtils.labelTextWithRequired((AppConstants.unitRate)),
            height: 70,
            onChanged: (unitRate) {
              _buildPaymentCalculation();
            },
            onSubmit: (value) {
              FocusScope.of(context)
                  .requestFocus(widget.addSalesBloc.discountFocus);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return AppConstants.enterUnitRate;
              }
              return null;
            },
          ),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 10),
        Expanded(
          child: TldsInputFormField(
            inputFormatters: TlInputFormatters.onlyAllowDecimalNumbers,
            hintText: AppConstants.discount,
            controller: widget.addSalesBloc.discountTextController,
            focusNode: widget.addSalesBloc.discountFocus,
            labelText: AppConstants.discountAmount,
            height: 70,
            onChanged: (discount) {
              double? discountAmount = double.tryParse(discount);
              double? unitRate = double.tryParse(
                      widget.addSalesBloc.unitRateTextController.text) ??
                  0;

              if (discountAmount != null && discountAmount > unitRate ||
                  discountAmount == 0) {
                widget.addSalesBloc.discountTextController.clear();
              }
              _buildPaymentCalculation();
            },
            onSubmit: (value) {
              FocusScope.of(context)
                  .requestFocus(widget.addSalesBloc.cgstFocus);
            },
          ),
        ),
      ],
    );
  }

  _buildSubmitButton() {
    return CustomActionButtons(
        onPressed: () {
          if (widget.addSalesBloc.accessoriesEntryFormkey.currentState!
              .validate()) {
            if (widget.editValues != null) {
              int quantityValue = int.tryParse(
                      widget.addSalesBloc.quantityTextController.text) ??
                  0;
              int currentQty = widget.addSalesBloc
                      .totalAccessoriesQty[widget.editValues?.stockId ?? ''] ??
                  widget.accessoriesDetails?.quantity ??
                  0;
              widget.addSalesBloc
                      .accessoriesQty[widget.editValues?.stockId ?? '?'] =
                  currentQty - quantityValue;

              widget.addSalesBloc.availableAccListStream(true);
              _updateData(widget.editIndex ?? 1);

              widget.addSalesBloc.paymentDetailsStreamController(true);
            } else {
              int quantityValue = int.tryParse(
                      widget.addSalesBloc.quantityTextController.text) ??
                  0;
              int currentQty = widget.addSalesBloc.accessoriesQty[
                      widget.accessoriesDetails?.stockId ?? ''] ??
                  widget.accessoriesDetails?.quantity ??
                  0;
              widget.addSalesBloc.accessoriesQty[
                      widget.accessoriesDetails?.stockId ?? ''] =
                  currentQty - quantityValue;

              widget.addSalesBloc.availableAccListStream(true);
              _saveData();
            }

            _clearInputFields();
            widget.addSalesBloc.vehicleAndEngineNumberStreamController(true);
            widget.addSalesBloc.refreshsalesDataTableController(true);
            Navigator.pop(context);
            Navigator.pop(context);
          }
        },
        buttonText: AppConstants.submit);
  }

  _buildSetValueInList() {
    List<sales.GstDetail> gstDetails = [];
    if (widget.addSalesBloc.selectedGstType == 'GST %') {
      gstDetails.add(
        sales.GstDetail(
            gstAmount: widget.addSalesBloc.cgstAmount ?? 0,
            gstName: 'CGST',
            percentage: double.tryParse(
                    widget.addSalesBloc.cgstPresentageTextController.text) ??
                0),
      );
      gstDetails.add(
        sales.GstDetail(
            gstAmount: widget.addSalesBloc.cgstAmount ?? 0,
            gstName: 'SGST',
            percentage: double.tryParse(
                    widget.addSalesBloc.cgstPresentageTextController.text) ??
                0),
      );
    }
    if (widget.addSalesBloc.selectedGstType == 'IGST %') {
      gstDetails.add(
        sales.GstDetail(
            gstAmount: widget.addSalesBloc.igstAmount ?? 0,
            gstName: 'IGST',
            percentage: double.tryParse(
                    widget.addSalesBloc.igstPresentageTextController.text) ??
                0),
      );
    }

    widget.addSalesBloc.accessoriesItemList?.add(sales.SalesItemDetail(
        categoryId: widget.accessoriesDetails?.categoryId ?? '',
        unitRate:
            double.tryParse(widget.addSalesBloc.unitRateTextController.text),
        quantity: int.tryParse(widget.addSalesBloc.quantityTextController.text),
        stockId: widget.accessoriesDetails?.stockId ?? '',
        hsnSacCode: widget.accessoriesDetails?.hsnSacCode ?? '',
        itemName: widget.accessoriesDetails?.itemName ?? '',
        partNo: widget.accessoriesDetails?.partNo,
        value: widget.addSalesBloc.totalValue ?? 0,
        discount:
            double.tryParse(widget.addSalesBloc.discountTextController.text) ??
                0,
        taxableValue: widget.addSalesBloc.taxableValue ?? 0,
        gstDetails: gstDetails,
        taxes: [],
        incentives: [],
        mainSpecValue: {},
        specificationsValue: {},
        invoiceValue: widget.addSalesBloc.invAmount ?? 0,
        finalInvoiceValue: widget.addSalesBloc.totalInvAmount ?? 0));
  }

  void _saveData() {
    _buildSetValueInList();
    widget.addSalesBloc.refreshsalesDataTableController(true);

    widget.addSalesBloc.availableAccessoriesQty = widget
            .addSalesBloc.availableAccessoriesQty ??
        0 -
            (int.tryParse(widget.addSalesBloc.quantityTextController.text) ??
                0);
  }

  void _updateData(int index) {
    List<sales.GstDetail> gstDetails = [];
    if (widget.addSalesBloc.selectedGstType == 'GST %') {
      gstDetails.add(
        sales.GstDetail(
            gstAmount: widget.addSalesBloc.cgstAmount ?? 0,
            gstName: 'CGST',
            percentage: double.tryParse(
                    widget.addSalesBloc.cgstPresentageTextController.text) ??
                0),
      );
      gstDetails.add(
        sales.GstDetail(
            gstAmount: widget.addSalesBloc.cgstAmount ?? 0,
            gstName: 'SGST',
            percentage: double.tryParse(
                    widget.addSalesBloc.cgstPresentageTextController.text) ??
                0),
      );
    }
    if (widget.addSalesBloc.selectedGstType == 'IGST %') {
      gstDetails.add(
        sales.GstDetail(
            gstAmount: widget.addSalesBloc.igstAmount ?? 0,
            gstName: 'IGST',
            percentage: double.tryParse(
                    widget.addSalesBloc.igstPresentageTextController.text) ??
                0),
      );
    }

    var updatedItem = sales.SalesItemDetail(
        categoryId: widget.editValues?.categoryId ?? '',
        unitRate:
            double.tryParse(widget.addSalesBloc.unitRateTextController.text),
        quantity: int.tryParse(widget.addSalesBloc.quantityTextController.text),
        stockId: widget.editValues?.stockId ?? '',
        hsnSacCode: widget.editValues?.hsnSacCode ?? '',
        itemName: widget.editValues?.itemName ?? '',
        partNo: widget.editValues?.partNo ?? '',
        value: widget.addSalesBloc.totalValue ?? 0,
        discount:
            double.tryParse(widget.addSalesBloc.discountTextController.text) ??
                0,
        taxableValue: widget.addSalesBloc.taxableValue,
        gstDetails: gstDetails,
        taxes: [],
        incentives: [],
        mainSpecValue: {},
        specificationsValue: {},
        invoiceValue: widget.addSalesBloc.invAmount,
        finalInvoiceValue: widget.addSalesBloc.totalInvAmount);

    widget.addSalesBloc.accessoriesItemList?[index] = updatedItem;
    widget.addSalesBloc.refreshsalesDataTableController(true);
  }

  void _buildPaymentCalculation() {
    int? qty =
        int.tryParse(widget.addSalesBloc.quantityTextController.text) ?? 0;

    double unitRate =
        double.tryParse(widget.addSalesBloc.unitRateTextController.text) ?? 0.0;

    widget.addSalesBloc.totalValue = qty * unitRate;

    double totalValues = widget.addSalesBloc.totalValue ?? 0;
    double discount =
        double.tryParse(widget.addSalesBloc.discountTextController.text) ?? 0;
    if (discount > unitRate || discount == 0) {
      widget.addSalesBloc.discountTextController.clear();
    }
    widget.addSalesBloc.taxableValue = totalValues - discount;
    double taxableValue = widget.addSalesBloc.taxableValue ?? 0;

    double cgstPercent = double.tryParse(
            widget.addSalesBloc.cgstPresentageTextController.text) ??
        0;
    double sgstPercent = double.tryParse(
            widget.addSalesBloc.cgstPresentageTextController.text) ??
        0;
    double igstPercent = double.tryParse(
            widget.addSalesBloc.igstPresentageTextController.text) ??
        0;

    if (widget.addSalesBloc.selectedGstType == 'GST %') {
      widget.addSalesBloc.cgstAmount = (taxableValue / 100) * cgstPercent;
      widget.addSalesBloc.sgstAmount = (taxableValue / 100) * sgstPercent;
      double gstAmt = (widget.addSalesBloc.cgstAmount ?? 0) +
          (widget.addSalesBloc.sgstAmount ?? 0);
      widget.addSalesBloc.invAmount = taxableValue + gstAmt;
      widget.addSalesBloc.totalInvAmount = widget.addSalesBloc.invAmount;
    }

    if (widget.addSalesBloc.selectedGstType == 'IGST %') {
      widget.addSalesBloc.igstAmount = (taxableValue / 100) * igstPercent;
      widget.addSalesBloc.invAmount =
          taxableValue + (widget.addSalesBloc.igstAmount ?? 0);
      widget.addSalesBloc.totalInvAmount = widget.addSalesBloc.invAmount;
    }
  }

  void _clearInputFields() {
    widget.addSalesBloc.hsnCodeTextController.clear();
    widget.addSalesBloc.quantityTextController.clear();
    widget.addSalesBloc.discountTextController.clear();
    widget.addSalesBloc.unitRateTextController.clear();
    widget.addSalesBloc.cgstPresentageTextController.clear();
    widget.addSalesBloc.igstPresentageTextController.clear();
  }
}
