---
name: model-state-freezed-abstract
description: "Trigger: saat membuat model atau state Freezed | Panduan model/state Freezed abstract class: fromSqflite, toSqflite, ParserUtil, konversi UTC."
metadata:
  kategori: "custom"
  versi: "1.1.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Model dan State Freezed menggunakan `abstract class`

Model/state Freezed wajib `abstract class`, factory `fromSqflite`, method `toSqflite`, parsing via `ParserUtil`, konversi UTC.

## Aturan

1. Model dan state yang dibuat dengan Freezed wajib menggunakan `abstract class`, bukan `class` biasa.
2. Model database wajib menyediakan factory `fromSqflite(Map<String, Object?> row)` dan method `toSqflite()` untuk konversi ke/dari SQLite.
3. Parsing nilai dari database wajib menggunakan `ParserUtil`.
4. Konversi tanggal ke UTC wajib dilakukan di `toSqflite()` (`toUtc().toIso8601String()`), dan konversi ke lokal wajib dilakukan di `fromSqflite()` (`parseDateTime(...)?.toLocal()`).
5. Field bertipe enum wajib diparse dengan `ParserUtil.safeParseEnum(TelEnum.values, ParserUtil.parseStringOrNull(row[NamaKolom.kolom]))`, dengan fallback nilai default yang valid bila tersimpan `null`/tidak dikenal (mis. `JenisIntervensiSos.napas478`), kecuali kolom boleh `null` — untuk kolom nullable cukup kembalikan `null` tanpa fallback.
6. Nilai enum yang dipersistenkan ke kolom `TEXT` wajib `lowerCamelCase` (`berhasilMenahan`, `timer3Menit`) dan konsisten dengan migrasi data (lihat skill `migrasi-skema-sqlite`); nilai `snake_case` lama tidak boleh muncul di enum baru.
7. Kolom yang nullable di database wajib dipetakan ke properti nullable di model (`String?`, `HasilIntervensiSos?`) dan diparse dengan `ParserUtil.parseStringOrNull` / `safeParseEnum` tanpa fallback paksa.

## Larangan

- Jangan membuat model/state Freezed dengan `class` biasa.
- Jangan melakukan parsing `dynamic` dari database secara langsung tanpa `ParserUtil`.
- Jangan menyimpan waktu lokal seolah-olah UTC.
- Jangan memparse enum dari database dengan cast/string matching langsung tanpa `ParserUtil.safeParseEnum`.
- Jangan persistenkan nilai enum `snake_case` ke kolom database.

## Contoh Benar

```dart
@freezed
abstract class DiaryCravingModel with _$DiaryCravingModel {
  const DiaryCravingModel._();
  const factory DiaryCravingModel({...}) = _DiaryCravingModel;

  factory DiaryCravingModel.fromSqflite(Map<String, Object?> row) {...}
  Map<String, Object?> toSqflite() {...}
}
```

## Contoh Salah

```dart
@freezed
class DiaryCravingModel with _$DiaryCravingModel { ... } // class biasa, bukan abstract
```

## Sumber Evaluasi

- Commit: `3b67d3095dacc4e5c7ea78d7eb251809e3e9d981`, `a15acd9603fe5d1251afa4acc3817e7e9c1607b1` (SosIntervensiModel, DiaryCravingModel perluasan, safeParseEnum), `a5beae01b86a4d9753963380818bc437c2b4741a` (enum lowerCamelCase + migrasi v12), `2462af81050e12b2933717f457a33a5b05d3719f` (RencanaDaruratModel)
- File: `lib/fitur/diary_craving/model/diary_craving_model.dart`, `lib/fitur/diary_craving/state/diary_craving_state.dart`, `lib/fitur/sos_craving/model/sos_intervensi_model.dart`, `lib/fitur/rencana_darurat/model/rencana_darurat_model.dart`
