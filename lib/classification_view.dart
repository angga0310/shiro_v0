import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiro_v0/database/api.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:get/get.dart';
import 'package:shiro_v0/login_page.dart';

class ClassificationView extends StatefulWidget {
  final VoidCallback goToGalerryKoi;
  const ClassificationView({Key? key, required this.goToGalerryKoi})
      : super(key: key);

  @override
  State<ClassificationView> createState() => _ClassificationViewState();
}

class _ClassificationViewState extends State<ClassificationView> {
  XFile? _imagefile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickimage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      // Gunakan image_cropper untuk memotong gambar
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Gambar',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            hideBottomControls: true,
            lockAspectRatio: false,
          ),
        ],
        aspectRatio: CropAspectRatio(
            ratioX: 1, ratioY: 1), // Opsional, untuk menetapkan rasio
      );

      if (croppedFile != null) {
        setState(() {
          _imagefile = XFile(croppedFile.path);
        });
      }
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

  Future<Map<String, dynamic>> classify(File imageFile) async {
    try {
      // Baca gambar asli
      final originalBytes = await imageFile.readAsBytes();
      final originalImage = img.decodeImage(originalBytes);

      if (originalImage == null) {
        throw Exception('Gambar tidak valid');
      }

      // Ubah ukuran gambar menjadi 256 x 256
      final resizedImage =
          img.copyResize(originalImage, width: 256, height: 256);

      // Konversi gambar yang diubah ukurannya menjadi byte array
      final resizedBytes = img.encodeJpg(resizedImage);

      // Encode file ke Base64
      final base64Image = base64Encode(resizedBytes);
      final fileName = imageFile.path.split('/').last;

      // Kirim request ke server
      final url = Uri.parse(Api.urlClassify); // Ganti dengan URL server Anda
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'base64': base64Image,
          'name': fileName,
        }),
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        return {
          'class': decodedData['data']['most_likely']['class'],
          'confidence': decodedData['data']['most_likely']['confidence'],
        };
      } else {
        throw Exception('Error ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

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
                  PopupMenuButton<String>(
                    onSelected: (String value) {
                      if (value == 'logout') {
                        logout(); // Call logout function
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
                              _showImageSourceDialog();
                            },
                            child: Container(
                              height: 275,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFBDBDBD),
                                borderRadius: BorderRadius.circular(12),
                              ),
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
                                  : const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                if (_imagefile == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Silahkan Pilih gambar dahulu'),
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  // Panggil showFishAnalysisResult secara langsung
                                  showFishAnalysisResult(
                                      context, File(_imagefile!.path) as File);
                                }
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
                            onPressed: () {
                              widget
                                  .goToGalerryKoi(); // Panggil callback untuk menuju GalerrykoiView
                            },
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

  void showFishAnalysisResult(BuildContext context, File imageFile) async {
    // Tampilkan dialog loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: 150,
            height: 150,
            child: Lottie.asset(
              'images/loading.json', // Path ke file loading.json
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );

    // Jalankan fungsi classify dan dapatkan hasilnya
    String result = '';
    num confidence = 0.0;

    try {
      final classificationResult = await classify(imageFile);
      result = classificationResult['class'];
      confidence = classificationResult['confidence'];
    } catch (e) {
      print('Error during classification: $e');
      result = 'Error';
    }

    // Tutup dialog loading
    // await Future.delayed(Duration(seconds: 1));
    Navigator.pop(context);

    // Tampilkan hasil analisis dalam dialog baru
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, // Align ke kiri
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  imageFile,
                  width: 290,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                result.isEmpty ? 'Tidak Diketahui' : result,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Lexend'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${(confidence * 100).toStringAsFixed(2)}% Accurate',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Lexend'),
                  ),
                  const Spacer(),
                  const Text(
                    '100%',
                    style: TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontSize: 12,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: confidence.toDouble(), // Nilai akurasi (0.0 - 1.0)
                backgroundColor: Colors.grey[300],
                color: Colors.green,
                minHeight: 6,
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup dialog
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(270, 42),
                    backgroundColor: const Color(0xFFB8001F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  child: const Text(
                    'Kembali',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lexend'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

void logout() async {
  // Mendapatkan instance SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Menghapus semua data yang terkait dengan login
  await prefs.remove('isLoggedIn');
  await prefs.remove('username');
  await prefs.remove('password');

  // Menampilkan notifikasi logout berhasil
  Get.snackbar(
    'Logout Berhasil',
    'Anda telah keluar',
    backgroundColor: Color(0xFF384B70),
    duration: const Duration(seconds: 2),
    titleText: const Text(
      'Logout Berhasil',
      style: TextStyle(fontFamily: 'Lexend', fontSize: 20, color: Colors.white),
    ),
    messageText: const Text(
      'Anda telah keluar',
      style: TextStyle(fontFamily: 'Lexend', fontSize: 16, color: Colors.white),
    ),
  );

  // Arahkan kembali ke halaman login
  Get.offAll(() => const LoginPage());
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
