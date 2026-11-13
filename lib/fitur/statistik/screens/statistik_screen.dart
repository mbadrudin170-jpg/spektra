import 'package:flutter/material.dart';

import 'package:spektra/fitur/statistik/widgets/memori_penyimpanan_section.dart';
import 'package:spektra/fitur/statistik/widgets/spesifikasi_baterai_section.dart';

// Layar statistik (minimal) — wadah section statistik perangkat; saat ini
// memuat section "Spesifikasi Baterai" dan "Memori & Penyimpanan" (Android).
// Disematkan sebagai konten tab (bukan layar yang di-push), sehingga tidak
// membawa `Scaffold`/`AppBar` sendiri — kerangka layar disediakan pemanggil.
class StatistikScreen extends StatelessWidget {
  const StatistikScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(
            'Statistik',
            style: tema.textTheme.titleSmall?.copyWith(
              color: tema.colorScheme.primary,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SpesifikasiBateraiSection(),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: MemoriPenyimpananSection(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Statistik perangkat lainnya akan hadir kemudian.',
            style: tema.textTheme.bodySmall?.copyWith(
              color: tema.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
