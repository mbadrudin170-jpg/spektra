# Sesi 12 — Diskusi: struktur folder `lib/` lebih rapi dan tertata

## Status
- Status Sinkron: Sudah Sinkron
- Tanggal: Fri Nov 13 2026 18:41 WIB
- Topik: Mode diskusi — perapihan dan penataan struktur folder `lib/` pada proyek spektra

## Catatan Sesi
- Awal sesi: membaca `MEMORI.md`; catch-up sync memindai `memori/sesi/*.md` `Belum Sinkron` — hanya `sesi_11.md` (migrasi state mode tema ke Riverpod, sesi paralel). Working tree menunjukkan perubahan nyata (`lib/fitur/pengaturan/tema/tema_provider.dart` baru, `tema_controller.dart` dihapus, `pubspec.yaml` memuat `flutter_riverpod`, berkas lain termodifikasi), namun berkas sesi_11 belum mencatat berkas terdampak migrasi dan status sesi paralel tidak dapat diverifikasi dari sini — diputuskan tidak ditandai `Sudah Sinkron` dan dilaporkan ke pengguna (tidak diputuskan sendiri sesuai skill `memori-check`).
- Konteks `lib/` aktual (working tree, ada berkas belum di-commit dari sesi paralel):
  - `lib/main.dart` — entry point; `ProviderScope` + `runApp(MyApp)`.
  - `lib/app.dart` — root `MyApp` (`ConsumerWidget`); `MaterialApp` + tema terang/gelap, `themeMode` dari `temaProvider`.
  - `lib/home.dart` — `MyHomePage` (StatefulWidget); `NavigationBar` 4 tab (Dashboard placeholder berisi counter demo, Biodata, Impian, Lainnya→`PengaturanScreen`); `_PlaceholderTab` privat.
  - `lib/fitur/pengaturan/tema/tema_provider.dart` (+ `.g.dart`) — `TemaNotifier` (`@Riverpod(keepAlive: true)`).
  - `lib/fitur/pengaturan/screens/pengaturan_screen.dart` — `PengaturanScreen` (pilihan mode tema; konten tab).
- `docs/lib.md` hanyalah dump sumber aplikasi counter bawaan (bukan spesifikasi struktur); `docs/struktur_proyek.md` hanya 10 baris (snapshot usang, menandai `assets/` dan `supabase/` tidak ditemukan); tidak ada dokumen yang menetapkan struktur `lib/` target. `docs/struktur_proyek.md` tidak boleh dianggap kondisi aktual `lib/` (dicatat MEMORI.md).
- `test/widget_test.dart` — satu widget test bawaan (mock `SharedPreferences`).
- Hasil diskusi akan dibuat sebagai `hasil_diskusi/diskusi_4.md` (nomor tertinggi 3 + 1) bila diskusi mencapai keputusan.
- Diskusi selesai dan keputusan disepakati pengguna; `hasil_diskusi/diskusi_4.md` dibuat (Dokumen: Final, Implementasi: Belum Diimplementasikan).
- Keputusan kunci: pola feature-first + `lib/core/` (dibuat saat dibutuhkan); `main.dart`/`app.dart`/`home.dart` tetap di akar; sub-folder lapisan di dalam fitur; state Riverpod yang bisa mengubah nilai → folder `notifier/` + `nama_notifier.dart`, provider read-only → folder `provider/` + `nama_provider.dart`; `TemaNotifier` tetap milik fitur pengaturan, dipindah ke `notifier/tema_notifier.dart` (berkas `.g.dart` digenerate ulang, bukan dipindah/diedit manual); pembersihan sisa template counter di luar cakupan; hasil diskusi memuat blueprint + rencana pemindahan konkret (dieksekusi lewat `kerjakan_hasil_diskusi`, belum dieksekusi).
- Catatan catch-up: pada awal sesi, `sesi_11.md` (migrasi Riverpod) berstatus `Belum Sinkron` dan dilaporkan ke pengguna tanpa ditandai. Selama diskusi berlangsung, sesi paralel menyelesaikan dan menandai `sesi_11.md` `Sudah Sinkron` (MEMORI.md + `memori/riwayat_perubahan.md` sudah diperbarui oleh sesi tersebut); berkas tersebut tidak diubah oleh sesi ini.

## Berkas Terdampak
| Lokasi File | Status Perubahan | Deskripsi |
|-------------|------------------|-----------|
| `memori/sesi/sesi_12.md` | Dibuat | Berkas sesi ini |
| `hasil_diskusi/diskusi_4.md` | Dibuat | Hasil mode diskusi: blueprint + rencana pemindahan struktur `lib/` (Dokumen: Final) |
| `MEMORI.md` | Diubah | `Lokasi Hasil Diskusi`, `Riwayat Diskusi`, `Lokasi Berkas Sesi` diperbarui |
| `memori/riwayat_perubahan.md` | Diubah | Entri pencatatan diskusi_4 ditambahkan |

## Sinkronisasi ke MEMORI.md
Disinkronkan pada 2026-11-13 (akhir sesi): `MEMORI.md` — `Lokasi Hasil Diskusi` (ditambahkan `diskusi_4.md`, nomor tertinggi 4), `Riwayat Diskusi` (entri `diskusi_4.md` ditambahkan), `Lokasi Berkas Sesi` (nomor tertinggi 12 + catatan `sesi_11` disinkronkan oleh sesi paralel), dan `Catatan untuk Model Selanjutnya` (acuan blueprint `diskusi_4.md` + pembedaan `notifier/`/`provider/`) diperbarui; `memori/riwayat_perubahan.md` — entri mode diskusi (K-1..K-9) ditambahkan. Tidak ada perubahan kode yang dieksekusi (diskusi murni; rencana pemindahan belum diimplementasikan, menunggu `kerjakan_hasil_diskusi`).
