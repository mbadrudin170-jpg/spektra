import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:spektra/fitur/diagnostik/daftar_tes.dart';
import 'package:spektra/fitur/diagnostik/model/hasil_tes.dart';
import 'package:spektra/fitur/diagnostik/screens/ringkasan_screen.dart';
import 'package:spektra/fitur/diagnostik/screens/tes/audio_mikrofon_test_screen.dart';
import 'package:spektra/fitur/diagnostik/screens/tes/audio_speaker_test_screen.dart';
import 'package:spektra/fitur/diagnostik/screens/tes/dead_pixel_test_screen.dart';
import 'package:spektra/fitur/diagnostik/screens/tes/getar_test_screen.dart';
import 'package:spektra/fitur/diagnostik/screens/tes/kecerahan_test_screen.dart';
import 'package:spektra/fitur/diagnostik/screens/tes/multi_touch_test_screen.dart';
import 'package:spektra/fitur/diagnostik/screens/tes/senter_test_screen.dart';
import 'package:spektra/fitur/diagnostik/screens/tes/tombol_volume_test_screen.dart';
import 'package:spektra/fitur/diagnostik/screens/tes/warna_layar_test_screen.dart';
import 'package:spektra/fitur/diagnostik/widgets/pesan_hanya_android.dart';
import 'package:spektra/fitur/diagnostik/widgets/status_tes_badge.dart';

// Layar grid kartu "Diagnostik Perangkat". Hasil tiap tes dikumpulkan
// in-memory selama sesi (tanpa persistensi); layar ringkasan dibuka lewat
// tombol di AppBar.
class DiagnostikScreen extends StatefulWidget {
  const DiagnostikScreen({super.key});

  @override
  State<DiagnostikScreen> createState() => _DiagnostikScreenState();
}

class _DiagnostikScreenState extends State<DiagnostikScreen> {
  final Map<String, HasilTes> _hasil = {};

  Future<void> _jalankan(String id) async {
    final hasil = await Navigator.of(context).push<HasilTes>(
      MaterialPageRoute<HasilTes>(builder: (_) => _bangunLayar(id)),
    );
    if (hasil != null && mounted) {
      setState(() => _hasil[id] = hasil);
    }
  }

  Future<void> _lihatRingkasan() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => RingkasanScreen(hasil: _hasil.values.toList()),
      ),
    );
  }

  Widget _bangunLayar(String id) => switch (id) {
    'warna_layar' => const WarnaLayarTestScreen(),
    'dead_pixel' => const DeadPixelTestScreen(),
    'multi_touch' => const MultiTouchTestScreen(),
    'kecerahan' => const KecerahanTestScreen(),
    'getar' => const GetarTestScreen(),
    'audio_speaker' => const AudioSpeakerTestScreen(),
    'audio_mikrofon' => const AudioMikrofonTestScreen(),
    'senter' => const SenterTestScreen(),
    'tombol_volume' => const TombolVolumeTestScreen(),
    _ => PesanHanyaAndroid(pesan: 'Tes tidak dikenal: $id'),
  };

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return Scaffold(
        appBar: AppBar(title: const Text('Diagnostik Perangkat')),
        body: const PesanHanyaAndroid(
          pesan: 'Tes diagnostik hanya tersedia di Android.',
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnostik Perangkat'),
        actions: [
          TextButton.icon(
            onPressed: _lihatRingkasan,
            icon: const Icon(Icons.summarize_outlined),
            label: const Text('Ringkasan'),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 3,
        padding: const EdgeInsets.all(12),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.9,
        children: [
          for (final tes in kDaftarTes)
            _KartuTes(
              tes: tes,
              status: _hasil[tes.id]?.status,
              onTap: () => _jalankan(tes.id),
            ),
        ],
      ),
    );
  }
}

class _KartuTes extends StatelessWidget {
  const _KartuTes({
    required this.tes,
    required this.status,
    required this.onTap,
  });

  final TesDiagnostik tes;
  final StatusTes? status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 6,
            children: [
              Icon(tes.ikon, size: 36, color: tema.colorScheme.primary),
              Text(
                tes.label,
                style: tema.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              StatusTesBadge(status: status),
            ],
          ),
        ),
      ),
    );
  }
}
