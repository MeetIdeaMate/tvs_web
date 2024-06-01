// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlds_flutter/export.dart';

import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_vehicle_and_accesories/add_vehicle_and_accessories_bloc.dart';

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
  final List<String> vehicleAndAccessories = ['Vehicle', 'Accessories'];

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
        _buildEngineDetails(),
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
            _buildPartNumberAndVehicleName(),
            _buildDefaultHeight(),
            _buildVariantAndColor(),
            _buildDefaultHeight(),
            _buildHSNCodeAndUniteRate(),
            _buildDefaultHeight(),
          ],
        ),
      ),
    );
  }

  Widget _buildPartNumberAndVehicleName() {
    return Row(
      children: [
        Expanded(
            child: TldsInputFormField(
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return AppConstants.enterPartNo;
                  }
                  return null;
                },
                inputFormatters:  TlInputFormatters.onlyAllowNumbers,
                focusNode: widget.addVehicleAndAccessoriesBloc.partNoFocusNode,
                labelText: AppConstants.partNo,
                hintText: AppConstants.partNo,
                controller:
                    widget.addVehicleAndAccessoriesBloc.partNumberController)),
        _buildDefaultWidth(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextWidget(AppConstants.vehicleName, fontSize: 14),
            AppWidgetUtils.buildSizedBox(
                custHeight: MediaQuery.sizeOf(context).height * 0.01),
            TldsDropDownButtonFormField(
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return AppConstants.selectVehiceName;
                }
                return null;
              },
              width: MediaQuery.sizeOf(context).width * 0.165,
              hintText: AppConstants.vehicleName,
              dropDownItems: widget.addVehicleAndAccessoriesBloc.selectVendor,
              onChange: (String? newValue) {
                widget.addVehicleAndAccessoriesBloc.vendorDropDownValue =
                    newValue ?? '';
              },
            )
          ],
        ),
      ],
    );
  }

  Widget _buildVariantAndColor() {
    return Row(
      children: [
        Expanded(
            child: TldsInputFormField(
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return AppConstants.enterVarient;
            }
            return null;
          },
          inputFormatters: TlInputFormatters.onlyAllowAlphabetAndNumber,
          focusNode: widget.addVehicleAndAccessoriesBloc.varientFocusNode,
          labelText: AppConstants.variant,
          hintText: AppConstants.variant,
          controller: widget.addVehicleAndAccessoriesBloc.variantController,
          onSubmit: (p0) {
            FocusScope.of(context).requestFocus(
                widget.addVehicleAndAccessoriesBloc.colorFocusNode);
          },
        )),
        _buildDefaultWidth(),
        Expanded(
            child: TldsInputFormField(
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return AppConstants.enterColor;
            }
            return null;
          },
          focusNode: widget.addVehicleAndAccessoriesBloc.colorFocusNode,
          inputFormatters: TlInputFormatters.onlyAllowAlphabets,
          labelText: AppConstants.color,
          hintText: AppConstants.color,
          controller: widget.addVehicleAndAccessoriesBloc.colorController,
          onSubmit: (p0) {
            FocusScope.of(context).requestFocus(
                widget.addVehicleAndAccessoriesBloc.hsnCodeFocusNode);
          },
        )),
      ],
    );
  }

  Widget _buildHSNCodeAndUniteRate() {
    return Row(
      children: [
        Expanded(
            child: TldsInputFormField(
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return AppConstants.enterHsnCode;
            }
            return null;
          },
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
                final engineNo = engineDetails['engineNo'] ?? '';
                final frameNo = engineDetails['frameNo'] ?? '';
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
    final engineAndFrameNoMap = {
      "engineNo":
          widget.addVehicleAndAccessoriesBloc.engineNumberController.text,
      "frameNo": widget.addVehicleAndAccessoriesBloc.frameNumberController.text
    };
    widget.addVehicleAndAccessoriesBloc.engineDetailsList
        .add(engineAndFrameNoMap);
    widget.addVehicleAndAccessoriesBloc.engineDetailsStreamController(true);
    widget.addVehicleAndAccessoriesBloc
        .refreshEngineDetailsListStramController(true);
    widget.addVehicleAndAccessoriesBloc.frameNumberController.clear();
    widget.addVehicleAndAccessoriesBloc.engineNumberController.clear();
    FocusScope.of(context)
        .requestFocus(widget.addVehicleAndAccessoriesBloc.engineNoFocusNode);
  }
}
