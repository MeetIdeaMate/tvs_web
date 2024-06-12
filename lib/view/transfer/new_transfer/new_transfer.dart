import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tlbilling/models/get_model/get_all_stocks_without_pagination.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/transfer/new_transfer/new_transfer_bloc.dart';
import 'package:tlbilling/view/transfer/new_transfer/tranfer_details.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';

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
    _newTransferBloc.selectedVehicleAndAccessories = AppConstants.vehicle;
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
          TransferDetails(newTransferBloc: _newTransferBloc),
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
          _buildVehicleListAndAccessoriesList(),
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

  Widget _buildVehicleListAndAccessoriesList() {
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
    return FutureBuilder(
      future: _newTransferBloc.stockListWithOutPagination(),
      builder: (context, futureSnapshot) {
        _newTransferBloc.vehicleData = futureSnapshot.data;
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: AppWidgetUtils.buildLoading(),
          );
        } else if (futureSnapshot.hasData) {
          if (futureSnapshot.data != null) {
            return StreamBuilder(
              stream: _newTransferBloc.availableVehicleListStreamController,
              builder: (context, streamSnapshot) {
                return Expanded(
                    child: ListView.builder(
                  itemCount: _newTransferBloc.vehicleData?.length,
                  itemBuilder: (context, index) {
                    var vehicle = _newTransferBloc.vehicleData?[index];
                    return _buildAvailableVehicleListCard(vehicle, index);
                  },
                ));
              },
            );
          } else {
            return Center(
              child: SvgPicture.asset(AppConstants.imgNoData),
            );
          }
        }
        return Center(
          child: SvgPicture.asset(AppConstants.imgNoData),
        );
      },
    );
  }

  Widget _buildAvailableVehicleListCard(
      GetAllStocksWithoutPaginationModel? vehicle, int index) {
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
                _buildCustomTextWidget(vehicle?.itemName ?? '',
                    fontSize: 14, fontWeight: FontWeight.w500),
                /*_buildCustomTextWidget('${vehicle[AppConstants.color]}',
                    fontSize: 12, fontWeight: FontWeight.w500),*/
              ],
            ),
            _buildCustomTextWidget(vehicle?.partNo ?? '',
                color: _appColors.greyColor),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCustomTextWidget(
                        vehicle?.mainSpecValue?.engineNo ?? '',
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                    AppWidgetUtils.buildSizedBox(custWidth: 12),
                    _buildCustomTextWidget(
                        vehicle?.mainSpecValue?.frameNo ?? '',
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          GetAllStocksWithoutPaginationModel? selectedVehicle =
                              _newTransferBloc.vehicleData?.removeAt(index);
                          _newTransferBloc.availableVehicleListStream(true);
                          _newTransferBloc.selectedList?.add(selectedVehicle!);
                          _newTransferBloc
                              .selectedVehicleListStreamController(true);
                          _newTransferBloc.selectedItemStream(true);
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
  }

  Widget _buildAvailableAccessoriesList() {
    return StreamBuilder(
      stream: _newTransferBloc.availableAccListStreamController,
      builder: (context, streamSnapshot) {
        return FutureBuilder(
          future: _newTransferBloc.getBranches(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: AppWidgetUtils.buildLoading(),
              );
            } else if (snapshot.hasData) {
              if (_newTransferBloc.accessoriesList.isEmpty) {
                return Center(
                  child: SvgPicture.asset(AppConstants.imgNoData),
                );
              } else {
                return Expanded(
                    child: ListView.builder(
                  itemCount: _newTransferBloc.accessoriesList.length,
                  itemBuilder: (context, index) {
                    var accessoriesData =
                        _newTransferBloc.accessoriesList[index];
                    return Card(
                      elevation: 0,
                      shape: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: _appColors.cardBorderColor),
                          borderRadius: BorderRadius.circular(5)),
                      surfaceTintColor: _appColors.whiteColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 220,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildCustomTextWidget(
                                          accessoriesData[
                                              AppConstants.accessoriesName],
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                      _buildCustomTextWidget(
                                          accessoriesData[
                                              AppConstants.accessoriesNumber],
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: _appColors.liteGrayColor),
                                    ],
                                  ),
                                ),
                                AppWidgetUtils.buildSizedBox(custWidth: 10),
                                SizedBox(
                                  width: 70,
                                  child: _buildCustomTextWidget(
                                      'Qty - ${accessoriesData[AppConstants.quantity]}',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                AppWidgetUtils.buildSizedBox(custWidth: 10),
                                IconButton(
                                    onPressed: () {
                                      _newTransferBloc.accessoriesList
                                          .removeAt(index);
                                      _newTransferBloc
                                          .availableAccListStream(true);
                                      _newTransferBloc.filteredAccessoriesList
                                          .add(accessoriesData);
                                      _newTransferBloc.filteredAccListStream(
                                          accessoriesData);
                                    },
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
            } else {
              return Center(
                child: SvgPicture.asset(AppConstants.imgNoData),
              );
            }
          },
        );
      },
    );
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
          Flexible(
            child: StreamBuilder(
              stream: _newTransferBloc.selectedItemStreamController,
              builder: (context, streamSnapshot) {
                if (_newTransferBloc.selectedList == null) {
                  return Center(
                    child: SvgPicture.asset(AppConstants.imgNoData),
                  );
                } else {
                  return ListView.builder(
                    itemCount: _newTransferBloc.selectedList?.length,
                    itemBuilder: (BuildContext context, int index) {
                      var selectedVehicleData =
                          _newTransferBloc.selectedList?[index];
                      return Card(
                        color: _appColors.whiteColor,
                        elevation: 0,
                        shape: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: _appColors.cardBorderColor),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        surfaceTintColor: _appColors.whiteColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildCustomTextWidget(
                                    selectedVehicleData?.itemName ?? '',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  /*_buildCustomTextWidget(
                                    '${selectedVehicleData[AppConstants.color]}',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),*/
                                ],
                              ),
                              _buildCustomTextWidget(
                                selectedVehicleData?.partNo ?? '',
                                color: _appColors.greyColor,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildCustomTextWidget(
                                        '${selectedVehicleData?.mainSpecValue?.engineNo}',
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      AppWidgetUtils.buildSizedBox(
                                          custWidth: 12),
                                      _buildCustomTextWidget(
                                        '${selectedVehicleData?.mainSpecValue?.frameNo}',
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          _newTransferBloc.selectedList
                                              ?.removeAt(index);
                                          _newTransferBloc
                                              .selectedItemStream(true);
                                          _newTransferBloc.vehicleData
                                              ?.add(selectedVehicleData!);
                                          _newTransferBloc
                                              .availableVehicleListStream(true);
                                        },
                                        icon: SvgPicture.asset(
                                          AppConstants.icFilledClose,
                                          height: 28,
                                          width: 28,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
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
            stream: _newTransferBloc.filteredAccListStreamController,
            builder: (context, snapshot) {
              if (_newTransferBloc.filteredAccessoriesList.isEmpty) {
                return Center(
                  child: SvgPicture.asset(AppConstants.imgNoData),
                );
              } else {
                return ListView.builder(
                  itemCount: _newTransferBloc.filteredAccessoriesList.length,
                  itemBuilder: (context, index) {
                    var filteredAccessoriesListData =
                        _newTransferBloc.filteredAccessoriesList[index];
                    return Card(
                        elevation: 0,
                        shape: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: _appColors.cardBorderColor, width: 1)),
                        surfaceTintColor: _appColors.whiteColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: _buildSelectedAccessoriesCardDetails(
                              filteredAccessoriesListData, index),
                        ));
                  },
                );
              }
            },
          ))
        ],
      ),
    );
  }

  Widget _buildSelectedAccessoriesCardDetails(
      Map<String, dynamic> filteredAccessoriesListData, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomTextWidget(
                filteredAccessoriesListData[AppConstants.accessoriesName],
                fontWeight: FontWeight.w500,
                fontSize: 14),
            _buildCustomTextWidget(
                filteredAccessoriesListData[AppConstants.accessoriesNumber],
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: _appColors.liteGrayColor)
          ],
        ),
        StreamBuilder<int>(
          stream: _newTransferBloc.accessoriesIncrementStream,
          builder: (context, snapshot) {
            if (_newTransferBloc.accessoriesCountController.text.isEmpty) {
              _newTransferBloc.accessoriesCountController.text =
                  filteredAccessoriesListData[AppConstants.quantity].toString();
            }
            return TldsInputFormField(
              width: 150,
              controller: _newTransferBloc.accessoriesCountController,
              prefixIcon: IconButton(
                onPressed: () {
                  int currentValue = int.tryParse(
                          _newTransferBloc.accessoriesCountController.text) ??
                      0;
                  if (currentValue > 0) {
                    filteredAccessoriesListData[AppConstants.quantity] =
                        currentValue--;
                    _newTransferBloc.accessoriesCountController.text =
                        currentValue.toString();
                    _newTransferBloc
                        .accessoriesIncrementStreamController(currentValue);
                  }
                },
                icon: SvgPicture.asset(
                  AppConstants.icFilledMinus,
                  width: 24,
                  height: 24,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  int currentValue = int.tryParse(
                          _newTransferBloc.accessoriesCountController.text) ??
                      0;
                  filteredAccessoriesListData[AppConstants.quantity] =
                      currentValue++;
                  _newTransferBloc.accessoriesCountController.text =
                      currentValue.toString();
                  _newTransferBloc
                      .accessoriesIncrementStreamController(currentValue);
                },
                icon: SvgPicture.asset(
                  AppConstants.icFilledAdd,
                  width: 24,
                  height: 24,
                ),
              ),
            );
          },
        ),
        IconButton(
            onPressed: () {
              _newTransferBloc.filteredAccessoriesList.removeAt(index);
              _newTransferBloc
                  .filteredAccListStream(filteredAccessoriesListData);
              _newTransferBloc.accessoriesList.add(filteredAccessoriesListData);
              _newTransferBloc.availableAccListStream(true);
            },
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

  /*Widget? _buildDefaultWidth({double? width}) {
    return AppWidgetUtils.buildSizedBox(
        custWidth: width ?? MediaQuery.sizeOf(context).width * 0.01);
  }*/

  Widget _buildDefaultHeight({double? height}) {
    return AppWidgetUtils.buildSizedBox(
        custHeight: height ?? MediaQuery.sizeOf(context).height * 0.02);
  }
}
