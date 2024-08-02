// import 'package:tlbilling/view/useraccess/user_access_levels.dart';

// class AccessLevel {
//   //Dashboard
//   static bool canViewDashboard = false;
//   static bool canAddDashboard = false;
//   static bool canPUpdateDashboard = false;
//   static bool canFUpdateDashboard = false;
//   static bool canDeleteDashboard = false;
//   static bool canHideDashboard = false;

//   //Purchase
//   static bool canViewPurchase = false;
//   static bool canAddPurchase = false;
//   static bool canPUpdatePurchase = false;
//   static bool canFUpdatePurchase = false;
//   static bool canDeletePurchase = false;
//   static bool canHidePurchase = false;

// //booking
//   static bool canViewBooking = false;
//   static bool canAddBooking = false;
//   static bool canPUpdateBooking = false;
//   static bool canFUpdateBooking = false;
//   static bool canDeleteBooking = false;
//   static bool canHideBooking = false;

//   //sales

//   static bool canViewSales = false;
//   static bool canAddSales = false;
//   static bool canPUpdateSales = false;
//   static bool canFUpdateSales = false;
//   static bool canDeleteSales = false;
//   static bool canHideSales = false;

//   //stock

//   static bool canViewStocks = false;
//   static bool canAddStocks = false;
//   static bool canPUpdateStocks = false;
//   static bool canFUpdateStocks = false;
//   static bool canDeleteStocks = false;
//   static bool canHideStocks = false;

//   //transfer

//   static bool canViewTransfer = false;
//   static bool canAddTransfer = false;
//   static bool canPUpdateTransfer = false;
//   static bool canFUpdateTransfer = false;
//   static bool canDeleteTransfer = false;
//   static bool canHideTransfer = false;

//   //customer

//   static bool canViewCustomer = false;
//   static bool canAddCustomer = false;
//   static bool canPUpdateCustomer = false;
//   static bool canFUpdateCustomer = false;
//   static bool canDeleteCustomer = false;
//   static bool canHideCustomer = false;

//   //vendor

//   static bool canViewVendor = false;
//   static bool canAddVendor = false;
//   static bool canPUpdateVendor = false;
//   static bool canFUpdateVendor = false;
//   static bool canDeleteVendor = false;
//   static bool canHideVendor = false;

//   //transport

//   static bool canViewTransport = false;
//   static bool canAddTransport = false;
//   static bool canPUpdateTransport = false;
//   static bool canFUpdateTransport = false;
//   static bool canDeleteTransport = false;
//   static bool canHideTransport = false;

//   //employee

//   static bool canViewEmployee = false;
//   static bool canAddEmployee = false;
//   static bool canPUpdateEmployee = false;
//   static bool canFUpdateEmployee = false;
//   static bool canDeleteEmployee = false;
//   static bool canHideEmployee = false;

//   //user

//   static bool canViewUser = false;
//   static bool canAddUser = false;
//   static bool canPUpdateUser = false;
//   static bool canFUpdateUser = false;
//   static bool canDeleteUser = false;
//   static bool canHideUser = false;

//   //branch

//   static bool canViewBranch = false;
//   static bool canAddBranch = false;
//   static bool canPUpdateBranch = false;
//   static bool canFUpdateBranch = false;
//   static bool canDeleteBranch = false;
//   static bool canHideBranch = false;

//   //voucher

//   static bool canViewVoucher = false;
//   static bool canAddVoucher = false;
//   static bool canPUpdateVoucher = false;
//   static bool canFUpdateVoucher = false;
//   static bool canDeleteVoucher = false;
//   static bool canHideVoucher = false;

//   //report

//   static bool canViewReports = false;
//   static bool canAddReports = false;
//   static bool canPUpdateReports = false;
//   static bool canFUpdateReports = false;
//   static bool canDeleteReports = false;
//   static bool canHideReports = false;

//   //config

//   static bool canViewConfig = false;
//   static bool canAddConfig = false;
//   static bool canPUpdateConfig = false;
//   static bool canFUpdateConfig = false;
//   static bool canDeleteConfig = false;
//   static bool canHideConfig = false;

//   static Future<void> initializeAccessLevels() async {
//     canViewDashboard = await UserAccessLevels.hasAccess('Dashboard', 'VIEW');
//     canAddDashboard = await UserAccessLevels.hasAccess('Dashboard', 'ADD');
//     canPUpdateDashboard =
//         await UserAccessLevels.hasAccess('Dashboard', 'P_UPDATE');
//     canFUpdateDashboard =
//         await UserAccessLevels.hasAccess('Dashboard', 'F_UPDATE');
//     canDeleteDashboard =
//         await UserAccessLevels.hasAccess('Dashboard', 'DELETE');
//     canHideDashboard = await UserAccessLevels.hasAccess('Dashboard', 'HIDE');

//     canViewPurchase = await UserAccessLevels.hasAccess('Purchase', 'VIEW');
//     canAddPurchase = await UserAccessLevels.hasAccess('Purchase', 'ADD');
//     canPUpdatePurchase =
//         await UserAccessLevels.hasAccess('Purchase', 'P_UPDATE');
//     canFUpdatePurchase =
//         await UserAccessLevels.hasAccess('Purchase', 'F_UPDATE');
//     canDeletePurchase = await UserAccessLevels.hasAccess('Purchase', 'DELETE');
//     canHidePurchase = await UserAccessLevels.hasAccess('Purchase', 'HIDE');

//     canViewBooking = await UserAccessLevels.hasAccess('Booking', 'VIEW');
//     canAddBooking = await UserAccessLevels.hasAccess('Booking', 'ADD');
//     canPUpdateBooking = await UserAccessLevels.hasAccess('Booking', 'P_UPDATE');
//     canFUpdateBooking = await UserAccessLevels.hasAccess('Booking', 'F_UPDATE');
//     canDeleteBooking = await UserAccessLevels.hasAccess('Booking', 'DELETE');
//     canHideBooking = await UserAccessLevels.hasAccess('Booking', 'HIDE');

//     canViewSales = await UserAccessLevels.hasAccess('Sales', 'VIEW');
//     canAddSales = await UserAccessLevels.hasAccess('Sales', 'ADD');
//     canPUpdateSales = await UserAccessLevels.hasAccess('Sales', 'P_UPDATE');
//     canFUpdateSales = await UserAccessLevels.hasAccess('Sales', 'F_UPDATE');
//     canDeleteSales = await UserAccessLevels.hasAccess('Sales', 'DELETE');
//     canHideSales = await UserAccessLevels.hasAccess('Sales', 'HIDE');

//     canViewStocks = await UserAccessLevels.hasAccess('Stocks', 'VIEW');
//     canAddStocks = await UserAccessLevels.hasAccess('Stocks', 'ADD');
//     canPUpdateStocks = await UserAccessLevels.hasAccess('Stocks', 'P_UPDATE');
//     canFUpdateStocks = await UserAccessLevels.hasAccess('Stocks', 'F_UPDATE');
//     canDeleteStocks = await UserAccessLevels.hasAccess('Stocks', 'DELETE');
//     canHideStocks = await UserAccessLevels.hasAccess('Stocks', 'HIDE');

//     canViewTransfer = await UserAccessLevels.hasAccess('Transfer', 'VIEW');
//     canAddTransfer = await UserAccessLevels.hasAccess('Transfer', 'ADD');
//     canPUpdateTransfer =
//         await UserAccessLevels.hasAccess('Transfer', 'P_UPDATE');
//     canFUpdateTransfer =
//         await UserAccessLevels.hasAccess('Transfer', 'F_UPDATE');
//     canDeleteTransfer = await UserAccessLevels.hasAccess('Transfer', 'DELETE');
//     canHideTransfer = await UserAccessLevels.hasAccess('Transfer', 'HIDE');

//     canViewCustomer = await UserAccessLevels.hasAccess('Customer', 'VIEW');
//     canAddCustomer = await UserAccessLevels.hasAccess('Customer', 'ADD');
//     canPUpdateCustomer =
//         await UserAccessLevels.hasAccess('Customer', 'P_UPDATE');
//     canFUpdateCustomer =
//         await UserAccessLevels.hasAccess('Customer', 'F_UPDATE');
//     canDeleteCustomer = await UserAccessLevels.hasAccess('Customer', 'DELETE');
//     canHideCustomer = await UserAccessLevels.hasAccess('Customer', 'HIDE');

//     canViewVendor = await UserAccessLevels.hasAccess('Vendor', 'VIEW');
//     canAddVendor = await UserAccessLevels.hasAccess('Vendor', 'ADD');
//     canPUpdateVendor = await UserAccessLevels.hasAccess('Vendor', 'P_UPDATE');
//     canFUpdateVendor = await UserAccessLevels.hasAccess('Vendor', 'F_UPDATE');
//     canDeleteVendor = await UserAccessLevels.hasAccess('Vendor', 'DELETE');
//     canHideVendor = await UserAccessLevels.hasAccess('Vendor', 'HIDE');

//     canViewTransport = await UserAccessLevels.hasAccess('Transport', 'VIEW');
//     canAddTransport = await UserAccessLevels.hasAccess('Transport', 'ADD');
//     canPUpdateTransport =
//         await UserAccessLevels.hasAccess('Transport', 'P_UPDATE');
//     canFUpdateTransport =
//         await UserAccessLevels.hasAccess('Transport', 'F_UPDATE');
//     canDeleteTransport =
//         await UserAccessLevels.hasAccess('Transport', 'DELETE');
//     canHideTransport = await UserAccessLevels.hasAccess('Transport', 'HIDE');

//     canViewEmployee = await UserAccessLevels.hasAccess('Employee', 'VIEW');
//     canAddEmployee = await UserAccessLevels.hasAccess('Employee', 'ADD');
//     canPUpdateEmployee =
//         await UserAccessLevels.hasAccess('Employee', 'P_UPDATE');
//     canFUpdateEmployee =
//         await UserAccessLevels.hasAccess('Employee', 'F_UPDATE');
//     canDeleteEmployee = await UserAccessLevels.hasAccess('Employee', 'DELETE');
//     canHideEmployee = await UserAccessLevels.hasAccess('Employee', 'HIDE');

//     canViewUser = await UserAccessLevels.hasAccess('User', 'VIEW');
//     canAddUser = await UserAccessLevels.hasAccess('User', 'ADD');
//     canPUpdateUser = await UserAccessLevels.hasAccess('User', 'P_UPDATE');
//     canFUpdateUser = await UserAccessLevels.hasAccess('User', 'F_UPDATE');
//     canDeleteUser = await UserAccessLevels.hasAccess('User', 'DELETE');
//     canHideUser = await UserAccessLevels.hasAccess('User', 'HIDE');

//     canViewBranch = await UserAccessLevels.hasAccess('Branch', 'VIEW');
//     canAddBranch = await UserAccessLevels.hasAccess('Branch', 'ADD');
//     canPUpdateBranch = await UserAccessLevels.hasAccess('Branch', 'P_UPDATE');
//     canFUpdateBranch = await UserAccessLevels.hasAccess('Branch', 'F_UPDATE');
//     canDeleteBranch = await UserAccessLevels.hasAccess('Branch', 'DELETE');
//     canHideBranch = await UserAccessLevels.hasAccess('Branch', 'HIDE');

//     canViewVoucher = await UserAccessLevels.hasAccess('Voucher', 'VIEW');
//     canAddVoucher = await UserAccessLevels.hasAccess('Voucher', 'ADD');
//     canPUpdateVoucher = await UserAccessLevels.hasAccess('Voucher', 'P_UPDATE');
//     canFUpdateVoucher = await UserAccessLevels.hasAccess('Voucher', 'F_UPDATE');
//     canDeleteVoucher = await UserAccessLevels.hasAccess('Voucher', 'DELETE');
//     canHideVoucher = await UserAccessLevels.hasAccess('Voucher', 'HIDE');

//     canViewReports = await UserAccessLevels.hasAccess('Reports', 'VIEW');
//     canAddReports = await UserAccessLevels.hasAccess('Reports', 'ADD');
//     canPUpdateReports = await UserAccessLevels.hasAccess('Reports', 'P_UPDATE');
//     canFUpdateReports = await UserAccessLevels.hasAccess('Reports', 'F_UPDATE');
//     canDeleteReports = await UserAccessLevels.hasAccess('Reports', 'DELETE');
//     canHideReports = await UserAccessLevels.hasAccess('Reports', 'HIDE');

//     canViewConfig = await UserAccessLevels.hasAccess('Config', 'VIEW');
//     canAddConfig = await UserAccessLevels.hasAccess('Config', 'ADD');
//     canPUpdateConfig = await UserAccessLevels.hasAccess('Config', 'P_UPDATE');
//     canFUpdateConfig = await UserAccessLevels.hasAccess('Config', 'F_UPDATE');
//     canDeleteConfig = await UserAccessLevels.hasAccess('Config', 'DELETE');
//     canHideConfig = await UserAccessLevels.hasAccess('Config', 'HIDE');
//   }
// }

import 'package:tlbilling/view/useraccess/user_access_levels.dart';

class AccessLevel {
  static final Map<String, Map<String, bool>> _accessLevels = {
    "Dashboard": {},
    "Purchase": {},
    "Booking": {},
    "Sales": {},
    "Stocks": {},
    "Transfer": {},
    "Customer": {},
    "Vendor": {},
    "Transport": {},
    "Employee": {},
    "User": {},
    "Branch": {},
    "Voucher": {},
    "Reports": {},
    "Config": {},
    "Access Control": {},
  };

  static Future<void> accessingData() async {
    for (String menuName in _accessLevels.keys) {
      _accessLevels[menuName]!['VIEW'] =
          await UserAccessLevels.hasAccess(menuName, 'VIEW');
      _accessLevels[menuName]!['ADD'] =
          await UserAccessLevels.hasAccess(menuName, 'ADD');
      _accessLevels[menuName]!['P_UPDATE'] =
          await UserAccessLevels.hasAccess(menuName, 'P_UPDATE');
      _accessLevels[menuName]!['F_UPDATE'] =
          await UserAccessLevels.hasAccess(menuName, 'F_UPDATE');
      _accessLevels[menuName]!['DELETE'] =
          await UserAccessLevels.hasAccess(menuName, 'DELETE');
      _accessLevels[menuName]!['HIDE'] =
          await UserAccessLevels.hasAccess(menuName, 'HIDE');
    }
  }

  static bool canView(String menuName) =>
      _accessLevels[menuName]?['VIEW'] ?? false;
  static bool canAdd(String menuName) =>
      _accessLevels[menuName]?['ADD'] ?? false;
  static bool canPUpdate(String menuName) =>
      _accessLevels[menuName]?['P_UPDATE'] ?? false;
  static bool canFUpdate(String menuName) =>
      _accessLevels[menuName]?['F_UPDATE'] ?? false;
  static bool canDelete(String menuName) =>
      _accessLevels[menuName]?['DELETE'] ?? false;
  static bool canHide(String menuName) =>
      _accessLevels[menuName]?['HIDE'] ?? false;
}
