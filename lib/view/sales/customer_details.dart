import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/api_service/service_locator.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/models/get_model/get_all_customer_name_list.dart';
import 'package:tlbilling/models/get_model/get_all_customers_model.dart';
import 'package:tlbilling/models/get_model/get_customer_booking_details.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/customer/create_customer_dialog.dart';
import 'package:tlbilling/view/sales/add_sales_bloc.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';

class CustomerDetails extends StatefulWidget {
  const CustomerDetails({
    super.key,
  });

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  final _appColors = AppColors();
  final _addSalesBloc = getIt<AddSalesBlocImpl>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppConstants.customerDetails,
          style: TextStyle(
              color: _appColors.primaryColor,
              fontSize: 17,
              fontWeight: FontWeight.bold),
        ),
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        _buildSelectCustomerAndAddCustomer(),
        if (_addSalesBloc.selectedCustomer != '')
          _buildSelectedCustomerDetails(),
      ],
    );
  }

  Widget _buildSelectedCustomerDetails() {
    return Container(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: _appColors.whiteColor,
      ),
      child: StreamBuilder(
          stream: _addSalesBloc.selectedCustomerDetailsViewStream,
          builder: (context, snapshot) {
            return FutureBuilder<GetAllCustomersModel?>(
              future: _addSalesBloc.getCustomerById(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text(AppConstants.loading));
                } else if (snapshot.hasError) {
                  return const Center(child: Text(AppConstants.errorLoading));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text(''));
                }

                GetAllCustomersModel? customer = snapshot.data;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer?.customerName ?? '',
                      style: TextStyle(
                          color: _appColors.primaryColor, fontSize: 20),
                    ),
                    AppWidgetUtils.buildSizedBox(custHeight: 8),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        if (customer?.mobileNo != '')
                          _buildCustomerData(
                              customer?.mobileNo ?? '', AppConstants.icCall),
                        if (customer?.accountNo != '')
                          _buildCustomerData(
                              customer?.accountNo ?? '', AppConstants.icBank),
                        if (customer?.address != '')
                          _buildCustomerData(
                              customer?.address ?? '', AppConstants.icLocation),
                        if (customer?.emailId != '')
                          _buildCustomerData(
                              customer?.emailId ?? '', AppConstants.icMail),
                        if (customer?.aadharNo != '')
                          _buildCustomerData(
                              customer?.aadharNo ?? '', AppConstants.icCard),
                        if (customer?.city != '')
                          _buildCustomerData(
                              customer?.city ?? '', AppConstants.icCity),
                      ],
                    ),
                  ],
                );
              },
            );
          }),
    );
  }

  Widget _buildCustomerData(String? textValue, String svgPath) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          svgPath,
          colorFilter:
              ColorFilter.mode(_appColors.primaryColor, BlendMode.srcIn),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 10),
        Flexible(child: Text(textValue ?? '')),
        AppWidgetUtils.buildSizedBox(custWidth: 5),
      ],
    );
  }

  Widget _buildSelectCustomerAndAddCustomer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: StreamBuilder<bool>(
            stream: _addSalesBloc.customerSelectstream,
            builder: (context, snapshot) {
              return FutureBuilder<List<GetAllCustomerNameList>?>(
                future: _addSalesBloc.getAllCustomerList(),
                builder: (context, customerSnapshot) {
                  if (customerSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Text(AppConstants.loading);
                  }

                  if (customerSnapshot.hasError) {
                    return const Text(AppConstants.errorLoading);
                  }

                  var customerList = customerSnapshot.data;
                  List<String>? customerNamesList =
                      customerList?.map((e) => e.customerName ?? '').toList();

                  return TldsDropDownButtonFormField(
                    // height: 50,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return AppConstants.selectCustomer;
                      }
                      return null;
                    },
                    width: MediaQuery.sizeOf(context).width * 0.22,
                    hintText: AppConstants.selectCustomer,
                    dropDownValue: _addSalesBloc.selectedCustomer,
                    dropDownItems: customerNamesList ?? [],
                    onChange: (String? newValue) {
                      _addSalesBloc.selectedCustomer = newValue;
                      var selectedVendor = customerList!.firstWhere(
                          (customer) => customer.customerName == newValue);
                      _addSalesBloc.selectedCustomerId =
                          selectedVendor.customerId;
                      _addSalesBloc
                          .selectedCustomerDetailsStreamController(true);

                      if (_addSalesBloc.selectedVehicleAndAccessories !=
                          'Accessories') {
                        _updateTotalInvoiceAmount();
                        _addSalesBloc.paymentDetailsStreamController(true);
                        _addSalesBloc
                            .getCustomerBookingDetails(
                                selectedVendor.customerId)
                            .then((value) {
                          if (value?.isNotEmpty ?? false) {
                            for (GetCustomerBookingDetails element
                                in value ?? []) {
                              _addSalesBloc.advanceAmt =
                                  element.paidDetail?.paidAmount ?? 0;
                              _addSalesBloc.bookingId = element.bookingNo;
                              _addSalesBloc
                                  .advanceAmountRefreshStreamController(true);
                              _addSalesBloc.vehicleNoAndEngineNoSearchController
                                  .text = element.partNo ?? '';
                              _addSalesBloc
                                  .vehicleAndEngineNumberStreamController(true);
                              _addSalesBloc.selectedVehicleAndAccessories =
                                  element.categoryName;
                              //    var selectedValue = newValue.first;

                              _addSalesBloc.selectedVehiclesList?.clear();
                              _addSalesBloc.slectedAccessoriesList?.clear();

                              _addSalesBloc.selectedMandatoryAddOns.clear();
                              clear();

                              _addSalesBloc
                                  .batteryDetailsRefreshStreamController(true);
                              _addSalesBloc.unitRateTextController.clear();

                              _addSalesBloc
                                  .selectedVehicleAndAccessoriesListStreamController(
                                      true);
                              _updateTotalInvoiceAmount();
                              _addSalesBloc
                                  .paymentDetailsStreamController(true);

                              // _addSalesBloc.selectedVehiclesList = [];
                              _addSalesBloc
                                  .batteryDetailsRefreshStreamController(true);
                              _addSalesBloc.selectedItemStream(true);
                              _addSalesBloc
                                  .selectedVehiclesListStreamController(true);

                              _addSalesBloc
                                  .changeVehicleAndAccessoriesListStreamController(
                                      true);
                              _addSalesBloc
                                  .selectedVehicleAndAccessoriesListStreamController(
                                      true);
                            }
                          }
                        });
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 10),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: CustomElevatedButton(
            height: 50,
            width: MediaQuery.sizeOf(context).width * 0.12,
            text: AppConstants.addNew,
            fontSize: 16,
            buttonBackgroundColor: _appColors.primaryColor,
            fontColor: _appColors.whiteColor,
            suffixIcon: SvgPicture.asset(AppConstants.icHumanAdd),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const CreateCustomerDialog();
                },
              );
            },
          ),
        ),
      ],
    );
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
        double.parse(_addSalesBloc.toBePayedAmt?.round().toString() ?? '');
    _addSalesBloc.paymentDetailsStreamController(true);
  }

  void clear() {
    // Reset properties
    _addSalesBloc.totalValue = 0.0;
    _addSalesBloc.taxableValue = 0.0;
    _addSalesBloc.totalInvAmount = 0.0;
    _addSalesBloc.invAmount = 0.0;
    _addSalesBloc.igstAmount = 0.0;
    _addSalesBloc.cgstAmount = 0.0;
    _addSalesBloc.sgstAmount = 0.0;
    _addSalesBloc.totalUnitRate = 0.0;
    // _addSalesBloc.advanceAmt = 0.0;
    _addSalesBloc.toBePayedAmt = 0.0;
    _addSalesBloc.totalQty = 0.0;

    // _addSalesBloc.selectedCustomer = null;
    // _addSalesBloc.selectedCustomerId = null;
    // _addSalesBloc.selectedCustomerDetailsStreamController(true);

    _addSalesBloc.isSplitPayment = false;

    _addSalesBloc.selectedMandatoryAddOns.clear();

    _addSalesBloc.splitPaymentAmt.clear();
    _addSalesBloc.splitPaymentId.clear();
    _addSalesBloc.paymentName.clear();
    _addSalesBloc.accessoriesQty.clear();

    _addSalesBloc.discountTextController.clear();
    _addSalesBloc.transporterVehicleNumberController.clear();
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
    // _addSalesBloc.screenChangeStreamController(true);
  }
}
