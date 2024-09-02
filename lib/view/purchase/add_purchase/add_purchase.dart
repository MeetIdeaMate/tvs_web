import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tlbilling/api_service/service_locator.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_vehicle_and_accesories/add_vehicle_and_accessories.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_vehicle_and_accesories/add_vehicle_and_accessories_bloc.dart';
import 'package:tlbilling/view/purchase/add_purchase/purchase_table.dart';
import 'package:tlbilling/view/purchase/purchase_view_bloc.dart';
import 'package:tlds_flutter/export.dart';

class AddPurchase extends StatefulWidget {
  const AddPurchase({super.key});

  @override
  State<AddPurchase> createState() => _AddPurchaseState();
}

class _AddPurchaseState extends State<AddPurchase> {
  final _appColors = AppColor();
  final _addPurchaseBloc = getIt<AddVehicleAndAccessoriesBlocImpl>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppConstants.purchase,
          style: GoogleFonts.poppins(color: _appColors.primaryColor),
        ),
      ),
      body: BlurryModalProgressHUD(
        inAsyncCall: _addPurchaseBloc.isAddPurchseBillLoading,
        progressIndicator: const CircularProgressIndicator(),
        child: const Row(
          children: [
            PurchaseTable(),
            AddVehicleAndAccessories(),
          ],
        ),
      ),
    );
  }
}
