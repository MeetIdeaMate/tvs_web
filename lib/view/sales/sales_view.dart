import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/sales/add_sales.dart';
import 'package:tlbilling/view/sales/sales_view_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:tlds_flutter/util/app_colors.dart';

class SalesViewScreen extends StatefulWidget {
  const SalesViewScreen({super.key});

  @override
  State<SalesViewScreen> createState() => _SalesViewScreenState();
}

class _SalesViewScreenState extends State<SalesViewScreen>
    with SingleTickerProviderStateMixin {
  final _salesViewBloc = SalesViewBlocImpl();
  final _appColors = AppColor();
  List<Map<String, String>> rowData = [
    {
      AppConstants.sno: '1',
      AppConstants.invoiceNo: 'INV-1234',
      AppConstants.invoiceDate: '16-05-24',
      AppConstants.customerId: 'CUS-4567',
      AppConstants.customerName: 'Ajith Kumar',
      AppConstants.mobileNumber: '+91 9876543210',
      AppConstants.paymentType: 'CASH',
      AppConstants.totalInvAmount: '₹ 1,000,00',
      AppConstants.pendingInvAmt: '₹ 1,000,00',
      AppConstants.balanceAmt: '₹ 1,000,00',
      AppConstants.status: 'Pending',
      AppConstants.createdBy: 'Admin',
    },
    {
      AppConstants.sno: '2',
      AppConstants.invoiceNo: 'INV-1234',
      AppConstants.invoiceDate: '16-05-24',
      AppConstants.customerId: 'CUS-4567',
      AppConstants.customerName: 'Senthil',
      AppConstants.mobileNumber: '+91 4567898768',
      AppConstants.paymentType: 'CASH',
      AppConstants.totalInvAmount: '₹ 1,000,00',
      AppConstants.pendingInvAmt: '₹ 1,000,00',
      AppConstants.balanceAmt: '₹ 1,000,00',
      AppConstants.status: 'Completed',
      AppConstants.createdBy: 'Admin',
    },
  ];

  @override
  void initState() {
    super.initState();
    _salesViewBloc.salesTabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 21,
          vertical: 28,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppWidgetUtils.buildHeaderText(AppConstants.sales),
            _buildSearchFilters(),
            AppWidgetUtils.buildSizedBox(
                custHeight: MediaQuery.sizeOf(context).height * 0.02),
            _buildTabBar(),
            _buildTabBarView()
          ],
        ),
      ),
    );
  }

  Widget _buildSearchFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder(
              stream: _salesViewBloc.invoiceNoStream,
              builder: (context, snapshot) {
                return _buildFormField(_salesViewBloc.invoiceNoTextController,
                    AppConstants.invoiceNo);
              },
            ),
            AppWidgetUtils.buildSizedBox(
              custWidth: MediaQuery.sizeOf(context).width * 0.01,
            ),
            StreamBuilder(
              stream: _salesViewBloc.paymentTypeStream,
              builder: (context, snapshot) {
                return _buildFormField(_salesViewBloc.paymentTypeTextController,
                    AppConstants.paymentType);
              },
            ),
            AppWidgetUtils.buildSizedBox(
              custWidth: MediaQuery.sizeOf(context).width * 0.01,
            ),
            StreamBuilder(
              stream: _salesViewBloc.customerNameStream,
              builder: (context, snapshot) {
                return _buildFormField(
                    _salesViewBloc.customerNameTextController,
                    AppConstants.customerName);
              },
            ),
          ],
        ),
        Row(
          children: [
            CustomElevatedButton(
              height: 40,
              width: 189,
              text: AppConstants.addSales,
              fontSize: 16,
              buttonBackgroundColor: _appColors.primaryColor,
              fontColor: _appColors.whiteColor,
              suffixIcon: SvgPicture.asset(AppConstants.icAdd),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddSales(),
                    ));
              },
            )
          ],
        )
      ],
    );
  }

  Widget _buildFormField(
      TextEditingController textController, String hintText) {
    final bool isTextEmpty = textController.text.isEmpty;
    final IconData iconData = isTextEmpty ? Icons.search : Icons.close;
    final Color iconColor = isTextEmpty ? _appColors.primaryColor : Colors.red;
    return TldsInputFormField(
      width: 203,
      height: 40,
      controller: textController,
      hintText: hintText,
      suffixIcon: IconButton(
        onPressed: iconData == Icons.search
            ? () {
                //add search cont here
                _checkController(hintText);
              }
            : () {
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

  void _checkController(String hintText) {
    if (AppConstants.invoiceNo == hintText) {
      _salesViewBloc.invoiceNoStreamController(true);
    } else if (AppConstants.paymentType == hintText) {
      _salesViewBloc.paymentTypeStreamController(true);
    } else if (AppConstants.customerName == hintText) {
      _salesViewBloc.customerNameStreamController(true);
    }
  }

  Widget _buildTabBar() {
    return SizedBox(
      width: 420,
      child: TabBar(
        controller: _salesViewBloc.salesTabController,
        tabs: const [
          Tab(text: AppConstants.all),
          Tab(text: AppConstants.today),
          Tab(text: AppConstants.pending),
          Tab(text: AppConstants.completed),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _salesViewBloc.salesTabController,
        children: [
          _buildCustomerTableView(context),
          _buildCustomerTableView(context),
          _buildCustomerTableView(context),
          _buildCustomerTableView(context),
        ],
      ),
    );
  }

  _buildCustomerTableView(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          key: UniqueKey(),
          dividerThickness: 0.01,
          columns: [
            _buildVehicleTableHeader(
              AppConstants.sno,
            ),
            _buildVehicleTableHeader(AppConstants.invoiceNo),
            _buildVehicleTableHeader(AppConstants.invoiceDate),
            _buildVehicleTableHeader(AppConstants.customerId),
            _buildVehicleTableHeader(AppConstants.customerName),
            _buildVehicleTableHeader(AppConstants.mobileNumber),
            _buildVehicleTableHeader(AppConstants.paymentType),
            _buildVehicleTableHeader(AppConstants.totalInvAmount),
            _buildVehicleTableHeader(AppConstants.pendingInvAmt),
            _buildVehicleTableHeader(AppConstants.balanceAmt),
            _buildVehicleTableHeader(AppConstants.status),
            _buildVehicleTableHeader(AppConstants.createdBy),
            _buildVehicleTableHeader(AppConstants.action),
            _buildVehicleTableHeader(AppConstants.print),
          ],
          rows: List.generate(rowData.length, (index) {
            final data = rowData[index];

            final color = index.isEven
                ? _appColors.whiteColor
                : _appColors.transparentBlueColor;
            return DataRow(
              color: MaterialStateColor.resolveWith((states) => color),
              cells: [
                DataCell(Text(data[AppConstants.sno]!)),
                DataCell(Text(data[AppConstants.invoiceNo]!)),
                DataCell(Text(data[AppConstants.invoiceDate]!)),
                DataCell(Text(data[AppConstants.customerId]!)),
                DataCell(Text(data[AppConstants.customerName]!)),
                DataCell(Text(data[AppConstants.mobileNumber]!)),
                DataCell(Text(data[AppConstants.paymentType]!)),
                DataCell(Text(data[AppConstants.totalInvAmount]!)),
                DataCell(Text(data[AppConstants.pendingInvAmt]!)),
                DataCell(Text(data[AppConstants.balanceAmt]!)),
                DataCell(Chip(label: Text(data[AppConstants.status]!))),
                DataCell(Text(data[AppConstants.createdBy]!)),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(AppConstants.icEdit),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                DataCell(IconButton(
                    onPressed: () {}, icon: const Icon(Icons.print))),
              ],
            );
          }),
        ),
      ),
    );
  }

  _buildVehicleTableHeader(String headerValue) => DataColumn(
        label: Text(
          headerValue,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      );
}
