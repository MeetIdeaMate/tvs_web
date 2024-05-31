import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/view/transfer/new_transfer/new_transfer_bloc.dart';
import 'package:tlds_flutter/export.dart';

class TransferDetails extends StatefulWidget {
  const TransferDetails({super.key});

  @override
  State<TransferDetails> createState() => _TransferDetailsState();
}

class _TransferDetailsState extends State<TransferDetails> {
  final _appColors = AppColors();
  final _transferBloc = NewTransferBlocImpl();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: _appColors.greyColor)),
            color: _appColors.transferDetailsContainerColor),
        width: MediaQuery.sizeOf(context).width * 0.36,
        child: Padding(
          padding: const EdgeInsets.all(
            12,
          ),
          child: _buildTransferDetails(),
        ));
  }

  Widget _buildTransferDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCustomTextWidget(AppConstants.transferDetails,
            color: _appColors.primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.w700),
        _buildDefaultHeight(),
        _buildSelectFromAndToBranch(),
      ],
    );
  }

  Widget _buildSelectFromAndToBranch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCustomTextWidget(AppConstants.selectFromBranchAndToBranch),
        _buildDefaultHeight(),
        _buildFromBranchAndToBranch(),
        _buildDefaultHeight(),
        _buildTransPorterDetails(),
      ],
    );
  }

  Widget _buildFromBranchAndToBranch() {
    return FutureBuilder(
      future: _transferBloc.getBranches(),
      builder: (context, snapshot) {
        List<String> branchNameList =
            snapshot.data?.map((e) => e.branchName ?? '').toList() ?? [];
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TldsDropDownButtonFormField(
              height: 40,
              width: MediaQuery.sizeOf(context).width * 0.15,
              hintText: AppConstants.fromBranch,
              dropDownItems: branchNameList,
              dropDownValue: _transferBloc.selectedBranch,
              onChange: (String? newValue) {
                _transferBloc.selectedBranch = newValue ?? '';
              },
            ),
            SvgPicture.asset(AppConstants.icSwapArrow),
            TldsDropDownButtonFormField(
              height: 40,
              width: MediaQuery.sizeOf(context).width * 0.15,
              hintText: AppConstants.toBranch,
              dropDownItems: branchNameList,
              dropDownValue: _transferBloc.selectedBranch,
              onChange: (String? newValue) {
                _transferBloc.selectedBranch = newValue ?? '';
              },
            ),
          ],);
      },
    );
  }

  Widget _buildTransPorterDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCustomTextWidget(AppConstants.transporterDetails,
            color: _appColors.primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 22),
        _buildDefaultHeight(),
        _buildTransporterFilterAndAddNewTransporter(),
        _buildDefaultHeight(),
        _buildTransporterDetailsCard(),
        _buildDefaultHeight(),
        CustomActionButtons(onPressed: () {}, buttonText: AppConstants.save)
      ],
    );
  }

  Widget _buildTransporterFilterAndAddNewTransporter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TldsDropDownButtonFormField(
          height: 40,
          width: MediaQuery.sizeOf(context).width * 0.21,
          hintText: AppConstants.selectTransporter,
          dropDownItems: _transferBloc.branch,
          onChange: (String? newValue) {
            _transferBloc.selectedBranch = newValue ?? '';
          },
        ),
        CustomElevatedButton(
          height: 40,
          width: MediaQuery.sizeOf(context).width * 0.12,
          text: AppConstants.addNew,
          fontSize: 16,
          buttonBackgroundColor: _appColors.primaryColor,
          fontColor: _appColors.whiteColor,
          suffixIcon: SvgPicture.asset(AppConstants.icHumanAdd),
        )
      ],
    );
  }

  Widget _buildTransporterDetailsCard() {
    return Card(
        elevation: 0,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
              color: _appColors.transferDetailsContainerColor, width: 1),
        ),
        surfaceTintColor: _appColors.whiteColor,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCustomTextWidget('AK Logistics Private Limited.',
                  color: _appColors.primaryColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
              _buildDefaultHeight(
                  height: MediaQuery.sizeOf(context).width * 0.020),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(AppConstants.icCall),
                      AppWidgetUtils.buildSizedBox(custWidth: 10),
                      _buildCustomTextWidget('+91 9876543210', fontSize: 14),
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(AppConstants.icMail),
                      AppWidgetUtils.buildSizedBox(custWidth: 10),
                      _buildCustomTextWidget('ajith@techlambdas.com',
                          fontSize: 14),
                    ],
                  )
                ],
              ),
              _buildDefaultHeight(
                  height: MediaQuery.sizeOf(context).width * 0.020),
              TldsInputFormField(
                controller: _transferBloc.transporterVehicleNumberController,
                width: MediaQuery.sizeOf(context).width,
                hintText: AppConstants.vehicleNumber,
              )
            ],
          ),
        ));
  }

  Widget _buildCustomTextWidget(String text,
      {Color? color, FontWeight? fontWeight, double? fontSize}) {
    return Text(
      text,
      style: GoogleFonts.nunitoSans(
          color: color, fontWeight: fontWeight, fontSize: fontSize),
    );
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
