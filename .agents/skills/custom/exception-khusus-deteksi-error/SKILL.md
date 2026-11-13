---
name: exception-khusus-deteksi-error
description: "Trigger: saat mendeteksi tipe error | Panduan exception khusus (class implements Exception) untuk deteksi via type check (is), bukan string matching pesan error."
metadata:
  kategori: "custom"
  versi: "1.0.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Penggunaan Tipe Exception Khusus untuk Deteksi Error

Gunakan class exception khusus yang implements `Exception` untuk menandai kondisi error, deteksi via `is` (type check), bukan string matching.

## Aturan

1. Gunakan tipe exception khusus (class yang mengimplementasikan `Exception` atau `Error`) untuk menandai kondisi error yang perlu dideteksi oleh pemanggil.
2. Pemanggil wajib mendeteksi error melalui `is` (type check), bukan pencocokan string `e.toString().contains(...)`.
3. Tipe exception khusus wajib dideklarasikan sebagai class terpisah dengan dokumentasi singkat.
4. Jangan bergantung pada teks pesan exception untuk menentukan alur program.

## Larangan

- Jangan melempar `Exception('pesan')` lalu mendeteksi via `e.toString().contains('pesan')`.
- Jangan menggunakan string matching untuk deteksi error.

## Contoh Benar

```dart
class IzinNotifikasiTidakDiberikanException implements Exception {
  const IzinNotifikasiTidakDiberikanException();
  @override
  String toString() => 'Izin notifikasi tidak diberikan';
}

// Melempar
throw const IzinNotifikasiTidakDiberikanException();

// Mendeteksi via type check
} on Exception catch (e, s) {
  if (e is IzinNotifikasiTidakDiberikanException) {
    // tangani kegagalan izin
  }
}
```

## Contoh Salah

```dart
throw Exception('Izin notifikasi tidak diberikan');

// Mendeteksi melalui pencocokan string (rentan)
final isIzin = e.toString().contains('Izin notifikasi tidak diberikan');
```

## Sumber Evaluasi

- Commit: `07fc8df6cf5ea28fe7133b1aee5dae7b05b96590`
- File: `lib/shared/notifikasi/notifikasi_service.dart`, `lib/fitur/pengaturan/screens/pengaturan_screen.dart`
