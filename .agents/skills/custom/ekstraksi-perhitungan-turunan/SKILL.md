---
name: ekstraksi-perhitungan-turunan
description: "Trigger: saat logika perhitungan turunan terduplikasi | Panduan ekstraksi logika perhitungan turunan ke ekstensi model atau helper murni agar ditulis sekali dan konsisten di seluruh layar."
metadata:
  kategori: "custom"
  versi: "1.1.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Ekstraksi Logika Perhitungan Turunan yang Diduplikasi

Perhitungan turunan yang sama di lebih dari satu layar wajib diekstrak ke satu lokasi bersama (ekstensi model, helper murni, atau utilitas).

## Aturan

1. Apabila perhitungan turunan yang sama digunakan di lebih dari satu layar, ekstrak ke satu lokasi bersama (ekstensi pada model, helper murni, atau utilitas) agar logika hanya ditulis sekali.
2. Konsumen (layar/widget) wajib menggunakan hasil dari lokasi bersama, bukan menghitung ulang secara inline.
3. Helper murni wajib menerima parameter primitif dan tidak bergantung pada `BuildContext` atau provider.
4. Guard pembagian dengan nol wajib diterapkan pada perhitungan yang melakukan pembagian.
5. Pisahkan secara eksplisit metrik **baseline (estimasi dari biodata)** dan metrik **aktual (dari catatan konsumsi)** ke helper bersama (mis. `MetrikBerhentiHelper` di `lib/fitur/konsumsi_rokok/helper/metrik_berhenti_helper.dart` dan `KonsumsiHitungHelper` di `konsumsi_hitung_helper.dart`). Metrik aktual (`hitungRokokDihindariAktual`, `hitungUangDihematAktual`, `hitungStreak`) wajib mengecualikan hari tanpa catatan konsumsi; hari tanpa catatan bukan bukti pengguna tidak merokok.
6. Rata-rata per hari atas `n` hari kalender terakhir wajib memakai basis kalender (hari tanpa catatan dihitung 0, `rataRataKalender`), bukan rata-rata hanya atas hari yang punya catatan.
7. Layar wajib memakai helper bersama, tidak menghitung ulang secara inline — contoh nyata: `_streakSaatIni` duplikat di `kalender_smoke_free_screen.dart` dihapus dan diganti `MetrikBerhentiHelper.hitungStreak(...)`.
8. Metrik baseline wajib diberi label "estimasi" di UI; metrik aktual wajib diberi label "berdasarkan n hari tercatat" di UI. Pemanggil (layar) yang menentukan sumber angka, bukan helper.
9. Konsistensi antara dua layar untuk besaran yang sama wajib dijaga lewat satu helper (contoh: dashboard, badge, impian, dan pelacakan toksin sama-sama memakai `MetrikBerhentiHelper`).
10. Jika sebuah kalkulasi lokal perlu dipertahankan sementara, tandai dengan `TODO` yang merujuk helper target, dan hapus begitu migrasi selesai (TODO basi yang merujuk PRD yang sudah diimplementasikan dilarang dibiarkan).

## Larangan

- Jangan membuat method perhitungan inline (mis. `_hitungUangDihemat`) di layar yang menggandakan logika yang sudah ada di ekstensi/helper.
- Jangan meletakkan perhitungan turunan di provider (perhitungan bergantung pada waktu saat ini dan lebih tepat di lapisan model).
- Jangan membiarkan formula berbeda antar layar untuk besaran yang sama.
- Jangan menghitung metrik aktual dengan menganggap hari tanpa catatan sebagai "tidak merokok".
- Jangan menduplikasi logika baseline/aktual di sebuah layar saat `MetrikBerhentiHelper`/`KonsumsiHitungHelper` sudah menyediakannya.

## Contoh Benar

```dart
// Ekstensi pada model (didefinisikan sekali)
extension BiodataModelPerhitungan on BiodataModel {
  double get uangDihemat {
    if (batangPerBungkus == 0) return 0; // Guard pembagian dengan nol
    return (rokokTidakDiHisap / batangPerBungkus) * hargaRokokPerBungkus;
  }
}

// Konsumsi di layar
final uangDihemat = biodata?.uangDihemat ?? 0;
```

## Contoh Salah

```dart
// Duplikasi perhitungan inline di layar
double _hitungUangDihemat(BiodataModel? biodata) {
  if (biodata == null) return 0;
  // ... logika duplikat
}
```

## Sumber Evaluasi

- Commit: `19f43e510b1478a43c5f0594efeef6f83b6c0299`, `9c5dafbfac409c0f7405fe453101d86e2eb223d3` (sentralisasi `MetrikBerhentiHelper`/`KonsumsiHitungHelper`, `rataRataKalender`, hari diary dikecualikan), `f6d1fa2f63e367ee147e7f4cb9ded6c6707533cb` (badge + impian pakai metrik aktual), `4dd0cdb5d101413a839c37c3dfb8c594aeef60c2` (hapus duplikat `_streakSaatIni` di kalender)
- File: `lib/fitur/biodata/model/biodata_model.dart`, `lib/fitur/konsumsi_rokok/helper/metrik_berhenti_helper.dart`, `lib/fitur/konsumsi_rokok/helper/konsumsi_hitung_helper.dart`, `lib/fitur/badge/helper/badge_helper.dart`, `lib/fitur/badge/screens/badge_screen.dart`, `lib/fitur/dashboard/screens/dashboard_screen.dart`, `lib/fitur/impian/screens/impian_screen.dart`, `lib/fitur/kalender_smoke_free/screens/kalender_smoke_free_screen.dart`, `lib/fitur/toxin_pelacakan/screens/toxin_pelacakan_screen.dart`
