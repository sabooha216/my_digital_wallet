import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart'; // استدعاء مكتبة الذاكرة
import 'constants/colors.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

// جعلنا الدالة الرئيسية async لانتظار قراءة الذاكرة قبل فتح التطبيق
void main() async {
  // أمر ضروري لفلاتر لتهيئة الذاكرة قبل رسم الشاشات
  WidgetsFlutterBinding.ensureInitialized();
  
  // فتح الذاكرة والبحث عن حالة تسجيل الدخول السابقة
  final prefs = await SharedPreferences.getInstance();
  final bool savedLoginState = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyDigitalWalletApp(initialLoginState: savedLoginState));
}

class MyDigitalWalletApp extends StatefulWidget {
  final bool initialLoginState; // استقبال الحالة من الدالة الرئيسية
  
  const MyDigitalWalletApp({super.key, required this.initialLoginState});

  @override
  State<MyDigitalWalletApp> createState() => _MyDigitalWalletAppState();
}

class _MyDigitalWalletAppState extends State<MyDigitalWalletApp> {
  bool isDarkMode = false;
  late bool isLoggedIn; 

  Locale appLocale = const Locale('ar');

  @override
  void initState() {
    super.initState();
    // تعيين حالة الدخول بناءً على ما وجدناه في الذاكرة
    isLoggedIn = widget.initialLoginState;
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

  // دالة الدخول الجديدة: تستقبل (صح أو خطأ) من زر تذكرني
  Future<void> _handleLogin(bool rememberMe) async {
    if (rememberMe) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true); // حفظ الحالة في الهاتف للأبد
    }
    setState(() {
      isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: appLocale,
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
              onLanguageChanged: _changeLanguage,
            )
          : LoginScreen(
              onThemeChanged: _toggleTheme,
              isDarkMode: isDarkMode,
              onLogin: _handleLogin, // نمرر دالة الدخول الجديدة
            ),
    );
  }
}