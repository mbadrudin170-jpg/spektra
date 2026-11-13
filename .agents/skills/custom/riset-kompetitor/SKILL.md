---
name: riset-kompetitor
description: "Trigger: saat menambah atau memperbarui apk_kompetitor.md atau mencari referensi APK belum dianalisa | Panduan riset kompetitor: daftar store, verifikasi link (curl/iTunes lookup), format tabel apk_kompetitor.md, laporan refrensi_apk.md."
metadata:
  kategori: "custom"
  versi: "1.4.2"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Riset Kompetitor Aplikasi Berhenti Merokok

Mengumpulkan dan mendokumentasikan daftar aplikasi kompetitor (serupa) untuk analisis fitur, positioning, dan celah pasar. Hasil riset disimpan dalam format tabel standar di `apk_kompetitor.md` untuk referensi tim dan stakeholder. Tugas lanjutan analisa referensi (mis. perintah `.kilo/commands/riset_kompetitor.md`) menghasilkan dokumen analisis mendalam `refrensi_apk.md` (bukan daftar baru). **Lingkup analisa hanya APK yang terdaftar di `apk_kompetitor.md` dan berstatus `Belum Dianalisa`** (kolom `Status Analisa`); listing `Sudah Dianalisa` tidak dianalisa ulang kecuali diminta eksplisit. Setelah analisa selesai per APK, status pada baris tersebut diubah menjadi `Sudah Dianalisa`.

## Cakupan yang Di-Cover

- Package: `tidak ada` (dokumentasi non-kode)
- File: `apk_kompetitor.md` (root proyek) — katalog daftar aplikasi per store dengan **kolom `Status Analisa` per baris** (nilai: `Belum Dianalisa` / `Sudah Dianalisa`) sebagai penanda listing yang sudah/belum dianalisa fitur-fiturnya
- File: `refrensi_apk.md` (root proyek) — laporan referensi mendalam dari seluruh APK di `apk_kompetitor.md`
- Perintah terkait: `.kilo/commands/cari_apk_kompetitor.md` untuk menambah listing baru; `.kilo/commands/riset_kompetitor.md` untuk analisa fitur dari seluruh APK terdaftar
- File wajib dibaca sebelum mengerjakan tugas riset: `README.md`, `AGENTS.md`, `apk_kompetitor.md`
- Kolom tabel: `Nama Aplikasi`, `Ringkasan Singkat`, `Store`, `Link`, `Status Analisa`
- Struktur `refrensi_apk.md`: informasi riset + cara membaca → ringkasan temuan terbesar → kondisi fitur aktual proyek → A. Rekomendasi fitur baru → B. Optimasi fitur eksisting → C. UI/UX & Layout → D. Katalog semua listing → E. Prioritas gabungan → F. Verifikasi & keterbatasan → G. Sumber
- Store yang didukung: Google Play Store, Apple App Store, F-Droid, GitHub, Samsung Galaxy Store, Uptodown, IzzyOnDroid, Amazon Appstore, APKPure, Aptoide, SlideME, Tencent MyApp, Huawei AppGallery
- Toko yang sering memblokir/menyulitkan akses langsung (Xiaomi GetApps, Oppo App Market, Vivo App Store, Huawei AppGallery, Baidu Mobile Assistant): hanya sertakan aplikasi bila link halaman aplikasi spesifik dapat diverifikasi.
- Kategori relevansi: pelacakan progres, penghematan uang, milestone kesehatan, mode tapering, diary craving, SOS craving, lencana/badge, widget, komunitas, CBT/AI coach, offline-first, backup/restore, gamifikasi

## Aturan

1. Setiap aplikasi **wajib** memiliki nama, ringkasan singkat (maks 2-3 kalimat), nama store/sumber, link yang valid, dan **kolom `Status Analisa`** (nilai: `Belum Dianalisa` atau `Sudah Dianalisa`).
2. Ringkasan singkat **wajib** menyebutkan fitur-fitur utama yang relevan dengan proyek ini (smoke-free tracking, savings, milestones, tapering, craving diary, badges, widgets, community, CBT, offline-first, dll).
3. Format tabel **wajib** mengikuti standar Markdown pipe (`| Kolom 1 | Kolom 2 | ... |`) dengan header dan separator baris kedua (`| --- | --- | ... |`).
4. Aplikasi dari store yang sama **dikelompokkan** secara berurutan (Google Play → Apple App Store → F-Droid → GitHub → Lainnya).
5. Duplikat nama aplikasi di store berbeda **diperbolehkan** (mis. Kwit di Play Store dan App Store) dengan baris terpisah.
6. Link **wajib** mengarah ke halaman resmi store/repositori (bukan pencarian umum), gunakan format `[Buka Aplikasi](url)`, `[Buka Repositori](url)`, `[Unduh APK](url)`, atau `[Cari Aplikasi](url)` sesuai jenis store.
7. Setiap penambahan/perubahan **wajib** di-commit dengan pesan `docs: ...` dan referensi ke skill ini.
8. **Wajib** verifikasi link masih aktif sebelum commit (cek manual atau otomatis).
9. Untuk riset massal lintas-store, delegasikan pencarian per-store ke subagen paralel, lalu **gabungkan dan verifikasi ulang secara independen** (subagen terbukti dapat mengarang link detail yang 404). Jangan percaya temuan subagen tanpa probe ulang.
10. Verifikasi otomatis dengan: `curl -s -o /dev/null -w "%{http_code}" -A "Mozilla/5.0 (X11; Linux x86_64) Chrome/120.0" -L <url>`. HTTP **200** = valid; HTTP **404** = buang entri; HTTP **403** dari APKPure/Aptoide/SlideME = anti-bot (bukan link mati) — verifikasi via websearch/webfetch, jangan dibuang otomatis.
11. Untuk id aplikasi Apple App Store, gunakan lookup `https://itunes.apple.com/lookup?id=<id>`; `resultCount: 0` berarti aplikasi tidak ada dan **tidak boleh** disertakan. Link per-region (`us`/`gb`/`id`/dst.) boleh dipakai bila mengembalikan 200.
12. Aplikasi Tionghoa/Regional tanpa link halaman aplikasi spesifik yang terverifikasi (mis. 戒烟军团, 今日抽烟, 自律戒烟, 戒烟小目标, 决心戒烟) **tidak boleh** disertakan; keberadaan di store saja (dari sumber sekunder) tidak cukup.
13. Periksa duplikat exact berdasarkan `package id` sebelum menambah baris (mis. `com.siwooeo.quitday` dan `com.siwooeo.quitsmoke` di Samsung Galaxy Store sudah tercatat sebagai QuitDay/QuitSave).
14. Untuk batch besar, tambahkan section `# Tambahan Riset (YYYY-MM-DD)` dengan sub-section `## <Store>`; setiap tabel tetap wajib punya header + separator (tabel yang kehilangan header rusak saat dirender).
15. Untuk tugas "mencarikan referensi dari seluruh APK di `apk_kompetitor.md`": baca `README.md`, `AGENTS.md`, dan `apk_kompetitor.md` lebih dulu; **lingkup hanya APK yang terdaftar di `apk_kompetitor.md`** — jangan menambah aplikasi baru ke daftar tanpa perintah eksplisit. Hasil ditulis/diperbarui di `refrensi_apk.md`.
16. `refrensi_apk.md` wajib memuat: link referensi pada tiap rekomendasi, pengelompokan per fitur (A), optimasi fitur eksisting (B), dan UI/UX/layout (C), penjelasan **tujuan** tiap item, serta **prioritas** (Tinggi/Sedang/Rendah) untuk penyortiran pengguna. Pengguna menyortir sendiri; dokumen ini riset pembanding, bukan keputusan implementasi.
17. Untuk `refrensi_apk.md`: hanya rekomendasikan fitur yang dapat berjalan di mobile. Fitur khusus iOS (Apple Watch, Live Activities, WidgetKit, Wear-only tanpa padanan Android) dicatat sebagai referensi pola saja, bukan rekomendasi. Fitur yang butuh backend/akun (AI coach, komunitas) ditandai jelas dan ditempatkan pada prioritas rendah; proyek ini offline-first.
18. Klasifikasikan status verifikasi listing dengan tiga tingkat: **terverifikasi** (halaman/README/mirror terbaca, atau iTunes `resultCount > 0`, atau curl 200 dengan isi terbaca), **verifikasi ringan** (Samsung Galaxy Store: curl 200 tetapi hanya judul halaman tampil, atau Amazon Appstore tanpa isi detail — cukup untuk ketersediaan, tidak cukup untuk rekomendasi fitur), **tidak terverifikasi** (HTTP 404, 403 tanpa sumber alternatif, halaman kosong, atau listing tidak ditemukan). Cantumkan jumlah perkiraan ("sekitar N dari 159") karena tidak semua listing bisa dibaca; listing tidak terverifikasi (Breev, Quit Smoking Tracker: Stop it App Store, ZeroSmoke, Smoker Reducer, QuitSM SlideME, Flamy Aptoide) tidak dijadikan dasar rekomendasi.
19. Uptodown bisa berputar antara HTTP 410 dan 404 untuk URL yang sama — treat sebagai flaky/rotasi; tandai tidak terverifikasi kecuali ada mirror resmi yang menyebut package id sama (mis. `com.despdev.quitsmoking` di Play Store). Smoke Reducer (`com.java.SmokeReducer`) hanya tersedia sebagai arsip IzzyOnDroid, bukan listing eksak.
20. Temuan cacat kode yang ditemukan saat riset (mis. `buatCadanganJson()` hanya menulis 4 dari 6 tabel yang terdaftar pada `tabelCadangan`) **didokumentasikan di `refrensi_apk.md` dengan prioritas dan path file, tidak diperbaiki** sebagai bagian dari tugas riset. Perbaikan kode adalah tugas terpisah.
21. Sebelum memperbarui `refrensi_apk.md`, periksa `git diff` working tree/staged — jangan menimpa, membangkitkan kembali, atau menggabungkan ulang bagian yang sudah dihapus pengguna (mis. usulan fitur yang dibatalkan); hilangkan pula tautan ke dokumen yang sudah dihapus (mis. `prd/*.md` yang dihapus) dari teks referensi.
22. Amazon Appstore dan Samsung Galaxy Store dapat mengembalikan HTTP 200 langsung pada curl dengan user agent Chrome; Galaxy Store tetap hanya menampilkan judul halaman, sehingga tetap diklasifikasi **verifikasi ringan**. APKPure/Aptoide/SlideME tetap 403 (anti-bot) — verifikasi via websearch/webfetch, bukan dibuang otomatis.
23. Untuk perintah `.kilo/commands/riset_kompetitor.md` (analisa fitur dari APK di `apk_kompetitor.md`, hasil ditulis ke `refrensi_apk.md`): **hanya boleh meriset/menganalisa APK yang `Status Analisa = Belum Dianalisa`**. APK berstatus `Sudah Dianalisa` **wajib dilewati** dan tidak dianalisa ulang kecuali pengguna secara eksplisit meminta analisa ulang (kembalikan status ke `Belum Dianalisa` terlebih dahulu). Setelah analisa selesai **per APK**, **wajib** mengubah `Status Analisa` pada baris tabel APK tersebut menjadi `Sudah Dianalisa`. Hanya perintah ini yang boleh mengubah status menjadi `Sudah Dianalisa`.
24. Untuk perintah `.kilo/commands/cari_apk_kompetitor.md` (menambah listing baru ke `apk_kompetitor.md`): listing yang baru ditambahkan **wajib** diberi `Status Analisa = Belum Dianalisa`. Perintah ini **TIDAK BOLEH** menandai listing sebagai `Sudah Dianalisa`.
25. Saat menjalankan perintah referensi/analisa (`riset_kompetitor.md`), filter dan proses hanya baris dengan `Status Analisa = Belum Dianalisa` di `apk_kompetitor.md`; jangan memperluas lingkup ke sumber lain. `refrensi_apk.md` tetap memuat katalog lengkap (seksi D) — perbarui hanya bagian yang terdampak oleh listing yang baru dianalisa, jangan tulis ulang dari nol kecuali diminta.
26. **Section `# Status Analisa Fitur` di akhir file TIDAK LAGI DIPERLUKAN** — penandaan status analisa kini dilakukan **per baris tabel** via kolom `Status Analisa`. Jangan tambah section status di akhir file.

## Larangan

- DILARANG menambah aplikasi tanpa ringkasan fitur relevan (hanya nama dan link).
- DILARANG menggunakan format tabel non-standar (mis. daftar bullet, JSON, CSV).
- DILARANG mengubah urutan kolom tabel yang sudah ditetapkan.
- DILARANG menghapus aplikasi yang sudah tercatat kecuali aplikasi benar-benar tidak lagi tersedia/tersedia di store resmi.
- DILARANG menyalin ringkasan dari deskripsi store tanpa disesuaikan dengan konteks proyek ini.
- DILARANG menambah kolom baru selain `Status Analisa` tanpa memperbarui skill ini dan seluruh baris tabel.
- DILARANG mempercayai link hasil subagen tanpa verifikasi independen (curl / iTunes lookup / webfetch) sebelum commit.
- DILARANG menyertakan aplikasi hanya dari sumber sekunder (situs agregator) tanpa link halaman aplikasi resmi yang terverifikasi.
- DILARANG menganggap HTTP 403 dari APKPure/Aptoide/SlideME sebagai link mati (itu anti-bot); sebaliknya DILARANG menyertakan link ber-HTTP 404 atau id App Store dengan `resultCount: 0`.
- DILARANG menambah tabel tanpa header/separator, atau menumpuk baris batch riset di bawah tabel yang sudah ada tanpa header baru.
- DILARANG merekomendasikan fitur yang tidak dapat berjalan di mobile (Apple Watch, Live Activities, WidgetKit-only) sebagai rekomendasi utama `refrensi_apk.md`.
- DILARANG menganggap Samsung Galaxy Store HTTP 200 + judul halaman sebagai verifikasi penuh isi fitur; hanya ketersediaan (verifikasi ringan).
- DILARANG memperluas lingkup tugas referensi di luar daftar `apk_kompetitor.md` tanpa perintah eksplisit dari pengguna.
- DILARANG menimpa/membangkitkan kembali bagian `refrensi_apk.md` yang sudah dihapus pengguna, atau menyisakan tautan ke PRD/dokumen yang sudah dihapus, tanpa diminta.
- DILARANG memperbaiki kode aplikasi sebagai bagian dari tugas riset; dokumentasikan temuan dengan path file dan prioritas.
- DILARANG menjadikan listing tidak terverifikasi (atau verifikasi ringan) sebagai dasar rekomendasi fitur atau angka prioritas.
- DILARANG menandai listing sebagai `Sudah Dianalisa` (kolom `Status Analisa`) sebelum analisa benar-benar dijalankan dan didokumentasikan di `refrensi_apk.md` (hanya perintah `riset_kompetitor.md` yang boleh).
- DILARANG menandai listing baru dari `cari_apk_kompetitor.md` sebagai `Sudah Dianalisa` (wajib `Belum Dianalisa`).
- DILARANG menghapus atau memodifikasi kolom `Status Analisa` tanpa melalui perintah yang sah.
- DILARANG membuat section `# Status Analisa Fitur` di akhir file — penandaan status kini per baris tabel.

## Contoh Benar

```markdown
| Nama Aplikasi | Ringkasan Singkat                                                                                                                                                                                 | Store             | Link                                                                                  | Status Analisa     |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------- | ------------------------------------------------------------------------------------- | ------------------ |
| SmokeStop     | Aplikasi berhenti merokok dengan fitur "Savings Goals" yang membiayai target personal dari uang rokok yang dihemat. Relevan dengan fitur impian/target dan progress bar berbasis saldo terkumpul. | Google Play Store | [Buka Aplikasi](https://play.google.com/store/apps/details?id=com.smokestop.tracker)  | Sudah Dianalisa    |
| Kwit          | Aplikasi berhenti merokok berbasis CBT dengan pelacakan progres, penghematan uang, jurnal perjalanan, dan dukungan komunitas. Relevan dengan pelacakan progres, penghematan, dan jurnal craving.  | Google Play Store | [Buka Aplikasi](https://play.google.com/store/apps/details?id=fr.kwit.android)        | Belum Dianalisa    |
| Kwit          | Aplikasi berhenti merokok berbasis CBT dengan pelacakan progres, penghematan uang, jurnal perjalanan, dan dukungan komunitas. Relevan dengan pelacakan progres, penghematan, dan jurnal craving.  | Apple App Store   | [Buka Aplikasi](https://apps.apple.com/gb/app/quit-smoking-for-good-kwit/id525441365) | Belum Dianalisa    |
| TrackLess     | Pelacak kebiasaan offline dan privat dengan timer pantang, milestone kesehatan, dan pencadangan JSON lokal. Relevan dengan pendekatan offline-first dan pemantauan progres smoke-free.            | GitHub            | [Buka Repositori](https://github.com/poorangryman/trackless-public)                   | Sudah Dianalisa    |
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

# Samsung Galaxy Store: curl bisa 200 tetapi hanya judul halaman -> "verifikasi ringan"
curl -s -o /dev/null -w "%{http_code}\n" -L "https://galaxystore.samsung.com/detail/<package>?cntyCd=IDN"
webfetch "https://galaxystore.samsung.com/detail/<package>?cntyCd=IDN"  # baca judul halaman saja
```

Contoh item pada `refrensi_apk.md` (fitur/optimasi/UI-UX diberi tujuan + link + prioritas):

```markdown
#### B1. Ekspor Cadangan Hilangkan Data Konsumsi & Intervensi SOS (bug)

- **Temuan:** `lib/fitur/cadangan/helper/cadangan_helper.dart` — `tabelCadangan`
  mendaftarkan 6 tabel, `buatCadanganJson()` hanya menulis 4 tabel.
- **Tujuan perbaikan:** keamanan data pengguna; konsisten dengan validasi.
- **Referensi:** [Flamy](https://play.google.com/store/apps/details?id=net.offlinefirst.flamy) · [TrackLess](https://github.com/poorangryman/trackless-public)
- **Saran:** tambahkan `konsumsi_rokok` & `sos_intervensi` ke payload ekspor; uji kontrak ekspor↔pulihkan.
- **Prioritas:** Tinggi (integritas data; kerugian senyap).
```

Klasifikasi verifikasi listing:

```text

terverifikasi   -> isi terbaca / iTunes resultCount>0 / mirror resmi package id sama
verifikasi ringan -> Galaxy Store 200 + judul halaman saja; Amazon tanpa isi detail
tidak terverifikasi -> 404/403 tanpa alternatif (Breev, ZeroSmoke, Smoker Reducer,
                      QuitSM SlideME, Flamy Aptoide, Quit Tracker Uptodown 410/404)
```

Contoh penandaan status analisa **per baris tabel** di `apk_kompetitor.md` (setelah menjalankan `riset_kompetitor.md`):

```markdown
| Nama Aplikasi | Ringkasan Singkat | Store | Link | Status Analisa |
| ------------- | ----------------- | ----- | ---- | -------------- |
| SmokeStop     | ...               | Google Play Store | [Buka Aplikasi](...) | Sudah Dianalisa |
| Kwit          | ...               | Google Play Store | [Buka Aplikasi](...) | Belum Dianalisa |
```

**Catatan:** Section `# Status Analisa Fitur` di akhir file **TIDAK LAGI DIPERLUKAN** dan **TIDAK DIBUAT**. Penandaan status analisa kini dilakukan **per baris tabel** via kolom `Status Analisa` (nilai: `Belum Dianalisa` / `Sudah Dianalisa`).

Alur kerja kedua perintah:

```text
cari_apk_kompetitor.md      -> tambah listing baru ke apk_kompetitor.md (Status Analisa: Belum Dianalisa)
riset_kompetitor.md -> analisa fitur APK yang Status Analisa = Belum Dianalisa -> perbarui refrensi_apk.md
                       -> ubah Status Analisa pada baris APK tersebut menjadi: Sudah Dianalisa
```

## Contoh Salah

```markdown
// DILARANG: Ringkasan tidak menyebutkan fitur relevan proyek
| Nama Aplikasi | Ringkasan Singkat | Store | Link | Status Analisa |
| ------------- | ----------------- | ----- | ---- | -------------- |
| SmokeStop | Aplikasi populer untuk berhenti merokok. | Google Play Store | [Buka Aplikasi](https://play.google.com/store/apps/details?id=com.smokestop.tracker) | Belum Dianalisa |

// DILARANG: Format link tidak standar
| QuitNow! | Aplikasi dengan komunitas dan milestone. | Google Play Store | https://play.google.com/store/apps/details?id=com.EAGINsoftware.dejaloYa | Belum Dianalisa |

// DILARANG: Kolom tidak lengkap (hilang Status Analisa)
| EasyQuit | Mode tapering dan statistik. | Google Play Store | [Buka Aplikasi](...) |

// DILARANG: Tabel tidak menggunakan format pipe Markdown

- SmokeFree: Quit smoking slowly - Mode bertahap, notifikasi - Google Play Store - [Link](...)

// DILARANG: Menandai listing baru dari cari_apk_kompetitor.md sebagai Sudah Dianalisa
| Nama Aplikasi | Ringkasan Singkat | Store | Link | Status Analisa |
| ------------- | ----------------- | ----- | ---- | -------------- |
| NewApp | Baru ditambahkan hari ini | Google Play Store | [Buka](...) | Sudah Dianalisa |  // SALAH: wajib Belum Dianalisa

// DILARANG: Mengubah Status Analisa menjadi Sudah Dianalisa tanpa menjalankan riset_kompetitor.md
| SmokeStop | ... | Google Play Store | [Buka](...) | Sudah Dianalisa |  // SALAH: belum dianalisa

// DILARANG: Masih membuat section # Status Analisa Fitur di akhir file
# Status Analisa Fitur (per 2026-11-12)
- Seluruh listing sudah dianalisa.
```

## Sumber Evaluasi

- File: `apk_kompetitor.md` (root proyek), `refrensi_apk.md` (root proyek), `.kilo/commands/riset_kompetitor.md`, `.kilo/commands/cari_apk_kompetitor.md`, `gpt/riset_kompetitor.md`, `gpt/cari_apk_kompetitor.md`
- Commit rujukan: `a6f3020` — Tambah daftar aplikasi berhenti merokok serupa (85+ aplikasi)
- Commit rujukan: `d174c1b` — Revisi instruksi riset aplikasi sejenis
- Commit rujukan: `f6ad391` — Delegasi pencarian aplikasi serupa ke berkas panduan
- Commit rujukan: `3af4f53` — Tambah riset aplikasi serupa lintas-store (delegasi subagen paralel, verifikasi curl/HTTP 200 + iTunes lookup, 403 anti-bot APKPure/Aptoide/SlideME, section `# Tambahan Riset (2026-11-10)`)
- Commit rujukan: `7cb9c64` — Perbarui skill riset-kompetitor dengan pengetahuan riset lintas-store (kerangka ref. aturan-pembuatan-skill); commit ini memperbarui isi skill tetapi menyisakan metadata `commit-terakhir` menunjuk `3af4f53` (dibawa hingga v1.1.0); diperbaiki pada v1.2.0
- Commit rujukan: `b7f455c` — Perbarui refrensi_apk.md: cakupan 159 tautan listing, hasil verifikasi sumber, metodologi verifikasi, dan analisis referensi (dasar struktur `refrensi_apk.md`, aturan 15–21, contoh item B1, klasifikasi verifikasi)
- Catatan sumber langsung (2026-11-10, probe mandiri, belum di-commit pada `refrensi_apk.md`): Samsung Galaxy Store `com.siwooeo.quitday` & `com.siwooeo.quitsmoke` mengembalikan HTTP 200 dengan judul halaman tampil; Quit Tracker Uptodown berubah dari HTTP 410 menjadi 404; Amazon Appstore mengembalikan 200 langsung dengan UA Chrome
- Instruksi langsung pengguna (2026-11-11, belum di-commit): penandaan status analisa dipindah dari section di akhir file ke **kolom `Status Analisa` per baris tabel**; hanya `riset_kompetitor.md` yang boleh mengubah status menjadi `Sudah Dianalisa`; `cari_apk_kompetitor.md` wajib set `Belum Dianalisa` pada listing baru.
- v1.4.0 (2026-11-11): ganti mekanisme penandaan status analisa dari section `# Status Analisa Fitur` (berbasis tanggal) ke **kolom `Status Analisa` per baris tabel** (nilai: `Belum Dianalisa` / `Sudah Dianalisa`); aturan 23–26 diperbarui; larangan kolom status dihapus dan diganti larangan per-row marking; contoh benar/salah diperbarui; section status di akhir file tidak lagi dibuat; metadata `commit-terakhir` diset `belum-ada-commit` karena belum di-commit
- Instruksi langsung pengguna (2026-11-11, belum di-commit): perintah `.kilo/commands/riset_kompetitor.md` hanya boleh meriset APK di `apk_kompetitor.md` yang **belum berstatus `Sudah Dianalisa`** (hanya baris `Status Analisa = Belum Dianalisa`); intro, deskripsi, dan aturan 23/25 diperjelas; versi dinaikkan ke 1.4.1.
