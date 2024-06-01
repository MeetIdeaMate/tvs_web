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
  const AddVehicleAndAccessories({super.key});

  @override
  State<AddVehicleAndAccessories> createState() =>
      _AddVehicleAndAccessoriesState();
}

class _AddVehicleAndAccessoriesState extends State<AddVehicleAndAccessories> {
  final _appColors = AppColors();
  final _addVehicleAndAccessoriesBloc = AddVehicleAndAccessoriesBlocImpl();
  final List<String> _options = ['GST %', 'ISGST %'];
  final List<String> vehicleAndAccessories = ['Vehicle', 'Accessories'];
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _addVehicleAndAccessoriesBloc.selectedPurchaseType = 'Vehicle';
    _addVehicleAndAccessoriesBloc.selectedPurchaseTypeStreamController(true);
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
            key: _addVehicleAndAccessoriesBloc.purchaseFormKey,
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
          future: _addVehicleAndAccessoriesBloc.getAllVendorNameList(),
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
              _addVehicleAndAccessoriesBloc.vendorDropDownValue =
                  newValue ?? '';
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
          controller: _addVehicleAndAccessoriesBloc.invoiceNumberController,
          onSubmit: (p0) {
            FocusScope.of(context).requestFocus(
                _addVehicleAndAccessoriesBloc.inVoiceDateFocusNode);
            _selectDate(
                context, _addVehicleAndAccessoriesBloc.invoiceDateController);
          },
        )),
        _buildDefaultWidth(),
        Expanded(
          child: TldsInputFormField(
            focusNode: _addVehicleAndAccessoriesBloc.inVoiceDateFocusNode,
            controller: _addVehicleAndAccessoriesBloc.invoiceDateController,
            requiredLabelText: const Text(AppConstants.invoiceDate),
            inputFormatters: TlInputFormatters.onlyAllowDate,
            hintText: 'dd/mm/yyyy',
            suffixIcon: IconButton(
                onPressed: () => _selectDate(context,
                    _addVehicleAndAccessoriesBloc.invoiceDateController),
                icon: SvgPicture.asset(AppConstants.icDate)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppConstants.selectInvoiceDate;
              }
              return null;
            },
            onTap: () => _selectDate(
                context, _addVehicleAndAccessoriesBloc.invoiceDateController),
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
      _addVehicleAndAccessoriesBloc.invoiceDateController.text = formattedDate;
      FocusScope.of(context)
          .requestFocus(_addVehicleAndAccessoriesBloc.purchaseRefFocusNode);
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
                focusNode: _addVehicleAndAccessoriesBloc.purchaseRefFocusNode,
                labelText: AppConstants.purchaseRef,
                hintText: AppConstants.purchaseOrderRef,
                controller:
                    _addVehicleAndAccessoriesBloc.purchaseRefController)),
        Row(
          children: _options.map((option) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Radio(
                    value: option,
                    groupValue: _selectedOption,
                    onChanged: (String? value) {
                      FocusScope.of(context).requestFocus(
                          _addVehicleAndAccessoriesBloc.carrierNameFocusNode);
                      setState(() {
                        _selectedOption = value;
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
          focusNode: _addVehicleAndAccessoriesBloc.carrierNameFocusNode,
          labelText: AppConstants.carrier,
          hintText: AppConstants.name,
          controller: _addVehicleAndAccessoriesBloc.carrierController,
          onSubmit: (p0) {
            FocusScope.of(context)
                .requestFocus(_addVehicleAndAccessoriesBloc.carrierNoFocusNode);
          },
        )),
        _buildDefaultWidth(),
        Expanded(
            child: TldsInputFormField(
          inputFormatters: TlInputFormatters.onlyAllowAlphabetAndNumber,
          focusNode: _addVehicleAndAccessoriesBloc.carrierNoFocusNode,
          labelText: AppConstants.carrierNumber,
          hintText: AppConstants.carrierNumber,
          controller: _addVehicleAndAccessoriesBloc.carrierNumberController,
          onSubmit: (p0) {
            FocusScope.of(context)
                .requestFocus(_addVehicleAndAccessoriesBloc.partNoFocusNode);
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
                    stream: _addVehicleAndAccessoriesBloc
                        .selectedPurchaseTypeStream,
                    builder: (context, snapshot) {
                      return _addVehicleAndAccessoriesBloc
                                  .selectedPurchaseType ==
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
              stream: _addVehicleAndAccessoriesBloc.selectedPurchaseTypeStream,
              builder: (context, snapshot) {
                if (_addVehicleAndAccessoriesBloc.selectedPurchaseType ==
                    'Vehicle') {
                  return VehiclePurchaseDetails(
                    addVehicleAndAccessoriesBloc: _addVehicleAndAccessoriesBloc,
                  );
                } else if (_addVehicleAndAccessoriesBloc.selectedPurchaseType ==
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
        selected: _addVehicleAndAccessoriesBloc.optionsSet,
        onSelectionChanged: (Set<String> newValue) {
          setState(() {
            _addVehicleAndAccessoriesBloc.optionsSet = newValue;
            _addVehicleAndAccessoriesBloc.selectedPurchaseType =
                _addVehicleAndAccessoriesBloc.optionsSet.first;
            _addVehicleAndAccessoriesBloc
                .selectedPurchaseTypeStreamController(true);
          });
        },
        style: ButtonStyle(
          backgroundColor: _addVehicleAndAccessoriesBloc
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
        if (_addVehicleAndAccessoriesBloc.purchaseFormKey.currentState!
            .validate()) {
          final newVehicle = VehicleDetails(
            partNo: int.parse(
                _addVehicleAndAccessoriesBloc.partNumberController.text),
            vehicleName:
                _addVehicleAndAccessoriesBloc.materialNameController.text,
            varient: _addVehicleAndAccessoriesBloc.variantController.text,
            color: _addVehicleAndAccessoriesBloc.colorController.text,
            hsnCode:
                int.parse(_addVehicleAndAccessoriesBloc.hsnCodeController.text),
            unitRate: int.parse(
                _addVehicleAndAccessoriesBloc.unitRateController.text),
            engineDetails: _addVehicleAndAccessoriesBloc.engineDetailsList
                .map((map) => EngineDetails(
                      engineNo: int.parse(map['engineNo']!),
                      frameNo: int.parse(map['frameNo']!),
                    ))
                .toList(),
          );
          final newPurchase = PurchaseBillData(
            vehicleDetails: [newVehicle],
          );

          _addVehicleAndAccessoriesBloc.purchaseBillDataList.add(newPurchase);
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
}
