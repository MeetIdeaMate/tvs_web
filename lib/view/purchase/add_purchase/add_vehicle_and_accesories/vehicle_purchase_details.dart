import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_vehicle_and_accesories/add_vehicle_and_accessories_bloc.dart';
import 'package:tlds_flutter/export.dart';

class VehiclePurchaseDetails extends StatefulWidget {
  const VehiclePurchaseDetails({super.key});

  @override
  State<VehiclePurchaseDetails> createState() => _VehiclePurchaseDetailsState();
}

class _VehiclePurchaseDetailsState extends State<VehiclePurchaseDetails> {
  final _appColors = AppColors();
  final _addVehicleAndAccessoriesBloc = AddVehicleAndAccessoriesBlocImpl();
  final List<String> vehicleAndAccessories = ['Vehicle', 'Accessories'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildVehiclePurchaseDetails(),
        _buildDefaultHeight(),
        _buildEngineDetails(),
      ],
    );
  }

  Widget _buildVehiclePurchaseDetails() {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.36,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: _appColors.greyColor))),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildPartNumberAndVehicleName(),
            _buildDefaultHeight(),
            _buildVariantAndColor(),
            _buildDefaultHeight(),
            _buildHSNCodeAndUniteRate(),
            _buildDefaultHeight(),
          ],
        ),
      ),
    );
  }

  Widget _buildPartNumberAndVehicleName() {
    return Row(
      children: [
        Expanded(
            child: TldsInputFormField(
                height: 40,
                labelText: AppConstants.partNo,
                hintText: AppConstants.partNo,
                controller:
                    _addVehicleAndAccessoriesBloc.partNumberController)),
        _buildDefaultWidth(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextWidget(AppConstants.vehicleName, fontSize: 14),
            AppWidgetUtils.buildSizedBox(
                custHeight: MediaQuery.sizeOf(context).height * 0.01),
            TldsDropDownButtonFormField(
              height: 40,
              width: MediaQuery.sizeOf(context).width * 0.165,
              hintText: AppConstants.vehicleName,
              dropDownItems: _addVehicleAndAccessoriesBloc.selectVendor,
              onChange: (String? newValue) {
                _addVehicleAndAccessoriesBloc.vendorDropDownValue =
                    newValue ?? '';
              },
            )
          ],
        ),
      ],
    );
  }

  Widget _buildVariantAndColor() {
    return Row(
      children: [
        Expanded(
            child: TldsInputFormField(
                height: 40,
                labelText: AppConstants.variant,
                hintText: AppConstants.variant,
                controller: _addVehicleAndAccessoriesBloc.variantController)),
        _buildDefaultWidth(),
        Expanded(
            child: TldsInputFormField(
                height: 40,
                labelText: AppConstants.color,
                hintText: AppConstants.color,
                controller: _addVehicleAndAccessoriesBloc.colorController)),
      ],
    );
  }

  Widget _buildHSNCodeAndUniteRate() {
    return Row(
      children: [
        Expanded(
            child: TldsInputFormField(
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d{0,8}'))],
                height: 40,
                labelText: AppConstants.hsnCode,
                hintText: AppConstants.hsnCode,
                controller: _addVehicleAndAccessoriesBloc.hsnCodeController)),
        _buildDefaultWidth(),
        Expanded(
            child: TldsInputFormField(
                height: 40,
                labelText: AppConstants.unitRate,
                hintText: AppConstants.unitRate,
                controller: _addVehicleAndAccessoriesBloc.unitRateController)),
      ],
    );
  }

  Widget _buildEngineDetails() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.36,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTextWidget(AppConstants.engineDetails,
                    color: _appColors.primaryColor, fontSize: 20),
                _buildTextWidget('QTY : 02',
                    color: _appColors.primaryColor, fontSize: 20),
              ],
            ),
            _buildDefaultHeight(),
            _buildEngineNumberAndFrameNumber(),
            _buildDefaultHeight(),
            _buildEngineDetailsList(),
            _buildDefaultHeight()
          ],
        ),
      ),
    );
  }

  Widget _buildEngineNumberAndFrameNumber() {
    return Row(
      children: [
        Expanded(
            child: TldsInputFormField(
                inputFormatters: [],
                height: 40,
                labelText: AppConstants.engineNumber,
                hintText: AppConstants.engineNumber,
                controller:
                    _addVehicleAndAccessoriesBloc.engineNumberController)),
        _buildDefaultWidth(),
        Expanded(
            child: TldsInputFormField(
                height: 40,
                labelText: AppConstants.frameNumber,
                hintText: AppConstants.frameNumber,
                controller:
                    _addVehicleAndAccessoriesBloc.frameNumberController)),
      ],
    );
  }

  Widget _buildEngineDetailsList() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 0.2,
      child: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return Card(
              elevation: 0,
              shape: OutlineInputBorder(
                  borderSide: BorderSide(color: _appColors.cardBorderColor)),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTextWidget('EngineNumber'),
                    _buildTextWidget('FrameNumber'),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.cancel,
                          color: _appColors.errorColor,
                        )),
                  ],
                ),
              ));
        },
      ),
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

  Widget _buildTextWidget(String text,
      {double? fontSize, FontWeight? fontWeight, Color? color}) {
    return Text(
      text,
      style: GoogleFonts.poppins(
          color: color, fontWeight: fontWeight, fontSize: fontSize),
    );
  }
}
