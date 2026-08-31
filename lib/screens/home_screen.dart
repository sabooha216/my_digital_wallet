import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onThemeChanged;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الرئيسية'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: onThemeChanged,
          ),
        ],
      ),
      body: const Center(
        child: Text('مرحباً بك في تطبيق المحفظة الرقمية'),
      ),
    );
  }
}