# Referensi APK Kompetitor Spektra — Laporan Riset

> Laporan referensi mendalam dari 10 dari 209 listing di `apk_kompetitor.md` (hanya listing `Status Analisa = Belum Dianalisa`; setelah analisa, status 10 baris tersebut diubah menjadi `Sudah Dianalisa`). Lingkup: aplikasi info/diagnostik perangkat ("Know Your Device") yang berjalan di **mobile**; Spektra bersifat **lokal-first** (lihat `README.md`). Dokumen ini riset pembanding, bukan keputusan implementasi — pengguna menyortir sendiri.

## Status

- Dokumen: Final (hasil riset; belum ada keputusan implementasi)
- Tanggal riset: 2026-11-14
- Topik: Referensi kompetitor untuk fitur, UI/UX, dan layout Spektra

## Cara Membaca

- Setiap rekomendasi memuat: **Temuan**, **Tujuan**, **Referensi** (link), **Saran**, **Prioritas** (Tinggi/Sedang/Rendah).
- Urutan item dalam seksi mengikuti prioritas (Tinggi → Sedang → Rendah).
- Rekomendasi hanya untuk fitur yang dapat berjalan di mobile dan lokal-first. Fitur yang butuh backend/akun atau khusus iOS/Wear OS dicatat sebagai referensi pola saja, bukan rekomendasi utama.
- Seksi D memuat katalog 10 APK yang dianalisa; seksi E gabungan prioritas; seksi F verifikasi & keterbatasan; seksi G sumber.

## Ringkasan Temuan Terbesar

1. **Kategori "dashboard spesifikasi + detail per kategori" adalah pola dominan** di aplikasi info perangkat teratas (DevCheck 10M+ unduhan, ytheekshana 10M+, Castro 500K+, Droid Hardware Info 5M+). Semuanya menempatkan ringkasan (CPU/RAM/baterai/penyimpanan) di depan, lalu halaman detail per kategori.
2. **Monitoring realtime dengan grafik** (baterai, frekuensi CPU, sensor) adalah pembeda utama antara aplikasi "statis" (AIDA64, CPU-Z, Droid Hardware Info) dan aplikasi "modern" (DevCheck, ytheekshana, Castro, Device Watch).
3. **Diagnostik interaktif per komponen** (layar, sentuh, audio, kamera, sensor) paling matang di Test Your Android (35+ tes) dan ytheekshana (Hardware Tests); keduanya tanpa laporan gabungan otomatis — celah bagi Spektra.
4. **Export laporan** (Teks/PDF/JSON) tersedia di ytheekshana, Droid Hardware Info, Athena; jarang di aplikasi diagnostik.
5. **Widget & overlay** (DevCheck Pro, ytheekshana, Device Watch) populer namun menambah kompleksitas Android (`SYSTEM_ALERT_WINDOW`, Jetpack Glance); ditempatkan pada prioritas rendah.
6. **Material You / Material 3** dipakai konsisten oleh Athena (F-Droid, open source), Device Watch, ytheekshana — selaras dengan tema Spektra yang sudah Material 3.

## Kondisi Fitur Aktual Proyek (acuan `README.md`)

- Fitur produk Spektra **belum tersedia** di kode. Yang ada: kerangka aplikasi (`ProviderScope`, `MaterialApp`, tema Material 3), navigasi empat tab (`NavigationBar` + `IndexedStack`; tab Dashboard masih template counter; tab Biodata/Impian placeholder), dan pengaturan mode tema dengan persistensi.
- Rencana yang sudah terdokumentasi: halaman statistik baterai Android-only (`battery_info_v2`, `hasil_diskusi/diskusi_2.md`, Draft); pengujian layar sentuh (`keluhan.md`); info CPU/RAM/penyimpanan/sensor/jaringan/diagnostik (`apk_kompetitor.md` sebagai acuan).
- Konsekuensi: seluruh rekomendasi seksi A–C adalah **usulan baru**, belum diimplementasikan dan belum tervalidasi terhadap UI nyata Spektra.

---

## A. Rekomendasi Fitur Baru (mobile, lokal-first)

### A1. Dashboard spesifikasi perangkat (ringkasan + pintasan)

- **Temuan:** Semua kompetitor kuat menempatkan ringkasan perangkat di halaman depan (DevCheck Dashboard, Castro dashboard window, ytheekshana Dashboard, Device Watch Home). Spektra belum memiliki dashboard (tab Dashboard masih template counter).
- **Tujuan:** Akses cepat ke kondisi perangkat tanpa membuka banyak layar; menjadi kerangka navigasi fitur Spektra.
- **Referensi:** [DevCheck](https://play.google.com/store/apps/details?id=flar2.devcheck), [Castro](https://play.google.com/store/apps/details?id=com.itemstudio.castro), [Device Info: System & CPU Info (ytheekshana)](https://play.google.com/store/apps/details?id=com.ytheekshana.deviceinfo), [Device Watch](https://f-droid.org/packages/org.jarsi.devicewatch/)
- **Saran:** Kartu ringkas CPU (frekuensi/inti), RAM (terpakai/total), baterai (level/status/suhu), penyimpanan (terpakai/total); tiap kartu menaut ke halaman detail terkait; indikator nilai realtime; nilai tidak tersedia ditampilkan `—`, bukan data karangan.
- **Prioritas:** Tinggi.

### A2. Halaman info baterai mendalam + grafik arus/pengisian

- **Temuan:** DevCheck (status/suhu/level/tegangan/arus/daya/kapasitas + Battery Monitor Pro), ytheekshana (Battery Monitor: arus mA, daya watt, estimasi kapasitas), Device Info HW (arus pengisian/pengurasan, power profile) merinci baterai jauh melampaui info dasar. Selaras dengan rencana `hasil_diskusi/diskusi_2.md` (statistik baterai, `battery_info_v2`).
- **Tujuan:** Memenuhi rencana diskusi_2 dan memberi nilai diagnostik nyata (kesehatan baterai, kecepatan charge/drain).
- **Referensi:** [DevCheck](https://play.google.com/store/apps/details?id=flar2.devcheck), [Device Info: System & CPU Info (ytheekshana)](https://play.google.com/store/apps/details?id=com.ytheekshana.deviceinfo), [Device Info HW](https://play.google.com/store/apps/details?id=ru.andr7e.deviceinfohw)
- **Saran:** Implementasikan per diskusi_2 (Android-only, snapshot saat buka + refresh manual, kapasitas desain mAh dengan fallback `Tidak diketahui`); tambahkan grafik kecil arus (mA) dan daya (W) bila paket mendukung; tandai keterbatasan (aplikasi pihak ketiga tidak selalu akurat pada perangkat tertentu).
- **Prioritas:** Tinggi.

### A3. Info CPU/SoC & GPU (frekuensi per core realtime, governor, arsitektur)

<!-- PRD: prd_info_cpu_soc_gpu.md -->
Sudah dibuatkan PRD-nya: `prd/prd_info_cpu_soc_gpu.md` (dibuat 2026-11-14). Isi section ini telah dipindahkan ke PRD tersebut; bagian ini hanya penanda.
- **Prioritas:** Tinggi.

### A6. Info sistem/OS (kernel, build, patch keamanan, root check)

- **Temuan:** AIDA64 (properti OS/Dalvik, deteksi root), Droid Hardware Info (kernel, governor, build), Device Info HW (build firmware lengkap, engineering menu MTK/Xiaomi), Test Your Android (root check + patch keamanan).
- **Tujuan:** Kelengkapan profil perangkat; bagian dari identitas "Know Your Device".
- **Referensi:** [AIDA64](https://play.google.com/store/apps/details?id=com.finalwire.aida64), [Droid Hardware Info](https://play.google.com/store/apps/details?id=com.inkwired.droidinfo), [Device Info HW](https://play.google.com/store/apps/details?id=ru.andr7e.deviceinfohw)
- **Saran:** Halaman sistem: merek/model/board, versi Android, API level, patch keamanan, kernel, build fingerprint; root check sederhana (pola `su`/`which` atau paket `root` detection lewat plugin; tandai "indikasi", bukan verdict absolut).
- **Prioritas:** Sedang.

### A7. Monitoring sensor realtime (grafik)

- **Temuan:** DevCheck (grafik realtime akselerometer/cahaya/proksimitas/langkah), Castro (grafik sensor realtime), Droid Hardware Info (pengujian realtime), ytheekshana (daftar sensor + konsumsi daya/wake-up).
- **Tujuan:** Nilai monitoring berkelanjutan; pembeda dari aplikasi info statis.
- **Referensi:** [DevCheck](https://play.google.com/store/apps/details?id=flar2.devcheck), [Castro](https://play.google.com/store/apps/details?id=com.itemstudio.castro), [Droid Hardware Info](https://play.google.com/store/apps/details?id=com.inkwired.droidinfo)
- **Saran:** Daftar sensor perangkat + grafik garis realtime sederhana per sensor (akselerometer/cahaya sebagai awal); baca via `sensors_plus`; tampilkan vendor/tipe/daya bila tersedia.
- **Prioritas:** Sedang.

### A8. Ekspor/berbagi laporan perangkat (Teks/PDF/JSON)

- **Temuan:** ytheekshana (ekspor Teks/PDF + tautan berbagi), Droid Hardware Info (ekspor laporan), Athena (ekspor JSON), Device Watch (CSV/HTML).
- **Tujuan:** Pengguna dapat menyimpan/membaca/membagikan spesifikasi perangkat (mis. saat jual-beli ponsel bekas).
- **Referensi:** [Device Info: System & CPU Info (ytheekshana)](https://play.google.com/store/apps/details?id=com.ytheekshana.deviceinfo), [Droid Hardware Info](https://play.google.com/store/apps/details?id=com.inkwired.droidinfo), [Athena](https://f-droid.org/packages/dev.sebaubuntu.athena/)
- **Saran:** Tombol "Bagikan/Ekspor" di halaman detail; format teks polos dulu (tanpa dependensi PDF), JSON opsional; jangan sertakan data pribadi (opsi bersih).
- **Prioritas:** Sedang.

### A9. Riwayat baterai & pengisian (grafik harian, ekspor CSV)

- **Temuan:** Device Watch (history 14 hari + charging sessions, CSV/HTML export, since-charge view, sepenuhnya offline), Battery Monitor (F-Droid, riwayat + widget), DevCheck (Battery Monitor Pro).
- **Tujuan:** Diagnosis pola konsumsi baterai; nilai diferensiasi untuk pengguna power-user.
- **Referensi:** [Device Watch](https://f-droid.org/packages/org.jarsi.devicewatch/), [DevCheck](https://play.google.com/store/apps/details?id=flar2.devcheck)
- **Saran:** Pencatatan berkala (mis. tiap perubahan level signifikan) ke tabel lokal (SQLite/Drift), grafik 14 hari, ekspor CSV; murni lokal, tanpa izin internet.
- **Prioritas:** Sedang.

### A10. Widget layar utama (baterai/CPU/RAM)

- **Temuan:** DevCheck Pro, ytheekshana (widget Material You), Device Watch (widget resizeable + Quick Settings tile + floating figure), SysFloat.
- **Tujuan:** Akses metrik tanpa membuka aplikasi.
- **Referensi:** [DevCheck](https://play.google.com/store/apps/details?id=flar2.devcheck), [Device Info: System & CPU Info (ytheekshana)](https://play.google.com/store/apps/details?id=com.ytheekshana.deviceinfo), [Device Watch](https://f-droid.org/packages/org.jarsi.devicewatch/)
- **Saran:** Widget kecil (baterai + CPU) memakai `home_widget`; update periodik terbatas (mis. 15–30 menit) untuk hemat baterai; pertimbangkan setelah A1–A5 stabil.
- **Prioritas:** Sedang.

### A11. Thermal monitor (suhu CPU/GPU/baterai + alarm overheat)

- **Temuan:** DevCheck, ytheekshana (Thermal Monitor), Droid Hardware Info (suhu internal), HWMonitor — suhu sering jadi "keluhan nyata" pengguna; alarm overheat ada di Battery Temperature/System Monitor.
- **Tujuan:** Peringatan dini overheating; melengkapi "monitoring kondisi hardware" pada tujuan produk.
- **Referensi:** [DevCheck](https://play.google.com/store/apps/details?id=flar2.devcheck), [Device Info: System & CPU Info (ytheekshana)](https://play.google.com/store/apps/details?id=com.ytheekshana.deviceinfo), [Droid Hardware Info](https://play.google.com/store/apps/details?id=com.inkwired.droidinfo)
- **Saran:** Tampilkan sensor termal yang tersedia (CPU/GPU/baterai); ambang alarm konfigurabel; catat bahwa pembacaan tergantung sensor perangkat (bisa kosong — tampilkan `—`).
- **Prioritas:** Sedang.

### A12. Info jaringan Wi-Fi & seluler (detail koneksi, IP)

- **Temuan:** DevCheck (Wi-Fi/seluler detail, IP publik, dual-SIM), AIDA64, ytheekshana (IP/gateway/DNS/link speed; Wi-Fi Analyzer terpisah), Athena (RIL/Wi-Fi section).
- **Tujuan:** Kelengkapan info perangkat; berguna untuk troubleshooting koneksi.
- **Referensi:** [DevCheck](https://play.google.com/store/apps/details?id=flar2.devcheck), [AIDA64](https://play.google.com/store/apps/details?id=com.finalwire.aida64), [Device Info: System & CPU Info (ytheekshana)](https://play.google.com/store/apps/details?id=com.ytheekshana.deviceinfo)
- **Saran:** Halaman jaringan: tipe koneksi, operator/SIM, IP lokal, kecepatan link, sinyal (dBm bila tersedia); pencarian IP publik hanya bila pengguna mengaktifkan (butuh jaringan — tetap lokal, tanpa akun); **jangan** memasukkan Wi-Fi Analyzer/port scan sebagai default (lihat A13).
- **Prioritas:** Rendah.

### A13. Alat jaringan lanjutan (Wi-Fi analyzer, network mapper, ping) — referensi saja

- **Temuan:** ytheekshana (Wi-Fi Analyzer, Network Mapper), Vernet/Network Scanner (F-Droid), DevCheck Pro (Network Mapper, Wi-Fi Scan). Sangat berguna tapi melebar dari fokus "info perangkat" dan sebagian butuh izin lokasi.
- **Tujuan:** (dicatat sebagai referensi pola, bukan rekomendasi utama) analisis jaringan di sekitar perangkat.
- **Referensi:** [Device Info: System & CPU Info (ytheekshana)](https://play.google.com/store/apps/details?id=com.ytheekshana.deviceinfo), [DevCheck](https://play.google.com/store/apps/details?id=flar2.devcheck)
- **Saran:** Tunda; bila nanti ditambahkan, jadikan menu diagnostik terpisah dengan izin lokasi eksplisit.
- **Prioritas:** Rendah.

### A14. Benchmark CPU/GPU/penyimpanan — referensi saja

- **Temuan:** DevCheck (benchmark CPU/memori/storage/GPU gratis + Benchmark Labs Pro), CPU-Z (online validation), AnTuTu/Geekbench/3DMark (di luar lingkup 10 APK ini tapi terdaftar di `apk_kompetitor.md`).
- **Tujuan:** (referensi pola) ukur performa lintas perangkat.
- **Referensi:** [DevCheck](https://play.google.com/store/apps/details?id=flar2.devcheck)
- **Saran:** Tunda; benchmark akurat butuh waktu implementasi dan validasi besar, di luar tujuan awal Spektra (info + diagnostik komponen). Bila dipilih, mulai dari benchmark penyimpanan baca/tulis sederhana.
- **Prioritas:** Rendah.

### A15. Info kamera & codec (aperture, RAW, codec AV1/HEVC)

- **Temuan:** DevCheck (kamera: aperture/ISO/RAW/crop factor), ytheekshana (kamera + codec AV1/HEVC/VP9), Athena (Camera/DRM/Media section).
- **Tujuan:** Detail perangkat tingkat lanjut; kebutuhan niche.
- **Referensi:** [DevCheck](https://play.google.com/store/apps/details?id=flar2.devcheck), [Device Info: System & CPU Info (ytheekshana)](https://play.google.com/store/apps/details?id=com.ytheekshana.deviceinfo)
- **Saran:** Tampilkan daftar kamera (resolusi, aperture, focal length bila tersedia via Camera2 API) dan codec perangkat bila mudah; bila tidak, lewati.
- **Prioritas:** Rendah.

### A16. Floating overlay monitor (FPS/CPU/baterai di atas aplikasi lain)

- **Temuan:** DevCheck Pro, ytheekshana, Device Watch (floating figure 1–3 metrik), SysFloat — populer di gaming, tapi butuh izin `SYSTEM_ALERT_WINDOW` dan sering dimatikan oleh penghemat baterai (keluhan ulasan DevCheck).
- **Tujuan:** Monitoring sekilas tanpa membuka aplikasi (referensi; tidak direkomendasikan sebagai fitur awal).
- **Referensi:** [DevCheck](https://play.google.com/store/apps/details?id=flar2.devcheck), [Device Watch](https://f-droid.org/packages/org.jarsi.devicewatch/), [Device Info: System & CPU Info (ytheekshana)](https://play.google.com/store/apps/details?id=com.ytheekshana.deviceinfo)
- **Saran:** Tunda; evaluasi setelah A1–A11 stabil; catat risiko izin dan baterai.
- **Prioritas:** Rendah.

### A17. Online validation / galeri spesifikasi komunitas (CPU-Z database) — TIDAK direkomendasikan

- **Temuan:** CPU-Z menyimpan spesifikasi ke database online (butuh internet + sisi server).
- **Tujuan:** (dicatat sebagai referensi pola) berbagi/bandingkan spesifikasi dengan komunitas.
- **Referensi:** [CPU-Z](https://play.google.com/store/apps/details?id=com.cpuid.cpu_z)
- **Saran:** Jangan diimplementasikan untuk Spektra versi awal — bertentangan dengan lokal-first; tautan "validasi online" hanya relevan bila Spektra nanti punya backend (belum ada).
- **Prioritas:** Rendah (ditolak untuk lingkup sekarang).

---

## B. Optimasi Fitur Eksisting

Fitur eksisting Spektra: navigasi empat tab + `IndexedStack`, mode tema (terang/gelap/sistem) dengan persistensi, tema Material 3, `ProviderScope`. Tidak ada fitur produk yang bisa "dioptimalkan" selain kerangka tersebut; optimasi berikut diarahkan ke sana.

### B1. Tab Dashboard masih template counter — ganti dengan dashboard spesifikasi

- **Temuan:** Tab Dashboard memuat antarmuka counter bawaan template (`README.md`); seluruh kompetitor memakai dashboard ringkasan perangkat sebagai halaman depan.
- **Tujuan:** Menghilangkan sisa template; halaman depan langsung bernilai bagi pengguna.
- **Referensi:** [DevCheck](https://play.google.com/store/apps/details?id=flar2.devcheck), [Castro](https://play.google.com/store/apps/details?id=com.itemstudio.castro)
- **Saran:** Implementasikan A1 di sini; hapus widget counter; pertahankan `IndexedStack`.
- **Prioritas:** Tinggi.

### B2. Tab Biodata/Impian placeholder — selaraskan dengan produk atau jadikan empty state

- **Temuan:** Tab Biodata dan Impian menampilkan placeholder teks; nama tab tidak cocok dengan produk info perangkat; pola empty state kompetitor/startup menunjukkan kerangka section lebih baik daripada teks placeholder.
- **Tujuan:** Menghindari kebingungan pengguna; konsistensi nama tab dengan visi produk.
- **Referensi:** [Device Watch](https://f-droid.org/packages/org.jarsi.devicewatch/) (tabbed dashboard Home/Apps/Device/Settings), [ytheekshana](https://play.google.com/store/apps/details?id=com.ytheekshana.deviceinfo)
- **Saran:** Usulan (perlu persetujuan pengguna, menyentuh kode): ganti nama tab menjadi mis. Dashboard / Perangkat / Diagnostik / Pengaturan; placeholder memakai pola empty state (ikon + judul + deskripsi + CTA), bukan teks telanjang. Jangan dikerjakan tanpa persetujuan.
- **Prioritas:** Sedang.

### B3. Tema: tambahkan dynamic color (Material You) mengikuti sistem

- **Temuan:** Athena, Device Watch, ytheekshana memakai Material You/dynamic color; Spektra sudah Material 3 tapi `ColorScheme.fromSeed(seedColor: Colors.deepPurple)` statis.
- **Tujuan:** Tema terasa modern dan mengikuti perangkat pengguna tanpa usaha tambahan.
- **Referensi:** [Athena](https://f-droid.org/packages/dev.sebaubuntu.athena/), [Device Watch](https://f-droid.org/packages/org.jarsi.devicewatch/), [Device Info: System & CPU Info (ytheekshana)](https://play.google.com/store/apps/details?id=com.ytheekshana.deviceinfo)
- **Saran:** Pakai `ColorScheme.fromSeed` + `useMaterial3` tetap; opsional `dynamic_color` package bila pengguna menginginkan; pertahankan mode tema eksisting; verifikasi kontras teks pada kedua skema.
- **Prioritas:** Sedang.

### B4. Empty/error state seragam untuk data tidak tersedia (tampilkan `—`, jangan mengarang)

- **Temuan:** Device Watch menampilkan dash `—` saat nilai tidak tersedia dan tidak mengarang data; pembacaan sensor/suhu sering kosong di perangkat tertentu (AIDA64/thermal: "No Thermal Data").
- **Tujuan:** Kepercayaan pengguna; mencegah angka palsu (terkait aturan validasi data proyek).
- **Referensi:** [Device Watch](https://f-droid.org/packages/org.jarsi.devicewatch/), [AIDA64](https://play.google.com/store/apps/details?id=com.finalwire.aida64)
- **Saran:** Buat komponen bersama state data tidak tersedia (ikon + teks `—` + alasan); dipakai di seluruh layar info; jangan pernah isi nilai contoh/karangan saat pembacaan gagal.
- **Prioritas:** Sedang.

### B5. Pull-to-refresh + kerangka loading untuk data realtime

- **Temuan:** Device Watch menyediakan pull-to-refresh di setiap halaman; loading state jelas; kompetitor lain memakai indikator progres.
- **Tujuan:** UX data realtime/manual refresh yang konsisten; melengkapi rencana diskusi_2 (refresh manual).
- **Referensi:** [Device Watch](https://f-droid.org/packages/org.jarsi.devicewatch/)
- **Saran:** `RefreshIndicator` pada halaman info; skeleton/placeholder saat memuat; setelah refresh, tampilkan waktu pembaruan terakhir.
- **Prioritas:** Sedang.

### B6. Nama tab "Lainnya" → "Pengaturan"

- **Temuan:** Konten tab "Lainnya" adalah `PengaturanScreen`; label sekarang ambigu.
- **Tujuan:** Kejelasan navigasi.
- **Referensi:** [Device Watch](https://f-droid.org/packages/org.jarsi.devicewatch/) (tab Settings bernama jelas)
- **Saran:** Ganti label/ikon tab menjadi Pengaturan (ikon `settings`); sepele, perlu persetujuan (menyentuh kode).
- **Prioritas:** Rendah.

### B7. Ekspor tema/preferensi tema — tidak perlu

- **Temuan:** Fitur ekspor tidak relevan untuk preferensi tema; produsen tidak melakukannya.
- **Tujuan:** (dicatat agar tidak dikerjakan)
- **Referensi:** —
- **Saran:** Lewati.
- **Prioritas:** Rendah (diabaikan).

---

## C. UI/UX & Layout

### C1. Pola layout utama: dashboard di depan + detail per kategori (kartu/section)

- **Temuan:** Tiga pola dominan di 10 APK: (a) **tab per kategori** (DevCheck Dashboard/Hardware/System/Battery/Network/Sensors; CPU-Z Device/System/Battery/Thermal/Sensor; Droid Hardware Info 8 tab geser), (b) **tree view** (Athena: 28 section berpohon, Material 3, statis), (c) **dashboard jendela + grafik** (Castro, ytheekshana: kartu & grafik realtime). Semuanya menaruh ringkasan di depan; berbeda di kedalaman detail.
- **Tujuan:** Menentukan kerangka navigasi Spektra yang familiar bagi pengguna sekaligus sesuai skala aplikasi (awal).
- **Referensi:** [DevCheck](https://play.google.com/store/apps/details?id=flar2.devcheck), [CPU-Z](https://play.google.com/store/apps/details?id=com.cpuid.cpu_z), [Athena](https://f-droid.org/packages/dev.sebaubuntu.athena/), [Castro](https://play.google.com/store/apps/details?id=com.itemstudio.castro), [Device Info: System & CPU Info (ytheekshana)](https://play.google.com/store/apps/details?id=com.ytheekshana.deviceinfo)
- **Saran:** Gunakan pola **dashboard (A1) + halaman detail per kategori dengan kartu/section** (bukan tree Athena — terlalu padat untuk realtime, bukan daftar label–nilai murni — terlalu kaku); navigasi bawah 4 tab tetap; menu detail sebagai layar push, bukan tab baru.
- **Prioritas:** Tinggi.

### C2. Alur diagnostik: menu grid ikon besar → tes interaktif → hasil per item (+ ringkasan)

- **Temuan:** Test Your Android memakai grid ikon besar dan tes interaktif per komponen; ytheekshana "Hardware Tests" daftar tes yang dieksekusi terpisah; keduanya **tidak** menyediakan ringkasan hasil gabungan (keluhan di ulasan). DevCheck/ytheekshana tidak mengumpulkan skor/laporan diagnostik.
- **Tujuan:** Alur tes yang mudah dipahami awam; nilai tambah Spektra = ringkasan akhir "N lulus / M gagal / K tidak tersedia".
- **Referensi:** [Test Your Android](https://play.google.com/store/apps/details?id=hibernate.v2.testyourandroid), [Device Info: System & CPU Info (ytheekshana)](https://play.google.com/store/apps/details?id=com.ytheekshana.deviceinfo), [DevCheck](https://play.google.com/store/apps/details?id=flar2.devcheck)
- **Saran:** Layar "Diagnostik" berupa grid kartu (Layar, Sentuh, Dead Pixel, Speaker, Mikrofon, Getar, Senter, Tombol, Sensor); tiap kartu → layar tes penuh → hasil (lulus/gagal/tidak tersedia); akumulasi ringkasan di layar akhir; simpan riwayat hasil tes (lokal).
- **Prioritas:** Tinggi.

### C3. Kartu ringkas + grafik kecil realtime untuk data yang berubah

- **Temuan:** ytheekshana (grafik RAM/baterai/frekuensi), Castro (grafik sensor/beban), Device Watch (battery ring realtime, live traffic, grafik 14 hari) menampilkan angka + grafik mini, bukan angka telanjang.
- **Tujuan:** Memudahkan pemantauan tren, bukan hanya nilai sesaat; nilai persepsi "aplikasi monitoring".
- **Referensi:** [Device Info: System & CPU Info (ytheekshana)](https://play.google.com/store/apps/details?id=com.ytheekshana.deviceinfo), [Castro](https://play.google.com/store/apps/details?id=com.itemstudio.castro), [Device Watch](https://f-droid.org/packages/org.jarsi.devicewatch/)
- **Saran:** Kartu dashboard berisi angka besar (tabular figures) + grafik garis/area kecil (fl_chart atau CustomPaint); baterai & CPU sebagai prioritas grafik; penyimpanan/RAM cukup progres bar.
- **Prioritas:** Sedang.

### C4. Material 3 + dynamic color; dark-mode-aware

- **Temuan:** Athena & Device Watch (Material You), ytheekshana (Material You + dynamic color), DevCheck (tema gelap kuat), CPU-Z (klasik, iklan penuh). Konsistensi Material 3 meningkatkan persepsi kualitas.
- **Tujuan:** Konsistensi visual Spektra (sudah Material 3) dan kenyamanan dark mode.
- **Referensi:** [Athena](https://f-droid.org/packages/dev.sebaubuntu.athena/), [Device Watch](https://f-droid.org/packages/org.jarsi.devicewatch/), [DevCheck](https://play.google.com/store/apps/details?id=flar2.devcheck)
- **Saran:** Satu sumber warna dari `Theme.of(context).colorScheme`; hindari hardcode di luar status semantic; uji kedua brightness; tambah dynamic color bila disetujui (B3).
- **Prioritas:** Sedang.

### C5. Warna status semantic untuk hasil diagnostik

- **Temuan:** Kompetitor memakai hijau/merah/kuning untuk lulus/gagal/peringatan (umum di alat tes; Device Watch memakai `—` untuk tidak tersedia, bukan warna palsu).
- **Tujuan:** Hasil tes terbaca sekilas; aksesibilitas (jangan andalkan warna saja — tambahkan ikon/teks).
- **Referensi:** [Test Your Android](https://play.google.com/store/apps/details?id=hibernate.v2.testyourandroid), [Device Watch](https://f-droid.org/packages/org.jarsi.devicewatch/)
- **Saran:** Hijau = lulus, merah = gagal, kuning/abu = tidak tersedia/peringatan; selalu sertakan ikon + teks; selaraskan dengan aturan warna proyek (hardcode hanya status semantic).
- **Prioritas:** Sedang.

### C6. Navigasi bawah + layar push untuk detail; bukan tab baru per kategori

- **Temuan:** DevCheck/ytheekshana memakai banyak kategori (8–12) — terlalu banyak untuk `NavigationBar` (maks ~5); mereka memakai sub-navigasi di dalam halaman/tab. CPU-Z/Droid Hardware Info cukup 5–8 tab geser.
- **Tujuan:** Navigasi Spektra tetap sederhana saat fitur bertambah.
- **Referensi:** [DevCheck](https://play.google.com/store/apps/details?id=flar2.devcheck), [CPU-Z](https://play.google.com/store/apps/details?id=com.cpuid.cpu_z), [Droid Hardware Info](https://play.google.com/store/apps/details?id=com.inkwired.droidinfo)
- **Saran:** Tab utama: Dashboard / Perangkat / Diagnostik / Pengaturan; isi "Perangkat" berupa daftar section (Sistem, CPU/GPU, Memori/Penyimpanan, Baterai, Layar/Kamera, Sensor, Jaringan, Laporan) yang push ke layar detail; jangan tambah destination tab.
- **Prioritas:** Sedang.

### C7. Ekspor/berbagi sebagai aksi di app bar / FAB layar detail

- **Temuan:** ytheekshana menempatkan ekspor sebagai aksi layar; Athena tombol ekspor JSON; Device Watch export CSV/HTML dari halaman terkait.
- **Tujuan:** Penemuan fitur ekspor tanpa menambah tab.
- **Referensi:** [Device Info: System & CPU Info (ytheekshana)](https://play.google.com/store/apps/details?id=com.ytheekshana.deviceinfo), [Athena](https://f-droid.org/packages/dev.sebaubuntu.athena/), [Device Watch](https://f-droid.org/packages/org.jarsi.devicewatch/)
- **Saran:** Ikon `share`/`download` pada `AppBar` halaman detail + opsi format (Teks/JSON); gunakan share sheet sistem.
- **Prioritas:** Sedang.

### C8. Tampilan info padat ala label–nilai untuk layar spesifikasi

- **Temuan:** Droid Hardware Info/CPU-Z memakai daftar "Label: Nilai" yang padat dan cepat dipindai; cocok untuk puluhan parameter; DevCheck menambahkan ikon & grouping section.
- **Tujuan:** Kepadatan informasi tanpa scroll berlebihan; tetap mudah dipindai.
- **Referensi:** [Droid Hardware Info](https://play.google.com/store/apps/details?id=com.inkwired.droidinfo), [CPU-Z](https://play.google.com/store/apps/details?id=com.cpuid.cpu_z), [DevCheck](https://play.google.com/store/apps/details?id=flar2.devcheck)
- **Saran:** `ListTile` dense dua-kolom logis (label abu + nilai) dikelompokkan per section dengan header kecil; hindari card per baris (terlalu berat); grup dengan `Divider`/spacing skala proyek.
- **Prioritas:** Sedang.

### C9. Anti-pola yang dihindari

- **Temuan:** CPU-Z (iklan layar penuh mengganggu; rating 3,5★), Test Your Android (iklan dilaporkan intrusif; butuh banyak izin sekaligus di awal), DevCheck (fitur inti dikunci Pro; overlay sering terbunuh penghemat baterai), AIDA64 (ikonik tapi statis; iklan), Athena (statis, tanpa realtime).
- **Tujuan:** Belajar dari kegagalan kompetitor.
- **Referensi:** [CPU-Z](https://play.google.com/store/apps/details?id=com.cpuid.cpu_z), [Test Your Android](https://play.google.com/store/apps/details?id=hibernate.v2.testyourandroid), [AIDA64](https://play.google.com/store/apps/details?id=com.finalwire.aida64), [Athena](https://f-droid.org/packages/dev.sebaubuntu.athena/)
- **Saran:** Tanpa iklan di Spektra; minta izin hanya saat fitur terkait dipakai; fitur inti tidak dikunci paywall (belum ada model bisnis); jangan mengandalkan overlay sebagai fitur utama; jangan tampilkan data karangan.
- **Prioritas:** Tinggi (sebagai rambu).

### C10. Widget & floating overlay (akses sekilas)

- **Temuan:** Device Watch (widget resizeable + QS tile + floating figure), ytheekshana (widget Material You + overlay), DevCheck Pro, Castro Pro (widget).
- **Tujuan:** Akses metrik tanpa membuka aplikasi.
- **Referensi:** [Device Watch](https://f-droid.org/packages/org.jarsi.devicewatch/), [Device Info: System & CPU Info (ytheekshana)](https://play.google.com/store/apps/details?id=com.ytheekshana.deviceinfo), [Castro](https://play.google.com/store/apps/details?id=com.itemstudio.castro)
- **Saran:** Lihat A10/A16 — tunda; mulai dari widget kecil bila dipilih; overlay tidak diprioritaskan.
- **Prioritas:** Rendah.

---

## D. Katalog 10 APK yang Dianalisa

| Nama Aplikasi | Store | Ringkasan relevansi | Link | Status Analisa |
|---|---|---|---|---|
| DevCheck Device & System Info | Google Play Store | Dashboard realtime, spesifikasi lengkap, benchmark, diagnostik, widget/overlay (Pro) | [Buka Aplikasi](https://play.google.com/store/apps/details?id=flar2.devcheck) | Sudah Dianalisa |
| AIDA64 | Google Play Store | Info sistem mendalam (CPU/GPU/OpenGL/sensor/Wi-Fi), modul Wear OS | [Buka Aplikasi](https://play.google.com/store/apps/details?id=com.finalwire.aida64) | Sudah Dianalisa |
| CPU-Z | Google Play Store | Info SoC/baterai/sensor klasik, online validation | [Buka Aplikasi](https://play.google.com/store/apps/details?id=com.cpuid.cpu_z) | Sudah Dianalisa |
| Device Info HW | Google Play Store | Detail komponen (LCD/PMIC/driver/codec), tema gelap, database perangkat | [Buka Aplikasi](https://play.google.com/store/apps/details?id=ru.andr7e.deviceinfohw) | Sudah Dianalisa |
| Droid Hardware Info | Google Play Store | Info per kategori + ekspor laporan; realtime CPU/sensor | [Buka Aplikasi](https://play.google.com/store/apps/details?id=com.inkwired.droidinfo) | Sudah Dianalisa |
| Test Your Android | Google Play Store | 35+ tes hardware interaktif (layar/audio/sensor/kamera) | [Buka Aplikasi](https://play.google.com/store/apps/details?id=hibernate.v2.testyourandroid) | Sudah Dianalisa |
| Device Info: System & CPU Info (ytheekshana) | Google Play Store | Info lengkap + realtime + tes + Wi-Fi analyzer + ekspor Teks/PDF, Material You | [Buka Aplikasi](https://play.google.com/store/apps/details?id=com.ytheekshana.deviceinfo) | Sudah Dianalisa |
| Athena | F-Droid | 28 section info, tree view, Material 3, ekspor JSON, open source | [Buka Aplikasi](https://f-droid.org/packages/dev.sebaubuntu.athena/) | Sudah Dianalisa |
| Device Watch | F-Droid | Dashboard tabbed realtime, widget resizeable, history baterai 14 hari, CSV/HTML export, offline | [Buka Aplikasi](https://f-droid.org/packages/org.jarsi.devicewatch/) | Sudah Dianalisa |
| Castro | Google Play Store | Dashboard + grafik realtime, sensor, ekspor, tool (screen tester, noise checker) | [Buka Aplikasi](https://play.google.com/store/apps/details?id=com.itemstudio.castro) | Sudah Dianalisa |

Total listing di `apk_kompetitor.md`: 209; dianalisa: 10; tersisa `Belum Dianalisa`: 199.

---

## E. Prioritas Gabungan

| Item | Jenis | Prioritas |
|---|---|---|
| A1 Dashboard spesifikasi perangkat | Fitur baru | Tinggi |
| A2 Info baterai + grafik arus | Fitur baru | Tinggi |
| A3 Info CPU/SoC & GPU realtime | Fitur baru | Tinggi |
| A4 Tes diagnostik komponen interaktif | Fitur baru | Tinggi |
| A5 Info memori & penyimpanan | Fitur baru | Tinggi |
| B1 Tab Dashboard → spesifikasi | Optimasi | Tinggi |
| C1 Layout dashboard + detail per kategori | UI/UX | Tinggi |
| C2 Alur diagnostik grid → tes → ringkasan | UI/UX | Tinggi |
| C9 Anti-pola (iklan/izin/paywall/overlay) | UI/UX | Tinggi |
| B2 Tab Biodata/Impian → empty state/produk | Optimasi | Sedang |
| B3 Dynamic color Material You | Optimasi | Sedang |
| B4 Empty/error state `—` tanpa mengarang | Optimasi | Sedang |
| B5 Pull-to-refresh + loading | Optimasi | Sedang |
| A6 Info sistem/OS (kernel/patch/root) | Fitur baru | Sedang |
| A7 Monitoring sensor realtime | Fitur baru | Sedang |
| A8 Ekspor Teks/PDF/JSON | Fitur baru | Sedang |
| A9 Riwayat baterai 14 hari + CSV | Fitur baru | Sedang |
| A10 Widget layar utama | Fitur baru | Sedang |
| A11 Thermal monitor + alarm | Fitur baru | Sedang |
| C3 Kartu angka + grafik mini realtime | UI/UX | Sedang |
| C4 Material 3 / dynamic color | UI/UX | Sedang |
| C5 Warna status semantic | UI/UX | Sedang |
| C6 Navigasi bawah + layar push detail | UI/UX | Sedang |
| C7 Ekspor sebagai aksi AppBar/share | UI/UX | Sedang |
| C8 Layout label–nilai padat | UI/UX | Sedang |
| A12 Info jaringan Wi-Fi/seluler | Fitur baru | Rendah |
| A13 Alat jaringan lanjutan (referensi) | Fitur baru | Rendah |
| A14 Benchmark CPU/GPU (referensi) | Fitur baru | Rendah |
| A15 Info kamera & codec | Fitur baru | Rendah |
| A16 Floating overlay monitor (referensi) | Fitur baru | Rendah |
| A17 Online validation (ditolak) | Fitur baru | Rendah |
| B6 "Lainnya" → "Pengaturan" | Optimasi | Rendah |
| B7 Ekspor tema/preferensi (diabaikan) | Optimasi | Rendah |
| C10 Widget & overlay akses sekilas | UI/UX | Rendah |

Urutan eksekusi yang disarankan (bila disetujui pengguna): B1 → A1 → A5 → A3 → A2 (selaras diskusi_2) → C6 → C1/C2/C9 → A4 → A6/A7/A8 → sisa prioritas Sedang → prioritas Rendah.

---

## F. Verifikasi & Keterbatasan

- **Verifikasi link:** ke-10 link diuji `curl` dengan User-Agent Chrome pada 2026-11-14 02:34 WIB — **HTTP 200** seluruhnya (Play Store, F-Droid).
- **Isi fitur:** Play Store sering membatasi isi via curl; detail fitur/rating/unduhan diperoleh via `webfetch` halaman store + `websearch` pihak ketiga (AppBrain/Chrome-Stats/review) + halaman/repositori resmi (`github.com/SebaUbuntu/Athena`, `github.com/jrs8205/Device-Watch`, `deviceinfohw.ru`, `devcheck.app`). Klasifikasi: **terverifikasi** untuk Athena & Device Watch (F-Droid + README GitHub terbaca) dan **verifikasi ringan–sedang** untuk aplikasi Play Store (halaman terbaca sebagian; angka unduhan/rating bervariasi antar sumber dan waktu — dicantumkan apa adanya, bukan angka presisi).
- **Yang TIDAK dianalisa:** sisa 199 listing (mis. benchmark Geekbench/AnTuTu, baterai iOS, diagnostik iOS) — di luar perintah pengguna (10 APK saja).
- **Tidak mengarang:** detail yang tidak ditemukan ditandai "tidak ditemukan" oleh peneliti; tidak ada angka/nilai yang dikarang. Rating Test Your Android bervariasi antar sumber (4,8★ halaman store vs ~3,9★ sumber pihak ketiga) — dicatat apa adanya.
- **Keterbatasan:** tidak ada screenshot yang direproduksi langsung di dokumen ini; analisis UI/UX berbasis deskripsi store, review, dan README; detail presisi layout perlu validasi visual (mis. via instalasi di perangkat) bila pengguna menginginkan.
- **Relevansi Spektra:** Spektra belum mengimplementasikan fitur apa pun; seluruh rekomendasi membutuhkan keputusan produk + implementasi terpisah; Spektra lokal-first — rekomendasi berbasis backend/akun tidak tersedia (A17 ditolak).
- **Temuan cacat kode:** tidak ada kode yang diubah/dianalisa pada tugas riset ini; temuan yang menyangkut kode (mis. B1/B2) didokumentasikan di sini, bukan diperbaiki.

## G. Sumber

- 10 listing di `apk_kompetitor.md` (Google Play Store, F-Droid) — lihat seksi D.
- [Athena — GitHub](https://github.com/SebaUbuntu/Athena) (README, lisensi Apache 2.0)
- [Device Watch — GitHub](https://github.com/jrs8205/Device-Watch) (README, Jetpack Compose, Material 3)
- [DevCheck — situs resmi](https://www.devcheck.app/) (devcheck.app)
- [Device Info HW — situs resmi](https://www.deviceinfohw.ru/) (database perangkat)
- [CPU-Z — CPUID](https://www.cpuid.com/softwares/cpu-z.html)
- [AIDA64 — FinalWire](https://www.aida64.com/downloads/aida64-for-android)
- Sumber pihak ketiga untuk rating/unduhan: AppBrain, Chrome-Stats, review Play Store (angka bervariasi, lihat seksi F).
- Konteks proyek: `README.md`, `AGENTS.md`, `apk_kompetitor.md`, `hasil_diskusi/diskusi_2.md`, `keluhan.md`, `MEMORI.md`.
