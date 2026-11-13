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
- `lib/main.dart` — entry point aplikasi; membungkus `MyApp` dengan `ProviderScope` (satu-satunya `ProviderScope` di aplikasi)
- `lib/app.dart` — root widget (`MyApp`, `ConsumerWidget`); `themeMode` reaktif dari `ref.watch(temaProvider).asData?.value ?? ThemeMode.system`; menyediakan `theme`/`darkTheme` ke `MaterialApp`
- `lib/home.dart` — halaman utama (`MyHomePage` dan `_MyHomePageState`); memuat `NavigationBar` 4 tab (Dashboard, Biodata, Impian, Lainnya) mengikuti pola `docs/lib.md`; tab selain Dashboard placeholder, tab "Lainnya" kini menampilkan `PengaturanScreen`
- `lib/fitur/pengaturan/tema/tema_provider.dart` — `TemaNotifier` (`@Riverpod(keepAlive: true)`, `AsyncNotifier<ThemeMode>`); memuat/mengubah mode tema (Terang/Gelap/Ikuti sistem) dan mempersistenkannya via `shared_preferences` (kunci `kunci_mode_tema`); file `tema_provider.g.dart` hasil generate (jangan diedit manual)
- `lib/fitur/pengaturan/screens/pengaturan_screen.dart` — layar `PengaturanScreen` (`ConsumerWidget`; pilihan mode tema; disematkan sebagai konten tab, tanpa `Scaffold`/`AppBar` sendiri)
- `test/widget_test.dart` — satu widget test bawaan (mock `SharedPreferences`; app dibungkus `ProviderScope`)
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
- Dependency state management: `flutter_riverpod` + `riverpod_annotation` (runtime), `riverpod_generator` + `build_runner` (dev; codegen `*.g.dart`). Dependency persistensi: `shared_preferences`. `TemaController` (`ChangeNotifier`) sudah tidak ada — mode tema dikelola `TemaNotifier` (sesi_11, 2026-11-13).
- Logger proyek (`L.*`) belum ada di spektra; error non-fatal dicatat dengan `debugPrint` sementara.
- Tema aplikasi memakai `ColorScheme.fromSeed(seedColor: Colors.deepPurple)` dengan `useMaterial3: true`, varian terang dan gelap.
- `docs/struktur_proyek.md` memuat daftar file `lib/fitur/...` yang belum ada di `lib/`; kemungkinan dokumen port/referensi dari proyek lain. Belum diketahui apakah spektra adalah lanjutan, port, atau proyek baru terpisah.
- Working tree tidak bersih per 2026-11-14 WIB (sesi_15): commit `f0f437d` ("as", 2026-11-13 18:59 UTC) di `main` menyertakan hasil sesi_10/11/12 dan berada 1 commit ahead dari `origin/main`; belum di-push. Working tree/staging memuat: `apk_kompetitor.md` (baru, staged), `MEMORI.md` (dimodifikasi, staged), `memori/sesi/sesi_12.md` (dimodifikasi, staged), `memori/sesi/sesi_13.md` (dimodifikasi), `memori/sesi/sesi_14.md` (skill `struktur-folder-lib`, staged + dimodifikasi), `memori/sesi/sesi_15.md` (baru, sesi ini), direktori `.agents/skills/custom/struktur-folder-lib/` (baru), penghapusan `hasil_diskusi/diskusi_1.md` (staged, belum dijelaskan pengguna — tidak dipulihkan tanpa konfirmasi), dan `SKILLS_INDEX.md` (dimodifikasi). Commit terakhir di branch `main`: `f0f437d` ("as").

## Lokasi Hasil Diskusi
Folder `hasil_diskusi/` di root proyek. Berkas di folder: `diskusi_2.md`, `diskusi_3.md`, `diskusi_4.md` (nomor tertinggi: 4). `diskusi_1.md` terhapus dari working tree per 2026-11-14 (staged deletion, belum dijelaskan pengguna); jangan dipulihkan/dihapus dari pencatatan tanpa konfirmasi.

## Riwayat Diskusi
- `diskusi_1.md` (2026-11-14) — Argumen `$ARGUMENTS` pada `.kilo/commands/mode/mode_diskusi.md`; Dokumen: Final; Implementasi: Sudah Diimplementasikan. Tindak lanjut: selesai (bagian `## Argumen` ditambahkan); mirror `gpt/` belum disinkronkan (menunggu permintaan pengguna).
- `diskusi_2.md` (2026-11-13) — Menampilkan spesifikasi baterai perangkat (keluhan.md); Dokumen: Draft; Implementasi: Belum Diimplementasikan. Keputusan: Android-only, bagian halaman statistik, snapshot saat ini/manual refresh, kapasitas desain mAh (fallback `Tidak diketahui`), package `battery_info_v2`; halaman statistik belum ada di `lib/`/`docs/` (pertanyaan terbuka). Tindak lanjut belum dimulai.
- `diskusi_3.md` (2026-11-13) — Riset aplikasi serupa Spektra lintas-store + pembuatan `apk_kompetitor.md`; Dokumen: Final; Implementasi: Belum Diimplementasikan. Keputusan: acuan riset = Spektra sesuai README (info/diagnostik perangkat), sesi ini hanya diskusi, `apk_kompetitor.md` dibuat saat perintah riset dijalankan (semua listing baru `Status Analisa = Belum Dianalisa`), eksekusi riset satu store per iterasi (Play Store dulu → perbarui berkas → store berikutnya), `sesi_2.md` ditandai `Sudah Sinkron` (perubahan tidak dapat diverifikasi). Tindak lanjut item 3 & 4 (perbarui `.kilo/commands/cari_apk_kompetitor.md` dan selaraskan skill `riset-kompetitor` ke konteks Spektra) selesai pada sesi_10; item 1 & 2 (riset store): Google Play Store selesai pada sesi_13 (2026-11-13, 56 listing terverifikasi HTTP 200) dan F-Droid selesai pada sesi_13 (2026-11-13, 16 listing); store berikutnya (GitHub s.d. store lainnya) belum dikerjakan; `apk_kompetitor.md` dibuat; `task.md` tidak dibuat.
- `diskusi_4.md` (2026-11-13) — Penataan struktur folder `lib/`; Dokumen: Final; Implementasi: Belum Diimplementasikan. Keputusan (K-1..K-9): pola feature-first + `lib/core/` (dibuat saat ada isi nyata); `main.dart`/`app.dart`/`home.dart` tetap di akar; sub-folder lapisan di dalam fitur (`screens/` dst.); state Riverpod yang bisa mengubah nilai → folder `notifier/` + `nama_notifier.dart`, provider read-only → folder `provider/` + `nama_provider.dart`; `TemaNotifier` tetap di fitur pengaturan, direname/dipindah ke `notifier/tema_notifier.dart` (`.g.dart` digenerate ulang via `build_runner`, bukan dipindah/diedit manual); pembersihan sisa template counter di luar cakupan. Rencana pemindahan konkret (6 langkah) belum dieksekusi.

## Riwayat Perubahan
Lihat `memori/riwayat_perubahan.md`.

## Lokasi Berkas Sesi
`memori/sesi/sesi_N.md` (diarsipkan permanen). Nomor tertinggi saat ini: 15 (`sesi_15.md` — tindak lanjut `diskusi_2.md` / `kerjakan_hasil_diskusi.md`, terhenti di validasi status `Draft`; `sesi_14.md` awal sesi ini ditimpa oleh sesi paralel sehingga sesi ini dipindah ke `sesi_15.md`; belum disinkronkan). `sesi_14.md` (pembuatan skill `struktur-folder-lib`, sesi paralel) selesai dan disinkronkan pada 2026-11-14; nomor 14 sempat dibuat bersamaan oleh dua sesi. `sesi_13.md` (sesi paralel riset aplikasi serupa — Google Play Store 56 listing + F-Droid 16 listing ke `apk_kompetitor.md`) disinkronkan pada 2026-11-14 (catch-up, sesi_15, atas arahan pengguna); `## Berkas Terdampak` sesi_13 hanya mencatat berkas sesi, padahal `apk_kompetitor.md` ikut berubah (dicatat sebagai koreksi jejak di berkas sesi). `sesi_2.md` ditandai `Sudah Sinkron` pada 2026-11-13 (catch-up, sesi_9) dengan catatan eksplisit bahwa klaim pembuatan `apk_kompetitor.md` tidak dapat diverifikasi (berkas tidak ada, `git` bersih); tidak ada perubahan yang disinkronkan dari berkas tersebut. `sesi_10.md` disinkronkan pada 2026-11-13 (catch-up, sesi_11): perbarui `.kilo/commands/cari_apk_kompetitor.md` (aturan satu store per iterasi) dan selaraskan `.agents/skills/custom/riset-kompetitor/SKILL.md` ke konteks Spektra (v1.5.0). Koreksi fakta (2026-11-13, sesi utama): klaim "`SKILLS_INDEX.md` tidak ada perubahan di working tree (tidak dapat diverifikasi)" **keliru** — berkas memang dimodifikasi pada sesi_10 (trigger skill `riset-kompetitor` diperbarui ke konteks Spektra + tanggal "diperbarui" diganti ke `Sat Nov 14 2026 01:35:34 WIB`; 2 baris). `sesi_11.md` disinkronkan pada 2026-11-13 (migrasi pengaturan mode tema dari `ChangeNotifier` ke Riverpod atas persetujuan pengguna): `ProviderScope` di `lib/main.dart`, `TemaNotifier` (`tema_provider.dart`) menggantikan `TemaController`, `app.dart` jadi `ConsumerWidget`, `pengaturan_screen.dart` jadi `ConsumerWidget` tanpa parameter controller, `home.dart` berhenti meneruskan controller, test dibungkus `ProviderScope`; `dart format`, `dart analyze`, `flutter test` lulus. `sesi_12.md` (mode diskusi, penataan struktur folder `lib/`) dibuat dan disinkronkan pada 2026-11-13; `hasil_diskusi/diskusi_4.md` diterbitkan (Dokumen: Final; Implementasi: Belum Diimplementasikan).

## Catatan untuk Model Selanjutnya
- Jangan mengarang status pengembangan atau tujuan produk; bagian yang belum diverifikasi wajib ditandai "Belum diketahui".
- Sebelum mengubah proyek, buat `memori/sesi/sesi_N.md` (nomor tertinggi + 1) sesuai skill `memori-check`.
- Riset "aplikasi serupa" untuk Spektra mengacu `README.md` (aplikasi Android info/diagnostik perangkat, "Know Your Device"), **bukan** aplikasi berhenti merokok (keputusan diskusi_3, 2026-11-13).
- `apk_kompetitor.md` sudah ada (dibuat sesi_13, 2026-11-13): Google Play Store 56 listing + F-Droid 16 listing, seluruh listing baru `Status Analisa = Belum Dianalisa` (status `Sudah Dianalisa` hanya boleh diset oleh perintah `riset_kompetitor.md`). Riset dilanjutkan satu store per iterasi (GitHub → Apple App Store → Samsung Galaxy Store → Mi/GetApps → Oppo App Market → store lainnya); berkas diperbarui setelah tiap store selesai. Skill `riset-kompetitor` dan `.kilo/commands/cari_apk_kompetitor.md` sudah diselaraskan ke konteks Spektra pada sesi_10/diskusi_3 tindak lanjut item 3 & 4 (bukan lagi berkonteks berhenti merokok).
- Tabrakan nomor sesi: `sesi_14.md` = sesi paralel pembuatan skill `struktur-folder-lib` (disinkronkan 2026-11-14); berkas sesi awal sesi ini (topik diskusi_2) tertimpa dan dipindah ke `sesi_15.md` — nomor sesi tidak digunakan ulang.
- Penghapusan `hasil_diskusi/diskusi_1.md` (staged, 2026-11-14) belum dijelaskan pengguna; jangan dipulihkan/dihapus dari pencatatan tanpa konfirmasi.
- Penataan `lib/` mengikuti `hasil_diskusi/diskusi_4.md` (Final, belum dieksekusi): feature-first + `lib/core/` (dibuat saat ada isi nyata); `main.dart`/`app.dart`/`home.dart` di akar; sub-folder lapisan di dalam fitur; state Riverpod yang bisa mengubah nilai → folder `notifier/` + `nama_notifier.dart`, provider read-only → `provider/` + `nama_provider.dart`; `tema_provider.dart` akan direname ke `notifier/tema_notifier.dart` (`.g.dart` digenerate ulang); pembersihan sisa template counter di luar cakupan diskusi_4.
- Skill `struktur-folder-lib` (`.agents/skills/custom/struktur-folder-lib/SKILL.md`) merangkum acuan diskusi_4 untuk portabel lintas proyek Flutter; disusun dari diskusi_4/perintah pengguna (belum ada commit terkait); indeks `SKILLS_INDEX.md` ikut diperbarui (entri custom 44, penomoran 44–56).
