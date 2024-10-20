import 'package:flutter/material.dart';
import 'package:shiro_v0/register_page.dart';
import 'package:shiro_v0/text_field/text_field.dart';
import 'package:get/get.dart';
import 'package:shiro_v0/text_field/text_fieldpw.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscurepas = true;
  bool ingatsaya = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Selamat Datang",
                style: TextStyle(
                  color: Color(0xFF384B70),
                  fontSize: 24,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text(
                    "Kenali Keindahan Koi, Jaga Kualitas Kolam \n dengan Teknologi IoT",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF384B70),
                      fontSize: 13,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 70),
              Container(
                width: 340,
                child: Center(
                  child: CustomTextField(
                    hintText: 'Masukan E-mail Anda',
                    labelText: 'Email',
                    prefixIcon: Icons.email_outlined,
                    controller: emailcontroller,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email harus diisi';
                      }
                      if (!GetUtils.isEmail(value)) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 340,
                child: Center(
                  child: CustomTextFieldPassword(
                    hintText: 'Masukan Password Anda',
                    labelText: 'Password',
                    prefixIcon: Icons.lock_outline,
                    controller: passwordcontroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password harus diisi';
                      }
                      if (value.length < 8) {
                        return 'Password minimal 8 karakter';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              // "Remember Me" checkbox and "Forgot Password" text button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: ingatsaya,
                          onChanged: (value) {
                            setState(() {
                              ingatsaya = value!;
                            });
                          },
                          activeColor: Color(0xFF384B70),
                        ),
                        const Text(
                          'Ingat Saya',
                          style: TextStyle(
                            color: Color(0xFF384B70),
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // Aksi ketika "Lupa Password" ditekan
                      },
                      child: const Text(
                        'Lupa Password?',
                        style: TextStyle(
                          color: Color(0xFF384B70),
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {
                  // Aksi ketika button Login ditekan
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(340, 52),
                  backgroundColor: Color(0xFFB8001F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    child: const Divider(
                      thickness: 1,
                      color: Color(0xFF384B70),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(RegisterPage());
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        color: Color(0xFF384B70),
                        fontSize: 12,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                  Container(
                    width: 120,
                    child: const Divider(
                      thickness: 1,
                      color: Color(0xFF384B70),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
