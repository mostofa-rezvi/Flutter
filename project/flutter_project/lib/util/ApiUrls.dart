class APIUrls {
  static const String baseURL = 'http://localhost:8080/api';

  static Uri get login => Uri.parse('$baseURL/auth/login');
  static Uri get appointments => Uri.parse('$baseURL/appointments');
  static Uri get prescriptions => Uri.parse('$baseURL/prescriptions');
  static Uri get medicines => Uri.parse('$baseURL/medicines');
  static Uri get tests => Uri.parse('$baseURL/tests');
  static Uri get user => Uri.parse('$baseURL/users');


  // static Uri get worker => Uri.parse('$baseURL/worker');
  // static Uri get task => Uri.parse('$baseURL/task');
  // static Uri get rawMaterial => Uri.parse('$baseURL/rawMaterial');
  // static Uri get supplier => Uri.parse('$baseURL/supplier');
  // static Uri get booking => Uri.parse('$baseURL/booking');
  // static Uri get payment => Uri.parse('$baseURL/payment');
  // static Uri get account => Uri.parse('$baseURL/account');
  // static Uri get transaction => Uri.parse('$baseURL/transaction');
  // static Uri get ledger => Uri.parse('$baseURL/ledger');
}