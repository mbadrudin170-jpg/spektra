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
- Platform: Android (bagian lain aplikasi juga berjalan di iOS/web, tetapi fitur pada PRD ini Android-only)
- Versi: Spektra `1.0.0+1`; Dart `^3.13.7`; Flutter `3.47.9` (stable)
- Status pengembangan: belum ada fitur produk CPU/SoC/GPU; yang ada di `lib/fitur/statistik/` adalah section baterai (selesai) dan section memori/penyimpanan (sedang diimplementasikan paralel, sesi_30); PRD A4 (tes diagnostik) juga dikerjakan paralel (sesi_31)

## 2. Tujuan PRD

**Konteks penggunaan:**
Digunakan untuk menentukan hasil yang ingin dicapai dari dokumen PRD ini. Tujuan harus berhubungan langsung dengan kebutuhan dokumen.

**Aturan pengisian:**
- Tuliskan hasil yang diharapkan dari PRD.
- Pastikan setiap tujuan memiliki hubungan dengan kebutuhan dokumen PRD.
- Gunakan tujuan yang jelas dan dapat dievaluasi.
- Jangan memasukkan tujuan yang berada di luar ruang lingkup PRD.

**Isi:**
Menyiapkan spesifikasi fitur baru **A3 — Info CPU/SoC & GPU** dari `refrensi_apk.md` (frekuensi per core realtime, governor, arsitektur), supaya implementasi menghasilkan layar info SoC/CPU/GPU yang akurat, lokal-first, dan konsisten dengan pola A5 (section di tab Statistik + layar push). PRD ini menjadi dasar implementasi: tanpa PRD Final, sesi implementasi tidak boleh dimulai.

Ruang lingkup PRD ini: model data, sumber pembacaan, layar, alur pengguna, dan berkas terdampak. Ruang lingkup ini **tidak** mencakup: pemanfaatan CPU per proses, benchmark (ditunda — lihat A14 `refrensi_apk.md:123-129`), thermal monitor (A11 `refrensi_apk.md:99-105`), dan implementasi kode Dart/Kotlin (belum ada sesi implementasi; status `Belum Diimplementasikan`).

## 3. Daftar Fitur

**Konteks penggunaan:**
Digunakan untuk melihat keseluruhan fitur produk dan menentukan tingkat kepentingannya.

**Aturan pengisian:**
- Setiap fitur harus memiliki nama dan deskripsi yang jelas.
- Satu baris mewakili satu fitur yang dapat diidentifikasi secara terpisah.
- Hindari menggabungkan beberapa fitur berbeda dalam satu baris.
- Pastikan fitur mendukung tujuan produk dan masuk dalam ruang lingkup.
- Gunakan prioritas berdasarkan kepentingan kebutuhan produk.

| Fitur | Deskripsi | Prioritas |
| ----- | --------- | ----------- |
| Kartu entry "CPU/SoC & GPU" di tab Statistik | Kartu/tombol sederhana pada `lib/fitur/statistik/screens/statistik_screen.dart` (irisan eksplisit dengan PRD A5, disetujui pengguna 2026-11-14); tap → push `CpuGpuScreen` | Must Have   |
| Layar "Info CPU/SoC & GPU" | Layar push baru `lib/fitur/cpu_gpu/screens/cpu_gpu_screen.dart`: `AppBar` + tombol muat ulang; 3 section (SoC, Core, GPU); angka memakai `FontFeature.tabularFigures()` | Must Have   |
| Identitas SoC & core & ABI | Nama model/vendor SoC (`Build.SOC_MODEL`/`SOC_MANUFACTURER`, API 31+; fallback `/proc/cpuinfo` field `Hardware`/`model name`, `/sys/devices/soc0/machine`), board, arsitektur + ABI list (`SUPPORTED_ABIS`, API 21+), jumlah core (`/sys/devices/system/cpu/possible` atau `online`), klaster big.LITTLE (kelompok `cpuinfo_max_freq`), semua nullable → `Tidak diketahui` bila tidak terbaca | Must Have   |
| Frekuensi & governor realtime per core | `scaling_cur_freq` per core (realtime 1 detik saat layar terbuka via `Timer.periodic` + dispose), `cpuinfo_max_freq`/`cpuinfo_min_freq`, governor aktif (`scaling_governor`); semua nilai null jika gagal baca → `Tidak diketahui` (bukan 0) | Must Have   |
| GPU: renderer/vendor/OpenGL ES/Vulkan | Renderer & vendor via EGL query pada surface 1×1 tersembunyi (platform channel Kotlin); OpenGL ES version via `ActivityManager.getDeviceConfigurationInfo().glEsVersion` (tanpa izin); Vulkan via query native bila tersedia — seluruhnya **best-effort**: nilai tidak terbaca tampil `Tidak diketahui`, bukan dikarang | Must Have   |
| Refresh realtime otomatis 1 detik + muat manual | `Timer.periodic(const Duration(seconds: 1))` di notifier, `cancel()` di dispose; plus tombol muat ulang `IconButton` di `AppBar` (pola A5); tidak ada refresh saat layar tidak terlihat | Must Have   |
| Proses manufaktur (opsional) | Bila terdeteksi dari sumber (jarang tersedia; `Build.SOC_MODEL` kadang memuatnya); bila tidak → `—`; **dilarang** mengarang | Could Have  |
| Uji (test) | `test/cpu_gpu_test.dart`: unit mapping hasil baca `/sys`/`/proc` (dengan fake `File`), widget test layar dengan notifier palsu | Must Have   |
| Izin & keamanan | Tanpa izin tambahan (pembacaan `/sys` & `getDeviceConfigurationInfo()` tidak butuh izin); **tanpa** `INTERNET`, **tanpa** data pengguna | Must Have   |

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
2. Pengguna melihat section baterai (A2) dan section memori/penyimpanan (A5); di bawahnya terdapat kartu/tombol **Info CPU/SoC & GPU**.
3. Pengguna mengetuk kartu → aplikasi push `CpuGpuScreen`.
4. Aplikasi menampilkan section **SoC** (nama, vendor, board, arsitektur/ABI, jumlah core, proses manufaktur bila terdeteksi), section **Core** (per core: index, frekuensi saat ini, max/min, governor), dan section **GPU** (renderer, vendor, OpenGL ES, Vulkan).
5. Selagi layar terbuka, frekuensi per core & governor diperbarui otomatis tiap 1 detik (angka `tabularFigures`). Pengguna dapat mengetuk tombol muat ulang di `AppBar` kapan pun.
6. Pengguna kembali dengan tombol back (atau `Navigator.pop`); timer berhenti, layar dilepas dari tree.

Kondisi alternatif:
- `/sys` atau `/proc/cpuinfo` tidak terbaca (dibatasi SELinux di Android 10+ atau kernel non-standar) → field terkait tampil `Tidak diketahui`/`—`, bukan angka palsu; tidak ada crash; section SoC/Core/GPU tetap dirender.
- `Build.SOC_MODEL` hanya tersedia API 31+ → pada Android < 12 tampil `Tidak diketahui`; fallback `/proc/cpuinfo` `Hardware`/`model name` dicoba lebih dulu/setelahnya sesuai urutan terdokumentasi di repository.
- GL ES/Vulkan tidak terdeteksi → `Tidak diketahui`; fitur lain tetap berfungsi.

Kondisi akhir: pengguna melihat identitas SoC/Core/GPU perangkatnya dengan angka realtime, tanpa izin tambahan, dan tidak ada data yang dikarang.

## 5. Steps

**Konteks penggunaan:**
Digunakan untuk menjelaskan urutan langkah-langkah kerja yang harus diikuti dalam mengisi atau menerapkan PRD.

**Aturan pengisian:**
- Buat langkah-langkah yang spesifik dan dapat diikuti.
- Gunakan numbered list untuk mempertahankan urutan.
- Setiap langkah harus tidak ambigu dan dapat dikerjakan.
- Jangan memasukkan langkah yang tidak relevan atau redundan.

**Isi:**
1. Pindahkan isi section fitur terkait di `refrensi_apk.md` ke dokumen PRD ini (bagian "Isi dari `refrensi_apk.md`" di bawah) dan tandai section tersebut dengan penanda `<!-- PRD: prd_info_cpu_soc_gpu.md -->`; jangan mengubah baris lain di `refrensi_apk.md` (versi terkini file ini: section A3 `refrensi_apk.md:53-57`; baris prioritas `refrensi_apk.md:328`; urutan eksekusi `refrensi_apk.md:359`).
2. Buat direktori fitur `lib/fitur/cpu_gpu/` dengan sub-folder sesuai struktur feature-first (`data/`, `model/`, `notifier/`, `screens/`, `widgets/` bila dibutuhkan) — lihat `.agents/skills/custom/struktur-folder-lib/SKILL.md` dan `.agents/skills/custom/penamaan-konvensi/SKILL.md`.
3. Tambahkan `MethodChannel('spektra/cpu_gpu')` di `android/app/src/main/kotlin/com/example/spektra/MainActivity.kt`: `SOC_MODEL`/`SOC_MANUFACTURER` (API 31+, fallback `Build.BOARD`), `SUPPORTED_ABIS`, `getDeviceConfigurationInfo().glEsVersion`, query EGL (`eglGetDisplay`/`eglInitialize` pada konteks 1×1 tersembunyi) untuk `GL_RENDERER`/`GL_VENDOR`/`GL_VERSION`, dan query Vulkan instance version bila tersedia — seluruhnya best-effort dengan nilai null bila gagal; tanpa izin.
4. Implementasikan `CpuGpuRepository` (`dart:io`): baca `/sys/devices/system/cpu/possible` (jumlah core; fallback `max`/`online`), iterasi `cpu{N}/cpufreq/scaling_cur_freq`, `cpuinfo_max_freq`, `cpuinfo_min_freq`, `scaling_governor`, serta `/proc/cpuinfo` (field `Hardware`/`model name`) dan `/proc/version` (info kernel, opsional); semua pembacaan dalam `try/catch` → nilai null; jangan pernah default ke 0.
5. Model `CpuGpuInfo` (ikuti pola `lib/fitur/statistik/model/memori_info.dart` — kelas plain/Freezed mengikuti gaya proyek; field nullable; konversi frekuensi kHz → MHz/GHz di luar model), dan `CpuGpuNotifier` (`@Riverpod(keepAlive: false)`, `muat()` memanggil repository via `AsyncValue.guard`, dan `Timer.periodic(const Duration(seconds: 1), ...)` untuk refresh; `ref.onDispose` membatalkan timer). Jalankan `dart run build_runner build --delete-conflicting-outputs` untuk `.g.dart`; jangan mengedit file generated.
6. Buat `CpuGpuScreen` (pola `SpesifikasiBateraiSection`/`MemoriPenyimpananSection`): `AppBar` dengan judul "CPU/SoC & GPU" + `IconButton(Icons.refresh)`; `ListView` section SoC/Core/GPU; label–nilai padat (aman tema, label abu + nilai `tabularFigures`); nilai null → `Tidak diketahui`/`—`.
7. Ubah `lib/fitur/statistik/screens/statistik_screen.dart` (irisan dengan PRD A5, disetujui pengguna 2026-11-14): sisipkan kartu/tombol "Info CPU/SoC & GPU" di bawah section memori/penyimpanan; tap → `Navigator.push` ke `CpuGpuScreen`; jangan mengubah isi section baterai dan memori.
8. Buat `test/cpu_gpu_test.dart` (unit test mapping + widget test dengan notifier fake); `test/widget_test.dart` TIDAK disentuh (klaim PRD A5).
9. Verifikasi: `dart format .`, `dart analyze`, `flutter test`.
10. Setelah implementasi selesai (bukan pada fase PRD ini): perbarui Status Implementasi PRD ini menjadi `Sudah Diimplementasikan`, tandai/hapus section penanda di `refrensi_apk.md` sesuai alur `kerjakan_prd` yang berlaku di proyek (PRD A4/A5 sebelumnya diselesaikan sesi paralel dengan pola menghapus PRD + section setelah implementasi — tanyakan alur pada pengguna bila ambigu; jangan hapus PRD tanpa persetujuan).

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

**Catatan irisan (disetujui eksplisit pengguna 2026-11-14 via tool `question`):** `lib/fitur/statistik/screens/statistik_screen.dart` diubah hanya untuk menambahkan kartu/tombol entry "CPU/SoC & GPU" (file yang sama diklaim PRD A5, yang sedang diimplementasikan sesi paralel). Pola irisan identik dengan keputusan A4↔A5 (`pubspec.yaml`, `lib/home.dart`) pada 2026-11-14.

| Lokasi File | Status Perubahan | Deskripsi Perubahan |
| ----------- | ------------------ | ------------------- |
| `prd/prd_info_cpu_soc_gpu.md` | Dibuat | PRD ini (fitur A3 dari `refrensi_apk.md`) |
| `refrensi_apk.md` | Diubah | Isi section `A3. Info CPU/SoC & GPU` (sekarang `refrensi_apk.md:53-57`) dipindahkan ke PRD ini; section ditandai `<!-- PRD: prd_info_cpu_soc_gpu.md -->`; baris prioritas `refrensi_apk.md:328` dan urutan eksekusi `refrensi_apk.md:359` tetap apa adanya |
| `android/app/src/main/kotlin/com/example/spektra/MainActivity.kt` | Diubah | Tambah `MethodChannel('spektra/cpu_gpu')`: `SOC_MODEL`/`SOC_MANUFACTURER`/`SUPPORTED_ABIS`/glEsVersion/EGL (`GL_RENDERER`, `GL_VENDOR`, `GL_VERSION`)/Vulkan (opsional); tanpa izin; nilai null bila gagal |
| `lib/fitur/cpu_gpu/data/cpu_gpu_repository.dart` | Dibuat | Pembacaan `/sys/devices/system/cpu/**` + `/proc/cpuinfo` + `/proc/version` via `dart:io`; dipanggil repository dari notifier; semua nullable |
| `lib/fitur/cpu_gpu/model/cpu_gpu_info.dart` | Dibuat | Model nilai (gaya proyek: `baterai_info.dart`/`memori_info.dart`); semua field nullable; `kHz`→`MHz` tampilan di layar |
| `lib/fitur/cpu_gpu/notifier/cpu_notifier.dart` | Dibuat | `@Riverpod(keepAlive: false)`; `muat()` via `AsyncValue.guard`; `Timer.periodic(1s)` + cancel di dispose |
| `lib/fitur/cpu_gpu/notifier/cpu_notifier.g.dart` | Dibuat | Hasil `build_runner` (bukan diedit manual) |
| `lib/fitur/cpu_gpu/screens/cpu_gpu_screen.dart` | Dibuat | Layar SoC/Core/GPU; `tabularFigures`; `Tidak diketahui` fallback |
| `lib/fitur/statistik/screens/statistik_screen.dart` | Diubah (irisan A5) | Sisipkan kartu/tombol "Info CPU/SoC & GPU" → `Navigator.push` ke `CpuGpuScreen`; tidak mengubah section baterai/memori |
| `test/cpu_gpu_test.dart` | Dibuat | Unit (repository/mapping) + widget test (layar dengan notifier palsu); `test/widget_test.dart` TIDAK disentuh |
| `pubspec.yaml` | Tidak disentuh | Tidak ada dependensi baru (`dart:io` + platform channel saja) |
| `lib/home.dart` | Tidak disentuh | Klaim PRD A4; entry diambil dari Statistik |
| `lib/fitur/diagnostik/**` | Tidak disentuh | Sekumpulan fitur A4 |
| `lib/fitur/statistik/**` selain `statistik_screen.dart` | Tidak disentuh | Klaim PRD A5 |
| `android/app/src/main/AndroidManifest.xml` | Tidak disentuh | Tidak diperlukan izin baru |
| `keluhan.md` | Tidak disentuh | Acuan keluhan; tidak diubah |

### Isi dari `refrensi_apk.md` (dipindahkan dari section `A3. Info CPU/SoC & GPU`, `refrensi_apk.md:53-57`)

- **Temuan:** CPU-Z (nama SoC, arsitektur, clock per core, governor), DevCheck, Droid Hardware Info (utilisasi realtime per core), Device Info HW (klaster, governor, ekstensi GPU) menjadikan ini layar wajib. Spektra belum memiliki apa pun di domain ini.
- **Tujuan:** Fitur inti "Know Your Device"; nilai tinggi bagi pengguna yang ingin tahu SoC/performa perangkatnya.
- **Referensi:** [CPU-Z](https://play.google.com/store/apps/details?id=com.cpuid.cpu_z) (100M+ unduhan, 3,5★; ads + online validation; per-core clock & governor), [DevCheck](https://play.google.com/store/apps/details?id=flar2.devcheck) (10M+ unduhan, 4,5★; ad-free; Hardware section menampilkan SoC, arsitektur, core configuration, manufacturing process, frekuensi; root/Shizuku menambah akses), [Droid Hardware Info](https://play.google.com/store/apps/details?id=com.inkwired.droidinfo) (5M+ unduhan, 4,6★; "System: CPU architecture, Board, Number of Cores, Clock Speed, CPU Features, Governor"; realtime utilization per core), [Device Info HW](https://play.google.com/store/apps/details?id=ru.andr7e.deviceinfohw) (5M+ unduhan, 4,5★; "CPU: model, cores, clusters, family, abi, governor, frequency; GPU: model, vendor, opengl, frequency"; catatan "On recent devices reading some information is blocked").
- **Saran:** Halaman SoC: nama, vendor, arsitektur/ABI, jumlah core, klaster (big.LITTLE), frekuensi realtime per core, governor, proses manufaktur (bila terdeteksi); GPU: renderer, vendor, versi OpenGL ES/Vulkan. Gunakan angka realtime dengan `FontFeature.tabularFigures()`.
- **Prioritas:** Tinggi.

### Catatan teknis pembacaan (Android)

- **Frekuensi & governor:** `/sys/devices/system/cpu/cpu{N}/cpufreq/{scaling_cur_freq,cpuinfo_max_freq,cpuinfo_min_freq,scaling_governor}` — terbaca di banyak kernel; pada kernel dengan SELinux `enforcing` ketat (sedangkan umumnya masih terbaca untuk cpufreq) kemungkinan `EACCES`/`ENOENT` → nilai null. Nilai ada dalam kHz.
- **Jumlah core:** `/sys/devices/system/cpu/possible` (format seperti `0-7`); fallback `online`; floor = 1.
- **SoC/board/abi:** `Build.SOC_MODEL`/`SOC_MANUFACTURER` hanya API 31+; `Build.BOARD`, `Build.SUPPORTED_ABIS` via MethodChannel; fallback `/proc/cpuinfo` (`Hardware`, `model name` — sering hanya muncul di kernel lama).
- **GPU:** tidak ada file `/sys` yang stabil; gunakan query EGL + `getDeviceConfigurationInfo().glEsVersion`. Vulkan hanya bila query berhasil; selain itu `Tidak diketahui`.
- **Proses manufaktur:** hampir tidak pernah terbaca untuk aplikasi biasa; `—` adalah hasil normal.
- **Realtime:** pembaharuan via `Timer.periodic(1 detik)`; `cancel()` saat layar dilepas.
