class AppUrl {
  // http://195.35.21.50:8082/
  static const baseUrl = 'http://193.203.163.226:8084/';
  static const login = '${baseUrl}user/login';
  static const addBranch = '${baseUrl}branch';
  static const addCustomer = '${baseUrl}customer';
  static const user = '${baseUrl}user/getByPagination?page=0&pageSize=10';
  static const config = '${baseUrl}config/';
  static const newUserOnboard = '${baseUrl}user';
  static const employee = '${baseUrl}employee';
  static const updateUserStatus = '${baseUrl}user/status/';
}
