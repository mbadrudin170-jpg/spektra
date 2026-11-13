# PRODUCT REQUIREMENTS DOCUMENT (PRD)

**Status Dokumen:** Final

**Status Implementasi:** Belum Diimplementasikan

---

## 1. Informasi Produk

**Konteks penggunaan:**
Digunakan untuk mengidentifikasi produk dan memberikan gambaran umum proyek. Informasi ini menjadi identitas utama PRD.

**Aturan pengisian:**
- Isi informasi berdasarkan kondisi dan identitas proyek yang sebenarnya.
- Gunakan nama yang konsisten dengan proyek.
- Tuliskan platform dan versi yang menjadi target pengembangan.
- Bedakan status dokumen dengan status implementasi.
- Jangan mengarang informasi yang belum diketahui.

**Informasi:**
- Nama aplikasi: Spektra
- Deskripsi produk: Aplikasi info/diagnostik perangkat Android ("Know Your Device"), lokal-first (lihat `README.md`)
- Platform: Android (fitur ini Android-only; bagian lain aplikasi juga berjalan di iOS/web)
- Versi: Spektra `1.0.0+1`; Dart `^3.13.7`; Flutter `3.47.9` (stable)
- Status pengembangan: fitur baterai (A2, selesai), memori/penyimpanan (A5, selesai 2026-11-14, sesi paralel), diagnostik (A4, selesai 2026-11-14, sesi paralel); PRD A3 (Info CPU/SoC & GPU) Final, belum diimplementasikan; fitur sistem/OS ini belum ada di kode

## 2. Tujuan PRD

**Konteks penggunaan:**
Digunakan untuk menentukan hasil yang ingin dicapai dari dokumen PRD ini. Tujuan harus berhubungan langsung dengan kebutuhan dokumen.

**Aturan pengisian:**
- Tuliskan hasil yang diharapkan dari PRD.
- Pastikan setiap tujuan memiliki hubungan dengan kebutuhan dokumen PRD.
- Gunakan tujuan yang jelas dan dapat dievaluasi.
- Jangan memasukkan tujuan yang berada di luar ruang lingkup PRD.

**Isi:**
Menyiapkan spesifikasi fitur baru **A6 — Info sistem/OS** dari `refrensi_apk.md` (kernel, build fingerprint, patch keamanan, root check indikasi), supaya implementasi menghasilkan layar info sistem/OS yang akurat, lokal-first, dan konsisten dengan pola section di tab Statistik (A3: kartu "CPU/SoC & GPU"; A5: section Memori & Penyimpanan). PRD ini menjadi dasar implementasi: tanpa PRD Final, sesi implementasi tidak boleh dimulai.

Ruang lingkup PRD ini: model data, sumber pembacaan, layar, alur pengguna, dan berkas terdampak. Ruang lingkup ini **tidak** mencakup: benchmark, kode Dart/Kotlin (belum diimplementasikan), dan izin runtime tambahan (tidak diperlukan).

## 3. Daftar Fitur

**Konteks penggunaan:**
Digunakan untuk melihat keseluruhan fitur produk dan menentukan tingkat kepentingannya.

**Aturan pengisian:**
- Setiap fitur harus memiliki nama dan deskripsi yang jelas.
- Satu baris mewakili satu fitur yang dapat diidentifikasi secara terpisah.
- Hindari menggabungkan beberapa fitur berbeda dalam satu baris.
- Pastikan fitur mendukung tujuan produk dan masuk dalam ruang lingkup.
- Gunakan prioritas berdasarkan kepentingan kebutuhan produk.

| Fitur | Deskripsi | Prioritas   |
| ----- | --------- | ----------- |
| Kartu entry "Info Sistem & OS" di tab Statistik | Kartu/tombol di `lib/fitur/statistik/screens/statistik_screen.dart` (irisan eksplisit dengan PRD A5/PRD A3 — disetujui pengguna 2026-11-14); tap → push `SistemOsScreen` | Must Have   |
| Layar "Info Sistem & OS" | Layar push baru `lib/fitur/sistem_os/screens/sistem_os_screen.dart`: `AppBar` + tombol muat ulang; 4 section (Perangkat & Build, Android, Kernel, Root); label–nilai padat; angka `FontFeature.tabularFigures()` | Must Have   |
| Identitas perangkat & build | `Build.MANUFACTURER`, `MODEL`, `DEVICE`, `BRAND`, `PRODUCT`, `BOARD`, `HARDWARE`, `FINGERPRINT`, `TAGS`, `TYPE`, `DISPLAY`, `INCREMENTAL` — via `MethodChannel('spektra/sistem_os')`; di luar Android: `Tidak diketahui` | Must Have   |
| Versi Android + API + patch keamanan | `Build.VERSION.RELEASE` (versi rilis), `SDK_INT` (level API), `SECURITY_PATCH` (patch keamanan, API 23+), `CODENAME`; di luar Android: `Tidak diketahui` | Must Have   |
| Kernel | `/proc/version` (versi kernel, toolchain kompiler) via `dart:io File`; tidak terbaca → `Tidak diketahui` | Must Have   |
| Root check sederhana (indikasi) | Heuristik tanpa plugin: keberadaan berkas `su`/`magisk` di path umum (`/system/xbin/su`, `/system/bin/su`, `/sbin/su`, `/sbin/.magisk`, `/data/adb/magisk`); hasil `Terindikasi (tidak pasti)` / `Tidak terdeteksi` + keterangan "indikasi, bukan verdict absolut"; dilarang menyebut root/tidak root secara mutlak | Must Have   |
| Ringkasan sesi (tanpa realtime) | Data statis; dimuat saat layar dibuka + tombol muat ulang manual (pola A5); tanpa Timer periodik | Must Have   |
| Uji | `test/sistem_os_test.dart`: unit mapping/parse; widget test layar dengan notifier palsu | Must Have   |
| Izin & keamanan | Tanpa izin tambahan; tanpa data pengguna; tanpa `INTERNET`; `/proc/version` tanpa izin | Must Have   |
| Izin "verified boot"/VB state | Ditolak: tidak dapat dibaca API publik tanpa plugin root; dicatat `Tidak diketahui` bila ditanyakan | Could Have (ditolak) |

## 4. Alur Pengguna

**Konteks penggunaan:**
Digunakan untuk menjelaskan urutan interaksi pengguna dengan aplikasi dari awal hingga tujuan tercapai.

**Aturan pengisian:**
- Mulai dari kondisi awal pengguna.
- Jelaskan setiap langkah secara berurutan.
- Sebutkan tindakan pengguna dan respons aplikasi.
- Sertakan percabangan atau kondisi alternatif jika tersedia.
- Jelaskan kondisi akhir yang diharapkan.
- Pastikan alur sesuai dengan persyaratan fitur.
- Jangan memasukkan proses yang tidak didukung oleh kebutuhan produk.

**Isi:**
1. Pengguna membuka tab **Statistik**.
2. Pengguna melihat section Baterai (A2), section Memori & Penyimpanan (A5), dan kartu "Info CPU/SoC & GPU" (A3); di bawahnya terdapat kartu/tombol **Info Sistem & OS**.
3. Pengguna mengetuk kartu → aplikasi push `SistemOsScreen`.
4. Aplikasi menampilkan section **Perangkat & Build** (merek/model/device/brand/product/board/hardware/fingerprint/tags/type/display/incremental), section **Android** (rilis, API, patch keamanan, codename), section **Kernel** (versi dari `/proc/version`), dan section **Root** (indikasi heuristik + keterangan).
5. Data dimuat otomatis saat layar dibuka; pengguna dapat mengetuk tombol muat ulang di `AppBar` kapan pun. Tidak ada auto-refresh.
6. Pengguna kembali dengan tombol back (atau `Navigator.pop`); layar dilepas dari tree.

Kondisi alternatif:
- `/proc/version` tidak terbaca (dibatasi SELinux atau kernel abnormal) → section Kernel tampil `Tidak diketahui`; section lain tetap dirender.
- MethodChannel gagal (mis. emulator abnormal) → seluruh section tampil `Tidak diketahui`; tidak ada crash; pengguna tetap melihat struktur layar.
- Perangkat root/su terdeteksi hanya sebagai **indikasi**; tampilan wajib memakai keterangan "indikasi, bukan verdict absolut".

Kondisi akhir: pengguna melihat profil sistem/OS perangkatnya dengan indikasi root yang jujur dan tanpa izin tambahan.

## 5. Steps

**Konteks penggunaan:**
Digunakan untuk menjelaskan urutan langkah-langkah kerja yang harus diikuti dalam mengisi atau menerapkan PRD.

**Aturan pengisian:**
- Buat langkah-langkah yang spesifik dan dapat diikuti.
- Gunakan numbered list untuk mempertahankan urutan.
- Setiap langkah harus tidak ambigu dan dapat dikerjakan.
- Jangan memasukkan langkah yang tidak relevan atau redundan.

**Isi:**
1. Pindahkan isi section fitur terkait di `refrensi_apk.md` ke dokumen PRD ini (bagian "Isi dari `refrensi_apk.md`" di bawah) dan tandai section tersebut dengan penanda `<!-- PRD: prd_info_sistem_os.md -->`; jangan mengubah baris lain di `refrensi_apk.md` (versi terkini file ini: section A6 `refrensi_apk.md:59-63`; baris prioritas `refrensi_apk.md:337`; urutan eksekusi `refrensi_apk.md:359`).
2. Buat direktori fitur `lib/fitur/sistem_os/` dengan sub-folder sesuai struktur feature-first (`data/`, `model/`, `notifier/`, `screens/`) — lihat `.agents/skills/custom/struktur-folder-lib/SKILL.md` dan `.agents/skills/custom/penamaan-konvensi/SKILL.md`.
3. Tambahkan `MethodChannel('spektra/sistem_os')` di `android/app/src/main/kotlin/com/example/spektra/MainActivity.kt` dengan pemanggilan `systemInfo` yang mengembalikan `Map<String, Any?>` (`manufacturer`, `model`, `device`, `brand`, `product`, `board`, `hardware`, `fingerprint`, `tags`, `type`, `display`, `incremental`, `releaseVersion`, `sdkInt`, `securityPatch`, `codename`) — tanpa izin; API level dijaga sebelum membaca `SECURITY_PATCH` (API 23+); setiap nilai nullable bila gagal.
   - **Catatan irisan (disetujui eksplisit pengguna 2026-11-14 via tool `question`):** `MainActivity.kt` juga diubah oleh PRD A3 (`MethodChannel('spektra/cpu_gpu')`) — perubahan A6 hanya **menambah** channel kedua, tidak mengubah channel A3 maupun implementasi A4 (`spektra/tombol_volume` yang sudah ada).
4. Implementasikan `SistemOsRepository`: baca MethodChannel (langkah 3) + `/proc/version` + heuristik root di `dart:io` (semua `try/catch` → nullable; jangan pernah default ke string kosong yang terlihat valid).
5. Model `SistemOsInfo` (gaya proyek: `baterai_info.dart`/`memori_info.dart`); semua field nullable.
6. `SistemOsNotifier` (`@Riverpod(keepAlive: false)`), `muat()` memanggil repository via `AsyncValue.guard`; tidak ada timer periodik. Jalankan `dart run build_runner build --delete-conflicting-outputs` untuk `.g.dart`; jangan mengedit file generated.
7. `SistemOsScreen` (pola `MemoriPenyimpananSection`/`CpuGpuScreen`): `AppBar` dengan judul "Info Sistem & OS" + `IconButton(Icons.refresh)`; `ListView` section Perangkat & Build / Android / Kernel / Root; label–nilai padat (aman tema); nilai null → `Tidak diketahui`/`—`; angka `tabularFigures`.
8. Ubah `lib/fitur/statistik/screens/statistik_screen.dart` (irisan dengan PRD A5 & PRD A3, disetujui pengguna 2026-11-14): sisipkan kartu/tombol "Info Sistem & OS" di bawah kartu "CPU/SoC & GPU"; tap → `Navigator.push` ke `SistemOsScreen`; tidak mengubah section baterai, section memori, maupun kartu A3.
9. Buat `test/sistem_os_test.dart`; `test/widget_test.dart` TIDAK disentuh (klaim PRD A5).
10. Verifikasi: `dart format .`, `dart analyze`, `flutter test`.
11. Setelah implementasi selesai (bukan pada fase PRD ini): perbarui Status Implementasi PRD ini menjadi `Sudah Diimplementasikan`, lalu tandai/hapus section penanda di `refrensi_apk.md` sesuai alur `kerjakan_prd` yang berlaku di proyek (PRD A4/A5 kemarin: sesi implementasi menghapus PRD + section setelah selesai — tanyakan alur pada pengguna bila ambigu; jangan menghapus PRD tanpa persetujuan).

## 6. File-File Terdampak

**Konteks penggunaan:**
Digunakan untuk mengidentifikasi file proyek yang berkaitan dengan implementasi kebutuhan produk. Bagian ini menjadi gambaran awal cakupan perubahan kode.

**Aturan pengisian:**
- Periksa struktur proyek sebelum menentukan file terdampak.
- Cantumkan lokasi file secara spesifik berdasarkan struktur proyek sebenarnya.
- Tandai apakah file perlu dibuat, diubah, atau dihapus.
- Jelaskan alasan dan tujuan perubahan setiap file.
- Cantumkan hanya file yang memiliki hubungan dengan kebutuhan fitur.
- Jangan mengarang lokasi, nama, atau keberadaan file.
- Jika file belum dapat ditentukan, tandai sebagai belum diketahui dan jangan menebak.
- Perbarui daftar setelah analisis teknis atau implementasi apabila ditemukan file terdampak tambahan.

**Catatan irisan:** `lib/fitur/statistik/screens/statistik_screen.dart` diubah hanya untuk menambah kartu/tombol entry (file yang sama diklaim PRD A5, sedang dipakai PRD A3). Irisan `android/app/src/main/kotlin/com/example/spektra/MainActivity.kt` dengan PRD A3 (channel native yang sama) **disetujui eksplisit pengguna pada 2026-11-14 via tool `question`**: A6 menambah `MethodChannel('spektra/sistem_os')` (hanya menambah; channel A3 `spektra/cpu_gpu` dan channel A4 `spektra/tombol_volume` tidak diubah).

| Lokasi File | Status Perubahan | Deskripsi Perubahan |
| ----------- | ------------------ | ------------------- |
| `prd/prd_info_sistem_os.md` | Dibuat | PRD ini (fitur A6 dari `refrensi_apk.md`) |
| `refrensi_apk.md` | Diubah | Isi section `A6. Info sistem/OS` (sekarang `refrensi_apk.md:59-63`) dipindahkan ke PRD ini; section ditandai `<!-- PRD: prd_info_sistem_os.md -->`; baris prioritas `refrensi_apk.md:337` dan urutan eksekusi `refrensi_apk.md:359` tetap apa adanya |
| `android/app/src/main/kotlin/com/example/spektra/MainActivity.kt` | Diubah (irisan A3 — disetujui 2026-11-14) | Tambah `MethodChannel('spektra/sistem_os')`: `systemInfo` mengembalikan map property `Build`; tanpa izin; channel A3/A4 tidak diubah; nilai null bila gagal |
| `lib/fitur/sistem_os/data/sistem_os_repository.dart` | Dibuat | MethodChannel + `/proc/version` + heuristik root (`File.existsSync` di path umum); semua nullable |
| `lib/fitur/sistem_os/model/sistem_os_info.dart` | Dibuat | Model nilai (gaya proyek: `baterai_info.dart`/`memori_info.dart`); semua field nullable |
| `lib/fitur/sistem_os/notifier/sistem_os_notifier.dart` | Dibuat | `@Riverpod(keepAlive: false)`; `muat()` via `AsyncValue.guard`; tanpa timer |
| `lib/fitur/sistem_os/notifier/sistem_os_notifier.g.dart` | Dibuat | Hasil `build_runner` (bukan diedit manual) |
| `lib/fitur/sistem_os/screens/sistem_os_screen.dart` | Dibuat | Layar Sistem & OS; `tabularFigures`; `Tidak diketahui` fallback |
| `lib/fitur/statistik/screens/statistik_screen.dart` | Diubah (irisan A5/A3) | Sisipkan kartu/tombol "Info Sistem & OS" → `Navigator.push` ke `SistemOsScreen`; tidak mengubah section baterai, section memori, kartu A3 |
| `test/sistem_os_test.dart` | Dibuat | Unit (repository/mapping) + widget test (layar dengan notifier palsu); `test/widget_test.dart` TIDAK disentuh |
| `pubspec.yaml` | Tidak disentuh | Tidak ada dependensi baru |
| `lib/home.dart` | Tidak disentuh | Klaim PRD A4; entry diambil dari Statistik |
| `lib/fitur/diagnostik/**` | Tidak disentuh | Klaim impl A4 (selesai) |
| `lib/fitur/statistik/**` selain `statistik_screen.dart` | Tidak disentuh | Klaim PRD A5 |
| `android/app/src/main/AndroidManifest.xml` | Tidak disentuh | Tidak diperlukan izin baru |
| `keluhan.md` | Tidak disentuh | Acuan keluhan; tidak diubah |

### Isi dari `refrensi_apk.md` (dipindahkan dari section `A6. Info sistem/OS`, `refrensi_apk.md:59-63`)

- **Temuan:** AIDA64 (properti OS/Dalvik, deteksi root), Droid Hardware Info (kernel, governor, build), Device Info HW (build firmware lengkap, engineering menu MTK/Xiaomi), Test Your Android (root check + patch keamanan).
- **Tujuan:** Kelengkapan profil perangkat; bagian dari identitas "Know Your Device".
- **Referensi:** [AIDA64](https://play.google.com/store/apps/details?id=com.finalwire.aida64) (10M+ unduhan, 4,5★/74,9K ulasan; menampilkan "Android OS and Dalvik properties", "SoC and device model identification"; catatan ulasan pengguna: AIDA64 memakai pop-up menyesatkan/scareware upsell — Spektra harus bebas dari anti-pola ini, selaras C9 `refrensi_apk.md:285-291`), [Droid Hardware Info](https://play.google.com/store/apps/details?id=com.inkwired.droidinfo) (5M+ unduhan, 4,6★/40K ulasan; "System: CPU architecture, Board, Number of Cores, Clock Speed, Governor and Kernel information"; catatan ulasan: iklan tidak intrusif, namun aplikasi kadang over-privilege), [Device Info HW](https://play.google.com/store/apps/details?id=ru.andr7e.deviceinfohw) (5M+ unduhan, 4,5★/13K ulasan; "System: complete info about your firmware build"; catatan resmi: "On recent devices reading some information is blocked" — nilai tidak terbaca harus tampil `Tidak diketahui`, bukan angka karangan).
- **Saran:** Halaman sistem: merek/model/board, versi Android, API level, patch keamanan, kernel, build fingerprint; root check sederhana (pola `su`/`which` atau paket `root` detection lewat plugin; tandai "indikasi", bukan verdict absolut).
- **Prioritas:** Sedang.

### Catatan teknis pembacaan (Android)

- **Build props:** tidak tersedia dari Dart; wajib MethodChannel Kotlin (`spektra/sistem_os`); `Build.*` bersifat string publik; `SECURITY_PATCH` hanya API 23+.
- **Kernel:** `/proc/version` terbaca pada kernel standar; pada kernel dengan SELinux ketat dapat `EACCES` → `Tidak diketahui`.
- **Root check:** heuristik keberadaan berkas `su`/`magisk`; tidak bersifat pasti; **dilarang** menyebut verdict mutlak; tampilkan keterangan "indikasi, bukan verdict absolut".
- **Emoji `—`/`Tidak diketahui`:** semua nilai yang gagal dibaca tampil `Tidak diketahui` atau `—` — bukan 0, bukan string kosong terlihat valid.
