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
import 'package:tlds_flutter/components/tlds_input_formaters.dart';

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
  bool isEVehicle = false;

  @override
  void initState() {
    super.initState();
    widget.addSalesBloc.selectedVehiclesList?.forEach((vehicle) {
      widget.addSalesBloc.unitRateControllers.add(TextEditingController());
    });

    _initializeControllers();
  }

  _initializeControllers() {
    var controller = widget.addSalesBloc.accessoriesQuantityController;
    controller = widget.addSalesBloc.slectedAccessoriesList!.map((accessory) {
      var controller = TextEditingController(
          text: widget.addSalesBloc.initialValueNotifier.value.toString());
      controller.addListener(
          () => _validateAndSetInitialValue(controller, accessory));
      return controller;
    }).toList();
    var unitRatecontroller = widget.addSalesBloc.accessoriesQuantityController;
    unitRatecontroller =
        widget.addSalesBloc.slectedAccessoriesList!.map((accessory) {
      var controller = TextEditingController(
          text: widget.addSalesBloc.initialValueNotifier.value.toString());

      return controller;
    }).toList();
  }

  void _validateAndSetInitialValue(
      TextEditingController controller, GetAllStockDetails accessory) {
    int? value = int.tryParse(controller.text);
    if (value == null || value < 0) {
      controller.text = '1';
    } else if (value > (accessory.quantity ?? 0)) {
      controller.text = (accessory.quantity ?? 0).toString();
    } else {
      widget.addSalesBloc.initialValueNotifier.value = value;
    }
  }

  @override
  void dispose() {
    for (var controller in widget.addSalesBloc.accessoriesQuantityController) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: StreamBuilder<bool>(
          stream: widget.addSalesBloc.batteryDetailsRefreshStream,
          builder: (context, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                _buildHeadingText(AppConstants.selectVehicleAndAccessories),
                _buildSelectedDataList(),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                _buildHeadingText(AppConstants.mandatoryAddons),
                FutureBuilder(
                  future: widget.addSalesBloc.getMandantoryAddOns(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Text(AppConstants.loading));
                    } else if (snapshot.hasError) {
                      return const Text(AppConstants.errorLoading);
                    } else if (!snapshot.hasData ||
                        (snapshot.data as List<String>).isEmpty) {
                      return const Text(AppConstants.noData);
                    } else {
                      List<String> mandatoryAddOns =
                          snapshot.data as List<String>;
                      return StreamBuilder<bool>(
                          stream: widget.addSalesBloc.mandatoryRefereshStream,
                          builder: (context, snapshot) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: mandatoryAddOns.length,
                              itemBuilder: (context, index) {
                                String addOn = mandatoryAddOns[index];
                                return _buildMandatoryAdd(
                                  addOn,
                                  widget.addSalesBloc
                                          .selectedMandatoryAddOns[addOn] ??
                                      '',
                                  (value) {
                                    widget.addSalesBloc
                                        .mandatoryRefereshStreamController(
                                            true);

                                    widget.addSalesBloc
                                            .selectedMandatoryAddOns[addOn] =
                                        value ?? '';
                                  },
                                );
                              },
                            );
                          });
                    }
                  },
                ),
                const SizedBox(height: 15),
                if (widget.addSalesBloc.selectedVehicleAndAccessories ==
                    'E-Vehicle')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeadingText(AppConstants.eVehicleConponents),
                      _buildBatteryDetails(),
                    ],
                  ),
              ],
            );
          }),
    );
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

  Widget _buildBatteryDetails() {
    return Column(
      children: [
        FutureBuilder(
          future: widget.addSalesBloc.getBatteryDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text(AppConstants.loading));
            } else if (snapshot.hasError) {
              return const Text(AppConstants.errorLoading);
            } else if (!snapshot.hasData ||
                (snapshot.data as List<String>).isEmpty) {
              return const Text(AppConstants.noData);
            } else {
              List<String> eVehicleComponents = snapshot.data as List<String>;

              while (widget.addSalesBloc.batteryDetailsControllers.length <
                  eVehicleComponents.length) {
                widget.addSalesBloc.batteryDetailsControllers
                    .add(TextEditingController());
              }
              while (widget.addSalesBloc.batteryDetailsControllers.length >
                  eVehicleComponents.length) {
                widget.addSalesBloc.batteryDetailsControllers
                    .removeLast()
                    .dispose();
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: eVehicleComponents.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(eVehicleComponents[index]),
                      const Spacer(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: TldsInputFormField(
                            height: 40,
                            controller: widget
                                .addSalesBloc.batteryDetailsControllers[index],
                            hintText: eVehicleComponents[index],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
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
                        _buildPaymentCalculation();
                      },
                    ),
                    IconButton(
                      onPressed: () {
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

  void _buildPaymentCalculation() {
    double totalUnitValue = 0.0;
    int qty = widget.addSalesBloc.selectedVehiclesList?.length ?? 0;

    for (int i = 0; i < qty; i++) {
      double unitRate =
          double.tryParse(widget.addSalesBloc.unitRateControllers[i].text) ??
              0.0;
      totalUnitValue += unitRate;
    }

    widget.addSalesBloc.totalValue = totalUnitValue * qty;

    double totalValues = widget.addSalesBloc.totalValue ?? 0;
    double cgstPercent = double.tryParse(
            widget.addSalesBloc.cgstPresentageTextController.text) ??
        0;
    double sgstPercent = double.tryParse(
            widget.addSalesBloc.cgstPresentageTextController.text) ??
        0;

    widget.addSalesBloc.taxableValue = totalValues;
    widget.addSalesBloc.cgstAmount = (totalValues / 100) * cgstPercent;
    widget.addSalesBloc.sgstAmount = (totalValues / 100) * sgstPercent;

    double taxableValue = widget.addSalesBloc.taxableValue ?? 0;
    widget.addSalesBloc.invAmount =
        taxableValue + (widget.addSalesBloc.sgstAmount ?? 0 * 2);
    _updateTotalInvoiceAmount();

    widget.addSalesBloc.paymentDetailsStreamController(true);
    widget.addSalesBloc.gstRadioBtnRefreashStreamController(true);
  }

  void _updateTotalInvoiceAmount() {
    double? empsIncValue =
        double.tryParse(widget.addSalesBloc.empsIncentiveTextController.text) ??
            0.0;
    double? stateIncValue = double.tryParse(
            widget.addSalesBloc.stateIncentiveTextController.text) ??
        0.0;

    double totalIncentive = empsIncValue + stateIncValue;
    widget.addSalesBloc.paymentDetailsStreamController(true);
    widget.addSalesBloc.totalInvAmount =
        (widget.addSalesBloc.invAmount ?? 0) - totalIncentive;
    widget.addSalesBloc.paymentDetailsStreamController(true);

    double advanceAmt = widget.addSalesBloc.advanceAmt ?? 0;
    double totalInvAmt = widget.addSalesBloc.totalInvAmount ?? 0;
    widget.addSalesBloc.toBePayedAmt = totalInvAmt - advanceAmt;

    widget.addSalesBloc.paymentDetailsStreamController(true);
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
    if (index >= widget.addSalesBloc.accessoriesQuantityController.length) {
      var controller = TextEditingController(
          text: widget.addSalesBloc.initialValueNotifier.value.toString());
      controller.addListener(
          () => _validateAndSetInitialValue(controller, accessories));
      widget.addSalesBloc.accessoriesQuantityController.add(controller);
    }

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
                Row(
                  children: [
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
                                int newQuantity = int.parse(widget
                                        .addSalesBloc
                                        .accessoriesQuantityController[index]
                                        .text) -
                                    1;
                                widget
                                    .addSalesBloc
                                    .accessoriesQuantityController[index]
                                    .text = newQuantity.toString();

                                // Check if the new quantity is zero and remove the item if so
                                if (newQuantity == 0) {
                                  setState(() {
                                    widget.addSalesBloc.slectedAccessoriesList
                                        ?.removeAt(index);
                                    widget.addSalesBloc
                                        .selectedAccessoriesListStreamController(
                                            true);
                                    widget.addSalesBloc.accessoriesData
                                        ?.add(accessories);
                                    widget.addSalesBloc
                                        .availableAccListStream(true);
                                    widget.addSalesBloc
                                        .accessoriesQuantityController
                                        .removeAt(index);
                                  });
                                }
                              }
                            },
                            icon: SvgPicture.asset(
                              AppConstants.icFilledMinus,
                              width: 24,
                              height: 24,
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            child: TextField(
                              controller: widget.addSalesBloc
                                  .accessoriesQuantityController[index],
                              keyboardType: TextInputType.number,
                              inputFormatters:
                                  TldsInputFormatters.onlyAllowNumbers,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                int? intValue = int.tryParse(value);
                                if (intValue != null) {
                                  widget.addSalesBloc.initialValueNotifier
                                      .value = intValue;
                                }
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (initialValue < (accessories.quantity ?? 0)) {
                                widget.addSalesBloc.incrementInitialValue();
                                widget
                                    .addSalesBloc
                                    .accessoriesQuantityController[index]
                                    .text = (int.parse(widget
                                            .addSalesBloc
                                            .accessoriesQuantityController[
                                                index]
                                            .text) +
                                        1)
                                    .toString();
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
                    TldsInputFormField(
                      width: 150,
                      controller: widget
                          .addSalesBloc.accessoriesUnitRateControllers[index],
                      inputFormatters:
                          TlInputFormatters.onlyAllowDecimalNumbers,
                      hintText: AppConstants.rupeeHint,
                      onChanged: (value) {
                        _buildPaymentCalculation();
                      },
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
                          widget.addSalesBloc.accessoriesQuantityController
                              .removeAt(index);
                        });
                      },
                      icon: SvgPicture.asset(AppConstants.icFilledClose),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
