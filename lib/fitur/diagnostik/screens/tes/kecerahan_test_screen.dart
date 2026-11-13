import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:spektra/fitur/diagnostik/model/hasil_tes.dart';
import 'package:spektra/fitur/diagnostik/widgets/pesan_hanya_android.dart';
import 'package:spektra/fitur/diagnostik/widgets/tes_footer.dart';

// Tes kecerahan: instruksi menguji rentang redup–terang layar; pengguna
// menilai dari layar aktual (tanpa package baru).
class KecerahanTestScreen extends StatelessWidget {
  const KecerahanTestScreen({super.key});

  void _selesaikan(BuildContext context, StatusTes status) {
    Navigator.of(context)
        .pop(HasilTes(id: 'kecerahan', label: 'Kecerahan', status: status));
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return Scaffold(
        appBar: AppBar(title: const Text('Kecerahan')),
        body: const PesanHanyaAndroid(),
      );
    }
    final tema = Theme.of(context);
    const instruksi = <({IconData ikon, String teks})>[
      (
        ikon: Icons.vertical_align_top,
        teks: 'Naikkan kecerahan layar ke maksimum lewat panel cepat/pengaturan sistem.',
      ),
      (
        ikon: Icons.visibility_outlined,
        teks: 'Amati apakah layar menyala penuh tanpa area gelap, semu, atau kedip.',
      ),
      (
        ikon: Icons.vertical_align_bottom,
        teks: 'Turunkan kecerahan ke minimum; amati apakah layar meredup dengan lancar.',
      ),
      (
        ikon: Icons.check_circle_outline,
        teks: 'Pilih Lulus bila kecerahan berubah sesuai pengaturan; Gagal bila tidak bereaksi.',
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Kecerahan')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Ikuti instruksi berikut:',
                  style: tema.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                for (var i = 0; i < instruksi.length; i++)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      instruksi[i].ikon,
                      color: tema.colorScheme.primary,
                    ),
                    title: Text('${i + 1}. ${instruksi[i].teks}'),
                  ),
              ],
            ),
          ),
          TesFooter(
            onLulus: () => _selesaikan(context, StatusTes.lulus),
            onGagal: () => _selesaikan(context, StatusTes.gagal),
            onTidakTersedia: () =>
                _selesaikan(context, StatusTes.tidakTersedia),
          ),
        ],
      ),
    );
  }
}
