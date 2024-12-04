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
  late List<Widget> _pages; // Declare _pages as a late variable

  // Fungsi untuk mengubah halaman aktif
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Fungsi untuk mengubah halaman ke GalerrykoiView
  void _goToGalerryKoi() {
    setState(() {
      _selectedIndex = 2; // Indeks untuk GalerrykoiView
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize _pages after the instance is fully initialized
    _pages = [
      const HomeView(),
      ClassificationView(goToGalerryKoi: _goToGalerryKoi),
      const GalerrykoiView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      body: IndexedStack(
        index: _selectedIndex, // Menentukan halaman yang ditampilkan
        children: _pages, // Daftar halaman
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
              icon: const Icon(Icons.photo_album), // Ganti dengan ikon galeri
              title: const Text('Galerry'), // Ubah teks menjadi Galerry
              selectedColor: const Color(0xFF384B70),
            ),
          ],
        ),
      ),
    );
  }
}
