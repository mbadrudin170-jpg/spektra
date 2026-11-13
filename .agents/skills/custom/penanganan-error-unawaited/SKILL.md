---
name: penanganan-error-unawaited
description: "Trigger: saat memanggil Future tanpa await (unawaited) | Panduan wajib catchError dengan logging L.e pada Future yang dilepas; jangan biarkan unhandled."
metadata:
  kategori: "custom"
  versi: "1.1.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Penanganan Error pada Future yang Dilepas (unawaited)

Future yang dilepas dengan `unawaited()` wajib memiliki penanganan error via `catchError()` yang mencatat error melalui logger proyek.

## Aturan

1. Future yang dilepas dengan `unawaited()` dan berpotensi gagal wajib memiliki penanganan error melalui `catchError(...)` atau `try/catch` yang mencatat error melalui logger proyek (`L.e`).
2. Jangan melepas `unawaited(...)` tanpa penanganan error hanya untuk menghilangkan peringatan analyzer.
3. Jangan mengandalkan keberhasilan implisit pada Future yang dilepas.
4. `unawaited(...)` pada pemanggilan method yang di dalamnya terdapat dialog (`showOkCancelAlertDialog`) atau `setState` DI LUAR blok `try` tetap wajib `.catchError(...)` di titik pemanggilan — exception dari dialog (mis. kegagalan platform channel) tidak tertangkap `try` internal method tersebut dan menjadi error async tidak tertangani. Lebih baik: pindahkan dialog/`setState` ke dalam `try` pada method tersebut, ATAU bungkus pemanggilan dengan `.catchError(...)` yang mencatat `L.e` dan `return null`.

## Larangan

- Jangan memanggil `unawaited(Nav.to(...))`, `unawaited(EasyLoading.show(...))`, atau sejenisnya tanpa `.catchError(...)`/`try/catch`.
- Jangan mengabaikan error pada Future yang dilepas.

## Contoh Benar

```dart
unawaited(
  Nav.to(context, const HalamanLain()).catchError((Object e, StackTrace s) {
    L.e('Gagal navigasi: $e $s');
    return null;
  }),
);
```

## Contoh Salah

```dart
unawaited(Nav.to(context, const HalamanLain()));
```

## Sumber Evaluasi

- Commit: `fd6b45afbb4064038b4bc1131aaf6125dae538ec`, `d80e637179ed969c19c97f2cc2ced3d3d5fa2d12`, `db5dd32f28e92346b9a8d3467fa9b2838e013a02` (pembungkus `_navigasi` + `catchError` pada layar terkait), `50c1be708e595449fa2fd18e3491d4418943c565` (catchError pada `_simpan`/`_hapus` di form & layar rencana darurat)
- File: `lib/fitur/dashboard/screens/dashboard_screen.dart`, `lib/fitur/biodata/screens/form_biodata.dart`, `lib/lainnya_screen.dart`, `lib/fitur/rencana_darurat/screens/form_rencana_darurat.dart`, `lib/fitur/rencana_darurat/screens/rencana_darurat_screen.dart`
