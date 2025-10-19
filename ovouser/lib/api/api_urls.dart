class APIUrls {
  static const String baseURL = 'https://admin.jewellery.ctpbd.info/api/';

  // Auth - (User)
  static const String login = '${baseURL}login';
  static const String register = '${baseURL}register';

  // Shops Products
  static const String shopsProducts = '${baseURL}shops-with-products';

  // User
  static const String viewCart = '${baseURL}order/view-cart';
  static const String orderHistory = '${baseURL}order/history';
  static const String addToCart = '${baseURL}order/add-to-cart';
  static const String updateCart = '${baseURL}order/update-cart';
  static const String placeOrder = '${baseURL}order/place-order';

}