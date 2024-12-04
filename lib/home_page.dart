import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shiro_v0/classification_view.dart';
import 'package:shiro_v0/galerrykoi_view.dart';
import 'package:shiro_v0/home_view.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Menyimpan halaman-halaman yang ada
  final List<Widget> _pages = [
    const HomeView(),
    const ClassificationView(),
    const GalerrykoiView(),
  ];

  // Fungsi untuk mengubah halaman aktif
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      body: IndexedStack(
        index: _selectedIndex,  // Menentukan halaman yang ditampilkan
        children: _pages,       // Daftar halaman
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: SalomonBottomBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text("Home"),
              selectedColor: const Color(0xFF384B70),
            ),
            SalomonBottomBarItem(
              icon: const Icon(FontAwesomeIcons.fish),
              title: const Text('Koi'),
              selectedColor: const Color(0xFF384B70),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.settings),
              title: const Text('Settings'),
              selectedColor: const Color(0xFF384B70),
            ),
          ],
        ),
      ),
    );
  }
}
