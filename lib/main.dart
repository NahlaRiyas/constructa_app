import 'package:constructa_app/theme/palette.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth/auth_wrapper.dart';
import 'auth/forgot_password_screen.dart';
import 'auth/login_screen.dart';
import 'auth/onboarding_screen.dart';
import 'auth/signup_screen.dart';
import 'auth/splash_screen.dart';
import 'core/common/utils/app_settings.dart';
import 'firebase_options.dart';
import 'modules/admin/navigation/admin_shell.dart';
import 'modules/user/screens/user_companies_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ConstructaApp());
}

class ConstructaApp extends StatelessWidget {
  const ConstructaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppSettings(),
      builder: (context, _) {
        final settings = AppSettings();
        return MaterialApp(
          title: 'Constructa',
          debugShowCheckedModeBanner: false,
          themeMode: settings.themeMode,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.light,
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              onPrimary: AppColors.textLight,
              secondary: AppColors.secondary,
              surface: AppColors.background,
              onSurface: AppColors.textPrimary,
              outlineVariant: AppColors.borderLight,
            ),
            scaffoldBackgroundColor: AppColors.background,
            cardColor: AppColors.cardBackground,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.cardBackground,
              foregroundColor: AppColors.textPrimary,
              elevation: 0,
            ),
            textTheme: GoogleFonts.poppinsTextTheme(
              ThemeData.light().textTheme,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.dark,
              seedColor: AppColors.primary,
              primary: AppColors.primaryContainer,
              onPrimary: AppColors.textLight,
              secondary: AppColors.secondaryContainer,
              surface: AppColors.darkBackground,
              onSurface: AppColors.textLight,
              onSurfaceVariant: AppColors.textMuted,
              outlineVariant: AppColors.surfaceDark,
            ),
            scaffoldBackgroundColor: AppColors.darkBackground,
            cardColor: AppColors.surfaceDark,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.surfaceDark,
              foregroundColor: AppColors.textLight,
              elevation: 0,
            ),
            textTheme: GoogleFonts.poppinsTextTheme(
              ThemeData.dark().textTheme,
            ),
          ),
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/onboarding': (context) => const OnboardingScreen(),
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignUpScreen(),
            '/forgot-password': (context) => const ForgotPasswordScreen(),
            '/home': (context) => const AuthWrapper(),
            '/companies': (context) => const UserCompaniesScreen(),
            '/admin': (context) => const AdminShell(),
          },
        );
      },
    );
  }
}
