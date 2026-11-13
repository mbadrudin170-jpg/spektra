import 'package:flutter/material.dart';

// Baris tombol penilaian hasil tes yang dipakai seluruh layar tes:
// pengguna yang menilai apakah tes lulus, gagal, atau tidak tersedia.
class TesFooter extends StatelessWidget {
  const TesFooter({
    super.key,
    required this.onLulus,
    required this.onGagal,
    required this.onTidakTersedia,
  });

  final VoidCallback onLulus;
  final VoidCallback onGagal;
  final VoidCallback onTidakTersedia;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          spacing: 8,
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: onLulus,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Lulus'),
              ),
            ),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onGagal,
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('Gagal'),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: onTidakTersedia,
                child: const Text('Tidak tersedia'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
