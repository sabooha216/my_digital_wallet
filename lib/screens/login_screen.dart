import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  bool _isNewUser = false;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // المتحكمات الجديدة حسب طلبك
  final _fullNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthPlaceDateController = TextEditingController();
  final _currentLocationController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _birthPlaceDateController.dispose();
    _currentLocationController.dispose();
    super.dispose();
  }

  Future<void> _processLoginOrRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final username = email.split('@').first;
    final dbHelper = DatabaseHelper.instance;

    if (!_isNewUser) {
      final existingUser = await dbHelper.getUserByName(username);
      if (existingUser != null) {
        widget.onLogin(rememberMe, username);
      } else {
        setState(() { _isNewUser = true; });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حساب جديد! أكمل بياناتك لإنشاء المحفظة 👇'), backgroundColor: Colors.blueAccent),
        );
      }
    } else {
      await dbHelper.insertUser({
        DatabaseHelper.columnName: username,
        DatabaseHelper.columnBalance: 1000.0,
        DatabaseHelper.columnFullName: _fullNameController.text.isEmpty ? 'غير محدد' : _fullNameController.text,
        DatabaseHelper.columnDob: _dobController.text.isEmpty ? 'غير محدد' : _dobController.text,
        DatabaseHelper.columnPhone: _phoneController.text.isEmpty ? 'غير محدد' : _phoneController.text,
        DatabaseHelper.columnBirthPlaceDate: _birthPlaceDateController.text.isEmpty ? 'غير محدد' : _birthPlaceDateController.text,
        DatabaseHelper.columnCurrentLocation: _currentLocationController.text.isEmpty ? 'غير محدد' : _currentLocationController.text,
      });
      widget.onLogin(rememberMe, username);
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
                  const Icon(Icons.account_balance_wallet, size: 100, color: Colors.blueAccent),
                  const SizedBox(height: 32),
                  Text(
                    AppLocalizations.of(context)!.welcomeMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isNewUser ? 'أكمل بياناتك لإنشاء المحفظة' : 'سجل دخولك للمحفظة الرقمية',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  
                  TextFormField(
                    controller: _emailController,
                    enabled: !_isNewUser,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'البريد الإلكتروني',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) => value!.isEmpty ? 'الرجاء إدخال البريد الإلكتروني' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    enabled: !_isNewUser,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) => value!.isEmpty ? 'الرجاء إدخال كلمة المرور' : null,
                  ),
                  
                  // =======================================
                  // الحقول الجديدة بترتيبك
                  // =======================================
                  if (_isNewUser) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    
                    // 1. الاسم الرباعي
                    TextFormField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        labelText: 'الاسم الرباعي',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // 2. تاريخ الميلاد
                    TextFormField(
                      controller: _dobController,
                      decoration: InputDecoration(
                        labelText: 'تاريخ الميلاد',
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // 3. رقم الجوال
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'رقم الجوال',
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // 4. مكان وتاريخ الميلاد
                    TextFormField(
                      controller: _birthPlaceDateController,
                      decoration: InputDecoration(
                        labelText: 'مكان وتاريخ الميلاد',
                        prefixIcon: const Icon(Icons.cake),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // 5. الموقع الحالي
                    TextFormField(
                      controller: _currentLocationController,
                      decoration: InputDecoration(
                        labelText: 'الموقع الحالي',
                        prefixIcon: const Icon(Icons.location_on_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],

                  if (!_isNewUser) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (value) => setState(() => rememberMe = value!),
                        ),
                        const Text('تذكرني (حفظ الجلسة)'),
                      ],
                    ),
                  ],

                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _processLoginOrRegister,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      _isNewUser ? 'إنشاء الحساب وبدء الاستخدام' : 'تسجيل الدخول',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
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