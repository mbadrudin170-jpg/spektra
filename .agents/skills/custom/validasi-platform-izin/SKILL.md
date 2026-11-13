---
name: validasi-platform-izin
description: "Trigger: saat fitur memerlukan platform atau izin | Panduan: cek dukungan platform sebelum API, minta izin sesuai kebijakan OS, periksa hasil izin sebelum mengaktifkan fitur."
metadata:
  kategori: "custom"
  versi: "1.0.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Validasi Dukungan Platform dan Izin Runtime

Periksa dukungan platform sebelum menggunakan API, minta izin sesuai kebijakan OS, periksa hasil izin sebelum mengaktifkan fitur.

## Aturan

1. Sebelum menggunakan API package, periksa dukungan platform berdasarkan versi package yang terpasang. Jangan mengasumsikan API yang sama tersedia di semua platform.
2. Jangan menampilkan kontrol fitur yang tidak didukung platform (misalnya pengingat terjadwal pada Web/Linux).
3. Permintaan izin harus mengikuti kebijakan sistem operasi dan dilakukan pada konteks yang tepat (setelah interaksi pengguna, bukan saat aplikasi pertama dibuka).
4. Periksa hasil izin sebelum menyatakan fitur berhasil diaktifkan. Jangan menyimpan status aktif jika izin sistem belum tersedia.
5. Pisahkan inisialisasi layanan dari permintaan izin pengguna. Inisialisasi boleh dilakukan saat startup, tetapi izin diminta sesuai kebutuhan fitur.
6. Tangani error platform yang tidak didukung (mis. `UnsupportedError`) secara eksplisit, bukan hanya `Exception`.

## Larangan

- Jangan meminta izin saat aplikasi pertama dibuka tanpa konteks fitur.
- Jangan menyimpan status aktif tanpa memeriksa hasil izin.
- Jangan mengasumsikan API notifikasi terjadwal tersedia di Web/Linux/Windows.

## Contoh Benar

```dart
if (kIsWeb) {
  // Jangan tampilkan pengingat terjadwal
} else if (defaultTargetPlatform == TargetPlatform.android) {
  final izin = await mintaIzinAndroid();
  if (!izin) return;
}
```

## Contoh Salah

```dart
// Meminta izin saat aplikasi pertama dibuka tanpa konteks fitur.
await plugin.requestNotificationsPermission();
// Menyimpan status aktif tanpa memeriksa hasil izin.
await setAktif(true);
```

## Sumber Evaluasi

- Commit: `774431dbf61bb330d548785e8d47597c5bdcd123`, `0cb0e52f48f6d6f95f2bfc9e8b82a092bb5f9e4f`
- File: `lib/shared/notifikasi/notifikasi_service.dart`, `lib/fitur/pengaturan/screens/pengaturan_screen.dart`, `saran.md`
