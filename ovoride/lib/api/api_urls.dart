class APIUrls {
  static const String baseURL = 'https://admin.jewellery.ctpbd.info/api/shop/';

  // Auth - (User)
  static const String login = '${baseURL}login';
  static const String register = '${baseURL}register';
  static const String dashboard = '${baseURL}dashboard';

  // Product
  static const String product = '${baseURL}products';
  static const String productCreate = '${baseURL}products';
  static const String productUpdateOrDelete = '${baseURL}product/id';

  // Category
  static const String category = '${baseURL}categories';
  static const String categoryCreate = '${baseURL}categories';
  static const String categoryUpdateOrDelete = '${baseURL}categories/id';
}