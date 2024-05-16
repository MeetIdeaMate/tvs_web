import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/transfer/new_transfer/new_transfer.dart';
import 'package:tlbilling/view/transfer/transfer_view_bloc.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';

class TransferView extends StatefulWidget {
  const TransferView({super.key});

  @override
  State<TransferView> createState() => _TransferViewState();
}

class _TransferViewState extends State<TransferView>
    with SingleTickerProviderStateMixin {
  final _transferViewBloc = TransferViewBlocImpl();
  final _appColors = AppColors();

  @override
  void initState() {
    super.initState();
    _transferViewBloc.transferScreenTabController =
        TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppWidgetUtils.buildHeaderText(AppConstants.transfer),
            _buildDefaultHeight(),
            _buildSearchFilter(),
            _buildTabBar(),
            _buildTabBarView(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          StreamBuilder(
            stream: _transferViewBloc.transporterNameSearchStream,
            builder: (context, snapshot) {
              return _buildFormField(_transferViewBloc.transporterNameSearchController,
              AppConstants.transporterName);
            },
          ),
          _buildDefaultWidth(),
          StreamBuilder(
            stream: _transferViewBloc.vehicleNameSearchStream,
            builder: (context, snapshot) {
              return _buildFormField(_transferViewBloc.vehicleNameSearchController,
                  AppConstants.vehicleName);
            },
          ),
          _buildDefaultWidth(),
          TldsDropDownButtonFormField(
            height: 40,
            width: MediaQuery.sizeOf(context).width * 0.15,
            hintText: AppConstants.selectVendor,
            dropDownItems: _transferViewBloc.status,
            onChange: (String? newValue) {
              _transferViewBloc.selectedStatus = newValue ?? '';
            },
          ),
        ],),
        Row(children: [
          _buildNewTransfer()
        ],)
      ],
    );
  }


  Widget _buildNewTransfer(){
    return CustomElevatedButton(
      height: 40,
      width: 189,
      text: AppConstants.newTransfer,
      fontSize: 16,
      buttonBackgroundColor: _appColors.primaryColor,
      fontColor: _appColors.whiteColor,
      suffixIcon: SvgPicture.asset(AppConstants.icAdd),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewTransfer(),
            ));
      },
    );
  }

  Widget _buildTabBar() {
    return SizedBox(
      width: 300,
      child: TabBar(
        controller: _transferViewBloc.transferScreenTabController,
        tabs: [
          Tab(
              //text: AppConstants.vehicle,
              child: _buildTabBarRow('Transferred', '2')),
          Tab(
              //text: AppConstants.accessories,
              child: _buildTabBarRow('Received', '4')),
        ],
      ),
    );
  }

  Widget _buildTabBarRow(String title, String count) {
    return Row(
      children: [
        Text(title),
        AppWidgetUtils.buildSizedBox(custWidth: 8),
        CircleAvatar(
          radius: 10,
          backgroundColor: _appColors.red,
          child: Text(
            count,
            style: GoogleFonts.nunitoSans(color: _appColors.whiteColor),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _transferViewBloc.transferScreenTabController,
        children: [
          _buildTransferTableView(context),
          _buildTransferTableView(context),
        ],
      ),
    );
  }

  _buildTransferTableView(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: DataTable(
        key: UniqueKey(),
        dividerThickness: 0.01,
        columns: [
          _buildTransferTableHeader(
            AppConstants.sno,
          ),
          _buildTransferTableHeader(AppConstants.fromBranch),
          _buildTransferTableHeader(AppConstants.toBranch),
          _buildTransferTableHeader(AppConstants.transporterName),
          _buildTransferTableHeader(AppConstants.mobileNumber),
          _buildTransferTableHeader(AppConstants.vehicleNumber),
          _buildTransferTableHeader(AppConstants.status),
          _buildTransferTableHeader(AppConstants.action),
        ],
        rows: List.generate(_transferViewBloc.rowData.length, (index) {
          final data = _transferViewBloc.rowData[index];

          final color = index.isEven
              ? _appColors.whiteColor
              : _appColors.transparentBlueColor;
          return DataRow(
            color: MaterialStateColor.resolveWith((states) => color),
            cells: [
              DataCell(Text(data[AppConstants.sno] ?? '')),
              DataCell(Text(data[AppConstants.fromBranch] ?? '')),
              DataCell(Text(data[AppConstants.toBranch] ?? '')),
              DataCell(Text(data[AppConstants.transporterName] ?? '')),
              DataCell(Text(data[AppConstants.mobileNumber] ?? '')),
              DataCell(Text(data[AppConstants.vehicleNumber] ?? '')),
              DataCell(Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                        color: data[AppConstants.status] == 'Transferred'
                            ? _appColors.whiteColor
                            : _appColors.yellowColor)),
                child: Padding(padding: const EdgeInsets.all(4),
                child: _buildTransferStatus(data))
              ),),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(AppConstants.icMore),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NewTransfer(),
                            ));
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTransferStatus(Map<String, String> data){
    return Row(
      children: [
        Text(data[AppConstants.status] ?? '',style: TextStyle(color:
        data[AppConstants.status] == 'Transferred'
            ? _appColors.successColor
            : _appColors.yellowColor),),
        AppWidgetUtils.buildSizedBox(custWidth: 4),
        data[AppConstants.status] == 'Transferred'
            ? Icon(
          Icons.check,
          color: _appColors.successColor,
        )
            : Icon(
          Icons.info_outline,
          color: _appColors.yellowColor,
        ),
      ],
    );
  }

  _buildTransferTableHeader(String headerValue) => DataColumn(
        label: Text(
          headerValue,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      );

  Widget _buildDefaultWidth() {
    return AppWidgetUtils.buildSizedBox(
        custWidth: MediaQuery.sizeOf(context).width * 0.01);
  }

  Widget _buildDefaultHeight() {
    return AppWidgetUtils.buildSizedBox(
        custHeight: MediaQuery.sizeOf(context).height * 0.02);
  }

  Widget _buildFormField(TextEditingController textController, String hintText) {
    final bool isTextEmpty =
        textController.text.isEmpty;
    final IconData iconData = isTextEmpty ? Icons.search : Icons.close;
    final Color iconColor =
    isTextEmpty ? _appColors.primaryColor : Colors.red;
    return TldsInputFormField(
      width: 203,
      height: 40,
      controller: textController,
      hintText: hintText,
      suffixIcon: IconButton(
        onPressed: iconData == Icons.search ? (){
          //add search cont here
          _checkController(hintText);
        } : () {
          textController.clear();
          _checkController(hintText);
        },
        icon: Icon(
          iconData,
          color: iconColor,
        ),
      ),
      onSubmit: (p0) {
        //add search cont here
        _checkController(hintText);
      },
    );
  }

  void _checkController(String transporterName) {
    if(AppConstants.transporterName == transporterName){
      _transferViewBloc.transporterNameStreamController(true);
    }else{
      _transferViewBloc.vehicleNameSearchStreamController(true);
    }
  }
}
