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
        "Ikan Koi Kohaku adalah salah satu jenis koi yang paling terkenal dan dihargai di dunia. Kohaku dikenal karena kesederhanaan pola dan warnanya yang memukau, serta simetri dan keharmonisannya. Ikan ini memiliki dasar tubuh berwarna putih bersih yang sangat mencolok, dengan pola merah cerah yang menyebar di bagian atas tubuhnya. Pola merah pada Kohaku, yang dikenal dengan sebutan 'hi', terbentuk dengan sangat indah, mulai dari bentuk bintik hingga garis-garis besar yang membentuk pola yang artistik. Pola merah ini biasanya terletak di bagian tubuh utama seperti punggung dan perut, sementara sirip dan ekor seharusnya tetap berwarna putih, yang meningkatkan keseimbangan visual ikan tersebut. Keindahan Kohaku terletak pada kesederhanaan dua warna utama yang sangat kontras, namun tetap harmonis. Desain pola pada Kohaku harus simetris, dengan warna merah yang jelas dan merata di seluruh tubuh ikan tanpa bercampur dengan warna putih. Pola yang ideal adalah yang memiliki keseimbangan antara ukuran dan penyebaran warna merah yang tidak berlebihan, dan tetap terjaga dengan baik di sepanjang tubuh ikan. Kohaku sangat dihargai dalam dunia pemeliharaan koi karena kesederhanaannya yang elegan dan kemampuannya untuk menarik perhatian dengan keindahan warna yang sangat bersih dan cemerlang.",
    "Showa Sanshoku":
        "Showa Sanshoku adalah jenis koi yang mencolok dengan warna hitam dominan, ditambah dengan aksen merah cerah dan putih yang saling berpadu dengan menawan. Warna hitam pada tubuh Showa Sanshoku sangat pekat dan hampir menyelimuti seluruh tubuh ikan. Sementara itu, pola merah cerah atau 'hi' muncul di beberapa bagian tubuh seperti punggung dan perut, menciptakan kontras yang sangat dramatis dengan warna hitam yang mendalam. Warna putih pada Showa Sanshoku biasanya hadir sebagai aksen di bagian bawah tubuh atau pada sisi tertentu yang membentuk pola yang jelas dan elegan. Pola ini sangat bervariasi dari satu ikan ke ikan lainnya, namun yang paling dicari adalah pola yang seimbang antara ketiga warna tersebut. Idealnya, pola merah dan putih tidak harus menutupi seluruh tubuh, tetapi harus cukup menyebar dan terintegrasi dengan baik dengan warna hitam. Showa Sanshoku adalah jenis koi yang sering menjadi pilihan bagi mereka yang menginginkan koi dengan penampilan yang kuat dan berkarakter, dengan komposisi warna yang penuh kontras namun tetap harmonis. Dengan pola yang kaya dan penuh keindahan, Showa Sanshoku sering kali menjadi daya tarik utama dalam kolam koi atau kontes koi.",
    "Shiro Utsuri":
        "Shiro Utsuri adalah jenis koi dengan dua warna utama, hitam dan putih, yang menciptakan tampilan yang sangat elegan dan misterius. Ikan ini dikenal karena warna hitam pekat yang mendominasi tubuhnya, dengan pola putih yang bersih dan jelas yang menyebar di berbagai bagian tubuh. Kontras antara warna hitam dan putih pada Shiro Utsuri sangat kuat, memberikan kesan yang sangat berkelas dan minimalis. Pola putih pada Shiro Utsuri biasanya terletak di beberapa bagian tubuh, seperti perut, dada, dan kadang-kadang juga pada bagian sirip, yang menambah kesan simetri dan keseimbangan. Shiro Utsuri sangat dihargai karena kesederhanaannya yang elegan, namun tetap memiliki daya tarik visual yang kuat. Warna putih pada Shiro Utsuri harus sangat bersih dan bebas dari bercak atau noda, karena hal ini merupakan indikasi kualitas tinggi dari ikan tersebut. Salah satu hal yang paling dicari dalam Shiro Utsuri adalah kejelasan dan ketajaman garis antara warna hitam dan putih, yang harus terlihat jelas dan sempurna. Keseimbangan antara kedua warna ini sangat penting, dan pola yang teratur dan simetris akan menjadi nilai tambah dalam penilaian.",
    "Tancho Kohaku":
        "Tancho Kohaku adalah varian spesial dari Kohaku yang sangat dihormati dalam budaya Jepang. Ikan ini memiliki tubuh dominan berwarna putih bersih, dengan corak merah yang sangat khas di bagian kepala yang membentuk sebuah lingkaran yang sempurna. Corak merah di kepala ini dikenal sebagai simbol keberuntungan, dan ikan Tancho Kohaku dianggap membawa hoki atau keberuntungan bagi pemiliknya. Keindahan Tancho Kohaku terletak pada kesederhanaan dan kesempurnaan pola yang sangat minimalis, di mana hanya ada satu warna merah di kepala dan seluruh tubuh lainnya berwarna putih. Pola merah ini harus berbentuk bulat sempurna di bagian kepala tanpa melebar atau menyentuh bagian lain dari tubuh. Desain yang sangat sederhana ini, meskipun terlihat minimalis, sebenarnya sangat sulit untuk ditemukan dengan sempurna, menjadikan Tancho Kohaku sebagai salah satu varian yang paling dicari dan dihargai dalam dunia koi. Warna putih yang bersih dan tak ternoda pada tubuh juga menjadi tanda bahwa ikan tersebut memiliki kualitas yang tinggi dan sangat dihargai dalam kontes koi.",
    "Ki Utsuri":
        "Ki Utsuri adalah jenis koi yang memiliki dominasi warna kuning cerah dengan pola hitam yang kontras. Warna kuning pada Ki Utsuri bisa bervariasi dari kuning pucat hingga kuning keemasan yang lebih mencolok, tergantung pada kualitas dan varietas ikan tersebut. Pola hitam pada tubuh Ki Utsuri sangat mencolok dan biasanya membentuk desain yang tidak teratur, seperti garis-garis atau noda yang tersebar di tubuh ikan. Kontras antara warna kuning dan hitam sangat mencolok, menciptakan efek visual yang dramatis dan penuh energi. Dalam beberapa kasus, warna hitam dapat menutupi sebagian besar tubuh ikan, namun yang paling diinginkan adalah keseimbangan antara warna kuning yang cerah dan corak hitam yang teratur dan tidak berlebihan. Ki Utsuri sangat dihargai karena memberikan tampilan yang berbeda dibandingkan dengan koi lainnya, dengan warna cerah dan pola yang kuat. Kualitas terbaik dari Ki Utsuri adalah warna kuning yang bersih dan cerah, serta pola hitam yang simetris dan tidak terlalu dominan. Jenis koi ini ideal bagi mereka yang mencari koi dengan tampilan yang berani dan penuh warna.",
    "Hi Utsuri":
        "Hi Utsuri adalah jenis koi dengan warna dasar merah cerah yang sangat mencolok, dipadukan dengan pola hitam yang menyebar di tubuhnya. Pola merah pada Hi Utsuri sangat kuat dan dominan, dengan variasi yang bisa berupa bintik-bintik atau garis yang lebih besar di sepanjang tubuh. Warna merah cerah atau 'hi' pada tubuh Hi Utsuri menciptakan tampilan yang penuh semangat dan energi, sementara pola hitam memberikan kontras yang kuat dan mempertegas garis-garis tubuh ikan. Warna hitam pada Hi Utsuri biasanya membentuk pola yang tidak teratur, yang bisa berbeda-beda dari satu ikan ke ikan lainnya. Salah satu ciri khas Hi Utsuri adalah kombinasi warna yang sangat mencolok, di mana kedua warna tersebut hadir dalam proporsi yang cukup besar. Pola hitam yang ideal harus terdistribusi secara merata dan tidak terlalu mendominasi warna merah, memberikan keseimbangan visual yang menyenangkan. Hi Utsuri sangat dihargai oleh para kolektor koi yang menyukai koi dengan tampilan yang kuat dan penuh warna, dengan pola yang dramatis dan mengesankan."
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
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 30,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: koiTypes.length,
                  itemBuilder: (context, index) {
                    bool isSelected = selectedKoi == koiTypes[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedKoi = koiTypes[index];
                            currentImageIndex = 0; // Reset ke gambar pertama
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? const Color(0xFF384B70)
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: isSelected
                                ? const BorderSide(
                                    color: Colors.white, width: 2)
                                : BorderSide.none,
                          ),
                        ),
                        child: Text(
                          koiTypes[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Tindakan saat card ditekan, membuka detail
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(selectedKoi),
                        content: SingleChildScrollView(
                          // Tambahkan SingleChildScrollView
                          child: Text(
                            koiDescription[selectedKoi] ??
                                'Deskripsi tidak tersedia',
                            style: const TextStyle(
                              color: Color(0xFF212121),
                              fontSize: 14,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Tutup'),
                          ),
                        ],
                      );
                    },
                  );
                },
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
                    children: [
                      const SizedBox(
                        height: 24,
                      ),
                      Container(
                        width: 335,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        height: 470, // Mengatur tinggi tetap untuk card
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
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
                                      quarterTurns: 1,
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
                            const SizedBox(
                              height: 24,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Align(
                                alignment: Alignment
                                    .centerLeft, // Menyelaraskan teks ke kiri
                                child: Text(
                                  selectedKoi,
                                  style: const TextStyle(
                                    color: Color(0xFF212121),
                                    fontSize: 12,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w500,
                                    height: 0.14,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                _getShortDescription(
                                    koiDescription[selectedKoi] ?? ''),
                                style: const TextStyle(
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk memotong teks jika terlalu panjang
  String _getShortDescription(String description) {
    if (description.length > 720) {
      return description.substring(0, 720) +
          '...'; // Potong dan tambahkan '...'
    }
    return description;
  }
}
