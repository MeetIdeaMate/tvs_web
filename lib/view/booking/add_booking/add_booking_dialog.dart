import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/models/get_model/get_all_customer_name_list.dart';
import 'package:tlbilling/models/get_model/get_all_employee_model.dart';
import 'package:tlbilling/models/get_model/get_all_stocks_without_pagination.dart';
import 'package:tlbilling/models/post_model/add_new_booking_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlbilling/view/booking/add_booking/add_booking_dialog_bloc.dart';
import 'package:tlbilling/view/booking/booking_list_bloc.dart';
import 'package:tlbilling/view/customer/create_customer_dialog.dart';
import 'package:tlds_flutter/components/tlds_date_picker.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_formaters.dart';
import 'package:toastification/toastification.dart';
import 'package:intl/intl.dart';

class AddBookingDialog extends StatefulWidget {
  final BookingListBlocImpl bookingListBloc;
  const AddBookingDialog({super.key, required this.bookingListBloc});

  @override
  State<AddBookingDialog> createState() => _AddBookingDialogState();
}

class _AddBookingDialogState extends State<AddBookingDialog> {
  final _appColors = AppColors();
  final _addBookingDialogBloc = AddBookingDialogBlocImpl();

  @override
  void initState() {
    super.initState();
    getBranchId();
    _addBookingDialogBloc.bookingDateTextController.text =
        DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  Future<void> getBranchId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _addBookingDialogBloc.branchId = prefs.getString('branchId') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
      inAsyncCall: _addBookingDialogBloc.isAsyncCall,
      color: _appColors.whiteColor,
      progressIndicator: AppWidgetUtils.buildLoading(),
      child: AlertDialog(
        surfaceTintColor: _appColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        actions: [
          CustomActionButtons(
              onPressed: () {
                _bookingPostServiceOnPress();
              },
              buttonText: AppConstants.save)
        ],
        content: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.4,
          child: Form(
            key: _addBookingDialogBloc.bookinFormKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  const Divider(),
                  _buildDateCustomerNameAndAddCustomer(),
                  _buildVehicleNameList(),
                  _buildAdditionalInfoField(),
                  _buildPaymentTypeAndAmount(),
                  _buildExecutiveFromAndTargetInvoiceDate(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppWidgetUtils.buildCustomDmSansTextWidget(AppConstants.newBooking,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: _appColors.primaryColor),
        IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close))
      ],
    );
  }

  Widget _buildDateCustomerNameAndAddCustomer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildDatePicker(),
        AppWidgetUtils.buildSizedBox(custWidth: 10),
        _buildCustomerNameDropdown(),
        AppWidgetUtils.buildSizedBox(custWidth: 10),
        _buildAddNewCustomerButton(),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Expanded(
      child: TldsDatePicker(
        height: 70,
        requiredLabelText:
            AppWidgetUtils.labelTextWithRequired(AppConstants.date),
        firstDate: DateTime(2000, 1, 1),
        suffixIcon: SvgPicture.asset(
          AppConstants.icDate,
          colorFilter: ColorFilter.mode(
            _appColors.primaryColor,
            BlendMode.srcIn,
          ),
        ),
        fontSize: 14,
        hintText: AppConstants.fromDate,
        controller: _addBookingDialogBloc.bookingDateTextController,
      ),
    );
  }

  Widget _buildCustomerNameDropdown() {
    return FutureBuilder(
      future: _addBookingDialogBloc.getCustomerNames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text(AppConstants.loading));
        } else if (snapshot.hasError) {
          return const Center(child: Text(AppConstants.errorLoading));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text(AppConstants.noData));
        }
        final customerList = snapshot.data ?? [];
        final customerNamesSet =
            customerList.map((result) => result.customerName ?? "").toSet();
        List<String> customerNamesList = customerNamesSet.toList();
        return _buildCustomTyAhead(
          requiredLabelText:
              AppWidgetUtils.labelTextWithRequired(AppConstants.customerName),
          width: 200,
          textEditingController:
              _addBookingDialogBloc.customerNameTextController,
          hintText: AppConstants.select,
          errorText: AppConstants.selectCustomer,
          list: customerNamesList,
          onSelected: (String suggestion) {
            _addBookingDialogBloc.customerNameTextController.text = suggestion;
            final selectedCustomer = customerList.firstWhere(
              (customer) => customer.customerName == suggestion,
              orElse: () => GetAllCustomerNameList(),
            );
            _addBookingDialogBloc.selectedCustomerId =
                selectedCustomer.customerId;
          },
        );
      },
    );
  }

  Widget _buildAddNewCustomerButton() {
    return CustomElevatedButton(
      width: 100,
      text: '',
      height: 50,
      fontSize: 14,
      buttonBackgroundColor: _appColors.primaryColor,
      fontColor: _appColors.whiteColor,
      suffixIcon: SvgPicture.asset(AppConstants.icCustomers),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const CreateCustomerDialog(),
        );
      },
    );
  }

  Widget _buildVehicleNameList() {
    return FutureBuilder(
      future: _addBookingDialogBloc.getVehicleList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text(AppConstants.loading));
        } else if (snapshot.hasError) {
          return const Center(child: Text(AppConstants.errorLoading));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text(AppConstants.noData));
        }
        List<String> vehicleNameList =
            snapshot.data?.map((e) => e.itemName ?? '').toList() ?? [];
        return _buildCustomTyAhead(
          requiredLabelText:
              AppWidgetUtils.labelTextWithRequired(AppConstants.vehicleName),
          width: MediaQuery.sizeOf(context).width,
          textEditingController:
              _addBookingDialogBloc.vehicleNameTextController,
          hintText: AppConstants.select,
          errorText: AppConstants.selectedVehicle,
          list: vehicleNameList,
          onSelected: (String suggestion) {
            _addBookingDialogBloc.vehicleNameTextController.text = suggestion;
            final selectedVehicle = snapshot.data?.firstWhere(
              (vehicle) => vehicle.itemName == suggestion,
              orElse: () => GetAllStocksWithoutPaginationModel(),
            );
            _addBookingDialogBloc.selectedVehiclePartNo =
                selectedVehicle?.partNo ?? '';
          },
        );
      },
    );
  }

  Widget _buildAdditionalInfoField() {
    return _buildFormField(
      _addBookingDialogBloc.additionalInfoTextController,
      AppConstants.additionalInfo,
      TldsInputFormatters.allowAlphabetsAndSpaces,
      labelText: AppConstants.additionalInfo,
    );
  }

  Widget _buildPaymentTypeAndAmount() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildPaymentType(),
        AppWidgetUtils.buildSizedBox(custWidth: 10),
        Expanded(child: _buildAmountFiled()),
      ],
    );
  }

  Widget _buildPaymentType() {
    return FutureBuilder(
      future: _addBookingDialogBloc.getPaymentsList(),
      builder: (context, snapshot) {
        List<String> paymentTypesList = snapshot.data?.configuration ?? [];
        return TldsDropDownButtonFormField(
          requiredLabelText:
              AppWidgetUtils.labelTextWithRequired(AppConstants.paymentType),
          height: 70,
          hintText: AppConstants.payments,
          dropDownItems: paymentTypesList,
          dropDownValue: _addBookingDialogBloc.selectedPaymentType,
          onChange: (String? newValue) {
            _addBookingDialogBloc.selectedPaymentType = newValue ?? '';
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppConstants.selectPaymentType;
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildAmountFiled() {
    return _buildFormField(
      requiredLabelText:
          AppWidgetUtils.labelTextWithRequired(AppConstants.amount),
      _addBookingDialogBloc.amountTextController,
      AppConstants.amount,
      TldsInputFormatters.onlyAllowDecimalAfterTwoDigits,
      validator: (amount) {
        if (amount?.isEmpty ?? false) {
          return AppConstants.enterAmount;
        }
        return null;
      },
    );
  }

  Widget _buildExecutiveFromAndTargetInvoiceDate() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildExecutiveFrom(),
          AppWidgetUtils.buildSizedBox(custWidth: 10),
          Expanded(child: _buildTargetInvoiceDate()),
        ]);
  }

  Widget _buildExecutiveFrom() {
    return FutureBuilder(
      future: _addBookingDialogBloc.getAllExcutiveList(),
      builder: (context, snapshot) {
        List<GetAllEmployeeModel?> employeeList = snapshot.data ?? [];
        List<String> employeeNames =
            employeeList.map((e) => e?.employeeName ?? '').toList();
        return TldsDropDownButtonFormField(
          requiredLabelText:  AppWidgetUtils.labelTextWithRequired(AppConstants.executiveName),
          height: 70,
          hintText: AppConstants.executiveName,
          dropDownItems: employeeNames,
          dropDownValue: _addBookingDialogBloc.selectedPaymentType,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppConstants.selectExcutive;
            }
            return null;
          },
          onChange: (String? newValue) {
            if (newValue != null) {
              GetAllEmployeeModel? selectedEmployee = employeeList.firstWhere(
                  (e) => e?.employeeName == newValue,
                  orElse: () => GetAllEmployeeModel());
              _addBookingDialogBloc.selectedExcutiveId =
                  selectedEmployee?.employeeId ?? '';
            }
          },
        );
      },
    );
  }

  Widget _buildTargetInvoiceDate() {
    return TldsDatePicker(
      requiredLabelText:  AppWidgetUtils.labelTextWithRequired(AppConstants.targetInvDate),
      height: 70,
      suffixIcon: SvgPicture.asset(
        AppConstants.icDate,
        colorFilter: ColorFilter.mode(
          _appColors.primaryColor,
          BlendMode.srcIn,
        ),
      ),
      fontSize: 14,
      hintText: AppConstants.targetInvDate,
      controller: _addBookingDialogBloc.targetInvoiceDateTextController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppConstants.selectTargetInvoicedDate;
        }
        return null;
      },
    );
  }

  Widget _buildCustomTyAhead(
      {TextEditingController? textEditingController,
      List<String>? list,
      String? errorText,
      String? labelText,
      double? width,
      String? hintText,
      Function(String)? onChanged,
      Function(String)? onSelected,
      Widget? requiredLabelText}) {
    return TypeAheadField(
      controller: textEditingController,
      itemBuilder: (context, String suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      onSelected: onSelected,
      suggestionsCallback: (pattern) {
        return list
            ?.where((customer) =>
                customer.toLowerCase().contains(pattern.toLowerCase()))
            .toList();
      },
      builder: (context, controller, focusNode) {
        return TldsInputFormField(
          requiredLabelText: requiredLabelText,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          width: width,
          height: 70,
          focusNode: focusNode,
          labelText: labelText,
          hintText: hintText,
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return errorText;
            }
            return null;
          },
          onChanged: onChanged,
        );
      },
    );
  }

  Widget _buildFormField(TextEditingController textController, String hintText,
      List<TextInputFormatter>? inputFormatters,
      {String? labelText,
      String? Function(String?)? validator,
      Widget? requiredLabelText}) {
    return TldsInputFormField(
      requiredLabelText: requiredLabelText,
      labelText: labelText,
      height: 70,
      validator: validator,
      inputFormatters: inputFormatters,
      controller: textController,
      hintText: hintText,
      onSubmit: (p0) {},
    );
  }

  _isLoading(bool? isLoadingState) {
    setState(() {
      _addBookingDialogBloc.isAsyncCall = isLoadingState;
    });
  }

  void _bookingPostServiceOnPress() {
    if (_addBookingDialogBloc.bookinFormKey.currentState!.validate()) {
       _isLoading(true);
      _addBookingDialogBloc.addNewBookingDetails(
          BookingModel(
              branchId: _addBookingDialogBloc.branchId ?? '',
              additionalInfo:
                  _addBookingDialogBloc.additionalInfoTextController.text,
              bookingDate: AppUtils.appToAPIDateFormat(
                  _addBookingDialogBloc.bookingDateTextController.text),
              customerId: _addBookingDialogBloc.selectedCustomerId ?? '',
              executiveId: _addBookingDialogBloc.selectedExcutiveId ?? '',
              paidDetail: PaidDetail(
                  paidAmount: double.tryParse(
                          _addBookingDialogBloc.amountTextController.text) ??
                      0,
                  paymentDate: AppUtils.appToAPIDateFormat(
                      _addBookingDialogBloc.bookingDateTextController.text),
                  paymentType: _addBookingDialogBloc.selectedPaymentType ?? ''),
              partNo: _addBookingDialogBloc.selectedVehiclePartNo ?? '',
              targetInvoiceDate: AppUtils.appToAPIDateFormat(
                  _addBookingDialogBloc.targetInvoiceDateTextController.text)),
          (statusCode) {
        if (statusCode == 200 || statusCode == 201) {
          _isLoading(false);
          widget.bookingListBloc.pageNumberUpdateStreamController(0);
          Navigator.pop(context);
          AppWidgetUtils.buildToast(
              context,
              ToastificationType.success,
              AppConstants.bookingCreated,
              Icon(
                Icons.check_circle_outline_rounded,
                color: _appColors.successColor,
              ),
              AppConstants.bookingCreatedDes,
              _appColors.successLightColor);
        } else {
          _isLoading(false);
          AppWidgetUtils.buildToast(
              context,
              ToastificationType.error,
              AppConstants.bookingCreatedErr,
              Icon(
                Icons.error_outline_outlined,
                color: _appColors.errorColor,
              ),
              AppConstants.somethingWentWrong,
              _appColors.errorLightColor);
        }
      });
    }
  }
}
