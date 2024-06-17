class AppUrl {
  static const baseUrl = 'http://193.203.163.226:8084/';
  // http://195.35.21.50:8082/
  static const login = '${baseUrl}user/login';
  static const branch = '${baseUrl}branch';
  static const customer = '${baseUrl}customer';
  static const addCustomer = '${baseUrl}customer';
  static const user = '${baseUrl}user/getByPagination?';
  static const config = '${baseUrl}config/';
  static const newUserOnboard = '${baseUrl}user';
  static const newEmployeeOnBoard = '${baseUrl}employee';
  static const employee = '${baseUrl}employee';
  static const employeeByPagination = '${baseUrl}employee/getByPagination?';
  static const updateUserStatus = '${baseUrl}user/status/';
  static const purchaseByPagenation = '${baseUrl}purchase/page';
  static const vendorNameList = '${baseUrl}vendor';
  static const transport = '${baseUrl}transport/';
  static String getAllConfigList = '${baseUrl}config/getAll';
  static const vendorByPagination = '${baseUrl}vendor/page?';
  static const addVendor = '${baseUrl}vendor';
  static const insurance = '${baseUrl}customer';
  static const sales = '${baseUrl}sales';
  static const stocks = '${baseUrl}stocks';
  static const purchase = '${baseUrl}purchase';
  static const purchaseByPartNo = '${baseUrl}purchase/ByPartNo/';
  static const category = '${baseUrl}category/page?page=0&size=10';
  static const stock = '${baseUrl}stock';
  static const purchaseCancel = '${baseUrl}purchase/cancel/';
  static const purchaseValidate = '${baseUrl}purchase/validate?partNo=';
}
