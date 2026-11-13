import 'package:flutter/material.dart';

import 'package:spektra/fitur/diagnostik/model/hasil_tes.dart';

// Lencana status tes: hijau = lulus, merah = gagal, oranye = tidak
// tersedia, abu = belum dites. Selalu disertai ikon + teks (bukan hanya
// warna).
class StatusTesBadge extends StatelessWidget {
  const StatusTesBadge({super.key, required this.status});

  final StatusTes? status;

  @override
  Widget build(BuildContext context) {
    final (ikon, teks, warna) = switch (status) {
      null => (Icons.help_outline, 'Belum dites', Colors.grey),
      StatusTes.lulus => (Icons.check_circle, 'Lulus', Colors.green),
      StatusTes.gagal => (Icons.cancel, 'Gagal', Colors.red),
      StatusTes.tidakTersedia => (
        Icons.do_not_disturb_on_outlined,
        'Tidak tersedia',
        Colors.orange,
      ),
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        Icon(ikon, size: 16, color: warna),
        Text(
          teks,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: warna, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
