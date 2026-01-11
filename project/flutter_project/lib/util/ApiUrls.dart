class APIUrls {
  static const String baseURL = 'http://localhost:8080/api';

  // Auth Endpoints
  static const String login = '$baseURL/auth/login';

  // Appointments & Prescriptions Endpoints
  static const String appointments = '$baseURL/appointments';
  static const String prescriptions = '$baseURL/prescriptions';

  // Medicine & Test Endpoints
  static const String medicines = '$baseURL/medicines';
  static const String tests = '$baseURL/tests';

  // User & Report Endpoints
  static const String user = '$baseURL/user';
  static const String reports = '$baseURL/reports';

  // Diagnostics & Department Endpoints
  static const String diagnostics = '$baseURL/diagnostics';
  static const String departments = '$baseURL/departments';

  // Billing & Manufacturer Endpoints
  static const String bills = '$baseURL/bills';
  static const String manufacturers = '$baseURL/manufacturers';
}
