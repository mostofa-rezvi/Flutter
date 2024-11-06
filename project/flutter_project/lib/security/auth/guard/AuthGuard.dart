import 'package:flutter/material.dart';
import 'package:flutter_project/pages/LoginPage.dart';
import 'package:flutter_project/security/auth/service/AuthService.dart';
import 'package:provider/provider.dart';

/// AuthGuard: Checks if the user is authenticated before allowing access to a screen.
class AuthGuard {
  /// Checks authentication status and navigates accordingly.
  static Future<void> checkAuth(BuildContext context, Widget screen) async {
    final authService = Provider.of<AuthService>(context, listen: false);

    if (authService.isAuthenticated) {
      // Navigate to the target screen if authenticated
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => screen),
      );
    } else {
      // Redirect to login if not authenticated
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    }
  }
}

/// RoleGuard: Checks if the user has the required role(s) to access a screen.
class RoleGuard {
  /// Checks if the user has one of the allowed roles and navigates accordingly.
  static Future<void> checkRole(BuildContext context, Widget screen, List<String> allowedRoles) async {
    final authService = Provider.of<AuthService>(context, listen: false);

    if (authService.isAuthenticated && allowedRoles.contains(authService.getRole()?.name)) {
      // Navigate to the target screen if the user's role is allowed
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => screen),
      );
    } else {
      // Logout and redirect to login if role is not allowed
      await authService.logout();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    }
  }
}
