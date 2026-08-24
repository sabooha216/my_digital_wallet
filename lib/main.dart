import 'package:flutter/material.dart';

import 'constants/colors.dart';
import 'screens/home_screen.dart';

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

  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digital Wallet',

      themeMode: isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,

      // الوضع الفاتح
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          surface: AppColors.cardBg,
        ),
      ),

      // الوضع الداكن
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: AppColors.darkBackground,
        colorScheme: ColorScheme.dark(
          primary: Colors.white,
          surface: AppColors.darkCardBg,
        ),
      ),

      home: HomeScreen(
        onThemeChanged: _toggleTheme,
        isDarkMode: isDarkMode,
      ),
    );
  }
}