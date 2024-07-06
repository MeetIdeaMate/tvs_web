import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:tlbilling/models/purchase_bill_data.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_vehicle_and_accesories/add_vehicle_and_accessories_bloc.dart';
import 'package:tlds_flutter/export.dart';

class EngineAndFrameNumberEntry extends StatefulWidget {
  final AddVehicleAndAccessoriesBlocImpl addVehicleAndAccessoriesBloc;
  const EngineAndFrameNumberEntry({
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
                onSubmit: (p0) {
                  if (widget.addVehicleAndAccessoriesBloc.engineNumberController
                      .text.isNotEmpty) {
                    _engineNumberAndFrameNumberOnSubmit();
                    _purchaseTableAmountCalculation();
                  }
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
                                final removedDetails = widget
                                    .addVehicleAndAccessoriesBloc
                                    .engineDetailsList
                                    .removeAt(index);
                                enteredEngineNumbers
                                    .remove(removedDetails.engineNo);
                                enteredFrameNumbers
                                    .remove(removedDetails.frameNo);

                                widget.addVehicleAndAccessoriesBloc
                                    .engineDetailsStreamController(true);
                                widget.addVehicleAndAccessoriesBloc
                                    .refreshEngineDetailsListStramController(
                                        true);
                                _purchaseTableAmountCalculation();
                                widget.addVehicleAndAccessoriesBloc
                                    .paymentDetailsStreamController(true);
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

    widget.addVehicleAndAccessoriesBloc.purchaseValidate().then((value) {
      if (isDuplicate || value) {
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

        _purchaseTableAmountCalculation();
        widget.addVehicleAndAccessoriesBloc
            .selectedPurchaseTypeStreamController(true);
      }
    });
  }

  void _purchaseTableAmountCalculation() {
    var qty = double.tryParse(widget
            .addVehicleAndAccessoriesBloc.engineDetailsList.length
            .toString()) ??
        0.0;
    var unitRate = double.tryParse(
            widget.addVehicleAndAccessoriesBloc.unitRateController.text) ??
        0.0;
    var totalValue = qty * unitRate;
    if (widget.addVehicleAndAccessoriesBloc.selectedPurchaseType ==
        'Accessories') {
      totalValue = (int.tryParse(widget
                  .addVehicleAndAccessoriesBloc.quantityController.text) ??
              0) *
          unitRate;
    }
    widget.addVehicleAndAccessoriesBloc.totalValue = totalValue;

    double? discountAmount = double.tryParse(
            widget.addVehicleAndAccessoriesBloc.discountTextController.text) ??
        0;
    totalValue = widget.addVehicleAndAccessoriesBloc.totalValue ?? 0;
    if (discountAmount > totalValue) {
      discountAmount = 0;
      widget.addVehicleAndAccessoriesBloc.discountTextController.text =
          discountAmount.toStringAsFixed(2);
    }
    var taxableValue = totalValue - discountAmount;
    widget.addVehicleAndAccessoriesBloc.taxableValue = taxableValue;
    widget.addVehicleAndAccessoriesBloc.taxableValue =
        (widget.addVehicleAndAccessoriesBloc.totalValue ?? 0) -
            (discountAmount);

    widget.addVehicleAndAccessoriesBloc.totalInvAmount =
        ((widget.addVehicleAndAccessoriesBloc.invAmount ?? 0) -
            (discountAmount));

    var tcsValue = double.tryParse(
            widget.addVehicleAndAccessoriesBloc.tcsvalueTextController.text) ??
        0.0;
    double gstAmount = 0.0;

    if (widget.addVehicleAndAccessoriesBloc.selectedGstType == 'GST %') {
      var cgstPercentage = double.tryParse(widget.addVehicleAndAccessoriesBloc
              .cgstPresentageTextController.text) ??
          0.0;
      var sgstPercentage = double.tryParse(widget.addVehicleAndAccessoriesBloc
              .cgstPresentageTextController.text) ??
          0.0;
      var cgstAmount = taxableValue * (cgstPercentage / 100);
      var sgstAmount = taxableValue * (sgstPercentage / 100);
      widget.addVehicleAndAccessoriesBloc.cgstAmount = cgstAmount;
      widget.addVehicleAndAccessoriesBloc.sgstAmount = sgstAmount;
      gstAmount = cgstAmount + sgstAmount;
    } else if (widget.addVehicleAndAccessoriesBloc.selectedGstType ==
        'IGST %') {
      var igstPercentage = double.tryParse(widget.addVehicleAndAccessoriesBloc
              .igstPresentageTextController.text) ??
          0.0;
      gstAmount = taxableValue * (igstPercentage / 100);
    }
    var invoiceValue = taxableValue + gstAmount;
    widget.addVehicleAndAccessoriesBloc.invAmount = invoiceValue + tcsValue;
    _updateTotalInvoiceAmount();
  }

  void _updateTotalInvoiceAmount() {
    double? empsIncValue = double.tryParse(widget
            .addVehicleAndAccessoriesBloc.empsIncentiveTextController.text) ??
        0.0;
    double? stateIncValue = double.tryParse(widget
            .addVehicleAndAccessoriesBloc.stateIncentiveTextController.text) ??
        0.0;

    double totalIncentive = empsIncValue + stateIncValue;

    double invoiceAmount = widget.addVehicleAndAccessoriesBloc.invAmount ?? 0;

    if (totalIncentive > invoiceAmount) {
      totalIncentive = invoiceAmount;

      if (empsIncValue > invoiceAmount) {
        widget.addVehicleAndAccessoriesBloc.empsIncentiveTextController.text =
            invoiceAmount.toStringAsFixed(2);
        widget.addVehicleAndAccessoriesBloc.stateIncentiveTextController.text =
            '';
      } else {
        widget.addVehicleAndAccessoriesBloc.stateIncentiveTextController.text =
            (invoiceAmount - empsIncValue).toStringAsFixed(2);
      }
    }

    widget.addVehicleAndAccessoriesBloc.totalInvAmount =
        invoiceAmount - totalIncentive;

    widget.addVehicleAndAccessoriesBloc.paymentDetailsStreamController(true);
  }
}
