import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spektra/fitur/statistik/model/baterai_info.dart';
import 'package:spektra/fitur/statistik/notifier/baterai_notifier.dart';

// Section "Spesifikasi Baterai" pada halaman statistik (Android saja).
// Data dibaca sekali saat layar dibuka; tombol muat ulang memuat ulang
// snapshot (bukan stream). Nilai yang tidak tersedia ditampilkan sebagai
// `Tidak diketahui`.
class SpesifikasiBateraiSection extends ConsumerWidget {
  const SpesifikasiBateraiSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return const _PesanTidakDidukung();
    }
    final tema = Theme.of(context);
    final bateraiAsync = ref.watch(bateraiProvider);
    final sedangMemuat = bateraiAsync.isLoading;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.battery_full, color: tema.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Spesifikasi Baterai',
                    style: tema.textTheme.titleMedium?.copyWith(
                      color: tema.colorScheme.primary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: sedangMemuat ? null : () => _muatUlang(ref),
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Muat ulang',
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Kapasitas desain pabrik tidak tersedia di Android; estimasi '
                'muatan tersisa ditampilkan dari sistem dan nilainya dapat '
                'berbeda antar perangkat.',
                style: tema.textTheme.bodySmall?.copyWith(
                  color: tema.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (bateraiAsync.isLoading)
              const LinearProgressIndicator()
            else if (bateraiAsync.hasError || bateraiAsync.value == null)
              _GagalMemuat(onCobaLagi: () => _muatUlang(ref))
            else
              _IsiSpesifikasi(info: bateraiAsync.requireValue!),
          ],
        ),
      ),
    );
  }

  static void _muatUlang(WidgetRef ref) {
    unawaited(
      ref.read(bateraiProvider.notifier).muatUlang().catchError((Object error) {
        debugPrint('Gagal memuat ulang info baterai: $error');
      }),
    );
  }
}

class _PesanTidakDidukung extends StatelessWidget {
  const _PesanTidakDidukung();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.battery_unknown, color: tema.colorScheme.outline),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Spesifikasi baterai perangkat hanya tersedia di Android.',
                style: tema.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GagalMemuat extends StatelessWidget {
  const _GagalMemuat({required this.onCobaLagi});

  final VoidCallback onCobaLagi;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.error_outline, color: tema.colorScheme.error),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Gagal memuat spesifikasi baterai.',
                style: tema.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        TextButton.icon(
          onPressed: onCobaLagi,
          icon: const Icon(Icons.refresh),
          label: const Text('Muat ulang'),
        ),
      ],
    );
  }
}

class _IsiSpesifikasi extends StatelessWidget {
  const _IsiSpesifikasi({required this.info});

  final BateraiInfo info;

  @override
  Widget build(BuildContext context) {
    final sisa = info.kapasitasTersisaMah;
    return Column(
      children: [
        const _BarisSpesifikasi(
          label: 'Kapasitas desain (mAh)',
          nilai: 'Tidak diketahui',
          tooltip:
              'Android tidak menyediakan API untuk kapasitas desain pabrik; '
              'nilai mAh yang ditampilkan adalah estimasi muatan tersisa.',
        ),
        _BarisSpesifikasi(
          label: 'Estimasi muatan tersisa (mAh)',
          nilai: sisa == null
              ? 'Tidak diketahui'
              : '≈ ${_angkaRibuan(sisa)} mAh',
        ),
        _BarisSpesifikasi(
          label: 'Level',
          nilai: info.levelPersen == null
              ? 'Tidak diketahui'
              : '${info.levelPersen}%',
        ),
        _BarisSpesifikasi(
          label: 'Status pengisian',
          nilai: _statusPengisianLabel(info.statusPengisian),
        ),
        _BarisSpesifikasi(
          label: 'Sumber pengisian',
          nilai: _sumberChargerLabel(info.sumberCharger),
        ),
        _BarisSpesifikasi(
          label: 'Kesehatan',
          nilai: _kesehatanLabel(info.kesehatan),
        ),
        _BarisSpesifikasi(
          label: 'Suhu',
          nilai: info.suhuCelcius == null
              ? 'Tidak diketahui'
              : '${info.suhuCelcius} °C',
        ),
        _BarisSpesifikasi(
          label: 'Tegangan',
          nilai: info.teganganMv == null
              ? 'Tidak diketahui'
              : '${_angkaRibuan(info.teganganMv!)} mV',
        ),
        _BarisSpesifikasi(
          label: 'Teknologi',
          nilai: info.teknologi ?? 'Tidak diketahui',
        ),
      ],
    );
  }
}

class _BarisSpesifikasi extends StatelessWidget {
  const _BarisSpesifikasi({
    required this.label,
    required this.nilai,
    this.tooltip,
  });

  final String label;
  final String nilai;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final nilaiWidget = Text(
      nilai,
      style: tema.textTheme.bodyMedium?.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      textAlign: TextAlign.end,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(label, style: tema.textTheme.bodyMedium),
          ),
          Expanded(
            flex: 4,
            child: tooltip == null
                ? nilaiWidget
                : Tooltip(message: tooltip!, child: nilaiWidget),
          ),
        ],
      ),
    );
  }
}

String _statusPengisianLabel(String? status) {
  return switch (status) {
    'charging' => 'Mengisi daya',
    'discharging' => 'Tidak tersambung',
    'full' => 'Penuh',
    _ => 'Tidak diketahui',
  };
}

String _sumberChargerLabel(String? sumber) {
  return switch (sumber) {
    'USB' => 'USB',
    'AC' => 'AC',
    'wireless' => 'Wireless',
    _ => 'Tidak diketahui',
  };
}

String _kesehatanLabel(String? kesehatan) {
  return switch (kesehatan) {
    'health_good' => 'Baik',
    'dead' => 'Tidak dapat digunakan',
    'over_heat' => 'Panas berlebih',
    'over_voltage' => 'Tegangan berlebih',
    'cold' => 'Terlalu dingin',
    'unspecified_failure' => 'Gangguan tidak ditentukan',
    _ => 'Tidak diketahui',
  };
}

// Format ribuan gaya Indonesia (titik sebagai pemisah ribuan).
String _angkaRibuan(int nilai) {
  final teks = nilai.abs().toString();
  final buffer = StringBuffer();
  final sisa = teks.length % 3;
  for (var i = 0; i < teks.length; i++) {
    buffer.write(teks[i]);
    if ((i + 1) % 3 == sisa && i != teks.length - 1) {
      buffer.write('.');
    }
  }
  return buffer.toString();
}
