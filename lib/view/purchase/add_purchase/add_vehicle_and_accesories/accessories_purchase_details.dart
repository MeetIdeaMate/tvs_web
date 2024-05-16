import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_vehicle_and_accesories/add_vehicle_and_accessories_bloc.dart';
import 'package:tlds_flutter/export.dart';

class AccessoriesPurchaseDetails extends StatefulWidget {
  const AccessoriesPurchaseDetails({super.key});

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
    return Padding(padding: const EdgeInsets.all(12),
    child: Column(
      children: [
        _buildMaterialNumberAndName(),
        _buildDefaultHeight(),
        _buildHSNCodeAndQty(),
        _buildDefaultHeight(),
        _buildUnitRate(),
        _buildDefaultHeight()
      ],
    ),);
  }

  Widget _buildMaterialNumberAndName() {
    return Row(
      children: [
        Expanded(
            child: TldsInputFormField(
                height: 40,
                labelText: AppConstants.materialNumber,
                hintText: AppConstants.materialNumber,
                controller:
                    _addVehicleAndAccessoriesBloc.materialNumberController)),
        _buildDefaultWidth(),
        Expanded(
            child: TldsInputFormField(
                height: 40,
                labelText: AppConstants.materialName,
                hintText: AppConstants.materialName,
                controller:
                    _addVehicleAndAccessoriesBloc.materialNameController)),
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
                controller: _addVehicleAndAccessoriesBloc.hsnCodeController)),
        _buildDefaultWidth(),
        Expanded(
            child: TldsInputFormField(
                height: 40,
                labelText: AppConstants.quantity,
                hintText: AppConstants.quantity,
                controller: _addVehicleAndAccessoriesBloc.quantityController)),
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
                controller: _addVehicleAndAccessoriesBloc.unitRateController)),
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
