import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/components/custom_dropdown_button_form_field.dart';
import 'package:tlbilling/components/custom_form_field.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/input_validation.dart';
import 'package:tlbilling/view/employee/create_employee_dialog_bloc.dart';
import 'package:tlbilling/view/employee/employee_view_bloc.dart';
import 'package:tlbilling/view/user/create_user_dialog_bloc.dart';
import 'package:tlbilling/view/voucher_receipt/new_voucher/new_voucher_bloc.dart';
import 'package:toastification/toastification.dart';

class CreateEmployeeDialog extends StatefulWidget {
  final EmployeeViewBlocImpl? employeeViewBloc;
  final String? employeeId;
  final CreateUserDialogBlocImpl? createUserDialogBlocImpl;
  final NewVoucherBlocImpl? newVoucherBloc;

  const CreateEmployeeDialog(
      {super.key,
      this.newVoucherBloc,
      this.employeeViewBloc,
      this.employeeId,
      this.createUserDialogBlocImpl});

  @override
  State<CreateEmployeeDialog> createState() => _CreateEmployeeDialogState();
}

class _CreateEmployeeDialogState extends State<CreateEmployeeDialog> {
  final _appColors = AppColors();
  final _createEmployeeDialogBlocImpl = CreateEmployeeDialogBlocImpl();
  bool _isLoading = false;

  void _isLoadingState({required bool state}) {
    setState(() {
      _isLoading = state;
    });
  }

  @override
  void initState() {
    super.initState();
    _getEditEmployeeDetailsById();
  }

  void _getEditEmployeeDetailsById() {
    _createEmployeeDialogBlocImpl
        .getEmployeeById(widget.employeeId ?? '')
        .then((value) {
      _createEmployeeDialogBlocImpl.empNameController.text =
          value?.employeeName ?? '';
      _createEmployeeDialogBlocImpl.empAgeController.text =
          value?.age.toString() ?? '';
      _createEmployeeDialogBlocImpl.empCityEditText.text = value?.city ?? '';
      _createEmployeeDialogBlocImpl.empMobNoController.text =
          value?.mobileNumber ?? '';
      _createEmployeeDialogBlocImpl.empEmailController.text =
          value?.emailId ?? '';
      _createEmployeeDialogBlocImpl.empaddressController.text =
          value?.address ?? '';
      _createEmployeeDialogBlocImpl.selectedEmpBranch = value?.branchName ?? '';
      _createEmployeeDialogBlocImpl.selectEmpGender = value?.gender ?? '';
      _createEmployeeDialogBlocImpl.selectedEmpType = value?.designation ?? '';

      _createEmployeeDialogBlocImpl.selectGenderStreamController(true);
      _createEmployeeDialogBlocImpl.selectBranchStreamController(true);
      _createEmployeeDialogBlocImpl.selectDesiganationStreamController(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: AppWidgetUtils.buildLoading(),
      child: AlertDialog(
        backgroundColor: _appColors.whiteColor,
        surfaceTintColor: _appColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.all(10),
        title: _buildEmployeeFormTitle(),
        actions: [
          _buildSaveButton(),
        ],
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: _buildEmployeeCreateForm(),
          ),
        ),
      ),
    );
  }

  _buildEmployeeFormTitle() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppWidgetUtils.buildText(
              text: widget.employeeId == null
                  ? AppConstants.addEmployee
                  : AppConstants.upadteEmployee,
              fontSize: 22,
              color: _appColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  _buildEmployeeCreateForm() {
    return Form(
      key: _createEmployeeDialogBlocImpl.empFormkey,
      child: Column(
        children: [
          AppWidgetUtils.buildSizedBox(custHeight: 10),
          _buildEmpNameAndEmailFields(),
          _empTypeAndBranchFields(),
          AppWidgetUtils.buildSizedBox(custHeight: 13),
          _buildAgeGenderAndCityFields(),
          AppWidgetUtils.buildSizedBox(custHeight: 13),
          _buildMobNoAndAddressFields(),
        ],
      ),
    );
  }

  _buildEmpNameAndEmailFields() {
    return Row(
      children: [
        _buildEmployeenNameFields(),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        _buildEmployeeEmailFields(),
      ],
    );
  }

  Widget _buildEmployeeEmailFields() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: CustomFormField(
            suffixIcon: SvgPicture.asset(
              colorFilter:
                  ColorFilter.mode(_appColors.primaryColor, BlendMode.srcIn),
              AppConstants.icMail,
              fit: BoxFit.none,
            ),
            validator: (value) {
              return InputValidations.mailValidation(value ?? '');
            },
            labelText: AppConstants.emailAddress,
            hintText: AppConstants.hintMail,
            controller: _createEmployeeDialogBlocImpl.empEmailController),
      ),
    );
  }

  Widget _buildEmployeenNameFields() {
    return Expanded(
      child: CustomFormField(
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[A-Z a-z @]'))
          ],
          height: 70,
          suffixIcon: SvgPicture.asset(
            colorFilter:
                ColorFilter.mode(_appColors.primaryColor, BlendMode.srcIn),
            AppConstants.icPerson,
            fit: BoxFit.none,
          ),
          requiredLabelText:
              AppWidgetUtils.labelTextWithRequired(AppConstants.empName),
          validator: (value) {
            return InputValidations.nameValidation(value ?? '');
          },
          hintText: AppConstants.hintName,
          controller: _createEmployeeDialogBlocImpl.empNameController),
    );
  }

  _empTypeAndBranchFields() {
    return Row(
      children: [
        _buildEmployeeDesignation(),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        _buildEmployeeBranch()
      ],
    );
  }

  Widget _buildEmployeeBranch() {
    return Expanded(
      child: StreamBuilder<bool>(
          stream: _createEmployeeDialogBlocImpl.selectBranchStream,
          builder: (context, snapshot) {
            return FutureBuilder(
              future: _createEmployeeDialogBlocImpl.getBranchName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(AppConstants.loading);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  List<String>? branchNameList = snapshot
                      .data?.result?.getAllBranchList
                      ?.map((e) => e.branchName)
                      .where((branchName) => branchName != null)
                      .cast<String>()
                      .toList();

                  // Ensure the selected branch is in the list
                  final selectedBranch = branchNameList!.contains(
                          _createEmployeeDialogBlocImpl.selectedEmpBranch)
                      ? _createEmployeeDialogBlocImpl.selectedEmpBranch
                      : null;

                  return CustomDropDownButtonFormField(
                    height: 70,
                    requiredLabelText: AppWidgetUtils.labelTextWithRequired(
                        AppConstants.branch),
                    dropDownItems: branchNameList,
                    hintText: AppConstants.exSelect,
                    dropDownValue: selectedBranch,
                    validator: (value) {
                      return InputValidations.branchValidation(value ?? '');
                    },
                    onChange: (String? newValue) {
                      var employeeValue =
                          snapshot.data?.result?.getAllBranchList?.firstWhere(
                              (element) => element.branchName == newValue);
                      _createEmployeeDialogBlocImpl.selectEmpBranchId =
                          employeeValue?.branchId;
                      _createEmployeeDialogBlocImpl.selectedEmpBranch =
                          newValue ?? '';
                    },
                  );
                } else {
                  return const Text(AppConstants.noData);
                }
              },
            );
          }),
    );
  }

  Widget _buildEmployeeDesignation() {
    return Expanded(
      child: StreamBuilder<bool>(
          stream: _createEmployeeDialogBlocImpl.selectDesignationStream,
          builder: (context, snapshot) {
            return FutureBuilder(
              future: _createEmployeeDialogBlocImpl.getConfigByIdModel(
                  configId: AppConstants.designation),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(AppConstants.loading);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  List<String>? designationList =
                      snapshot.data?.map((e) => e).cast<String>().toList();

                  // Ensure the selected type is in the list
                  final selectedType = designationList!.contains(
                          _createEmployeeDialogBlocImpl.selectedEmpType)
                      ? _createEmployeeDialogBlocImpl.selectedEmpType
                      : null;

                  return CustomDropDownButtonFormField(
                    height: 70,
                    requiredLabelText: AppWidgetUtils.labelTextWithRequired(
                        AppConstants.empType),
                    dropDownItems: designationList,
                    dropDownValue: selectedType,
                    validator: (value) {
                      return InputValidations.empTypeValidation(value ?? '');
                    },
                    hintText: AppConstants.exSelect,
                    onChange: (String? newValue) {
                      _createEmployeeDialogBlocImpl.selectedEmpType =
                          newValue ?? '';
                    },
                  );
                } else {
                  return const Text(AppConstants.noData);
                }
              },
            );
          }),
    );
  }

  _buildAgeGenderAndCityFields() {
    return Row(
      children: [
        _buildEmployeeAgeFields(),
        AppWidgetUtils.buildSizedBox(custWidth: 12),
        _buildEmpGenderDropdown(),
        AppWidgetUtils.buildSizedBox(custWidth: 12),
        _buildEmpCityFields()
      ],
    );
  }

  Widget _buildEmpCityFields() {
    return Expanded(
      flex: 2,
      child: CustomFormField(
          requiredLabelText:
              AppWidgetUtils.labelTextWithRequired(AppConstants.city),
          validator: (value) {
            return InputValidations.cityValidation(value ?? '');
          },
          hintText: AppConstants.hintCity,
          controller: _createEmployeeDialogBlocImpl.empCityEditText),
    );
  }

  Widget _buildEmpGenderDropdown() {
    return Expanded(
      child: StreamBuilder<bool>(
          stream: _createEmployeeDialogBlocImpl.selectGenderStream,
          builder: (context, snapshot) {
            return FutureBuilder(
              future: _createEmployeeDialogBlocImpl.getConfigByIdModel(
                  configId: AppConstants.gender),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(AppConstants.loading);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  List<String>? genderList =
                      snapshot.data?.map((e) => e).cast<String>().toList();

                  // Ensure the selected gender is in the list
                  final selectedGender = genderList!.contains(
                          _createEmployeeDialogBlocImpl.selectEmpGender)
                      ? _createEmployeeDialogBlocImpl.selectEmpGender
                      : null;

                  return CustomDropDownButtonFormField(
                    requiredLabelText: AppWidgetUtils.labelTextWithRequired(
                        AppConstants.gender),
                    dropDownItems: genderList,
                    dropDownValue: selectedGender,
                    hintText: AppConstants.exSelect,
                    validator: (value) {
                      return InputValidations.genderValidation(value ?? '');
                    },
                    onChange: (String? newValue) {
                      _createEmployeeDialogBlocImpl.selectEmpGender =
                          newValue ?? '';
                    },
                  );
                } else {
                  return const Text(AppConstants.noData);
                }
              },
            );
          }),
    );
  }

  Widget _buildEmployeeAgeFields() {
    return Expanded(
      child: CustomFormField(
          maxLength: 2,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          labelText: AppConstants.age,
          hintText: AppConstants.hintAge,
          controller: _createEmployeeDialogBlocImpl.empAgeController),
    );
  }

  _buildMobNoAndAddressFields() {
    return Row(
      children: [
        _buildEmpMobileNoFields(),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        _buildEmployeeAdress(),
      ],
    );
  }

  Widget _buildEmployeeAdress() {
    return Expanded(
      child: CustomFormField(
          requiredLabelText:
              AppWidgetUtils.labelTextWithRequired(AppConstants.address),
          validator: (value) {
            return InputValidations.addressValidation(value ?? '');
          },
          hintText: AppConstants.typeHere,
          controller: _createEmployeeDialogBlocImpl.empaddressController),
    );
  }

  Widget _buildEmpMobileNoFields() {
    return Expanded(
      child: CustomFormField(
          suffixIcon: SvgPicture.asset(
            colorFilter:
                ColorFilter.mode(_appColors.primaryColor, BlendMode.srcIn),
            AppConstants.icCall,
            fit: BoxFit.none,
          ),
          maxLength: 10,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          requiredLabelText:
              AppWidgetUtils.labelTextWithRequired(AppConstants.mobileNumber),
          validator: (value) {
            return InputValidations.mobileNumberValidation(value ?? '');
          },
          hintText: AppConstants.exMobNo,
          controller: _createEmployeeDialogBlocImpl.empMobNoController),
    );
  }

  _buildSaveButton() {
    return CustomActionButtons(
        buttonText: widget.employeeId == null
            ? AppConstants.addEmployee
            : AppConstants.upadteEmployee,
        onPressed: () {
          if (_createEmployeeDialogBlocImpl.empFormkey.currentState!
              .validate()) {
            _isLoadingState(state: true);
            _createEmployeeDialogBlocImpl.onboardNewEmployee(
              (statusCode) {
                if (widget.employeeId == null) {
                  _buildCreateEmployee(statusCode);
                } else {
                  return _buildEditEmployee();
                }
              },
            );
          }
        });
  }

  void _buildCreateEmployee(int? statusCode) {
    if (statusCode == 200 || statusCode == 201) {
      _isLoadingState(state: false);
      Navigator.pop(context);
      AppWidgetUtils.buildToast(
          context,
          ToastificationType.success,
          AppConstants.employeeCreate,
          Icon(
            Icons.check_circle_outline_rounded,
            color: _appColors.successColor,
          ),
          AppConstants.employeeCreatedSuccessfully,
          _appColors.successLightColor);
      widget.employeeViewBloc?.employeeTableViewStream(true);
      widget.createUserDialogBlocImpl?.employeeNameSelectStream(true);
      widget.newVoucherBloc?.payToTextStreamController(true);
      widget.newVoucherBloc?.giverTextStreamController(true);
    } else if (statusCode == 409) {
      AppWidgetUtils.buildToast(
          context,
          ToastificationType.error,
          AppConstants.empAlreadyCreated,
          Icon(Icons.error_outline, color: _appColors.errorColor),
          AppConstants.addNewEmployee,
          _appColors.errorLightColor);
    } else {
      _isLoadingState(state: false);
      AppWidgetUtils.buildToast(
          context,
          ToastificationType.error,
          AppConstants.employeeCreate,
          Icon(
            Icons.error_outline_outlined,
            color: _appColors.errorColor,
          ),
          AppConstants.somethingWentWrong,
          _appColors.errorLightColor);
    }
  }

  Future<void> _buildEditEmployee() {
    return _createEmployeeDialogBlocImpl.updateEmployee(widget.employeeId ?? '',
        (statusCode) {
      if (statusCode == 200 || statusCode == 201) {
        _isLoadingState(state: false);
        Navigator.pop(context);
        AppWidgetUtils.buildToast(
            context,
            ToastificationType.success,
            AppConstants.employeeUpdate,
            Icon(
              Icons.check_circle_outline_rounded,
              color: _appColors.successColor,
            ),
            AppConstants.employeeUpdateSuccessfully,
            _appColors.successLightColor);
        widget.employeeViewBloc?.pageNumberUpdateStreamController(0);
      } else {
        _isLoadingState(state: false);
        AppWidgetUtils.buildToast(
            context,
            ToastificationType.error,
            AppConstants.employeeUpdate,
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
