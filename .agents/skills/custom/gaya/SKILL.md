---
name: gaya
description: "Trigger: saat menata warna dan tema UI | Panduan styling Flutter: withValues(alpha:) bukan withOpacity, warna dari ColorScheme/tema, hardcode hanya status semantic (hijau/merah/kuning), EasyLoading dengan catchError."
metadata:
  kategori: "custom"
  versi: "1.1.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Panduan Styling (Gaya)

Skill ini mendokumentasikan aturan styling warna dan tema berdasarkan implementasi nyata di proyek Flutter. Semua aturan wajib diikuti untuk menjaga konsistensi visual antara mode terang dan gelap, serta menghindari API yang sudah deprecated.

## Cakupan yang Di-Cover

- Package: `package:flutter` (class `Color`, `ThemeData`, `ColorScheme`, `Brightness`), `package:flutter_easyloading` (class `EasyLoading`, `EasyLoadingMaskType`)
- Class: `Color`, `ThemeData`, `ColorScheme`, `Brightness`, `EasyLoading`, `EasyLoadingMaskType`, `AlwaysStoppedAnimation`
- Enum: `Brightness.light`, `Brightness.dark`, `EasyLoadingMaskType.black`, `EasyLoadingMaskType.none`
- Properti: `Color.alpha`, `ColorScheme.primary`, `ColorScheme.surface`, `ColorScheme.onSurface`, `ColorScheme.primaryContainer`, `ThemeData.brightness`, `ThemeData.colorScheme`
- Method: `Color.withValues(alpha:)`, `Color.withOpacity()`, `Theme.of(context)`, `EasyLoading.show()`, `EasyLoading.dismiss()`

## Aturan

1. Wajib menggunakan `warna.withValues(alpha: ...)` untuk mengatur opacity warna.
2. DILARANG menggunakan `warna.withOpacity(...)` karena deprecated sejak Flutter 3.47+.
3. Wajib menggunakan warna dari `Theme.of(context).colorScheme` untuk teks dan komponen UI agar menyesuaikan mode terang/gelap.
4. Hardcode warna (HEX/RGBA) hanya diperbolehkan jika warna harus tetap sama di kedua mode tema (mis. brand color, status semantic: hijau sukses, merah error, kuning warning).
5. DILARANG mengubah nilai HEX/RGBA yang sudah ada menjadi referensi `ColorScheme` jika warna memang harus tetap.
5a. Hardcode status semantic sudah dikonfirmasi pengguna boleh dipertahankan — task yang menandai `const Color(0xFFFF9800)` (dashboard, warning), `const Color(0xFF4CAF50)` (dashboard, sukses), dan `const Color(0xFFEF5350)` (konsumsi_rokok_screen, error) sebagai pelanggaran ditandai `batal` oleh pengguna (commit `ceb9536cc50304149be139dc8c5a36addb9c0774`, `task.md`). Kode di atas sudah sesuai aturan #4; jangan "diperbaiki" dengan mengganti ke `ColorScheme`.
6. `EasyLoading.show()` dan `EasyLoading.dismiss()` yang dipanggil dengan `unawaited()` wajib dilengkapi `.catchError(...)` untuk menangani error.
7. Mask type untuk operasi blocking wajib menggunakan `EasyLoadingMaskType.black`.
8. Konsisten menggunakan `withValues` di seluruh widget, tidak boleh bercampur dengan `withOpacity`.

## Larangan

- DILARANG `withOpacity()` → gunakan `withValues(alpha:)`.
- DILARANG hardcode warna untuk komponen yang harus ikut tema (primary, surface, onSurface, dll.).
- DILARANG `EasyLoading.show/dismiss` tanpa `.catchError()` pada `unawaited()`.
- DILARANG mencampur `withValues` dan `withOpacity` dalam satu file/widget.

## Contoh Benar

```dart
// Opacity dengan withValues (WAJIB)
Container(
  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
)
LinearProgressIndicator(
  backgroundColor: warnaProgres.withValues(alpha: 0.2),
  valueColor: AlwaysStoppedAnimation(warnaProgres),
)
Colors.black.withValues(alpha: 0.5), // Overlay modal

// Warna dari ColorScheme untuk UI umum
Text('Judul', style: TextStyle(color: Theme.of(context).colorScheme.onSurface))
Card(color: Theme.of(context).colorScheme.surfaceContainerHighest)
FilledButton(onPressed: ..., child: Text('Simpan'))

// Hardcode hanya untuk status semantic yang harus sama di light/dark
Container(color: const Color(0xFF4CAF50), child: ...), // Brand green / sukses
Icon(Icons.check_circle, color: const Color(0xFF4CAF50)), // Status sukses
Icon(Icons.error, color: const Color(0xFFEF5350)), // Status error
Icon(Icons.warning, color: const Color(0xFFFF9800)), // Status warning

// EasyLoading dengan catchError pada unawaited
unawaited(
  EasyLoading.show(
    status: 'Memproses...',
    maskType: EasyLoadingMaskType.black,
  ).catchError((e, s) => L.e('Gagal loading: $e $s')),
);
```

## Contoh Salah

```dart
// DILARANG: withOpacity deprecated
warna.withOpacity(0.2)

// DILARANG: Hardcode primary color (harus ikut tema)
final primary = const Color(0xFF2196F3);

// DILARANG: Semua warna hardcode (tidak support dark mode)
Container(color: Colors.blue, child: Text('...', style: TextStyle(color: Colors.white)))

// DILARANG: EasyLoading tanpa catchError
unawaited(EasyLoading.show(status: 'Memproses...'));
```

## Sumber Evaluasi

- File: `lib/fitur/sos_craving/screens/sos_craving_screen.dart`, `lib/fitur/impian/widget/visual_tabungan_impian.dart`, `lib/fitur/dashboard/screens/dashboard_screen.dart`, `lib/fitur/konsumsi_rokok/screens/konsumsi_rokok_screen.dart`
- Class terkait: `Color`, `ThemeData`, `ColorScheme`, `Brightness`, `EasyLoading`, `EasyLoadingMaskType`, `AlwaysStoppedAnimation`
- Commit rujukan: `3b67d309` — `warna.withValues(alpha: 0.2)` di `SosCravingScreen`; `c7337d1` — `VisualTabunganImpian` warna semantic; `ceb9536cc50304149be139dc8c5a36addb9c0774` — task.md: temuan warna hardcode semantic ditandai `batal` (pengguna memutuskan boleh dipertahankan)
