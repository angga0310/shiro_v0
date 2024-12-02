import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shiro_v0/database/api.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class ClassificationPage extends StatefulWidget {
  const ClassificationPage({super.key});

  @override
  State<ClassificationPage> createState() => _ClassificationPageState();
}

class _ClassificationPageState extends State<ClassificationPage> {
  XFile? _imagefile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            const SizedBox(
              height: 120,
            ),
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
                  // Panggil showFishAnalysisResult secara langsung
                  showFishAnalysisResult(
                      context, File(_imagefile!.path) as File);
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(340, 52),
                backgroundColor: const Color(0xFF384B70),
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
          ],
        ),
      ),
    );
  }

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

  void showFishAnalysisResult(BuildContext context, File imageFile) async {
    // Tampilkan dialog loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
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
              const SizedBox(height: 16),
              const Text(
                'Jenis ikan koi ini adalah',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                result.isEmpty
                    ? 'Tidak Diketahui'
                    : '$result (${(confidence * 100).toStringAsFixed(2)}%)',
                style: const TextStyle(
                  color: Color(0xFFB8001F),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 52),
                  backgroundColor: const Color(0xFFB8001F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                child: const Text(
                  'Kembali',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
    final resizedImage = img.copyResize(originalImage, width: 256, height: 256);

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

}
