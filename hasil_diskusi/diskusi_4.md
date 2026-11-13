# Hasil Diskusi 4 — Penataan Struktur Folder `lib/`

## Status
- Dokumen: Final
- Implementasi: Sudah Diimplementasikan
- Tanggal: 2026-11-13
- Topik: Perapihan dan penataan struktur folder `lib/` pada proyek spektra (rencana pemindahan konkret)

## Latar Belakang
Pengguna menginginkan agar struktur folder `lib/` lebih rapi dan tertata. Kondisi `lib/` saat diskusi (working tree, termasuk berkas belum di-commit dari sesi paralel migrasi Riverpod):

```text
lib/
├── main.dart                              # entry point; ProviderScope + runApp(MyApp)
├── app.dart                               # root MyApp (ConsumerWidget); MaterialApp + tema terang/gelap
├── home.dart                              # MyHomePage; NavigationBar 4 tab (Dashboard, Biodata, Impian, Lainnya)
└── fitur/
    └── pengaturan/
        ├── screens/
        │   └── pengaturan_screen.dart     # PengaturanScreen (konten tab)
        └── tema/
            ├── tema_provider.dart         # TemaNotifier (@Riverpod keepAlive)
            └── tema_provider.g.dart       # hasil generate riverpod_generator
```

Temuan yang memicu diskusi:

1. Akar `lib/` berisi `app.dart`/`home.dart`, fitur berada di `lib/fitur/` — belum ada pola folder yang terdokumentasi sebagai acuan.
2. `home.dart` masih memuat sisa template Flutter (counter demo); hal itu **di luar cakupan** diskusi ini (pengguna memilih cakupan "struktur folder saja").
3. `tema_provider.dart` ditempatkan di sub-folder domain `tema/`, belum mengikuti pembedaan notifier vs provider yang disepakati.
4. Tidak ada acuan tertulis untuk `lib/core/` dan penamaan lapisan di dalam fitur.
5. `docs/struktur_proyek.md` usang (10 baris; menandai `assets/` dan `supabase/` yang tidak ada) dan `docs/lib.md` hanya dump sumber template counter — keduanya bukan acuan struktur.

## Poin Diskusi
### 1. Cakupan diskusi
- Tanya: Apakah perapihan mencakup pembersihan sisa template counter juga?
- Kesimpulan: Cakupan dibatasi pada penataan folder/pemindahan file saja; pembersihan kode demo di luar cakupan.

### 2. Pola struktur `lib/`
- Tanya: Pola apa yang dijadikan acuan?
- Kesimpulan: Feature-first + `lib/core/` untuk hal lintas-fitur. Akar `lib/` tetap berisi `main.dart`, `app.dart`, `home.dart`.

### 3. Lokasi shell utama
- Tanya: Di mana `home.dart` (`MyHomePage`, pemilik `NavigationBar`) ditempatkan?
- Kesimpulan: Tetap di akar `lib/` (`lib/home.dart`), bersama `main.dart` dan `app.dart`.

### 4. Sub-folder lapisan di dalam fitur
- Tanya: Bagaimana struktur sub-folder di dalam folder fitur?
- Kesimpulan: Sub-folder lapisan (bukan flat). `screens/` untuk layar.

### 5. Pembedaan notifier vs provider (Riverpod)
- Tanya: Bagaimana penamaan folder dan berkas untuk Riverpod?
- Kesimpulan: Provider/Notifier yang **bisa mengubah state** disimpan di folder `notifier/` dengan nama berkas `nama_notifier.dart`. Provider yang **hanya bisa membaca nilai** disimpan di folder `provider/` dengan nama berkas `nama_provider.dart`.

### 6. Lokasi tema (`TemaNotifier`)
- Tanya: Apakah tema dipindah ke `lib/core/` karena dipakai root app?
- Kesimpulan: Tetap milik fitur pengaturan (`fitur/pengaturan/`). Cukup tempatnya mengikuti konvensi notifier.

### 7. Pembuatan `lib/core/`
- Tanya: Apakah `lib/core/` dibuat sekarang?
- Kesimpulan: Disepakati namanya sebagai folder lintas-fitur, tetapi dibuat hanya saat ada isi nyata (bukan folder kosong sekarang).

### 8. Bentuk tindak lanjut
- Tanya: Apakah hasil diskusi berupa rencana pemindahan konkret?
- Kesimpulan: Ya — blueprint pohon folder target + daftar pemindahan file konkret untuk dieksekusi lewat `kerjakan_hasil_diskusi`.

## Keputusan
- K-1: Acuan struktur `lib/` adalah feature-first + `lib/core/` (dibuat saat ada isi nyata); `lib/main.dart`, `lib/app.dart`, dan `lib/home.dart` tetap di akar.
- K-2: Di dalam `lib/fitur/<nama_fitur>/` digunakan sub-folder lapisan; `screens/` untuk layar.
- K-3: State Riverpod yang bisa mengubah nilai disimpan di folder `notifier/` dengan nama berkas `nama_notifier.dart`; provider yang hanya membaca nilai disimpan di folder `provider/` dengan nama berkas `nama_provider.dart`.
- K-4: `lib/fitur/pengaturan/tema/tema_provider.dart` direname/dipindah menjadi `lib/fitur/pengaturan/notifier/tema_notifier.dart` (class `TemaNotifier` tetap); `part` diarahkan ke `tema_notifier.g.dart`.
- K-5: `tema_provider.g.dart` tidak dipindah/diedit manual; dihapus dan digenerate ulang dengan `dart run build_runner build --delete-conflicting-outputs` menjadi `tema_notifier.g.dart`.
- K-6: `TemaNotifier` tetap dimiliki fitur pengaturan (tidak dipindah ke `lib/core/`).
- K-7: Pembersihan sisa template Flutter di `lib/home.dart` (counter demo, FAB "Increment") di luar cakupan diskusi ini.
- K-8: Nama provider hasil generate (`temaProvider`) tidak berubah karena diturunkan dari nama class `TemaNotifier`; hanya jalur impor dan berkas `part` yang berubah.
- K-9: Penamaan folder lapisan mengikuti konvensi bahasa Indonesia proyek (mis. `notifier/`, `provider/`, `screens/`); folder `lib/core/` dibuat hanya saat ada isi nyata.

Blueprint target `lib/`:

```text
lib/
├── main.dart
├── app.dart
├── home.dart
└── fitur/
    └── pengaturan/
        ├── screens/
        │   └── pengaturan_screen.dart
        └── notifier/
            ├── tema_notifier.dart     # rename dari tema/tema_provider.dart
            └── tema_notifier.g.dart   # hasil build_runner
```

## Rekomendasi
- R-1: Rencana pemindahan wajib memperbarui impor di semua berkas pemakai (`lib/app.dart` dan `lib/fitur/pengaturan/screens/pengaturan_screen.dart`), lalu verifikasi `dart format`, `dart analyze`, dan `flutter test`.
- R-2: Berkas `tema_notifier.g.dart` hanya boleh dihasilkan `build_runner`; jangan pernah disalin atau diedit manual.
- R-3: Fitur baru ke depan mengikuti blueprint: `lib/fitur/<nama_fitur>/screens/`, `notifier/` (stateful), `provider/` (read-only), dan `widgets/` bila dibutuhkan.
- R-4: Cakupan `test/` mengikuti struktur `lib/` bila kelak relevan; tidak diubah sekarang (di luar cakupan).
- R-5: Bila pengguna menginginkan acuan tertulis di `docs/` (pengganti `docs/struktur_proyek.md` yang usang), buat diskusi/perintah terpisah; tidak dilakukan dalam diskusi ini.

## Tindak Lanjut
| No | Tindakan | File Terdampak | Status |
|----|----------|----------------|--------|
| 1 | Rename `lib/fitur/pengaturan/tema/tema_provider.dart` → `lib/fitur/pengaturan/notifier/tema_notifier.dart`; ubah `part` menjadi `part 'tema_notifier.g.dart';` | `lib/fitur/pengaturan/notifier/tema_notifier.dart` | selesai |
| 2 | Hapus `lib/fitur/pengaturan/tema/tema_provider.g.dart`; jalankan `dart run build_runner build --delete-conflicting-outputs` | `lib/fitur/pengaturan/notifier/tema_notifier.g.dart` | selesai |
| 3 | Perbarui impor di `lib/app.dart` ke `package:spektra/fitur/pengaturan/notifier/tema_notifier.dart` | `lib/app.dart` | selesai |
| 4 | Perbarui impor di `lib/fitur/pengaturan/screens/pengaturan_screen.dart` ke `package:spektra/fitur/pengaturan/notifier/tema_notifier.dart` | `lib/fitur/pengaturan/screens/pengaturan_screen.dart` | selesai |
| 5 | Hapus folder kosong `lib/fitur/pengaturan/tema/` | `lib/fitur/pengaturan/tema/` | selesai |
| 6 | Verifikasi `dart format`, `dart analyze`, `flutter test` | proyek | selesai |

## File Terdampak
| Lokasi File | Status Perubahan | Deskripsi |
|-------------|------------------|-----------|
| `lib/fitur/pengaturan/tema/tema_provider.dart` | Diubah (rename) | Dipindah/rename menjadi `lib/fitur/pengaturan/notifier/tema_notifier.dart`; `part` diarahkan ke `tema_notifier.g.dart` |
| `lib/fitur/pengaturan/tema/tema_provider.g.dart` | Dihapus | Digenerate ulang sebagai `tema_notifier.g.dart` oleh `build_runner` |
| `lib/fitur/pengaturan/tema/` | Dihapus | Folder kosong setelah pemindahan |
| `lib/app.dart` | Diubah | Impor diarahkan ke `notifier/tema_notifier.dart` |
| `lib/fitur/pengaturan/screens/pengaturan_screen.dart` | Diubah | Impor diarahkan ke `notifier/tema_notifier.dart` |
| `hasil_diskusi/diskusi_4.md` | Dibuat | Berkas hasil diskusi ini |
| `memori/sesi/sesi_12.md` | Dibuat | Berkas sesi mode diskusi |

## Pertanyaan Terbuka
Belum ada

## Riwayat Perubahan
| Tanggal | Perubahan |
|---------|-----------|
| 2026-11-13 | Berkas dibuat dari mode diskusi; blueprint target `lib/` dan keputusan K-1 s.d. K-9 disetujui pengguna |
| 2026-11-14 | Implementasi selesai (sesi_21): `tema_provider.dart` → `notifier/tema_notifier.dart` (part → `tema_notifier.g.dart`), `tema_provider.g.dart` digenerate ulang via `build_runner`, impor `lib/app.dart` dan `pengaturan_screen.dart` diperbarui, folder `tema/` hilang, `dart format`/`dart analyze`/`flutter test` lulus; status Tindak Lanjut → `selesai`, Implementasi → `Sudah Diimplementasikan` |
