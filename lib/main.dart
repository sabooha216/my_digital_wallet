import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'constants/colors.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyDigitalWalletApp());
}

class MyDigitalWalletApp extends StatefulWidget {
  const MyDigitalWalletApp({super.key});

  @override
  State<MyDigitalWalletApp> createState() => _MyDigitalWalletAppState();
}

class _MyDigitalWalletAppState extends State<MyDigitalWalletApp> {
  bool isDarkMode = false;
  bool isLoggedIn = true; // جعلناها true مؤقتاً لتظهر الشاشة الرئيسية مباشرة

  Locale appLocale = const Locale('ar'); // اللغة الافتراضية

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      
      locale: appLocale, // ربط التطبيق بمتغير اللغة
      
      debugShowCheckedModeBanner: false,
      title: 'Digital Wallet',

      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          surface: AppColors.cardBg,
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: AppColors.darkBackground,
        colorScheme: ColorScheme.dark(
          primary: Colors.white,
          surface: AppColors.darkCardBg,
        ),
      ),

      home: isLoggedIn
          ? HomeScreen(
              onThemeChanged: _toggleTheme,
              isDarkMode: isDarkMode,
              onLanguageChanged: _changeLanguage, // تمرير دالة تغيير اللغة
            )
          : LoginScreen(
              onThemeChanged: _toggleTheme,
              isDarkMode: isDarkMode,
              onLogin: () {
                setState(() {
                  isLoggedIn = true;
                });
              },
            ),
    );
  }
}