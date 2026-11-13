import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:spektra/fitur/diagnostik/model/hasil_tes.dart';
import 'package:spektra/fitur/diagnostik/widgets/pesan_hanya_android.dart';
import 'package:spektra/fitur/diagnostik/widgets/tes_footer.dart';

// Tes warna layar penuh: latar berganti merah → hijau → biru → putih →
// hitam setiap ketukan; pengguna mengamati pixel rusak/tinting lalu menilai.
class WarnaLayarTestScreen extends StatefulWidget {
  const WarnaLayarTestScreen({super.key});

  @override
  State<WarnaLayarTestScreen> createState() => _WarnaLayarTestScreenState();
}

class _WarnaLayarTestScreenState extends State<WarnaLayarTestScreen> {
  static const _warnaUji = <Color>[
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.white,
    Colors.black,
  ];

  int _indeks = 0;

  void _selesaikan(StatusTes status) {
    Navigator.of(context)
        .pop(HasilTes(id: 'warna_layar', label: 'Warna Layar', status: status));
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return Scaffold(
        appBar: AppBar(title: const Text('Warna Layar')),
        body: const PesanHanyaAndroid(),
      );
    }
    final warna = _warnaUji[_indeks];
    final warnaTeks =
        ThemeData.estimateBrightnessForColor(warna) == Brightness.light
        ? Colors.black
        : Colors.white;
    return Scaffold(
      appBar: AppBar(title: const Text('Warna Layar')),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () =>
                  setState(() => _indeks = (_indeks + 1) % _warnaUji.length),
              child: ColoredBox(
                color: warna,
                child: Center(
                  child: Text(
                    'Ketuk layar untuk ganti warna',
                    style: TextStyle(color: warnaTeks),
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
