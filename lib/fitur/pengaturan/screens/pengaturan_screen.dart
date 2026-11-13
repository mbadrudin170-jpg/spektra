import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spektra/fitur/pengaturan/tema/tema_provider.dart';

// Layar pengaturan; saat ini memuat pilihan mode tema aplikasi
// (terang, gelap, atau mengikuti sistem).
//
// Disematkan sebagai konten tab (bukan layar yang di-push), sehingga tidak
// membawa `Scaffold`/`AppBar` sendiri — kerangka layar disediakan pemanggil.
class PengaturanScreen extends ConsumerWidget {
  const PengaturanScreen({super.key});

  static const List<_PilihanTema> _pilihanTema = [
    _PilihanTema(
      mode: ThemeMode.light,
      ikon: Icons.light_mode,
      label: 'Terang',
      deskripsi: 'Selalu gunakan tema terang',
    ),
    _PilihanTema(
      mode: ThemeMode.dark,
      ikon: Icons.dark_mode,
      label: 'Gelap',
      deskripsi: 'Selalu gunakan tema gelap',
    ),
    _PilihanTema(
      mode: ThemeMode.system,
      ikon: Icons.brightness_auto,
      label: 'Ikuti sistem',
      deskripsi: 'Menyesuaikan tema dengan pengaturan perangkat',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final modeTema = ref.watch(temaProvider).asData?.value ?? ThemeMode.system;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            'Tema aplikasi',
            style: tema.textTheme.titleSmall?.copyWith(
              color: tema.colorScheme.primary,
            ),
          ),
        ),
        RadioGroup<ThemeMode>(
          groupValue: modeTema,
          onChanged: (mode) {
            if (mode == null) {
              return;
            }
            ref.read(temaProvider.notifier).ubah(mode).catchError((
              Object error,
            ) {
              debugPrint('Gagal mengubah mode tema: $error');
            });
          },
          child: Column(
            children: [
              for (final pilihan in _pilihanTema)
                RadioListTile<ThemeMode>(
                  value: pilihan.mode,
                  secondary: Icon(pilihan.ikon),
                  title: Text(pilihan.label),
                  subtitle: Text(pilihan.deskripsi),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PilihanTema {
  const _PilihanTema({
    required this.mode,
    required this.ikon,
    required this.label,
    required this.deskripsi,
  });

  final ThemeMode mode;
  final IconData ikon;
  final String label;
  final String deskripsi;
}
