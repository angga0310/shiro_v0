import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiro_v0/database/api.dart';
import 'package:shiro_v0/home_page.dart';
import 'package:shiro_v0/model/user.dart';
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
  final TextEditingController usernamecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();

    SharedPreferences.getInstance().then((prefs) {
      String? rememberedUsername = prefs.getString('rememberedusername');
      if (rememberedUsername != null && rememberedUsername.isNotEmpty) {
        usernamecontroller.text = rememberedUsername;
      }
    });
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
                    hintText: 'Masukan Username',
                    labelText: 'Username',
                    prefixIcon: Icons.email_outlined,
                    controller: usernamecontroller,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Username harus diisi';
                      }
                      // Memperbarui regex untuk mengizinkan spasi
                      if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                        return 'Hanya diperbolehkan huruf';
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
                      // if (value.length < 8) {
                      //   return 'Password minimal 8 karakter';
                      // }
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
                  login();
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
              )
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
    if (_formkey.currentState!.validate()) {
      String username = usernamecontroller.text;
      String password = passwordcontroller.text;

      var response = await http
          .get(Uri.parse("${Api.urlLogin}?login=$username&password=$password"));
      if (response.statusCode == 200) {
        // Request successful, parse the response body
        Map<String, dynamic> json = jsonDecode(response.body.toString());
        User user = User.fromJson(json["user"]);

        // Simpan informasi user ke dalam SharedPreferences jika checkbox ingatsaya dicentang
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (ingatsaya) {
          await prefs.setString('rememberedUsername', usernamecontroller.text);
        } else {
          await prefs.remove('rememberedUsername');
        }

        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('username', username);
        await prefs.setString('password', password);

        Get.snackbar(
          'Login Berhasil',
          'Selamat datang, ${user.username}',
          backgroundColor: Colors.white,
          duration: const Duration(seconds: 2),
          titleText: const Text(
            'Login Berhasil',
            style: TextStyle(
                fontFamily: 'Lexend', fontSize: 20, color: Color(0xFF35755D)),
          ),
          messageText: Text(
            'Selamat datang, ${user.username}',
            style: const TextStyle(
                fontFamily: 'Lexend', fontSize: 16, color: Color(0xFF35755D)),
          ),
        );

        Get.off(const HomePage(), arguments: user);
      } else {
        Get.snackbar(
          'Login Gagal',
          'Username atau password salah',
          backgroundColor: const Color(0xFF35755D),
          overlayBlur: 1,
          duration: const Duration(seconds: 2),
          titleText: const Text(
            'Login Gagal',
            style: TextStyle(
                fontFamily: 'Lexend', fontSize: 20, color: Colors.white),
          ),
          messageText: const Text(
            'Username atau password salah',
            style: TextStyle(
                fontFamily: 'Lexend', fontSize: 16, color: Colors.white),
          ),
        );
      }
    }
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (!isLoggedIn) return;

    String username = prefs.getString("username") ?? "";
    String password = prefs.getString("password") ?? "";

    if (username.isEmpty || password.isEmpty) return;

    var response = await http
        .get(Uri.parse("${Api.urlLogin}?login=$username&password=$password"));
    if (response.statusCode == 200) {
      // Request successful, parse the response body
      Map<String, dynamic> json = jsonDecode(response.body.toString());
      User user = User.fromJson(json["user"]);

      Get.snackbar(
        'Login Berhasil',
        'Selamat datang, ${user.username}',
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 2),
        titleText: const Text(
          'Login Berhasil',
          style: TextStyle(
              fontFamily: 'Lexend', fontSize: 20, color: Color(0xFF35755D)),
        ),
        messageText: Text(
          'Selamat datang, ${user.username}',
          style: const TextStyle(
              fontFamily: 'Lexend', fontSize: 16, color: Color(0xFF35755D)),
        ),
      );

      Get.off(const HomePage(), arguments: user);
    }
  }
}
