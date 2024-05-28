import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/sales/add_sales_bloc.dart';
import 'package:tlbilling/view/sales/customer_details.dart';
import 'package:tlbilling/view/sales/selected_sales_data.dart';
import 'package:tlbilling/view/sales/vechile_accessories_list.dart';

class AddSales extends StatefulWidget {
  const AddSales({super.key});

  @override
  State<AddSales> createState() => _AddSalesState();
}

class _AddSalesState extends State<AddSales> {
  final _appColors = AppColors();
  final _addSalesBloc = AddSalesBlocImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _appColors.whiteColor,
      appBar: AppBar(
        backgroundColor: _appColors.whiteColor,
        title: const Text(AppConstants.addSales),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: _appColors.grey,
            height: 1.0,
          ),
        ),
      ),
      body: _buildAddSalesEntryBody(),
    );
  }

  Widget _buildAddSalesEntryBody() {
    return Row(
      children: [
        _buildVehicleAndAccessoriesList(),
        _buildInvoiceEntry(),
        AppWidgetUtils.buildSizedBox(custWidth: 50),
        _buildCustomerAndPaymentDetails(),
      ],
    );
  }

  Widget _buildCustomerAndPaymentDetails() {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border:
              Border.symmetric(vertical: BorderSide(color: _appColors.grey)),
          color: _appColors.darkHighlight,
        ),
        child: CustomerDetails(
          addSalesBloc: _addSalesBloc,
        ),
      ),
    );
  }

  Widget _buildInvoiceEntry() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: _appColors.lightBgColor,
            ),
            child: SelectedSalesData(addSalesBloc: _addSalesBloc)),
      ),
    );
  }

  Widget _buildVehicleAndAccessoriesList() {
    return Expanded(
      flex: 2,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: _appColors.whiteColor,
          ),
          child: VehicleAccessoriesList(
            addSalesBloc: _addSalesBloc,
          )),
    );
  }
}
