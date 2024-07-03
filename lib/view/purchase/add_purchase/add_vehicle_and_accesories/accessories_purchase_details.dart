import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_vehicle_and_accesories/add_vehicle_and_accessories_bloc.dart';
import 'package:tlds_flutter/export.dart';

class AccessoriesPurchaseDetails extends StatefulWidget {
  AddVehicleAndAccessoriesBlocImpl purchaseBloc;
  AccessoriesPurchaseDetails({super.key, required this.purchaseBloc});

  @override
  State<AccessoriesPurchaseDetails> createState() =>
      _AccessoriesPurchaseDetailsState();
}

class _AccessoriesPurchaseDetailsState
    extends State<AccessoriesPurchaseDetails> {
  final _addVehicleAndAccessoriesBloc = AddVehicleAndAccessoriesBlocImpl();
  final List<String> vehicleAndAccessories = ['Vehicle', 'Accessories'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _buildVehicleDetails(),
          _buildDefaultHeight(),
          _buildHSNCodeAndQty(),
          _buildDefaultHeight(),
          _buildUnitRate(),
          _buildDefaultHeight()
        ],
      ),
    );
  }

  Widget _buildVehicleDetails() {
    return Row(
      children: [
        Expanded(
            child: TldsInputFormField(
                height: 40,
                labelText: AppConstants.materialNumber,
                hintText: AppConstants.materialNumber,
                controller: widget.purchaseBloc.partNumberController)),
        _buildDefaultWidth(),
        Expanded(
            child: TldsInputFormField(
                height: 40,
                labelText: AppConstants.materialName,
                hintText: AppConstants.materialName,
                controller: widget.purchaseBloc.vehicleNameTextController)),
      ],
    );
  }

  Widget _buildHSNCodeAndQty() {
    return Row(
      children: [
        Expanded(
            child: TldsInputFormField(
                height: 40,
                labelText: AppConstants.hsnCode,
                hintText: AppConstants.hsnCode,
                controller: widget.purchaseBloc.hsnCodeController)),
        _buildDefaultWidth(),
        Expanded(
            child: TldsInputFormField(
                height: 40,
                labelText: AppConstants.quantity,
                hintText: AppConstants.quantity,
                controller: widget.purchaseBloc.quantityController)),
      ],
    );
  }

  Widget _buildUnitRate() {
    return Row(
      children: [
        Expanded(
            child: TldsInputFormField(
                height: 40,
                labelText: AppConstants.unitRate,
                hintText: AppConstants.unitRate,
                controller: widget.purchaseBloc.unitRateController)),
      ],
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
}
