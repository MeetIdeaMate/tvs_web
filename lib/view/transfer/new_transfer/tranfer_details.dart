import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/models/get_model/get_all_stocks_without_pagination.dart';
import 'package:tlbilling/models/post_model/add_new_transfer.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/transfer/new_transfer/new_transfer_bloc.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';

class TransferDetails extends StatefulWidget {
  final NewTransferBlocImpl? newTransferBloc;

  const TransferDetails({super.key, this.newTransferBloc});

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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: AppWidgetUtils.buildLoading(),
          );
        } else if (snapshot.hasData) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder(
                stream: _transferBloc.fromBranchNameListStreamController,
                builder: (context, snapshot) {
                  return TldsDropDownButtonFormField(
                    height: 40,
                    width: MediaQuery.sizeOf(context).width * 0.15,
                    hintText: AppConstants.fromBranch,
                    dropDownItems: branchNameList,
                    dropDownValue: _transferBloc.selectedFromBranch,
                    onChange: (String? newValue) async {
                      _transferBloc.selectedFromBranch = newValue ?? '';
                      _transferBloc.toBranchNameList = [];
                      _transferBloc.toBranchNameListStream(false);
                      await Future.delayed(Duration.zero);
                      _transferBloc.toBranchNameList = branchNameList
                          .where((element) =>
                              element != _transferBloc.selectedFromBranch)
                          .toList();
                      _transferBloc.selectedToBranch = null;
                      _transferBloc.toBranchNameListStream(true);
                    },
                  );
                },
              ),
              SvgPicture.asset(AppConstants.icSwapArrow),
              StreamBuilder(
                stream: _transferBloc.toBranchNameListStreamController,
                builder: (context, snapshot) {
                  return TldsDropDownButtonFormField(
                    height: 40,
                    width: MediaQuery.sizeOf(context).width * 0.15,
                    hintText: AppConstants.toBranch,
                    dropDownItems: _transferBloc.toBranchNameList,
                    dropDownValue: _transferBloc.selectedToBranch,
                    onChange: (String? newValue) {
                      _transferBloc.selectedToBranch = newValue ?? '';
                    },
                  );
                },
              )
            ],
          );
        }
        return Center(
          child: SvgPicture.asset(AppConstants.imgNoData),
        );
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
        CustomActionButtons(
            onPressed: () {
              AddNewTransfer? addNewTransferObj;
              for (GetAllStocksWithoutPaginationModel element
                  in widget.newTransferBloc?.selectedList ?? []) {
                addNewTransferObj = AddNewTransfer(
                    transferFromBranch:
                        _transferBloc.selectedFromBranch,
                    transferToBranch: _transferBloc.selectedToBranch,
                    transferItems: [
                      TransferItem(
                          categoryId: element.categoryId,
                          addNewTransferMainSpecValue:
                              AddNewTransferMainSpecValue(
                                  engineNo: element.mainSpecValue?.engineNo,
                                  frameNo: element.mainSpecValue?.frameNo),
                          partNo: element.partNo,
                          quantity: element.quantity)
                    ]);
              }
              print('************req obj********${addNewTransferObj?.toJson()}');
              widget.newTransferBloc?.createNewTransfer(addNewTransferObj!);
            },
            buttonText: AppConstants.save)
      ],
    );
  }

  Widget _buildTransporterFilterAndAddNewTransporter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FutureBuilder(
          future: _transferBloc.getAllTransportsWithoutPagination(),
          builder: (context, snapshot) {
            List<String> transportersNames =
                snapshot.data?.map((e) => e.transportName ?? '').toList() ?? [];
            return TldsDropDownButtonFormField(
              height: 40,
              width: MediaQuery.sizeOf(context).width * 0.21,
              hintText: AppConstants.selectTransporter,
              dropDownItems: transportersNames,
              dropDownValue: _transferBloc.selectedTransporterName,
              onChange: (String? newValue) {
                _transferBloc.selectedTransporterName = newValue ?? '';
                _transferBloc.selectedTransporterName != null
                    ? _transferBloc.transporterDetailsStream(true)
                    : null;
                _transferBloc.selectedTransporterId = snapshot.data
                    ?.firstWhere((element) => element.transportName == newValue)
                    .transportId;
                _transferBloc.getTransporterDetailById().then((value) {
                  _transferBloc.transporterName = value?.transportName;
                  _transferBloc.transporterMobileNumber = value?.mobileNo;
                  _transferBloc.transporterDetailsStream(true);
                });
              },
            );
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
    return StreamBuilder(
      stream: _transferBloc.transporterDetailsStreamController,
      builder: (context, snapshot) {
        return _transferBloc.selectedTransporterName != null
            ? FutureBuilder(
                future: null,
                builder: (context, snapshot) {
                  return Card(
                      elevation: 0,
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                            color: _appColors.transferDetailsContainerColor,
                            width: 1),
                      ),
                      surfaceTintColor: _appColors.whiteColor,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildCustomTextWidget(
                                    _transferBloc.transporterName ?? '',
                                    color: _appColors.primaryColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400),
                                IconButton(
                                    color: _appColors.red,
                                    onPressed: () {
                                      _transferBloc.selectedTransporterName =
                                          null;
                                      _transferBloc.selectedTransporterId =
                                          null;
                                      _transferBloc
                                          .transporterDetailsStream(true);
                                    },
                                    icon: const Icon(Icons.close))
                              ],
                            ),
                            _buildDefaultHeight(
                                height:
                                    MediaQuery.sizeOf(context).width * 0.020),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(AppConstants.icCall),
                                    AppWidgetUtils.buildSizedBox(custWidth: 10),
                                    _buildCustomTextWidget(
                                        _transferBloc.transporterMobileNumber ??
                                            '',
                                        fontSize: 14),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(AppConstants.icMail),
                                    AppWidgetUtils.buildSizedBox(custWidth: 10),
                                    _buildCustomTextWidget(
                                        _transferBloc.transporterMailId ?? '',
                                        fontSize: 14),
                                  ],
                                )
                              ],
                            ),
                            _buildDefaultHeight(
                                height:
                                    MediaQuery.sizeOf(context).width * 0.020),
                            TldsInputFormField(
                              controller: _transferBloc
                                  .transporterVehicleNumberController,
                              width: MediaQuery.sizeOf(context).width,
                              hintText: AppConstants.vehicleNumber,
                            )
                          ],
                        ),
                      ));
                },
              )
            : Container();
      },
    );
  }

  Widget _buildCustomTextWidget(String text,
      {Color? color, FontWeight? fontWeight, double? fontSize}) {
    return Text(
      text,
      style: GoogleFonts.nunitoSans(
          color: color, fontWeight: fontWeight, fontSize: fontSize),
    );
  }

  /*Widget? _buildDefaultWidth({double? width}) {
    return AppWidgetUtils.buildSizedBox(
        custWidth: width ?? MediaQuery.sizeOf(context).width * 0.01);
  }*/

  Widget _buildDefaultHeight({double? height}) {
    return AppWidgetUtils.buildSizedBox(
        custHeight: height ?? MediaQuery.sizeOf(context).height * 0.02);
  }
}
