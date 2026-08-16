import 'package:constructa_app/theme/palette.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth/auth_wrapper.dart';
import 'auth/forgot_password_screen.dart';
import 'auth/login_screen.dart';
import 'auth/onboarding_screen.dart';
import 'auth/signup_screen.dart';
import 'auth/splash_screen.dart';
import 'firebase_options.dart';
import 'modules/user/screens/user_companies_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ConstructaApp());
}

class ConstructaApp extends StatelessWidget {
  const ConstructaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Constructa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          onPrimary: AppColors.textLight,
          secondary: AppColors.secondary,
          surface: AppColors.background,
          onSurface: AppColors.textPrimary,
          outline: AppColors.borderLight,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: AppColors.background,
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
      },
    );
  }
}
