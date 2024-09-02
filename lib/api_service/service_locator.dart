import 'package:get_it/get_it.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/components/side_menu_navigation_bloc.dart';
import 'package:tlbilling/view/account_head/account_head_view_bloc.dart';
import 'package:tlbilling/view/booking/add_booking/add_booking_dialog_bloc.dart';
import 'package:tlbilling/view/booking/booking_list_bloc.dart';
import 'package:tlbilling/view/branch/branch_view_bloc.dart';
import 'package:tlbilling/view/branch/create_branch_dialog_bloc.dart';
import 'package:tlbilling/view/configuration/configuration_dialog/configuration_dialog_bloc.dart';
import 'package:tlbilling/view/configuration/configuration_view_bloc.dart';
import 'package:tlbilling/view/customer/create_customer_dialog_bloc.dart';
import 'package:tlbilling/view/customer/customer_view_bloc.dart';
import 'package:tlbilling/view/employee/create_employee_dialog_bloc.dart';
import 'package:tlbilling/view/employee/employee_view_bloc.dart';
import 'package:tlbilling/view/login/login_page_bloc.dart';
import 'package:tlbilling/view/purchase/add_purchase/add_vehicle_and_accesories/add_vehicle_and_accessories_bloc.dart';
import 'package:tlbilling/view/purchase/purchase_view_bloc.dart';
import 'package:tlbilling/view/sales/add_sales_bloc.dart';
import 'package:tlbilling/view/sales/sales_view_bloc.dart';
import 'package:tlbilling/view/stocks/stocks_view_bloc.dart';
import 'package:tlbilling/view/transfer/new_transfer/new_transfer_bloc.dart';
import 'package:tlbilling/view/transfer/transfer_view_bloc.dart';
import 'package:tlbilling/view/transport/create_transport_dialog_bloc.dart';
import 'package:tlbilling/view/transport/transport_view_bloc.dart';
import 'package:tlbilling/view/user/create_user_dialog_bloc.dart';
import 'package:tlbilling/view/user/user_view_bloc.dart';
import 'package:tlbilling/view/useraccess/access_control_view_bloc.dart';
import 'package:tlbilling/view/vendor/create_vendor_dialog_bloc.dart';
import 'package:tlbilling/view/vendor/vendor_view_bloc.dart';
import 'package:tlbilling/view/voucher_receipt/new_voucher/new_voucher_bloc.dart';

final GetIt getIt = GetIt.instance;

class ServiceLocator {
  static void setupLocator() {
    appServiceUtilsRegisterLocator();
    loginRegisterLocator();
    sideMenuRegisterlocator();
    branchRegisterLocator();
    employeeRegisterLocator();
    userRegisterLocator();
    customerRegisterLocator();
    vendorRegisterLocator();
    transportRegisterLocator();
    purchaseRegisterLocator();
    bookingRegisterLocator();
    salesRegisterLocator();
    stockRegisterLocator();
    transferRegisterLocator();
    accountRegisterLocator();
    voucherRegisterLocator();
    configRegisterLocator();
    accessControlRegisterLocator();
  }

  // sales module
  static void salesRegisterLocator() {
    getIt.registerLazySingleton<SalesViewBlocImpl>(() => SalesViewBlocImpl());
    getIt.registerLazySingleton<AddSalesBlocImpl>(() => AddSalesBlocImpl());
  }

  //user module
  static void userRegisterLocator() {
    getIt.registerLazySingleton<UserViewBlocImpl>(() => UserViewBlocImpl());
    getIt.registerLazySingleton<CreateUserDialogBlocImpl>(
        () => CreateUserDialogBlocImpl());
  }

  //purchase module
  static void purchaseRegisterLocator() {
    getIt.registerLazySingleton<PurchaseViewBlocImpl>(
        () => PurchaseViewBlocImpl());
    getIt.registerLazySingleton<AddVehicleAndAccessoriesBlocImpl>(
        () => AddVehicleAndAccessoriesBlocImpl());
  }

  // transport module
  static void transportRegisterLocator() {
    getIt.registerLazySingleton<TransportBlocImpl>(() => TransportBlocImpl());
    getIt.registerLazySingleton<CreateTransportBlocImpl>(
        () => CreateTransportBlocImpl());
  }

  // account module
  static void accountRegisterLocator() {
    getIt.registerLazySingleton<AccountViewBlocImpl>(
        () => AccountViewBlocImpl());
  }

  // employee module
  static void employeeRegisterLocator() {
    getIt.registerLazySingleton<EmployeeViewBlocImpl>(
        () => EmployeeViewBlocImpl());
    getIt.registerLazySingleton<CreateEmployeeDialogBlocImpl>(
        () => CreateEmployeeDialogBlocImpl());
  }

  // booking module
  static void bookingRegisterLocator() {
    getIt.registerLazySingleton<BookingListBlocImpl>(
        () => BookingListBlocImpl());

    getIt.registerLazySingleton<AddBookingDialogBlocImpl>(
        () => AddBookingDialogBlocImpl());
  }

  // app service utils
  static void appServiceUtilsRegisterLocator() {
    getIt.registerLazySingleton<AppServiceUtilImpl>(
      () => AppServiceUtilImpl(),
    );
  }

  //vouchar module
  static void voucherRegisterLocator() {
    getIt.registerLazySingleton<NewVoucherBlocImpl>(() => NewVoucherBlocImpl());
  }

  //login module
  static void loginRegisterLocator() {
    getIt.registerLazySingleton<LoginPageBlocImpl>(() => LoginPageBlocImpl());
  }

  //vendor module
  static void vendorRegisterLocator() {
    getIt.registerLazySingleton<VendorViewBlocImpl>(() => VendorViewBlocImpl());
    getIt.registerLazySingleton<CreateVendorDialogBlocImpl>(
        () => CreateVendorDialogBlocImpl());
  }

  //customer module
  static void customerRegisterLocator() {
    getIt.registerLazySingleton<CustomerViewBlocImpl>(
        () => CustomerViewBlocImpl());
    getIt.registerLazySingleton<CreateCustomerDialogBlocImpl>(
        () => CreateCustomerDialogBlocImpl());
  }

  //sidemenu

  static void sideMenuRegisterlocator() {
    getIt.registerLazySingleton<SideMenuNavigationBlocImpl>(
        () => SideMenuNavigationBlocImpl());
  }

  //AccessControl modules

  static void accessControlRegisterLocator() {
    getIt.registerLazySingleton<AccessControlViewBlocImpl>(
        () => AccessControlViewBlocImpl());
  }

//tranfer module
  static void transferRegisterLocator() {
    getIt.registerLazySingleton<TransferViewBlocImpl>(
        () => TransferViewBlocImpl());
    getIt.registerLazySingleton<NewTransferBlocImpl>(
        () => NewTransferBlocImpl());
  }

//stock module
  static void stockRegisterLocator() {
    getIt.registerLazySingleton<StocksViewBlocImpl>(() => StocksViewBlocImpl());
  }

//config module
  static void configRegisterLocator() {
    getIt.registerLazySingleton<ConfigurationBlocImpl>(
        () => ConfigurationBlocImpl());
    // getIt.registerFactory<ConfigurationDialogBlocImpl>(
    //   () => ConfigurationDialogBlocImpl(),
    // );
    getIt.registerLazySingleton<ConfigurationDialogBlocImpl>(
        () => ConfigurationDialogBlocImpl());
  }

//branch
  static void branchRegisterLocator() {
    getIt.registerLazySingleton<BranchViewBlocImpl>(() => BranchViewBlocImpl());
    getIt.registerLazySingleton<CreateBranchDialogBlocImpl>(
        () => CreateBranchDialogBlocImpl());
  }
}
