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
import 'package:toastification/toastification.dart';

class CreateEmployeeDialog extends StatefulWidget {
  final EmployeeViewBlocImpl employeeViewBloc;
  final String? employeeId;

  const CreateEmployeeDialog(
      {super.key, required this.employeeViewBloc, this.employeeId});

  @override
  State<CreateEmployeeDialog> createState() => _CreateEmployeeDialogState();
}

class _CreateEmployeeDialogState extends State<CreateEmployeeDialog> {
  final List<String>? empType = ['labor', 'supervisor'];
  final List<String>? empBranch = ['kvp', 'chennai'];
  final List<String>? empGender = ['male', 'Female', 'others'];
  final List<String>? city = ['kvp', 'chennai'];

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
          width: MediaQuery.sizeOf(context).width * 0.4,
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
              text: AppConstants.addEmployee,
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
          //AppWidgetUtils.buildSizedBox(custHeight: 13),
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
      child: FutureBuilder(
        future: _createEmployeeDialogBlocImpl.getBranchName(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the data is loading, you can show a loading indicator
            return const Text(AppConstants.loading);
          } else if (snapshot.hasError) {
            // If an error occurred while fetching data, you can show an error message
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            // When the data is successfully fetched
            List<String>? branchNameList = snapshot
                .data?.result?.getAllBranchList
                ?.map((e) => e.branchName)
                .where((branchName) => branchName != null)
                .cast<String>()
                .toList();

            return CustomDropDownButtonFormField(
              height: 70,
              requiredLabelText:
                  AppWidgetUtils.labelTextWithRequired(AppConstants.branch),
              dropDownItems: branchNameList ?? [],
              hintText: AppConstants.exSelect,
              validator: (value) {
                return InputValidations.branchValidation(value ?? '');
              },
              onChange: (String? newValue) {
                var employeeValue = snapshot.data?.result?.getAllBranchList
                    ?.firstWhere((element) => element.branchName == newValue);
                _createEmployeeDialogBlocImpl.selectEmpBranchId =
                    employeeValue?.branchId;
                _createEmployeeDialogBlocImpl.selectedEmpBranch =
                    newValue ?? '';
              },
            );
          } else {
            // In case there is no data and no error
            return const Text('No data available');
          }
        },
      ),
    );
  }

  Widget _buildEmployeeDesignation() {
    return Expanded(
      child: FutureBuilder(
        future: _createEmployeeDialogBlocImpl.getConfigByIdModel(
            configId: AppConstants.designation),
        builder: (context, snapshot) {
          return CustomDropDownButtonFormField(
            height: 70,
            requiredLabelText:
                AppWidgetUtils.labelTextWithRequired(AppConstants.empType),
            dropDownItems: snapshot.data ?? [],
            validator: (value) {
              return InputValidations.empTypeValidation(value ?? '');
            },
            hintText: (snapshot.connectionState == ConnectionState.waiting)
                ? AppConstants.loading
                : (snapshot.hasError || snapshot.data == null)
                    ? AppConstants.errorLoading
                    : AppConstants.exSelect,
            onChange: (String? newValue) {
              _createEmployeeDialogBlocImpl.selectedEmpType = newValue ?? '';
            },
          );
        },
      ),
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
      child: FutureBuilder(
        future: _createEmployeeDialogBlocImpl.getConfigByIdModel(
            configId: AppConstants.gender),
        builder: (context, snapshot) {
          return CustomDropDownButtonFormField(
            //height: 50,
            requiredLabelText:
                AppWidgetUtils.labelTextWithRequired(AppConstants.gender),
            dropDownItems: snapshot.data ?? [],
            hintText: AppConstants.exSelect,
            validator: (value) {
              return InputValidations.genderValidation(value ?? '');
            },
            onChange: (String? newValue) {
              _createEmployeeDialogBlocImpl.selectEmpGender = newValue ?? '';
            },
          );
        },
      ),
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
        buttonText: AppConstants.addEmployee,
        onPressed: () {
          if (_createEmployeeDialogBlocImpl.empFormkey.currentState!
              .validate()) {
            _isLoadingState(state: true);
            _buildCreateEmployee();
          }
        });
  }

  Future<void> _buildCreateEmployee() {
    return _createEmployeeDialogBlocImpl.onboardNewEmployee(
      (statusCode) {
        if (widget.employeeId == null) {
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
            widget.employeeViewBloc.employeeTableViewStream(true);
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
        } else {
          return _createEmployeeDialogBlocImpl
              .updateEmployee(widget.employeeId ?? '', (statusCode) {
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
              widget.employeeViewBloc.employeeTableViewStream(true);
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
      },
    );
  }
}
