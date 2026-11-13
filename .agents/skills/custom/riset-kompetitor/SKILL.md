---
name: riset-kompetitor
description: "Trigger: saat menambah atau memperbarui apk_kompetitor.md atau mencari aplikasi kompetitor untuk Spektra | Panduan riset kompetitor Spektra: format tabel apk_kompetitor.md, kolom Status Analisa per listing (Belum/Sudah Dianalisa), verifikasi link (curl/iTunes lookup/webfetch), alur satu store per iterasi (Play Store → F-Droid → GitHub → Apple App Store → Samsung/Mi/Oppo/lainnya), dan laporan refrensi_apk.md."
metadata:
  kategori: "custom"
  versi: "1.5.0"
  diperbarui: "Sat Nov 14 2026 01:35:34 WIB"
  sumber-terakhir: "perintah pengguna: tindak lanjut diskusi_3 (kerjakan_hasil_diskusi) — selaraskan skill dari konteks berhenti merokok ke Spektra"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Riset Kompetitor Aplikasi Spektra

Mengumpulkan dan mendokumentasikan daftar aplikasi mobile kompetitor (aplikasi serupa Spektra — aplikasi Android berbasis Flutter untuk informasi spesifikasi perangkat, monitoring kondisi hardware, dan alat diagnostik komponen perangkat; "Know Your Device" sesuai `README.md`). Hasil riset disimpan dalam format tabel standar di `apk_kompetitor.md` untuk referensi tim dan stakeholder. Tugas lanjutan analisa referensi (mis. perintah `.kilo/commands/riset_kompetitor.md`) menghasilkan dokumen analisis mendalam `refrensi_apk.md` (bukan daftar baru). **Lingkup analisa hanya APK yang terdaftar di `apk_kompetitor.md` dan berstatus `Belum Dianalisa`** (kolom `Status Analisa`); listing `Sudah Dianalisa` tidak dianalisa ulang kecuali diminta eksplisit. Setelah analisa selesai per APK, status pada baris tersebut diubah menjadi `Sudah Dianalisa`.

## Cakupan yang Di-Cover

- Package: `tidak ada` (dokumentasi non-kode; proyek Spektra Android-first, Flutter)
- File: `apk_kompetitor.md` (root proyek) — katalog daftar aplikasi per store dengan **kolom `Status Analisa` per baris** (nilai: `Belum Dianalisa` / `Sudah Dianalisa`) sebagai penanda listing yang sudah/belum dianalisa fitur-fiturnya
- File: `refrensi_apk.md` (root proyek) — laporan referensi mendalam dari seluruh APK di `apk_kompetitor.md`
- Perintah terkait: `.kilo/commands/cari_apk_kompetitor.md` untuk menambah listing baru (dengan aturan **satu store per iterasi**); `.kilo/commands/riset_kompetitor.md` untuk analisa fitur dari seluruh APK terdaftar
- File wajib dibaca sebelum mengerjakan tugas riset: `README.md`, `AGENTS.md`, `apk_kompetitor.md` (bila ada)
- Kolom tabel: `Nama Aplikasi`, `Ringkasan Singkat`, `Store`, `Link`, `Status Analisa`
- Struktur `refrensi_apk.md`: informasi riset + cara membaca → ringkasan temuan terbesar → kondisi fitur aktual proyek → A. Rekomendasi fitur baru → B. Optimasi fitur eksisting → C. UI/UX & Layout → D. Katalog semua listing → E. Prioritas gabungan → F. Verifikasi & keterbatasan → G. Sumber
- Store yang didukung: Google Play Store, Apple App Store, F-Droid, GitHub, Samsung Galaxy Store, Uptodown, IzzyOnDroid, Amazon Appstore, APKPure, Aptoide, SlideME, Mi/GetApps, Oppo App Market, Tencent MyApp, Huawei AppGallery
- Toko yang sering memblokir/menyulitkan akses langsung (Xiaomi GetApps, Oppo App Market, Vivo App Store, Huawei AppGallery, Baidu Mobile Assistant): hanya sertakan aplikasi bila link halaman aplikasi spesifik dapat diverifikasi.
- Kategori relevansi: info perangkat & OS (CPU/RAM/GPU/penyimpanan/OS/kernel/build number), info baterai, info layar, sensor (akselerometer, gyro, magnet, cahaya, proximity, tekanan), termal/suhu, benchmark & performa, diagnostik hardware (layar, kamera, audio/speaker/vibrasi, sensor), uji konektivitas jaringan (WiFi/seluler/ping/kecepatan), monitoring realtime, widget info perangkat

## Aturan

1. Setiap aplikasi **wajib** memiliki nama, ringkasan singkat (maks 2-3 kalimat), nama store/sumber, link yang valid, dan **kolom `Status Analisa`** (nilai: `Belum Dianalisa` atau `Sudah Dianalisa`).
2. Ringkasan singkat **wajib** menyebutkan fitur-fitur utama yang relevan dengan Spektra (info perangkat/CPU/RAM/penyimpanan, info baterai, info layar, info OS/kernel, monitoring sensor, diagnostik layar/kamera/audio, uji jaringan, monitoring realtime, benchmark, widget info perangkat), bukan deskripsi umum dari store.
3. Format tabel **wajib** mengikuti standar Markdown pipe (`| Kolom 1 | Kolom 2 | ... |`) dengan header dan separator baris kedua (`| --- | --- | ... |`).
4. Aplikasi dari store yang sama **dikelompokkan** secara berurutan (Google Play → Apple App Store → F-Droid → GitHub → Lainnya).
5. Duplikat nama aplikasi di store berbeda **diperbolehkan** (mis. aplikasi sama di Play Store dan App Store) dengan baris terpisah.
6. Link **wajib** mengarah ke halaman resmi store/repositori (bukan pencarian umum), gunakan format `[Buka Aplikasi](url)`, `[Buka Repositori](url)`, `[Unduh APK](url)`, atau `[Cari Aplikasi](url)` sesuai jenis store.
7. Setiap penambahan/perubahan **wajib** di-commit dengan pesan `docs: ...` dan referensi ke skill ini.
8. **Wajib** verifikasi link masih aktif sebelum commit (cek manual atau otomatis).
9. **Satu store per iterasi.** Eksekusi sesuai `.kilo/commands/cari_apk_kompetitor.md`: mulai dari Google Play Store, setelah seluruh kandidat terverifikasi independen dan `apk_kompetitor.md` diperbarui, baru lanjut ke store berikutnya (**F-Droid → GitHub → Apple App Store → Samsung Galaxy Store → Mi/GetApps → Oppo App Market → store lainnya**). DILARANG meriset semua store sekaligus tanpa memperbarui `apk_kompetitor.md` setelah tiap store. Subagen paralel boleh dipakai untuk mengumpulkan kandidat di dalam satu store, tetapi **verifikasi tetap independen** (curl/iTunes/webfetch).
10. Verifikasi otomatis dengan: `curl -s -o /dev/null -w "%{http_code}" -A "Mozilla/5.0 (X11; Linux x86_64) Chrome/120.0" -L <url>`. HTTP **200** = valid; HTTP **404** = buang entri; HTTP **403** dari APKPure/Aptoide/SlideME = anti-bot (bukan link mati) — verifikasi via websearch/webfetch, jangan dibuang otomatis.
11. Untuk id aplikasi Apple App Store, gunakan lookup `https://itunes.apple.com/lookup?id=<id>`; `resultCount: 0` berarti aplikasi tidak ada dan **tidak boleh** disertakan. Link per-region (`us`/`gb`/`id`/dst.) boleh dipakai bila mengembalikan 200.
12. Aplikasi Tionghoa/Regional tanpa link halaman aplikasi spesifik yang terverifikasi **tidak boleh** disertakan; keberadaan di store saja (dari sumber sekunder) tidak cukup.
13. Periksa duplikat exact berdasarkan `package id` sebelum menambah baris (mis. dua varian aplikasi dengan package id berbeda di store sama tetap dicatat terpisah bila memang dua aplikasi).
14. Untuk batch besar, tambahkan section `# Tambahan Riset (YYYY-MM-DD)` dengan sub-section `## <Store>`; setiap tabel tetap wajib punya header + separator (tabel yang kehilangan header rusak saat dirender).
15. Untuk tugas "mencarikan referensi dari seluruh APK di `apk_kompetitor.md`": baca `README.md`, `AGENTS.md`, dan `apk_kompetitor.md` lebih dulu; **lingkup hanya APK yang terdaftar di `apk_kompetitor.md`** — jangan menambah aplikasi baru ke daftar tanpa perintah eksplisit. Hasil ditulis/diperbarui di `refrensi_apk.md`.
16. `refrensi_apk.md` wajib memuat: link referensi pada tiap rekomendasi, pengelompokan per fitur (A), optimasi fitur eksisting (B), dan UI/UX/layout (C), penjelasan **tujuan** tiap item, serta **prioritas** (Tinggi/Sedang/Rendah) untuk penyortiran pengguna. Pengguna menyortir sendiri; dokumen ini riset pembanding, bukan keputusan implementasi.
17. Untuk `refrensi_apk.md`: hanya rekomendasikan fitur yang dapat berjalan di mobile. Fitur khusus iOS (Apple Watch, Live Activities, WidgetKit, Wear-only tanpa padanan Android) dicatat sebagai referensi pola saja, bukan rekomendasi. Fitur yang butuh backend/akun ditandai jelas dan ditempatkan pada prioritas rendah; Spektra bersifat lokal-first.
18. Klasifikasikan status verifikasi listing dengan tiga tingkat: **terverifikasi** (halaman/README/mirror terbaca, atau iTunes `resultCount > 0`, atau curl 200 dengan isi terbaca), **verifikasi ringan** (Samsung Galaxy Store: curl 200 tetapi hanya judul halaman tampil, atau Amazon Appstore tanpa isi detail — cukup untuk ketersediaan, tidak cukup untuk rekomendasi fitur), **tidak terverifikasi** (HTTP 404, 403 tanpa sumber alternatif, halaman kosong, atau listing tidak ditemukan). Cantumkan jumlah perkiraan ("sekitar N dari M") karena tidak semua listing bisa dibaca; listing tidak terverifikasi tidak dijadikan dasar rekomendasi.
19. Uptodown bisa berputar antara HTTP 410 dan 404 untuk URL yang sama — treat sebagai flaky/rotasi; tandai tidak terverifikasi kecuali ada mirror resmi yang menyebut package id sama.
20. Temuan cacat kode yang ditemukan saat riset didokumentasikan di `refrensi_apk.md` dengan prioritas dan path file, **tidak diperbaiki** sebagai bagian dari tugas riset. Perbaikan kode adalah tugas terpisah.
21. Sebelum memperbarui `refrensi_apk.md`, periksa `git diff` working tree/staged — jangan menimpa, membangkitkan kembali, atau menggabungkan ulang bagian yang sudah dihapus pengguna; hilangkan pula tautan ke dokumen yang sudah dihapus dari teks referensi.
22. Amazon Appstore dan Samsung Galaxy Store dapat mengembalikan HTTP 200 langsung pada curl dengan user agent Chrome; Galaxy Store tetap hanya menampilkan judul halaman, sehingga tetap diklasifikasi **verifikasi ringan**. APKPure/Aptoide/SlideME tetap 403 (anti-bot) — verifikasi via websearch/webfetch, bukan dibuang otomatis.
23. Untuk perintah `.kilo/commands/riset_kompetitor.md` (analisa fitur dari APK di `apk_kompetitor.md`, hasil ditulis ke `refrensi_apk.md`): **hanya boleh meriset/menganalisa APK yang `Status Analisa = Belum Dianalisa`**. APK berstatus `Sudah Dianalisa` **wajib dilewati** dan tidak dianalisa ulang kecuali pengguna secara eksplisit meminta analisa ulang (kembalikan status ke `Belum Dianalisa` terlebih dahulu). Setelah analisa selesai **per APK**, **wajib** mengubah `Status Analisa` pada baris tabel APK tersebut menjadi `Sudah Dianalisa`. Hanya perintah ini yang boleh mengubah status menjadi `Sudah Dianalisa`.
24. Untuk perintah `.kilo/commands/cari_apk_kompetitor.md` (menambah listing baru ke `apk_kompetitor.md`): listing yang baru ditambahkan **wajib** diberi `Status Analisa = Belum Dianalisa`. Perintah ini **TIDAK BOLEH** menandai listing sebagai `Sudah Dianalisa`.
25. Saat menjalankan perintah referensi/analisa (`riset_kompetitor.md`), filter dan proses hanya baris dengan `Status Analisa = Belum Dianalisa` di `apk_kompetitor.md`; jangan memperluas lingkup ke sumber lain. `refrensi_apk.md` tetap memuat katalog lengkap (seksi D) — perbarui hanya bagian yang terdampak oleh listing yang baru dianalisa, jangan tulis ulang dari nol kecuali diminta.
26. **Section `# Status Analisa Fitur` di akhir file TIDAK LAGI DIPERLUKAN** — penandaan status analisa kini dilakukan **per baris tabel** via kolom `Status Analisa`. Jangan tambah section status di akhir file.

## Larangan

- DILARANG menambah aplikasi tanpa ringkasan fitur relevan Spektra (hanya nama dan link).
- DILARANG menggunakan format tabel non-standar (mis. daftar bullet, JSON, CSV).
- DILARANG mengubah urutan kolom tabel yang sudah ditetapkan.
- DILARANG menghapus aplikasi yang sudah tercatat kecuali aplikasi benar-benar tidak lagi tersedia/tersedia di store resmi.
- DILARANG menyalin ringkasan dari deskripsi store tanpa disesuaikan dengan konteks Spektra (info/diagnostik perangkat).
- DILARANG menambah kolom baru selain `Status Analisa` tanpa memperbarui skill ini dan seluruh baris tabel.
- DILARANG mempercayai link hasil subagen tanpa verifikasi independen (curl / iTunes lookup / webfetch) sebelum commit.
- DILARANG menyertakan aplikasi hanya dari sumber sekunder (situs agregator) tanpa link halaman aplikasi resmi yang terverifikasi.
- DILARANG menganggap HTTP 403 dari APKPure/Aptoide/SlideME sebagai link mati (itu anti-bot); sebaliknya DILARANG menyertakan link ber-HTTP 404 atau id App Store dengan `resultCount: 0`.
- DILARANG menambah tabel tanpa header/separator, atau menumpuk baris batch riset di bawah tabel yang sudah ada tanpa header baru.
- DILARANG meriset semua store sekaligus dalam satu iterasi; riset wajib satu store per iterasi (lihat Aturan 9).
- DILARANG merekomendasikan fitur yang tidak dapat berjalan di mobile (Apple Watch, Live Activities, WidgetKit-only) sebagai rekomendasi utama `refrensi_apk.md`.
- DILARANG menganggap Samsung Galaxy Store HTTP 200 + judul halaman sebagai verifikasi penuh isi fitur; hanya ketersediaan (verifikasi ringan).
- DILARANG memperluas lingkup tugas referensi di luar daftar `apk_kompetitor.md` tanpa perintah eksplisit dari pengguna.
- DILARANG menimpa/membangkitkan kembali bagian `refrensi_apk.md` yang sudah dihapus pengguna, atau menyisakan tautan ke dokumen yang sudah dihapus, tanpa diminta.
- DILARANG memperbaiki kode aplikasi sebagai bagian dari tugas riset; dokumentasikan temuan dengan path file dan prioritas.
- DILARANG menjadikan listing tidak terverifikasi (atau verifikasi ringan) sebagai dasar rekomendasi fitur atau angka prioritas.
- DILARANG menandai listing sebagai `Sudah Dianalisa` (kolom `Status Analisa`) sebelum analisa benar-benar dijalankan dan didokumentasikan di `refrensi_apk.md` (hanya perintah `riset_kompetitor.md` yang boleh).
- DILARANG menandai listing baru dari `cari_apk_kompetitor.md` sebagai `Sudah Dianalisa` (wajib `Belum Dianalisa`).
- DILARANG menghapus atau memodifikasi kolom `Status Analisa` tanpa melalui perintah yang sah.
- DILARANG membuat section `# Status Analisa Fitur` di akhir file — penandaan status kini per baris tabel.

## Contoh Benar

Baris berikut hanya ilustrasi format (id aplikasi placeholder, bukan listing nyata):

```markdown
| Nama Aplikasi | Ringkasan Singkat                                                                                                                                  | Store             | Link                                                                                  | Status Analisa     |
| ------------- | -------------------------------------------------------------------------------------------------------------------------------------------- | ----------------- | ------------------------------------------------------------------------------------- | ------------------ |
| DeviceInfo X  | Aplikasi info perangkat dengan detail CPU, RAM, penyimpanan, baterai, dan identitas Android. Relevan dengan fitur info spesifikasi Spektra.  | Google Play Store | [Buka Aplikasi](https://play.google.com/store/apps/details?id=com.contoh.deviceinfox)  | Belum Dianalisa    |
| HardwareMon Y | Monitoring sensor realtime (akselerometer, gyro, cahaya) dan suhu perangkat. Relevan dengan monitoring hardware Spektra.                    | Google Play Store | [Buka Aplikasi](https://play.google.com/store/apps/details?id=com.contoh.hardwaremony) | Belum Dianalisa    |
| SensorLab Z   | Diagnostik layar, kamera, dan audio dengan alat uji sensor. Relevan dengan fitur diagnostik komponen Spektra.                               | GitHub            | [Buka Repositori](https://github.com/contoh/sensorlabz)                                | Sudah Dianalisa    |
```

Contoh verifikasi otomatis sebelum commit (riset massal lintas-store):

```bash
# Google Play / Apple App Store / GitHub / F-Droid (200 = valid, 404 = buang)
for u in "<url1>" "<url2>"; do
  code=$(curl -s -o /dev/null -w "%{http_code}" -A "Mozilla/5.0 (X11; Linux x86_64) Chrome/120.0" --max-time 15 -L "$u"); echo "$code  $u"
done

# App Store: cek keberadaan app (resultCount: 0 = tidak ada, jangan sertakan)
curl -s "https://itunes.apple.com/lookup?id=<app_id>" | head -c 300

# APKPure / Aptoide / SlideME sering 403 (anti-bot, bukan mati) -> verifikasi via websearch/webfetch
```

Contoh item pada `refrensi_apk.md` (fitur/optimasi/UI-UX diberi tujuan + link + prioritas):

```markdown
#### B1. Widget Informasi Baterai pada Layar Utama

- **Temuan:** Spektra belum menampilkan info baterai realtime di luar layar khusus.
- **Tujuan perbaikan:** akses cepat info baterai tanpa membuka aplikasi.
- **Referensi:** [DeviceInfo X](https://play.google.com/store/apps/details?id=com.contoh.deviceinfox)
- **Saran:** tampilkan level baterai + status pengisian pada widget berukuran kecil.
- **Prioritas:** Sedang.
```

Klasifikasi verifikasi listing:

```text
terverifikasi   -> isi terbaca / iTunes resultCount>0 / mirror resmi package id sama
verifikasi ringan -> Galaxy Store 200 + judul halaman saja; Amazon tanpa isi detail
tidak terverifikasi -> 404/403 tanpa alternatif
```

Contoh penandaan status analisa **per baris tabel** di `apk_kompetitor.md` (setelah menjalankan `riset_kompetitor.md`):

```markdown
| Nama Aplikasi | Ringkasan Singkat | Store | Link | Status Analisa |
| ------------- | ----------------- | ----- | ---- | -------------- |
| DeviceInfo X  | ...               | Google Play Store | [Buka Aplikasi](...) | Sudah Dianalisa |
| HardwareMon Y | ...               | Google Play Store | [Buka Aplikasi](...) | Belum Dianalisa |
```

**Catatan:** Section `# Status Analisa Fitur` di akhir file **TIDAK LAGI DIPERLUKAN** dan **TIDAK DIBUAT**. Penandaan status analisa kini dilakukan **per baris tabel** via kolom `Status Analisa` (nilai: `Belum Dianalisa` / `Sudah Dianalisa`).

Alur kerja kedua perintah:

```text
cari_apk_kompetitor.md      -> tambah listing baru ke apk_kompetitor.md (Status Analisa: Belum Dianalisa)
                               (satu store per iterasi: Play Store -> F-Droid -> GitHub -> App Store -> Samsung -> Mi/Oppo -> lainnya)
riset_kompetitor.md -> analisa fitur APK yang Status Analisa = Belum Dianalisa -> perbarui refrensi_apk.md
                       -> ubah Status Analisa pada baris APK tersebut menjadi: Sudah Dianalisa
```

## Contoh Salah

```markdown
// DILARANG: Ringkasan tidak menyebutkan fitur relevan Spektra
| Nama Aplikasi | Ringkasan Singkat | Store | Link | Status Analisa |
| ------------- | ----------------- | ----- | ---- | -------------- |
| DeviceInfo X | Aplikasi populer untuk info perangkat. | Google Play Store | [Buka Aplikasi](https://play.google.com/store/apps/details?id=com.contoh.deviceinfox) | Belum Dianalisa |

// DILARANG: Format link tidak standar
| HardwareMon Y | Monitoring sensor realtime. | Google Play Store | https://play.google.com/store/apps/details?id=com.contoh.hardwaremony | Belum Dianalisa |

// DILARANG: Kolom tidak lengkap (hilang Status Analisa)
| SensorLab Z | Diagnostik layar dan kamera. | Google Play Store | [Buka Aplikasi](...) |

// DILARANG: Tabel tidak menggunakan format pipe Markdown
- DeviceInfo X: info perangkat Android - Google Play Store - [Link](...)

// DILARANG: Menandai listing baru dari cari_apk_kompetitor.md sebagai Sudah Dianalisa
| Nama Aplikasi | Ringkasan Singkat | Store | Link | Status Analisa |
| ------------- | ----------------- | ----- | ---- | -------------- |
| DeviceInfo X | Baru ditambahkan hari ini | Google Play Store | [Buka](...) | Sudah Dianalisa |  // SALAH: wajib Belum Dianalisa

// DILARANG: Mengubah Status Analisa menjadi Sudah Dianalisa tanpa menjalankan riset_kompetitor.md
| DeviceInfo X | ... | Google Play Store | [Buka](...) | Sudah Dianalisa |  // SALAH: belum dianalisa

// DILARANG: Masih membuat section # Status Analisa Fitur di akhir file
# Status Analisa Fitur
- Seluruh listing sudah dianalisa.
```

## Sumber Evaluasi

- File: `apk_kompetitor.md` (root proyek), `refrensi_apk.md` (root proyek), `.kilo/commands/riset_kompetitor.md`, `.kilo/commands/cari_apk_kompetitor.md`
- Referensi produk Spektra: `README.md` (aplikasi Android info/diagnostik perangkat, "Know Your Device")
- Commit rujukan: `a6f3020` — Tambah daftar aplikasi kompetitor serupa (riwayat awal, konteks berhenti merokok)
- Commit rujukan: `3af4f53` — Tambah riset kompetitor lintas-store (section `# Tambahan Riset (2026-11-10)`)
- Commit rujukan: `b7f455c` — Perbarui refrensi_apk.md: cakupan 159 tautan listing, metodologi verifikasi (dasar aturan 18–22)
- v1.5.0 (2026-11-14): penyelarasan konteks skill dari "aplikasi berhenti merokok" ke **Spektra** (perintah pengguna; tindak lanjut `hasil_diskusi/diskusi_3.md` — update skill lama, bukan skill pendamping); judul, intro, kategori relevansi, aturan 2/9 (satu store per iterasi), contoh jujur ilustratif placeholder; mekanisme kolom `Status Analisa`, aturan verifikasi curl/iTunes/webfetch, dan larangan marking dipertahankan tanpa perubahan substansi
- Instruksi langsung pengguna (2026-11-11, belum di-commit saat itu): penandaan status analisa dipindah dari section di akhir file ke **kolom `Status Analisa` per baris tabel**; hanya `riset_kompetitor.md` yang boleh mengubah status menjadi `Sudah Dianalisa`; `cari_apk_kompetitor.md` wajib set `Belum Dianalisa` pada listing baru
- 2026-11-13: keputusan pengguna (`hasil_diskusi/diskusi_3.md`) — acuan riset Spektra = README; riset satu store per iterasi (Play Store → F-Droid → GitHub → App Store → Samsung/Mi/Oppo/lainnya); `apk_kompetitor.md` dibuat baru saat perintah riset dijalankan dengan kerangka section per store
