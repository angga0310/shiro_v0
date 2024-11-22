import 'package:flutter/material.dart';
import 'package:shiro_v0/login_page.dart';
import 'package:shiro_v0/text_field/text_field.dart';
import 'package:get/get.dart';
import 'package:shiro_v0/text_field/text_fieldgender.dart';
import 'package:shiro_v0/text_field/text_fieldpw.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formkey = GlobalKey<FormState>();
  String? JenisKelamin;
  final TextEditingController namacontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController nowacontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController konfirpasswordcontroller =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 65,
                    height: 80,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/Logo.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 21),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Buat Akun",
                      style: TextStyle(
                          color: Color(0xFF384B70),
                          fontSize: 24,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w700,
                          height: 0),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Lengkapi data dibawah ini",
                      style: TextStyle(
                        color: Color(0xFF384B70),
                        fontSize: 13,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 348,
                      child: Center(
                        child: CustomTextField(
                          hintText: 'Nama Lengkap Anda',
                          labelText: 'Nama',
                          prefixIcon: Icons.account_circle_outlined,
                          controller: namacontroller,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Nama harus diisi';
                            }
                            if (RegExp(r'[0-9]').hasMatch(value)) {
                              return 'Pastikan format nama benar';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: 348,
                      child: Center(
                        child: CustomTextField(
                          hintText: 'Email Anda',
                          labelText: 'E-Mail',
                          prefixIcon: Icons.email_outlined,
                          controller: emailcontroller,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email harus diisi';
                            }
                            if (!GetUtils.isEmail(value)) {
                              return 'Format Email tidak valid';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: 348,
                      child: Center(
                        child: GenderDropdown(
                          labelText: 'Jenis Kelamin',
                          prefixIcon: Icons.male_outlined,
                          selectedGender: JenisKelamin,
                          onChanged: (value) {
                            setState(() {
                              JenisKelamin = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Pilih Jenis Kelamin";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: 348,
                      child: Center(
                        child: CustomTextField(
                          hintText: 'No. Whatsapp Anda',
                          labelText: 'No Whatsapp',
                          prefixIcon: Icons.call_outlined,
                          controller: nowacontroller,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'No whatsapp harus diisi';
                            }
                            if (value.length < 12) {
                              return 'Pastikan nomor benar';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: 348,
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
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: 348,
                      child: Center(
                        child: CustomTextFieldPassword(
                          hintText: 'Konfirmasi Password',
                          labelText: 'Re Password',
                          prefixIcon: Icons.lock_outline,
                          controller: konfirpasswordcontroller,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Konfirmasi password harus diisi';
                            }
                            if (value != passwordcontroller.text) {
                              return 'Konfirmasi Password tidak cocok';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {}
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(340, 52),
                        backgroundColor: const Color(0xFFB8001F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, 
                        crossAxisAlignment: CrossAxisAlignment
                            .center, 
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_back_ios_new_outlined,
                              size:
                                  16, 
                              color: Color(
                                  0xFF384B70), 
                            ),
                            padding: EdgeInsets
                                .zero, 
                            constraints:
                                BoxConstraints(), 
                          ),
                          SizedBox(width: 0), 
                          TextButton(
                            onPressed: () {
                              Get.to(LoginPage());
                            },
                            child: const Text(
                              "Kembali ke halaman Login",
                              style: TextStyle(
                                color: Color(0xFF384B70),
                                fontSize: 12, 
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
