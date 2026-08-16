import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyDigitalWalletApp());
}

class MyDigitalWalletApp extends StatelessWidget {
  const MyDigitalWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digital Wallet',
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}