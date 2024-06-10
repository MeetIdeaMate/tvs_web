import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/models/purchase_bill_data.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_vehicle_and_accesories/accessories_purchase_details.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_vehicle_and_accesories/add_vehicle_and_accessories_bloc.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_vehicle_and_accesories/vehicle_purchase_details.dart';
import 'package:tlbilling/view/vendor/create_vendor_dialog.dart';
import 'package:tlds_flutter/export.dart';

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

    // widget.purchaseBloc.optionsSet = {'M-Vehile'};
    widget.purchaseBloc.selectedPurchaseTypeStreamController(true);
    widget.purchaseBloc.getAllCategoryList().then((value) {
      print('^^then val^^^^^^^^^^${value.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.sizeOf(context).width * 0.36,
        decoration: BoxDecoration(
            border: Border(
          top: BorderSide(color: _appColors.greyColor),
        )),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: widget.purchaseBloc.purchaseFormKey,
            child: Column(
              children: [
                _buildVendorDetails(),
                _buildVehicleAndAccessoriesDetails(),
              ],
            ),
          ),
        ));
  }

  Widget _buildVendorDetails() {
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

  Widget _buildGstAndIncentivesColumn() {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.36,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: _appColors.greyColor))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildCustomTextWidget(
            AppConstants.gstDetails,
            fontSize: 20,
            color: _appColors.primaryColor,
          ),
          _buildGstDetails(),
          AppWidgetUtils.buildSizedBox(custHeight: 10),
          Visibility(
            visible: widget.purchaseBloc.selectedCategory?.incentive != null,
            child: _buildCustomTextWidget(
              AppConstants.incentives,
              fontSize: 20,
              color: _appColors.primaryColor,
            ),
          ),
          AppWidgetUtils.buildSizedBox(custHeight: 10),
          Visibility(
              visible: widget.purchaseBloc.selectedCategory?.incentive != null,
              child: _buildIncentives()),
          AppWidgetUtils.buildSizedBox(custHeight: 10),
          Visibility(
            visible: widget.purchaseBloc.selectedCategory?.taxes != null,
            child: _buildCustomTextWidget(
              AppConstants.otherDetails,
              fontSize: 20,
              color: _appColors.primaryColor,
            ),
          ),
          AppWidgetUtils.buildSizedBox(custHeight: 10),
          Visibility(
              visible: widget.purchaseBloc.selectedCategory?.taxes != null,
              child: _buildOtherDetails()),
        ]),
      ),
    );
  }

  Widget _buildOtherDetails() {
    return StreamBuilder<bool>(
        stream: widget.purchaseBloc.taxValueCheckBoxStream,
        builder: (context, snapshot) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Checkbox(
                      value: widget.purchaseBloc.isTcsValueChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          widget.purchaseBloc.isTcsValueChecked =
                              value ?? false;
                        });
                      },
                    ),
                    const Text(AppConstants.tcsValue),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Checkbox(
                      value: widget.purchaseBloc.isDiscountChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          widget.purchaseBloc.isDiscountChecked =
                              value ?? false;
                        });
                      },
                    ),
                    const Text(AppConstants.discount),
                  ],
                ),
              ),
              if (widget.purchaseBloc.isTcsValueChecked)
                Expanded(
                  child: TldsInputFormField(
                    inputFormatters: TlInputFormatters.onlyAllowNumbers,
                    hintText: AppConstants.tcsValue,
                    controller: widget.purchaseBloc.tcsvalueTextController,
                  ),
                ),
              if (widget.purchaseBloc.isDiscountChecked &&
                  widget.purchaseBloc.isTcsValueChecked)
                AppWidgetUtils.buildSizedBox(custWidth: 16),
              if (widget.purchaseBloc.isDiscountChecked)
                Expanded(
                  child: TldsInputFormField(
                    inputFormatters: TlInputFormatters.onlyAllowNumbers,
                    hintText: AppConstants.discount,
                    controller: widget.purchaseBloc.discountTextController,
                  ),
                ),
            ],
          );
        });
  }

  Widget _buildGstDetails() {
    return StreamBuilder<bool>(
        stream: widget.purchaseBloc.gstRadioBtnRefreashStream,
        builder: (context, snapshot) {
          return Row(
            children: [
              Row(
                children: widget.purchaseBloc.gstTypeOptions.map((option) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Radio<String>(
                          value: option,
                          groupValue: widget.purchaseBloc.selectedGstType,
                          onChanged: (String? value) {
                            FocusScope.of(context).requestFocus(
                                widget.purchaseBloc.carrierNameFocusNode);
                            setState(() {
                              widget.purchaseBloc.selectedGstType = value;
                            });
                          },
                        ),
                        Text(option),
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
                        inputFormatters: TlInputFormatters.onlyAllowNumbers,
                        hintText: AppConstants.cgstPercent,
                        controller:
                            widget.purchaseBloc.cgstPresentageTextController)),
                AppWidgetUtils.buildSizedBox(custWidth: 10),
                Flexible(
                    child: TldsInputFormField(
                        inputFormatters: TlInputFormatters.onlyAllowNumbers,
                        hintText: AppConstants.sgstPercent,
                        controller:
                            widget.purchaseBloc.cgstPresentageTextController)),
              ] else if (widget.purchaseBloc.selectedGstType ==
                  AppConstants.igstPercent) ...[
                Flexible(
                    child: TldsInputFormField(
                        inputFormatters: TlInputFormatters.onlyAllowNumbers,
                        hintText: AppConstants.igstPercent,
                        controller:
                            widget.purchaseBloc.igstPresentageTextController)),
              ],
            ],
          );
        });
  }

  Widget _buildIncentives() {
    return StreamBuilder<bool>(
        stream: widget.purchaseBloc.incentiveCheckBoxStream,
        builder: (context, snapshot) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Checkbox(
                      value: widget.purchaseBloc.isEmpsIncChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          widget.purchaseBloc.isEmpsIncChecked = value ?? false;
                        });
                      },
                    ),
                    const Text(AppConstants.empsInc),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Checkbox(
                      value: widget.purchaseBloc.isStateIncChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          widget.purchaseBloc.isStateIncChecked =
                              value ?? false;
                        });
                      },
                    ),
                    const Text(AppConstants.stateInc),
                  ],
                ),
              ),
              if (widget.purchaseBloc.isEmpsIncChecked)
                Expanded(
                  child: TldsInputFormField(
                    inputFormatters: TlInputFormatters.onlyAllowNumbers,
                    hintText: AppConstants.empsInc,
                    controller: widget.purchaseBloc.empsIncentiveTextController,
                  ),
                ),
              if (widget.purchaseBloc.isEmpsIncChecked &&
                  widget.purchaseBloc.isStateIncChecked)
                AppWidgetUtils.buildSizedBox(custWidth: 16),
              if (widget.purchaseBloc.isStateIncChecked)
                Expanded(
                  child: TldsInputFormField(
                    inputFormatters: TlInputFormatters.onlyAllowNumbers,
                    hintText: AppConstants.stateInc,
                    controller:
                        widget.purchaseBloc.stateIncentiveTextController,
                  ),
                ),
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

  Widget _buildVehicleAndAccessoriesDetails() {
    return SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.36,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDefaultHeight(),
                  StreamBuilder(
                    stream: widget.purchaseBloc.selectedPurchaseTypeStream,
                    builder: (context, snapshot) {
                      return widget.purchaseBloc.selectedPurchaseType ==
                              'Vehicle'
                          ? _buildCustomTextWidget(
                              AppConstants.vehicleDetails,
                              fontSize: 20,
                              color: _appColors.primaryColor,
                            )
                          : _buildCustomTextWidget(
                              AppConstants.accessoriesDetails,
                              fontSize: 20,
                              color: _appColors.primaryColor,
                            );
                    },
                  ),
                  _buildDefaultHeight(),
                  _buildVehicleAccessoriesSegmentedButton(),
                ],
              ),
            ),
            _buildDefaultHeight(),
            _buildGstAndIncentivesColumn(),
            StreamBuilder(
              stream: widget.purchaseBloc.selectedPurchaseTypeStream,
              builder: (context, snapshot) {
                if (widget.purchaseBloc.selectedPurchaseType == 'Accessories') {
                  return const AccessoriesPurchaseDetails();
                } else {
                  return VehiclePurchaseDetails(
                    addVehicleAndAccessoriesBloc: widget.purchaseBloc,
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: _buildAddToTableButton(),
            )
          ],
        ));
  }

  Widget _buildVehicleAccessoriesSegmentedButton() {
    return SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: FutureBuilder(
          future: widget.purchaseBloc.getAllCategoryList(),
          builder: (context, snapshot) {
            return SegmentedButton(
              multiSelectionEnabled: false,
              segments:
                  List.generate(snapshot.data?.category?.length ?? 0, (index) {
                return ButtonSegment(
                    value: snapshot.data?.category?[index].categoryName ?? '',
                    label: Text(
                      snapshot.data?.category?[index].categoryName ?? '',
                    ));
              }),
              selected: widget.purchaseBloc.optionsSet,
              onSelectionChanged: (Set<String> newValue) {
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

                  final selectedCategory = snapshot.data!.category!.firstWhere(
                    (category) =>
                        category.categoryName ==
                        widget.purchaseBloc.selectedPurchaseType,
                  );

                  widget.purchaseBloc.selectedCategory = selectedCategory;

                  print(
                      '*******CAT*****${widget.purchaseBloc.selectedCategory}');
                  print('*******lcid*****${widget.purchaseBloc.categoryId}');
                  widget.purchaseBloc
                      .selectedPurchaseTypeStreamController(true);
                });
              },
              style: ButtonStyle(
                backgroundColor: widget.purchaseBloc
                    .changeSegmentedColor(_appColors.segmentedButtonColor),
              ),
            );
          },
        ));
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
            partNo: int.parse(widget.purchaseBloc.partNumberController.text),
            vehicleName: widget.purchaseBloc.vehicleNameTextController.text,
            hsnCode: int.parse(widget.purchaseBloc.hsnCodeController.text),
            qty: widget.purchaseBloc.engineDetailsList.length,
            unitRate: double.parse(widget.purchaseBloc.unitRateController.text),
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
    widget.purchaseBloc.hsnCodeController.clear();
    widget.purchaseBloc.unitRateController.clear();
    widget.purchaseBloc.engineNumberController.clear();
    widget.purchaseBloc.frameNumberController.clear();
    widget.purchaseBloc.vehicleNameTextController.clear();
    widget.purchaseBloc.selectedGstType = '';
    widget.purchaseBloc.cgstPresentageTextController.clear();
    widget.purchaseBloc.sgstPresentageTextController.clear();
    widget.purchaseBloc.igstPresentageTextController.clear();
    widget.purchaseBloc.empsIncentiveTextController.clear();
    widget.purchaseBloc.stateIncentiveTextController.clear();
    widget.purchaseBloc.tcsvalueTextController.clear();
    widget.purchaseBloc.discountTextController.clear();
    setState(() {
      widget.purchaseBloc.isEmpsIncChecked = false;
      widget.purchaseBloc.isDiscountChecked = false;
      widget.purchaseBloc.isStateIncChecked = false;
      widget.purchaseBloc.isTcsValueChecked = false;
    });
    widget.purchaseBloc.engineDetailsStreamController(true);
    widget.purchaseBloc.refreshEngineDetailsListStramController(true);
  }

  void _purchaseTableAmountCalculation() {
    var qty = double.tryParse(
            widget.purchaseBloc.engineDetailsList.length.toString()) ??
        0.0;
    var unitRate =
        double.tryParse(widget.purchaseBloc.unitRateController.text) ?? 0.0;
    var totalValue = qty * unitRate;
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
}
