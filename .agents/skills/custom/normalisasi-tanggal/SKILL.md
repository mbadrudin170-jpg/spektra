---
name: normalisasi-tanggal
description: "Trigger: saat membandingkan atau menghitung tanggal | Panduan normalisasi DateTime ke komponen tanggal saja (tahun-bulan-hari) sebelum perbandingan/perhitungan berbasis hari, plus klamping nilai negatif ke nol."
metadata:
  kategori: "custom"
  versi: "1.1.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Normalisasi Tanggal untuk Perbandingan dan Perhitungan Berbasis Hari

Normalisasi `DateTime` ke komponen tanggal saja sebelum membandingkan atau menghitung selisih hari, dan klamping hasil negatif ke nol.

## Aturan

1. Sebelum membandingkan atau menghitung selisih hari antara dua tanggal, normalisasi nilai `DateTime` ke komponen tanggal saja (tahun, bulan, hari) dengan membuang komponen waktu.
2. Gunakan `DateTime(tanggal.year, tanggal.month, tanggal.day)` untuk memperoleh representasi tanggal tanpa waktu.
3. Saat menghitung selisih hari dengan `difference(...).inDays`, pastikan kedua operand sudah dinormalisasi agar hasil tidak terpengaruh oleh jam/menit/detik.
4. Hasil perhitungan durasi atau jumlah hari yang dapat bernilai negatif wajib diklem (clamp) ke nol apabila nilai negatif tidak bermakna dalam konteks (mis. "hari smoke-free" tidak boleh negatif).
5. Gunakan `isBefore`/`isAfter` pada nilai yang sudah dinormalisasi untuk menentukan rentang tanggal, agar batas hari konsisten.
6. Kueri SQLite "data hari ini" untuk kolom tanggal berformat ISO-8601 yang tersimpan dalam UTC wajib memakai rentang UTC dari batas hari lokal — `where: 'kolom >= ? AND kolom < ?'` dengan `whereArgs: [awalLokal.toUtc().toIso8601String(), awalLokal.add(const Duration(days: 1)).toUtc().toIso8601String()]` — bukan prefix string `LIKE 'yyyy-MM-dd%'` dari `DateTime.now().toUtc()` (untuk zona UTC+X, entri pagi hari tersimpan dengan tanggal UTC sehari sebelumnya sehingga prefix meleset satu hari).
7. Saat memetakan hasil kueri atau catatan ke hari kalender pada UI, normalisasi dengan `tanggal.toLocal()` dulu sebelum diambil komponen year/month/day (lihat `KonsumsiHitungHelper._kunciTanggal`).

## Larangan

- Jangan membandingkan `DateTime.now()` (yang menyertakan waktu) langsung dengan tanggal yang dinormalisasi tanpa penyesuaian.
- Jangan membiarkan hasil perhitungan hari bernilai negatif pada konteks yang mensyaratkan nilai non-negatif.
- Jangan menggunakan komponen waktu dalam penentuan status hari (smoke-free / belum) pada kalender.
- Jangan memakai prefix `LIKE 'yyyy-MM-dd%'` (UTC) untuk kueri "hari ini" pada kolom yang tersimpan sebagai waktu UTC dari waktu lokal; gunakan rentang `>= awal hari lokal (UTC) AND < besok lokal (UTC)`.

## Contoh Benar

```dart
final hariIniDate = DateTime(hariIni.year, hariIni.month, hariIni.day);
final tanggalBerhentiDate = DateTime(
  tanggalBerhenti.year,
  tanggalBerhenti.month,
  tanggalBerhenti.day,
);
final totalHari = hariIniDate.difference(tanggalBerhentiDate).inDays + 1;
final totalAman = totalHari < 0 ? 0 : totalHari;

// Klamping durasi negatif ke nol.
final durasi = DateTime.now().difference(tanggalBerhenti);
final aman = durasi.isNegative ? Duration.zero : durasi;
```

## Contoh Salah

```dart
// Membandingkan DateTime.now() (dengan waktu) langsung dengan tanggal berhenti.
final totalHari = DateTime.now().difference(tanggalBerhenti).inDays + 1;
// Bisa salah satu hari karena komponen waktu.
```

## Sumber Evaluasi

- Commit: `6fd979fd9e8296bc7d9c40e9037870faef9c846a`, `02aa6b29b0669a4f5bf21651b09b43552f65d6f8`, `db5dd32f28e92346b9a8d3467fa9b2838e013a02` (rentang UTC batas hari lokal untuk kueri diary harian di `sheet_hasil_intervensi.dart`), `9c5dafbfac409c0f7405fe453101d86e2eb223d3` (`_kunciTanggal` lokal)
- File: `lib/fitur/kalender_smoke_free/screens/kalender_smoke_free_screen.dart`, `lib/fitur/pemulihan_kesehatan/screens/pemulihan_kesehatan_screen.dart`, `lib/fitur/dashboard/screens/dashboard_screen.dart`, `lib/fitur/sos_craving/widgets/sheet_hasil_intervensi.dart`, `lib/fitur/konsumsi_rokok/helper/konsumsi_hitung_helper.dart`
