// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tlbilling/models/parent_response_model.dart';
import 'package:tlbilling/models/purchase_bill_data.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlds_flutter/export.dart';

import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_vehicle_and_accesories/add_vehicle_and_accessories_bloc.dart';
import 'package:toastification/toastification.dart';

class VehiclePurchaseDetails extends StatefulWidget {
  AddVehicleAndAccessoriesBlocImpl addVehicleAndAccessoriesBloc;
  VehiclePurchaseDetails({
    super.key,
    required this.addVehicleAndAccessoriesBloc,
  });

  @override
  State<VehiclePurchaseDetails> createState() => _VehiclePurchaseDetailsState();
}

class _VehiclePurchaseDetailsState extends State<VehiclePurchaseDetails> {
  final _appColors = AppColors();

  @override
  void initState() {
    super.initState();
    widget.addVehicleAndAccessoriesBloc.updateEngineDetailsStream.listen((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget
          .addVehicleAndAccessoriesBloc.engineListScrollController.hasClients) {
        widget.addVehicleAndAccessoriesBloc.engineListScrollController
            .animateTo(
          widget.addVehicleAndAccessoriesBloc.engineListScrollController
              .position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildVehiclePurchaseDetails(),
        _buildDefaultHeight(),
        Visibility(
            visible: widget
                    .addVehicleAndAccessoriesBloc.selectedCategory?.mainSpec !=
                null,
            child: _buildEngineDetails()),
      ],
    );
  }

  Widget _buildVehiclePurchaseDetails() {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.36,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: _appColors.greyColor))),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TldsInputFormField(
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return AppConstants.enterPartNo;
                }
                return null;
              },
              inputFormatters: TlInputFormatters.onlyAllowAlphabetAndNumber,
              focusNode: widget.addVehicleAndAccessoriesBloc.partNoFocusNode,
              labelText: AppConstants.partNo,
              hintText: AppConstants.partNo,
              controller:
                  widget.addVehicleAndAccessoriesBloc.partNumberController,
              onSubmit: (partNumberValue) {
                widget.addVehicleAndAccessoriesBloc.getPurchasePartNoDetails(
                  (statusCode) {
                    if (statusCode == 401 || statusCode == 400) {
                      AppWidgetUtils.buildToast(
                          context,
                          ToastificationType.error,
                          AppConstants.partNoError,
                          Icon(Icons.check_circle_outline_rounded,
                              color: _appColors.errorColor),
                          AppConstants.partNoErrorDes,
                          _appColors.errorLightColor);
                    }
                  },
                ).then((partDetails) {
                  _getAndSetValuesForInputFields(partDetails);
                });
                FocusScope.of(context).requestFocus(
                    widget.addVehicleAndAccessoriesBloc.vehiceNameFocusNode);
              },
            ),
            AppWidgetUtils.buildSizedBox(custHeight: 10),
            TldsInputFormField(
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return AppConstants.enterVehiceName;
                }
                return null;
              },
              // inputFormatters: TlInputFormatters.onlyAllowAlphabetsAndSpaces,
              focusNode:
                  widget.addVehicleAndAccessoriesBloc.vehiceNameFocusNode,
              labelText: AppConstants.vehicleName,
              hintText: AppConstants.vehicleName,
              controller:
                  widget.addVehicleAndAccessoriesBloc.vehicleNameTextController,
              onSubmit: (p0) {
                FocusScope.of(context).requestFocus(
                    widget.addVehicleAndAccessoriesBloc.hsnCodeFocusNode);
              },
            ),
            _buildDefaultHeight(),
            _buildDefaultHeight(),
            _buildHSNCodeAndUniteRate(),
            _buildDefaultHeight(),
          ],
        ),
      ),
    );
  }

  Widget _buildHSNCodeAndUniteRate() {
    return Row(
      children: [
        Expanded(
            child: TldsInputFormField(
          // validator: (String? value) {
          //   if (value == null || value.isEmpty) {
          //     return AppConstants.enterHsnCode;
          //   }
          //   return null;
          // },
          focusNode: widget.addVehicleAndAccessoriesBloc.hsnCodeFocusNode,
          inputFormatters: TlInputFormatters.onlyAllowNumbers,
          labelText: AppConstants.hsnCode,
          hintText: AppConstants.hsnCode,
          controller: widget.addVehicleAndAccessoriesBloc.hsnCodeController,
          onSubmit: (p0) {
            FocusScope.of(context).requestFocus(
                widget.addVehicleAndAccessoriesBloc.unitRateFocusNode);
          },
        )),
        _buildDefaultWidth(),
        Expanded(
            child: TldsInputFormField(
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return AppConstants.enterUnitRate;
            }
            return null;
          },
          inputFormatters: TlInputFormatters.onlyAllowDecimalNumbers,
          focusNode: widget.addVehicleAndAccessoriesBloc.unitRateFocusNode,
          labelText: AppConstants.unitRate,
          hintText: AppConstants.unitRate,
          controller: widget.addVehicleAndAccessoriesBloc.unitRateController,
          onSubmit: (p0) {
            FocusScope.of(context).requestFocus(
                widget.addVehicleAndAccessoriesBloc.engineNoFocusNode);
          },
        )),
      ],
    );
  }

  Widget _buildEngineDetails() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.36,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTextWidget(AppConstants.engineDetails,
                    color: _appColors.primaryColor, fontSize: 20),
                _buildQtyData(),
              ],
            ),
            _buildDefaultHeight(),
            _buildEngineNumberAndFrameNumber(),
            _buildDefaultHeight(),
            _buildEngineDetailsList(),
            _buildDefaultHeight()
          ],
        ),
      ),
    );
  }

  Widget _buildQtyData() {
    return StreamBuilder(
        stream: widget.addVehicleAndAccessoriesBloc.refreshEngineListStream,
        builder: (context, snapshot) {
          return _buildTextWidget(
              'QTY : ${widget.addVehicleAndAccessoriesBloc.engineDetailsList.length}',
              color: _appColors.primaryColor,
              fontSize: 20);
        });
  }

  Widget _buildEngineNumberAndFrameNumber() {
    return Row(
      children: [
        Expanded(
            child: TldsInputFormField(
          inputFormatters: TlInputFormatters.onlyAllowAlphabetAndNumber,
          focusNode: widget.addVehicleAndAccessoriesBloc.engineNoFocusNode,
          labelText: AppConstants.engineNumber,
          hintText: AppConstants.engineNumber,
          controller:
              widget.addVehicleAndAccessoriesBloc.engineNumberController,
          onSubmit: (p0) {
            FocusScope.of(context).requestFocus(
                widget.addVehicleAndAccessoriesBloc.frameNumberFocusNode);
          },
        )),
        _buildDefaultWidth(),
        Expanded(
            child: TldsInputFormField(
                inputFormatters: TlInputFormatters.onlyAllowAlphabetAndNumber,
                focusNode:
                    widget.addVehicleAndAccessoriesBloc.frameNumberFocusNode,
                onSubmit: (p0) {
                  _engineNumberAndFrameNumberOnSubmit();
                },
                labelText: AppConstants.frameNumber,
                hintText: AppConstants.frameNumber,
                controller:
                    widget.addVehicleAndAccessoriesBloc.frameNumberController)),
      ],
    );
  }

  Widget _buildEngineDetailsList() {
    return StreamBuilder(
        stream: widget.addVehicleAndAccessoriesBloc.updateEngineDetailsStream,
        builder: (context, snapshot) {
          return SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 0.2,
            child: ListView.builder(
              controller: widget
                  .addVehicleAndAccessoriesBloc.engineListScrollController,
              itemCount:
                  widget.addVehicleAndAccessoriesBloc.engineDetailsList.length,
              itemBuilder: (context, index) {
                final engineDetails = widget
                    .addVehicleAndAccessoriesBloc.engineDetailsList[index];
                final engineNo = engineDetails.engineNo;
                final frameNo = engineDetails.frameNo;
                return Card(
                    elevation: 0,
                    shape: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: _appColors.cardBorderColor)),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTextWidget(engineNo),
                          _buildTextWidget(frameNo),
                          IconButton(
                              onPressed: () {
                                widget.addVehicleAndAccessoriesBloc
                                    .engineDetailsList
                                    .removeAt(index);
                                widget.addVehicleAndAccessoriesBloc
                                    .engineDetailsStreamController(true);
                                widget.addVehicleAndAccessoriesBloc
                                    .frameNumberController
                                    .clear();
                                widget.addVehicleAndAccessoriesBloc
                                    .engineNumberController
                                    .clear();
                                widget.addVehicleAndAccessoriesBloc
                                    .refreshEngineDetailsListStramController(
                                        true);
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: _appColors.errorColor,
                              )),
                        ],
                      ),
                    ));
              },
            ),
          );
        });
  }

  Widget _buildDefaultWidth() {
    return AppWidgetUtils.buildSizedBox(
        custWidth: MediaQuery.sizeOf(context).width * 0.01);
  }

  Widget _buildDefaultHeight() {
    return AppWidgetUtils.buildSizedBox(
        custHeight: MediaQuery.sizeOf(context).height * 0.02);
  }

  Widget _buildTextWidget(String text,
      {double? fontSize, FontWeight? fontWeight, Color? color}) {
    return Text(
      text,
      style: GoogleFonts.poppins(
          color: color, fontWeight: fontWeight, fontSize: fontSize),
    );
  }

  _engineNumberAndFrameNumberOnSubmit() {
    widget.addVehicleAndAccessoriesBloc.engineDetailsList.add(EngineDetails(
        engineNo:
            widget.addVehicleAndAccessoriesBloc.engineNumberController.text,
        frameNo:
            widget.addVehicleAndAccessoriesBloc.frameNumberController.text));
    widget.addVehicleAndAccessoriesBloc.engineDetailsStreamController(true);
    widget.addVehicleAndAccessoriesBloc
        .refreshEngineDetailsListStramController(true);
    widget.addVehicleAndAccessoriesBloc.frameNumberController.clear();
    widget.addVehicleAndAccessoriesBloc.engineNumberController.clear();
    FocusScope.of(context)
        .requestFocus(widget.addVehicleAndAccessoriesBloc.engineNoFocusNode);
  }

  void _getAndSetValuesForInputFields(ParentResponseModel partDetails) {
    var vehchileById = partDetails.result?.purchaseByPartNo;

    setState(() {
      widget.addVehicleAndAccessoriesBloc.vehicleNameTextController.text =
          vehchileById?.itemName ?? '';

      widget.addVehicleAndAccessoriesBloc.hsnCodeController.text =
          vehchileById.hashCode.toString();

      widget.addVehicleAndAccessoriesBloc.unitRateController.text =
          vehchileById?.unitRate.toString() ?? '';

      // Set GST values
      for (var gstDetail in vehchileById?.gstDetails ?? []) {
        if (gstDetail.gstName == 'CGST' || gstDetail.gstName == 'SGST') {
          widget.addVehicleAndAccessoriesBloc.selectedGstType =
              AppConstants.gstPercent;
          widget.addVehicleAndAccessoriesBloc
              .gstRadioBtnRefreshStreamController(true);
          widget.addVehicleAndAccessoriesBloc.cgstPresentageTextController
              .text = gstDetail.percentage?.toString() ?? '';
          widget.addVehicleAndAccessoriesBloc.sgstPresentageTextController
              .text = gstDetail.percentage?.toString() ?? '';
        } else {
          widget.addVehicleAndAccessoriesBloc.selectedGstType =
              AppConstants.igstPercent;
          widget.addVehicleAndAccessoriesBloc
              .gstRadioBtnRefreshStreamController(true);
          widget.addVehicleAndAccessoriesBloc.igstPresentageTextController
              .text = gstDetail.percentage?.toString() ?? '';
        }
      }

      // Set incentives
      for (var incentive in vehchileById?.incentives ?? []) {
        if (incentive.incentiveName == 'StateIncentive') {
          widget.addVehicleAndAccessoriesBloc.isStateIncChecked = true;

          widget.addVehicleAndAccessoriesBloc
              .incentiveCheckBoxStreamController(true);
          widget.addVehicleAndAccessoriesBloc.stateIncentiveTextController
              .text = incentive.incentiveAmount?.toString() ?? '';
        } else if (incentive.incentiveName == 'EMPS 2024 Incentive') {
          widget.addVehicleAndAccessoriesBloc.isEmpsIncChecked = true;
          widget.addVehicleAndAccessoriesBloc
              .incentiveCheckBoxStreamController(true);
          widget.addVehicleAndAccessoriesBloc.empsIncentiveTextController.text =
              incentive.incentiveAmount?.toString() ?? '';
        }
      }

      // Set taxes
      for (var tax in vehchileById?.taxes ?? []) {
        if (tax.taxName == 'TcsValue') {
          widget.addVehicleAndAccessoriesBloc.isTcsValueChecked = true;
          widget.addVehicleAndAccessoriesBloc
              .taxValueCheckboxStreamController(true);
          widget.addVehicleAndAccessoriesBloc.tcsvalueTextController.text =
              tax.taxAmount?.toString() ?? '';
          widget.addVehicleAndAccessoriesBloc.isTcsValueChecked =
              tax.percentage > 0;
        }
      }

      // Update total values
      widget.addVehicleAndAccessoriesBloc.totalValue =
          vehchileById?.value?.toDouble();
      widget.addVehicleAndAccessoriesBloc.discountValue =
          vehchileById?.discount?.toDouble();
      widget.addVehicleAndAccessoriesBloc.taxableValue =
          vehchileById?.taxableValue?.toDouble();
      widget.addVehicleAndAccessoriesBloc.totalInvAmount =
          vehchileById?.finalInvoiceValue?.toDouble();
    });
  }
}
