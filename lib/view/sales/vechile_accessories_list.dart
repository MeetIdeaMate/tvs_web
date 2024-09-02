// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tlbilling/api_service/service_locator.dart';
import 'package:tlbilling/models/get_model/get_all_category_model.dart';
import 'package:tlbilling/models/get_model/get_all_stocks_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/sales/accessories_sales_entry_dialog.dart';
import 'package:tlbilling/view/sales/add_sales_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';

class VehicleAccessoriesList extends StatefulWidget {
  final Function(List<Widget>)? selectedItems;
  const VehicleAccessoriesList({super.key, this.selectedItems});

  @override
  State<VehicleAccessoriesList> createState() => _VehicleAccessoriesListState();
}

class _VehicleAccessoriesListState extends State<VehicleAccessoriesList> {
  final _appColors = AppColors();
  final _addSalesblocImpl = getIt<AddSalesBlocImpl>();

  @override
  void initState() {
    super.initState();
    _addSalesblocImpl.selectedVehicleAndAccessories = 'M-Vehicle';
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
      stream: _addSalesblocImpl.changeVehicleAndAccessoriesListStream,
      builder: (context, snapshot) {
        return _addSalesblocImpl.selectedVehicleAndAccessories == 'M-Vehicle'
            ? _buildAvailableVehicleList(
                _addSalesblocImpl.selectedVehicleAndAccessories)
            : _addSalesblocImpl.selectedVehicleAndAccessories == 'E-Vehicle'
                ? _buildAvailableVehicleList(
                    _addSalesblocImpl.selectedVehicleAndAccessories)
                : _addSalesblocImpl.selectedVehicleAndAccessories ==
                        'Accessories'
                    ? _buildAvailableAccessoriesList(
                        _addSalesblocImpl.selectedVehicleAndAccessories)
                    : _buildAvailableVehicleList(
                        _addSalesblocImpl.selectedVehicleAndAccessories);
      },
    );
  }

  Widget _buildAvailableVehicleList(String? category) {
    return FutureBuilder(
      future: _addSalesblocImpl.getStockDetails(category: category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text(AppConstants.loading));
        } else if (snapshot.hasError) {
          return const Center(child: Text(AppConstants.errorLoading));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: SvgPicture.asset(AppConstants.imgNoData));
        }
        _addSalesblocImpl.vehicleData = snapshot.data;

        _addSalesblocImpl.vehicleAndEngineNumberStreamController(true);

        return StreamBuilder(
          stream: _addSalesblocImpl.vehicleAndEngineNumberStream,
          builder: (context, snapshot) {
            String searchTerm =
                _addSalesblocImpl.vehicleNoAndEngineNoSearchController.text;
            List<GetAllStockDetails>? filteredVehicleData = _addSalesblocImpl
                .vehicleData
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
                                        _addSalesblocImpl.vehicleData
                                            ?.remove(selectedVehicle!);
                                        if (_addSalesblocImpl
                                                    .selectedVehiclesList !=
                                                null &&
                                            _addSalesblocImpl
                                                .selectedVehiclesList!
                                                .isNotEmpty) {
                                          // Replace the selected vehicle
                                          _addSalesblocImpl.vehicleData?.add(
                                              _addSalesblocImpl
                                                  .selectedVehiclesList!.first);
                                          _addSalesblocImpl.selectedVehiclesList
                                              ?.clear();
                                        }
                                        _addSalesblocImpl.selectedVehiclesList
                                            ?.add(selectedVehicle!);
                                        _addSalesblocImpl
                                            .vehicleAndEngineNumberStreamController(
                                                true);
                                        _addSalesblocImpl
                                            .selectedItemStream(true);
                                        _addSalesblocImpl.hsnCodeTextController
                                            .text = vehicle?.hsnSacCode ?? '';
                                        _addSalesblocImpl
                                            .gstDetailsStreamController(true);
                                        _addSalesblocImpl
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
      future: _addSalesblocImpl.getStockDetails(
          category: selectedVehicleAndAccessories),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text(AppConstants.loading));
        } else if (snapshot.hasError) {
          return const Center(child: Text(AppConstants.errorLoading));
        } else if (!snapshot.hasData) {
          return Center(child: SvgPicture.asset(AppConstants.imgNoData));
        }
        _addSalesblocImpl.accessoriesData = snapshot.data;
        _addSalesblocImpl.vehicleAndEngineNumberStreamController(true);
        return StreamBuilder(
            stream: _addSalesblocImpl.availableAccListStreamController,
            builder: (context, streamSnapshot) {
              if (_addSalesblocImpl.accessoriesData?.isEmpty ?? false) {
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
              String searchTerm =
                  _addSalesblocImpl.vehicleNoAndEngineNoSearchController.text;
              List<GetAllStockDetails>? filteredAccessoriesData =
                  _addSalesblocImpl.accessoriesData
                      ?.where((accessory) =>
                          (accessory.itemName
                                  ?.toLowerCase()
                                  .contains(searchTerm.toLowerCase()) ??
                              false) ||
                          (accessory.partNo
                                  ?.toLowerCase()
                                  .contains(searchTerm.toLowerCase()) ??
                              false))
                      .toList();
              _addSalesblocImpl.vehicleAndEngineNumberStreamController(true);
              if (filteredAccessoriesData?.isEmpty ?? false) {
                return Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: SvgPicture.asset(AppConstants.imgNoData)),
                    AppWidgetUtils.buildSizedBox(custHeight: 5),
                    Text('No $selectedVehicleAndAccessories')
                  ],
                ));
              }
              return Expanded(
                  child: ListView.builder(
                itemCount: filteredAccessoriesData?.length ?? 0,
                itemBuilder: (context, index) {
                  var accessoriesData = filteredAccessoriesData?[index];
                  _addSalesblocImpl
                          .totalAccessoriesQty[accessoriesData?.stockId ?? ''] =
                      accessoriesData?.quantity ?? 0;
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
                                  'Qty - ${_addSalesblocImpl.accessoriesQty[accessoriesData?.stockId] ?? accessoriesData?.quantity}',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                              IconButton(
                                  onPressed: () {
                                    if ((_addSalesblocImpl.accessoriesQty[
                                                accessoriesData?.stockId] ??
                                            accessoriesData?.quantity) ==
                                        accessoriesData?.quantity) {
                                      var selectedAccessory =
                                          filteredAccessoriesData?[index];

                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return AccessoriesSalesEntryDialog(
                                            accessoriesDetails:
                                                selectedAccessory,
                                            selectedItemTndex: index,
                                          );
                                        },
                                      );
                                    }

                                    _addSalesblocImpl
                                        .availableAccListStream(true);
                                    _addSalesblocImpl
                                        .selectedAccessoriesListStreamController(
                                            true);
                                    _addSalesblocImpl.selectedItemStream(true);
                                    _addSalesblocImpl
                                        .vehicleAndEngineNumberStreamController(
                                            true);
                                    _addSalesblocImpl
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
            future: _addSalesblocImpl.getAllCategoryList(),
            builder: (context, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Text(AppConstants.loading));
              } else if (futureSnapshot.hasError ||
                  futureSnapshot.data == null) {
                return const Center(child: Text(AppConstants.errorLoading));
              } else {
                var categoryList = futureSnapshot.data?.category;
                return StreamBuilder(
                  stream: _addSalesblocImpl.selectedVehicleAndAccessoriesStream,
                  builder: (context, snapshot) {
                    var selectedCategory =
                        _addSalesblocImpl.selectedVehicleAndAccessories;
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

                        _addSalesblocImpl.screenChangeStreamController(true);

                        _addSalesblocImpl
                            .changeVehicleAndAccessoriesListStreamController(
                                true);

                        _addSalesblocImpl
                            .vehicleAndEngineNumberStreamController(true);
                        _addSalesblocImpl.availableAccListStream(true);
                        _addSalesblocImpl
                            .vehicleAndEngineNumberStreamController(true);
                        _addSalesblocImpl
                            .selectedVehicleAndAccessoriesListStreamController(
                                true);
                        _addSalesblocImpl
                            .batteryDetailsRefreshStreamController(true);

                        _addSalesblocImpl.selectedVehicleAndAccessories =
                            selectedValue;
                        _addSalesblocImpl
                            .selectedVehicleAndAccessoriesListStreamController(
                                true);
                        //widget.addSalesBloc.screenChangeStreamController(true);

                        clear();

                        // if (widget.addSalesBloc.selectedCustomerId != null) {
                        //  _addSalesblocImpl.selectedCustomer = null;
                        //  _addSalesblocImpl.selectedCustomerId = null;
                        //  _addSalesblocImpl
                        //       .screenChangeStreamController(true);
                        // }

                        _addSalesblocImpl.selectedVehiclesList?.clear();
                        _addSalesblocImpl.slectedAccessoriesList?.clear();

                        _addSalesblocImpl.selectedMandatoryAddOns.clear();
                        _addSalesblocImpl.cgstPresentageTextController.clear();
                        // _addSalesblocImpl.sgstPresentageTextController.clear();
                        _addSalesblocImpl.igstPresentageTextController.clear();
                        _addSalesblocImpl.discountTextController.clear();
                        _addSalesblocImpl.stateIncentiveTextController.clear();
                        _addSalesblocImpl.empsIncentiveTextController.clear();
                        _addSalesblocImpl.hsnCodeTextController.clear();

                        _addSalesblocImpl
                            .selectedVehicleAndAccessoriesListStreamController(
                                true);

                        _addSalesblocImpl
                            .batteryDetailsRefreshStreamController(true);
                        _addSalesblocImpl
                            .selectedVehicleAndAccessoriesListStreamController(
                                true);
                        _addSalesblocImpl.paymentDetailsStreamController(true);
                        _addSalesblocImpl
                            .selectedVehicleAndAccessoriesListStreamController(
                                true);
                      },
                      style: ButtonStyle(
                        backgroundColor: _addSalesblocImpl.changeSegmentedColor(
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
        stream: _addSalesblocImpl.vehicleAndEngineNumberStream,
        builder: (context, snapshot) {
          final bool isTextEmpty = _addSalesblocImpl
              .vehicleNoAndEngineNoSearchController.text.isEmpty;
          final IconData iconData = isTextEmpty ? Icons.search : Icons.close;
          final Color iconColor =
              isTextEmpty ? _appColors.primaryColor : Colors.red;
          _addSalesblocImpl.selectedVehicleAndAccessoriesStreamController(true);
          bool showSearchBar =
              _addSalesblocImpl.selectedVehicleAndAccessories == 'Accessories'
                  ? (_addSalesblocImpl.accessoriesData?.isNotEmpty ?? false)
                  : (_addSalesblocImpl.vehicleData?.isNotEmpty ?? false);
          return Visibility(
            visible: showSearchBar,
            child: TldsInputFormField(
              height: 40,
              controller:
                  _addSalesblocImpl.vehicleNoAndEngineNoSearchController,
              hintText: _addSalesblocImpl.selectedVehicleAndAccessories ==
                      'Accessories'
                  ? 'Accessories Name/Part No'
                  : AppConstants.vehicleNameAndEngineNumber,
              suffixIcon: IconButton(
                onPressed: () {
                  if (!isTextEmpty) {
                    _addSalesblocImpl.vehicleNoAndEngineNoSearchController
                        .clear();

                    _addSalesblocImpl
                        .vehicleAndEngineNumberStreamController(true);
                    _addSalesblocImpl.availableAccListStream(true);
                  }
                },
                icon: Icon(
                  iconData,
                  color: iconColor,
                ),
              ),
              onChanged: (value) {
                _addSalesblocImpl.vehicleAndEngineNumberStreamController(true);
                _addSalesblocImpl.availableAccListStream(true);
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

  void clear() {
    // Reset properties
    _addSalesblocImpl.totalValue = 0.0;
    _addSalesblocImpl.taxableValue = 0.0;
    _addSalesblocImpl.totalInvAmount = 0.0;
    _addSalesblocImpl.invAmount = 0.0;
    _addSalesblocImpl.igstAmount = 0.0;
    _addSalesblocImpl.cgstAmount = 0.0;
    _addSalesblocImpl.sgstAmount = 0.0;
    _addSalesblocImpl.totalUnitRate = 0.0;
    //_addSalesblocImpl.advanceAmt = 0.0;
    _addSalesblocImpl.toBePayedAmt = 0.0;
    _addSalesblocImpl.totalQty = 0.0;

    //_addSalesblocImpl.selectedCustomer = null;
    //_addSalesblocImpl.selectedCustomerId = null;
    //_addSalesblocImpl.selectedCustomerDetailsStreamController(true);

    _addSalesblocImpl.isSplitPayment = false;

    _addSalesblocImpl.selectedMandatoryAddOns.clear();

    _addSalesblocImpl.splitPaymentAmt.clear();
    _addSalesblocImpl.splitPaymentId.clear();
    _addSalesblocImpl.paymentName.clear();
    _addSalesblocImpl.accessoriesQty.clear();

    _addSalesblocImpl.discountTextController.clear();
    _addSalesblocImpl.transporterVehicleNumberController.clear();
    _addSalesblocImpl.vehicleNoAndEngineNoSearchController.clear();
    _addSalesblocImpl.unitRateControllers.clear();
    _addSalesblocImpl.hsnCodeTextController.clear();
    _addSalesblocImpl.betteryNameTextController.clear();
    _addSalesblocImpl.batteryCapacityTextController.clear();
    _addSalesblocImpl.empsIncentiveTextController.clear();
    _addSalesblocImpl.stateIncentiveTextController.clear();
    _addSalesblocImpl.paidAmountController.clear();
    _addSalesblocImpl.paymentTypeIdTextController.clear();
    _addSalesblocImpl.quantityTextController.clear();
    _addSalesblocImpl.unitRateTextController.clear();

    _addSalesblocImpl.vehicleAndEngineNumberStreamController(true);

    _addSalesblocImpl.gstDetailsStreamController(true);
    _addSalesblocImpl.batteryDetailsRefreshStreamController(true);
    _addSalesblocImpl.selectedVehicleAndAccessoriesListStreamController(true);
    _addSalesblocImpl.paymentDetailsStreamController(true);
    //_addSalesblocImpl.screenChangeStreamController(true);
  }
}
