import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shiro_v0/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
void main() async {
  await initializeDateFormatting('id_ID', null);
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




