import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/colors.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // تمت إضافة مكتبة الويندوز هنا
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تمت إضافة هذا الجزء لتهيئة قاعدة البيانات للعمل على الويندوز بنجاح
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final prefs = await SharedPreferences.getInstance();

  final bool savedLoginState = prefs.getBool('isLoggedIn') ?? false;
  final String savedUsername = prefs.getString('username') ?? '';

  runApp(
    MyDigitalWalletApp(
      initialLoginState: savedLoginState,
      initialUsername: savedUsername,
    ),
  );
}

class MyDigitalWalletApp extends StatefulWidget {
  final bool initialLoginState;
  final String initialUsername;

  const MyDigitalWalletApp({
    super.key,
    required this.initialLoginState,
    required this.initialUsername,
  });

  @override
  State<MyDigitalWalletApp> createState() => _MyDigitalWalletAppState();
}

class _MyDigitalWalletAppState extends State<MyDigitalWalletApp> {
  bool isDarkMode = false;
  late bool isLoggedIn;
  late String username;

  Locale appLocale = const Locale('ar');

  @override
  void initState() {
    super.initState();

    isLoggedIn = widget.initialLoginState;
    username = widget.initialUsername;
  }

  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void _changeLanguage() {
    setState(() {
      if (appLocale.languageCode == 'ar') {
        appLocale = const Locale('en');
      } else {
        appLocale = const Locale('ar');
      }
    });
  }

  // تسجيل الدخول مع اسم المستخدم
  Future<void> _handleLogin(bool rememberMe, String newUsername) async {
    username = newUsername;

    if (rememberMe) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', newUsername);
    }

    setState(() {
      isLoggedIn = true;
    });
  }

  // تسجيل الخروج
  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('isLoggedIn');
    await prefs.remove('username');

    setState(() {
      isLoggedIn = false;
      username = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: appLocale,
      debugShowCheckedModeBanner: false,
      title: 'Digital Wallet',

      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          surface: AppColors.cardBg,
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: AppColors.darkBackground,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          surface: AppColors.darkCardBg,
        ),
      ),

      home: isLoggedIn
          ? HomeScreen(
              onThemeChanged: _toggleTheme,
              isDarkMode: isDarkMode,
              onLanguageChanged: _changeLanguage,
              onLogout: _handleLogout,
              username: username,
            )
          : LoginScreen(
              onThemeChanged: _toggleTheme,
              isDarkMode: isDarkMode,
              onLogin: _handleLogin,
            ),
    );
  }
}
