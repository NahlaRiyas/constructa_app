import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../core/models/user_model.dart';
import '../core/services/auth_service.dart';
import '../modules/user/navigation/user_bottom_nav.dart';
import '../modules/constructor/navigation/constructor_bottom_nav.dart';
import '../modules/admin/navigation/admin_shell.dart';
import 'login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final user = authSnapshot.data;
        if (user == null) {
          return const LoginScreen();
        }

        // Fetch user document to check role ('customer', 'company', or 'admin')
        return StreamBuilder<UserModel?>(
          stream: AuthService().getUserData(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final userModel = userSnapshot.data;

            // Admin role (strictly check role field from Firestore)
            if (userModel?.role == 'admin') {
              return const AdminShell();
            }

            if (userModel?.role == 'company' || userModel?.role == 'constructor') {
              return const ConstructorMainNavigationShell();
            }

            // Default to User Module (Customer)
            return const UserMainNavigationShell();
          },
        );
      },
    );
  }
}
