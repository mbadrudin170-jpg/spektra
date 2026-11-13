import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:spektra/fitur/diagnostik/model/hasil_tes.dart';
import 'package:spektra/fitur/diagnostik/widgets/pesan_hanya_android.dart';
import 'package:spektra/fitur/diagnostik/widgets/tes_footer.dart';

// Tes dead pixel: pola latar kontras (warna solid + pola grid gelap/terang)
// untuk mendeteksi dead/stuck pixel; ketuk layar untuk berganti pola.
class DeadPixelTestScreen extends StatefulWidget {
  const DeadPixelTestScreen({super.key});

  @override
  State<DeadPixelTestScreen> createState() => _DeadPixelTestScreenState();
}

class _DeadPixelTestScreenState extends State<DeadPixelTestScreen> {
  int _indeks = 0;

  static const _pola = <({String nama, Color warna, bool? gridGelap})>[
    (nama: 'Merah', warna: Colors.red, gridGelap: null),
    (nama: 'Hijau', warna: Colors.green, gridGelap: null),
    (nama: 'Biru', warna: Colors.blue, gridGelap: null),
    (nama: 'Putih', warna: Colors.white, gridGelap: null),
    (nama: 'Hitam', warna: Colors.black, gridGelap: null),
    (nama: 'Grid (hitam di atas putih)', warna: Colors.white, gridGelap: true),
    (nama: 'Grid (putih di atas hitam)', warna: Colors.black, gridGelap: false),
  ];

  void _selesaikan(StatusTes status) {
    Navigator.of(context)
        .pop(HasilTes(id: 'dead_pixel', label: 'Dead Pixel', status: status));
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return Scaffold(
        appBar: AppBar(title: const Text('Dead Pixel')),
        body: const PesanHanyaAndroid(),
      );
    }
    final pola = _pola[_indeks];
    final gridGelap = pola.gridGelap;
    final warnaTeks =
        ThemeData.estimateBrightnessForColor(pola.warna) == Brightness.light
        ? Colors.black
        : Colors.white;
    return Scaffold(
      appBar: AppBar(title: const Text('Dead Pixel')),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () =>
                  setState(() => _indeks = (_indeks + 1) % _pola.length),
              child: gridGelap == null
                  ? ColoredBox(
                      color: pola.warna,
                      child: Center(
                        child: Text(
                          pola.nama,
                          style: TextStyle(color: warnaTeks),
                        ),
                      ),
                    )
                  : CustomPaint(
                      painter: _PolaGridPainter(gelap: gridGelap),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            pola.nama,
                            style: TextStyle(color: warnaTeks),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          TesFooter(
            onLulus: () => _selesaikan(StatusTes.lulus),
            onGagal: () => _selesaikan(StatusTes.gagal),
            onTidakTersedia: () => _selesaikan(StatusTes.tidakTersedia),
          ),
        ],
      ),
    );
  }
}

class _PolaGridPainter extends CustomPainter {
  _PolaGridPainter({required this.gelap});

  // true: garis gelap di atas latar putih; false: garis terang di atas hitam.
  final bool gelap;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = gelap ? Colors.white : Colors.black,
    );
    final garis = Paint()
      ..color = gelap ? Colors.black : Colors.white
      ..strokeWidth = 1;
    const langkah = 24.0;
    for (var x = 0.0; x <= size.width; x += langkah) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), garis);
    }
    for (var y = 0.0; y <= size.height; y += langkah) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), garis);
    }
  }

  @override
  bool shouldRepaint(covariant _PolaGridPainter oldDelegate) =>
      oldDelegate.gelap != gelap;
}
