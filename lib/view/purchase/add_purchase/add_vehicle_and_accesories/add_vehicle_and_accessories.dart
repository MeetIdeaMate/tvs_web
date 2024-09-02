import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tlbilling/api_service/service_locator.dart';
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
  const AddVehicleAndAccessories({
    super.key,
  });

  @override
  State<AddVehicleAndAccessories> createState() =>
      _AddVehicleAndAccessoriesState();
}

class _AddVehicleAndAccessoriesState extends State<AddVehicleAndAccessories> {
  final _appColors = AppColors();
  final _addPurchaseBloc = getIt<AddVehicleAndAccessoriesBlocImpl>();
  final List<String> vehicleAndAccessories = ['Vehicle', 'Accessories'];

  @override
  void initState() {
    super.initState();
    _addPurchaseBloc.selectedPurchaseTypeStreamController(true);
    _addPurchaseBloc.getAllCategoryList();
    _addPurchaseBloc.selectedGstType = AppConstants.gstPercent;
    _addPurchaseBloc.gstRadioBtnRefreshStreamController(true);
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
            key: _addPurchaseBloc.purchaseFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildInvoiceDetails(),
                _buildVehicleDetails(),
                Visibility(
                  visible: _addPurchaseBloc.selectedPurchaseType !=
                      AppConstants.accessories,
                  child: EngineAndFrameNumberEntry(
                      addVehicleAndAccessoriesBloc: _addPurchaseBloc),
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
        stream: _addPurchaseBloc.paymentDetailsStream,
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
                      _addPurchaseBloc.engineDetailsList.isNotEmpty ||
                              _addPurchaseBloc.selectedPurchaseType ==
                                  AppConstants.accessories
                          ? AppUtils.formatCurrency(
                              _addPurchaseBloc.totalValue ?? 0.0)
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
                    inputFormatters:
                        TldsInputFormatters.onlyAllowDecimalNumbers,
                    controller: _addPurchaseBloc.discountTextController,
                    onChanged: (discount) {
                      double? discountAmount = double.tryParse(discount);
                      double totalValue = _addPurchaseBloc.totalValue ?? 0;
                      if (discountAmount != null &&
                          discountAmount > totalValue) {
                        discountAmount = 0;
                        _addPurchaseBloc.discountTextController.text =
                            discountAmount.toStringAsFixed(2);
                      }

                      _addPurchaseBloc.taxableValue =
                          (_addPurchaseBloc.totalValue ?? 0) -
                              (discountAmount ?? 0);

                      _addPurchaseBloc.totalInvAmount =
                          ((_addPurchaseBloc.invAmount ?? 0) -
                              (discountAmount ?? 0));

                      _addPurchaseBloc.paymentDetailsStreamController(true);
                    },
                  ),
                ),
                _buildPaymentDetailTile(
                    AppConstants.taxableValue,
                    subTitle: AppConstants.taxableValueAB,
                    Text(
                      AppUtils.formatCurrency(
                          _addPurchaseBloc.taxableValue ?? 0.0),
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
                          visible: _addPurchaseBloc.selectedGstType ==
                              AppConstants.igstPercent,
                          child: _buildPaymentDetailTile(
                              AppConstants.igstAmount,
                              Text(
                                AppUtils.formatCurrency(
                                    _addPurchaseBloc.igstAmount ?? 0.0),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )),
                        ),
                        Visibility(
                          visible: _addPurchaseBloc.selectedGstType ==
                              AppConstants.gstPercent,
                          child: _buildPaymentDetailTile(
                              AppConstants.cgstAmount,
                              Text(
                                AppUtils.formatCurrency(
                                    _addPurchaseBloc.cgstAmount ?? 0.0),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )),
                        ),
                        Visibility(
                          visible: _addPurchaseBloc.selectedGstType ==
                              AppConstants.gstPercent,
                          child: _buildPaymentDetailTile(
                              AppConstants.sgstAmount,
                              Text(
                                AppUtils.formatCurrency(
                                    _addPurchaseBloc.sgstAmount ?? 0.0),
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
                    controller: _addPurchaseBloc.tcsvalueTextController,
                    inputFormatters:
                        TldsInputFormatters.onlyAllowDecimalAfterTwoDigits,
                    onChanged: (tcsValue) {
                      double? parsedTcsValue = double.tryParse(
                          _addPurchaseBloc.tcsvalueTextController.text);

                      double taxableValue = _addPurchaseBloc.taxableValue ?? 0;
                      double cgstAmount = _addPurchaseBloc.cgstAmount ?? 0;
                      double sgstAmount = _addPurchaseBloc.sgstAmount ?? 0;

                      double gstAmount = cgstAmount + sgstAmount;

                      _addPurchaseBloc.invAmount =
                          (taxableValue + gstAmount) + (parsedTcsValue ?? 0.0);

                      _addPurchaseBloc.totalInvAmount =
                          (taxableValue + gstAmount) + (parsedTcsValue ?? 0.0);

                      _addPurchaseBloc.paymentDetailsStreamController(true);
                    },
                  ),
                ),
                _buildPaymentDetailTile(
                    AppConstants.invoiceValue,
                    subTitle: AppConstants.invoiceValueFour,
                    Text(
                      AppUtils.formatCurrency(
                          _addPurchaseBloc.invAmount ?? 0.0),
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
                      inputFormatters:
                          TldsInputFormatters.onlyAllowDecimalAfterTwoDigits,
                      controller: _addPurchaseBloc.empsIncentiveTextController,
                      onChanged: (empsInc) {
                        _updateTotalInvoiceAmount();
                      },
                    )),
                _buildPaymentDetailTile(
                    AppConstants.stateIncentive,
                    subTitle: AppConstants.stateIncentiveSix,
                    TldsInputFormField(
                      hintText: AppConstants.rupeeHint,
                      width: 100,
                      height: 40,
                      inputFormatters:
                          TldsInputFormatters.onlyAllowDecimalAfterTwoDigits,
                      controller: _addPurchaseBloc.stateIncentiveTextController,
                      onChanged: (stateInc) {
                        _updateTotalInvoiceAmount();
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
                          _addPurchaseBloc.totalInvAmount ?? 0.0),
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
        stream: _addPurchaseBloc.gstRadioBtnRefreashStream,
        builder: (context, snapshot) {
          return Row(
            children: [
              Row(
                children: _addPurchaseBloc.gstTypeOptions.map((gstTypeOption) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Radio<String>(
                          value: gstTypeOption,
                          groupValue: _addPurchaseBloc.selectedGstType,
                          onChanged: (String? value) {
                            FocusScope.of(context).requestFocus(
                                _addPurchaseBloc.carrierNameFocusNode);
                            setState(() {
                              _addPurchaseBloc.selectedGstType = value;
                              _addPurchaseBloc.cgstPresentageTextController
                                  .clear();
                              _addPurchaseBloc.sgstPresentageTextController
                                  .clear();
                              _addPurchaseBloc.igstPresentageTextController
                                  .clear();
                              _addPurchaseBloc.cgstAmount = 0;
                              _addPurchaseBloc.sgstAmount = 0;
                              _addPurchaseBloc.igstAmount = 0;
                              _addPurchaseBloc
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
              if (_addPurchaseBloc.selectedGstType ==
                  AppConstants.gstPercent) ...[
                Flexible(
                    child: TldsInputFormField(
                  inputFormatters: TlInputFormatters.onlyAllowDecimalNumbers,
                  hintText: AppConstants.cgstPercent,
                  controller: _addPurchaseBloc.cgstPresentageTextController,
                  maxLength: 5,
                  counterText: '',
                  onChanged: (cgst) {
                    double cgstPercent = double.tryParse(cgst) ?? 0;
                    if (cgstPercent > 100) {
                      _addPurchaseBloc.cgstPresentageTextController.clear();
                    }
                    var cgstPercentage = double.tryParse(_addPurchaseBloc
                            .cgstPresentageTextController.text) ??
                        0.0;
                    var sgstPercentage = double.tryParse(_addPurchaseBloc
                            .cgstPresentageTextController.text) ??
                        0.0;
                    if (_addPurchaseBloc.taxableValue != null) {
                      var cgstAmount = _addPurchaseBloc.taxableValue! *
                          (cgstPercentage / 100);
                      var sgstAmount = _addPurchaseBloc.taxableValue! *
                          (sgstPercentage / 100);
                      _addPurchaseBloc.cgstAmount = cgstAmount;
                      _addPurchaseBloc.sgstAmount = sgstAmount;
                      final gstAmount = cgstAmount + sgstAmount;
                      _addPurchaseBloc.invAmount =
                          gstAmount + (_addPurchaseBloc.taxableValue ?? 0.0);

                      _addPurchaseBloc.totalInvAmount =
                          gstAmount + (_addPurchaseBloc.taxableValue ?? 0.0);

                      _addPurchaseBloc.paymentDetailsStreamController(true);
                    }
                  },
                )),
                AppWidgetUtils.buildSizedBox(custWidth: 10),
                Flexible(
                    child: TldsInputFormField(
                  enabled: false,
                  inputFormatters: TlInputFormatters.onlyAllowDecimalNumbers,
                  hintText: AppConstants.sgstPercent,
                  controller: _addPurchaseBloc.cgstPresentageTextController,
                )),
              ] else if (_addPurchaseBloc.selectedGstType ==
                  AppConstants.igstPercent) ...[
                Flexible(
                    child: TldsInputFormField(
                  inputFormatters: TlInputFormatters.onlyAllowDecimalNumbers,
                  hintText: AppConstants.igstPercent,
                  controller: _addPurchaseBloc.igstPresentageTextController,
                  maxLength: 5,
                  counterText: '',
                  onChanged: (igst) {
                    double igstPercent = double.tryParse(igst) ?? 0;
                    if (igstPercent > 100) {
                      _addPurchaseBloc.igstPresentageTextController.clear();
                    }
                    var igstPresentage = double.tryParse(_addPurchaseBloc
                            .igstPresentageTextController.text) ??
                        0.0;
                    if (_addPurchaseBloc.taxableValue != null) {
                      var igstAmount = _addPurchaseBloc.taxableValue! *
                          (igstPresentage / 100);

                      _addPurchaseBloc.igstAmount = igstAmount;

                      _addPurchaseBloc.invAmount =
                          igstAmount + (_addPurchaseBloc.taxableValue ?? 0.0);

                      _addPurchaseBloc.totalInvAmount =
                          igstAmount + (_addPurchaseBloc.taxableValue ?? 0.0);

                      _addPurchaseBloc.paymentDetailsStreamController(true);
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
          future: _addPurchaseBloc.getAllVendorNameList(),
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
                _addPurchaseBloc.selectedVendorId = selectedVendor.vendorId;
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
          controller: _addPurchaseBloc.invoiceNumberController,
          onSubmit: (invoiceNo) {
            FocusScope.of(context)
                .requestFocus(_addPurchaseBloc.inVoiceDateFocusNode);
            _selectDate(context, _addPurchaseBloc.invoiceDateController);
          },
        )),
        _buildDefaultWidth(),
        Expanded(
          child: TldsInputFormField(
            focusNode: _addPurchaseBloc.inVoiceDateFocusNode,
            controller: _addPurchaseBloc.invoiceDateController,
            requiredLabelText: const Text(AppConstants.invoiceDate),
            inputFormatters: TlInputFormatters.onlyAllowDate,
            hintText: 'dd/mm/yyyy',
            suffixIcon: IconButton(
                onPressed: () => _selectDate(
                    context, _addPurchaseBloc.invoiceDateController),
                icon: SvgPicture.asset(AppConstants.icDate)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppConstants.selectInvoiceDate;
              }
              return null;
            },
            onTap: () =>
                _selectDate(context, _addPurchaseBloc.invoiceDateController),
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
        onSubmit: (purchaseRef) {
          FocusScope.of(context).requestFocus(_addPurchaseBloc.partNoFocusNode);
        },
        inputFormatters: TlInputFormatters.onlyAllowAlphabetAndNumber,
        focusNode: _addPurchaseBloc.purchaseRefFocusNode,
        labelText: AppConstants.purchaseRef,
        hintText: AppConstants.purchaseOrderRef,
        controller: _addPurchaseBloc.purchaseRefController);
  }

  Widget _buildCategoryHeader() {
    return StreamBuilder(
      stream: _addPurchaseBloc.selectedPurchaseTypeStream,
      builder: (context, snapshot) {
        return _buildCustomTextWidget(
          '${_addPurchaseBloc.selectedPurchaseType ?? 'Vehicle'} ${AppConstants.details}',
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
          future: _addPurchaseBloc.getAllCategoryList(),
          builder: (context, snapshot) {
            return IgnorePointer(
              ignoring: _addPurchaseBloc.purchaseBillDataList.isNotEmpty,
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
                selected: _addPurchaseBloc.optionsSet,
                onSelectionChanged: (Set<String> newValue) {
                  _addPurchaseBloc.selectedPurchaseTypeStreamController(true);
                  setState(() {
                    _addPurchaseBloc.optionsSet = newValue;
                    _addPurchaseBloc.selectedPurchaseType =
                        _addPurchaseBloc.optionsSet.first;
                    String categoryId = snapshot.data!.category!
                        .where((e) =>
                            e.categoryName ==
                            _addPurchaseBloc.selectedPurchaseType)
                        .map((e) => e.categoryId)
                        .toString();
                    categoryId = categoryId.substring(1, categoryId.length - 1);
                    _addPurchaseBloc.categoryId = categoryId;
                    final selectedCategory =
                        snapshot.data!.category!.firstWhere(
                      (category) =>
                          category.categoryName ==
                          _addPurchaseBloc.selectedPurchaseType,
                    );
                    _addPurchaseBloc.hsnCodeController.text =
                        selectedCategory.hsnSacCode ?? '';
                    _addPurchaseBloc.selectedCategory = selectedCategory;
                    _addPurchaseBloc.selectedPurchaseTypeStreamController(true);
                  });
                },
                style: ButtonStyle(
                  backgroundColor: _addPurchaseBloc
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
            focusNode: _addPurchaseBloc.partNoFocusNode,
            labelText: _addPurchaseBloc.selectedPurchaseType !=
                    AppConstants.accessories
                ? AppConstants.partNo
                : AppConstants.materialNumber,
            hintText: _addPurchaseBloc.selectedPurchaseType !=
                    AppConstants.accessories
                ? AppConstants.partNo
                : AppConstants.materialNumber,
            controller: _addPurchaseBloc.partNumberController,
            onSubmit: (partNumberValue) {
              _addPurchaseBloc.getPurchasePartNoDetails(
                (statusCode) {
                  // if (statusCode == 401 || statusCode == 400) {
                  //   // AppWidgetUtils.buildToast(
                  //   //     context,
                  //   //     ToastificationType.error,
                  //   //     AppConstants.partNoError,
                  //   //     Icon(Icons.check_circle_outline_rounded,
                  //   //         color: _appColors.errorColor),
                  //   //     AppConstants.partNoErrorDes,
                  //   //     _appColors.errorLightColor);
                  // }
                },
              ).then((partDetails) {
                _getAndSetValuesForInputFields(partDetails);
              });
              FocusScope.of(context)
                  .requestFocus(_addPurchaseBloc.unitRateFocusNode);
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
          focusNode: _addPurchaseBloc.unitRateFocusNode,
          labelText: AppConstants.unitRate,
          hintText: AppConstants.rupeeHint,
          controller: _addPurchaseBloc.unitRateController,
          onSubmit: (unit) {
            FocusScope.of(context)
                .requestFocus(_addPurchaseBloc.vehiceNameFocusNode);
          },
          onChanged: (unitPrice) {
            _purchaseTableAmountCalculation();
            _addPurchaseBloc.paymentDetailsStreamController(true);
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
            focusNode: _addPurchaseBloc.vehiceNameFocusNode,
            labelText: _addPurchaseBloc.selectedPurchaseType !=
                    AppConstants.accessories
                ? AppConstants.vehicleName
                : AppConstants.materialName,
            hintText: _addPurchaseBloc.selectedPurchaseType !=
                    AppConstants.accessories
                ? AppConstants.vehicleName
                : AppConstants.materialName,
            controller: _addPurchaseBloc.vehicleNameTextController,
            onSubmit: (p0) {
              FocusScope.of(context)
                  .requestFocus(_addPurchaseBloc.engineNoFocusNode);
            },
          ),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 10),
        Visibility(
          visible:
              _addPurchaseBloc.selectedPurchaseType == AppConstants.accessories,
          child: TldsInputFormField(
            labelText: AppConstants.quantity,
            hintText: AppConstants.quantity,
            inputFormatters: TldsInputFormatters.onlyAllowNumbers,
            width: 180,
            controller: _addPurchaseBloc.quantityController,
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
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return AppConstants.enterHsnCode;
        }
        return null;
      },
      focusNode: _addPurchaseBloc.hsnCodeFocusNode,
      labelText: AppConstants.hsnCode,
      hintText: AppConstants.enterHsnCode,
      controller: _addPurchaseBloc.hsnCodeController,
      onSubmit: (p0) {
        FocusScope.of(context).requestFocus(_addPurchaseBloc.hsnCodeFocusNode);
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
        if (_addPurchaseBloc.purchaseFormKey.currentState!.validate()) {
          final newVehicle = VehicleDetails(
            incentiveType: _addPurchaseBloc.isEmpsIncChecked
                ? AppConstants.empsIncetive
                : AppConstants.stateInc,
            cgstAmount: _addPurchaseBloc.cgstAmount,
            categoryId: _addPurchaseBloc.categoryId,
            invoiceValue: _addPurchaseBloc.invAmount,
            sgstAmount: _addPurchaseBloc.sgstAmount,
            taxableValue: _addPurchaseBloc.taxableValue!,
            totalInvoiceValue: _addPurchaseBloc.totalInvAmount,
            totalValue: _addPurchaseBloc.totalValue!,
            igstAmount: _addPurchaseBloc.igstAmount,
            discountValue: _addPurchaseBloc
                    .discountTextController.text.isNotEmpty
                ? double.tryParse(_addPurchaseBloc.discountTextController.text)
                : 0,
            cgstPercentage:
                _addPurchaseBloc.cgstPresentageTextController.text.isNotEmpty
                    ? double.tryParse(
                        _addPurchaseBloc.cgstPresentageTextController.text)
                    : 0,
            sgstPercentage:
                _addPurchaseBloc.cgstPresentageTextController.text.isNotEmpty
                    ? double.tryParse(
                        _addPurchaseBloc.cgstPresentageTextController.text)
                    : 0,
            igstPercentage:
                _addPurchaseBloc.igstPresentageTextController.text.isNotEmpty
                    ? double.tryParse(
                        _addPurchaseBloc.igstPresentageTextController.text)
                    : 0,
            empsIncentive:
                _addPurchaseBloc.empsIncentiveTextController.text.isNotEmpty
                    ? double.tryParse(
                        _addPurchaseBloc.empsIncentiveTextController.text)
                    : 0,
            gstType: _addPurchaseBloc.selectedGstType,
            stateIncentive:
                _addPurchaseBloc.stateIncentiveTextController.text.isNotEmpty
                    ? double.tryParse(
                        _addPurchaseBloc.stateIncentiveTextController.text)
                    : 0,
            tcsValue: _addPurchaseBloc.tcsvalueTextController.text.isNotEmpty
                ? double.tryParse(_addPurchaseBloc.tcsvalueTextController.text)
                : 0,
            partNo: _addPurchaseBloc.partNumberController.text,
            vehicleName: _addPurchaseBloc.vehicleNameTextController.text,
            hsnCode: int.tryParse(_addPurchaseBloc.hsnCodeController.text),
            qty: _addPurchaseBloc.selectedPurchaseType != 'Accessories'
                ? _addPurchaseBloc.engineDetailsList.length
                : int.tryParse(_addPurchaseBloc.quantityController.text) ?? 0,
            unitRate:
                double.tryParse(_addPurchaseBloc.unitRateController.text) ?? 0,
            engineDetails: _addPurchaseBloc.engineDetailsList
                .map((map) => EngineDetails(
                      engineNo: map.engineNo,
                      frameNo: map.frameNo,
                    ))
                .toList(),
          );
          if (_addPurchaseBloc.editIndex != null) {
            _addPurchaseBloc.purchaseBillDataList[_addPurchaseBloc.editIndex!] =
                PurchaseBillData(
              vehicleDetails: [newVehicle],
            );
            _addPurchaseBloc.editIndex = null;
          } else {
            final newPurchase = PurchaseBillData(
              vehicleDetails: [newVehicle],
            );
            _addPurchaseBloc.purchaseBillDataList.add(newPurchase);
          }
          clearPurchaseDataValue();
          _addPurchaseBloc.refreshPurchaseDataTableList(true);
          _addPurchaseBloc.isTableDataVerifyedStreamController(true);
          FocusScope.of(context).requestFocus(_addPurchaseBloc.partNoFocusNode);
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

  void _updateTotalInvoiceAmount() {
    double? empsIncValue =
        double.tryParse(_addPurchaseBloc.empsIncentiveTextController.text) ??
            0.0;
    double? stateIncValue =
        double.tryParse(_addPurchaseBloc.stateIncentiveTextController.text) ??
            0.0;

    double totalIncentive = empsIncValue + stateIncValue;

    double invoiceAmount = _addPurchaseBloc.invAmount ?? 0;

    if (totalIncentive > invoiceAmount) {
      totalIncentive = invoiceAmount;

      if (empsIncValue > invoiceAmount) {
        _addPurchaseBloc.empsIncentiveTextController.text =
            invoiceAmount.toStringAsFixed(2);
        _addPurchaseBloc.stateIncentiveTextController.text = '';
      } else {
        _addPurchaseBloc.stateIncentiveTextController.text =
            (invoiceAmount - empsIncValue).toStringAsFixed(2);
      }
    }

    _addPurchaseBloc.totalInvAmount = invoiceAmount - totalIncentive;

    _addPurchaseBloc.paymentDetailsStreamController(true);
  }

  clearPurchaseDataValue() {
    _addPurchaseBloc.partNumberController.clear();
    _addPurchaseBloc.unitRateController.clear();
    _addPurchaseBloc.engineNumberController.clear();
    _addPurchaseBloc.frameNumberController.clear();
    _addPurchaseBloc.vehicleNameTextController.clear();
    _addPurchaseBloc.empsIncentiveTextController.clear();
    _addPurchaseBloc.stateIncentiveTextController.clear();
    _addPurchaseBloc.tcsvalueTextController.clear();
    _addPurchaseBloc.discountTextController.clear();
    _addPurchaseBloc.quantityController.clear();
    _addPurchaseBloc.engineDetailsList.clear();
    if (_addPurchaseBloc.selectedPurchaseType == 'Accessories') {
      _addPurchaseBloc.cgstPresentageTextController.clear();
      _addPurchaseBloc.hsnCodeController.clear();
    }
    _addPurchaseBloc.engineDetailsStreamController(true);
    _addPurchaseBloc.refreshEngineDetailsListStramController(true);
    setState(() {
      _addPurchaseBloc.totalValue = 0;
      _addPurchaseBloc.discountTextController.clear();
      _addPurchaseBloc.taxableValue = 0;
      _addPurchaseBloc.cgstAmount = 0;
      _addPurchaseBloc.sgstAmount = 0;
      _addPurchaseBloc.tcsvalueTextController.clear();
      _addPurchaseBloc.invAmount = 0;
      _addPurchaseBloc.totalInvAmount = 0;
    });

    _addPurchaseBloc.paymentDetailsStreamController(true);
  }

  void _purchaseTableAmountCalculation() {
    var qty =
        double.tryParse(_addPurchaseBloc.engineDetailsList.length.toString()) ??
            0.0;
    var unitRate =
        double.tryParse(_addPurchaseBloc.unitRateController.text) ?? 0.0;
    var totalValue = qty * unitRate;
    if (_addPurchaseBloc.selectedPurchaseType == 'Accessories') {
      totalValue =
          (int.tryParse(_addPurchaseBloc.quantityController.text) ?? 0) *
              unitRate;
    }
    _addPurchaseBloc.totalValue = totalValue;

    double? discountAmount =
        double.tryParse(_addPurchaseBloc.discountTextController.text) ?? 0;
    totalValue = _addPurchaseBloc.totalValue ?? 0;
    if (discountAmount > totalValue) {
      discountAmount = 0;
      _addPurchaseBloc.discountTextController.text =
          discountAmount.toStringAsFixed(2);
    }
    var taxableValue = totalValue - discountAmount;
    _addPurchaseBloc.taxableValue = taxableValue;
    _addPurchaseBloc.taxableValue =
        (_addPurchaseBloc.totalValue ?? 0) - (discountAmount);

    _addPurchaseBloc.totalInvAmount =
        ((_addPurchaseBloc.invAmount ?? 0) - (discountAmount));

    var tcsValue =
        double.tryParse(_addPurchaseBloc.tcsvalueTextController.text) ?? 0.0;
    double gstAmount = 0.0;

    if (_addPurchaseBloc.selectedGstType == 'GST %') {
      var cgstPercentage =
          double.tryParse(_addPurchaseBloc.cgstPresentageTextController.text) ??
              0.0;
      var sgstPercentage =
          double.tryParse(_addPurchaseBloc.cgstPresentageTextController.text) ??
              0.0;
      var cgstAmount = taxableValue * (cgstPercentage / 100);
      var sgstAmount = taxableValue * (sgstPercentage / 100);
      _addPurchaseBloc.cgstAmount = cgstAmount;
      _addPurchaseBloc.sgstAmount = sgstAmount;
      gstAmount = cgstAmount + sgstAmount;
    } else if (_addPurchaseBloc.selectedGstType == 'IGST %') {
      var igstPercentage =
          double.tryParse(_addPurchaseBloc.igstPresentageTextController.text) ??
              0.0;
      gstAmount = taxableValue * (igstPercentage / 100);
    }
    var invoiceValue = taxableValue + gstAmount;
    _addPurchaseBloc.invAmount = invoiceValue + tcsValue;
    _updateTotalInvoiceAmount();
  }

  void _getAndSetValuesForInputFields(ParentResponseModel partDetails) {
    var vehchileById = partDetails.result?.purchaseByPartNo;
    setState(() {
      _addPurchaseBloc.vehicleNameTextController.text =
          vehchileById?.itemName ?? '';
      _addPurchaseBloc.unitRateController.text =
          vehchileById?.unitRate.toString() ?? '';
      for (var gstDetail in vehchileById?.gstDetails ?? []) {
        if (gstDetail.gstName == 'CGST' || gstDetail.gstName == 'SGST') {
          _addPurchaseBloc.selectedGstType = AppConstants.gstPercent;
          _addPurchaseBloc.gstRadioBtnRefreshStreamController(true);
          _addPurchaseBloc.cgstPresentageTextController.text =
              gstDetail.percentage?.toString() ?? '';
          _addPurchaseBloc.sgstPresentageTextController.text =
              gstDetail.percentage?.toString() ?? '';

          _addPurchaseBloc.engineDetailsStreamController(true);
          _addPurchaseBloc.gstRadioBtnRefreshStreamController(true);
          _addPurchaseBloc.paymentDetailsStreamController(true);
        } else {
          _addPurchaseBloc.selectedGstType = AppConstants.igstPercent;
          _addPurchaseBloc.gstRadioBtnRefreshStreamController(true);
          _addPurchaseBloc.igstPresentageTextController.text =
              gstDetail.percentage?.toString() ?? '';
          _addPurchaseBloc.gstRadioBtnRefreshStreamController(true);
          _addPurchaseBloc.paymentDetailsStreamController(true);
        }
      }

      _addPurchaseBloc.paymentDetailsStreamController(true);
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
      _addPurchaseBloc.invoiceDateController.text = formattedDate;
      // ignore: use_build_context_synchronously
      FocusScope.of(context)
          .requestFocus(_addPurchaseBloc.purchaseRefFocusNode);
    }
  }

  void _setCategoryValueInitially() {
    _addPurchaseBloc.getAllCategoryList().then((categoryValue) {
      if (categoryValue?.category?.isNotEmpty ?? false) {
        setState(() {
          var firstCategory = categoryValue!.category!.first;
          _addPurchaseBloc.optionsSet = {firstCategory.categoryName.toString()};
          _addPurchaseBloc.selectedPurchaseType = firstCategory.categoryName;
          _addPurchaseBloc.categoryId = firstCategory.categoryId;
          _addPurchaseBloc.hsnCodeController.text =
              firstCategory.hsnSacCode ?? '';
          _addPurchaseBloc.selectedCategory = firstCategory;
          _addPurchaseBloc.selectedPurchaseTypeStreamController(true);
        });
      }
    });
  }

  void updateTotalValue() {
    double? unitRate =
        double.tryParse(_addPurchaseBloc.unitRateController.text);
    _addPurchaseBloc.engineDetailsStreamController(true);
    _addPurchaseBloc.gstRadioBtnRefreshStreamController(true);
    _addPurchaseBloc.paymentDetailsStreamController(true);
    double? totalQty =
        double.tryParse(_addPurchaseBloc.quantityController.text);
    _addPurchaseBloc.engineDetailsStreamController(true);
    _addPurchaseBloc.gstRadioBtnRefreshStreamController(true);
    _addPurchaseBloc.totalValue = (unitRate ?? 0) * (totalQty ?? 0);

    _addPurchaseBloc.taxableValue = (unitRate ?? 0) * (totalQty ?? 0);

    _addPurchaseBloc.invAmount = (unitRate ?? 0) * (totalQty ?? 0);

    _addPurchaseBloc.totalInvAmount = (unitRate ?? 0) * (totalQty ?? 0);
    _addPurchaseBloc.paymentDetailsStreamController(true);
    _addPurchaseBloc.engineDetailsStreamController(true);
    _addPurchaseBloc.gstRadioBtnRefreshStreamController(true);
  }
}
