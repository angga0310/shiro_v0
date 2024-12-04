import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shiro_v0/database/api.dart';
import 'package:shiro_v0/model/kolam.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Timer? _timer;

  List<num> suhuChart = [0, 40, 26, 30]; //[Min Max] [batas aman]
  List<num> phChart = [0, 14, 6.5, 8];
  List<num> tdsChart = [0, 500, 0, 150];
  int dataPoint = 30;

  String selectedData = 'suhu';
  Map<String, dynamic>? selectedKolam;
  List<Kolam> kolamData = [
    // Kolam(
    //     id: 0,
    //     temperature: 0,
    //     tds: 0,
    //     ph: 0,
    //     timestamp: DateTime(1965, 10, 30, 5, 0))
  ];

  @override
  void initState() {
    super.initState();
    // selectedKolam = kolamData.isNotEmpty ? kolamData[0] : null;
    getData();
    _startTimer();
  }

  @override
  void dispose() {
    // Membatalkan timer saat widget dihancurkan
    _timer?.cancel();
    super.dispose();
  }

  double mapValue(num value, List<num> limit) {
    double min = limit[0].toDouble();
    double max = limit[1].toDouble();
    double mappedValue = (value - min) / (max - min);
    {}
    return mappedValue.clamp(0.0, 1.0);
  }

  Color colorValue(num value, List<num> limit) {
    if ((value > limit[2]) && (value < limit[3])) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
      refreshData(); // Menjalankan method refreshData setiap 1 menit
    });
  }

  void refreshData() async {
    if (kolamData.isEmpty) {
      getData();
      return;
    }
    var response = await http.get(Uri.parse(
        '${Api.urlData}?start_datetime=${kolamData[0].timestamp}&limit=$dataPoint'));
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['code'] != 200) return;
      List<dynamic> data = jsonDecode(response.body)['data'];
      for (int i = 0; i < data.length; i++) {
        Map<String, dynamic> dataMap = data[i];
        Kolam dataKolam = Kolam.fromJson(dataMap);
        if (!mounted) return;
        setState(() {
          kolamData.insert(0, dataKolam);
          kolamData.removeLast();
        });
      }
      print(kolamData[0].temperature.toString());
    }
  }

  void getData() async {
    var response = await http.get(Uri.parse('${Api.urlData}?row=$dataPoint'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      if (data.isNotEmpty) kolamData = [];
      for (int i = 0; i < data.length; i++) {
        Map<String, dynamic> dataMap = data[i];
        Kolam dataKolam = Kolam.fromJson(dataMap);
        if (!mounted) return;
        setState(() {
          kolamData.add(dataKolam);
        });
      }
      print(kolamData[0].temperature.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                BackgroundPattern(),
                Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          height: 48,
                        ),
                        const Padding(padding: EdgeInsets.all(8)),
                        Image.asset("images/monitoring_logo.png"),
                        const SizedBox(
                          width: 4,
                        ),
                        const Text(
                          'Monitoring Kolam ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        const SizedBox(
                          width: 159,
                        ),
                        PopupMenuButton<String>(
                          onSelected: (String value) {
                            if (value == 'logout') {
                              _logout(); // Call logout function
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              const PopupMenuItem<String>(
                                value: 'logout',
                                child: Text('Logout'),
                              ),
                            ];
                          },
                          child: const Icon(
                            Icons.account_circle,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 180, // Tinggi card
                      width: 372, // Lebar card
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16), // Sudut melengkung
                        ),
                        elevation: 4, // Shadow di bawah card
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    child: _buildIndicator(
                                      value: mapValue(
                                          kolamData.isNotEmpty
                                              ? kolamData[0].temperature
                                              : suhuChart[0],
                                          suhuChart),
                                      label: (kolamData.isNotEmpty
                                              ? kolamData[0].temperature
                                              : 0)
                                          .toString(),
                                      unit: "°C",
                                      color: kolamData.isNotEmpty
                                          ? colorValue(kolamData[0].temperature,
                                              suhuChart)
                                          : Colors.yellow,
                                      status: '',
                                    ),
                                    onTap: () {
                                      setState(() {
                                        selectedData = "suhu";
                                      });
                                    },
                                  ),
                                  GestureDetector(
                                    child: _buildIndicator(
                                      value: mapValue(
                                          kolamData.isNotEmpty
                                              ? kolamData[0].ph
                                              : phChart[0],
                                          phChart),
                                      label: (kolamData.isNotEmpty
                                              ? kolamData[0].ph
                                              : 0)
                                          .toString(),
                                      unit: "PH",
                                      color: kolamData.isNotEmpty
                                          ? colorValue(kolamData[0].ph, phChart)
                                          : Colors.yellow,
                                      status: '',
                                    ),
                                    onTap: () {
                                      setState(() {
                                        selectedData = "ph";
                                      });
                                    },
                                  ),
                                  GestureDetector(
                                    child: _buildIndicator(
                                      value: mapValue(
                                          kolamData.isNotEmpty
                                              ? kolamData[0].tds
                                              : tdsChart[0],
                                          tdsChart),
                                      label: (kolamData.isNotEmpty
                                              ? kolamData[0].tds
                                              : 0)
                                          .toString(),
                                      unit: "PPM",
                                      color: kolamData.isNotEmpty
                                          ? colorValue(
                                              kolamData[0].tds, tdsChart)
                                          : Colors.yellow,
                                      status: '',
                                    ),
                                    onTap: () {
                                      setState(() {
                                        selectedData = "tds";
                                      });
                                    },
                                  ),
                                ],
                              ),
                              //Status
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildLegend(Colors.green, "Aman"),
                                  const SizedBox(width: 16),
                                  _buildLegend(Colors.red, "Bahaya"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            //ini nanti dropdown
            Container(
              height: 40,
              width: 360,
              color: Colors.greenAccent,
            ),
            const SizedBox(
              height: 12,
            ),
            //grafik data
            Container(
              width: 378,
              height: 216,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: kolamData.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: buildLineChart(kolamData),
                    )
                  : const Center(
                      child: Text(
                        'Tidak ada data grafik',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              width: 378,
              height: 54,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Membuat jarak antar elemen secara otomatis
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Suhu Air',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0), // Padding di antara teks tengah
                    child: Text(
                      kolamData.isNotEmpty
                          ? kolamData[0].temperature.toString()
                          : "-",
                      style: const TextStyle(
                        color: Color(0xFF384B70),
                        fontSize: 18,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Suhu Air',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 12,
            ),
            Container(
              width: 378,
              height: 54,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        'PH Air',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      )),
                  Expanded(
                    child: Center(
                      child: Text(
                        kolamData.isNotEmpty ? kolamData[0].ph.toString() : "-",
                        style: const TextStyle(
                          color: Color(0xFF384B70),
                          fontSize: 18,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Text('PH',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              width: 378,
              height: 54,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      'TDS',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        kolamData.isNotEmpty
                            ? kolamData[0].tds.toString()
                            : "-",
                        style: const TextStyle(
                          color: Color(0xFF384B70),
                          fontSize: 18,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Text(
                      'PPM',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 70,
            )
          ],
        ),
      ),
    );
  }

  void _logout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("User logout bang"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget buildLineChart(List<Kolam> data) {
    if (data.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada data grafik',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }
    data = data.reversed.toList();

    // Ekstrak temperature sebagai data points
    List<double> dataPoints = [];
    if (selectedData == "suhu") {
      dataPoints = data.map((kolam) => kolam.temperature).toList();
    }
    if (selectedData == "ph") {
      dataPoints = data.map((kolam) => kolam.ph).toList();
    }
    if (selectedData == "tds") {
      dataPoints = data.map((kolam) => kolam.tds).toList();
    }

    if (dataPoints.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada data grafik',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

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
          // Menampilkan judul pada sisi kiri
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                value.toStringAsFixed(0),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Lexend',
                ),
              ),
            ),
          ),
          // Menampilkan judul pada sisi bawah
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) => Text(
                DateFormat('HH:mm', 'id_ID')
                    .format(data[value.toInt()].timestamp),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Lexend',
                ),
              ),
            ),
          ),
          // Menonaktifkan judul pada sisi atas
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          // Menonaktifkan judul pada sisi kanan
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
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
            gradient: const LinearGradient(
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

  Widget _buildIndicator({
    required double value,
    required String label,
    required String unit,
    required String status,
    required Color color,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularPercentIndicator(
          radius: 46,
          lineWidth: 10.0,
          percent: value,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                unit,
                style: TextStyle(fontSize: 12, color: color),
              ),
            ],
          ),
          progressColor: color,
          backgroundColor: color.withOpacity(0.2),
        ),
        const SizedBox(height: 8),
        Text(
          status,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 12),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class BackgroundPattern extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240, // Tinggi container
      width: MediaQuery.of(context).size.width, // Lebar container
      decoration: const BoxDecoration(
        color: Color(0xFF384B70), // Warna dasar biru
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        child: Image.asset(
          'images/pattern.png', // Path ke file
          repeat: ImageRepeat.repeat,
          scale: 1.0,
        ),
      ),
    );
  }
}
