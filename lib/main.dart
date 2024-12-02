import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shiro_v0/home_page.dart';
import 'package:shiro_v0/splash_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontFamily: 'Lexend'
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            fontFamily: 'Lexend'
          ) 
        )
      ),
      home: const SplashScreen(),
    );
  }
}




