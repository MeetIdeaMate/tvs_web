import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tlbilling/models/get_model/get_all_stocks_model.dart';
import 'package:tlbilling/models/parent_response_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlbilling/view/sales/add_sales_bloc.dart';
import 'package:tlbilling/view/sales/customer_details.dart';
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
  bool isEVehicle = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: StreamBuilder<bool>(
          stream: widget.addSalesBloc.batteryDetailsRefreshStream,
          builder: (context, snapshot) {
            if (widget.addSalesBloc.selectedVehiclesList?.isEmpty == true &&
                widget.addSalesBloc.slectedAccessoriesList?.isEmpty == true) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppConstants.imgNoData),
                  AppWidgetUtils.buildSizedBox(custHeight: 5),
                  const Text('Select Vehicle or Accesories'),
                ],
              );
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppWidgetUtils.buildSizedBox(custHeight: 10),
                  CustomerDetails(
                    addSalesBloc: widget.addSalesBloc,
                  ),
                  AppWidgetUtils.buildSizedBox(custHeight: 10),
                  _buildHeadingText(
                      widget.addSalesBloc.selectedVehicleAndAccessories ==
                              AppConstants.accessories
                          ? AppConstants.selectedAccessories
                          : widget.addSalesBloc.selectedVehicleAndAccessories ==
                                  AppConstants.eVehicle
                              ? AppConstants.selectEVehicle
                              : AppConstants.selectMVehicle),
                  _buildSelectedDataList(),
                  AppWidgetUtils.buildSizedBox(custHeight: 10),
                  if (widget.addSalesBloc.selectedVehicleAndAccessories !=
                      AppConstants.accessories)
                    _buildHeadingText(AppConstants.mandatoryAddons),
                  if (widget.addSalesBloc.selectedVehicleAndAccessories !=
                      AppConstants.accessories)
                    FutureBuilder<ParentResponseModel>(
                      future: widget.addSalesBloc.getMandantoryAddOns(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: Text(AppConstants.loading));
                        } else if (snapshot.hasError) {
                          return const Text(AppConstants.errorLoading);
                        } else if (!snapshot.hasData ||
                            (snapshot.data?.result?.getConfigurationModel
                                    ?.configuration as List<String>)
                                .isEmpty) {
                          return const Text(AppConstants.noData);
                        } else {
                          List<String> mandatoryAddOns = snapshot
                              .data
                              ?.result
                              ?.getConfigurationModel
                              ?.configuration as List<String>;

                          if (widget
                              .addSalesBloc.selectedMandatoryAddOns.isEmpty) {
                            for (String addOn in mandatoryAddOns) {
                              widget.addSalesBloc
                                      .selectedMandatoryAddOns[addOn] =
                                  AppConstants.yesC;
                            }
                          }
                          if (snapshot.data?.result?.getConfigurationModel
                                  ?.inputType ==
                              'YES/NO') {
                            return StreamBuilder<bool>(
                              stream:
                                  widget.addSalesBloc.mandatoryRefereshStream,
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
                                          AppConstants.yesC,
                                      (value) {
                                        widget.addSalesBloc
                                            .mandatoryRefereshStreamController(
                                                true);

                                        widget.addSalesBloc
                                                .selectedMandatoryAddOns[
                                            addOn] = value ?? '';
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          } else if (snapshot.data?.result
                                  ?.getConfigurationModel?.inputType ==
                              'INPUT') {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: mandatoryAddOns.length,
                              itemBuilder: (context, index) {
                                String componentName = mandatoryAddOns[index];
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(componentName),
                                    const Spacer(),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: TldsInputFormField(
                                          height: 40,
                                          controller: TextEditingController(),
                                          hintText: componentName,
                                          onChanged: (value) {
                                            widget.addSalesBloc
                                                    .selectedMandatoryAddOns[
                                                componentName] = value;

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

                          return const Text(
                              'Give Correct input Type YES/NO or INPUT');
                        }
                      },
                    ),
                  const SizedBox(height: 15),
                  if (widget.addSalesBloc.selectedVehicleAndAccessories ==
                      AppConstants.eVehicle)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeadingText(AppConstants.eVehicleConponents),
                        _buildBatteryDetails(),
                      ],
                    ),
                ],
              ),
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
              return FutureBuilder<ParentResponseModel>(
                future: widget.addSalesBloc.getBatteryDetails(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Text(AppConstants.loading));
                  } else if (snapshot.hasError) {
                    return const Text(AppConstants.errorLoading);
                  } else if (!snapshot.hasData ||
                      (snapshot.data?.result?.getConfigurationModel
                              ?.configuration as List<String>)
                          .isEmpty) {
                    return const Text(AppConstants.noData);
                  } else {
                    List<String> eVehicleComponents = snapshot.data?.result
                        ?.getConfigurationModel?.configuration as List<String>;

                    widget.addSalesBloc.batteryDetailsMap.clear();

                    for (String componentName in eVehicleComponents) {
                      widget.addSalesBloc.batteryDetailsMap[componentName] = '';
                    }

                    if (snapshot
                            .data?.result?.getConfigurationModel?.inputType ==
                        'YES/NO') {
                      return StreamBuilder<bool>(
                        stream: widget.addSalesBloc.mandatoryRefereshStream,
                        builder: (context, snapshot) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: eVehicleComponents.length,
                            itemBuilder: (context, index) {
                              String bettery = eVehicleComponents[index];

                              return _buildMandatoryAdd(
                                bettery,
                                widget.addSalesBloc
                                        .batteryDetailsMap[bettery] ??
                                    AppConstants.yesC,
                                (value) {
                                  widget.addSalesBloc
                                      .mandatoryRefereshStreamController(true);

                                  widget.addSalesBloc
                                      .batteryDetailsMap[bettery] = value ?? '';
                                },
                              );
                            },
                          );
                        },
                      );
                    } else if (snapshot
                            .data?.result?.getConfigurationModel?.inputType ==
                        'INPUT') {
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
                                      widget.addSalesBloc.batteryDetailsMap[
                                          componentName] = value;

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
                    return const Text('no');
                  }
                },
              );
            }),
      ],
    );
  }

  void printBatteryDetails() {
    widget.addSalesBloc.batteryDetailsMap.forEach((key, value) {});
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
    return StreamBuilder(
      stream: widget.addSalesBloc.selectedItemStreamController,
      builder: (context, snapshot) {
        List<GetAllStockDetails>? selectedVehiclesList =
            widget.addSalesBloc.selectedVehiclesList;
        bool hasVehicles =
            selectedVehiclesList != null && selectedVehiclesList.isNotEmpty;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: hasVehicles ? selectedVehiclesList.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  if (hasVehicles) {
                    GetAllStockDetails? vehicle = selectedVehiclesList[index];
                    Map<String, dynamic>? addOnsMap = vehicle.addOns?.toJson();
                    if (addOnsMap != null && addOnsMap.isNotEmpty) {
                      addOnsMap.forEach((key, value) {
                        double initialValue = value != null
                            ? double.tryParse(value.toString()) ?? 0
                            : 0;
                        if (!widget.addSalesBloc.previousValuesAddOns
                            .containsKey(key)) {
                          widget.addSalesBloc.previousValuesAddOns[key] =
                              initialValue;
                        }
                        widget.addSalesBloc.currentTotalAddons += initialValue;
                      });
                      widget.addSalesBloc
                          .totalAddOnsSumUpdateStreamController(true);
                    }
                    return StreamBuilder(
                        stream: widget.addSalesBloc.totalAddOnsSumController,
                        builder: (context, snapshot) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSelectedVehicleCard(vehicle, index),
                              AppWidgetUtils.buildSizedBox(custHeight: 15),
                              AppWidgetUtils.buildHeaderText('Add Ons'),
                              if (addOnsMap != null && addOnsMap.isNotEmpty)
                                Column(
                                  children: addOnsMap.entries.map((entry) {
                                    String key = entry.key;
                                    dynamic value = entry.value;
                                    TextEditingController controller =
                                        TextEditingController(
                                            text: value?.toString() ?? '');
                                    return ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5),
                                      title: Text(
                                        key,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: TldsInputFormField(
                                        width: 100,
                                        height: 40,
                                        controller: controller,
                                        onChanged: (newValue) {
                                          double? newNumericValue =
                                              double.tryParse(newValue);
                                          if (newNumericValue != null) {
                                            updateTotalAddOnsSum(addOnsMap, key,
                                                newNumericValue);
                                          } else {
                                            updateTotalAddOnsSum(
                                                addOnsMap, key, 0);
                                          }

                                          widget.addSalesBloc
                                              .totalAddOnsSumUpdateStreamController(
                                                  true);
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                              AppWidgetUtils.buildSizedBox(custHeight: 15),
                              StreamBuilder<bool>(
                                stream: widget.addSalesBloc
                                    .totalAddOnsSumUpdateController,
                                builder: (context, totalSnapshot) {
                                  return Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        color: _appColors.bgHighlightColor),
                                    child: Text(
                                      'Total Add-Ons: ₹ ${widget.addSalesBloc.currentTotalAddons.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        });
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void updateTotalAddOnsSum(
      Map<String, dynamic> addOnsMap, String key, double newValue) {
    double oldValue = widget.addSalesBloc.previousValuesAddOns[key] ?? 0;
    widget.addSalesBloc.previousValuesAddOns[key] = newValue;
    double newTotal = widget.addSalesBloc.previousValuesAddOns.entries
        .map((entry) => entry.value)
        .fold(0, (previousValue, element) => previousValue + element);
    widget.addSalesBloc.currentTotalAddons = newTotal;
    addOnsMap[key] = newValue;
    _buildPaymentCalculation();
    widget.addSalesBloc.totalAddOnsSumStreamController(newTotal);
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
              value: AppConstants.yesC,
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
              value: AppConstants.noC,
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
                    clear();
                    widget.addSalesBloc
                        .vehicleAndEngineNumberStreamController(true);
                    widget.addSalesBloc
                        .batteryDetailsRefreshStreamController(true);
                    widget.addSalesBloc.selectedItemStream(true);
                    widget.addSalesBloc.vehicleData?.add(vehicle);
                    widget.addSalesBloc.availableVehicleListStream(true);
                    widget.addSalesBloc.selectedCustomer = null;
                    widget.addSalesBloc.selectedCustomerId = null;
                    widget.addSalesBloc
                        .selectedCustomerDetailsStreamController(true);
                    widget.addSalesBloc.cgstPresentageTextController.clear();
                    //  widget.addSalesBloc.sgstPresentageTextController.clear();
                    widget.addSalesBloc.igstPresentageTextController.clear();
                    widget.addSalesBloc.discountTextController.clear();
                    widget.addSalesBloc.stateIncentiveTextController.clear();
                    widget.addSalesBloc.empsIncentiveTextController.clear();
                    widget.addSalesBloc.hsnCodeTextController.clear();
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
    double totalAddOnsAmount = widget.addSalesBloc.currentTotalAddons;

    int qty = widget.addSalesBloc.selectedVehiclesList?.length ?? 0;

    for (int i = 0; i < qty; i++) {
      double unitRate =
          double.tryParse(widget.addSalesBloc.unitRates[i]!) ?? 0.0;
      totalUnitValue += unitRate;
    }

    widget.addSalesBloc.totalValue = totalUnitValue * qty + totalAddOnsAmount;

    double totalValues = widget.addSalesBloc.totalValue ?? 0;
    double discount =
        double.tryParse(widget.addSalesBloc.discountTextController.text) ?? 0;
    if (discount >= totalValues || discount == 0) {
      widget.addSalesBloc.discountTextController.clear();
    }
    widget.addSalesBloc.taxableValue = totalValues - discount;
    double taxableValue = widget.addSalesBloc.taxableValue ?? 0;

    double cgstPercent = double.tryParse(
            widget.addSalesBloc.cgstPresentageTextController.text) ??
        0;
    double sgstPercent = double.tryParse(
            widget.addSalesBloc.cgstPresentageTextController.text) ??
        0;
    double igstPercent = double.tryParse(
            widget.addSalesBloc.igstPresentageTextController.text) ??
        0;

    if (widget.addSalesBloc.selectedGstType == 'GST %') {
      widget.addSalesBloc.cgstAmount = (taxableValue / 100) * cgstPercent;
      widget.addSalesBloc.sgstAmount = (taxableValue / 100) * sgstPercent;
      double gstAmt = (widget.addSalesBloc.cgstAmount ?? 0) +
          (widget.addSalesBloc.sgstAmount ?? 0);
      widget.addSalesBloc.invAmount = taxableValue + gstAmt;
      widget.addSalesBloc.totalInvAmount = widget.addSalesBloc.invAmount;
    }

    if (widget.addSalesBloc.selectedGstType == 'IGST %') {
      widget.addSalesBloc.igstAmount = (taxableValue / 100) * igstPercent;
      widget.addSalesBloc.invAmount =
          taxableValue + (widget.addSalesBloc.igstAmount ?? 0);
      widget.addSalesBloc.totalInvAmount = widget.addSalesBloc.invAmount;
    }
    _updateTotalInvoiceAmount();

    _updateOtherAmountDetails();

    widget.addSalesBloc.paymentDetailsStreamController(true);
    widget.addSalesBloc.gstRadioBtnRefreashStreamController(true);
  }

  void _updateOtherAmountDetails() {
    double rtoAmount =
        double.tryParse(widget.addSalesBloc.rtoAmountTextController.text) ?? 0;
    double manditoryFittingAmount = double.tryParse(
            widget.addSalesBloc.manditoryFittingAmountTextControler.text) ??
        0;
    double optionalAcc = double.tryParse(
            widget.addSalesBloc.optionlFittingAmountTextController.text) ??
        0;
    double otherAmount =
        double.tryParse(widget.addSalesBloc.otherAmountTextController.text) ??
            0;
    double tobepayedAmount = widget.addSalesBloc.exShowrRomPrice ?? 0;

    // Sum all the amounts including tobepayedAmount
    double totalAmount = rtoAmount +
        manditoryFittingAmount +
        optionalAcc +
        otherAmount +
        tobepayedAmount;

    widget.addSalesBloc.toBePayed = totalAmount;
    widget.addSalesBloc.paymentDetailsStreamController(true);
    // Now you can use totalAmount as needed
    print('Total Amount: $totalAmount');
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
    widget.addSalesBloc.exShowrRomPrice = totalInvAmt - advanceAmt;
    widget.addSalesBloc.exShowrRomPrice = double.tryParse(
        widget.addSalesBloc.exShowrRomPrice?.round().toString() ?? '');

    widget.addSalesBloc.toBePayed = double.tryParse(
        widget.addSalesBloc.exShowrRomPrice?.round().toString() ?? '');
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

  void clear() {
    widget.addSalesBloc.totalValue = 0.0;
    widget.addSalesBloc.taxableValue = 0.0;
    widget.addSalesBloc.totalInvAmount = 0.0;
    widget.addSalesBloc.invAmount = 0.0;
    widget.addSalesBloc.igstAmount = 0.0;
    widget.addSalesBloc.cgstAmount = 0.0;
    widget.addSalesBloc.sgstAmount = 0.0;
    widget.addSalesBloc.totalUnitRate = 0.0;
    widget.addSalesBloc.advanceAmt = 0.0;
    widget.addSalesBloc.exShowrRomPrice = 0.0;
    widget.addSalesBloc.totalQty = 0.0;
    widget.addSalesBloc.totalDiscount = 0.0;

    widget.addSalesBloc.selectedCustomer = null;
    widget.addSalesBloc.selectedCustomerId = null;

    widget.addSalesBloc.selectedMandatoryAddOns.clear();

    widget.addSalesBloc.splitPaymentAmt.clear();
    widget.addSalesBloc.splitPaymentId.clear();
    widget.addSalesBloc.paymentName.clear();
    widget.addSalesBloc.accessoriesQty.clear();

    widget.addSalesBloc.discountTextController.clear();
    widget.addSalesBloc.transporterVehicleNumberController.clear();
    widget.addSalesBloc.vehicleNoAndEngineNoSearchController.clear();
    widget.addSalesBloc.unitRateControllers.clear();
    widget.addSalesBloc.hsnCodeTextController.clear();
    widget.addSalesBloc.betteryNameTextController.clear();
    widget.addSalesBloc.batteryCapacityTextController.clear();
    widget.addSalesBloc.empsIncentiveTextController.clear();
    widget.addSalesBloc.stateIncentiveTextController.clear();
    widget.addSalesBloc.paidAmountController.clear();
    widget.addSalesBloc.paymentTypeIdTextController.clear();
    widget.addSalesBloc.quantityTextController.clear();
    widget.addSalesBloc.unitRateTextController.clear();
    widget.addSalesBloc.discountTextController.clear();

    widget.addSalesBloc.vehicleAndEngineNumberStreamController(true);

    widget.addSalesBloc.gstDetailsStreamController(true);
    widget.addSalesBloc.batteryDetailsRefreshStreamController(true);
    widget.addSalesBloc.selectedVehicleAndAccessoriesListStreamController(true);
    widget.addSalesBloc.paymentDetailsStreamController(true);
    widget.addSalesBloc.screenChangeStreamController(true);
  }
}
