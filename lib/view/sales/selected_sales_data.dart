import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
                if (widget.addSalesBloc.selectedVehicleAndAccessories !=
                    'Accessories')
                  _buildHeadingText(AppConstants.mandatoryAddons),
                if (widget.addSalesBloc.selectedVehicleAndAccessories !=
                    'Accessories')
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

  Widget _buildBatteryDetails() {
    return Column(
      children: [
        StreamBuilder(
            stream: widget.addSalesBloc.batteryDetailsRefreshStream,
            builder: (context, snapshot) {
              return FutureBuilder(
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
                    List<String> eVehicleComponents =
                        snapshot.data as List<String>;

                    widget.addSalesBloc.batteryDetailsMap.clear();

                    for (String componentName in eVehicleComponents) {
                      widget.addSalesBloc.batteryDetailsMap[componentName] = '';
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: eVehicleComponents.length,
                      itemBuilder: (context, index) {
                        String componentName = eVehicleComponents[index];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(componentName),
                            const Spacer(),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: TldsInputFormField(
                                  height: 40,
                                  controller: TextEditingController(),
                                  hintText: componentName,
                                  onChanged: (value) {
                                    widget.addSalesBloc
                                            .batteryDetailsMap[componentName] =
                                        value;

                                    printBatteryDetails();
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              );
            }),
      ],
    );
  }

  void printBatteryDetails() {
    widget.addSalesBloc.batteryDetailsMap.forEach((key, value) {
    });
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
    widget.addSalesBloc.unitRateControllers.text =
        widget.addSalesBloc.unitRates[index] ?? '';

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
                    fontSize: 12, fontWeight: FontWeight.w700),
              ],
            ),
            _buildCustomTextWidget(vehicle.partNo ?? '',
                fontSize: 12, fontWeight: FontWeight.w500),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCustomTextWidget(vehicle.mainSpecValue?.engineNo ?? '',
                    fontSize: 10, fontWeight: FontWeight.bold),
                AppWidgetUtils.buildSizedBox(custWidth: 12),
                _buildCustomTextWidget(vehicle.mainSpecValue?.frameNo ?? '',
                    fontSize: 10, fontWeight: FontWeight.bold),
                AppWidgetUtils.buildSizedBox(custWidth: 5),
                Expanded(
                  child: TldsInputFormField(
                    height: 40,
                    controller: TextEditingController(),
                    inputFormatters: TlInputFormatters.onlyAllowDecimalNumbers,
                    hintText: AppConstants.rupeeHint,
                    onChanged: (value) {
                      widget.addSalesBloc.unitRates[index] = value;
                      _buildPaymentCalculation();
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    widget.addSalesBloc.selectedVehiclesList?.removeAt(index);
                    widget.addSalesBloc.unitRates.remove(index);

                    widget.addSalesBloc
                        .vehicleAndEngineNumberStreamController(true);
                    widget.addSalesBloc.selectedItemStream(true);
                    widget.addSalesBloc.vehicleData?.add(vehicle);
                    widget.addSalesBloc.availableVehicleListStream(true);
                    widget.addSalesBloc.cgstPresentageTextController.clear();
                    //  widget.addSalesBloc.sgstPresentageTextController.clear();
                    widget.addSalesBloc.igstPresentageTextController.clear();
                    widget.addSalesBloc.discountTextController.clear();
                    widget.addSalesBloc.stateIncentiveTextController.clear();
                    widget.addSalesBloc.empsIncentiveTextController.clear();
                    _buildPaymentCalculation();
                  },
                  icon: SvgPicture.asset(
                    AppConstants.icFilledClose,
                    height: 28,
                    width: 28,
                  ),
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
          double.tryParse(widget.addSalesBloc.unitRates[i]!) ?? 0.0;
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

    if ((widget.addSalesBloc.invAmount ?? 0) != -1) {
      widget.addSalesBloc.totalInvAmount =
          (widget.addSalesBloc.invAmount ?? 0) - totalIncentive;
    } else {
      widget.addSalesBloc.totalInvAmount = 0.0;
    }
    double advanceAmt = widget.addSalesBloc.advanceAmt ?? 0;
    double totalInvAmt = widget.addSalesBloc.totalInvAmount ?? 0;
    widget.addSalesBloc.toBePayedAmt = totalInvAmt - advanceAmt;
    widget.addSalesBloc.paymentDetailsStreamController(true);
  }

  Widget _buildCustomTextWidget(String text,
      {Color? color, FontWeight? fontWeight, double? fontSize}) {
    return Text(
      text,
      overflow: TextOverflow.fade,
      style: GoogleFonts.poppins(
          color: color, fontWeight: fontWeight, fontSize: fontSize),
    );
  }

  Widget _buildSelectedAccessoriesCardDetails(
    GetAllStockDetails accessories,
    int index,
  ) {
    TextEditingController qtyController = TextEditingController();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   //  qtyController.text = widget.addSalesBloc.accessoriesQty[index] ?? '1';
    // });

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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCustomTextWidget(
                  accessories.itemName ?? '',
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCustomTextWidget(
                      accessories.partNo ?? '',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: _appColors.liteGrayColor,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          // IconButton(
                          //   onPressed: () {
                          //     int currentValue = int.tryParse(widget
                          //             .addSalesBloc.accessoriesQty[index]!) ??
                          //         1;
                          //     if (currentValue > 1) {
                          //       setState(() {
                          //         widget.addSalesBloc.accessoriesQty[index] =
                          //             (currentValue - 1).toString();
                          //         qtyController.text =
                          //             (currentValue - 1).toString();
                          //         widget.addSalesBloc.decrementInitialValue();
                          //         _updateTotalValue();
                          //       });
                          //     }
                          //   },
                          //   icon: SvgPicture.asset(
                          //     AppConstants.icFilledMinus,
                          //     width: 24,
                          //     height: 24,
                          //   ),
                          // ),
                          Expanded(
                            child: TldsInputFormField(
                              height: 40,
                              controller: qtyController,
                              textAlign: TextAlign.center,
                              hintText: 'Qty',
                              inputFormatters:
                                  TlInputFormatters.onlyAllowNumbers,
                              onChanged: (value) {
                                if (value.isEmpty) return;
                                int? intValue = int.tryParse(value);
                                if (intValue != null) {
                                  if (intValue > (accessories.quantity ?? 0)) {
                                    intValue = accessories.quantity ?? 0;
                                    qtyController.text =
                                        accessories.quantity.toString();
                                  }

                                  widget.addSalesBloc.accessoriesQty[index] =
                                      intValue.toString();
                                  widget.addSalesBloc.initialValueNotifier
                                      .value = intValue;
                                  _updateTotalValue();
                                }
                              },
                            ),
                          ),
                          // IconButton(
                          //   onPressed: () {
                          //     int currentValue = int.tryParse(widget
                          //             .addSalesBloc.accessoriesQty[index]!) ??
                          //         0;
                          //     if (currentValue <
                          //         (accessories.quantity ?? 0)) {
                          //       setState(() {
                          //         widget.addSalesBloc.accessoriesQty[index] =
                          //             (currentValue + 1).toString();
                          //         qtyController.text =
                          //             (currentValue + 1).toString();
                          //         widget.addSalesBloc.incrementInitialValue();
                          //         _updateTotalValue();
                          //       });
                          //     }
                          //   },
                          //   icon: SvgPicture.asset(
                          //     AppConstants.icFilledAdd,
                          //     width: 24,
                          //     height: 24,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: TldsInputFormField(
                        height: 40,
                        controller: TextEditingController(),
                        inputFormatters:
                            TldsInputFormatters.onlyAllowDecimalNumbers,
                        hintText: AppConstants.rupeeHint,
                        onChanged: (value) {
                          widget.addSalesBloc.unitRates[index] = value;
                          _updateTotalValue();
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        widget.addSalesBloc.slectedAccessoriesList
                            ?.removeAt(index);
                        widget.addSalesBloc.selectedItemStream(true);
                        widget.addSalesBloc
                            .selectedAccessoriesListStreamController(true);
                        widget.addSalesBloc.accessoriesData?.add(accessories);
                        widget.addSalesBloc.availableAccListStream(true);
                        widget.addSalesBloc.cgstPresentageTextController
                            .clear();
                        //  widget.addSalesBloc.sgstPresentageTextController.clear();
                        widget.addSalesBloc.igstPresentageTextController
                            .clear();
                        widget.addSalesBloc.discountTextController.clear();
                        widget.addSalesBloc.stateIncentiveTextController
                            .clear();
                        widget.addSalesBloc.empsIncentiveTextController.clear();
                        _updateTotalValue();
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

  void _updateTotalValue() {
    double totalUnitValue = 0.0;
    int accessoriesQty =
        widget.addSalesBloc.slectedAccessoriesList?.length ?? 0;
    for (int i = 0; i < accessoriesQty; i++) {
      int qty = int.tryParse(widget.addSalesBloc.accessoriesQty[i] ?? '0') ?? 1;
      double unitRate =
          double.tryParse(widget.addSalesBloc.unitRates[i] ?? '0.0') ?? 0.0;
      totalUnitValue += unitRate * qty;
    }
    widget.addSalesBloc.paymentDetailsStreamController(true);
    double cgstPercent = double.tryParse(
            widget.addSalesBloc.cgstPresentageTextController.text) ??
        0;
    double sgstPercent = double.tryParse(
            widget.addSalesBloc.cgstPresentageTextController.text) ??
        0;
    widget.addSalesBloc.totalValue = totalUnitValue * accessoriesQty;
    widget.addSalesBloc.paymentDetailsStreamController(true);
    widget.addSalesBloc.taxableValue = widget.addSalesBloc.totalValue;
    widget.addSalesBloc.cgstAmount = (totalUnitValue / 100) * cgstPercent;
    widget.addSalesBloc.sgstAmount = (totalUnitValue / 100) * sgstPercent;
    double taxableValue = widget.addSalesBloc.taxableValue ?? 0;
    widget.addSalesBloc.invAmount =
        taxableValue + (widget.addSalesBloc.sgstAmount ?? 0) * 2;
    _updateTotalInvoiceAmount();
    widget.addSalesBloc.paymentDetailsStreamController(true);
    widget.addSalesBloc.gstRadioBtnRefreashStreamController(true);
  }
}
