import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tlbilling/components/custom_dropdown_button_form_field.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart' as tlbilling;
import 'package:tlbilling/utils/input_validation.dart';
import 'package:tlbilling/view/report/report_generate_pdf_dialog_bloc.dart';
import 'package:tlds_flutter/export.dart';

class GeneratePdfDialog extends StatefulWidget {
  const GeneratePdfDialog({super.key});

  @override
  State<GeneratePdfDialog> createState() => _GeneratePdfDialogState();
}

class _GeneratePdfDialogState extends State<GeneratePdfDialog> {
  final _appColors = AppColors();
  final _genratePdfDialogBlocImpl = GenratePdfDialogBlocImpl();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _appColors.whiteColor,
      surfaceTintColor: _appColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.all(10),
      title: _buildEmployeeFormTitle(),
      content: _buildSelectBranchAndFilterDate(),
      actions: [_buildGenerateButton()],
    );
  }

  _buildEmployeeFormTitle() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            tlbilling.AppWidgetUtils.buildText(
              text: AppConstants.overAllSalesReport,
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

  _buildSelectBranchAndFilterDate() {
    return SingleChildScrollView(
      child: Form(
        key: _genratePdfDialogBlocImpl.formkey,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          //height: MediaQuery.of(context).size.height * 0.3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildSelectBranch(),
                _buildSelectDate(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildSelectDate() {
    return Row(
      children: [
        Expanded(
          child: TldsDatePicker(
            controller: _genratePdfDialogBlocImpl.fromDateTextEdit,
            height: 70,
            hintText: AppConstants.fromDate,
            fontSize: 14,
            validator: (String? value) {
              if (value!.isEmpty) {
                return AppConstants.selectFromDate;
              }
              return '';
            },
            requiredLabelText: tlbilling.AppWidgetUtils.labelTextWithRequired(
              AppConstants.fromDate,
              fontSize: 13,
            ),
          ),
        ),
        tlbilling.AppWidgetUtils.buildSizedBox(custWidth: 14),
        Expanded(
          child: TldsDatePicker(
            hintText: AppConstants.toDate,
            controller: _genratePdfDialogBlocImpl.toDateTextEdit,
            height: 70,
            fontSize: 14,
            validator: (String? value) {
              if (value!.isEmpty) {
                return AppConstants.selectToDate;
              }
              return '';
            },
            requiredLabelText: tlbilling.AppWidgetUtils.labelTextWithRequired(
              AppConstants.toDate,
              fontSize: 13,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSelectBranch() {
    return FutureBuilder(
      future: _genratePdfDialogBlocImpl.getBranchName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text(AppConstants.loading);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<String>? branchNameList = snapshot.data?.result?.getAllBranchList
              ?.map((e) => e.branchName)
              .where((branchName) => branchName != null)
              .cast<String>()
              .toList();

          // Ensure the selected branch is in the list
          final selectedBranch =
              branchNameList!.contains(_genratePdfDialogBlocImpl.selectedBranch)
                  ? _genratePdfDialogBlocImpl.selectedBranch
                  : null;

          return CustomDropDownButtonFormField(
            height: 70,
            requiredLabelText:
                AppWidgetUtils.labelTextWithRequired(AppConstants.branch),
            dropDownItems: branchNameList,
            hintText: AppConstants.exSelect,
            dropDownValue: selectedBranch,
            validator: (value) {
              return InputValidations.branchValidation(value ?? '');
            },
            onChange: (String? newValue) {
              _genratePdfDialogBlocImpl.selectedBranch = newValue ?? '';
            },
          );
        } else {
          return const Text(AppConstants.noData);
        }
      },
    );
  }

  _buildGenerateButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: CustomElevatedButton(
          height: 50,
          width: double.infinity,
          text: AppConstants.pdfGeneration,
          fontSize: 16,
          buttonBackgroundColor: AppColors().primaryColor,
          fontColor: AppColors().whiteColor,
          suffixIcon: SvgPicture.asset(AppConstants.icPdfPrint),
          onPressed: () {
            if (_genratePdfDialogBlocImpl.formkey.currentState!.validate()) {}
          }),
    );
  }
}
