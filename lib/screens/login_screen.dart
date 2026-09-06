import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// إضافة استدعاء ملف قاعدة البيانات
import '../database/database_helper.dart'; 

class LoginScreen extends StatefulWidget {
  final VoidCallback onThemeChanged;
  final bool isDarkMode;
  final Function(bool, String) onLogin;

  const LoginScreen({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
    required this.onLogin,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // دالة للتعامل مع قاعدة البيانات عند تسجيل الدخول
  Future<void> _processLogin(String username) async {
    final dbHelper = DatabaseHelper.instance;
    
    // 1. البحث عن المستخدم في قاعدة البيانات
    final existingUser = await dbHelper.getUserByName(username);

    // 2. إذا كان المستخدم غير موجود، نقوم بإنشاء حساب جديد له
    if (existingUser == null) {
      await dbHelper.insertUser({
        DatabaseHelper.columnName: username,
        DatabaseHelper.columnBalance: 1000.0, // رصيد افتراضي للمستخدم الجديد
      });
      print('تم تسجيل مستخدم جديد: $username برصيد 1000'); // للتحقق في الكونسول
    } else {
      print('أهلاً بك مجدداً: $username'); // للتحقق في الكونسول
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    size: 100,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 32),

                  Text(
                    AppLocalizations.of(context)!.welcomeMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'سجل دخولك للمحفظة الرقمية',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 32),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'البريد الإلكتروني',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال البريد الإلكتروني';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال كلمة المرور';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value!;
                          });
                        },
                      ),
                      const Text('تذكرني (حفظ الجلسة)'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    // تم تحويل الدالة إلى async لأننا نتعامل مع قاعدة بيانات
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final email = _emailController.text.trim();
<<<<<<< HEAD
                        final username = email.split('@').first;

                        // استدعاء دالة قاعدة البيانات
                        await _processLogin(username);

                        // استكمال عملية تسجيل الدخول وتغيير الشاشة
=======

                        // أخذ اسم المستخدم من الجزء الموجود قبل @
                        final username = email.split('@').first;

>>>>>>> 72b0b3f55fe009f6c5df6c2529b4376b811c6fbe
                        widget.onLogin(rememberMe, username);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'تسجيل الدخول',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}