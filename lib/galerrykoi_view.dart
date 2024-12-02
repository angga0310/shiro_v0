import 'package:flutter/material.dart';

class GalerrykoiView extends StatefulWidget {
  const GalerrykoiView({super.key});

  @override
  State<GalerrykoiView> createState() => _GalerrykoiViewState();
}

class _GalerrykoiViewState extends State<GalerrykoiView> {
  final List<String> koiTypes = [
    "Kohaku",
    "Showa Sanshoku",
    "Shiro Utsuri",
    "Tancho Kohaku",
    "Ki Utsuri",
    "Hi Utsuri"
  ];

  final Map<String, List<String>> koiImages = {
    "Kohaku": [
      "images/Koi/Kohaku/kohaku1.jpg",
      "images/Koi/Kohaku/kohaku2.jpg",
      "images/Koi/Kohaku/kohaku3.jpg",
    ],
    "Showa Sanshoku": [
      "images/Koi/Showa/showa1.jpg",
      "images/Koi/Showa/showa2.jpg",
      "images/Koi/Showa/showa3.jpg",
    ],
    "Shiro Utsuri": [
      "images/Koi/Shiro Utsuri/shiro1.jpg",
      "images/Koi/Shiro Utsuri/shiro2.jpg",
      "images/Koi/Shiro Utsuri/shiro3.jpg",
    ],
    "Tancho Kohaku": [
      "images/Koi/Tancho/tancho1.jpg",
      "images/Koi/Tancho/tancho2.jpg",
      "images/Koi/Tancho/tancho3.jpg",
    ],
    "Ki Utsuri": [
      "images/Koi/Ki Utsuri/ki1.jpg",
      "images/Koi/Ki Utsuri/ki2.jpg",
      "images/Koi/Ki Utsuri/ki3.jpeg",
    ],
    "Hi Utsuri": [
      "images/Koi/Hi Utsuri/hi1.jpeg",
      "images/Koi/Hi Utsuri/hi2.jpeg",
      "images/Koi/Hi Utsuri/hi3.jpeg",
    ],
  };

  final Map<String, String> koiDescription = {
    "Kohaku":
        "Ikan Koi Kohaku adalah salah satu jenis koi paling populer dan ikonik yang dikenal karena keindahan pola dan warnanya yang elegan. Kohaku memiliki dasar tubuh berwarna putih bersih yang dipadukan dengan pola merah cerah (hi). Pola merah ini terbentuk dalam berbagai variasi, mulai dari bintik hingga garis besar, yang secara estetis menonjolkan keindahan tubuhnya. Keunikan ikan koi Kohaku terletak pada kombinasi warna yang sederhana namun memukau, karena hanya terdiri dari dua warna utama, tetapi dengan tingkat kejernihan dan harmoni yang sangat dihargai oleh para pecinta koi. Pola merah pada Kohaku idealnya tidak menyentuh sirip atau ekor, sehingga menambah daya tarik visualnya.",
    "Showa Sanshoku":
        "Showa Sanshoku adalah jenis ikan koi dengan warna hitam, putih, dan merah.",
    "Shiro Utsuri":
        "Shiro Utsuri adalah koi dengan warna dominan hitam dan putih, memberikan tampilan yang elegan.",
    "Tancho Kohaku":
        "Tancho Kohaku memiliki warna putih dengan corak merah di bagian kepala, simbol keberuntungan.",
    "Ki Utsuri":
        "Ki Utsuri memiliki dominasi warna kuning dengan corak hitam, memberikan kesan cerah.",
    "Hi Utsuri":
        "Hi Utsuri adalah koi dengan warna merah cerah di tubuhnya dan corak hitam.",
  };

  String selectedKoi = "Kohaku";
  int currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            color: Color(0xFF384B70),
            image: DecorationImage(
              image: AssetImage("images/pattern.png"),
              repeat: ImageRepeat.repeat,
              scale: 1.0,
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 42,
                    height: 42,
                    child: Image.asset(
                      "images/icon_galerry.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Text(
                    'Jenis Ikan Koi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                  const SizedBox(
                    width: 191,
                  ),
                  const Icon(
                    Icons.account_circle,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 30, // Menambahkan batasan tinggi pada ListView
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: koiTypes.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedKoi = koiTypes[index];
                            currentImageIndex = 0; // Reset ke gambar pertama
                          });
                        },
                        child: Text(koiTypes[index]),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
                child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 24,
                  ),
                  Container(
                    width: 335,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          )
                        ]),
                    child: Column(
                      children: [
                        Container(
                          height: 180,
                          child: PageView.builder(
  onPageChanged: (index) {
    setState(() {
      currentImageIndex = index;
    });
  },
  itemCount: koiImages[selectedKoi]?.length ?? 0,
  itemBuilder: (context, index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: RotatedBox(
        quarterTurns: 1, // 1 berarti putar 90 derajat searah jarum jam
        child: Image.asset(
          koiImages[selectedKoi]?[index] ?? '',
          fit: BoxFit.cover,
          height: 180,
          width: double.infinity,
        ),
      ),
    );
  },
),

                        ),
                        SizedBox(height: 8,),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            selectedKoi,
                            style: TextStyle(
                              color: Color(0xFF212121),
                              fontSize: 12,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w500,
                              height: 0.14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            koiDescription[selectedKoi] ?? '',
                            style: TextStyle(
                              color: Color(0xCC666666),
                              fontSize: 10,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
