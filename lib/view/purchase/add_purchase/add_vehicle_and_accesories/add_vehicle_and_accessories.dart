import 'package:flutter/material.dart';
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
  final List<String> _options = ['GST %', 'ISGST %'];
  final List<String> vehicleAndAccessories = ['Vehicle', 'Accessories'];

  @override
  void initState() {
    super.initState();
    widget.purchaseBloc.selectedPurchaseType = 'Vehicle';
    widget.purchaseBloc.selectedPurchaseTypeStreamController(true);
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
                _buildVehicleAndAccessoriesDetails()
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
              _buildPurchaseRefGstAndIGST(),
              _buildDefaultHeight(),
              _buildCarrierAndCarrierNumber()
            ],
          ),
        ));
  }

  Widget _buildSelectVendorDropDownAndAddNewButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FutureBuilder(
          future: widget.purchaseBloc.getAllVendorNameList(),
          builder: (context, snapshot) => TldsDropDownButtonFormField(
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return AppConstants.selectVendor;
              }
              return null;
            },
            width: MediaQuery.sizeOf(context).width * 0.22,
            hintText: AppConstants.selectVendor,
            dropDownItems: snapshot.data ?? [],
            onChange: (String? newValue) {
              widget.purchaseBloc.vendorDropDownValue = newValue ?? '';
            },
          ),
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
          onSubmit: (p0) {
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

  Future<void> _selectTime(
      BuildContext context, TextEditingController timeController) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      final formattedTime = pickedTime.format(context);
      timeController.text = formattedTime;
    }
  }

  Widget _buildPurchaseRefGstAndIGST() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
            child: TldsInputFormField(
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
                controller: widget.purchaseBloc.purchaseRefController)),
        Row(
          children: _options.map((option) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Radio(
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
      ],
    );
  }

  Widget _buildCarrierAndCarrierNumber() {
    return Row(
      children: [
        Expanded(
            child: TldsInputFormField(
          inputFormatters: TlInputFormatters.onlyAllowAlphabets,
          focusNode: widget.purchaseBloc.carrierNameFocusNode,
          labelText: AppConstants.carrier,
          hintText: AppConstants.name,
          controller: widget.purchaseBloc.carrierController,
          onSubmit: (p0) {
            FocusScope.of(context)
                .requestFocus(widget.purchaseBloc.carrierNoFocusNode);
          },
        )),
        _buildDefaultWidth(),
        Expanded(
            child: TldsInputFormField(
          inputFormatters: TlInputFormatters.onlyAllowAlphabetAndNumber,
          focusNode: widget.purchaseBloc.carrierNoFocusNode,
          labelText: AppConstants.carrierNumber,
          hintText: AppConstants.carrierNumber,
          controller: widget.purchaseBloc.carrierNumberController,
          onSubmit: (p0) {
            FocusScope.of(context)
                .requestFocus(widget.purchaseBloc.partNoFocusNode);
          },
        )),
      ],
    );
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
            StreamBuilder(
              stream: widget.purchaseBloc.selectedPurchaseTypeStream,
              builder: (context, snapshot) {
                if (widget.purchaseBloc.selectedPurchaseType == 'Vehicle') {
                  return VehiclePurchaseDetails(
                    addVehicleAndAccessoriesBloc: widget.purchaseBloc,
                  );
                } else if (widget.purchaseBloc.selectedPurchaseType ==
                    'Accessories') {
                  return const AccessoriesPurchaseDetails();
                }
                return Container();
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
      child: SegmentedButton(
        multiSelectionEnabled: false,
        segments: List.generate(
            vehicleAndAccessories.length,
            (index) => ButtonSegment(
                value: vehicleAndAccessories[index],
                label: Text(
                  vehicleAndAccessories[index],
                ))),
        selected: widget.purchaseBloc.optionsSet,
        onSelectionChanged: (Set<String> newValue) {
          setState(() {
            widget.purchaseBloc.optionsSet = newValue;
            widget.purchaseBloc.selectedPurchaseType =
                widget.purchaseBloc.optionsSet.first;
            widget.purchaseBloc.selectedPurchaseTypeStreamController(true);
          });
        },
        style: ButtonStyle(
          backgroundColor: widget.purchaseBloc
              .changeSegmentedColor(_appColors.segmentedButtonColor),
        ),
      ),
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
        if (widget.purchaseBloc.purchaseFormKey.currentState!.validate()) {
          final newVehicle = VehicleDetails(
            partNo: int.parse(widget.purchaseBloc.partNumberController.text),
            vehicleName: widget.purchaseBloc.materialNameController.text,
            varient: widget.purchaseBloc.variantController.text,
            color: widget.purchaseBloc.colorController.text,
            hsnCode: int.parse(widget.purchaseBloc.hsnCodeController.text),
            unitRate: int.parse(widget.purchaseBloc.unitRateController.text),
            engineDetails: widget.purchaseBloc.engineDetailsList
                .map((map) => EngineDetails(
                      engineNo: int.parse(map['engineNo']!),
                      frameNo: int.parse(map['frameNo']!),
                    ))
                .toList(),
          );
          final newPurchase = PurchaseBillData(
            vendorName: widget.purchaseBloc.vendorDropDownValue,
            carrierName: widget.purchaseBloc.carrierController.text,
            carrierNumber: widget.purchaseBloc.carrierNumberController.text,
            invoiceNo: widget.purchaseBloc.invoiceNumberController.text,
            invoiceDate: widget.purchaseBloc.invoiceDateController.text,
            gstType: widget.purchaseBloc.selectedGstType ?? '',
            purchaseRef: widget.purchaseBloc.purchaseRefController.text,
            vehicleDetails: [newVehicle],
          );
          print(
              '********new purchase details***********${newPurchase.toJson()}');
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
    widget.purchaseBloc.materialNameController.clear();
    widget.purchaseBloc.variantController.clear();
    widget.purchaseBloc.colorController.clear();
    widget.purchaseBloc.hsnCodeController.clear();
    widget.purchaseBloc.unitRateController.clear();
    widget.purchaseBloc.engineDetailsList.clear();
    widget.purchaseBloc.vendorDropDownValue = null;
    widget.purchaseBloc.carrierController.clear();
    widget.purchaseBloc.carrierNumberController.clear();
    widget.purchaseBloc.invoiceNumberController.clear();
    widget.purchaseBloc.invoiceDateController.clear();
    widget.purchaseBloc.selectedGstType = null;
    widget.purchaseBloc.purchaseRefController.clear();
  }
}
