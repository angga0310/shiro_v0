import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedindex = 0;
  final ImagePicker _picker = ImagePicker();
  XFile? _imagefile;
  Map<String, dynamic>? selectedKolam;
  String username = "Dania Angga";
  bool isConnected = true;

  final kolamData = [
    {
      'name': 'Kolam 1',
      'ph': '7.2',
      'suhu': '26',
      'amonia': '0.02',
      'grafik': {
        'suhu': [26, 27, 28, 29, 30],
        'ph': [7.2, 7.1, 7.0, 6.9, 6.8],
        'amonia': [0.02, 0.03, 0.04, 0.05, 0.04],
      },
    },
    {
      'name': 'Kolam 2',
      'ph': '9',
      'suhu': '45',
      'amonia': '1',
      'grafik': {
        'suhu': [27, 28, 26, 25, 27],
        'ph': [6.9, 6.8, 6.7, 6.6, 6.8],
        'amonia': [0.01, 0.02, 0.01, 0.02, 0.01],
      },
    },
  ];

  Future<void> _pickimage(ImageSource source) async {
    final PickedFile = await _picker.pickImage(source: source);
    if (PickedFile != null) {
      setState(() {
        _imagefile = PickedFile;
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Sumber Gambar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(context);
                _pickimage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickimage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onItemTapped(int index) async {
    setState(() {
      _selectedindex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedKolam = kolamData.isNotEmpty ? kolamData[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedindex,
        children: [
          // Halaman home
          Center(
            child: Container(
              color: const Color(0xFF384B70),
              constraints: const BoxConstraints.expand(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 25,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("images/Icon_kolam.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          const Text(
                            'Kolam Koi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: 338,
                      height: 216,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: (selectedKolam != null &&
                              selectedKolam!['grafik'] != null &&
                              selectedKolam!['grafik'] is Map<String, List>)
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: buildLineChart(
                                Map<String, List<dynamic>>.from(
                                    selectedKolam!['grafik']),
                              ),
                            )
                          : const Center(
                              child: Text(
                                'Tidak ada data grafik',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      width: 380,
                      height: 467,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Kondisi Kolam',
                            style: TextStyle(
                              color: Color(0xFF384B70),
                              fontSize: 14,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Dropdown button
                          DropdownButton<String>(
                              value: selectedKolam!['name'],
                              items: kolamData
                                  .map<DropdownMenuItem<String>>((kolam) {
                                return DropdownMenuItem<String>(
                                  value: kolam['name'] as String,
                                  child: Text(
                                    kolam['name'] as String,
                                    style: const TextStyle(
                                      color: Color(0xFF384B70),
                                      fontSize: 10,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedKolam = kolamData.firstWhere(
                                      (kolam) => kolam['name'] == value);
                                  print('Selected Kolam: $selectedKolam');
                                });
                              }),

                          // Garis pemisah
                          const Divider(color: Color(0x26384B70), thickness: 2),
                          const SizedBox(height: 16),

                          // Bagian 4 card di bawah
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Kolom kiri dengan 3 card kecil
                              Column(
                                children: [
                                  Container(
                                    width: 148,
                                    height: 81,
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEAEDF3),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Row(
                                            children: [
                                              const Text(
                                                'Suhu Air',
                                                style: TextStyle(
                                                  color: Color(0xFF384B70),
                                                  fontSize: 12,
                                                  fontFamily: 'Lexend',
                                                  fontWeight: FontWeight.w500,
                                                  height: 0,
                                                ),
                                              ),
                                              const Spacer(),
                                              Icon(
                                                Icons.water_drop,
                                                color: getSuhuColor(
                                                    selectedKolam![
                                                        'suhu']!), // Warna ikon
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '${selectedKolam!['suhu']}°C',
                                          style: const TextStyle(
                                            color: Color(0xFF6881B0),
                                            fontSize: 18,
                                            fontFamily: 'Lexend',
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 148,
                                    height: 81,
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEAEDF3),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Row(
                                            children: [
                                              const Text(
                                                'PH Air',
                                                style: TextStyle(
                                                  color: Color(0xFF384B70),
                                                  fontSize: 12,
                                                  fontFamily: 'Lexend',
                                                  fontWeight: FontWeight.w500,
                                                  height: 0,
                                                ),
                                              ),
                                              const Spacer(),
                                              Icon(
                                                Icons.water_drop,
                                                color: getPHColor(
                                                    selectedKolam![
                                                        'ph']!), // Warna ikon
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          selectedKolam!['ph']!,
                                          style: const TextStyle(
                                            color: Color(0xFF6881B0),
                                            fontSize: 18,
                                            fontFamily: 'Lexend',
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 148,
                                    height: 81,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEAEDF3),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Row(
                                            children: [
                                              const Text(
                                                'Amonia',
                                                style: TextStyle(
                                                  color: Color(0xFF384B70),
                                                  fontSize: 12,
                                                  fontFamily: 'Lexend',
                                                  fontWeight: FontWeight.w500,
                                                  height: 0,
                                                ),
                                              ),
                                              const Spacer(),
                                              Icon(
                                                Icons.water_drop,
                                                color: getAmoniaColor(
                                                    selectedKolam![
                                                        'amonia']!), // Warna ikon
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '${selectedKolam!['amonia']} ppm',
                                          style: const TextStyle(
                                            color: Color(0xFF6881B0),
                                            fontSize: 18,
                                            fontFamily: 'Lexend',
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),

                              // Card besar di samping
                              Container(
                                width: 147,
                                height: 269,
                                decoration: BoxDecoration(
                                  color: Color(0xFFEAEDF3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, // Menempatkan teks di pinggir
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0,
                                          top: 8.0), // Menambahkan margin
                                      child: Text(
                                        'Sistem IOT',
                                        style: TextStyle(
                                          color: Color(0xFF384B70),
                                          fontSize: 12,
                                          fontFamily: 'Lexend',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 60,
                                    ),
                                    Center(
                                      child: Container(
                                        width: 76,
                                        height: 85,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'images/iotwater.png'),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Center(
                                      child: Container(
                                        width: 75,
                                        height: 22,
                                        decoration: ShapeDecoration(
                                          color: isConnected
                                              ? Color(0xFF9CD3BE)
                                              : Color(
                                                  0xFFFF6961), // Hijau jika terhubung, merah jika tidak
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(28),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            isConnected
                                                ? 'Terhubung'
                                                : 'Tidak Terhubung', // Teks berubah sesuai kondisi
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ),
            ),
          ),

          // Halaman cek jenis ikan
          Center(
            child: Column(
              children: [
                const Spacer(), // Memberikan ruang kosong di atas
                Center(
                  child: GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: Container(
                      width: 305,
                      height: 269,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFDDDDDD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: _imagefile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(_imagefile!.path),
                                  width: 305,
                                  height: 269,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 24),
                                  Icon(
                                    Icons.camera_alt,
                                    size: 78,
                                    color: Colors.grey[700],
                                  ),
                                  const Text(
                                    'Ketuk untuk \n menambahkan foto',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF384B70),
                                      fontSize: 12,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w500,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 1),
                ElevatedButton(
                  onPressed: () {
                    if (_imagefile == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Silahkan Pilih gambar dahulu'),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      print('Gambar dipilih, proses cek jenis ikan');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(340, 52),
                    backgroundColor: const Color(0xFFB8001F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Cek Jenis ikan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(
                    height: 120), // Jarak tambahan dari tombol ke bawah layar
              ],
            ),
          ),

          // Halaman setting
          const Center(
            child: Text(
              "Settings",
              style: TextStyle(fontSize: 36),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, -1))
            ]),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pets),
              label: 'Koi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedindex,
          selectedItemColor: const Color(0xFF384B70),
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Color getSuhuColor(String suhu) {
    final double? suhuValue = double.tryParse(suhu);
    if (suhuValue == null) return Colors.grey; // Default jika data tidak valid
    if (suhuValue < 20 || suhuValue > 30)
      return Color(0xFFED6A80); // Tidak normal
    return Color(0xFF94C4B2); // Normal
  }

  Color getPHColor(String ph) {
    final double? phValue = double.tryParse(ph);
    if (phValue == null) return Colors.grey; // Default jika data tidak valid
    if (phValue < 6.5 || phValue > 8.5)
      return Color(0xFFED6A80); // Tidak normal
    return Color(0xFF94C4B2); // Normal
  }

  Color getAmoniaColor(String amonia) {
    final double? amoniaValue = double.tryParse(amonia);
    if (amoniaValue == null)
      return Colors.grey; // Default jika data tidak valid
    if (amoniaValue > 0.1) return Color(0xFFED6A80); // Tidak normal
    return Color(0xFF94C4B2); // Normal
  }

  Widget buildLineChart(Map<String, List<dynamic>> grafikData) {
    print("Grafik Data: $grafikData"); // Debugging
    if (grafikData.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada data grafik',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    final List<LineChartBarData> lines = [];

    // Periksa dan tambahkan garis untuk suhu
    if (grafikData['suhu'] != null) {
      lines.add(
        LineChartBarData(
          spots: List.generate(
            grafikData['suhu']!.length,
            (index) => FlSpot(
              index.toDouble(),
              (grafikData['suhu']![index] as num)
                  .toDouble(), // Konversi eksplisit
            ),
          ),
          isCurved: true,
          color: Colors.blue,
          barWidth: 3,
          belowBarData: BarAreaData(show: false),
        ),
      );
    }

    // Periksa dan tambahkan garis untuk pH
    if (grafikData['ph'] != null) {
      lines.add(
        LineChartBarData(
          spots: List.generate(
            grafikData['ph']!.length,
            (index) => FlSpot(
              index.toDouble(),
              (grafikData['ph']![index] as num)
                  .toDouble(), // Konversi eksplisit
            ),
          ),
          isCurved: true,
          color: Colors.green,
          barWidth: 3,
          belowBarData: BarAreaData(show: false),
        ),
      );
    }

    // Periksa dan tambahkan garis untuk amonia
    if (grafikData['amonia'] != null) {
      lines.add(
        LineChartBarData(
          spots: List.generate(
            grafikData['amonia']!.length,
            (index) => FlSpot(
              index.toDouble(),
              (grafikData['amonia']![index] as num)
                  .toDouble(), // Konversi eksplisit
            ),
          ),
          isCurved: true,
          color: Colors.red,
          barWidth: 3,
          belowBarData: BarAreaData(show: false),
        ),
      );
    }

    if (lines.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada data grafik',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: true),
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 22),
          ),
        ),
        lineBarsData: lines,
      ),
    );
  }
}
