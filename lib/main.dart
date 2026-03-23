import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/main_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: FoodPalApp(),
    ),
  );
}

class FoodPalApp extends StatelessWidget {
  const FoodPalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FoodPal',
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
    );
  }
}
