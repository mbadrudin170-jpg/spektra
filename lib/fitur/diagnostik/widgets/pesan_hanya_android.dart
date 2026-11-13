import 'package:flutter/material.dart';

// Pesan standar untuk layar tes di platform non-Android/web ("hanya tersedia
// di Android"). Dipakai oleh seluruh layar tes agar konsisten dengan pola
// `_PesanTidakDidukung` pada section statistik.
class PesanHanyaAndroid extends StatelessWidget {
  const PesanHanyaAndroid({
    super.key,
    this.pesan = 'Tes ini hanya tersedia di Android.',
  });

  final String pesan;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.android_outlined,
              size: 48,
              color: tema.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              pesan,
              style: tema.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
