import 'package:flutter/material.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/sales/accessories_sales_table.dart';
import 'package:tlbilling/view/sales/add_sales_bloc.dart';
import 'package:tlbilling/view/sales/payment_details.dart';
import 'package:tlbilling/view/sales/sales_view_bloc.dart';
import 'package:tlbilling/view/sales/selected_sales_data.dart';
import 'package:tlbilling/view/sales/vechile_accessories_list.dart';

class AddSales extends StatefulWidget {
  final SalesViewBlocImpl salesViewBloc;
  const AddSales({super.key, required this.salesViewBloc});

  @override
  State<AddSales> createState() => _AddSalesState();
}

class _AddSalesState extends State<AddSales> {
  final _appColors = AppColors();
  final _addSalesBloc = AddSalesBlocImpl();

  @override
  void initState() {
    super.initState();
    _addSalesBloc.selectedVehicleAndAccessories = 'Vehicle';
    _addSalesBloc.selectedVehicleAndAccessoriesStreamController(true);
  }

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
    return Form(
      key: _addSalesBloc.paymentFormKey,
      child: StreamBuilder<bool>(
          stream: _addSalesBloc.screenChangeStream,
          builder: (context, snapshot) {
            return Row(
              children: [
                if (_addSalesBloc.isAccessoriestable == false)
                  Expanded(
                    flex: 1,
                    child: _buildVehicleAndAccessoriesList(),
                  ),
                if (_addSalesBloc.selectedVehicleAndAccessories !=
                    'Accessories')
                  Expanded(
                    flex: 1,
                    child: _buildInvoiceEntry(),
                  ),
                if (_addSalesBloc.selectedVehicleAndAccessories !=
                    'Accessories')
                  AppWidgetUtils.buildSizedBox(custWidth: 50),
                if (_addSalesBloc.selectedVehicleAndAccessories !=
                    'Accessories')
                  Expanded(
                    flex: 1,
                    child: _buildCustomerAndPaymentDetails(),
                  ),
                if (_addSalesBloc.selectedVehicleAndAccessories ==
                    'Accessories') ...[
                  AppWidgetUtils.buildSizedBox(
                      custWidth:
                          _addSalesBloc.isAccessoriestable == false ? 20 : 0),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: _addSalesBloc.isAccessoriestable == false
                          ? BoxDecoration(
                              border: Border.symmetric(
                                  vertical: BorderSide(color: _appColors.grey)),
                            )
                          : const BoxDecoration(),
                      child: AccessoiresSalesTable(
                        addSalesBloc: _addSalesBloc,
                      ),
                    ),
                  ),
                  if (_addSalesBloc.isAccessoriestable)
                    Expanded(
                      flex: 1,
                      child: _buildCustomerAndPaymentDetails(),
                    ),
                ]
              ],
            );
          }),
    );
  }

  Widget _buildCustomerAndPaymentDetails() {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                  vertical: BorderSide(color: _appColors.grey)),
            ),
            child: PaymentDetails(
              salesViewBloc: widget.salesViewBloc,
              addSalesBloc: _addSalesBloc,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceEntry() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: _appColors.hightlightColor),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: _appColors.lightBgColor,
        ),
        child: SelectedSalesData(addSalesBloc: _addSalesBloc),
      ),
    );
  }

  Widget _buildVehicleAndAccessoriesList() {
    return Column(
      children: [
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   decoration: BoxDecoration(
        //     color: _appColors.whiteColor,
        //   ),
        //   child: CustomerDetails(
        //     addSalesBloc: _addSalesBloc,
        //   ),
        // ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: _appColors.whiteColor,
            ),
            child: VehicleAccessoriesList(
              addSalesBloc: _addSalesBloc,
            ),
          ),
        ),
      ],
    );
  }
}
