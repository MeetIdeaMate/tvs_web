import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/components/custom_dropdown_button_form_field.dart';
import 'package:tlbilling/models/get_all_employee_model.dart';
import 'package:tlbilling/models/parent_response_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/input_validation.dart';
import 'package:tlbilling/view/employee/create_employee_dialog.dart';
import 'package:tlbilling/view/user/create_user_dialog_bloc.dart';
import 'package:tlbilling/view/user/user_view_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_formaters.dart';
import 'package:tlds_flutter/util/app_colors.dart';
import 'package:toastification/toastification.dart';

class CreateUserDialog extends StatefulWidget {
  final UserViewBlocImpl userViewBloc;
  const CreateUserDialog({super.key, required this.userViewBloc});

  @override
  State<CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  final _appColors = AppColors();
  final _createUserDialogBlocImpl = CreateUserDialogBlocImpl();
  bool _isLoading = false;
  void _isLoadingState({required bool state}) {
    setState(() {
      _isLoading = state;
    });
  }

  Future<void> getBranchName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _createUserDialogBlocImpl.branchId = prefs.getString('branchId') ?? '';
    });
  }

  @override
  void initState() {
    getBranchName();
    super.initState();
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
        title: _buildUserFormTitle(),
        actions: [
          _buildSaveButton(),
        ],
        content: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.4,
          // height: 300,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: _buildUserCreateForm(),
          ),
        ),
      ),
    );
  }

  _buildUserFormTitle() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppWidgetUtils.buildText(
              text: AppConstants.addUser,
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

  _buildUserCreateForm() {
    return SingleChildScrollView(
      child: Form(
        key: _createUserDialogBlocImpl.userFormKey,
        child: Column(
          children: [
            AppWidgetUtils.buildSizedBox(custHeight: 10),
            _buildUserNameAndMobNoFields(),
            _buildDesignationAndPasswordFields(),
            AppWidgetUtils.buildSizedBox(custHeight: 15),
            if (widget.userViewBloc.isMainBranch ?? false) _buildSelectBranch()
          ],
        ),
      ),
    );
  }

  _buildUserNameAndMobNoFields() {
    return Row(children: [
      Expanded(
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(
          child: StreamBuilder<bool>(
              stream: _createUserDialogBlocImpl.employeeSelectStream,
              builder: (context, snapshot) {
                return FutureBuilder<ParentResponseModel>(
                  future: _createUserDialogBlocImpl.getEmployeeName(),
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

                    return TypeAheadField<String>(
                      controller:
                          _createUserDialogBlocImpl.employeeNameEditText,
                      suggestionsCallback: (search) => employeeNamesList
                          .where((name) =>
                              name.toLowerCase().contains(search.toLowerCase()))
                          .toList(),
                      itemBuilder: (context, suggestion) {
                        var selectedemployee = employeesList.firstWhere(
                          (employee) => employee.employeeName == suggestion,
                        );
                        return ListTile(
                          title: Text(suggestion),
                          subtitle: Text(
                            ' ${selectedemployee.mobileNumber}',
                          ),
                          trailing: Text('${selectedemployee.city}'),
                        );
                      },
                      onSelected: (String? value) {
                        if (value != null) {
                          var selectedemployee = employeesList.firstWhere(
                            (employee) => employee.employeeName == value,
                          );
                          _createUserDialogBlocImpl.selectedEmpId =
                              selectedemployee.employeeId;
                          _createUserDialogBlocImpl.employeeNameEditText.text =
                              selectedemployee.employeeName.toString();

                          _buildEmployeeNameOnchange(
                              employeeName: selectedemployee.employeeName,
                              titles: employeesList);
                        }
                      },
                      builder: (context, controller, focusNode) {
                        return TldsInputFormField(
                          controller: controller,

                          focusNode: focusNode,
                          requiredLabelText:
                              AppWidgetUtils.labelTextWithRequired(
                                  AppConstants.username),
                          //prefixIcon: AppConstants.icSelectPaitent,
                          hintText: (snapshot.connectionState ==
                                  ConnectionState.waiting)
                              ? AppConstants.loading
                              : (snapshot.hasError || snapshot.data == null)
                                  ? AppConstants.errorLoading
                                  : AppConstants.exSelect,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return AppConstants.aadharDigitErrorText;
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
        AppWidgetUtils.buildSizedBox(custWidth: 6),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: IconButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                backgroundColor:
                    MaterialStateProperty.all(_appColors.primaryColor),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => CreateEmployeeDialog(
                      createUserDialogBlocImpl: _createUserDialogBlocImpl),
                );
              },
              icon: SvgPicture.asset(
                AppConstants.icaddUser,
              )),
        ),
      ])),
      AppWidgetUtils.buildSizedBox(custWidth: 14),
      _buildMobNoTextField()
    ]);
  }

  Expanded _buildMobNoTextField() {
    return Expanded(
      child: TldsInputFormField(
          inputFormatters: TldsInputFormatters.onlyAllowNumbers,
          maxLength: 10,
          counterText: '',
          suffixIcon: SvgPicture.asset(
            colorFilter:
                ColorFilter.mode(_appColors.primaryColor, BlendMode.srcIn),
            AppConstants.icCall,
            fit: BoxFit.none,
          ),
          requiredLabelText:
              AppWidgetUtils.labelTextWithRequired(AppConstants.mobileNumber),
          validator: (value) {
            return InputValidations.mobileNumberValidation(value ?? '');
          },
          hintText: AppConstants.hintMobileNo,
          controller: _createUserDialogBlocImpl.mobileNoTextController),
    );
  }

  _buildDesignationAndPasswordFields() {
    return Row(
      children: [
        Expanded(
          child: StreamBuilder<bool>(
              stream: _createUserDialogBlocImpl.selectedDesinationStream,
              builder: (context, snapshot) {
                return FutureBuilder(
                  future: _createUserDialogBlocImpl.getConfigByIdModel(
                      configId: AppConstants.designation),
                  builder: (context, snapshot) {
                    //  List<String> designationList = snapshot.data ?? [];
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CustomDropDownButtonFormField(
                          requiredLabelText:
                              AppWidgetUtils.labelTextWithRequired(
                                  AppConstants.designationText),
                          dropDownItems: (snapshot.hasData &&
                                  (snapshot.data?.isNotEmpty == true))
                              ? snapshot.data!
                              : List.empty(),
                          validator: (value) {
                            return InputValidations.designationValidation(
                                value ?? '');
                          },
                          hintText: (snapshot.connectionState ==
                                  ConnectionState.waiting)
                              ? AppConstants.loading
                              : (snapshot.hasError || snapshot.data == null)
                                  ? AppConstants.errorLoading
                                  : AppConstants.selectDesignation,
                          dropDownValue:
                              _createUserDialogBlocImpl.selectedDesignation,
                          onChange: null),
                    );
                  },
                );
              }),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        _buildPasswordTextField(),
      ],
    );
  }

  Widget _buildPasswordTextField() {
    return Expanded(
        child: StreamBuilder<bool>(
            stream: _createUserDialogBlocImpl.passwordVisibleStream,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.only(top: 18),
                child: TldsInputFormField(
                  labelText: AppConstants.passwordLable,
                  controller: _createUserDialogBlocImpl.passwordController,
                  hintText: AppConstants.passwordLable,
                  obscure: !_createUserDialogBlocImpl.ispasswordVisible,
                  suffixIcon: IconButton(
                    onPressed: () {
                      _createUserDialogBlocImpl.ispasswordVisible =
                          !_createUserDialogBlocImpl.ispasswordVisible;
                      _createUserDialogBlocImpl
                          .passwordVisbleStreamControler(true);
                    },
                    icon: Icon(
                        _createUserDialogBlocImpl.ispasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: _appColors.greyColor),
                  ),
                  validator: (validation) =>
                      InputValidations.passwordValidation(validation!),
                ),
              );
            }));
  }

  Widget _buildSelectBranch() {
    return FutureBuilder(
      future: _createUserDialogBlocImpl.getBranchName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text(AppConstants.loading);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if (snapshot.hasData) {
          final branchMap = {
            for (var branch in snapshot.data!.result!.getAllBranchList!)
              if (branch.branchName != null) branch.branchName!: branch.branchId
          };

          final branchNameList = branchMap.keys.toList();
          final selectedBranchName =
              branchMap.keys.contains(_createUserDialogBlocImpl.selectedBranch)
                  ? _createUserDialogBlocImpl.selectedBranch
                  : null;

          return CustomDropDownButtonFormField(
            height: 70,
            requiredLabelText:
                AppWidgetUtils.labelTextWithRequired(AppConstants.branch),
            dropDownItems: branchNameList,
            hintText: AppConstants.exSelect,
            dropDownValue: selectedBranchName,
            validator: (value) {
              return InputValidations.branchValidation(value ?? '');
            },
            onChange: (String? newValue) {
              _createUserDialogBlocImpl.selectedBranchId = branchMap[newValue];
              _createUserDialogBlocImpl.selectedBranch = newValue;
            },
          );
        } else {
          return const Text(AppConstants.noData);
        }
      },
    );
  }

  _buildSaveButton() {
    return CustomActionButtons(
        buttonText: AppConstants.addUser, onPressed: _buildOnPressed);
  }

  _buildOnPressed() {
    if (_createUserDialogBlocImpl.userFormKey.currentState!.validate()) {
      _isLoadingState(state: true);
      _createUserDialogBlocImpl.onboardNewUser(() {
        _isLoadingState(state: false);
        AppWidgetUtils.buildToast(
            context,
            ToastificationType.success,
            AppConstants.userCreated,
            Icon(Icons.check_circle_outline_rounded,
                color: AppColor().successColor),
            AppConstants.userCreateSuccessfully,
            AppColor().successLightColor);
        Navigator.pop(context);
        _isLoadingState(state: false);
        widget.userViewBloc.pageNumberUpdateStreamController(0);
      }, (statusCode) {
        if (statusCode == 409) {
          AppWidgetUtils.buildToast(
              context,
              ToastificationType.error,
              AppConstants.userAlreadyCreated,
              Icon(Icons.error_outline, color: AppColor().errorColor),
              AppConstants.selectDiffrentUser,
              AppColor().errorLightColor);
          _isLoadingState(state: false);
        }
      });
    }
    _isLoadingState(state: false);
  }

  void _buildEmployeeNameOnchange({
    String? employeeName,
    List<EmployeeListModel>? titles,
  }) {
    var selectedEmployee =
        titles?.firstWhere((element) => element.employeeName == employeeName);

    if (selectedEmployee != null) {
      _createUserDialogBlocImpl
          .getEmployeeById(selectedEmployee.employeeId.toString())
          .then((value) {
        _createUserDialogBlocImpl.employeeNameSelectStream(true);
        _createUserDialogBlocImpl.selectedDesinationStreamController(true);
        _createUserDialogBlocImpl.selectedUserName = value?.employeeName;
        _createUserDialogBlocImpl.mobileNoTextController.text =
            value?.mobileNumber ?? '';
        _createUserDialogBlocImpl.selectedDesignation = value?.designation;
      });
    }
  }
}
