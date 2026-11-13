---
name: penanganan-asyncvalue-berkali
description: "Trigger: saat layar menangani beberapa AsyncValue | Panduan loading gabungan, error terpisah, requireValue yang aman, tipe generic konkret."
metadata:
  kategori: "custom"
  versi: "1.1.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Penanganan Beberapa Provider Asynchronous pada Satu Layar

Ketika layar memuat lebih dari satu provider asynchronous, tangani loading gabungan dan error secara terpisah. Pertahankan tipe data konkret pada setiap `AsyncValue`.

## Aturan

1. Ketika layar memuat lebih dari satu provider asynchronous, tangani status `isLoading` gabungan. Tampilkan indikator loading jika salah satu provider masih loading.
2. Tangani status `hasError` untuk setiap provider secara terpisah, dengan pesan error dan tombol retry yang memanggil `ref.refresh(provider)` yang sesuai.
3. Panggil `requireValue` pada setiap provider hanya setelah status loading dan error ditangani.
4. Kondisi data tidak lengkap (misalnya biodata null) tetap ditangani sebagai tampilan tersendiri dengan informasi dan call-to-action.
5. Saat menerima atau meneruskan nilai asynchronous ke parameter method/helper, gunakan tipe generic konkret sesuai state provider, misalnya `AsyncValue<ImpianState>`, bukan `AsyncValue<dynamic>`.
6. Pertahankan tipe konkret setiap provider secara terpisah agar akses properti state tetap diperiksa oleh analyzer.

## Larangan

- Jangan memanggil `requireValue` pada provider yang masih loading atau error.
- Jangan menggabungkan penanganan error beberapa provider menjadi satu blok yang tidak jelas provider mana yang gagal.
- Jangan menggunakan `AsyncValue<dynamic>` jika tipe state provider sudah diketahui.

## Contoh Benar

```dart
final biodataAsync = ref.watch(biodataProvider);
final impianAsync = ref.watch(impianProvider);

if (biodataAsync.isLoading || impianAsync.isLoading) {
  return const Scaffold(body: Center(child: CircularProgressIndicator()));
}
if (biodataAsync.hasError) {
  return _ErrorRetry(onRetry: () => ref.refresh(biodataProvider));
}
if (impianAsync.hasError) {
  return _ErrorRetry(onRetry: () => ref.refresh(impianProvider));
}

final biodata = biodataAsync.requireValue;
final impianState = impianAsync.requireValue;
```

Parameter helper yang menerima state asynchronous juga harus tetap bertipe spesifik:

```dart
Widget _buildCardRingkasanImpian(
  BiodataModel biodata,
  AsyncValue<ImpianState> impianAsync,
) {
  // ...
}
```

## Contoh Salah

```dart
Widget _buildCardRingkasanImpian(
  BiodataModel biodata,
  AsyncValue<dynamic> impianAsync,
) {
  // ...
}
```

## Sumber Evaluasi

- Commit: `c9f96b2debb9e678513229c5a4a68a062e3a8afc`
- File: `lib/fitur/dashboard/screens/dashboard_screen.dart`
