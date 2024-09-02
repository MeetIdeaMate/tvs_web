import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/service_locator.dart';
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

  final sales.SalesItemDetail? editValues;
  final int? editIndex;
  final int? selectedItemTndex;
  final double? totalQty;

  const AccessoriesSalesEntryDialog(
      {super.key,
      this.accessoriesDetails,
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
  final _addSalesBloc = getIt<AddSalesBlocImpl>();

  @override
  void initState() {
    super.initState();

    _addSalesBloc.hsnCodeTextController.text =
        widget.accessoriesDetails?.hsnSacCode ?? '';

    if (widget.editValues != null) {
      _addSalesBloc.quantityTextController.text =
          widget.editValues?.quantity.toString() ?? '';
      _addSalesBloc.discountTextController.text =
          widget.editValues?.discount.toString() ?? '0';
      _addSalesBloc.unitRateTextController.text =
          widget.editValues?.unitRate.toString() ?? '';
      _addSalesBloc.hsnCodeTextController.text =
          widget.editValues?.hsnSacCode.toString() ?? '';

      if (widget.editValues?.gstDetails != null) {
        for (var gstDetail in widget.editValues!.gstDetails!) {
          if (gstDetail.gstName == 'CGST') {
            _addSalesBloc.cgstPresentageTextController.text =
                gstDetail.percentage.toString();
          } else if (gstDetail.gstName == 'SGST') {
            _addSalesBloc.cgstPresentageTextController.text =
                gstDetail.percentage.toString();
          } else if (gstDetail.gstName == 'IGST') {
            _addSalesBloc.igstPresentageTextController.text =
                gstDetail.percentage.toString();
          }
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();

    _addSalesBloc.discountTextController.clear();
    _addSalesBloc.quantityTextController.clear();
    _addSalesBloc.hsnCodeTextController.clear();
    _addSalesBloc.unitRateTextController.clear();
    _addSalesBloc.cgstPresentageTextController.clear();
    _addSalesBloc.igstPresentageTextController.clear();
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
      key: _addSalesBloc.accessoriesEntryFormkey,
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
      controller: _addSalesBloc.hsnCodeTextController,
      onChanged: (hsn) {},
      //   readOnly: true,
      height: 70,
      validator: (value) {
        if (value!.isEmpty) {
          return AppConstants.enterHsnCode;
        }
        return null;
      },
      focusNode: _addSalesBloc.hsnCodeFocus,
      onSubmit: (value) {
        FocusScope.of(context).requestFocus(_addSalesBloc.quantityFocus);
      },
    );
  }

  Widget _buildGstRadioBtns() {
    return StreamBuilder<bool>(
      stream: _addSalesBloc.gstRadioBtnRefreashStream,
      builder: (context, snapshot) {
        return Row(
          children: [
            Row(
              children: _addSalesBloc.gstTypeOptions.map((gstTypeOption) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: gstTypeOption,
                        groupValue: _addSalesBloc.selectedGstType,
                        onChanged: (String? value) {
                          _addSalesBloc.selectedGstType = value;
                          FocusScope.of(context)
                              .requestFocus(_addSalesBloc.igstFocus);
                          _addSalesBloc
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
            if (_addSalesBloc.selectedGstType == AppConstants.gstPercent)
              _buildGstPercentFields()
            else if (_addSalesBloc.selectedGstType == AppConstants.igstPercent)
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
              controller: _addSalesBloc.cgstPresentageTextController,
              focusNode: _addSalesBloc.cgstFocus,
              height: 40,
              maxLength: 5,
              counterText: '',
              onChanged: (cgst) {
                double cgstPercentage = double.tryParse(cgst) ?? 0;
                _buildPaymentCalculation();
                if (cgstPercentage > 100) {
                  _addSalesBloc.cgstPresentageTextController.clear();
                }
              },
              onSubmit: (value) {
                FocusScope.of(context)
                    .requestFocus(_addSalesBloc.discountFocus);
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
              controller: _addSalesBloc.cgstPresentageTextController,
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
              controller: _addSalesBloc.igstPresentageTextController,
              focusNode: _addSalesBloc.igstFocus,
              height: 40,
              maxLength: 5,
              counterText: '',
              onChanged: (igst) {
                double igstPercent = double.tryParse(igst) ?? 0;
                if (igstPercent > 100) {
                  _addSalesBloc.igstPresentageTextController.clear();
                }

                _buildPaymentCalculation();
              },
              onSubmit: (value) {
                FocusScope.of(context)
                    .requestFocus(_addSalesBloc.discountFocus);
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
              stream: _addSalesBloc.unitRateChangeStream,
              builder: (context, snapshot) {
                return TldsInputFormField(
                  inputFormatters: TlInputFormatters.onlyAllowDecimalNumbers,
                  hintText: AppConstants.quantity,
                  controller: _addSalesBloc.quantityTextController,
                  focusNode: _addSalesBloc.quantityFocus,
                  requiredLabelText: AppWidgetUtils.labelTextWithRequired(
                      (AppConstants.quantity)),
                  height: 70,
                  onChanged: (quantity) {
                    int quantityValue = int.tryParse(
                            _addSalesBloc.quantityTextController.text) ??
                        0;
                    int currentQty = _addSalesBloc.accessoriesQty[
                                    widget.accessoriesDetails?.stockId ?? ''] ==
                                null ||
                            _addSalesBloc.accessoriesQty[
                                    widget.accessoriesDetails?.stockId ?? ''] ==
                                0
                        ? widget.accessoriesDetails?.quantity ?? 0
                        : _addSalesBloc.accessoriesQty[
                                widget.accessoriesDetails?.stockId ?? ''] ??
                            0;

                    int currentQtyEdit = _addSalesBloc.totalAccessoriesQty[
                            widget.editValues?.stockId ?? ''] ??
                        0;
                    _addSalesBloc.availableAccListStream(true);
                    if (widget.editValues != null) {
                      if (quantityValue > currentQtyEdit ||
                          quantityValue == 0) {
                        _addSalesBloc.quantityTextController.clear();
                      }
                    } else {
                      if (quantityValue > currentQty || quantityValue == 0) {
                        _addSalesBloc.quantityTextController.clear();
                      }
                    }

                    _buildPaymentCalculation();
                  },
                  onSubmit: (value) {
                    FocusScope.of(context)
                        .requestFocus(_addSalesBloc.unitRateFocus);
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
            controller: _addSalesBloc.unitRateTextController,
            focusNode: _addSalesBloc.unitRateFocus,
            requiredLabelText:
                AppWidgetUtils.labelTextWithRequired((AppConstants.unitRate)),
            height: 70,
            onChanged: (unitRate) {
              _buildPaymentCalculation();
            },
            onSubmit: (value) {
              FocusScope.of(context).requestFocus(_addSalesBloc.discountFocus);
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
            controller: _addSalesBloc.discountTextController,
            focusNode: _addSalesBloc.discountFocus,
            labelText: AppConstants.discountAmount,
            height: 70,
            onChanged: (discount) {
              double? discountAmount = double.tryParse(discount);
              double? unitRate =
                  double.tryParse(_addSalesBloc.unitRateTextController.text) ??
                      0;

              if (discountAmount != null && discountAmount >= unitRate ||
                  discountAmount == 0) {
                _addSalesBloc.discountTextController.clear();
              }
              _buildPaymentCalculation();
            },
            onSubmit: (value) {
              FocusScope.of(context).requestFocus(_addSalesBloc.cgstFocus);
            },
          ),
        ),
      ],
    );
  }

  _buildSubmitButton() {
    return CustomActionButtons(
        onPressed: () {
          if (_addSalesBloc.accessoriesEntryFormkey.currentState!.validate()) {
            if (widget.editValues != null) {
              int quantityValue =
                  int.tryParse(_addSalesBloc.quantityTextController.text) ?? 0;
              int currentQty = _addSalesBloc
                      .totalAccessoriesQty[widget.editValues?.stockId ?? ''] ??
                  widget.accessoriesDetails?.quantity ??
                  0;
              _addSalesBloc.accessoriesQty[widget.editValues?.stockId ?? '?'] =
                  currentQty - quantityValue;

              _addSalesBloc.availableAccListStream(true);
              _updateData(widget.editIndex ?? 1);

              _addSalesBloc.paymentDetailsStreamController(true);
            } else {
              int quantityValue =
                  int.tryParse(_addSalesBloc.quantityTextController.text) ?? 0;
              int currentQty = _addSalesBloc.accessoriesQty[
                      widget.accessoriesDetails?.stockId ?? ''] ??
                  widget.accessoriesDetails?.quantity ??
                  0;
              _addSalesBloc.accessoriesQty[widget.accessoriesDetails?.stockId ??
                  ''] = currentQty - quantityValue;

              _addSalesBloc.availableAccListStream(true);
              _saveData();
            }

            _clearInputFields();
            _addSalesBloc.vehicleAndEngineNumberStreamController(true);
            _addSalesBloc.refreshsalesDataTableController(true);
            Navigator.pop(context);
          }
        },
        buttonText: AppConstants.submit);
  }

  _buildSetValueInList() {
    List<sales.GstDetail> gstDetails = [];
    if (_addSalesBloc.selectedGstType == 'GST %') {
      gstDetails.add(
        sales.GstDetail(
            gstAmount: _addSalesBloc.cgstAmount ?? 0,
            gstName: 'CGST',
            percentage: double.tryParse(
                    _addSalesBloc.cgstPresentageTextController.text) ??
                0),
      );
      gstDetails.add(
        sales.GstDetail(
            gstAmount: _addSalesBloc.cgstAmount ?? 0,
            gstName: 'SGST',
            percentage: double.tryParse(
                    _addSalesBloc.cgstPresentageTextController.text) ??
                0),
      );
    }
    if (_addSalesBloc.selectedGstType == 'IGST %') {
      gstDetails.add(
        sales.GstDetail(
            gstAmount: _addSalesBloc.igstAmount ?? 0,
            gstName: 'IGST',
            percentage: double.tryParse(
                    _addSalesBloc.igstPresentageTextController.text) ??
                0),
      );
    }

    _addSalesBloc.accessoriesItemList?.add(sales.SalesItemDetail(
        categoryId: widget.accessoriesDetails?.categoryId ?? '',
        unitRate: double.tryParse(_addSalesBloc.unitRateTextController.text),
        quantity: int.tryParse(_addSalesBloc.quantityTextController.text),
        stockId: widget.accessoriesDetails?.stockId ?? '',
        hsnSacCode: widget.accessoriesDetails?.hsnSacCode ?? '',
        itemName: widget.accessoriesDetails?.itemName ?? '',
        partNo: widget.accessoriesDetails?.partNo,
        value: _addSalesBloc.totalValue ?? 0,
        discount:
            double.tryParse(_addSalesBloc.discountTextController.text) ?? 0,
        taxableValue: _addSalesBloc.taxableValue ?? 0,
        gstDetails: gstDetails,
        taxes: [],
        incentives: [],
        mainSpecValue: {},
        specificationsValue: {},
        invoiceValue: _addSalesBloc.invAmount ?? 0,
        finalInvoiceValue: _addSalesBloc.totalInvAmount ?? 0));
  }

  void _saveData() {
    _buildSetValueInList();
    _addSalesBloc.refreshsalesDataTableController(true);

    _addSalesBloc.availableAccessoriesQty =
        _addSalesBloc.availableAccessoriesQty ??
            0 - (int.tryParse(_addSalesBloc.quantityTextController.text) ?? 0);
  }

  void _updateData(int index) {
    List<sales.GstDetail> gstDetails = [];
    if (_addSalesBloc.selectedGstType == 'GST %') {
      gstDetails.add(
        sales.GstDetail(
            gstAmount: _addSalesBloc.cgstAmount ?? 0,
            gstName: 'CGST',
            percentage: double.tryParse(
                    _addSalesBloc.cgstPresentageTextController.text) ??
                0),
      );
      gstDetails.add(
        sales.GstDetail(
            gstAmount: _addSalesBloc.cgstAmount ?? 0,
            gstName: 'SGST',
            percentage: double.tryParse(
                    _addSalesBloc.cgstPresentageTextController.text) ??
                0),
      );
    }
    if (_addSalesBloc.selectedGstType == 'IGST %') {
      gstDetails.add(
        sales.GstDetail(
            gstAmount: _addSalesBloc.igstAmount ?? 0,
            gstName: 'IGST',
            percentage: double.tryParse(
                    _addSalesBloc.igstPresentageTextController.text) ??
                0),
      );
    }

    var updatedItem = sales.SalesItemDetail(
        categoryId: widget.editValues?.categoryId ?? '',
        unitRate: double.tryParse(_addSalesBloc.unitRateTextController.text),
        quantity: int.tryParse(_addSalesBloc.quantityTextController.text),
        stockId: widget.editValues?.stockId ?? '',
        hsnSacCode: widget.editValues?.hsnSacCode ?? '',
        itemName: widget.editValues?.itemName ?? '',
        partNo: widget.editValues?.partNo ?? '',
        value: _addSalesBloc.totalValue ?? 0,
        discount:
            double.tryParse(_addSalesBloc.discountTextController.text) ?? 0,
        taxableValue: _addSalesBloc.taxableValue,
        gstDetails: gstDetails,
        taxes: [],
        incentives: [],
        mainSpecValue: {},
        specificationsValue: {},
        invoiceValue: _addSalesBloc.invAmount,
        finalInvoiceValue: _addSalesBloc.totalInvAmount);

    _addSalesBloc.accessoriesItemList?[index] = updatedItem;
    _addSalesBloc.refreshsalesDataTableController(true);
  }

  void _buildPaymentCalculation() {
    int? qty = int.tryParse(_addSalesBloc.quantityTextController.text) ?? 0;

    double unitRate =
        double.tryParse(_addSalesBloc.unitRateTextController.text) ?? 0.0;

    _addSalesBloc.totalValue = qty * unitRate;

    double totalValues = _addSalesBloc.totalValue ?? 0;
    double discount =
        double.tryParse(_addSalesBloc.discountTextController.text) ?? 0;
    if (discount >= unitRate || discount == 0) {
      _addSalesBloc.discountTextController.clear();
    }
    _addSalesBloc.taxableValue = totalValues - discount;
    double taxableValue = _addSalesBloc.taxableValue ?? 0;

    double cgstPercent =
        double.tryParse(_addSalesBloc.cgstPresentageTextController.text) ?? 0;
    double sgstPercent =
        double.tryParse(_addSalesBloc.cgstPresentageTextController.text) ?? 0;
    double igstPercent =
        double.tryParse(_addSalesBloc.igstPresentageTextController.text) ?? 0;

    if (_addSalesBloc.selectedGstType == 'GST %') {
      _addSalesBloc.cgstAmount = (taxableValue / 100) * cgstPercent;
      _addSalesBloc.sgstAmount = (taxableValue / 100) * sgstPercent;
      double gstAmt =
          (_addSalesBloc.cgstAmount ?? 0) + (_addSalesBloc.sgstAmount ?? 0);
      _addSalesBloc.invAmount = taxableValue + gstAmt;
      _addSalesBloc.totalInvAmount = _addSalesBloc.invAmount;
    }

    if (_addSalesBloc.selectedGstType == 'IGST %') {
      _addSalesBloc.igstAmount = (taxableValue / 100) * igstPercent;
      _addSalesBloc.invAmount = taxableValue + (_addSalesBloc.igstAmount ?? 0);
      _addSalesBloc.totalInvAmount = _addSalesBloc.invAmount;
    }
  }

  void _clearInputFields() {
    _addSalesBloc.hsnCodeTextController.clear();
    _addSalesBloc.quantityTextController.clear();
    _addSalesBloc.discountTextController.clear();
    _addSalesBloc.unitRateTextController.clear();
    _addSalesBloc.cgstPresentageTextController.clear();
    _addSalesBloc.igstPresentageTextController.clear();
  }
}
