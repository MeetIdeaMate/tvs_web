import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tlbilling/api_service/service_locator.dart';
import 'package:tlbilling/models/get_model/get_all_stocks_model.dart';
import 'package:tlbilling/models/parent_response_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlbilling/view/sales/add_sales_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';

class SelectedSalesData extends StatefulWidget {
  const SelectedSalesData({
    super.key,
  });

  @override
  State<SelectedSalesData> createState() => _SelectedSalesDataState();
}

class _SelectedSalesDataState extends State<SelectedSalesData> {
  final _appColors = AppColors();
  final _addSalesBloc = getIt<AddSalesBlocImpl>();
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
          stream: _addSalesBloc.batteryDetailsRefreshStream,
          builder: (context, snapshot) {
            if (_addSalesBloc.selectedVehiclesList?.isEmpty == true &&
                _addSalesBloc.slectedAccessoriesList?.isEmpty == true) {
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                _buildHeadingText(_addSalesBloc.selectedVehicleAndAccessories ==
                        AppConstants.accessories
                    ? AppConstants.selectedAccessories
                    : _addSalesBloc.selectedVehicleAndAccessories ==
                            AppConstants.eVehicle
                        ? AppConstants.selectEVehicle
                        : AppConstants.selectMVehicle),
                _buildSelectedDataList(),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                if (_addSalesBloc.selectedVehicleAndAccessories !=
                    AppConstants.accessories)
                  _buildHeadingText(AppConstants.mandatoryAddons),
                if (_addSalesBloc.selectedVehicleAndAccessories !=
                    AppConstants.accessories)
                  FutureBuilder<ParentResponseModel>(
                    future: _addSalesBloc.getMandantoryAddOns(),
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
                        List<String> mandatoryAddOns = snapshot
                            .data
                            ?.result
                            ?.getConfigurationModel
                            ?.configuration as List<String>;

                        if (_addSalesBloc.selectedMandatoryAddOns.isEmpty) {
                          for (String addOn in mandatoryAddOns) {
                            _addSalesBloc.selectedMandatoryAddOns[addOn] =
                                AppConstants.yesC;
                          }
                        }
                        if (snapshot.data?.result?.getConfigurationModel
                                ?.inputType ==
                            'YES/NO') {
                          return StreamBuilder<bool>(
                            stream: _addSalesBloc.mandatoryRefereshStream,
                            builder: (context, snapshot) {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: mandatoryAddOns.length,
                                itemBuilder: (context, index) {
                                  String addOn = mandatoryAddOns[index];

                                  return _buildMandatoryAdd(
                                    addOn,
                                    _addSalesBloc
                                            .selectedMandatoryAddOns[addOn] ??
                                        AppConstants.yesC,
                                    (value) {
                                      _addSalesBloc
                                          .mandatoryRefereshStreamController(
                                              true);

                                      _addSalesBloc
                                              .selectedMandatoryAddOns[addOn] =
                                          value ?? '';
                                    },
                                  );
                                },
                              );
                            },
                          );
                        } else if (snapshot.data?.result?.getConfigurationModel
                                ?.inputType ==
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
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: TldsInputFormField(
                                        height: 40,
                                        controller: TextEditingController(),
                                        hintText: componentName,
                                        onChanged: (value) {
                                          _addSalesBloc.selectedMandatoryAddOns[
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
                if (_addSalesBloc.selectedVehicleAndAccessories ==
                    AppConstants.eVehicle)
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
            stream: _addSalesBloc.batteryDetailsRefreshStream,
            builder: (context, snapshot) {
              return FutureBuilder<ParentResponseModel>(
                future: _addSalesBloc.getBatteryDetails(),
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

                    _addSalesBloc.batteryDetailsMap.clear();

                    for (String componentName in eVehicleComponents) {
                      _addSalesBloc.batteryDetailsMap[componentName] = '';
                    }

                    if (snapshot
                            .data?.result?.getConfigurationModel?.inputType ==
                        'YES/NO') {
                      return StreamBuilder<bool>(
                        stream: _addSalesBloc.mandatoryRefereshStream,
                        builder: (context, snapshot) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: eVehicleComponents.length,
                            itemBuilder: (context, index) {
                              String bettery = eVehicleComponents[index];

                              return _buildMandatoryAdd(
                                bettery,
                                _addSalesBloc.batteryDetailsMap[bettery] ??
                                    AppConstants.yesC,
                                (value) {
                                  _addSalesBloc
                                      .mandatoryRefereshStreamController(true);

                                  _addSalesBloc.batteryDetailsMap[bettery] =
                                      value ?? '';
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
                                      _addSalesBloc.batteryDetailsMap[
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
    _addSalesBloc.batteryDetailsMap.forEach((key, value) {});
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
        stream: _addSalesBloc.selectedItemStreamController,
        builder: (context, snapshot) {
          List<GetAllStockDetails>? selectedVehiclesList =
              _addSalesBloc.selectedVehiclesList;

          bool hasVehicles = selectedVehiclesList?.isNotEmpty ?? false;

          return ListView.builder(
            itemCount: hasVehicles ? selectedVehiclesList?.length : 0,
            itemBuilder: (BuildContext context, int index) {
              if (hasVehicles) {
                GetAllStockDetails? vehicle =
                    selectedVehiclesList?[index] as GetAllStockDetails;

                return _buildSelectedVehicleCard(vehicle, index);
              } else {
                return Container();
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
    _addSalesBloc.unitRateControllers.text =
        _addSalesBloc.unitRates[index] ?? '';

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
                      _addSalesBloc.unitRates[index] = value;
                      _buildPaymentCalculation();
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _addSalesBloc.selectedVehiclesList?.removeAt(index);
                    _addSalesBloc.unitRates.remove(index);
                    clear();
                    _addSalesBloc.vehicleAndEngineNumberStreamController(true);
                    _addSalesBloc.batteryDetailsRefreshStreamController(true);
                    _addSalesBloc.selectedItemStream(true);
                    _addSalesBloc.vehicleData?.add(vehicle);
                    _addSalesBloc.availableVehicleListStream(true);

                    _addSalesBloc.selectedCustomer = null;
                    _addSalesBloc.selectedCustomerId = null;
                    _addSalesBloc.selectedCustomerDetailsStreamController(true);

                    _addSalesBloc.cgstPresentageTextController.clear();
                    //  _addSalesBloc.sgstPresentageTextController.clear();
                    _addSalesBloc.igstPresentageTextController.clear();
                    _addSalesBloc.discountTextController.clear();
                    _addSalesBloc.stateIncentiveTextController.clear();
                    _addSalesBloc.empsIncentiveTextController.clear();
                    _addSalesBloc.hsnCodeTextController.clear();
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
    int qty = _addSalesBloc.selectedVehiclesList?.length ?? 0;

    for (int i = 0; i < qty; i++) {
      double unitRate = double.tryParse(_addSalesBloc.unitRates[i]!) ?? 0.0;
      totalUnitValue += unitRate;
    }

    _addSalesBloc.totalValue = totalUnitValue * qty;

    double totalValues = _addSalesBloc.totalValue ?? 0;
    double cgstPercent =
        double.tryParse(_addSalesBloc.cgstPresentageTextController.text) ?? 0;
    double sgstPercent =
        double.tryParse(_addSalesBloc.cgstPresentageTextController.text) ?? 0;

    _addSalesBloc.taxableValue = totalValues;
    _addSalesBloc.cgstAmount = (totalValues / 100) * cgstPercent;
    _addSalesBloc.sgstAmount = (totalValues / 100) * sgstPercent;

    double taxableValue = _addSalesBloc.taxableValue ?? 0;
    _addSalesBloc.invAmount =
        taxableValue + (_addSalesBloc.sgstAmount ?? 0 * 2);
    _updateTotalInvoiceAmount();

    _addSalesBloc.paymentDetailsStreamController(true);
    _addSalesBloc.gstRadioBtnRefreashStreamController(true);
  }

  void _updateTotalInvoiceAmount() {
    double? empsIncValue =
        double.tryParse(_addSalesBloc.empsIncentiveTextController.text) ?? 0.0;
    double? stateIncValue =
        double.tryParse(_addSalesBloc.stateIncentiveTextController.text) ?? 0.0;

    double totalIncentive = empsIncValue + stateIncValue;

    if ((_addSalesBloc.invAmount ?? 0) != -1) {
      _addSalesBloc.totalInvAmount =
          (_addSalesBloc.invAmount ?? 0) - totalIncentive;
    } else {
      _addSalesBloc.totalInvAmount = 0.0;
    }
    double advanceAmt = _addSalesBloc.advanceAmt ?? 0;

    double totalInvAmt = _addSalesBloc.totalInvAmount ?? 0;
    _addSalesBloc.toBePayedAmt = totalInvAmt - advanceAmt;
    _addSalesBloc.toBePayedAmt =
        double.tryParse(_addSalesBloc.toBePayedAmt?.round().toString() ?? '');
    _addSalesBloc.paymentDetailsStreamController(true);
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
    _addSalesBloc.totalValue = 0.0;
    _addSalesBloc.taxableValue = 0.0;
    _addSalesBloc.totalInvAmount = 0.0;
    _addSalesBloc.invAmount = 0.0;
    _addSalesBloc.igstAmount = 0.0;
    _addSalesBloc.cgstAmount = 0.0;
    _addSalesBloc.sgstAmount = 0.0;
    _addSalesBloc.totalUnitRate = 0.0;
    _addSalesBloc.advanceAmt = 0.0;
    _addSalesBloc.toBePayedAmt = 0.0;
    _addSalesBloc.totalQty = 0.0;

    _addSalesBloc.selectedCustomer = null;
    _addSalesBloc.selectedCustomerId = null;

    _addSalesBloc.selectedMandatoryAddOns.clear();

    _addSalesBloc.splitPaymentAmt.clear();
    _addSalesBloc.splitPaymentId.clear();
    _addSalesBloc.paymentName.clear();
    _addSalesBloc.accessoriesQty.clear();

    _addSalesBloc.discountTextController.clear();
    _addSalesBloc.transporterVehicleNumberController.clear();
    _addSalesBloc.vehicleNoAndEngineNoSearchController.clear();
    _addSalesBloc.unitRateControllers.clear();
    _addSalesBloc.hsnCodeTextController.clear();
    _addSalesBloc.betteryNameTextController.clear();
    _addSalesBloc.batteryCapacityTextController.clear();
    _addSalesBloc.empsIncentiveTextController.clear();
    _addSalesBloc.stateIncentiveTextController.clear();
    _addSalesBloc.paidAmountController.clear();
    _addSalesBloc.paymentTypeIdTextController.clear();
    _addSalesBloc.quantityTextController.clear();
    _addSalesBloc.unitRateTextController.clear();

    _addSalesBloc.vehicleAndEngineNumberStreamController(true);

    _addSalesBloc.gstDetailsStreamController(true);
    _addSalesBloc.batteryDetailsRefreshStreamController(true);
    _addSalesBloc.selectedVehicleAndAccessoriesListStreamController(true);
    _addSalesBloc.paymentDetailsStreamController(true);
    _addSalesBloc.screenChangeStreamController(true);
  }
}
