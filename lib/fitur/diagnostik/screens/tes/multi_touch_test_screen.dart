import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:spektra/fitur/diagnostik/model/hasil_tes.dart';
import 'package:spektra/fitur/diagnostik/widgets/pesan_hanya_android.dart';
import 'package:spektra/fitur/diagnostik/widgets/tes_footer.dart';

// Tes multi-touch: menampilkan titik dan koordinat tiap pointer aktif;
// pengguna memverifikasi jumlah jari maksimal yang terbaca.
class MultiTouchTestScreen extends StatefulWidget {
  const MultiTouchTestScreen({super.key});

  @override
  State<MultiTouchTestScreen> createState() => _MultiTouchTestScreenState();
}

class _MultiTouchTestScreenState extends State<MultiTouchTestScreen> {
  final Map<int, Offset> _pointers = {};

  void _selesaikan(StatusTes status) {
    Navigator.of(context)
        .pop(HasilTes(id: 'multi_touch', label: 'Multi-Touch', status: status));
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return Scaffold(
        appBar: AppBar(title: const Text('Multi-Touch')),
        body: const PesanHanyaAndroid(),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Multi-Touch')),
      body: Column(
        children: [
          Expanded(
            child: ColoredBox(
              color: Colors.black,
              child: Listener(
                onPointerDown: (event) =>
                    setState(() => _pointers[event.pointer] = event.position),
                onPointerMove: (event) => setState(() {
                  if (_pointers.containsKey(event.pointer)) {
                    _pointers[event.pointer] = event.position;
                  }
                }),
                onPointerUp: (event) =>
                    setState(() => _pointers.remove(event.pointer)),
                onPointerCancel: (event) =>
                    setState(() => _pointers.remove(event.pointer)),
                child: Stack(
                  children: [
                    CustomPaint(
                      painter: _TitikPointerPainter(_pointers),
                      size: Size.infinite,
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: Text(
                        'Sentuh layar dengan beberapa jari.\nJumlah jari aktif: ${_pointers.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
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

class _TitikPointerPainter extends CustomPainter {
  _TitikPointerPainter(this.pointers);

  final Map<int, Offset> pointers;

  @override
  void paint(Canvas canvas, Size size) {
    final titik = Paint()..color = Colors.cyanAccent;
    for (final entry in pointers.entries) {
      final posisi = entry.value;
      canvas.drawCircle(posisi, 36, titik);
      final teks = TextPainter(
        text: TextSpan(
          text:
              'jari ${entry.key}\n(${posisi.dx.toInt()}, ${posisi.dy.toInt()})',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      teks.paint(canvas, posisi + const Offset(44, -12));
    }
  }

  @override
  bool shouldRepaint(covariant _TitikPointerPainter oldDelegate) => true;
}
