import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/components/custom_dropdown_button_form_field.dart';
import 'package:tlbilling/components/custom_form_field.dart';
import 'package:tlbilling/models/get_model/get_all_branch_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlbilling/utils/input_validation.dart';
import 'package:tlbilling/view/branch/branch_view_bloc.dart';
import 'package:tlbilling/view/branch/create_branch_dialog_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_formaters.dart';
import 'package:toastification/toastification.dart';

class CreateBranchDialog extends StatefulWidget {
  final String? branchId;
  final BranchViewBlocImpl? branchViewBlocImpl;
  const CreateBranchDialog({super.key, this.branchId, this.branchViewBlocImpl});

  @override
  State<CreateBranchDialog> createState() => _CreateBranchDialogState();
}

class _CreateBranchDialogState extends State<CreateBranchDialog> {
  final _appColors = AppColors();
  final _createBranchDialogBlocImpl = CreateBranchDialogBlocImpl();

  @override
  void initState() {
    super.initState();
    if (widget.branchId != null) {
      _createBranchDialogBlocImpl.getBranchDetailsById(widget.branchId).then(
          (editableValueData) => _getEditBranchDetails(editableValueData));
    } else {
      _createBranchDialogBlocImpl.selectedIsMainOrSub = AppConstants.mainBranch;
    }
    _selectMainBranchStatus();
    _createBranchDialogBlocImpl.radioButtonStream(true);
  }

  _selectMainBranchStatus() {
    _createBranchDialogBlocImpl.selectedIsMainOrSub == AppConstants.mainBranch
        ? _createBranchDialogBlocImpl.isMainBranch = true
        : _createBranchDialogBlocImpl.isMainBranch = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
        inAsyncCall: _createBranchDialogBlocImpl.isAsyncCall,
        progressIndicator: AppWidgetUtils.buildLoading(),
        color: _appColors.whiteColor,
        child: AlertDialog(
          backgroundColor: _appColors.whiteColor,
          surfaceTintColor: _appColors.whiteColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.all(10),
          title: _buildCreateBranchTitle(),
          actions: [
            _buildSaveButton(),
          ],
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: _buildBranchCreateForm(),
            ),
          ),
        ));
  }

  _buildCreateBranchTitle() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppWidgetUtils.buildText(
              text: widget.branchId != null
                  ? AppConstants.updateBranch
                  : AppConstants.addBranch,
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

  _buildSaveButton() {
    return CustomActionButtons(
      buttonText: widget.branchId != null
          ? AppConstants.updateBranch
          : AppConstants.addBranch,
      onPressed: () {
        if (_createBranchDialogBlocImpl.branchFormKey.currentState!
            .validate()) {
          _isLoading(true);
          if (widget.branchId != null) {
            _createBranchDialogBlocImpl.updateBranch(
              widget.branchId,
              (statusCode) {
                if (statusCode == 200 || statusCode == 201) {
                  _isLoading(false);
                  widget.branchViewBlocImpl?.branchTablePageStream(0);
                  Navigator.pop(context);
                  AppWidgetUtils.buildToast(
                      context,
                      ToastificationType.success,
                      AppConstants.branchUpdated,
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: _appColors.successColor,
                      ),
                      AppConstants.branchUpdatedSuccessFully,
                      _appColors.successLightColor);
                } else {
                  _isLoading(false);
                }
              },
            );
          } else {
            _createBranchDialogBlocImpl.addBranch((statusCode) {
              if (statusCode == 200 || statusCode == 201) {
                _isLoading(false);
                widget.branchViewBlocImpl?.branchTablePageStream(0);
                Navigator.pop(context);
                AppWidgetUtils.buildToast(
                    context,
                    ToastificationType.success,
                    AppConstants.branchCreated,
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: _appColors.successColor,
                    ),
                    AppConstants.branchCreatedSuccessFully,
                    _appColors.successLightColor);
              } else {
                _isLoading(false);
              }
            });
          }
        }
      },
    );
  }

  _buildBranchCreateForm() {
    return SingleChildScrollView(
      child: Form(
        key: _createBranchDialogBlocImpl.branchFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSelectBranchRadioButton(),
            AppWidgetUtils.buildSizedBox(custHeight: 10),
            _buildBranchNameAndCityFields(),
            AppWidgetUtils.buildSizedBox(custHeight: 13),
            _buildMobNoPinCodeAndAddressFields(),
            AppWidgetUtils.buildSizedBox(custHeight: 13),
            _buildSelectBranchMainBranchFields(),
          ],
        ),
      ),
    );
  }

  _buildBranchNameAndCityFields() {
    return Row(
      children: [
        Expanded(
          child: CustomFormField(
              requiredLabelText:
                  AppWidgetUtils.labelTextWithRequired(AppConstants.branchName),
              validator: (value) {
                return InputValidations.branchValidation(value ?? '');
              },
              inputFormatters: TldsInputFormatters.onlyAllowAlphabetAndNumber,
              hintText: AppConstants.hintbranch,
              controller: _createBranchDialogBlocImpl.branchNameController),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        Expanded(
          child: _buildCityField(),
        ),
      ],
    );
  }

  Widget _buildCityField() {
    return FutureBuilder(
      future: _createBranchDialogBlocImpl.getCities(),
      builder: (context, snapshot) {
        return StreamBuilder<bool>(
            stream: _createBranchDialogBlocImpl.cityRefreshStream,
            builder: (context, streamSnapshot) {
              return CustomDropDownButtonFormField(
                // height: 72,
                requiredLabelText:
                    AppWidgetUtils.labelTextWithRequired(AppConstants.city),
                dropDownItems: snapshot.data ?? [],
                hintText: AppConstants.exSelect,
                dropDownValue: _createBranchDialogBlocImpl.selectedCity,
                validator: (value) {
                  return InputValidations.nameValidation(value ?? '');
                },
                onChange: (String? newValue) {
                  _createBranchDialogBlocImpl.selectedCity = newValue ?? '';
                },
              );
            });
      },
    );
  }

  _buildMobNoPinCodeAndAddressFields() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              CustomFormField(
                  requiredLabelText: AppWidgetUtils.labelTextWithRequired(
                      AppConstants.mobileNumber),
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    return InputValidations.mobileNumberValidation(value ?? '');
                  },
                  hintText: AppConstants.hintMobileNo,
                  controller: _createBranchDialogBlocImpl.mobileNoController),
              AppWidgetUtils.buildSizedBox(custHeight: 10),
              CustomFormField(
                  labelText: AppConstants.pinCode,
                  maxLength: 6,
                  inputFormatters: TlInputFormatters.onlyAllowNumbers,
                  validator: (value) {
                    return InputValidations.pinCodeValidation(value ?? '');
                  },
                  hintText: AppConstants.hintPinCode,
                  controller: _createBranchDialogBlocImpl.pinCodeController),
            ],
          ),
        ),
        AppWidgetUtils.buildSizedBox(custWidth: 14),
        Expanded(
          child: CustomFormField(
              requiredLabelText:
                  AppWidgetUtils.labelTextWithRequired(AppConstants.address),
              height: 128,
              maxLine: 100,
              validator: (value) {
                return InputValidations.addressValidation(value ?? '');
              },
              hintText: AppConstants.hintAddress,
              controller: _createBranchDialogBlocImpl.addressController),
        ),
      ],
    );
  }

  _buildSelectBranchMainBranchFields() {
    return StreamBuilder(
      stream: _createBranchDialogBlocImpl.radioButtonStreamController,
      builder: (context, snapshot) {
        return Row(
          children: [
            Visibility(
                visible: _createBranchDialogBlocImpl.selectedIsMainOrSub ==
                    AppConstants.subBranch,
                child: Expanded(
                  child: FutureBuilder(
                    future: _createBranchDialogBlocImpl.getBranchList(),
                    builder: (context, snapshot) {
                      List<GetAllBranchList>? getAllBranchList =
                          snapshot.data?.result?.getAllBranchList;
                      // This list only return the mainBranches
                      List<String>? branchNameList = getAllBranchList
                              ?.where((element) => element.mainBranch == true)
                              .map((e) => e.branchName ?? '')
                              .toList() ??
                          [];
                      return CustomDropDownButtonFormField(
                        // height: 72,
                        requiredLabelText: AppWidgetUtils.labelTextWithRequired(
                            AppConstants.mainBranch),
                        dropDownItems: branchNameList,
                        dropDownValue:
                            _createBranchDialogBlocImpl.mainBranchName,
                        hintText: AppConstants.exSelect,
                        validator: (value) {
                          return InputValidations.branchValidation(value ?? '');
                        },
                        onChange: (String? newValue) {
                          _createBranchDialogBlocImpl.mainBranchId =
                              getAllBranchList
                                  ?.firstWhere((element) =>
                                      element.branchName == newValue)
                                  .branchId;
                        },
                      );
                    },
                  ),
                )),
          ],
        );
      },
    );
  }

  _buildSelectBranchRadioButton() {
    return StreamBuilder(
      stream: _createBranchDialogBlocImpl.radioButtonStreamController,
      builder: (context, snapshot) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Row(
                children: [
                  Radio(
                      value: AppConstants.mainBranch,
                      groupValue:
                          _createBranchDialogBlocImpl.selectedIsMainOrSub,
                      onChanged: (String? value) {
                        _createBranchDialogBlocImpl.selectedIsMainOrSub = value;
                        _selectMainBranchStatus();
                        _createBranchDialogBlocImpl.radioButtonStream(true);
                      }),
                  Text(AppConstants.mainBranch,
                      style:
                          TextStyle(fontSize: 13, color: _appColors.blackColor))
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Radio(
                      value: AppConstants.subBranch,
                      groupValue:
                          _createBranchDialogBlocImpl.selectedIsMainOrSub,
                      onChanged: (String? value) {
                        _createBranchDialogBlocImpl.selectedIsMainOrSub = value;
                        _selectMainBranchStatus();
                        _createBranchDialogBlocImpl.radioButtonStream(true);
                      }),
                  Text(AppConstants.subBranch,
                      style:
                          TextStyle(fontSize: 13, color: _appColors.blackColor))
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getEditBranchDetails(
      GetAllBranchList? editableValueData) async {
    _createBranchDialogBlocImpl.isMainBranch = editableValueData?.mainBranch;
    editableValueData?.mainBranch == true
        ? _createBranchDialogBlocImpl.selectedIsMainOrSub =
            AppConstants.mainBranch
        : _createBranchDialogBlocImpl.selectedIsMainOrSub =
            AppConstants.subBranch;
    _createBranchDialogBlocImpl.radioButtonStream(true);
    _createBranchDialogBlocImpl.branchNameController.text =
        editableValueData?.branchName ?? '';
    _createBranchDialogBlocImpl.pinCodeController.text =
        editableValueData?.pinCode ?? '';
    _createBranchDialogBlocImpl.mobileNoController.text =
        editableValueData?.mobileNo ?? '';
    _createBranchDialogBlocImpl.selectedCity = editableValueData?.city ?? '';

    _createBranchDialogBlocImpl.cityRefreshStreamController(true);

    _createBranchDialogBlocImpl.addressController.text =
        editableValueData?.address ?? '';
    _createBranchDialogBlocImpl.mainBranchId = editableValueData?.mainBranchId;
    _createBranchDialogBlocImpl
        .getBranchDetailsById(_createBranchDialogBlocImpl.mainBranchId)
        .then((value) {
      _createBranchDialogBlocImpl.mainBranchName = value?.branchName ?? '';
    });
  }

  _isLoading(bool? isLoadingState) {
    setState(() {
      _createBranchDialogBlocImpl.isAsyncCall = isLoadingState;
    });
  }
}
