// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlbilling/models/parent_response_model.dart';
import 'package:tlbilling/models/purchase_bill_data.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_vehicle_and_accesories/add_vehicle_and_accessories_bloc.dart';
import 'package:tlds_flutter/export.dart';

class EngineAndFrameNumberEntry extends StatefulWidget {
  AddVehicleAndAccessoriesBlocImpl addVehicleAndAccessoriesBloc;
  EngineAndFrameNumberEntry({
    super.key,
    required this.addVehicleAndAccessoriesBloc,
  });

  @override
  State<EngineAndFrameNumberEntry> createState() =>
      _EngineAndFrameNumberEntryState();
}

class _EngineAndFrameNumberEntryState extends State<EngineAndFrameNumberEntry> {
  final _appColors = AppColors();
  Set<String> enteredEngineNumbers = {};
  Set<String> enteredFrameNumbers = {};

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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          border:
              Border.symmetric(horizontal: BorderSide(color: _appColors.grey))),
      child: Column(
        children: [
          _buildEngineDetails(),
        ],
      ),
    );
  }

  Widget _buildEngineDetails() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.36,
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
          AppWidgetUtils.buildSizedBox(custHeight: 10),
          _buildEngineDetailsHint(),
          AppWidgetUtils.buildSizedBox(custHeight: 10),
          _buildDefaultHeight(),
          _buildEngineNumberAndFrameNumber(),
          _buildDefaultHeight(),
          _buildEngineDetailsList(),
          _buildDefaultHeight()
        ],
      ),
    );
  }

  Widget _buildQtyData() {
    return StreamBuilder(
        stream: widget.addVehicleAndAccessoriesBloc.refreshEngineListStream,
        builder: (context, snapshot) {
          return Chip(
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            side: BorderSide.none,
            backgroundColor: _appColors.hightlightColor,
            label: Text(
              'QTY : ${widget.addVehicleAndAccessoriesBloc.engineDetailsList.length}',
              style: TextStyle(color: _appColors.primaryColor, fontSize: 14),
            ),
            padding: const EdgeInsets.all(4),
          );
        });
  }

  Widget _buildEngineDetailsHint() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(AppConstants.icInfo),
        AppWidgetUtils.buildSizedBox(custWidth: 8),
        Expanded(
            child: Text(
          AppConstants.partNoHint,
          style: TextStyle(color: _appColors.grey),
        ))
      ],
    );
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
                onSubmit: widget.addVehicleAndAccessoriesBloc
                        .engineNumberController.text.isNotEmpty
                    ? (p0) {
                        if (widget.addVehicleAndAccessoriesBloc
                            .engineNumberController.text.isNotEmpty) {
                          _engineNumberAndFrameNumberOnSubmit();
                          updateTotalValue();
                        }
                      }
                    : null,
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
                                updateTotalValue();

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
                                enteredEngineNumbers.remove(engineNo);
                                enteredFrameNumbers.remove(frameNo);
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

  void _engineNumberAndFrameNumberOnSubmit() {
    final engineNo =
        widget.addVehicleAndAccessoriesBloc.engineNumberController.text;
    final frameNo =
        widget.addVehicleAndAccessoriesBloc.frameNumberController.text;

    bool isDuplicate = false;

    if (enteredEngineNumbers.contains(engineNo)) {
      isDuplicate = true;
    }

    if (enteredFrameNumbers.contains(frameNo)) {
      isDuplicate = true;
    }

    // Check for duplicates
    if (isDuplicate) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: _appColors.whiteColor,
            surfaceTintColor: _appColors.whiteColor,
            contentPadding: const EdgeInsets.all(10),
            title: const Text('Duplicate Entry'),
            content:
                const Text('Engine number or Frame number already exists.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return; // Stop further execution
    }

    // Perform purchase validation
    widget.addVehicleAndAccessoriesBloc.purchaseValidate().then((value) {
      if (value) {
        // If validation fails (duplicate entry detected)
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: _appColors.whiteColor,
              surfaceTintColor: _appColors.whiteColor,
              contentPadding: const EdgeInsets.all(10),
              title: const Text('Duplicate Entry'),
              content:
                  const Text('Engine number or Frame number already exists.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        // If validation succeeds (no duplicate), proceed with adding to list and clearing fields
        widget.addVehicleAndAccessoriesBloc.engineDetailsList.add(
          EngineDetails(engineNo: engineNo, frameNo: frameNo),
        );
        widget.addVehicleAndAccessoriesBloc.engineDetailsStreamController(true);
        widget.addVehicleAndAccessoriesBloc
            .refreshEngineDetailsListStramController(true);
        widget.addVehicleAndAccessoriesBloc.frameNumberController.clear();
        widget.addVehicleAndAccessoriesBloc.engineNumberController.clear();
        FocusScope.of(context).requestFocus(
            widget.addVehicleAndAccessoriesBloc.engineNoFocusNode);

        enteredEngineNumbers.add(engineNo);
        enteredFrameNumbers.add(frameNo);
        updateTotalValue();
      }
    });
  }
  // void _getAndSetValuesForInputFields(ParentResponseModel partDetails) {
  //   var vehchileById = partDetails.result?.purchaseByPartNo;

  //   setState(() {
  //     widget.addVehicleAndAccessoriesBloc.vehicleNameTextController.text =
  //         vehchileById?.itemName ?? '';

  //     widget.addVehicleAndAccessoriesBloc.unitRateController.text =
  //         vehchileById?.unitRate.toString() ?? '';

  //     // Set GST values
  //     for (var gstDetail in vehchileById?.gstDetails ?? []) {
  //       if (gstDetail.gstName == 'CGST' || gstDetail.gstName == 'SGST') {
  //         widget.addVehicleAndAccessoriesBloc.selectedGstType =
  //             AppConstants.gstPercent;
  //         widget.addVehicleAndAccessoriesBloc
  //             .gstRadioBtnRefreshStreamController(true);
  //         widget.addVehicleAndAccessoriesBloc.cgstPresentageTextController
  //             .text = gstDetail.percentage?.toString() ?? '';
  //         widget.addVehicleAndAccessoriesBloc.sgstPresentageTextController
  //             .text = gstDetail.percentage?.toString() ?? '';
  //       } else {
  //         widget.addVehicleAndAccessoriesBloc.selectedGstType =
  //             AppConstants.igstPercent;
  //         widget.addVehicleAndAccessoriesBloc
  //             .gstRadioBtnRefreshStreamController(true);
  //         widget.addVehicleAndAccessoriesBloc.igstPresentageTextController
  //             .text = gstDetail.percentage?.toString() ?? '';
  //       }
  //     }

  //     // Set incentives
  //     for (var incentive in vehchileById?.incentives ?? []) {
  //       if (incentive.incentiveName == 'StateIncentive') {
  //         widget.addVehicleAndAccessoriesBloc.isStateIncChecked = true;

  //         widget.addVehicleAndAccessoriesBloc
  //             .incentiveCheckBoxStreamController(true);
  //         widget.addVehicleAndAccessoriesBloc.stateIncentiveTextController
  //             .text = incentive.incentiveAmount?.toString() ?? '';
  //       } else if (incentive.incentiveName == 'EMPS 2024 Incentive') {
  //         widget.addVehicleAndAccessoriesBloc.isEmpsIncChecked = true;
  //         widget.addVehicleAndAccessoriesBloc
  //             .incentiveCheckBoxStreamController(true);
  //         widget.addVehicleAndAccessoriesBloc.empsIncentiveTextController.text =
  //             incentive.incentiveAmount?.toString() ?? '';
  //       }
  //     }

  //     // Set taxes
  //     for (var tax in vehchileById?.taxes ?? []) {
  //       if (tax.taxName == 'TcsValue') {
  //         widget.addVehicleAndAccessoriesBloc.isTcsValueChecked = true;
  //         widget.addVehicleAndAccessoriesBloc
  //             .taxValueCheckboxStreamController(true);
  //         widget.addVehicleAndAccessoriesBloc.tcsvalueTextController.text =
  //             tax.taxAmount?.toString() ?? '';
  //         widget.addVehicleAndAccessoriesBloc.isTcsValueChecked =
  //             tax.percentage > 0;
  //       }
  //     }

  //     // Update total values
  //     widget.addVehicleAndAccessoriesBloc.totalValue =
  //         vehchileById?.value?.toDouble();
  //     widget.addVehicleAndAccessoriesBloc.discountValue =
  //         vehchileById?.discount?.toDouble();
  //     widget.addVehicleAndAccessoriesBloc.taxableValue =
  //         vehchileById?.taxableValue?.toDouble();
  //     widget.addVehicleAndAccessoriesBloc.totalInvAmount =
  //         vehchileById?.finalInvoiceValue?.toDouble();
  //   });
  // }

  void updateTotalValue() {
    double? unitRate = double.tryParse(
        widget.addVehicleAndAccessoriesBloc.unitRateController.text);
    double totalQty =
        widget.addVehicleAndAccessoriesBloc.engineDetailsList.length.toDouble();
    widget.addVehicleAndAccessoriesBloc.totalValue = (unitRate ?? 0) * totalQty;
    widget.addVehicleAndAccessoriesBloc.paymentDetailsStreamController(true);
    widget.addVehicleAndAccessoriesBloc.taxableValue =
        (unitRate ?? 0) * totalQty;
    widget.addVehicleAndAccessoriesBloc.invAmount = (unitRate ?? 0) * totalQty;
    widget.addVehicleAndAccessoriesBloc.totalInvAmount =
        (unitRate ?? 0) * totalQty;
  }
}
