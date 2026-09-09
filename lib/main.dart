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
              onPrimary: AppColors.onPrimary,
              secondary: AppColors.secondary,
              surface: AppColors.lightBackground,
              onSurface: AppColors.lightTextPrimary,
              outline: AppColors.lightBorderLight,
            ),
            scaffoldBackgroundColor: AppColors.lightBackground,
            cardColor: AppColors.lightCardBackground,
            dialogTheme: const DialogThemeData(
              backgroundColor: AppColors.lightCardBackground,
            ),
            bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: AppColors.lightCardBackground,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.lightCardBackground,
              foregroundColor: AppColors.lightTextPrimary,
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
              onSurface: AppColors.darkTextPrimary,
              onSurfaceVariant: AppColors.darkTextSecondary,
              outline: AppColors.darkBorderLight,
            ),
            scaffoldBackgroundColor: AppColors.darkBackground,
            cardColor: AppColors.darkCardBackground,
            dialogTheme: const DialogThemeData(
              backgroundColor: AppColors.darkCardBackground,
            ),
            bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: AppColors.darkCardBackground,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.darkCardBackground,
              foregroundColor: AppColors.darkTextPrimary,
              elevation: 0,
            ),
            navigationBarTheme: NavigationBarThemeData(
              backgroundColor: AppColors.darkCardBackground,
              indicatorColor: AppColors.darkSurfaceLight,
              labelTextStyle: WidgetStateProperty.all(
                GoogleFonts.poppins(color: AppColors.textLight, fontSize: 12),
              ),
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
