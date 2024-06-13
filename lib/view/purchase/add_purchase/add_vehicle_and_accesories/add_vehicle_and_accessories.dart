import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/models/parent_response_model.dart';
import 'package:tlbilling/models/purchase_bill_data.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_vehicle_and_accesories/add_vehicle_and_accessories_bloc.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_vehicle_and_accesories/vehicle_purchase_details.dart';
import 'package:tlbilling/view/vendor/create_vendor_dialog.dart';
import 'package:tlds_flutter/export.dart';
import 'package:toastification/toastification.dart';

class AddVehicleAndAccessories extends StatefulWidget {
  AddVehicleAndAccessoriesBlocImpl purchaseBloc;
  AddVehicleAndAccessories({super.key, required this.purchaseBloc});

  @override
  State<AddVehicleAndAccessories> createState() =>
      _AddVehicleAndAccessoriesState();
}

class _AddVehicleAndAccessoriesState extends State<AddVehicleAndAccessories> {
  final _appColors = AppColors();

  final List<String> vehicleAndAccessories = ['Vehicle', 'Accessories'];

  @override
  void initState() {
    super.initState();
    widget.purchaseBloc.selectedPurchaseTypeStreamController(true);
    widget.purchaseBloc.getAllCategoryList();
    widget.purchaseBloc.selectedGstType = AppConstants.gstPercent;
    widget.purchaseBloc.gstRadioBtnRefreshStreamController(true);
    _setCategoryValueInitially();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.sizeOf(context).width * 0.36,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: _appColors.grey),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: widget.purchaseBloc.purchaseFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildInvoiceDetails(),
                _buildVehicleDetails(),
                Visibility(
                  visible: widget.purchaseBloc.selectedPurchaseType !=
                      AppConstants.accessories,
                  child: EngineAndFrameNumberEntry(
                      addVehicleAndAccessoriesBloc: widget.purchaseBloc),
                ),
                _buildHsnCodeAndGSTSelection(),
                _buildPaymentDetails(),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: _buildAddToTableButton(),
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildInvoiceDetails() {
    return Container(
        width: MediaQuery.sizeOf(context).width * 0.36,
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: _appColors.greyColor))),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCustomTextWidget(
                AppConstants.vendorDetails,
                fontSize: 20,
                color: _appColors.primaryColor,
              ),
              _buildDefaultHeight(),
              _buildSelectVendorDropDownAndAddNewButton(),
              _buildDefaultHeight(),
              _buildInvoiceDateAndNumber(),
              _buildDefaultHeight(),
              _buildPurchaseRef(),
              _buildDefaultHeight(),
            ],
          ),
        ));
  }

  Widget _buildVehicleDetails() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          border:
              Border.symmetric(horizontal: BorderSide(color: _appColors.grey))),
      width: MediaQuery.sizeOf(context).width * 0.36,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDefaultHeight(),
          _buildCategoryHeader(),
          _buildDefaultHeight(),
          _buildVehicleAccessoriesSegmentedButton(),
          AppWidgetUtils.buildSizedBox(custHeight: 10),
          _buildPartNumberHint(),
          AppWidgetUtils.buildSizedBox(custHeight: 10),
          _buildPartNoAndUnitRate(),
          AppWidgetUtils.buildSizedBox(custHeight: 10),
          _buildVehicleName(),
          _buildDefaultHeight(),
        ],
      ),
    );
  }

  Widget _buildHsnCodeAndGSTSelection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          border:
              Border.symmetric(horizontal: BorderSide(color: _appColors.grey))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildCustomTextWidget(
          AppConstants.gstDetails,
          fontSize: 20,
          color: _appColors.primaryColor,
        ),
        _buildHsnCodeField(),
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        _buildGstDetails(),
      ]),
    );
  }

  Widget _buildPaymentDetails() {
    return StreamBuilder<bool>(
        stream: widget.purchaseBloc.paymentDetailsStream,
        builder: (context, snapshot) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                border: Border.symmetric(
                    horizontal: BorderSide(color: _appColors.greyColor))),
            width: MediaQuery.sizeOf(context).width * 0.36,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPaymentDetailTile(
                    AppConstants.totalValue,
                    Text(
                      widget.purchaseBloc.engineDetailsList.isNotEmpty ||
                              widget.purchaseBloc.selectedPurchaseType ==
                                  AppConstants.accessories
                          ? AppUtils.formatCurrency(
                              widget.purchaseBloc.totalValue ?? 0.0)
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
                    width: 100,
                    height: 40,
                    controller: widget.purchaseBloc.discountTextController,
                    onChanged: (discount) {
                      double? discountAmount = double.tryParse(discount);

                      widget.purchaseBloc.taxableValue =
                          (widget.purchaseBloc.totalValue ?? 0) -
                              (discountAmount ?? 0);

                      widget.purchaseBloc.totalInvAmount =
                          ((widget.purchaseBloc.invAmount ?? 0) -
                              (discountAmount ?? 0));

                      widget.purchaseBloc.paymentDetailsStreamController(true);
                    },
                  ),
                ),
                _buildPaymentDetailTile(
                    AppConstants.taxableValue,
                    subTitle: AppConstants.taxableValueAB,
                    Text(
                      AppUtils.formatCurrency(
                          widget.purchaseBloc.taxableValue ?? 0.0),
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
                        color: _appColors.hightlightColor,
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Visibility(
                          visible: widget.purchaseBloc.selectedGstType ==
                              AppConstants.igstPercent,
                          child: _buildPaymentDetailTile(
                              AppConstants.igstAmount,
                              Text(
                                AppUtils.formatCurrency(
                                    widget.purchaseBloc.igstAmount ?? 0.0),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )),
                        ),
                        Visibility(
                          visible: widget.purchaseBloc.selectedGstType ==
                              AppConstants.gstPercent,
                          child: _buildPaymentDetailTile(
                              AppConstants.cgstAmount,
                              Text(
                                AppUtils.formatCurrency(
                                    widget.purchaseBloc.cgstAmount ?? 0.0),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )),
                        ),
                        Visibility(
                          visible: widget.purchaseBloc.selectedGstType ==
                              AppConstants.gstPercent,
                          child: _buildPaymentDetailTile(
                              AppConstants.sgstAmount,
                              Text(
                                AppUtils.formatCurrency(
                                    widget.purchaseBloc.sgstAmount ?? 0.0),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                    )),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                _buildPaymentDetailTile(
                  AppConstants.tcsValue,
                  subTitle: AppConstants.tcsValueThree,
                  TldsInputFormField(
                    hintText: AppConstants.rupeeHint,
                    width: 100,
                    height: 40,
                    controller: widget.purchaseBloc.tcsvalueTextController,
                    onChanged: (tcsValue) {
                      double? parsedTcsValue = double.tryParse(
                          widget.purchaseBloc.tcsvalueTextController.text);

                      double taxableValue =
                          widget.purchaseBloc.taxableValue ?? 0;
                      double cgstAmount = widget.purchaseBloc.cgstAmount ?? 0;
                      double sgstAmount = widget.purchaseBloc.sgstAmount ?? 0;

                      double gstAmount = cgstAmount + sgstAmount;

                      widget.purchaseBloc.invAmount =
                          (taxableValue + gstAmount) + (parsedTcsValue ?? 0.0);

                      widget.purchaseBloc.totalInvAmount =
                          (taxableValue + gstAmount) + (parsedTcsValue ?? 0.0);

                      widget.purchaseBloc.paymentDetailsStreamController(true);
                    },
                  ),
                ),
                _buildPaymentDetailTile(
                    AppConstants.invoiceValue,
                    subTitle: AppConstants.invoiceValueFour,
                    Text(
                      AppUtils.formatCurrency(
                          widget.purchaseBloc.invAmount ?? 0.0),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                _buildPaymentDetailTile(
                    AppConstants.empsIncentive,
                    subTitle: AppConstants.empsIncentiveFive,
                    TldsInputFormField(
                      hintText: AppConstants.rupeeHint,
                      width: 100,
                      height: 40,
                      controller:
                          widget.purchaseBloc.empsIncentiveTextController,
                      onChanged: (empsInc) {
                        double? empsIncValue = double.tryParse(widget
                            .purchaseBloc.empsIncentiveTextController.text);

                        widget.purchaseBloc.totalInvAmount =
                            (widget.purchaseBloc.totalInvAmount ?? 0) -
                                (empsIncValue ?? 0);

                        widget.purchaseBloc
                            .paymentDetailsStreamController(true);
                      },
                    )),
                _buildPaymentDetailTile(
                    AppConstants.stateIncentive,
                    subTitle: AppConstants.stateIncentiveSix,
                    TldsInputFormField(
                      hintText: AppConstants.rupeeHint,
                      width: 100,
                      height: 40,
                      controller:
                          widget.purchaseBloc.stateIncentiveTextController,
                      onChanged: (stateInc) {
                        double? stateIncValue = double.tryParse(widget
                            .purchaseBloc.stateIncentiveTextController.text);

                        widget.purchaseBloc.totalInvAmount =
                            (widget.purchaseBloc.totalInvAmount ?? 0) -
                                (stateIncValue ?? 0);

                        widget.purchaseBloc
                            .paymentDetailsStreamController(true);
                      },
                    )),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: _appColors.transparentGreenColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: const Text(AppConstants.totalInvoiceAmount),
                    subtitle: Text(
                      AppConstants.totalInvoiceAmountCal,
                      style: TextStyle(color: _appColors.grey),
                    ),
                    trailing: Text(
                      AppUtils.formatCurrency(
                          widget.purchaseBloc.totalInvAmount ?? 0.0),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
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

  Widget _buildGstDetails() {
    return StreamBuilder<bool>(
        stream: widget.purchaseBloc.gstRadioBtnRefreashStream,
        builder: (context, snapshot) {
          return Row(
            children: [
              Row(
                children:
                    widget.purchaseBloc.gstTypeOptions.map((gstTypeOption) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Radio<String>(
                          value: gstTypeOption,
                          groupValue: widget.purchaseBloc.selectedGstType,
                          onChanged: (String? value) {
                            FocusScope.of(context).requestFocus(
                                widget.purchaseBloc.carrierNameFocusNode);
                            setState(() {
                              widget.purchaseBloc.selectedGstType = value;
                              widget.purchaseBloc.cgstPresentageTextController
                                  .clear();
                              widget.purchaseBloc.sgstPresentageTextController
                                  .clear();
                              widget.purchaseBloc.igstPresentageTextController
                                  .clear();
                              widget.purchaseBloc.cgstAmount = 0;
                              widget.purchaseBloc.sgstAmount = 0;
                              widget.purchaseBloc.igstAmount = 0;
                              widget.purchaseBloc
                                  .paymentDetailsStreamController(true);
                            });
                          },
                        ),
                        Text(gstTypeOption),
                      ],
                    ),
                  );
                }).toList(),
              ),
              AppWidgetUtils.buildSizedBox(custWidth: 10),
              if (widget.purchaseBloc.selectedGstType ==
                  AppConstants.gstPercent) ...[
                Flexible(
                    child: TldsInputFormField(
                  inputFormatters: TlInputFormatters.onlyAllowDecimalNumbers,
                  hintText: AppConstants.cgstPercent,
                  controller: widget.purchaseBloc.cgstPresentageTextController,
                  onChanged: (cgst) {
                    var cgstPercentage = double.tryParse(widget
                            .purchaseBloc.cgstPresentageTextController.text) ??
                        0.0;
                    var sgstPercentage = double.tryParse(widget
                            .purchaseBloc.cgstPresentageTextController.text) ??
                        0.0;

                    if (widget.purchaseBloc.taxableValue != null) {
                      var cgstAmount = widget.purchaseBloc.taxableValue! *
                          (cgstPercentage / 100);
                      var sgstAmount = widget.purchaseBloc.taxableValue! *
                          (sgstPercentage / 100);
                      widget.purchaseBloc.cgstAmount = cgstAmount;
                      widget.purchaseBloc.sgstAmount = sgstAmount;
                      final gstAmount = cgstAmount + sgstAmount;
                      widget.purchaseBloc.invAmount =
                          gstAmount + (widget.purchaseBloc.taxableValue ?? 0.0);

                      widget.purchaseBloc.totalInvAmount =
                          gstAmount + (widget.purchaseBloc.taxableValue ?? 0.0);

                      widget.purchaseBloc.paymentDetailsStreamController(true);
                    }
                  },
                )),
                AppWidgetUtils.buildSizedBox(custWidth: 10),
                Flexible(
                    child: TldsInputFormField(
                  enabled: false,
                  inputFormatters: TlInputFormatters.onlyAllowDecimalNumbers,
                  hintText: AppConstants.sgstPercent,
                  controller: widget.purchaseBloc.cgstPresentageTextController,
                )),
              ] else if (widget.purchaseBloc.selectedGstType ==
                  AppConstants.igstPercent) ...[
                Flexible(
                    child: TldsInputFormField(
               inputFormatters: TlInputFormatters.onlyAllowDecimalNumbers,
                  hintText: AppConstants.igstPercent,
                  controller: widget.purchaseBloc.igstPresentageTextController,
                  onChanged: (igst) {
                    var igstPresentage = double.tryParse(widget
                            .purchaseBloc.igstPresentageTextController.text) ??
                        0.0;
                    if (widget.purchaseBloc.taxableValue != null) {
                      var igstAmount = widget.purchaseBloc.taxableValue! *
                          (igstPresentage / 100);

                      widget.purchaseBloc.igstAmount = igstAmount;

                      widget.purchaseBloc.invAmount = igstAmount +
                          (widget.purchaseBloc.taxableValue ?? 0.0);

                      widget.purchaseBloc.totalInvAmount = igstAmount +
                          (widget.purchaseBloc.taxableValue ?? 0.0);

                      widget.purchaseBloc.paymentDetailsStreamController(true);
                    }
                  },
                )),
              ],
            ],
          );
        });
  }

  Widget _buildSelectVendorDropDownAndAddNewButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FutureBuilder(
          future: widget.purchaseBloc.getAllVendorNameList(),
          builder: (context, snapshot) {
            var vendorList = snapshot.data?.result?.getAllVendorNameList;
            List<String>? vendorNames =
                vendorList?.map((e) => e.vendorName ?? '').toList();
            return TldsDropDownButtonFormField(
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return AppConstants.selectVendor;
                }
                return null;
              },
              width: MediaQuery.sizeOf(context).width * 0.22,
              hintText: AppConstants.selectVendor,
              dropDownItems: vendorNames ?? [],
              onChange: (String? newValue) {
                var selectedVendor = vendorList!
                    .firstWhere((vendor) => vendor.vendorName == newValue);
                widget.purchaseBloc.selectedVendorId = selectedVendor.vendorId;
              },
            );
          },
        ),
        _buildDefaultWidth(),
        Expanded(
            child: CustomElevatedButton(
          height: 45,
          fontColor: _appColors.whiteColor,
          buttonBackgroundColor: _appColors.primaryColor,
          suffixIcon: SvgPicture.asset(AppConstants.icHumanAdd),
          text: AppConstants.addNew,
          fontSize: 14,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return const CreateVendorDialog();
              },
            );
          },
        )),
      ],
    );
  }

  Widget _buildInvoiceDateAndNumber() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: TldsInputFormField(
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return AppConstants.enterInvoiceNo;
            }
            return null;
          },
          inputFormatters: TlInputFormatters.onlyAllowAlphabetAndNumber,
          labelText: AppConstants.invoiceNo,
          hintText: AppConstants.invoiceNo,
          controller: widget.purchaseBloc.invoiceNumberController,
          onSubmit: (invoiceNo) {
            FocusScope.of(context)
                .requestFocus(widget.purchaseBloc.inVoiceDateFocusNode);
            _selectDate(context, widget.purchaseBloc.invoiceDateController);
          },
        )),
        _buildDefaultWidth(),
        Expanded(
          child: TldsInputFormField(
            focusNode: widget.purchaseBloc.inVoiceDateFocusNode,
            controller: widget.purchaseBloc.invoiceDateController,
            requiredLabelText: const Text(AppConstants.invoiceDate),
            inputFormatters: TlInputFormatters.onlyAllowDate,
            hintText: 'dd/mm/yyyy',
            suffixIcon: IconButton(
                onPressed: () => _selectDate(
                    context, widget.purchaseBloc.invoiceDateController),
                icon: SvgPicture.asset(AppConstants.icDate)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppConstants.selectInvoiceDate;
              }
              return null;
            },
            onTap: () =>
                _selectDate(context, widget.purchaseBloc.invoiceDateController),
          ),
        ),
      ],
    );
  }

  Widget _buildPurchaseRef() {
    return TldsInputFormField(
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return AppConstants.enterPurchaseRefNo;
          }
          return null;
        },
        inputFormatters: TlInputFormatters.onlyAllowAlphabetAndNumber,
        focusNode: widget.purchaseBloc.purchaseRefFocusNode,
        labelText: AppConstants.purchaseRef,
        hintText: AppConstants.purchaseOrderRef,
        controller: widget.purchaseBloc.purchaseRefController);
  }

  Widget _buildCategoryHeader() {
    return StreamBuilder(
      stream: widget.purchaseBloc.selectedPurchaseTypeStream,
      builder: (context, snapshot) {
        return _buildCustomTextWidget(
          '${widget.purchaseBloc.selectedPurchaseType ?? 'Vehicle'} ${AppConstants.details}',
          fontSize: 20,
          color: _appColors.primaryColor,
        );
      },
    );
  }

  Widget _buildVehicleAccessoriesSegmentedButton() {
    return SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: FutureBuilder(
          future: widget.purchaseBloc.getAllCategoryList(),
          builder: (context, snapshot) {
            return IgnorePointer(
              ignoring: widget.purchaseBloc.purchaseBillDataList.isNotEmpty,
              child: SegmentedButton(
                multiSelectionEnabled: false,
                segments: List.generate(snapshot.data?.category?.length ?? 1,
                    (index) {
                  return ButtonSegment(
                      value: snapshot.data?.category?[index].categoryName ?? '',
                      label: Text(
                        snapshot.data?.category?[index].categoryName ?? '',
                      ));
                }),
                selected: widget.purchaseBloc.optionsSet,
                onSelectionChanged: (Set<String> newValue) {
                  widget.purchaseBloc
                      .selectedPurchaseTypeStreamController(true);
                  setState(() {
                    widget.purchaseBloc.optionsSet = newValue;

                    widget.purchaseBloc.selectedPurchaseType =
                        widget.purchaseBloc.optionsSet.first;

                    String categoryId = snapshot.data!.category!
                        .where((e) =>
                            e.categoryName ==
                            widget.purchaseBloc.selectedPurchaseType)
                        .map((e) => e.categoryId)
                        .toString();

                    categoryId = categoryId.substring(1, categoryId.length - 1);

                    widget.purchaseBloc.categoryId = categoryId;

                    final selectedCategory =
                        snapshot.data!.category!.firstWhere(
                      (category) =>
                          category.categoryName ==
                          widget.purchaseBloc.selectedPurchaseType,
                    );

                    widget.purchaseBloc.hsnCodeController.text =
                        selectedCategory.hsnSacCode ?? '';

                    widget.purchaseBloc.selectedCategory = selectedCategory;
                    widget.purchaseBloc
                        .selectedPurchaseTypeStreamController(true);
                  });
                },
                style: ButtonStyle(
                  backgroundColor: widget.purchaseBloc
                      .changeSegmentedColor(_appColors.segmentedButtonColor),
                ),
              ),
            );
          },
        ));
  }

  Widget _buildPartNumberHint() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(AppConstants.icInfo),
        AppWidgetUtils.buildSizedBox(custWidth: 8),
        Expanded(
            child: Text(
          AppConstants.partNoHint,
          style: TextStyle(color: _appColors.grey),
        ))
      ],
    );
  }

  Widget _buildPartNoAndUnitRate() {
    return Row(
      children: [
        Expanded(
          child: TldsInputFormField(
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return AppConstants.enterPartNo;
              }
              return null;
            },
            inputFormatters: TlInputFormatters.onlyAllowAlphabetAndNumber,
            focusNode: widget.purchaseBloc.partNoFocusNode,
            labelText: widget.purchaseBloc.selectedPurchaseType !=
                    AppConstants.accessories
                ? AppConstants.partNo
                : AppConstants.materialNumber,
            hintText: widget.purchaseBloc.selectedPurchaseType !=
                    AppConstants.accessories
                ? AppConstants.partNo
                : AppConstants.materialNumber,
            controller: widget.purchaseBloc.partNumberController,
            onSubmit: (partNumberValue) {
              widget.purchaseBloc.getPurchasePartNoDetails(
                (statusCode) {
                  if (statusCode == 401 || statusCode == 400) {
                    AppWidgetUtils.buildToast(
                        context,
                        ToastificationType.error,
                        AppConstants.partNoError,
                        Icon(Icons.check_circle_outline_rounded,
                            color: _appColors.errorColor),
                        AppConstants.partNoErrorDes,
                        _appColors.errorLightColor);
                  }
                },
              ).then((partDetails) {
                _getAndSetValuesForInputFields(partDetails);
              });
              FocusScope.of(context)
                  .requestFocus(widget.purchaseBloc.unitRateFocusNode);
            },
          ),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 10),
        TldsInputFormField(
          width: 180,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return AppConstants.enterUnitRate;
            }
            return null;
          },
          inputFormatters: TlInputFormatters.onlyAllowDecimalNumbers,
          focusNode: widget.purchaseBloc.unitRateFocusNode,
          labelText: AppConstants.unitRate,
          hintText: AppConstants.rupeeHint,
          controller: widget.purchaseBloc.unitRateController,
          onChanged: (unitPrice) {
            widget.purchaseBloc.totalValue =
                double.tryParse(widget.purchaseBloc.unitRateController.text);
            widget.purchaseBloc.paymentDetailsStreamController(true);
          },
          onSubmit: (p0) {
            FocusScope.of(context)
                .requestFocus(widget.purchaseBloc.engineNoFocusNode);
          },
        ),
      ],
    );
  }

  Widget _buildVehicleName() {
    return Row(
      children: [
        Expanded(
          child: TldsInputFormField(
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return AppConstants.enterVehiceName;
              }
              return null;
            },
            focusNode: widget.purchaseBloc.vehiceNameFocusNode,
            labelText: widget.purchaseBloc.selectedPurchaseType !=
                    AppConstants.accessories
                ? AppConstants.vehicleName
                : AppConstants.materialName,
            hintText: widget.purchaseBloc.selectedPurchaseType !=
                    AppConstants.accessories
                ? AppConstants.vehicleName
                : AppConstants.materialName,
            controller: widget.purchaseBloc.vehicleNameTextController,
            onSubmit: (p0) {
              FocusScope.of(context)
                  .requestFocus(widget.purchaseBloc.hsnCodeFocusNode);
            },
          ),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 10),
        Visibility(
          visible: widget.purchaseBloc.selectedPurchaseType ==
              AppConstants.accessories,
          child: TldsInputFormField(
            labelText: AppConstants.quantity,
            hintText: AppConstants.quantity,
            width: 180,
            controller: widget.purchaseBloc.quantityController,
            onChanged: (qty) {
              updateTotalValue();
            },
          ),
        )
      ],
    );
  }

  Widget _buildHsnCodeField() {
    return TldsInputFormField(
      enabled:
          widget.purchaseBloc.selectedPurchaseType == AppConstants.accessories,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return AppConstants.enterHsnCode;
        }
        return null;
      },
      focusNode: widget.purchaseBloc.hsnCodeFocusNode,
      labelText: AppConstants.hsnCode,
      hintText: AppConstants.enterHsnCode,
      controller: widget.purchaseBloc.hsnCodeController,
      onSubmit: (p0) {
        FocusScope.of(context)
            .requestFocus(widget.purchaseBloc.hsnCodeFocusNode);
      },
    );
  }

  Widget _buildAddToTableButton() {
    return CustomElevatedButton(
      suffixIcon: SvgPicture.asset(AppConstants.icAdd),
      buttonBackgroundColor: _appColors.primaryColor,
      fontColor: _appColors.whiteColor,
      text: AppConstants.addToTable,
      fontSize: 16,
      onPressed: () {
        _purchaseTableAmountCalculation();
        if (widget.purchaseBloc.purchaseFormKey.currentState!.validate()) {
          final newVehicle = VehicleDetails(
            incentiveType: widget.purchaseBloc.isEmpsIncChecked
                ? AppConstants.empsIncetive
                : AppConstants.stateInc,
            cgstAmount: widget.purchaseBloc.cgstAmount,
            categoryId: widget.purchaseBloc.categoryId,
            invoiceValue: widget.purchaseBloc.invAmount,
            sgstAmount: widget.purchaseBloc.sgstAmount,
            taxableValue: widget.purchaseBloc.taxableValue!,
            totalInvoiceValue: widget.purchaseBloc.totalInvAmount,
            totalValue: widget.purchaseBloc.totalValue!,
            igstAmount: widget.purchaseBloc.igstAmount,
            discountPresentage: double.tryParse(
                widget.purchaseBloc.discountTextController.text),
            discountValue: widget.purchaseBloc.discountValue,
            cgstPercentage: double.tryParse(
                widget.purchaseBloc.cgstPresentageTextController.text),
            sgstPercentage: double.tryParse(
                widget.purchaseBloc.cgstPresentageTextController.text),
            igstPercentage: double.tryParse(
                widget.purchaseBloc.igstPresentageTextController.text),
            empsIncentive: double.tryParse(
                widget.purchaseBloc.empsIncentiveTextController.text),
            gstType: widget.purchaseBloc.selectedGstType,
            stateIncentive: double.tryParse(
                widget.purchaseBloc.stateIncentiveTextController.text),
            tcsValue: double.tryParse(
                widget.purchaseBloc.tcsvalueTextController.text),
            partNo: widget.purchaseBloc.partNumberController.text,
            vehicleName: widget.purchaseBloc.vehicleNameTextController.text,
            hsnCode: int.tryParse(widget.purchaseBloc.hsnCodeController.text),
            qty: widget.purchaseBloc.selectedPurchaseType != 'Accessories'
                ? widget.purchaseBloc.engineDetailsList.length
                : int.tryParse(widget.purchaseBloc.quantityController.text) ??
                    0,
            unitRate:
                double.tryParse(widget.purchaseBloc.unitRateController.text) ??
                    0,
            engineDetails: widget.purchaseBloc.engineDetailsList
                .map((map) => EngineDetails(
                      engineNo: map.engineNo,
                      frameNo: map.frameNo,
                    ))
                .toList(),
          );
          final newPurchase = PurchaseBillData(
            vehicleDetails: [newVehicle],
          );
          widget.purchaseBloc.purchaseBillDataList.add(newPurchase);
          clearPurchaseDataValue();
          widget.purchaseBloc.refreshPurchaseDataTableList(true);
        } else {}
      },
    );
  }

  Widget _buildDefaultWidth() {
    return AppWidgetUtils.buildSizedBox(
        custWidth: MediaQuery.sizeOf(context).width * 0.01);
  }

  Widget _buildDefaultHeight() {
    return AppWidgetUtils.buildSizedBox(
        custHeight: MediaQuery.sizeOf(context).height * 0.02);
  }

  Widget _buildCustomTextWidget(String text,
      {Color? color, double? fontSize, FontWeight? fontWeight}) {
    return Text(
      text,
      style: GoogleFonts.poppins(
          color: color, fontWeight: fontWeight, fontSize: fontSize),
    );
  }

  clearPurchaseDataValue() {
    widget.purchaseBloc.partNumberController.clear();
    widget.purchaseBloc.unitRateController.clear();
    widget.purchaseBloc.engineNumberController.clear();
    widget.purchaseBloc.frameNumberController.clear();
    widget.purchaseBloc.vehicleNameTextController.clear();
    widget.purchaseBloc.empsIncentiveTextController.clear();
    widget.purchaseBloc.stateIncentiveTextController.clear();
    widget.purchaseBloc.tcsvalueTextController.clear();
    widget.purchaseBloc.discountTextController.clear();
    widget.purchaseBloc.quantityController.clear();
    widget.purchaseBloc.engineDetailsList.clear();
    widget.purchaseBloc.engineDetailsStreamController(true);
    widget.purchaseBloc.refreshEngineDetailsListStramController(true);
    setState(() {
      widget.purchaseBloc.totalValue = 0;
      widget.purchaseBloc.discountTextController.clear();
      widget.purchaseBloc.taxableValue = 0;
      widget.purchaseBloc.cgstAmount = 0;
      widget.purchaseBloc.sgstAmount = 0;
      widget.purchaseBloc.tcsvalueTextController.clear();
      widget.purchaseBloc.invAmount = 0;
      widget.purchaseBloc.totalInvAmount = 0;
    });

    widget.purchaseBloc.paymentDetailsStreamController(true);
  }

  void _purchaseTableAmountCalculation() {
    var qty = double.tryParse(
            widget.purchaseBloc.engineDetailsList.length.toString()) ??
        0.0;
    var unitRate =
        double.tryParse(widget.purchaseBloc.unitRateController.text) ?? 0.0;
    var totalValue = qty * unitRate;
    if (widget.purchaseBloc.selectedPurchaseType == 'Accessories') {
      totalValue =
          (int.tryParse(widget.purchaseBloc.quantityController.text) ?? 0) *
              unitRate;
    }
    widget.purchaseBloc.totalValue = totalValue;
    var discount =
        double.tryParse(widget.purchaseBloc.discountTextController.text) ?? 0.0;
    var taxableValue = totalValue - discount;
    widget.purchaseBloc.taxableValue = taxableValue;
    var discountPercentage =
        double.tryParse(widget.purchaseBloc.discountTextController.text) ?? 0.0;
    var discountValue = totalValue * (discountPercentage / 100);
    widget.purchaseBloc.discountValue = discountValue;
    var tcsValue =
        double.tryParse(widget.purchaseBloc.tcsvalueTextController.text) ?? 0.0;
    double gstAmount = 0.0;

    if (widget.purchaseBloc.selectedGstType == 'GST %') {
      var cgstPercentage = double.tryParse(
              widget.purchaseBloc.cgstPresentageTextController.text) ??
          0.0;
      var sgstPercentage = double.tryParse(
              widget.purchaseBloc.cgstPresentageTextController.text) ??
          0.0;
      var cgstAmount = taxableValue * (cgstPercentage / 100);
      var sgstAmount = taxableValue * (sgstPercentage / 100);
      widget.purchaseBloc.cgstAmount = cgstAmount;
      widget.purchaseBloc.sgstAmount = sgstAmount;
      gstAmount = cgstAmount + sgstAmount;
    } else if (widget.purchaseBloc.selectedGstType == 'IGST %') {
      var igstPercentage = double.tryParse(
              widget.purchaseBloc.igstPresentageTextController.text) ??
          0.0;
      gstAmount = taxableValue * (igstPercentage / 100);
    }
    var invoiceValue = taxableValue + gstAmount;
    widget.purchaseBloc.invAmount = invoiceValue + tcsValue;
    var empsIncentive =
        double.tryParse(widget.purchaseBloc.empsIncentiveTextController.text) ??
            0.0;
    var stateIncentive = double.tryParse(
            widget.purchaseBloc.stateIncentiveTextController.text) ??
        0.0;
    var totalIncentive = empsIncentive + stateIncentive;
    var totalInvoiceAmount = invoiceValue - totalIncentive;
    widget.purchaseBloc.totalInvAmount = totalInvoiceAmount;
  }

  void _getAndSetValuesForInputFields(ParentResponseModel partDetails) {
    var vehchileById = partDetails.result?.purchaseByPartNo;

    setState(() {
      widget.purchaseBloc.vehicleNameTextController.text =
          vehchileById?.itemName ?? '';

      widget.purchaseBloc.unitRateController.text =
          vehchileById?.unitRate.toString() ?? '';

      // Set GST values
      for (var gstDetail in vehchileById?.gstDetails ?? []) {
        if (gstDetail.gstName == 'CGST' || gstDetail.gstName == 'SGST') {
          widget.purchaseBloc.selectedGstType = AppConstants.gstPercent;
          widget.purchaseBloc.gstRadioBtnRefreshStreamController(true);
          widget.purchaseBloc.cgstPresentageTextController.text =
              gstDetail.percentage?.toString() ?? '';
          widget.purchaseBloc.sgstPresentageTextController.text =
              gstDetail.percentage?.toString() ?? '';
        } else {
          widget.purchaseBloc.selectedGstType = AppConstants.igstPercent;
          widget.purchaseBloc.gstRadioBtnRefreshStreamController(true);
          widget.purchaseBloc.igstPresentageTextController.text =
              gstDetail.percentage?.toString() ?? '';
        }
      }

      // Set incentives
      for (var incentive in vehchileById?.incentives ?? []) {
        if (incentive.incentiveName == 'StateIncentive') {
          widget.purchaseBloc.isStateIncChecked = true;

          widget.purchaseBloc.incentiveCheckBoxStreamController(true);
          widget.purchaseBloc.stateIncentiveTextController.text =
              incentive.incentiveAmount?.toString() ?? '';
        } else if (incentive.incentiveName == 'EMPS 2024 Incentive') {
          widget.purchaseBloc.isEmpsIncChecked = true;
          widget.purchaseBloc.incentiveCheckBoxStreamController(true);
          widget.purchaseBloc.empsIncentiveTextController.text =
              incentive.incentiveAmount?.toString() ?? '';
        }
      }

      // Set taxes
      for (var tax in vehchileById?.taxes ?? []) {
        if (tax.taxName == 'TcsValue') {
          widget.purchaseBloc.isTcsValueChecked = true;
          widget.purchaseBloc.taxValueCheckboxStreamController(true);
          widget.purchaseBloc.tcsvalueTextController.text =
              tax.taxAmount?.toString() ?? '';
          widget.purchaseBloc.isTcsValueChecked = tax.percentage > 0;
        }
      }

      // Update total values
      widget.purchaseBloc.totalValue = vehchileById?.value?.toDouble();
      widget.purchaseBloc.discountValue = vehchileById?.discount?.toDouble();
      widget.purchaseBloc.taxableValue = vehchileById?.taxableValue?.toDouble();
      widget.purchaseBloc.totalInvAmount =
          vehchileById?.finalInvoiceValue?.toDouble();
    });
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController date) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date.text.isEmpty
          ? DateTime.now()
          : AppUtils.appStringToDateTime(date.text),
      firstDate: DateTime(0001, 01, 01),
      lastDate: DateTime(9999, 12, 31),
    );
    if (picked != null) {
      final formattedDate = AppUtils.apiToAppDateFormat(picked.toString());
      widget.purchaseBloc.invoiceDateController.text = formattedDate;
      FocusScope.of(context)
          .requestFocus(widget.purchaseBloc.purchaseRefFocusNode);
    }
  }

  void _setCategoryValueInitially() {
    widget.purchaseBloc.getAllCategoryList().then((categoryValue) {
      if (categoryValue?.category?.isNotEmpty ?? false) {
        setState(() {
          var firstCategory = categoryValue!.category!.first;
          widget.purchaseBloc.optionsSet = {
            firstCategory.categoryName.toString()
          };
          widget.purchaseBloc.selectedPurchaseType = firstCategory.categoryName;
          widget.purchaseBloc.categoryId = firstCategory.categoryId;
          widget.purchaseBloc.hsnCodeController.text =
              firstCategory.hsnSacCode ?? '';
          widget.purchaseBloc.selectedCategory = firstCategory;
          widget.purchaseBloc.selectedPurchaseTypeStreamController(true);
        });
      }
    });
  }

  void updateTotalValue() {
    double? unitRate =
        double.tryParse(widget.purchaseBloc.unitRateController.text);
    double? totalQty =
        double.tryParse(widget.purchaseBloc.quantityController.text);
    widget.purchaseBloc.totalValue = (unitRate ?? 0) * (totalQty ?? 0);
    widget.purchaseBloc.paymentDetailsStreamController(true);
    widget.purchaseBloc.taxableValue = (unitRate ?? 0) * (totalQty ?? 0);
    widget.purchaseBloc.invAmount = (unitRate ?? 0) * (totalQty ?? 0);
    widget.purchaseBloc.totalInvAmount = (unitRate ?? 0) * (totalQty ?? 0);
  }
}
