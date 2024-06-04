import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_vehicle_and_accesories/add_vehicle_and_accessories.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_vehicle_and_accesories/add_vehicle_and_accessories_bloc.dart';
import 'package:tlbilling/view/purchase/add_purchase/purchase_table.dart';
import 'package:tlds_flutter/export.dart';

class AddPurchase extends StatefulWidget {
  const AddPurchase({super.key});

  @override
  State<AddPurchase> createState() => _AddPurchaseState();
}

class _AddPurchaseState extends State<AddPurchase> {
  final _appColors = AppColor();
  final _purchaseBloc = AddVehicleAndAccessoriesBlocImpl();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppConstants.purchase,
          style: GoogleFonts.poppins(color: _appColors.primaryColor),
        ),
      ),
      body:  Row(
        children: [
          PurchaseTable(purchaseBloc: _purchaseBloc,),
          AddVehicleAndAccessories(purchaseBloc:  _purchaseBloc,),
        ],
      ),
    );
  }
}
