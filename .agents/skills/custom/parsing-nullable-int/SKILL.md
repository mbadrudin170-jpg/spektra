---
name: parsing-nullable-int
description: "Trigger: saat membaca field integer nullable dari database | Panduan parseIntOrNull (null tetap null, tidak jadi 0) dan parseInt/parseBool dengan defaultValue untuk field non-nullable."
metadata:
  kategori: "custom"
  versi: "1.0.4"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Parsing Field Nullable Integer dari Database Menggunakan parseIntOrNull

Field `int?` yang dibaca dari database wajib menggunakan `ParserUtil.parseIntOrNull(...)`. Nilai null harus tetap null, bukan berubah menjadi 0.

## Aturan

1. Field nullable `int?` dari database wajib di-parse menggunakan `ParserUtil.parseIntOrNull(...)`, bukan `ParserUtil.parseInt(...)` yang menggunakan nilai default 0.
2. Pertahankan null dari database di model agar aplikasi dapat membedakan kondisi "belum diatur" dengan nilai nol yang memang ditetapkan.
3. **Field non-nullable di Dart** (`int`, `bool`, dll.) gunakan `ParserUtil.parseInt(...)` atau `ParserUtil.parseBool(...)` dengan `defaultValue`, karena tipe Dart tidak bisa menampung null. Jika DB null, nilai default Dart akan digunakan.
4. **Field nullable di Dart** (`int?`, `bool?`, `String?`, dll.) gunakan `ParserUtil.parseIntOrNull(...)`, `ParserUtil.parseBool(...)`, atau `ParserUtil.parseStringOrNull(...)` tanpa `??` default, sehingga null dari database tetap null.
5. Terapkan aturan ini pada seluruh field nullable yang dipetakan dalam factory model dari baris SQLite.

## Larangan

- Jangan menggunakan `ParserUtil.parseInt(row[kolom])` untuk field `int?` yang null berarti belum diatur.
- Jangan mengubah null menjadi 0 tanpa keputusan dan validasi bisnis yang jelas.
- Jangan menambahkan `?? defaultValue` pada hasil `parseIntOrNull` untuk field nullable `int?`, karena akan meniadakan tujuan menjaga null tetap null.

## Contoh Benar

```dart
// Field nullable int? di Dart → parseIntOrNull, null tetap null
targetSmokeFreeHari: ParserUtil.parseIntOrNull(
  row[NamaKolom.targetSmokeFreeHari],
),

// Field non-nullable int di Dart → parseInt dengan defaultValue
jumlah: ParserUtil.parseInt(row[NamaKolom.jumlah], defaultValue: 1),

// Field non-nullable bool di Dart → parseBool dengan defaultValue
isSlip: ParserUtil.parseBool(row[NamaKolom.isSlip], defaultValue: false),

// Field nullable String? di Dart → parseStringOrNull, null tetap null
catatan: ParserUtil.parseStringOrNull(row[NamaKolom.catatan]),
```

## Contoh Salah

```dart
// SALAH: parseInt pada field nullable int? → null berubah menjadi 0
targetSmokeFreeHari: ParserUtil.parseInt(
  row[NamaKolom.targetSmokeFreeHari],
), // null berubah menjadi 0

// SALAH: ?? defaultValue pada parseIntOrNull untuk field nullable → null tidak tetap null
jumlah: ParserUtil.parseIntOrNull(row[NamaKolom.jumlah]) ?? 0,
```

## Sumber Evaluasi

- Commit: `c9f96b2debb9e678513229c5a4a68a062e3a8afc`
- File: `lib/fitur/biodata/model/biodata_model.dart`, `lib/fitur/konsumsi_rokok/model/konsumsi_rokok_model.dart`
