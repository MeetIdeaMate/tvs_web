import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlbilling/view/employee/create_employee_dialog.dart';
import 'package:tlbilling/view/voucher_receipt/new_voucher/new_voucher_bloc.dart';
import 'package:tlbilling/view/voucher_receipt/vouecher_receipt_list_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';

class NewVoucher extends StatefulWidget {
  final VoucherReceiptListBlocImpl? blocInstance;

  const NewVoucher({super.key, this.blocInstance});

  @override
  State<NewVoucher> createState() => _NewVoucherState();
}

class _NewVoucherState extends State<NewVoucher> {
  final _newVoucherBloc = NewVoucherBlocImpl();
  final _appColors = AppColors();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _appColors.whiteColor,
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const Divider(),
            _buildDefaultHeight(),
            _buildPayToAndDate(),
            _buildDefaultHeight(),
            _buildGiverAndAmount(),
          ],
        ),
      ),
      actions: [_buildActionButton()],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppWidgetUtils.buildCustomDmSansTextWidget(AppConstants.newVoucher,
            fontSize: 20, fontWeight: FontWeight.w700),
        IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close))
      ],
    );
  }

  Widget _buildPayToAndDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            StreamBuilder<bool>(
                stream: _newVoucherBloc.payToTextStream,
                builder: (context, snapshot) {
                  return FutureBuilder(
                    future: _newVoucherBloc.getEmployeeName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: Text(AppConstants.loading));
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text(AppConstants.errorLoading));
                      } else if (!snapshot.hasData ||
                          snapshot.data!.result == null ||
                          snapshot.data!.result!.employeeListModel == null) {
                        return const Center(child: Text(AppConstants.noData));
                      }
                      final employeesList =
                          snapshot.data!.result!.employeeListModel;
                      final employeeNamesSet = employeesList!
                          .map((result) => result.employeeName ?? "")
                          .toSet();
                      List<String> employeeNamesList =
                          employeeNamesSet.toList();

                      return TypeAheadField(
                        controller: _newVoucherBloc.payToTextController,
                        itemBuilder: (context, String suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        onSelected: (String suggestion) {
                          _newVoucherBloc.payToTextController.text = suggestion;
                        },
                        suggestionsCallback: (pattern) {
                          return employeeNamesList
                              .where((employee) => employee
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase()))
                              .toList();
                        },
                        builder: (context, controller, focusNode) {
                          return TldsInputFormField(
                            suffixIcon: const Icon(Icons.arrow_drop_down),
                            width: 201,
                            focusNode: focusNode,
                            labelText: AppConstants.employee,
                            hintText: AppConstants.payTo,
                            controller: controller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Select Employee';
                              }
                              return null;
                            },
                          );
                        },
                      );
                    },
                  );
                }),
            AppWidgetUtils.buildSizedBox(custWidth: 5),
            IconButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6)),
                  backgroundColor:
                      MaterialStateProperty.all(_appColors.primaryColor)),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CreateEmployeeDialog(
                        newVoucherBloc: _newVoucherBloc);
                  },
                );
              },
              icon: SvgPicture.asset(AppConstants.icaddUser),
              color: _appColors.whiteColor,
            ),
          ],
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 44),
        Expanded(
            child: TldsInputFormField(
          controller: _newVoucherBloc.voucherDateTextController,
          requiredLabelText: const Text(AppConstants.invoiceDate),
          height: 40,
          hintText: 'dd/mm/yyyy',
          suffixIcon: IconButton(
              onPressed: () => _selectDate(
                  context, _newVoucherBloc.voucherDateTextController),
              icon: SvgPicture.asset(AppConstants.icDate)),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Enter Appointment Date';
            }
            return null;
          },
          onTap: () =>
              _selectDate(context, _newVoucherBloc.voucherDateTextController),
        ))
      ],
    );
  }

  Widget _buildGiverAndAmount() {
    return Row(
      children: [
        Expanded(
          child: StreamBuilder<bool>(
              stream: _newVoucherBloc.giverTextStream,
              builder: (context, snapshot) {
                return FutureBuilder(
                  future: _newVoucherBloc.getEmployeeName(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Text(AppConstants.loading));
                    } else if (snapshot.hasError) {
                      return const Center(
                          child: Text(AppConstants.errorLoading));
                    } else if (!snapshot.hasData ||
                        snapshot.data!.result == null ||
                        snapshot.data!.result!.employeeListModel == null) {
                      return const Center(child: Text(AppConstants.noData));
                    }
                    final employeesList =
                        snapshot.data!.result!.employeeListModel;
                    final employeeNamesSet = employeesList!
                        .map((result) => result.employeeName ?? "")
                        .toSet();
                    List<String> employeeNamesList = employeeNamesSet.toList();
                    return TypeAheadField(
                      controller: _newVoucherBloc.giverTextController,
                      itemBuilder: (context, String suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      onSelected: (String suggestion) {
                        _newVoucherBloc.giverTextController.text = suggestion;
                      },
                      suggestionsCallback: (pattern) {
                        return employeeNamesList
                            .where((employee) => employee
                                .toLowerCase()
                                .contains(pattern.toLowerCase()))
                            .toList();
                      },
                      builder: (context, controller, focusNode) {
                        return TldsInputFormField(
                          suffixIcon: const Icon(Icons.arrow_drop_down),
                          focusNode: focusNode,
                          labelText: AppConstants.giver,
                          hintText: AppConstants.giver,
                          controller: controller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Select Employee';
                            }
                            return null;
                          },
                        );
                      },
                    );
                  },
                );
              }),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 44),
        Expanded(
            child: TldsInputFormField(
          controller: _newVoucherBloc.amountTextController,
          hintText: AppConstants.amount,
          labelText: AppConstants.amount,
        ))
      ],
    );
  }

  Widget _buildActionButton() {
    return CustomActionButtons(onPressed: () {}, buttonText: AppConstants.save);
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController date) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date.text.isEmpty
          ? DateTime.now()
          : AppUtils.appStringToDateTime(date.text),
      firstDate: DateTime(0001, 01, 01),
      lastDate: DateTime(9999, 12, 31),
    );
    if (picked != null) {
      final formattedDate = AppUtils.apiToAppDateFormat(picked.toString());
      _newVoucherBloc.voucherDateTextController.text = formattedDate;
    }
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
