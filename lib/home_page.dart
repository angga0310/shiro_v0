import 'dart:async';
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shiro_v0/classification_view.dart';
import 'package:shiro_v0/database/api.dart';
import 'package:shiro_v0/galerrykoi_view.dart';
import 'package:shiro_v0/home_view.dart';
import 'package:shiro_v0/model/kolam.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedindex = 0;

  final List<Widget> _pages = [
    const HomeView(), 
    const ClassificationView(),
    const GalerrykoiView(),
  ];

  Future<void> _onItemTapped(int index) async {
    setState(() {
      _selectedindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedindex,
        children: _pages,
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
            )
          ],
        ),
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
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  Map<String, dynamic>? selectedKolam;
  Timer? _timer;
  String selectedData = 'suhu';
  bool isConnected = true;

  final kolamData = [
    {
      'name': 'Kolam 1',
      'ph': '7.2',
      'suhu': '26',
      'Tds': '0.02',
      'grafik': {
        'suhu': [26, 27, 28, 29, 30],
        'ph': [7.2, 7.1, 7.0, 6.9, 6.8],
        'Tds': [0.02, 0.03, 0.04, 0.05, 0.04],
      },
    },
    {
      'name': 'Kolam 2',
      'ph': '9',
      'suhu': '45',
      'Tds': '1',
      'grafik': {
        'suhu': [27, 28, 26, 25, 27],
        'ph': [6.9, 6.8, 6.7, 6.6, 6.8],
        'Tds': [0.01, 0.02, 0.01, 0.02, 0.01],
      },
    },
  ];

  List<Kolam> kolamList = [
    Kolam(
        id: 0,
        temperature: 0,
        tds: 0,
        ph: 0,
        timestamp: DateTime(1965, 10, 30, 5, 0))
  ];

  @override
  void initState() {
    super.initState();
    selectedKolam = kolamData.isNotEmpty ? kolamData[0] : null;
    getData();
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      refresh();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hentikan timer saat widget dihancurkan
    super.dispose();
  }

  void refresh() async{
    var response = await http.get(Uri.parse('${Api.urlData}?row=1'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      for (int i = 0; i < data.length; i++) {
        Map<String, dynamic> orderMap = data[i];
        Kolam dataKolam = Kolam.fromJson(orderMap);
        if (!mounted) return;
        setState(() {
          kolamList.insert(0,dataKolam);
        });
      }
    }
  }

  void getData() async {
    var response = await http.get(Uri.parse('${Api.urlData}?row=30'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      if (data.isNotEmpty) kolamList = [];
      for (int i = 0; i < data.length; i++) {
        Map<String, dynamic> orderMap = data[i];
        Kolam dataKolam = Kolam.fromJson(orderMap);
        if (!mounted) return;
        setState(() {
          kolamList.add(dataKolam);
        });
      }
      print(kolamList[0].temperature.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
                width: 378,
                height: 216,
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
                child: (selectedKolam != null &&
                        selectedKolam!['grafik'] != null &&
                        selectedKolam!['grafik'] is Map<String, List>)
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        // child: buildLineChart(
                        //   Map<String, List<dynamic>>.from(
                        //       selectedKolam!['grafik']),
                        // ),
                        child: buildLineChart(kolamList),
                      )
                    : const Center(
                        child: Text(
                          'Tidak ada data grafik',
                          style: TextStyle(color: Colors.white, fontSize: 16),
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
                    // DropdownButton<String>(
                    //     value: selectedKolam!['name'],
                    //     items: kolamData.map<DropdownMenuItem<String>>((kolam) {
                    //       return DropdownMenuItem<String>(
                    //         value: kolam['name'] as String,
                    //         child: Text(
                    //           kolam['name'] as String,
                    //           style: const TextStyle(
                    //             color: Color(0xFF384B70),
                    //             fontSize: 10,
                    //             fontFamily: 'Lexend',
                    //             fontWeight: FontWeight.w400,
                    //             height: 0,
                    //           ),
                    //         ),
                    //       );
                    //     }).toList(),
                    //     onChanged: (value) {
                    //       setState(() {
                    //         selectedKolam = kolamData
                    //             .firstWhere((kolam) => kolam['name'] == value);
                    //         print('Selected Kolam: $selectedKolam');
                    //       });
                    //     }),

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
                            // Card untuk Suhu Air
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedData = 'suhu';
                                });
                              },
                              child: Container(
                                width: 148,
                                height: 81,
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAEDF3),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: selectedData == 'suhu'
                                        ? Colors
                                            .blue // Warna border jika dipilih
                                        : Colors.transparent,
                                    width: 2,
                                  ),
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
                                                selectedKolam!['suhu']!),
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${kolamList[0].temperature.toString()}°C',
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
                            ),
                            // Card untuk PH Air
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedData = 'ph';
                                });
                              },
                              child: Container(
                                width: 148,
                                height: 81,
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAEDF3),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: selectedData == 'ph'
                                        ? Colors
                                            .blue // Warna border jika dipilih
                                        : Colors.transparent,
                                    width: 2,
                                  ),
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
                                                selectedKolam!['ph']!),
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      kolamList[0].ph.toString(),
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
                            ),

                            // Card untuk Suhu Air
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedData = 'Tds';
                                });
                              },
                              child: Container(
                                width: 148,
                                height: 81,
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAEDF3),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: selectedData == 'Tds'
                                        ? Colors
                                            .blue // Warna border jika dipilih
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          const Text(
                                            'Tds',
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
                                            color: getTdsColor(
                                                selectedKolam!['Tds']!),
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${kolamList[0].tds.toString()} ppm',
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
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),

                        // Card besar di samping
                        Container(
                          width: 147,
                          height: 269,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAEDF3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Menempatkan teks di pinggir
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                    left: 8.0, top: 8.0), // Menambahkan margin
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
                              const SizedBox(
                                height: 60,
                              ),
                              Center(
                                child: Container(
                                  width: 76,
                                  height: 85,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('images/iotwater.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Center(
                                child: Container(
                                  width: 75,
                                  height: 22,
                                  decoration: ShapeDecoration(
                                    color: isConnected
                                        ? const Color(0xFF9CD3BE)
                                        : const Color(
                                            0xFFFF6961), // Hijau jika terhubung, merah jika tidak
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      isConnected
                                          ? 'Terhubung'
                                          : 'Tidak Terhubung', // Teks berubah sesuai kondisi
                                      style: const TextStyle(
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
              const SizedBox(
                height: 80,
              )
            ],
          ),
        ),
      ),
    );
  }

  Color getSuhuColor(String suhu) {
    final double? suhuValue = double.tryParse(suhu);
    if (suhuValue == null) return Colors.grey; // Default jika data tidak valid
    if (suhuValue < 20 || suhuValue > 30)
      return const Color(0xFFED6A80); // Tidak normal
    return const Color(0xFF94C4B2); // Normal
  }

  Color getPHColor(String ph) {
    final double? phValue = double.tryParse(ph);
    if (phValue == null) return Colors.grey; // Default jika data tidak valid
    if (phValue < 6.5 || phValue > 8.5)
      return const Color(0xFFED6A80); // Tidak normal
    return const Color(0xFF94C4B2); // Normal
  }

  Color getTdsColor(String Tds) {
    final double? TdsValue = double.tryParse(Tds);
    if (TdsValue == null)
      return Colors.grey; // Default jika data tidak valid
    if (TdsValue > 0.1) return const Color(0xFFED6A80); // Tidak normal
    return const Color(0xFF94C4B2); // Normal
  }

  // Widget buildLineChart(Map<String, List<dynamic>> grafikData) {
  // if (grafikData.isEmpty || !grafikData.containsKey(selectedData)) {
  //   return const Center(
  //     child: Text(
  //       'Tidak ada data grafik',
  //       style: TextStyle(color: Colors.red, fontSize: 16),
  //     ),
  //   );
  // }

  // List<num> dataPoints =
  //     grafikData[selectedData]!.map((e) => e as num).toList();

  Widget buildLineChart(List<Kolam> data) {
    if (data.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada data grafik',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    // Ekstrak temperature sebagai data points
    
    List<double> dataPoints = [];
    if(selectedData == "suhu") dataPoints = data.map((kolam) => kolam.temperature).toList();
    if(selectedData == "ph") dataPoints = data.map((kolam) => kolam.ph).toList();
    if(selectedData == "Tds") dataPoints = data.map((kolam) => kolam.tds).toList();

    if(dataPoints.isEmpty){
      return const Center(
        child: Text(
          'Tidak ada data grafik',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }
    dataPoints = dataPoints.reversed.toList();
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: dataPoints.length - 1.toDouble(),
        minY: dataPoints.reduce((a, b) => a < b ? a : b).toDouble() - 1,
        maxY: dataPoints.reduce((a, b) => a > b ? a : b).toDouble() + 1,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                value.toStringAsFixed(0),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) => Text(
                'T${value.toInt() + 1}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              dataPoints.length,
              (index) => FlSpot(
                index.toDouble(),
                dataPoints[index].toDouble(),
              ),
            ),
            isCurved: true,
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.cyanAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            barWidth: 2,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.blueAccent.withOpacity(0.4),
                  Colors.cyanAccent.withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: 3,
                color: Colors.white,
                strokeWidth: 1,
                strokeColor: Colors.blueAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
