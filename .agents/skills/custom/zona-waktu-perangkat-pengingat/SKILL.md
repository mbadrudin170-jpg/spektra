---
name: zona-waktu-perangkat-pengingat
description: "Trigger: saat menjadwalkan pengingat berbasis zona waktu | Panduan flutter_timezone untuk deteksi zona lokal, inisialisasi tz database, fallback Asia/Jakarta, handle error tiap tahap."
metadata:
  kategori: "custom"
  versi: "1.0.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Zona Waktu Perangkat untuk Pengingat Harian

Pengingat harian wajib ikuti zona waktu lokal perangkat, bukan Asia/Jakarta permanen. Deteksi via flutter_timezone, fallback Asia/Jakarta.

## Cakupan yang Di-Cover

- Package: `package:timezone` as `tz` (class `tz`, `TZDateTime`, `Location`), `package:flutter_timezone` (class `FlutterTimezone`)
- Class: `tz`, `TZDateTime`, `Location`, `FlutterTimezone`
- Method: `tz.initializeTimeZones()`, `tz.getLocation()`, `tz.setLocalLocation()`, `FlutterTimezone.getLocalTimezone()`, `L.i()`, `L.w()`, `L.e()`
- Properti: `Location.identifier`, `Location.name`

## Aturan

1. Pengingat harian wajib mengikuti zona waktu lokal perangkat, bukan `Asia/Jakarta` permanen.
2. Inisialisasi database zona waktu via `tz.initializeTimeZones()` sebelum pencarian/penetapan lokasi.
3. Gunakan `FlutterTimezone.getLocalTimezone()` untuk dapatkan zona perangkat.
4. Gunakan properti `identifier` dari `TimezoneInfo` untuk `tz.getLocation(identifier)`.
5. Setelah lokasi ditemukan, set `tz.setLocalLocation(...)` sebelum buat/jadwalkan `TZDateTime`.
6. Jangan gunakan singkatan WIB/WITA/WIT sebagai identifier tanpa validasi. Utamakan identifier dari package.
7. `Asia/Jakarta` hanya fallback jika deteksi/pencarian gagal.
8. Handle error setiap tahap: inisialisasi DB, deteksi perangkat, pencarian lokasi, set lokasi, fallback.
9. Log identifier yang terdeteksi. Fallback → log warning/error.
10. Pastikan zona waktu berhasil diset sebelum lanjut penjadwalan.
11. Fallback Asia/Jakarta gagal → handle sebagai kegagalan inisialisasi.
12. Gunakan exception handling sesuai API package, jangan catch Exception terlalu luas.

## Larangan

- Jangan set `Asia/Jakarta` permanen tanpa deteksi perangkat.
- Jangan inisialisasi database zona waktu (`tz.initializeTimeZones()`) diabaikan.
- Jangan abaikan error deteksi/pencarian/set lokasi.
- Jangan gunakan singkatan WIB/WITA/WIT sebagai identifier tanpa validasi.
- Jangan abaikan hasil null dari `locale` atau `platformBrightness` tanpa fallback.

## Contoh Benar

```dart
Future<void> setupZonaWaktu() async {
  try {
    // Inisialisasi database zona waktu
    tz.initializeTimeZones();

    // Deteksi zona waktu perangkat
    final deviceTz = await FlutterTimezone.getLocalTimezone();
    L.i('deviceTimezone=${deviceTz.identifier}');

    // Gunakan identifier dari TimezoneInfo
    final location = tz.getLocation(deviceTz.identifier);

    // Set lokasi sebelum penjadwalan
    tz.setLocalLocation(location);
    L.i('timezoneSet=${location.name}');
  } catch (e, s) {
    // Fallback ke Asia/Jakarta dengan logging
    L.w('fallbackToAsiaJakarta: $e');
    try {
      final fallback = tz.getLocation('Asia/Jakarta');
      tz.setLocalLocation(fallback);
    } catch (e2, s2) {
      L.e('fallbackFailed: $e2 $s2');
      rethrow;
    }
  }
}
```

## Contoh Salah

```dart
// DILARANG: Set Asia/Jakarta permanen tanpa deteksi perangkat
tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

// DILARANG: Tidak inisialisasi database zona waktu
// DILARANG: Tidak handle error deteksi/pencarian/set lokasi

// DILARANG: Gunakan singkatan WIB tanpa validasi
tz.setLocalLocation(tz.getLocation('WIB')); // Tidak valid identifier
```

## Sumber Evaluasi

- File: `pubspec.yaml`, `pubspec.lock`, `lib/shared/notifikasi/notifikasi_service.dart`, `saran.md`
- Class terkait: `tz`, `TZDateTime`, `Location`, `FlutterTimezone`
- Commit rujukan: `d42422ba65a0f3c90b46a0736a197af572b62c33` — Zona waktu perangkat dengan fallback Asia/Jakarta
