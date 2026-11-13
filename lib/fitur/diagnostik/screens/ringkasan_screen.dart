import 'package:flutter/material.dart';

import 'package:spektra/fitur/diagnostik/daftar_tes.dart';
import 'package:spektra/fitur/diagnostik/model/hasil_tes.dart';
import 'package:spektra/fitur/diagnostik/widgets/status_tes_badge.dart';

// Layar ringkasan sesi tes: daftar hasil per tes + total
// "N lulus / M gagal / K tidak tersedia". Tanpa persistensi — data hanya
// hidup selama sesi layar grid terbuka.
class RingkasanScreen extends StatelessWidget {
  const RingkasanScreen({super.key, required this.hasil});

  final List<HasilTes> hasil;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final perId = {for (final h in hasil) h.id: h};
    final lulus = hasil.where((h) => h.status == StatusTes.lulus).length;
    final gagal = hasil.where((h) => h.status == StatusTes.gagal).length;
    final tidakTersedia = hasil
        .where((h) => h.status == StatusTes.tidakTersedia)
        .length;
    final belumDites = kDaftarTes.length - hasil.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Ringkasan Hasil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Hasil sesi tes ini',
            style: tema.textTheme.titleSmall?.copyWith(
              color: tema.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          for (final tes in kDaftarTes)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(tes.ikon, color: tema.colorScheme.primary),
              title: Text(tes.label),
              trailing: StatusTesBadge(status: perId[tes.id]?.status),
            ),
          const Divider(),
          const SizedBox(height: 8),
          Text(
            '$lulus lulus / $gagal gagal / $tidakTersedia tidak tersedia',
            style: tema.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (belumDites > 0) ...[
            const SizedBox(height: 4),
            Text(
              '$belumDites tes belum dijalankan.',
              style: tema.textTheme.bodySmall?.copyWith(
                color: tema.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Kembali'),
          ),
        ],
      ),
    );
  }
}
