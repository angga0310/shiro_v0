import 'package:flutter/material.dart';
import 'package:shiro_v0/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF384B70),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Mengatur agar berada di tengah vertikal
          children: [
            Container(
              width: 104,
              height: 121,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/logo.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),// Spasi antara logo dan teks
            const Text(
              'SHIRO',
              style: TextStyle(
                color: Color(0xFFFCFAEE),
                fontSize: 32,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
