import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shiro_v0/database/api.dart';
import 'package:shiro_v0/model/kolam.dart';
import 'package:http/http.dart' as http;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String selectedData = 'suhu';
  Map<String, dynamic>? selectedKolam;
  List<Kolam> kolamList = [
    Kolam(
        id: 0,
        temperature: 0,
        tds: 0,
        ph: 0,
        timestamp: DateTime(1965, 10, 30, 5, 0))
  ];
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
  void initState() {
    super.initState();
    selectedKolam = kolamData.isNotEmpty ? kolamData[0] : null;
    getData();
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
                                  _buildIndicator(
                                    value: 0.26,
                                    label: "26.56",
                                    unit: "°C",
                                    color: Colors.green,
                                    status: '',
                                  ),
                                  _buildIndicator(
                                    value: 0.88,
                                    label: "123.12",
                                    unit: "PH",
                                    color: Colors.red,
                                    status: '',
                                  ),
                                  _buildIndicator(
                                    value: 0.88,
                                    label: "8.86",
                                    unit: "PPM",
                                    color: Colors.green,
                                    status: '',
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
              child: (selectedKolam != null &&
                      selectedKolam!['grafik'] != null &&
                      selectedKolam!['grafik'] is Map<String, List>)
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8),
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
                  Expanded(
                    child: Center(
                      child: Text(
                        '26.56',
                        style: TextStyle(
                          color: Color(0xFF384B70),
                          fontSize: 18,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Text(
                      '°C',
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
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
                        '123.12 ',
                        style: TextStyle(
                          color: Color(0xFF384B70),
                          fontSize: 18,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
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
            SizedBox(
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
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
                        '8.86',
                        style: TextStyle(
                          color: Color(0xFF384B70),
                          fontSize: 18,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
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
            SizedBox(
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

    // Ekstrak temperature sebagai data points

    List<double> dataPoints = [];
    if (selectedData == "suhu")
      dataPoints = data.map((kolam) => kolam.temperature).toList();
    if (selectedData == "ph")
      dataPoints = data.map((kolam) => kolam.ph).toList();
    if (selectedData == "amonia")
      dataPoints = data.map((kolam) => kolam.tds).toList();

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
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                value.toStringAsFixed(0),
                style: const TextStyle(
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
                style: const TextStyle(
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
