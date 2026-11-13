---
name: import-ordering
description: "Trigger: saat menambahkan atau merapikan import | Panduan urutan import alfabetis berdasarkan path package lengkap dengan komentar penjelas seperlunya."
metadata:
  kategori: "custom"
  versi: "1.1.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Import Ordering (Urutan Import)

Import wajib diurutkan secara alfabetis berdasarkan path package lengkap.

## Aturan

1. Urutkan seluruh import dalam setiap kelompok secara alfabetis berdasarkan path lengkap, bukan berdasarkan jenis file atau urutan pemakaian.
2. Import dari package proyek wajib diurutkan berdasarkan path lengkap.
3. Terapkan aturan yang sama pada import notifier, model, helper, screens, dan widget; jangan menempatkan import berdasarkan perkiraan prioritas.
4. Saat memperbaiki urutan import, verifikasi seluruh blok import sudah terurut alfabetis secara penuh, bukan hanya menukar dua baris yang terlihat bermasalah. Satu pasang import yang salah urut tetap melanggar aturan.
5. Prinsip ini berlaku untuk seluruh file Dart dalam proyek.
6. Komentar penjelas boleh diletakkan dekat import terkait bila membantu menjelaskan alasan urutan, tetapi komentar tidak menggantikan kewajiban mengurutkan path import.

## Contoh Benar

```dart
import 'package:berhenti_merokok/fitur/impian/model/impian_model.dart';
// Urutan paket alfabetis: notifier diurutkan sebelum screens, sesuai aturan import ordering.
import 'package:berhenti_merokok/fitur/impian/notifier/impian_notifier.dart';
import 'package:berhenti_merokok/fitur/impian/screens/form_impian.dart';
import 'package:berhenti_merokok/fitur/impian/widget/visual_tabungan_impian.dart';
```

## Contoh Salah

```dart
import 'package:berhenti_merokok/fitur/impian/model/impian_model.dart';
import 'package:berhenti_merokok/fitur/impian/screens/form_impian.dart';
import 'package:berhenti_merokok/fitur/impian/notifier/impian_notifier.dart';
import 'package:berhenti_merokok/fitur/impian/widget/visual_tabungan_impian.dart';
```

## Sumber Evaluasi

- Commit: `86b437c75df86daa9e41b9f7ae46c9331213c341`
- File: `lib/fitur/impian/screens/detail_impian_screen.dart`
