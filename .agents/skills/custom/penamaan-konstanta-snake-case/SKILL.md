---
name: penamaan-konstanta-snake-case
description: "Trigger: saat menamai konstanta kolom database | Panduan konstanta kolom snake_case lowercase yang harus sama persis dengan skema dan migrasi SQLite."
metadata:
  kategori: "custom"
  versi: "1.0.2"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Penamaan Konstanta Kolom Database Menggunakan snake_case

Nilai konstanta kolom dalam `NamaKolom` wajib menggunakan huruf kecil dan underscore (`snake_case`) serta harus cocok persis dengan nama kolom pada skema dan migrasi SQLite.

## Aturan

1. Nilai konstanta nama kolom di `NamaKolom` wajib lowercase + underscore (snake_case).
2. Setiap konstanta wajib cocok persis (case-sensitive) dengan nama kolom pada `onCreate`, `onUpgrade`, dan query database.
3. Saat memperbaiki nama kolom, periksa konsistensi pemetaan model dan skema/migrasi agar aplikasi tidak membaca nama kolom yang berbeda.

## Larangan

- Jangan menggunakan huruf kapital pada nilai konstanta (mis. `'Tanggal_mulai_tapering'` alih-alih `'tanggal_mulai_tapering'`).
- Jangan menggunakan nilai konstanta yang berbeda dari nama kolom aktual pada skema atau migrasi.

## Contoh Benar

```dart
static const String tanggalMulaiTapering = 'tanggal_mulai_tapering';
static const String targetSmokeFreeHari = 'target_smoke_free_hari';
```

## Contoh Salah

```dart
static const String tanggalMulaiTapering = 'Tanggal_mulai_tapering';
```

## Sumber Evaluasi

- Commit: `c9f96b2debb9e678513229c5a4a68a062e3a8afc`
- File: `lib/shared/konstanta/nama_kolom.dart`
