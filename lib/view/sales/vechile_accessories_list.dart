// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tlbilling/models/get_model/get_all_category_model.dart';
import 'package:tlbilling/models/get_model/get_all_stocks_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/sales/accessories_sales_entry_dialog.dart';
import 'package:tlbilling/view/sales/add_sales_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';

class VehicleAccessoriesList extends StatefulWidget {
  final AddSalesBlocImpl addSalesBloc;
  final Function(List<Widget>)? selectedItems;
  const VehicleAccessoriesList(
      {super.key, required this.addSalesBloc, this.selectedItems});

  @override
  State<VehicleAccessoriesList> createState() => _VehicleAccessoriesListState();
}

class _VehicleAccessoriesListState extends State<VehicleAccessoriesList> {
  final _appColors = AppColors();

  @override
  void initState() {
    super.initState();
    widget.addSalesBloc.selectedVehicleAndAccessories = 'M-Vehicle';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDefaultHeight(),
        _buildHeadingAndSegmentedButton(),
        _buildDefaultHeight(),
        _buildVehicleNameAndEngineNumberSearch(),
        _buildDefaultHeight(),
        _buildVehicleAndAccessoriesList()
      ],
    );
  }

  Widget _buildVehicleAndAccessoriesList() {
    return StreamBuilder(
      stream: widget.addSalesBloc.changeVehicleAndAccessoriesListStream,
      builder: (context, snapshot) {
        return widget.addSalesBloc.selectedVehicleAndAccessories == 'M-Vehicle'
            ? _buildAvailableVehicleList(
                widget.addSalesBloc.selectedVehicleAndAccessories)
            : widget.addSalesBloc.selectedVehicleAndAccessories == 'E-Vehicle'
                ? _buildAvailableVehicleList(
                    widget.addSalesBloc.selectedVehicleAndAccessories)
                : widget.addSalesBloc.selectedVehicleAndAccessories ==
                        'Accessories'
                    ? _buildAvailableAccessoriesList(
                        widget.addSalesBloc.selectedVehicleAndAccessories)
                    : _buildAvailableVehicleList(
                        widget.addSalesBloc.selectedVehicleAndAccessories);
      },
    );
  }

  Widget _buildAvailableVehicleList(String? category) {
    return FutureBuilder(
      future: widget.addSalesBloc.getStockDetails(category: category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text(AppConstants.loading));
        } else if (snapshot.hasError) {
          return const Center(child: Text(AppConstants.errorLoading));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: SvgPicture.asset(AppConstants.imgNoData));
        }
        widget.addSalesBloc.vehicleData = snapshot.data;

        widget.addSalesBloc.vehicleAndEngineNumberStreamController(true);

        return StreamBuilder(
          stream: widget.addSalesBloc.vehicleAndEngineNumberStream,
          builder: (context, snapshot) {
            String searchTerm =
                widget.addSalesBloc.vehicleNoAndEngineNoSearchController.text;
            List<GetAllStockDetails>? filteredVehicleData = widget
                .addSalesBloc.vehicleData
                ?.where((vehicle) =>
                    (vehicle.mainSpecValue?.engineNo
                            ?.toLowerCase()
                            .contains(searchTerm.toLowerCase()) ??
                        false) ||
                    (vehicle.itemName
                            ?.toLowerCase()
                            .contains(searchTerm.toLowerCase()) ??
                        false) ||
                    (vehicle.partNo
                            ?.toLowerCase()
                            .contains(searchTerm.toLowerCase()) ??
                        false))
                .toList();

            if (filteredVehicleData?.isEmpty ?? false) {
              return Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: SvgPicture.asset(AppConstants.imgNoData)),
                  AppWidgetUtils.buildSizedBox(custHeight: 5),
                  Text('No $category')
                ],
              ));
            }

            return Expanded(
              child: ListView.builder(
                itemCount: filteredVehicleData?.length ?? 0,
                itemBuilder: (context, index) {
                  var vehicle = filteredVehicleData?[index];

                  return Card(
                    color: _appColors.whiteColor,
                    elevation: 0,
                    shape: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: _appColors.cardBorderColor),
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
                            ],
                          ),
                          _buildCustomTextWidget(vehicle?.partNo ?? '',
                              color: _appColors.greyColor),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        var selectedVehicle =
                                            filteredVehicleData?[index];
                                        filteredVehicleData?.removeAt(index);
                                        widget.addSalesBloc.vehicleData
                                            ?.remove(selectedVehicle!);
                                        widget.addSalesBloc
                                            .vehicleAndEngineNumberStreamController(
                                                true);
                                        widget.addSalesBloc.selectedVehiclesList
                                            ?.add(selectedVehicle!);
                                        widget.addSalesBloc
                                            .selectedItemStream(true);
                                        widget
                                            .addSalesBloc
                                            .hsnCodeTextController
                                            .text = vehicle?.hsnSacCode ?? '';
                                        widget.addSalesBloc
                                            .gstDetailsStreamController(true);
                                        widget.addSalesBloc
                                            .batteryDetailsRefreshStreamController(
                                                true);
                                        if (filteredVehicleData?.isEmpty ??
                                            false) {
                                          Center(
                                              child: SvgPicture.asset(
                                                  AppConstants.imgNoData));
                                        }
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
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAvailableAccessoriesList(String? selectedVehicleAndAccessories) {
    return FutureBuilder(
      future: widget.addSalesBloc
          .getStockDetails(category: selectedVehicleAndAccessories),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text(AppConstants.loading));
        } else if (snapshot.hasError) {
          return const Center(child: Text(AppConstants.loading));
        } else if (!snapshot.hasData) {
          return Center(child: SvgPicture.asset(AppConstants.imgNoData));
        }
        widget.addSalesBloc.accessoriesData = snapshot.data;
        widget.addSalesBloc.vehicleAndEngineNumberStreamController(true);
        return StreamBuilder(
            stream: widget.addSalesBloc.availableAccListStreamController,
            builder: (context, streamSnapshot) {
              if (widget.addSalesBloc.accessoriesData?.isEmpty ?? false) {
                return Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: SvgPicture.asset(AppConstants.imgNoData)),
                    AppWidgetUtils.buildSizedBox(custHeight: 5),
                    const Text('No Accessories')
                  ],
                ));
              }

              return Expanded(
                  child: ListView.builder(
                itemCount: widget.addSalesBloc.accessoriesData?.length ?? 0,
                itemBuilder: (context, index) {
                  var accessoriesData =
                      widget.addSalesBloc.accessoriesData?[index];
                  widget.addSalesBloc
                          .totalAccessoriesQty[accessoriesData?.stockId ?? ''] =
                      accessoriesData?.quantity ?? 0;
                  //   print(widget.addSalesBloc.accessoriesQty[index]);
                  return Card(
                    color: _appColors.whiteColor,
                    elevation: 0,
                    shape: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: _appColors.cardBorderColor),
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
                                  _buildCustomTextWidget(
                                      accessoriesData?.itemName ?? '',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                  _buildCustomTextWidget(
                                      accessoriesData?.partNo ?? '',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: _appColors.liteGrayColor),
                                ],
                              ),
                              _buildCustomTextWidget(
                                  'Qty - ${widget.addSalesBloc.accessoriesQty[accessoriesData?.stockId] ?? accessoriesData?.quantity}',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                              IconButton(
                                  onPressed: () {
                                    if ((widget.addSalesBloc.accessoriesQty[
                                                accessoriesData?.stockId] ??
                                            accessoriesData?.quantity) ==
                                        accessoriesData?.quantity) {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return AccessoriesSalesEntryDialog(
                                            accessoriesDetails: accessoriesData,
                                            addSalesBloc: widget.addSalesBloc,
                                            selectedItemTndex: index,
                                          );
                                        },
                                      );
                                    }
                                    // GetAllStockDetails? selectedAccessories =
                                    //     widget.addSalesBloc.accessoriesData
                                    //         ?.removeAt(index);

                                    widget.addSalesBloc
                                        .availableAccListStream(true);

                                    // widget.addSalesBloc.slectedAccessoriesList
                                    //     ?.add(selectedAccessories!);
                                    widget.addSalesBloc
                                        .selectedAccessoriesListStreamController(
                                            true);

                                    widget.addSalesBloc
                                        .selectedItemStream(true);
                                    widget.addSalesBloc
                                        .vehicleAndEngineNumberStreamController(
                                            true);
                                    widget.addSalesBloc
                                        .batteryDetailsRefreshStreamController(
                                            true);
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
            });
      },
    );
  }

  Widget _buildHeadingAndSegmentedButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: FutureBuilder<GetAllCategoryListModel?>(
            future: widget.addSalesBloc.getAllCategoryList(),
            builder: (context, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Text(AppConstants.errorLoading));
              } else if (futureSnapshot.hasError ||
                  futureSnapshot.data == null) {
                return const Center(child: Text(AppConstants.errorLoading));
              } else {
                var categoryList = futureSnapshot.data?.category;
                return StreamBuilder(
                  stream:
                      widget.addSalesBloc.selectedVehicleAndAccessoriesStream,
                  builder: (context, snapshot) {
                    var selectedCategory =
                        widget.addSalesBloc.selectedVehicleAndAccessories;
                    return SegmentedButton(
                      selected: {selectedCategory ?? ''},
                      multiSelectionEnabled: false,
                      segments: categoryList!
                          .map((category) => ButtonSegment(
                                value: category.categoryName ?? '',
                                label: Text(category.categoryName ?? ''),
                              ))
                          .toList(),
                      onSelectionChanged: (Set<String> newValue) {
                        var selectedValue = newValue.first;
                        widget.addSalesBloc
                            .batteryDetailsRefreshStreamController(true);

                        widget.addSalesBloc.selectedVehicleAndAccessories =
                            selectedValue;
                        widget.addSalesBloc
                            .batteryDetailsRefreshStreamController(true);
                        widget.addSalesBloc.selectedVehiclesList?.clear();
                        widget.addSalesBloc.slectedAccessoriesList?.clear();
                        widget.addSalesBloc
                            .batteryDetailsRefreshStreamController(true);
                        widget.addSalesBloc.selectedMandatoryAddOns.clear();
                        widget.addSalesBloc
                            .batteryDetailsRefreshStreamController(true);
                        widget.addSalesBloc
                            .selectedVehicleAndAccessoriesListStreamController(
                                true);
                        widget.addSalesBloc
                            .paymentDetailsStreamController(true);

                        widget.addSalesBloc
                            .batteryDetailsRefreshStreamController(true);
                        widget.addSalesBloc.selectedItemStream(true);
                        widget.addSalesBloc
                            .selectedVehiclesListStreamController(true);

                        widget.addSalesBloc.screenChangeStreamController(true);
                        widget.addSalesBloc
                            .selectedVehicleAndAccessoriesStreamController(
                                true);
                        widget.addSalesBloc
                            .changeVehicleAndAccessoriesListStreamController(
                                true);
                        widget.addSalesBloc
                            .selectedVehicleAndAccessoriesListStreamController(
                                true);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            widget.addSalesBloc.changeSegmentedColor(
                          _appColors.segmentedButtonColor,
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
    );
  }

  Widget _buildVehicleNameAndEngineNumberSearch() {
    return Container(
      color: _appColors.whiteColor,
      child: StreamBuilder(
        stream: widget.addSalesBloc.vehicleAndEngineNumberStream,
        builder: (context, snapshot) {
          final bool isTextEmpty = widget
              .addSalesBloc.vehicleNoAndEngineNoSearchController.text.isEmpty;
          final IconData iconData = isTextEmpty ? Icons.search : Icons.close;
          final Color iconColor =
              isTextEmpty ? _appColors.primaryColor : Colors.red;
          widget.addSalesBloc
              .selectedVehicleAndAccessoriesStreamController(true);
          bool showSearchBar =
              widget.addSalesBloc.selectedVehicleAndAccessories == 'Accessories'
                  ? (widget.addSalesBloc.accessoriesData?.isNotEmpty ?? false)
                  : (widget.addSalesBloc.vehicleData?.isNotEmpty ?? false);
          return Visibility(
            visible: showSearchBar,
            child: TldsInputFormField(
              height: 40,
              controller:
                  widget.addSalesBloc.vehicleNoAndEngineNoSearchController,
              hintText: AppConstants.vehicleNameAndEngineNumber,
              suffixIcon: IconButton(
                onPressed: () {
                  if (!isTextEmpty) {
                    widget.addSalesBloc.vehicleNoAndEngineNoSearchController
                        .clear();
                    widget.addSalesBloc
                        .vehicleAndEngineNumberStreamController(true);
                  }
                },
                icon: Icon(
                  iconData,
                  color: iconColor,
                ),
              ),
              onChanged: (value) {
                widget.addSalesBloc
                    .vehicleAndEngineNumberStreamController(true);
              },
            ),
          );
        },
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

  Widget _buildDefaultHeight({double? height}) {
    return AppWidgetUtils.buildSizedBox(
        custHeight: height ?? MediaQuery.sizeOf(context).height * 0.02);
  }
}
