import 'package:flutter/material.dart';

class ClassificationView extends StatefulWidget {
  const ClassificationView({super.key});

  @override
  State<ClassificationView> createState() => _ClassificationViewState();
}

class _ClassificationViewState extends State<ClassificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF384B70), // Warna dasar biru
          image: DecorationImage(
            image: AssetImage('images/pattern.png'), // Path ke pattern
            repeat: ImageRepeat.repeat,
            scale: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: Image.asset(
                      "images/icon_koi.png",
                      fit: BoxFit.contain, // Menjaga proporsi gambar
                    ),
                  ),
                  const Text(
                    'Klasifikasi Jenis Koi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                  const SizedBox(
                    width: 150,
                  ),
                  const Icon(
                    Icons.account_circle,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            const SizedBox(height: 30), // Jarak setelah teks
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    // Bagian atas card
                    Container(
                      width: 335,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Tambahkan logika untuk membuka kamera atau galeri
                            },
                            child: Container(
                              height: 275,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFBDBDBD),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt,
                                      size: 80, color: Color(0xFF384B70)),
                                  SizedBox(height: 8),
                                  Text(
                                    'Ketuk untuk \nmenambahkan foto',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF384B70),
                                      fontSize: 12,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  CustomPaint(
                                    size: const Size(
                                        double.infinity, 80), // Ukuran garis
                                    painter: LinePainter(), // Gambar garis
                                  ),
                                  const Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.circle,
                                              size: 15,
                                              color: Color(0xFF384B70)),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Unggah foto ikan Koi Anda untuk mengetahui jenis ikan tersebut.',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                                fontFamily: 'Lexend',
                                                fontWeight: FontWeight.w500,
                                                height: 1.4,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                          height: 10), // Jarak antar lingkaran
                                      Row(
                                        children: [
                                          Icon(Icons.circle,
                                              size: 15,
                                              color: Color(0xFF384B70)),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Pastikan foto diambil dari atas dengan pencahayaan \nyang baik untuk hasil terbaik.',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                                fontFamily: 'Lexend',
                                                fontWeight: FontWeight.w500,
                                                height: 1.4,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                              onPressed: () {
                                // Tambahkan logika untuk deteksi
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(270, 31),
                                backgroundColor: const Color(0xFFB8001F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 24,
                                ),
                              ),
                              child: const Text(
                                'Deteksi',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                              )),
                          TextButton(
                            onPressed: () {},
                            child: RichText(
                              text: const TextSpan(
                                text: 'Informasi Jenis Koi ', // Teks utama
                                style: TextStyle(
                                  color: Color(0xFF384B70),
                                  fontSize: 10,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                                children: [
                                  TextSpan(
                                    text: '>',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BackgroundPattern extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height, // Tinggi container
      width: MediaQuery.of(context).size.width, // Lebar container
      decoration: const BoxDecoration(
        color: Color(0xFF384B70), // Warna dasar biru
      ),
      child: Image.asset(
        'images/pattern2.png', // Path ke file
        fit: BoxFit.fill, // Menyesuaikan agar sesuai ukuran container
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF384B70) // Warna garis
      ..strokeWidth = 2.0 // Ketebalan garis
      ..style = PaintingStyle.stroke;

    // Menggambar garis dari titik pertama ke kedua
    canvas.drawLine(
      const Offset(7, 20), // Titik awal garis (sesuaikan X dan Y)
      Offset(7, size.height - 25), // Titik akhir garis
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
