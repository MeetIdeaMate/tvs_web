import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
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
  final AddSalesBlocImpl addSalesBloc;
  const CustomerDetails({
    super.key,
    required this.addSalesBloc,
  });

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  final _appColors = AppColors();

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
        if (widget.addSalesBloc.selectedCustomer != '')
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
          stream: widget.addSalesBloc.selectedCustomerDetailsViewStream,
          builder: (context, snapshot) {
            return FutureBuilder<GetAllCustomersModel?>(
              future: widget.addSalesBloc.getCustomerById(),
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
            stream: widget.addSalesBloc.customerSelectstream,
            builder: (context, snapshot) {
              return FutureBuilder<List<GetAllCustomerNameList>?>(
                future: widget.addSalesBloc.getAllCustomerList(),
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
                    dropDownValue: widget.addSalesBloc.selectedCustomer,
                    dropDownItems: customerNamesList ?? [],
                    onChange: (String? newValue) {
                      widget.addSalesBloc.selectedCustomer = newValue;
                      var selectedVendor = customerList!.firstWhere(
                          (customer) => customer.customerName == newValue);
                      widget.addSalesBloc.selectedCustomerId =
                          selectedVendor.customerId;
                      widget.addSalesBloc
                          .selectedCustomerDetailsStreamController(true);

                      if (widget.addSalesBloc.selectedVehicleAndAccessories !=
                          'Accessories') {
                        _updateTotalInvoiceAmount();
                        widget.addSalesBloc
                            .paymentDetailsStreamController(true);
                        widget.addSalesBloc
                            .getCustomerBookingDetails(
                                selectedVendor.customerId)
                            .then((value) {
                          if (value?.isNotEmpty ?? false) {
                            for (GetCustomerBookingDetails element
                                in value ?? []) {
                              widget.addSalesBloc.advanceAmt =
                                  element.paidDetail?.paidAmount ?? 0;
                              widget.addSalesBloc.bookingId = element.bookingNo;
                              widget.addSalesBloc
                                  .advanceAmountRefreshStreamController(true);
                              widget
                                  .addSalesBloc
                                  .vehicleNoAndEngineNoSearchController
                                  .text = element.partNo ?? '';
                              widget.addSalesBloc
                                  .vehicleAndEngineNumberStreamController(true);
                              widget.addSalesBloc
                                      .selectedVehicleAndAccessories =
                                  element.categoryName;
                              //    var selectedValue = newValue.first;

                              widget.addSalesBloc.selectedVehiclesList?.clear();
                              widget.addSalesBloc.slectedAccessoriesList
                                  ?.clear();

                              widget.addSalesBloc.selectedMandatoryAddOns
                                  .clear();
                              widget.addSalesBloc
                                  .batteryDetailsRefreshStreamController(true);
                              widget.addSalesBloc
                                  .selectedVehicleAndAccessoriesListStreamController(
                                      true);
                              _updateTotalInvoiceAmount();
                              widget.addSalesBloc
                                  .paymentDetailsStreamController(true);

                              // widget.addSalesBloc.selectedVehiclesList = [];
                              widget.addSalesBloc
                                  .batteryDetailsRefreshStreamController(true);
                              widget.addSalesBloc.selectedItemStream(true);
                              widget.addSalesBloc
                                  .selectedVehiclesListStreamController(true);

                              widget.addSalesBloc
                                  .changeVehicleAndAccessoriesListStreamController(
                                      true);
                              widget.addSalesBloc
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
                  return CreateCustomerDialog(bloc: widget.addSalesBloc);
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
        double.tryParse(widget.addSalesBloc.empsIncentiveTextController.text) ??
            0.0;
    double? stateIncValue = double.tryParse(
            widget.addSalesBloc.stateIncentiveTextController.text) ??
        0.0;

    double totalIncentive = empsIncValue + stateIncValue;

    if ((widget.addSalesBloc.invAmount ?? 0) != -1) {
      widget.addSalesBloc.totalInvAmount =
          (widget.addSalesBloc.invAmount ?? 0) - totalIncentive;
    } else {
      widget.addSalesBloc.totalInvAmount = 0.0;
    }

    double advanceAmt = widget.addSalesBloc.advanceAmt ?? 0;
    double totalInvAmt = widget.addSalesBloc.totalInvAmount ?? 0;
    widget.addSalesBloc.toBePayedAmt = totalInvAmt - advanceAmt;
    widget.addSalesBloc.toBePayedAmt = double.parse(
        widget.addSalesBloc.toBePayedAmt?.round().toString() ?? '');
    widget.addSalesBloc.paymentDetailsStreamController(true);
  }
}
