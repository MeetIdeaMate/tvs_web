import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tlbilling/models/get_model/get_all_stocks_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlbilling/view/sales/add_sales_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';

class SelectedSalesData extends StatefulWidget {
  final AddSalesBlocImpl addSalesBloc;

  const SelectedSalesData({
    Key? key,
    required this.addSalesBloc,
  }) : super(key: key);

  @override
  State<SelectedSalesData> createState() => _SelectedSalesDataState();
}

class _SelectedSalesDataState extends State<SelectedSalesData> {
  final _appColors = AppColors();

  @override
  void initState() {
    super.initState();
    // Initialize the controllers for selected vehicles
    widget.addSalesBloc.selectedVehiclesList?.forEach((vehicle) {
      widget.addSalesBloc.unitRateControllers.add(TextEditingController());
    });
  }

  @override
  void dispose() {
    widget.addSalesBloc.unitRateControllers
        .forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _updateUnitRateControllers() {
    while (widget.addSalesBloc.unitRateControllers.length <
        (widget.addSalesBloc.selectedVehiclesList?.length ?? 0)) {
      widget.addSalesBloc.unitRateControllers.add(TextEditingController());
    }
    while (widget.addSalesBloc.unitRateControllers.length >
        (widget.addSalesBloc.selectedVehiclesList?.length ?? 0)) {
      widget.addSalesBloc.unitRateControllers.removeLast().dispose();
    }

    double totalValue = 0.0;
    int qty = widget.addSalesBloc.selectedVehiclesList?.length ?? 0;
    for (int i = 0; i < qty; i++) {
      double unitRate =
          double.tryParse(widget.addSalesBloc.unitRateControllers[i].text) ??
              0.0;
      totalValue += unitRate;
    }

    widget.addSalesBloc.totalValue = totalValue;
    widget.addSalesBloc.paymentDetailsStreamController(true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppWidgetUtils.buildSizedBox(custHeight: 10),
          _buildHeadingText(AppConstants.selectVehicleAndAccessories),
          _buildSelectedDataList(),
          AppWidgetUtils.buildSizedBox(custHeight: 10),
          _buildHeadingText(AppConstants.mandatoryAddons),
          _buildMandatoryAdd(
            AppConstants.tools,
            widget.addSalesBloc.selectedTypeTools,
            (value) {
              setState(() {
                widget.addSalesBloc.selectedTypeTools = value ?? '';
              });
            },
          ),
          _buildMandatoryAdd(
            AppConstants.manualHardCopy,
            widget.addSalesBloc.selectedTypeManualBook,
            (value) {
              setState(() {
                widget.addSalesBloc.selectedTypeManualBook = value ?? '';
              });
            },
          ),
          _buildMandatoryAdd(
            AppConstants.dupicateKey,
            widget.addSalesBloc.selectedTypeDuplicateKeys,
            (value) {
              setState(() {
                widget.addSalesBloc.selectedTypeDuplicateKeys = value ?? '';
              });
            },
          ),
          const SizedBox(height: 15),
          if (widget.addSalesBloc.selectedVehicleAndAccessories ==
              'E-Vehicle') ...[
            _buildHeadingText(AppConstants.eVehicleConponents),
            _buildBatteryDetails(),
          ],
        ],
      ),
    );
  }

  Widget _buildBatteryDetails() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(AppConstants.batteryName),
            const Spacer(),
            Expanded(
              child: TldsInputFormField(
                controller: widget.addSalesBloc.betteryNameTextController,
                hintText: AppConstants.hintBatteryName,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(AppConstants.batteryCapacity),
            const Spacer(),
            Expanded(
              child: TldsInputFormField(
                controller: widget.addSalesBloc.batteryCapacityTextController,
                hintText: AppConstants.batteryCapacity,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeadingText(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
          color: _appColors.primaryColor),
    );
  }

  Widget _buildSelectedDataList() {
    return Expanded(
      child: StreamBuilder(
        stream: widget.addSalesBloc.selectedItemStreamController,
        builder: (context, snapshot) {
          List<GetAllStockDetails>? selectedVehiclesList =
              widget.addSalesBloc.selectedVehiclesList;
          List<GetAllStockDetails>? selectedAccessoriesList =
              widget.addSalesBloc.slectedAccessoriesList;

          bool hasVehicles =
              selectedVehiclesList != null && selectedVehiclesList.isNotEmpty;
          bool hasAccessories = selectedAccessoriesList != null &&
              selectedAccessoriesList.isNotEmpty;

          _updateUnitRateControllers();

          return ListView.builder(
            itemCount: widget.addSalesBloc.selectedVehicleAndAccessories ==
                    'M-Vehicle'
                ? (hasVehicles ? selectedVehiclesList.length : 0)
                : (widget.addSalesBloc.selectedVehicleAndAccessories ==
                        'E-Vehicle'
                    ? (hasVehicles ? selectedVehiclesList.length : 0)
                    : (hasAccessories ? selectedAccessoriesList.length : 0)),
            itemBuilder: (BuildContext context, int index) {
              if (widget.addSalesBloc.selectedVehicleAndAccessories ==
                      'M-Vehicle' ||
                  widget.addSalesBloc.selectedVehicleAndAccessories ==
                      'E-Vehicle') {
                if (hasVehicles) {
                  GetAllStockDetails? vehicle = selectedVehiclesList[index];
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
      ),
    );
  }

  Widget _buildMandatoryAdd(
      String label, String groupValue, ValueChanged<String?> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        Row(
          children: [
            Radio(
              value: 'YES',
              groupValue: groupValue,
              onChanged: onChanged,
            ),
            const Text(
              AppConstants.yes,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Radio(
              value: 'NO',
              groupValue: groupValue,
              onChanged: onChanged,
            ),
            const Text(
              AppConstants.no,
              style: TextStyle(
                fontSize: 16,
              ),
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
              ],
            ),
            _buildCustomTextWidget(vehicle.partNo ?? '',
                fontSize: 12, fontWeight: FontWeight.w500),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
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
                    TldsInputFormField(
                      width: 150,
                      controller:
                          widget.addSalesBloc.unitRateControllers[index],
                      inputFormatters:
                          TlInputFormatters.onlyAllowDecimalNumbers,
                      hintText: AppConstants.rupeeHint,
                      onChanged: (value) {
                        double totalValue = 0.0;

                        int qty =
                            widget.addSalesBloc.selectedVehiclesList?.length ??
                                0;
                        for (int i = 0; i < qty; i++) {
                          double unitRate = double.tryParse(widget
                                  .addSalesBloc.unitRateControllers[i].text) ??
                              0.0;
                          totalValue += unitRate;
                        }

                        widget.addSalesBloc.totalValue = totalValue * qty;
                        widget.addSalesBloc.totalUnitRate = totalValue;
                        widget.addSalesBloc
                            .paymentDetailsStreamController(true);
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          widget.addSalesBloc.selectedVehiclesList
                              ?.removeAt(index);
                          widget.addSalesBloc.unitRateControllers
                              .removeAt(index)
                              .dispose();
                          widget.addSalesBloc
                              .vehicleAndEngineNumberStreamController(true);
                          widget.addSalesBloc.selectedItemStream(true);
                          widget.addSalesBloc.vehicleData?.add(vehicle);
                          widget.addSalesBloc.availableVehicleListStream(true);
                        });
                      },
                      icon: SvgPicture.asset(
                        AppConstants.icFilledClose,
                        height: 28,
                        width: 28,
                      ),
                    ),
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
                      Text('$initialValue'),
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
                    setState(() {
                      widget.addSalesBloc.slectedAccessoriesList
                          ?.removeAt(index);
                      widget.addSalesBloc
                          .selectedAccessoriesListStreamController(true);
                      widget.addSalesBloc.accessoriesData?.add(accessories);
                      widget.addSalesBloc.availableAccListStream(true);
                    });
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
