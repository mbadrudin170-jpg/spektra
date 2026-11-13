# MEMORI.md — Proyek spektra

> Dokumen konteks hidup proyek. Berkas ini berubah seiring waktu; bukan kontrak tetap.
> Setiap perubahan proyek wajib dicatat lewat `memori/sesi/sesi_N.md` terlebih dahulu, baru disinkronkan ke berkas ini pada akhir sesi.
> Berkas sesi diarsipkan permanen dan tidak boleh dihapus.

## Identitas Proyek
- Nama proyek: `spektra` (paket Flutter di `pubspec.yaml`)
- Deskripsi: belum diketahui (pubspec masih berisi "A new Flutter project.")
- Platform: Flutter (android, ios, web — lihat folder `android/`, `ios/`, `web/`); platform lain belum diverifikasi
- Versi: `1.0.0+1`
- SDK Dart: `^3.13.7`
- Branch git aktif: `main`
- Status pengembangan: awal (fitur pertama `lib/fitur/pengaturan/` — layar pengaturan mode tema; sebelumnya hanya `lib/main.dart`, `lib/app.dart`, `lib/home.dart`, dan `test/widget_test.dart`)

## Tujuan Proyek
Belum diketahui. Dokumen `docs/struktur_proyek.md` dan `docs/rencana_integrasi_profile.md` mengindikasikan adanya spesifikasi fitur yang cukup lengkap (dashboard, biodata, impian, diary craving, dll.), tetapi dokumen tersebut belum diverifikasi terhadap kode sumber. Jangan menganggap `docs/struktur_proyek.md` sebagai kondisi aktual `lib/`.

## Struktur Penting
- `lib/main.dart` — entry point aplikasi (hanya berisi `main()`)
- `lib/app.dart` — root widget (`MyApp`, kini `StatefulWidget`); membuat `TemaController`, menyediakan `theme`/`darkTheme`/`themeMode` reaktif ke `MaterialApp`
- `lib/home.dart` — halaman utama (`MyHomePage` dan `_MyHomePageState`); memuat `NavigationBar` 4 tab (Dashboard, Biodata, Impian, Lainnya) mengikuti pola `docs/lib.md`; tab selain Dashboard placeholder, tab "Lainnya" kini menampilkan `PengaturanScreen`
- `lib/fitur/pengaturan/tema/tema_controller.dart` — `TemaController` (`ChangeNotifier`); memuat/mengubah mode tema (Terang/Gelap/Ikuti sistem) dan mempersistenkannya via `shared_preferences` (kunci `kunci_mode_tema`)
- `lib/fitur/pengaturan/screens/pengaturan_screen.dart` — layar `PengaturanScreen` (pilihan mode tema; disematkan sebagai konten tab, tanpa `Scaffold`/`AppBar` sendiri)
- `test/widget_test.dart` — satu widget test bawaan (mock `SharedPreferences`)
- `docs/` — dokumen spesifikasi/referensi (belum terverifikasi sinkron dengan kode)
- `script/` — kumpulan skrip bash pengembangan (antara lain `build_core_shared.sh`, `build_lib_docs.sh`, `build_structure.sh`, `script_tes.sh`)
- `.agents/rules/`, `.agents/skills/`, `SKILLS_INDEX.md` — aturan dan skill proyek
- `.kilo/` — konfigurasi Kilo proyek
- `AGENTS.md` — aturan global proyek (wajib dibaca sebelum bekerja)

## Aturan dan Skill
- Aturan global berada di `.agents/rules/global/*` (format task, PRD, hasil diskusi, skill).
- Indeks skill: `SKILLS_INDEX.md` (kategori `custom` dan `bawaan`).
- Skill wajib proyek: `memori-check` (baca/perbarui MEMORI.md + berkas sesi setiap interaksi).
- Bahasa Indonesia baku untuk respons, dokumen, dan komentar kode.
- Verifikasi sebelum lapor selesai: `dart format`, `dart analyze`, `flutter test` bila relevan.
- Berkas hasil generate (`*.g.dart`, `*.freezed.dart`, `*.mocks.dart`) tidak boleh diedit manual; ubah sumbernya lalu jalankan `build_runner`.

## Konvensi (berlaku di proyek ini, mengikuti AGENTS.md dan skill custom)
- Penamaan mengikuti skill `penamaan-konvensi` (identifier bahasa Indonesia, file snake_case, class PascalCase, konstanta SCREAMING_SNAKE_CASE, tabel/kolom snake_case).
- Detail konvensi lain merujuk `.agents/skills/custom/*`, bukan disalin ke berkas ini.

## Catatan Teknis
- Dependency baru: `shared_preferences` (persistensi pengaturan lokal; belum ada Riverpod/state management lain di proyek).
- Logger proyek (`L.*`) belum ada di spektra; error non-fatal dicatat dengan `debugPrint` sementara.
- Tema aplikasi memakai `ColorScheme.fromSeed(seedColor: Colors.deepPurple)` dengan `useMaterial3: true`, varian terang dan gelap.
- `docs/struktur_proyek.md` memuat daftar file `lib/fitur/...` yang belum ada di `lib/`; kemungkinan dokumen port/referensi dari proyek lain. Belum diketahui apakah spektra adalah lanjutan, port, atau proyek baru terpisah.
- Working tree tidak bersih per 2026-11-14 WIB (perubahan belum di-commit: `.kilo/commands/mode/mode_diskusi.md`, `hasil_diskusi/diskusi_1.md`, `MEMORI.md`, `memori/riwayat_perubahan.md`, `memori/sesi/sesi_3.md`); 3 commit: `1fb6840` (Initial commit), `4078d78` (konfigurasi linting kustom), `90f66d8` (as).

## Lokasi Hasil Diskusi
Folder `hasil_diskusi/` di root proyek. Berkas: `diskusi_1.md`, `diskusi_2.md` (nomor tertinggi: 2).

## Riwayat Diskusi
- `diskusi_1.md` (2026-11-14) — Argumen `$ARGUMENTS` pada `.kilo/commands/mode/mode_diskusi.md`; Dokumen: Final; Implementasi: Sudah Diimplementasikan. Tindak lanjut: selesai (bagian `## Argumen` ditambahkan); mirror `gpt/` belum disinkronkan (menunggu permintaan pengguna).
- `diskusi_2.md` (2026-11-13) — Menampilkan spesifikasi baterai perangkat (keluhan.md); Dokumen: Draft; Implementasi: Belum Diimplementasikan. Keputusan: Android-only, bagian halaman statistik, snapshot saat ini/manual refresh, kapasitas desain mAh (fallback `Tidak diketahui`), package `battery_info_v2`; halaman statistik belum ada di `lib/`/`docs/` (pertanyaan terbuka). Tindak lanjut belum dimulai.

## Riwayat Perubahan
Lihat `memori/riwayat_perubahan.md`.

## Lokasi Berkas Sesi
`memori/sesi/sesi_N.md` (diarsipkan permanen). Nomor tertinggi saat ini: 8 (`sesi_8.md`). Catatan: `sesi_2.md` masih ber-status `Belum Sinkron` (mengklaim `apk_kompetitor.md` dibuat, tetapi berkas tidak ada dan `git status` bersih; tidak dapat diverifikasi — menunggu keputusan pengguna).

## Catatan untuk Model Selanjutnya
- Jangan mengarang status pengembangan atau tujuan produk; bagian yang belum diverifikasi wajib ditandai "Belum diketahui".
- Sebelum mengubah proyek, buat `memori/sesi/sesi_N.md` (nomor tertinggi + 1) sesuai skill `memori-check`.
