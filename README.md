# Spektra

**Know Your Device**

Spektra adalah aplikasi Flutter untuk Android yang dirancang sebagai alat informasi dan diagnostik perangkat — menampilkan spesifikasi perangkat, memantau kondisi hardware, dan menyediakan pengujian terhadap komponen perangkat.

> **Status implementasi:** Proyek masih berada pada tahap pengembangan awal. Pernyataan tujuan produk di atas merupakan arah produk yang terdokumentasi di dalam repositori; sebagian besar fitur tujuan tersebut **belum tersedia** di dalam kode saat ini (lihat bagian [Fitur](#fitur)).

## Identitas Proyek

| Atribut | Nilai |
|---------|-------|
| Nama paket | `spektra` |
| Versi | `1.0.0+1` |
| Bahasa | Dart (`^3.13.7`) |
| Framework | Flutter (`3.47.9`, kanal stable) |
| SDK | Material 3 (`useMaterial3: true`) |
| Platform | `android/`, `ios/`, `web/` (template bawaan Flutter; ditujukan utama untuk Android) |
| Rilis publik | Belum — `publish_to: 'none'` pada `pubspec.yaml` |
| Identifier Android | `com.example.spektra` (masih bawaan template) |

## Tujuan

Berdasarkan dokumentasi konteks di dalam repositori (`apk_kompetitor.md`, yang menjadi acuan riset aplikasi sejenis "Spektra (Know Your Device)"), Spektra disusun dengan sasaran berikut:

1. Menampilkan informasi spesifikasi perangkat (CPU, RAM, penyimpanan, layar, baterai, sistem operasi, sensor).
2. Memantau kondisi hardware secara berkala.
3. Menyediakan alat diagnostik untuk menguji fungsi komponen perangkat (mis. layar dan sensor).

**Ruang lingkup implementasi saat ini terbatas pada:** kerangka aplikasi (`ProviderScope`, `MaterialApp`, tema), navigasi empat tab, dan pengaturan mode tema dengan persistensi. Seluruh sasaran produk di atas belum diimplementasikan di dalam kode.

## Fitur

### Fitur yang sudah tersedia (terverifikasi di dalam kode)

| Fitur | Lokasi | Keterangan |
|-------|--------|------------|
| Navigasi empat tab | `lib/home.dart` | `NavigationBar` + `IndexedStack`; tab Dashboard, Biodata, Impian, dan Lainnya. Tab bersifat persisten (state terjaga saat berpindah tab) berkat `IndexedStack`. |
| Mode tema Terang / Gelap / Ikuti sistem | `lib/fitur/pengaturan/screens/pengaturan_screen.dart` | `RadioGroup<ThemeMode>` + `RadioListTile`; perubahan diterapkan seketika melalui `ref.read(temaProvider.notifier).ubah(...)`. |
| Persistensi mode tema | `lib/fitur/pengaturan/tema/tema_provider.dart` | `TemaNotifier` (`@Riverpod(keepAlive: true)`, `AsyncNotifier<ThemeMode>`) menyimpan preferensi ke `shared_preferences` dengan kunci `kunci_mode_tema` (`terang` / `gelap` / `sistem`) dan memuatnya kembali saat aplikasi dibuka; nilai gagal dibaca dinormalisasi ke `ThemeMode.system`. |
| Tema Material 3 terang/gelap | `lib/app.dart` | `ColorScheme.fromSeed(seedColor: Colors.deepPurple)` dengan varian `Brightness.light`/`Brightness.dark`; `themeMode` reaktif terhadap pilihan pengguna. |
| State management Riverpod | `lib/main.dart`, `lib/app.dart` | Aplikasi dibungkus `ProviderScope` di `main()`; provider diakses secara reaktif melalui `ref.watch`/`ref.read`. |
| Smoke test penghitung | `test/widget_test.dart` | Widget test counter dengan `SharedPreferences.setMockInitialValues({})`; memastikan aplikasi terbangun dan tombol `+` berfungsi. |

Catatan: tab **Dashboard** saat ini masih memuat antarmuka penghitung bawaan template (bukan fitur produk), sedangkan tab **Biodata** dan **Impian** menampilkan placeholder `"Biodata — belum tersedia"` / `"Impian — belum tersedia"`.

### Fitur yang belum tersedia (terdokumentasi, belum diimplementasikan)

| Fitur | Sumber dokumen | Status |
|-------|----------------|--------|
| Menampilkan spesifikasi baterai (kapasitas mAh, status pengisian) | `keluhan.md`; `hasil_diskusi/diskusi_2.md` (rencana halaman statistik baterai, Android-only, paket `battery_info_v2`) | Belum diimplementasikan |
| Pemeriksaan/pengujian layar sentuh (touch screen) | `keluhan.md` | Belum diimplementasikan |
| Tab Biodata (pengisian data diri) | `lib/home.dart` (placeholder) | Belum diimplementasikan |
| Tab Impian (visualisasi impian) | `lib/home.dart` (placeholder) | Belum diimplementasikan |
| Informasi CPU, RAM, penyimpanan, sensor, jaringan, diagnostik hardware (kamera/audio) | `apk_kompetitor.md` (daftar aplikasi sejenis sebagai acuan) | Belum diimplementasikan |

Daftar tersebut bersumber dari dokumen rencana di dalam repositori; fitur sama sekali belum tersedia di dalam kode dan belum dapat dicoba.

## Teknologi

### Framework dan bahasa

- Flutter `3.47.9` (kanal stable) dan Dart SDK `^3.13.7`
- Material 3 (`uses-material-design: true`)
- Android: Kotlin (`MainActivity`), Gradle Kotlin DSL, Java 17; tidak ada kode native tambahan — `MainActivity` masih bawaan template (`FlutterActivity`)
- iOS dan web: template bawaan Flutter (belum diverifikasi berjalan)

### Dependensi (langsung)

| Paket | Versi (`pubspec.yaml` / `pubspec.lock`) | Kegunaan |
|-------|------------------------------------------|----------|
| `flutter_riverpod` | `^3.5.0` / `3.5.0` | State management reaktif |
| `riverpod_annotation` | `^4.0.8` / `4.0.8` | Anotasi codegen Riverpod |
| `shared_preferences` | `^2.5.3` / `2.5.6` | Persistensi preferensi lokal (mode tema) |
| `cupertino_icons` | `^1.0.8` / `1.0.8` | Ikon Cupertino |
| `flutter_test` | SDK | Framework pengujian widget |
| `flutter_lints` | `^6.0.0` / `6.0.0` | Kumpulan lint rekomendasi Flutter |
| `riverpod_generator` | `^4.0.10` / `4.0.10` | Codegen (`build_runner`) untuk `*.g.dart` |
| `build_runner` | `^2.17.1` / `2.17.1` | Menjalankan code generation |

Berkas `*.g.dart` (mis. `tema_provider.g.dart`) merupakan hasil generate dan tidak boleh diedit manual; ubah sumbernya lalu jalankan `build_runner`.

## Struktur Proyek

```text
spektra/
├── lib/
│   ├── main.dart                              # Entry point; membungkus aplikasi dengan ProviderScope
│   ├── app.dart                               # MyApp (ConsumerWidget); MaterialApp + tema terang/gelap
│   ├── home.dart                              # MyHomePage; AppBar, IndexedStack, NavigationBar 4 tab
│   └── fitur/
│       └── pengaturan/
│           ├── screens/
│           │   └── pengaturan_screen.dart     # Layar pengaturan (mode tema); disematkan sebagai konten tab
│           └── tema/
│               ├── tema_provider.dart         # TemaNotifier (AsyncNotifier, keepAlive) + persistensi
│               └── tema_provider.g.dart       # Hasil generate build_runner (jangan diedit manual)
├── test/
│   └── widget_test.dart                       # Smoke test widget (counter)
├── android/                                   # Proyek Android (template; label "spektra")
├── ios/                                       # Proyek iOS (template)
├── web/                                       # Proyek web (template)
├── docs/                                      # Dokumen spesifikasi/referensi (belum terverifikasi terhadap kode)
├── hasil_diskusi/                             # Berkas hasil diskusi (diskusi_2..4)
├── memori/                                    # Berkas sesi & riwayat perubahan proyek
├── script/                                    # Skrip bantu pengembangan
└── pubspec.yaml                               # Konfigurasi paket
```

Konvensi: state Riverpod yang dapat mengubah nilai dikelompokkan pada subfolder fitur; penamaan mengikuti konvensi proyek (identifier bahasa Indonesia, berkas `snake_case`, kelas `PascalCase`). Lihat `AGENTS.md` dan `.agents/rules/` untuk aturan lengkap.

## Arsitektur dan Catatan Teknis

- **State management** menggunakan Riverpod. Akar aplikasi satu-satunya `ProviderScope` berada di `lib/main.dart`. Mode tema dikelola `TemaNotifier` (`AsyncNotifier<ThemeMode>` dengan `keepAlive: true`), bukan `ChangeNotifier`.
- **Reaktivitas tema**: `app.dart` membaca `ref.watch(temaProvider).asData?.value ?? ThemeMode.system` sehingga pergantian mode tema langsung diterapkan tanpa restart.
- **Persistensi**: preferensi disimpan lewat `shared_preferences`; nilai yang tidak dikenal atau gagal dibaca dinormalisasi ke `ThemeMode.system`.
- **Tahan kegagalan**: pemuatan/penyimpanan tema yang gagal hanya dicatat (`debugPrint`) dan tidak menghentikan aplikasi.
- **Tab Lainnya** menampilkan `PengaturanScreen` sebagai konten tab (bukan halaman yang di-push), sehingga tidak membawa `Scaffold`/`AppBar` sendiri.
- **Ketahanan `IndexedStack`**: state halaman lain tidak hilang saat berpindah tab karena seluruh anak `IndexedStack` tetap berada di dalam pohon widget.

## Menjalankan Proyek

### Prasyarat

- Flutter stable (dikembangkan dengan `3.47.9`) dan Dart `^3.13.7`
- Android SDK (untuk target Android) atau target iOS/web sesuai kebutuhan

### Langkah

```bash
# 1. Ambil dependensi
flutter pub get

# 2. Bangkitkan kode hasil generate (tema_provider.g.dart)
dart run build_runner build --delete-conflicting-outputs

# 3. Jalankan aplikasi (contoh: perangkat/emulator Android)
flutter run
```

Perintah verifikasi lain yang lazim dipakai di proyek ini:

```bash
flutter test        # menjalankan widget test
dart analyze        # analisis statis
dart format .       # format otomatis
```

Catatan: `android/local.properties` dan berkas konfigurasi mesin pengembangan tidak disertakan di dalam repositori. Build rilis Android saat ini masih memakai signing debug (bawaan template) dan `applicationId` masih `com.example.spektra`.

## Pengujian

Satu berkas pengujian tersedia: `test/widget_test.dart` — smoke test yang memverifikasi aplikasi terbangun dan interaksi tombol `+` menaikkan penghitung dari `0` ke `1`. `SharedPreferences` dimock dengan `SharedPreferences.setMockInitialValues({})`. Tidak ada pengujian lain (unit/integrasi) yang tersedia pada saat dokumentasi ini ditulis.

## Kelebihan Proyek

Berikut nilai tambah yang dapat diverifikasi langsung dari implementasi:

1. **State management modern dan terawasi.** Penggunaan Riverpod dengan code generation (`riverpod_generator`, `build_runner`) menghasilkan provider yang type-safe dan konsisten, dengan satu `ProviderScope` sebagai akar aplikasi.
2. **Tema reaktif dengan persistensi.** Mode tema terang/gelap/sistem dapat diubah pengguna dan langsung efektif; pilihan tersimpan di penyimpanan lokal sehingga bertahan setelah aplikasi ditutup dan dibuka kembali, dengan fallback aman ke `ThemeMode.system` saat gagal dibaca atau bernilai tidak dikenal.
3. **Material 3 sepenuhnya.** Aplikasi memakai `ColorScheme.fromSeed`, varian terang dan gelap, dan komponen Material 3 (`NavigationBar`, `RadioGroup`, `RadioListTile`).
4. **Struktur kode feature-first.** Fitur diletakkan di bawah `lib/fitur/<nama-fitur>/` dengan pemisahan `screens/` dan `tema/`, menjadi fondasi penataan kode yang rapi saat fitur bertambah (lihat `hasil_diskusi/diskusi_4.md` untuk rencana penataan lebih lanjut).
5. **Analisis statis dan pemformatan bawaan.** `analysis_options.yaml` mengaktifkan `flutter_lints`, dan proyek terdokumentasi konvensional (`AGENTS.md`, `.agents/rules/`) sehingga kualitas kode dapat dijaga berkala.
6. **Smoke test tersedia.** `test/widget_test.dart` memverifikasi aplikasi dapat dibangun dan merespons interaksi dasar — berguna sebagai jaring pengaman regresi awal.

Kelebihan di atas terbatas pada kemampuan yang sudah ada pada kode saat ini; kemampuan yang masih direncanakan (mis. informasi baterai, diagnostik hardware) tidak dihitung sebagai kelebihan yang tersedia.

## Batasan dan Status Saat Ini

- Fitur produk utama (informasi perangkat, monitoring hardware, diagnostik) **belum tersedia**; aplikasi belum dapat digunakan sesuai tujuan produk.
- Tab **Biodata** dan **Impian** masih placeholder; tab **Dashboard** masih contoh penghitung bawaan template.
- `applicationId`/label Android dan ikon masih bawaan template.
- Rilis publik belum ada (`publish_to: 'none'`); belum ada konfigurasi signing rilis.
- iOS/web belum diverifikasi; ditujukan utama untuk Android.
- `docs/` memuat dokumen spesifikasi yang belum tentu sinkron dengan implementasi; dokumen tersebut bukan sumber kebenaran implementasi.

## Dokumentasi Lainnya

| Berkas | Isi |
|--------|-----|
| `AGENTS.md` | Aturan global proyek (wajib dibaca sebelum bekerja) |
| `MEMORI.md` | Catatan konteks hidup proyek (status, struktur, riwayat) |
| `docs/` | Dokumen spesifikasi/referensi |
| `hasil_diskusi/` | Berkas hasil diskusi (mis. rencana halaman baterai, penataan struktur `lib/`) |
| `apk_kompetitor.md` | Daftar aplikasi sejenis (acuan riset; seluruh entri belum dianalisa) |
| `SKILLS_INDEX.md` | Indeks skill/aturan pengembangan proyek |

## Lisensi

Proyek ini bersifat privat (`publish_to: 'none'`); belum ada berkas lisensi pada repositori.
