import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_vehicle_and_accesories/accessories_purchase_details.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_vehicle_and_accesories/add_vehicle_and_accessories_bloc.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_vehicle_and_accesories/vehicle_purchase_details.dart';
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
          child: Column(
            children: [
              _buildVendorDetails(),
              _buildVehicleAndAccessoriesDetails()
            ],
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
        TldsDropDownButtonFormField(
          height: 40,
          width: MediaQuery.sizeOf(context).width * 0.22,
          hintText: AppConstants.selectVendor,
          dropDownItems: _addVehicleAndAccessoriesBloc.selectVendor,
          onChange: (String? newValue) {
            _addVehicleAndAccessoriesBloc.vendorDropDownValue = newValue ?? '';
          },
        ),
        _buildDefaultWidth(),
        Expanded(
            child: CustomElevatedButton(
          fontColor: _appColors.whiteColor,
          buttonBackgroundColor: _appColors.primaryColor,
          suffixIcon: SvgPicture.asset(AppConstants.icHumanAdd),
          height: 40,
          text: AppConstants.addNew,
          fontSize: 14,
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
                height: 40,
                labelText: AppConstants.invoiceNo,
                hintText: AppConstants.invoiceNo,
                controller:
                    _addVehicleAndAccessoriesBloc.invoiceNumberController)),
        _buildDefaultWidth(),
        Expanded(
          child: TldsInputFormField(
            controller: _addVehicleAndAccessoriesBloc.invoiceDateController,
            requiredLabelText: const Text(AppConstants.invoiceDate),
            width: 246.43,
            height: 40,
            hintText: 'dd/mm/yyyy',
            suffixIcon: IconButton(
                onPressed: () => _selectDate(context,
                    _addVehicleAndAccessoriesBloc.invoiceDateController),
                icon: SvgPicture.asset(AppConstants.icDate)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Appointment Date';
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
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
              child: TldsInputFormField(
                  height: 40,
                  labelText: AppConstants.purchaseRef,
                  hintText: AppConstants.purchaseOrderRef,
                  controller:
                      _addVehicleAndAccessoriesBloc.purchaseRefController)),
          Row(
            children: _options.map((option) {
              return Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  child: Row(
                    children: [
                      Radio(
                        value: option,
                        groupValue: _selectedOption,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedOption = value;
                          });
                        },
                      ),
                      Text(option),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCarrierAndCarrierNumber() {
    return Row(
      children: [
        Expanded(
            child: TldsInputFormField(
                height: 40,
                labelText: AppConstants.carrier,
                hintText: AppConstants.name,
                controller: _addVehicleAndAccessoriesBloc.carrierController)),
        _buildDefaultWidth(),
        Expanded(
            child: TldsInputFormField(
                height: 40,
                labelText: AppConstants.carrierNumber,
                hintText: AppConstants.carrierNumber,
                controller:
                    _addVehicleAndAccessoriesBloc.carrierNumberController)),
      ],
    );
  }

  Widget _buildVehicleAndAccessoriesDetails() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.36,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDefaultHeight(),
            StreamBuilder(
              stream: _addVehicleAndAccessoriesBloc.selectedPurchaseTypeStream,
              builder: (context, snapshot) {
                return _addVehicleAndAccessoriesBloc.selectedPurchaseType ==
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
          ],),),
          _buildDefaultHeight(),
          StreamBuilder(
            stream: _addVehicleAndAccessoriesBloc.selectedPurchaseTypeStream,
            builder: (context, snapshot) {
              if (_addVehicleAndAccessoriesBloc.selectedPurchaseType ==
                  'Vehicle') {
                return const VehiclePurchaseDetails();
              } else if (_addVehicleAndAccessoriesBloc.selectedPurchaseType ==
                  'Accessories') {
                return const AccessoriesPurchaseDetails();
              }
              return Container();
            },
          ),
          Padding(padding: const EdgeInsets.all(12),
          child: _buildAddToTableButton(),)
        ],
      )
    );
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
        fontSize: 16);
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
