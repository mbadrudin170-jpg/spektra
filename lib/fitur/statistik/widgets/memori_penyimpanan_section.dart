import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spektra/fitur/statistik/model/memori_info.dart';
import 'package:spektra/fitur/statistik/notifier/memori_notifier.dart';

// Section "Memori & Penyimpanan" pada halaman statistik (Android saja).
// Data dibaca sekali saat layar dibuka; tombol muat ulang memuat ulang
// snapshot (bukan stream). Nilai yang tidak tersedia ditampilkan sebagai
// `Tidak diketahui`.
class MemoriPenyimpananSection extends ConsumerWidget {
  const MemoriPenyimpananSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return const _PesanTidakDidukung();
    }
    final tema = Theme.of(context);
    final memoriAsync = ref.watch(memoriProvider);
    final sedangMemuat = memoriAsync.isLoading;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.memory, color: tema.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Memori & Penyimpanan',
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
            if (memoriAsync.isLoading)
              const LinearProgressIndicator()
            else if (memoriAsync.hasError || memoriAsync.value == null)
              _GagalMemuat(onCobaLagi: () => _muatUlang(ref))
            else
              _IsiSpesifikasi(info: memoriAsync.requireValue!),
          ],
        ),
      ),
    );
  }

  static void _muatUlang(WidgetRef ref) {
    unawaited(
      ref.read(memoriProvider.notifier).muatUlang().catchError((Object error) {
        debugPrint('Gagal memuat ulang info memori: $error');
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
            Icon(Icons.memory_outlined, color: tema.colorScheme.outline),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Memori & penyimpanan hanya tersedia di Android.',
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
                'Gagal memuat info memori & penyimpanan.',
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

  final MemoriInfo info;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        _BarisSpesifikasi(
          label: 'RAM total',
          nilai: _formatMb(info.ramTotalMb),
        ),
        _BarisSpesifikasi(
          label: 'RAM tersedia',
          nilai: _formatMb(info.ramTersediaMb),
        ),
        _BarisSpesifikasi(
          label: 'RAM terpakai',
          nilai: _denganPersen(info.ramTerpakaiMb, info.ramTotalMb, _formatMb),
        ),
        _BarisSpesifikasi(
          label: 'Perangkat RAM rendah',
          nilai: info.perangkatRamRendah == null
              ? 'Tidak diketahui'
              : (info.perangkatRamRendah! ? 'Ya' : 'Tidak'),
        ),
        const _BarisSpesifikasi(
          label: 'Tipe memori',
          nilai: 'Tidak diketahui',
          tooltip:
              'Tipe memori (LPDDR) tidak tersedia lewat API publik Android; '
              'tidak ditampilkan pada versi awal.',
        ),
        _BarisSpesifikasi(
          label: 'Penyimpanan total',
          nilai: _formatByte(info.penyimpananTotalByte),
        ),
        _BarisSpesifikasi(
          label: 'Penyimpanan terpakai',
          nilai: _denganPersen(
            info.penyimpananTerpakaiByte,
            info.penyimpananTotalByte,
            _formatByte,
          ),
        ),
        _BarisSpesifikasi(
          label: 'Penyimpanan bebas',
          nilai: _formatByte(info.penyimpananBebasByte),
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

String _formatMb(int? mb) =>
    mb == null ? 'Tidak diketahui' : '${_angkaRibuan(mb)} MB';

// Konversi byte ke satuan yang mudah dibaca, gaya Indonesia (titik ribuan,
// koma desimal).
String _formatByte(int? byte) {
  if (byte == null) {
    return 'Tidak diketahui';
  }
  const gb = 1000 * 1000 * 1000;
  const mb = 1000 * 1000;
  if (byte >= gb) {
    return '${(byte / gb).toStringAsFixed(1).replaceAll('.', ',')} GB';
  }
  return '${_angkaRibuan(byte ~/ mb)} MB';
}

String _denganPersen(int? nilai, int? total, String Function(int?) format) {
  if (nilai == null) {
    return 'Tidak diketahui';
  }
  final formatted = format(nilai);
  if (total == null || total <= 0) {
    return formatted;
  }
  final persen = ((nilai / total) * 100).round();
  return '$formatted ($persen%)';
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
