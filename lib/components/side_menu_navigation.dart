import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/components/responsive.dart';
import 'package:tlbilling/components/side_menu_navigation_bloc.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/branch/branch_view.dart';
import 'package:tlbilling/view/customer/customer_view.dart';
import 'package:tlbilling/view/employee/employee_view_screen.dart';
import 'package:tlbilling/view/login/login_page.dart';
import 'package:tlbilling/view/purchase/purchase_view.dart';
import 'package:tlbilling/view/sales/sales_view.dart';
import 'package:tlbilling/view/stocks/stocks_view.dart';
import 'package:tlbilling/view/transfer/transfer_view.dart';

import 'package:tlbilling/view/transport/transport_view.dart';
import 'package:tlbilling/view/user/user_view.dart';
import 'package:tlbilling/view/vendor/vendor_view.dart';

class SideMenuNavigation extends StatefulWidget {
  const SideMenuNavigation({super.key});

  @override
  State<SideMenuNavigation> createState() => _SideMenuNavigationState();
}

class _SideMenuNavigationState extends State<SideMenuNavigation> {
  final _appcolors = AppColors();
  final sideMenuBloc = SideMenuNavigationBlocImpl();
  String selectedMenuItem = AppConstants.purchase;

  @override
  void initState() {
    super.initState();

    sideMenuBloc.sideMenuStreamController(true);
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _buildMobileView(),
      tablet: _buildTabletView(),
      desktop: _buildDesktopView(),
    );
  }

  Widget _buildMobileView() {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedMenuItem),
      ),
      drawer: _buildDrawer(),
      body: _buildPage(selectedMenuItem),
    );
  }

  Widget _buildDesktopView() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            child: Container(
              decoration: const BoxDecoration(color: Colors.deepPurple),
              child: _buildDrawer(),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Center(
            child: Container(
              color: Colors.grey[200],
              child: _buildPage(selectedMenuItem),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletView() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            decoration: const BoxDecoration(color: Colors.deepPurple),
            child: _buildDrawer(),
          ),
        ),
        Expanded(
          flex: 5,
          child: _buildPage(selectedMenuItem),
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return StreamBuilder(
      stream: sideMenuBloc.sideMenuStream,
      builder: (context, snapshot) {
        return Drawer(
          backgroundColor: _appcolors.primaryColor,
          child: ListView(
            children: [
              AppWidgetUtils.buildSizedBox(custHeight: 10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Center(
                  child: SvgPicture.asset(
                    AppConstants.icCompanyLogo,
                    colorFilter: ColorFilter.mode(
                        _appcolors.whiteColor, BlendMode.srcIn),
                  ),
                ),
              ),
              Center(
                child: Text(
                  AppConstants.companyHeaderName,
                  style: TextStyle(
                      color: _appcolors.whiteColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                child: Divider(color: _appcolors.hintColor),
              ),
              _buildDrawerMenuItem(
                AppConstants.icdashBoard,
                AppConstants.dashboard,
                () {
                  _onMenuItemSelected(AppConstants.dashboard);
                },
              ),
              _buildDrawerMenuItem(
                AppConstants.icPurchase,
                AppConstants.purchase,
                () {
                  _onMenuItemSelected(AppConstants.purchase);
                },
              ),
              _buildDrawerMenuItem(
                AppConstants.icSales,
                AppConstants.sales,
                () {
                  _onMenuItemSelected(AppConstants.sales);
                },
              ),
              _buildDrawerMenuItem(
                AppConstants.icStocks,
                AppConstants.stocks,
                () {
                  _onMenuItemSelected(AppConstants.stocks);
                },
              ),
              _buildDrawerMenuItem(
                AppConstants.icTransfer,
                AppConstants.transfer,
                () {
                  _onMenuItemSelected(AppConstants.transfer);
                },
              ),
              _buildDrawerMenuItem(
                AppConstants.icCustomers,
                AppConstants.customer,
                () {
                  _onMenuItemSelected(AppConstants.customer);
                },
              ),
              _buildDrawerMenuItem(
                AppConstants.icVendor,
                AppConstants.vendor,
                () {
                  _onMenuItemSelected(AppConstants.vendor);
                },
              ),
              _buildDrawerMenuItem(
                AppConstants.icTransport,
                AppConstants.transport,
                () {
                  _onMenuItemSelected(AppConstants.transport);
                },
              ),
              _buildDrawerMenuItem(
                AppConstants.icVendor,
                AppConstants.employee,
                () {
                  _onMenuItemSelected(AppConstants.employee);
                },
              ),
              _buildDrawerMenuItem(
                AppConstants.icUser,
                AppConstants.user,
                () {
                  _onMenuItemSelected(AppConstants.user);
                },
              ),
              _buildDrawerMenuItem(
                AppConstants.icBranch,
                AppConstants.branch,
                () {
                  _onMenuItemSelected(AppConstants.branch);
                },
              ),
              _buildDrawerMenuItem(
                AppConstants.icReport,
                AppConstants.reports,
                () {
                  _onMenuItemSelected(AppConstants.reports);
                },
              ),
              AppWidgetUtils.buildSizedBox(custHeight: 30),
              _buildLogoutMenuItem(),
              AppWidgetUtils.buildSizedBox(custHeight: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawerMenuItem(
    String svgIconPath,
    String titleText,
    Function() onTapFunction,
  ) {
    final isSelected = titleText == selectedMenuItem;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 43,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          color: isSelected ? _appcolors.whiteColor : null,
        ),
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          leading: SvgPicture.asset(
            svgIconPath,
            colorFilter: ColorFilter.mode(
                isSelected ? _appcolors.primaryColor : _appcolors.whiteColor,
                BlendMode.srcIn),
          ),
          title: Text(titleText,
              style: TextStyle(
                  color: isSelected
                      ? _appcolors.primaryColor
                      : _appcolors.whiteColor,
                  fontSize: 14)),
          onTap: () {
            onTapFunction();
            if (Responsive.isMobile(context) || Responsive.isTablet(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  void _onMenuItemSelected(String menuItem) {
    setState(() {
      selectedMenuItem = menuItem;
    });
  }

  Widget _buildPage(String menuItem) {
    switch (menuItem) {
      case AppConstants.purchase:
        return const PurchaseView();
      case AppConstants.stocks:
        return const StocksView();
      case AppConstants.sales:
        return const SalesViewScreen();
      case AppConstants.customer:
        return const CustomerView();
      case AppConstants.transfer:
        return const TransferView();
      case AppConstants.vendor:
        return const VendorView();
      case AppConstants.transport:
        return const TransportView();
      case AppConstants.employee:
        return const EmployeeView();
      case AppConstants.user:
        return const UserView();
      case AppConstants.branch:
        return const BranchView();
      case AppConstants.reports:
        return const Text('reports');

      case AppConstants.logOut:
        return Container();
      default:
        return Container();
    }
  }

  Widget _buildLogoutMenuItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        child: InkWell(
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return const LoginPage();
              },
            ));
          },
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: AppColors.white12,
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  _buildName(),
                  const Divider(),
                  _buildBranch(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    /*Card(
      surfaceTintColor: null,
      shadowColor: null,
      shape: CircleBorder(side: BorderSide(style: BorderStyle.none), eccentricity: 0.5),
      color: Colors.white12,
      child: ,
    );*/
  }

  _buildName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ajithkumar',
              style: TextStyle(color: _appcolors.whiteColor, fontSize: 14),
            ),
            Text(
              'admin',
              style: TextStyle(color: _appcolors.grey, fontSize: 9),
            )
          ],
        ),
        SvgPicture.asset(AppConstants.icLogout)
      ],
    );
  }

  _buildBranch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'KovilPatti',
              style: TextStyle(color: _appcolors.whiteColor, fontSize: 14),
            ),
            Row(
              children: [
                Container(
                  height: 5,
                  width: 5,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.green,
                  ),
                ),
                _buildText(' Current Branch', _appcolors.whiteColor, 8),
              ],
            )
          ],
        ),
        SvgPicture.asset(AppConstants.icDownArrow)
      ],
    );
  }

  _buildText(String? name, Color? color, double? fontSize) {
    return Text(
      name!,
      style: TextStyle(
        color: color,
        fontSize: 9,
      ),
    );
  }
}
