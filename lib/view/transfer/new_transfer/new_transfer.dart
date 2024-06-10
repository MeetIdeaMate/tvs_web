import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/view/transfer/new_transfer/new_transfer_bloc.dart';
import 'package:tlbilling/view/transfer/new_transfer/tranfer_details.dart';
import 'package:tlds_flutter/export.dart';

class NewTransfer extends StatefulWidget {
  const NewTransfer({super.key});

  @override
  State<NewTransfer> createState() => _NewTransferState();
}

class _NewTransferState extends State<NewTransfer> {
  final _appColors = AppColors();
  final _newTransferBloc = NewTransferBlocImpl();

  @override
  void initState() {
    super.initState();
    _newTransferBloc.selectedVehicleAndAccessories = 'Vehicle';
    _newTransferBloc.selectedVehicleAndAccessoriesStreamController(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.newTransfer),
      ),
      body: Row(
        children: [
          _buildVehicleDetails(),
          const TransferDetails(),
        ],
      ),
    );
  }

  Widget _buildVehicleDetails() {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: _appColors.greyColor)),
      width: MediaQuery.sizeOf(context).width * 0.64,
      child: Row(
        children: [
          _buildVehicleList(),
          StreamBuilder(
            stream: _newTransferBloc.selectedVehicleAndAccessoriesStream,
            builder: (context, snapshot) {
              return _newTransferBloc.selectedVehicleAndAccessories == 'Vehicle'
                  ? _buildSelectedVehicle()
                  : _newTransferBloc.selectedVehicleAndAccessories ==
                          'Accessories'
                      ? _buildSelectedAccessories()
                      : Center(
                          child: _buildCustomTextWidget(
                              AppConstants.selectVehicleOrAccessories),
                        );
            },
          )
        ],
      ),
    );
  }

  Widget _buildVehicleList() {
    return _buildCommonContainer(
      Column(
        children: [
          _buildHeadingAndSegmentedButton(),
          _buildDefaultHeight(),
          _buildVehicleNameAndEngineNumberSearch(),
          _buildDefaultHeight(),
          StreamBuilder(
            stream: _newTransferBloc.changeVehicleAndAccessoriesListStream,
            builder: (context, snapshot) {
              return _newTransferBloc.selectedVehicleAndAccessories == 'Vehicle'
                  ? _buildAvailableVehicleList()
                  : _newTransferBloc.selectedVehicleAndAccessories ==
                          'Accessories'
                      ? _buildAvailableAccessoriesList()
                      : Center(
                          child: _buildCustomTextWidget(
                              AppConstants.selectVehicleOrAccessories),
                        );
            },
          )
        ],
      ),
    );
  }

  Widget _buildHeadingAndSegmentedButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.28,
          child: StreamBuilder(
            stream: _newTransferBloc.selectedVehicleAndAccessoriesStream,
            builder: (context, snapshot) {
              return SegmentedButton(
                multiSelectionEnabled: false,
                segments: List.generate(
                    _newTransferBloc.vehicleAndAccessoriesList.length,
                    (index) => ButtonSegment(
                        value:
                            _newTransferBloc.vehicleAndAccessoriesList[index],
                        label: Text(
                          _newTransferBloc.vehicleAndAccessoriesList[index],
                        ))),
                selected: _newTransferBloc.optionsSet,
                onSelectionChanged: (Set<String> newValue) {
                  _newTransferBloc.optionsSet = newValue;
                  _newTransferBloc.selectedVehicleAndAccessories =
                      _newTransferBloc.optionsSet.first;
                  _newTransferBloc.selectedVehicleAndAccessories ==
                          'Accessories'
                      ? _newTransferBloc.selectedVehicleList.clear()
                      : null;
                  _newTransferBloc
                      .selectedVehicleAndAccessoriesStreamController(true);
                  _newTransferBloc
                      .changeVehicleAndAccessoriesListStreamController(true);
                  _newTransferBloc
                      .selectedVehicleAndAccessoriesListStreamController(true);
                },
                style: ButtonStyle(
                  backgroundColor: _newTransferBloc
                      .changeSegmentedColor(_appColors.segmentedButtonColor),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildVehicleNameAndEngineNumberSearch() {
    return StreamBuilder(
      stream: _newTransferBloc.vehicleAndEngineNumberStream,
      builder: (context, snapshot) {
        final bool isTextEmpty =
            _newTransferBloc.vehicleAndEngineNumberController.text.isEmpty;
        final IconData iconData = isTextEmpty ? Icons.search : Icons.close;
        final Color iconColor =
            isTextEmpty ? _appColors.primaryColor : Colors.red;
        return TldsInputFormField(
          width: MediaQuery.sizeOf(context).width,
          height: 40,
          controller: _newTransferBloc.vehicleAndEngineNumberController,
          hintText: AppConstants.vehicleNameAndEngineNumber,
          suffixIcon: IconButton(
            onPressed: () {
              isTextEmpty
                  ? null
                  : _newTransferBloc.vehicleAndEngineNumberController.clear();
              _newTransferBloc.vehicleAndEngineNumberStreamController(true);
            },
            icon: Icon(
              iconData,
              color: iconColor,
            ),
          ),
          onSubmit: (p0) {
            _newTransferBloc.vehicleAndEngineNumberStreamController(true);
          },
        );
      },
    );
  }

  Widget _buildAvailableVehicleList() {
    return Expanded(
        child: ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
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
                    _buildCustomTextWidget('TVS APACHE - 200',
                        fontSize: 16, fontWeight: FontWeight.w500),
                    _buildCustomTextWidget('Navy Blue',
                        fontSize: 12, fontWeight: FontWeight.w500),
                  ],
                ),
                _buildCustomTextWidget('K619163235',
                    color: _appColors.greyColor),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCustomTextWidget('DG5BR1034324',
                            fontSize: 16, fontWeight: FontWeight.w500),
                        AppWidgetUtils.buildSizedBox(custWidth: 12),
                        _buildCustomTextWidget('MD26CG5BR6345',
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              _newTransferBloc.selectedVehicleList.add('');
                              _newTransferBloc
                                  .selectedVehicleListStreamController(true);
                            },
                            icon: SvgPicture.asset(
                              AppConstants.icFilledAdd,
                              height: 24,
                              width: 24,
                            ))
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    ));
  }

  Widget _buildAvailableAccessoriesList() {
    return Expanded(
        child: ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCustomTextWidget('TVS APACHE - 200',
                            fontSize: 14, fontWeight: FontWeight.w500),
                        _buildCustomTextWidget('Navy Blue',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _appColors.liteGrayColor),
                      ],
                    ),
                    _buildCustomTextWidget('Qty - 20',
                        fontSize: 14, fontWeight: FontWeight.w500),
                    IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          AppConstants.icFilledAdd,
                          width: 24,
                          height: 24,
                        ))
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ));
  }

  Widget _buildSelectedVehicle() {
    return _buildCommonContainer(
      color: _appColors.selectedVehicleAndAccessoriesColor,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomTextWidget(AppConstants.selectedVehicle,
              color: _appColors.primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 19),
          Expanded(
              child: StreamBuilder(
            stream: _newTransferBloc.selectedVehicleListStream,
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: _newTransferBloc.selectedVehicleList.length,
                itemBuilder: (context, index) {
                  return _buildSelectedVehicleCard(index);
                },
              );
            },
          ))
        ],
      ),
    );
  }

  Widget _buildSelectedVehicleCard(int index) {
    return Card(
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
                _buildCustomTextWidget('TVS APACHE - 200',
                    fontSize: 16, fontWeight: FontWeight.w500),
                _buildCustomTextWidget('Navy Blue',
                    fontSize: 12, fontWeight: FontWeight.w500),
              ],
            ),
            _buildCustomTextWidget('K619163235', color: _appColors.greyColor),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCustomTextWidget('DG5BR1034324',
                        fontSize: 16, fontWeight: FontWeight.w500),
                    AppWidgetUtils.buildSizedBox(custWidth: 12),
                    _buildCustomTextWidget('MD26CG5BR6345',
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          _newTransferBloc.selectedVehicleList.removeAt(index);
                          _newTransferBloc
                              .selectedVehicleListStreamController(true);
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

  Widget _buildSelectedAccessories() {
    return _buildCommonContainer(
      color: _appColors.selectedVehicleAndAccessoriesColor,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomTextWidget(AppConstants.selectedAccessories,
              color: _appColors.primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 19),
          Expanded(
              child: StreamBuilder(
            stream: null,
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Card(
                      elevation: 0,
                      shape: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: _appColors.cardBorderColor, width: 1)),
                      surfaceTintColor: _appColors.whiteColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _buildSelectedAccessoriesCardDetails(),
                      ));
                },
              );
            },
          ))
        ],
      ),
    );
  }

  Widget _buildSelectedAccessoriesCardDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomTextWidget('Tool Kit',
                fontWeight: FontWeight.w500, fontSize: 14),
            _buildCustomTextWidget('TK627856',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: _appColors.liteGrayColor)
          ],
        ),
        StreamBuilder(
          stream: _newTransferBloc.accessoriesIncrementStream,
          builder: (context, snapshot) {
            return InputQty(
              decoration: QtyDecorationProps(
                  constraints:
                      const BoxConstraints(minWidth: 150, maxWidth: 150),
                  plusBtn: IconButton(
                      onPressed: () {
                        setState(() {
                          _newTransferBloc.initialValue++;
                          _newTransferBloc
                              .accessoriesIncrementStreamController(true);
                        });
                      },
                      icon: SvgPicture.asset(
                        AppConstants.icFilledAdd,
                        width: 24,
                        height: 24,
                      )),
                  minusBtn: IconButton(
                      onPressed: () {
                        setState(() {
                          _newTransferBloc.initialValue--;
                          _newTransferBloc
                              .accessoriesIncrementStreamController(true);
                        });
                      },
                      icon: SvgPicture.asset(
                        AppConstants.icFilledMinus,
                        width: 24,
                        height: 24,
                      )),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: _appColors.liteBlueColor, width: 2.5),
                      borderRadius: BorderRadius.circular(10))),
              initVal: _newTransferBloc.initialValue,
              steps: 1,
            );
          },
        ),
        IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(AppConstants.icFilledClose))
      ],
    );
  }

  Widget _buildCommonContainer(Widget childWidget, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.30,
        decoration: BoxDecoration(
            border: Border.all(
              color: _appColors.liteGrayColor,
            ),
            color: color,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(padding: const EdgeInsets.all(12), child: childWidget),
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

  Widget? _buildDefaultWidth({double? width}) {
    return AppWidgetUtils.buildSizedBox(
        custWidth: width ?? MediaQuery.sizeOf(context).width * 0.01);
  }

  Widget _buildDefaultHeight({double? height}) {
    return AppWidgetUtils.buildSizedBox(
        custHeight: height ?? MediaQuery.sizeOf(context).height * 0.02);
  }
}
