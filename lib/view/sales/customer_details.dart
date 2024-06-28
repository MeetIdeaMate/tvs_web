// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/models/get_model/get_all_customers_model.dart';
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
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        Text(
          AppConstants.customerDetails,
          style: TextStyle(
              color: _appColors.primaryColor,
              fontSize: 17,
              fontWeight: FontWeight.bold),
        ),
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        _buildSelectCustomerAndAddCustomer(),
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        //  if (widget.addSalesBloc.selectedCustomer != null)
        _buildSelectedCustomerDetails(),
        // AppWidgetUtils.buildSizedBox(custHeight: 10),
        // Text(
        //   AppConstants.paymentDetails,
        //   style: TextStyle(
        //       color: _appColors.primaryColor,
        //       fontSize: 17,
        //       fontWeight: FontWeight.bold),
        // ),
        // AppWidgetUtils.buildSizedBox(custHeight: 7),
        // _buildPaymentMethodSelection(context),
        // const Spacer(),
        // CustomActionButtons(
        //     onPressed: () {
        //       if (widget.addSalesBloc.selectedPaymentOption != null ||
        //           widget.addSalesBloc.selectedCustomer != null) {}
        //     },
        //     buttonText: AppConstants.save)
      ],
    );
  }

  Widget _buildSelectedCustomerDetails() {
    return Container(
      padding: const EdgeInsets.all(15),
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
                      customer?.customerName ?? 'ajith',
                      style: TextStyle(
                          color: _appColors.primaryColor, fontSize: 20),
                    ),
                    AppWidgetUtils.buildSizedBox(custHeight: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCustomerColumn([
                          _buildCustomerData(
                              customer?.mobileNo ?? '', AppConstants.icCall),
                          _buildCustomerData(
                              customer?.accountNo ?? '', AppConstants.icBank),
                          _buildCustomerData(
                              customer?.address ?? '', AppConstants.icLocation),
                        ]),
                        _buildCustomerColumn([
                          _buildCustomerData(
                              customer?.emailId ?? '', AppConstants.icMail),
                          _buildCustomerData(
                              customer?.aadharNo ?? '', AppConstants.icCard),
                          _buildCustomerData(
                              customer?.city ?? '', AppConstants.icCity),
                        ]),
                      ],
                    ),
                  ],
                );
              },
            );
          }),
    );
  }

  Widget _buildCustomerColumn(List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var child in children) ...[
          child,
          AppWidgetUtils.buildSizedBox(custHeight: 10),
        ],
      ],
    );
  }

  Widget _buildCustomerData(String? textValue, String svgPath) {
    return Row(
      children: [
        SvgPicture.asset(
          svgPath,
          colorFilter:
              ColorFilter.mode(_appColors.primaryColor, BlendMode.srcIn),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 10),
        Text(textValue ?? '')
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
                return FutureBuilder(
                  future: widget.addSalesBloc.getAllCustomerList(),
                  builder: (context, snapshot) {
                    var customerList = snapshot.data;
                    List<String>? customerNamesList =
                        customerList?.map((e) => e.customerName ?? '').toList();
                    return TldsDropDownButtonFormField(
                      height: 70,
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
                        var selectedVendor = customerList!.firstWhere(
                            (customer) => customer.customerName == newValue);
                        widget.addSalesBloc.selectedCustomerId =
                            selectedVendor.customerId;
                        widget.addSalesBloc.customerNameStreamcontroller(true);
                        widget.addSalesBloc
                            .selectedCustomerDetailsStreamController(true);
                      },
                    );
                  },
                );
              }),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 10),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: CustomElevatedButton(
            height: 40,
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
        )
      ],
    );
  }

  // Widget _buildCustomRadioTile({
  //   required String value,
  //   required String? groupValue,
  //   required ValueChanged<String?> onChanged,
  //   required IconData icon,
  //   required String label,
  // }) {
  //   bool isSelected = value == groupValue;

  //   return GestureDetector(
  //     onTap: () {
  //       onChanged(value);
  //     },
  //     child: Container(
  //       margin: const EdgeInsets.all(8.0),
  //       width: 180,
  //       height: 50,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(8.0),
  //         border: Border.all(
  //           color: isSelected
  //               ? Theme.of(context).primaryColor
  //               : _appColors.greyColor,
  //           width: isSelected ? 2.0 : 1.0,
  //         ),
  //       ),
  //       child: Row(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //             child: Icon(
  //               icon,
  //               color:
  //                   isSelected ? _appColors.primaryColor : _appColors.greyColor,
  //             ),
  //           ),
  //           Expanded(
  //             child: Text(
  //               label,
  //               style: TextStyle(
  //                   fontSize: 16.0,
  //                   color: isSelected
  //                       ? _appColors.primaryColor
  //                       : _appColors.greyColor),
  //             ),
  //           ),
  //           Radio<String>(
  //             value: value,
  //             groupValue: groupValue,
  //             onChanged: onChanged,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildPaymentOptions() {
  //   return FutureBuilder(
  //     future: widget.addSalesBloc.getPaymentmethods(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       } else if (snapshot.hasData) {
  //         return SizedBox(
  //           height: 200,
  //           width: 180,
  //           child: ListView.separated(
  //             itemCount: snapshot.data?.length ?? 0,
  //             itemBuilder: (context, index) => _buildCustomRadioTile(
  //               value: snapshot.data?[index].toString() ?? '',
  //               groupValue: widget.addSalesBloc.selectedPaymentOption,
  //               onChanged: (value) {
  //                 setState(() {
  //                   widget.addSalesBloc.selectedPaymentOption = value!;
  //                 });
  //               },
  //               icon: Icons.payment,
  //               label: snapshot.data?[index].toUpperCase() ?? '',
  //             ),
  //             separatorBuilder: (BuildContext context, int index) {
  //               return AppWidgetUtils.buildSizedBox(custHeight: 8);
  //             },
  //           ),
  //         );
  //       } else {
  //         return const Center(
  //           child: Text('No Payment Methods Available'),
  //         );
  //       }
  //     },
  //   );
  // }
}
