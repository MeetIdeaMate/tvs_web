import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tlbilling/models/get_model/get_all_stocks_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/sales/add_sales_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';

class SelectedSalesData extends StatefulWidget {
  final AddSalesBlocImpl addSalesBloc;
  const SelectedSalesData({
    super.key,
    required this.addSalesBloc,
  });

  @override
  State<SelectedSalesData> createState() => _SelectedSalesDataState();
}

class _SelectedSalesDataState extends State<SelectedSalesData> {
  final _appColors = AppColors();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        Text(
          AppConstants.selectVehicleAndAccessories,
          style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: _appColors.primaryColor),
        ),
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        Flexible(
          child: StreamBuilder(
            stream: widget.addSalesBloc.selectedAccessoriesListStream,
            builder: (context, snapshot) {
              return StreamBuilder(
                stream: widget.addSalesBloc.selectedItemStreamController,
                builder: (context, snapshot) {
                  List<GetAllStockDetails>? selectedVehiclesList =
                      widget.addSalesBloc.selectedVehiclesList;
                  List<GetAllStockDetails>? selectedAccessoriesList =
                      widget.addSalesBloc.slectedAccessoriesList;

                  bool hasVehicles = selectedVehiclesList != null &&
                      selectedVehiclesList.isNotEmpty;
                  bool hasAccessories = selectedAccessoriesList != null &&
                      selectedAccessoriesList.isNotEmpty;

                  return ListView.builder(
                    itemCount: widget
                                .addSalesBloc.selectedVehicleAndAccessories ==
                            'M-Vehicle'
                        ? (hasVehicles ? selectedVehiclesList.length : 0)
                        : (widget.addSalesBloc.selectedVehicleAndAccessories ==
                                'E-Vehicle'
                            ? (hasVehicles ? selectedVehiclesList.length : 0)
                            : (hasAccessories
                                ? selectedAccessoriesList.length
                                : 0)),
                    itemBuilder: (BuildContext context, int index) {
                      if (widget.addSalesBloc.selectedVehicleAndAccessories ==
                          'M-Vehicle') {
                        if (hasVehicles) {
                          GetAllStockDetails? vehicle =
                              selectedVehiclesList[index];
                          return _buildSelectedVehicleCard(vehicle, index);
                        } else {
                          return Container();
                        }
                      } else if (widget
                              .addSalesBloc.selectedVehicleAndAccessories ==
                          'E-Vehicle') {
                        if (hasVehicles) {
                          GetAllStockDetails? vehicle =
                              selectedVehiclesList[index];
                          return _buildSelectedVehicleCard(vehicle, index);
                        } else {
                          return Container();
                        }
                      } else {
                        if (hasAccessories) {
                          var accessories = selectedAccessoriesList[index];
                          return _buildSelectedAccessoriesCardDetails(
                              accessories, index);
                        } else {
                          return Container();
                        }
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
        _buildGSTType(),
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        _buildDiscount(context),
        const Divider(),
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Taxable Amount : ₹ 10,0000',
              style: TextStyle(fontSize: 14),
            ),
            AppWidgetUtils.buildSizedBox(custHeight: 6),
            const Text('CGST (14%)  : ₹ 14,000',
                style: TextStyle(fontSize: 14)),
            AppWidgetUtils.buildSizedBox(custHeight: 6),
            const Text('SGST(14%) :  ₹ 14,000', style: TextStyle(fontSize: 14)),
            AppWidgetUtils.buildSizedBox(custHeight: 6),
            const Text('Disc :  10%', style: TextStyle(fontSize: 14)),
            AppWidgetUtils.buildSizedBox(custHeight: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: _appColors.bgHighlightColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: const Text('Total Inv Amount : ₹ 12,8000',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            AppWidgetUtils.buildSizedBox(custHeight: 10),
            Row(
              children: [
                Checkbox(
                  value: widget.addSalesBloc.isInsurenceChecked,
                  onChanged: (value) {
                    setState(() {
                      widget.addSalesBloc.isInsurenceChecked = value!;
                    });
                  },
                ),
                AppWidgetUtils.buildSizedBox(custWidth: 5),
                const Text('Insurance for the vehicle YES / NO'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDiscount(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: widget.addSalesBloc.isDiscountChecked,
              onChanged: (value) {
                setState(() {
                  widget.addSalesBloc.isDiscountChecked = value ?? false;
                });
              },
            ),
            AppWidgetUtils.buildSizedBox(custWidth: 5),
            const Text(AppConstants.discount),
          ],
        ),
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        if (widget.addSalesBloc.isDiscountChecked)
          TldsInputFormField(
            width: 300,
            controller: widget.addSalesBloc.discountTextController,
            hintText: AppConstants.discount,
          ),
      ],
    );
  }

  Widget _buildGSTType() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppConstants.gstType,
          style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: _appColors.primaryColor),
        ),
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Radio(
                  value: 'GST',
                  groupValue: widget.addSalesBloc.selectedGstType,
                  onChanged: (value) {
                    setState(() {
                      widget.addSalesBloc.selectedGstType = value ?? '';
                    });
                  },
                ),
                const Text('GST(%)'),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: 'IGST',
                  groupValue: widget.addSalesBloc.selectedGstType,
                  onChanged: (value) {
                    setState(() {
                      widget.addSalesBloc.selectedGstType = value ?? '';
                    });
                  },
                ),
                const Text('IGST(%)'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectedVehicleCard(GetAllStockDetails vehicle, int index) {
    return Card(
      color: _appColors.whiteColor,
      elevation: 0,
      shape: OutlineInputBorder(
          borderSide: BorderSide(color: _appColors.cardBorderColor),
          borderRadius: BorderRadius.circular(5)),
      surfaceTintColor: _appColors.whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCustomTextWidget(vehicle.itemName ?? '',
                    fontSize: 14, fontWeight: FontWeight.w500),
                // _buildCustomTextWidget(vehicle.partNo ?? '',
                //     fontSize: 12, fontWeight: FontWeight.w500),
              ],
            ),
            _buildCustomTextWidget(vehicle.partNo ?? '',
                fontSize: 12, fontWeight: FontWeight.w500),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCustomTextWidget(
                        vehicle.mainSpecValue?.engineNo ?? '',
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                    AppWidgetUtils.buildSizedBox(custWidth: 12),
                    _buildCustomTextWidget(vehicle.mainSpecValue?.frameNo ?? '',
                        fontSize: 10, fontWeight: FontWeight.bold),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          widget.addSalesBloc.selectedVehiclesList
                              ?.removeAt(index);
                          widget.addSalesBloc
                              .vehicleAndEngineNumberStreamController(true);

                          widget.addSalesBloc.selectedItemStream(true);
                          widget.addSalesBloc.vehicleData?.add(vehicle);
                          widget.addSalesBloc.availableVehicleListStream(true);
                        },
                        icon: SvgPicture.asset(
                          AppConstants.icFilledClose,
                          height: 28,
                          width: 28,
                        ))
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTextWidget(String text,
      {Color? color, FontWeight? fontWeight, double? fontSize}) {
    return Text(
      text,
      style: GoogleFonts.poppins(
          color: color, fontWeight: fontWeight, fontSize: fontSize),
    );
  }

  Widget _buildSelectedAccessoriesCardDetails(
      GetAllStockDetails accessories, int index) {
    return Card(
      elevation: 0,
      shape: OutlineInputBorder(
        borderSide: BorderSide(color: _appColors.cardBorderColor),
        borderRadius: BorderRadius.circular(5),
      ),
      color: _appColors.whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder<int>(
          valueListenable: widget.addSalesBloc.initialValueNotifier,
          builder: (context, initialValue, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCustomTextWidget(
                      accessories.itemName ?? '',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    _buildCustomTextWidget(
                      accessories.partNo ?? '',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: _appColors.liteGrayColor,
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _appColors.disabledColor,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (initialValue > 0) {
                            widget.addSalesBloc.decrementInitialValue();
                          }
                        },
                        icon: SvgPicture.asset(
                          AppConstants.icFilledMinus,
                          width: 24,
                          height: 24,
                        ),
                      ),
                      Text(
                        '$initialValue',
                      ),
                      IconButton(
                        onPressed: () {
                          if (initialValue < (accessories.quantity ?? 0)) {
                            widget.addSalesBloc.incrementInitialValue();
                          }
                        },
                        icon: SvgPicture.asset(
                          AppConstants.icFilledAdd,
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Remove the accessory from the list
                    widget.addSalesBloc.slectedAccessoriesList?.removeAt(index);

                    // Notify that the selected accessories list has changed
                    widget.addSalesBloc
                        .selectedAccessoriesListStreamController(true);

                    // Add the accessory back to the available list (if needed)
                    widget.addSalesBloc.accessoriesData?.add(accessories);

                    // Notify that the available accessories list has changed
                    widget.addSalesBloc.availableAccListStream(true);
                  },
                  icon: SvgPicture.asset(AppConstants.icFilledClose),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
