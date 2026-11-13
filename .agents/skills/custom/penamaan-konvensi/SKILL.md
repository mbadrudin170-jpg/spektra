---
name: penamaan-konvensi
description: "Trigger: saat menamai identifier, file, atau class | Konvensi proyek Flutter: identifier bahasa Indonesia, file snake_case, variable camelCase, class PascalCase, konstanta SCREAMING_SNAKE_CASE, import package:, tabel/kolom snake_case."
metadata:
  kategori: "custom"
  versi: "1.1.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Konvensi Penamaan Proyek

Skill ini mendokumentasikan konvensi penamaan yang wajib diterapkan di proyek ini.

## Cakupan yang Di-Cover

- Package: `package:flutter`, `package:flutter_riverpod`, `package:freezed`, `package:json_annotation`, `package:mockito` (kode eksternal tetap pakai konvensi aslinya dalam Bahasa Inggris)
- Class: `BiodataModel`, `ModeBerhenti`, `NamaTabel`, `NamaKolom`
- Enum: `ModeBerhenti.seketika`, `ModeBerhenti.bertahap`, `Status.loading`, `Status.success`, `Status.error`
- Properti: `jumlahRokokPerHari`, `isLoading`, `hasError`, `_errorMessage`, `namaTabel`, `versiDatabase`
- Method: `simpanBiodata()`, `_handleTap()`

## Aturan

1. Wajib gunakan bahasa Indonesia untuk identifier yang didefinisikan aplikasi (variable, method, class, enum, table, column).
2. DILARANG campur bahasa Indonesia dan Inggris dalam satu identifier.
3. Kode dari library eksternal (Flutter, Riverpod, Freezed, dll) tetap pakai konvensi aslinya (English).
4. Nama file `.dart` wajib menggunakan `snake_case`.
5. Nama file test: `<nama>_test.dart` (snake_case + suffix `_test`).
6. Nama file generated: `<nama>.g.dart`, `<nama>.freezed.dart`, `<nama>.mocks.dart`.
7. Class, Enum, Mixin, Extension, Typedef: `PascalCase`.
8. Generic type parameter: huruf besar tunggal (`T`, `E`, `K`, `V`).
9. Local variable, parameter, field, method, function: `camelCase`.
10. Boolean variable/field: prefix `is`/`has`/`can`/`should` (camelCase).
11. Private (underscore prefix): `_camelCase`.
12. Top-level constant, static const class field: `SCREAMING_SNAKE_CASE`.
13. Enum values: `lowerCamelCase` (bukan SCREAMING_SNAKE_CASE).
13a. Nilai enum yang dipersistenkan ke kolom database (`.name` disimpan ke kolom `TEXT`) juga wajib `lowerCamelCase` (mis. `berhasilMenahan`, `timer3Menit`). Perubahan nilai enum yang sudah tersimpan wajib disertai migrasi data di `onUpgrade` (lihat skill `migrasi-skema-sqlite`); nilai `snake_case` lama tidak boleh dipertahankan di enum baru maupun di data baru.
14. Nama tabel & kolom database: `snake_case` (lowercase + underscore).
15. Konstanta `NamaTabel` / `NamaKolom` value harus cocok persis dengan schema SQLite.
16. Import wajib pakai `package:` prefix, DILARANG relative import (`../`, `./`).
17. Urutkan import alfabetis berdasarkan path package lengkap.
18. Group: `dart:`, `package:` (external), `package:` (internal/project), lalu `export`.

## Larangan

- DILARANG campur bahasa Indonesia dan Inggris dalam satu identifier.
- DILARANG nama file dengan huruf besar (mis. `BiodataScreen.dart`).
- DILARANG single letter variable (kecuali loop index `i`, `j`, atau generic `T`).
- DILARANG abbreviation tidak standar (`btn` → `button`, `ctx` → `context`).
- DILARANG Hungarian notation (`strNama`, `intUmur`, `lstItem`).
- DILARANG nama file/class yang hanya beda case (`User.dart` vs `user.dart`).
- DILARANG relative import (`../`, `./`).
- DILARANG enum values SCREAMING_SNAKE_CASE (gunakan lowerCamelCase).

## Contoh Benar

```dart
// Identifier Indonesia
class BiodataModel { ... }
final int jumlahRokokPerHari;
Future<void> simpanBiodata() async { ... }
enum ModeBerhenti { seketika, bertahap }
const String namaTabel = 'biodata';

// File snake_case
lib/fitur/biodata/model/biodata_model.dart
lib/fitur/biodata/screens/biodata_screen.dart
test/biodata_model_test.dart

// Class PascalCase
class BiodataModel { ... }
enum ModeBerhenti { ... }
extension BiodataPerhitungan on BiodataModel { ... }

// Variable camelCase
final String namaPengguna;
int jumlahRokokPerHari;
bool isLoading;
bool hasError;
String? _errorMessage;

// Konstanta SCREAMING_SNAKE_CASE
const String namaTabel = 'biodata';
const int versiDatabase = 8;
static const int maxPanjangNama = 100;

// Enum lowerCamelCase
enum Status { loading, success, error }

// Database snake_case
class NamaTabel {
  static const String biodata = 'biodata';
  static const String craving = 'craving_diary';
}
class NamaKolom {
  static const String id = 'id';
  static const String tanggalMulai = 'tanggal_mulai_berhenti';
  static const String jumlahRokok = 'jumlah_rokok_per_hari';
}

// Import package: + alfabetis
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:berhenti_merokok/fitur/biodata/model/biodata_model.dart';
import 'package:berhenti_merokok/fitur/biodata/notifier/biodata_notifier.dart';
import 'package:berhenti_merokok/shared/utils/l.dart';
```

## Contoh Salah

```dart
// DILARANG: Campur bahasa
final int cigarettesPerDay; // English di app-code
Future<void> saveBiodata() async { ... } // English method

// DILARANG: Nama file huruf besar
lib/fitur/biodata/model/biodataModel.dart
lib/fitur/biodata/screens/BiodataScreen.dart
test/BiodataModelTest.dart

// DILARANG: Single letter variable (kecuali loop index)
final int x; // DILARANG

// DILARANG: Abbreviation tidak standar
final Button btn; // DILARANG, gunakan button
final Context ctx; // DILARANG, gunakan context

// DILARANG: Hungarian notation
final String strNama; // DILARANG
final int intUmur; // DILARANG
final List lstItem; // DILARANG

// DILARANG: Relative import
import '../model/biodata_model.dart'; // DILARANG
import './biodata_model.dart'; // DILARANG
```

## Sumber Evaluasi

- File: `lib/fitur/biodata/model/biodata_model.dart`, `lib/shared/konstanta/nama_tabel.dart`, `lib/shared/konstanta/nama_kolom.dart`
- Class terkait: `BiodataModel`, `ModeBerhenti`, `NamaTabel`, `NamaKolom`
- Commit rujukan: `1e7b71e` — Import ordering enforcement; `adc85b5` — NamaKolom snake_case constants; `3b67d309` — Indonesian identifiers throughout; `a5beae01b86a4d9753963380818bc437c2b4741a` — enum lowerCamelCase + migrasi data v12 untuk nilai tersimpan
