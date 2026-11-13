---
name: tipografi
description: "Trigger: saat mengatur tipografi | Panduan: Theme.of(context).textTheme utama, copyWith untuk kustomisasi, hierarki label/sub-label/nilai, bold terarah, FontFeature.tabularFigures() untuk angka/timer, FittedBox/Flexible secukupnya."
metadata:
  kategori: "custom"
  versi: "1.0.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Panduan Tipografi

Skill ini mendokumentasikan aturan tipografi berdasarkan `optimasi_ui.md` dan implementasi nyata di proyek Flutter.

## Cakupan yang Di-Cover

- Package: `package:flutter` (class `ThemeData`, `TextTheme`, `TextStyle`, `FontFeature`, `TextOverflow`, `FittedBox`, `Flexible`, `Expanded`)
- Class: `ThemeData`, `TextTheme`, `TextStyle`, `FontFeature`, `FittedBox`, `Flexible`, `Expanded`
- Properti: `ThemeData.textTheme`, `TextStyle.fontSize`, `TextStyle.fontWeight`, `TextStyle.color`, `TextStyle.fontFeatures`, `TextOverflow.ellipsis`
- Method: `Theme.of(context)`, `TextStyle.copyWith()`

## Aturan

1. Wajib menggunakan `Theme.of(context).textTheme` sebagai referensi utama gaya teks.
2. Wajib menggunakan `copyWith()` untuk menyesuaikan (bold, warna, ukuran) dari style dasar tema.
3. DILARANG menentukan `fontSize`, `fontWeight`, `fontFamily` manual tanpa acuan `textTheme` (kecuali hardcode diperlukan khusus).
4. Setiap tingkat teks wajib memiliki perbedaan minimal 1 properti gaya (ukuran, ketebalan, warna).
5. DILARANG dua tingkat informasi berbeda menggunakan gaya identik.
6. Wajib gunakan bold untuk judul halaman, informasi utama, nilai penting, elemen butuh penekanan.
7. DILARANG bold pada seluruh teks.
8. Wajib menggunakan `FontFeature.tabularFigures()` untuk timer, jam, dan angka monetary agar lebar digit sama.
9. Wajib antisipasi teks panjang yang bisa overflow dengan `FittedBox` atau `Flexible` hanya pada bagian yang benar-benar butuh.

## Larangan

- DILARANG `TextStyle(fontSize: ..., fontWeight: ...)` manual tanpa `textTheme`.
- DILARANG hierarki visual dengan gaya identik untuk tingkat berbeda.
- DILARANG bold sembarangan tanpa hierarki jelas.
- DILARANG `FittedBox`/`Flexible` di seluruh teks tanpa alasan.

## Contoh Benar

```dart
final textTheme = Theme.of(context).textTheme;

// BENAR: Berbasis textTheme + copyWith
Text(
  'Judul Halaman',
  style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
)
Text(
  'Deskripsi',
  style: textTheme.bodyMedium?.copyWith(color: textTheme.bodyMedium?.color?.withValues(alpha: 0.7)),
)
Text(
  'Nilai Utama',
  style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
)

// Hierarki visual: Label → Sub-Label → Nilai
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  spacing: 4,
  children: [
    Text('Total Pengeluaran', style: textTheme.bodySmall),
    Text('Pengeluaran bulan ini', style: textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary)),
    Text('Rp500.000', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
  ],
)

// Bold terarah
Text('Hari ke-30', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)), // Nilai penting
Text('Smoke-free', style: textTheme.bodyMedium), // Label biasa

// Tabular figures untuk timer/angka
Text('$menit:$detik', style: textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, fontFeatures: const [FontFeature.tabularFigures()]))
```

## Contoh Salah

```dart
// DILARANG: Manual TextStyle tanpa textTheme
Text('Judul', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
Text('Nilai', style: TextStyle(fontSize: 18, color: Colors.blue))

// DILARANG: Hierarki dengan gaya identik
final style = textTheme.bodyMedium;
Text('Label', style: style)
Text('Sub-Label', style: style)
Text('Nilai', style: style)

// DILARANG: Semua bold
Text('Label', style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold))
Text('Nilai', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))

// DILARANG: FittedBox di semua teks tanpa alasan
FittedBox(child: Text(semuaTeks))
```

## Sumber Evaluasi

- File: `lib/fitur/impian/screens/detail_impian_screen.dart`, `lib/fitur/dashboard/screens/dashboard_screen.dart`
- Class terkait: `ThemeData`, `TextTheme`, `TextStyle`, `FontFeature`, `FittedBox`, `Flexible`
- Commit rujukan: `c7337d1` — DetailImpianScreen hierarki label/sub-label/nilai; `e659574` — Dashboard kartu motivasi; `3b67d309` — `_TimerCravingView` pakai tabularFigures; `c7337d1` — `VisualTabunganImpian` nilai uang
