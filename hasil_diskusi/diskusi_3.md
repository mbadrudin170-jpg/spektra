# Hasil Diskusi 3 — Riset aplikasi serupa Spektra per-store dan pembuatan `apk_kompetitor.md`

## Status
- Dokumen: Final
- Implementasi: Belum Diimplementasikan
- Tanggal: 2026-11-13
- Topik: Riset aplikasi mobile serupa Spektra (info/diagnostik perangkat) di berbagai store (GitHub, F-Droid, Google Play Store, Apple App Store, Samsung Galaxy Store, Mi Store/GetApps, Oppo App Market, dan store lainnya) untuk ditambahkan ke `apk_kompetitor.md`; perintah dijalankan satu store per iterasi (Play Store dulu), bukan sekaligus

## Latar Belakang
Argumen mode diskusi identik dengan isi `.kilo/commands/cari_apk_kompetitor.md` (mencari aplikasi serupa di GitHub, F-Droid, Google Play Store, Apple App Store, Samsung Galaxy Store, Mi Store, Oppo Store, dan store lainnya; hanya aplikasi mobile; sebanyak mungkin; ditambahkan ke `apk_kompetitor.md` dengan kolom `Nama Aplikasi`, `Ringkasan Singkat`, `Store`, `Link`, `Status Analisa` = `Belum Dianalisa`) ditambah instruksi eksplisit pengguna: setiap kali perintah dijalankan, riset dikerjakan **satu per satu store** (bukan sekaligus) — misalnya cari di Play Store dulu, perbarui `apk_kompetitor.md`, lalu lanjut ke store berikutnya.

Fakta yang relevan:

- `apk_kompetitor.md` **tidak ada** di root proyek ini dan tidak pernah ada dalam riwayat git. `.agents/skills/custom/riset-kompetitor/SKILL.md` menyebut berkas tersebut sebagai katalog listing kompetitor beserta kolom `Status Analisa` per baris.
- `README.md` (commit `4e3bc9e`): Spektra adalah aplikasi Android berbasis Flutter untuk menampilkan informasi spesifikasi perangkat, memantau kondisi hardware, dan menyediakan alat diagnostik perangkat ("Know Your Device"). Platform: Android.
- `MEMORI.md`: identitas dan tujuan proyek belum terverifikasi sinkron dengan `lib/`; dokumen `docs/` berisi referensi proyek lain (aplikasi sosial, berhenti merokok) dan dinyatakan belum diverifikasi; MEMORI.md sendiri menandai "Belum diketahui apakah spektra adalah lanjutan, port, atau proyek baru terpisah".
- Skill `riset-kompetitor` tertulis dalam konteks "aplikasi berhenti merokok" (judul, kategori relevansi, acuan `refrensi_apk.md`) sehingga tidak sepenuhnya selaras dengan konteks Spektra, meskipun mekanisme yang dipakai (kolom `Status Analisa`, verifikasi link, format tabel) masih dapat dipakai.
- Aturan 9 skill `riset-kompetitor` (delegasikan pencarian lintas-store ke subagen paralel) **bertentangan** dengan instruksi eksplisit pengguna pada argumen (satu per satu store). Instruksi eksplisit pengguna diprioritaskan; konflik dicatat sebagai tindak lanjut pembaruan skill/perintah.
- `memori/sesi/sesi_2.md` (2026-11-13) mengklaim `apk_kompetitor.md` dibuat lintas-store, tetapi berkasnya tidak ada dan `git` bersih; perubahan tidak dapat diverifikasi. Sesi ini menandai `sesi_2.md` `Sudah Sinkron` (pilihan pengguna) dengan catatan eksplisit; isi sesi_2 tidak dijadikan dasar.
- Working tree tidak bersih sejak sebelum sesi ini (perubahan belum di-commit di `lib/`, `pubspec.*`, `MEMORI.md`, `memori/riwayat_perubahan.md`); sesi ini tidak menyentuh kode.

## Poin Diskusi
### 1. Acuan "aplikasi serupa" mengacu ke produk yang mana?
- Tanya: Riset aplikasi kompetitor pada topik ini ditujukan ke aplikasi mana — Spektra (README) atau aplikasi berhenti merokok (skill/sesi_2/docs)?
- Kesimpulan: **Spektra sesuai `README.md`** — aplikasi Android berbasis Flutter untuk info spesifikasi perangkat, monitoring hardware, dan alat diagnostik ("Know Your Device").

### 2. Cakupan sesi mode diskusi ini
- Tanya: Apakah sesi ini cukup mendiskusikan dan mendokumentasikan keputusan, atau sekaligus menjalankan riset?
- Kesimpulan: **Hanya diskusi + pembuatan `hasil_diskusi/diskusi_3.md`.** Tidak ada riset store yang dijalankan dan `apk_kompetitor.md` belum dibuat.

### 3. Nasib `apk_kompetitor.md`
- Tanya: `apk_kompetitor.md` belum ada di root proyek; apakah dibuat sekarang atau nanti?
- Kesimpulan: **Dibuat baru saat perintah riset dijalankan** (bukan pada sesi diskusi ini), dengan struktur sesuai skill `riset-kompetitor` (section per store, tabel lengkap header+separator, semua listing baru `Status Analisa = Belum Dianalisa`).

### 4. Penanganan catch-up `sesi_2.md`
- Tanya: `sesi_2.md` berstatus `Belum Sinkron` mengklaim `apk_kompetitor.md` dibuat, tetapi berkas tidak ada dan `git` bersih — bagaimana penanganannya?
- Kesimpulan: **Ditandai `Sudah Sinkron`** dengan catatan eksplisit bahwa perubahan tidak dapat diverifikasi dan tidak ada perubahan yang disinkronkan.

### 5. Ritme dan urutan riset lintas-store
- Tanya: Apakah semua store diriset sekaligus atau satu per satu?
- Kesimpulan: **Satu per satu store.** Play Store dulu; setelah hasil satu store terverifikasi dan `apk_kompetitor.md` diperbarui, baru lanjut ke store berikutnya. Bukan riset serentak lintas-store.

### 6. Relevansi ringkasan dengan proyek Spektra
- Tanya: Fitur apa yang relevan untuk diringkas pada kolom `Ringkasan Singkat` bila acuan = Spektra?
- Kesimpulan: Ringkasan wajib menyebut fitur relevan Spektra: info spesifikasi perangkat/CPU/RAM/penyimpanan, info baterai, info layar, info OS/kernel, monitoring sensor, diagnostik hardware (layar, kamera, audio), uji konektivitas jaringan, monitoring realtime, benchmark, dan sejenisnya.

## Keputusan
- K-1: Acuan riset "aplikasi serupa" = **Spektra sesuai `README.md`** (informasi spesifikasi perangkat, monitoring hardware, alat diagnostik Android). Bukan aplikasi berhenti merokok.
- K-2: Sesi mode diskusi ini hanya menyelesaikan diskusi dan mendokumentasikan keputusan; **tidak menjalankan riset** dan **tidak membuat** `apk_kompetitor.md`.
- K-3: `apk_kompetitor.md` **dibuat baru saat perintah riset dijalankan** dengan struktur mengikuti skill `riset-kompetitor` (section per store, format tabel pipe Markdown dengan header+separator, kolom `Status Analisa`); semua listing baru wajib `Status Analisa = Belum Dianalisa`; dilarang menandai `Sudah Dianalisa`.
- K-4: `memori/sesi/sesi_2.md` ditandai `Sudah Sinkron` (pilihan pengguna, 2026-11-13) dengan catatan eksplisit bahwa perubahan yang diklaimnya tidak dapat diverifikasi (berkas tidak ada; `git` bersih); isi sesi_2 tidak dijadikan dasar pekerjaan apa pun.
- K-5: Eksekusi perintah riset wajib **satu store per iterasi**: Play Store dulu → cari aplikasi serupa (hanya mobile) sebanyak mungkin → verifikasi link independen (curl 200 / iTunes lookup / webfetch) → tambahkan ke `apk_kompetitor.md` → baru lanjut store berikutnya (mis. App Store, F-Droid, GitHub, dst.). Dilarang meriset semua store sekaligus.
- K-6: Setiap ringkasan listing wajib menyebut fitur yang relevan dengan Spektra (info/monitoring perangkat, diagnostik, dan sejenisnya), bukan deskripsi umum dari store.
- K-7: Duplikat listing lintas-store diperbolehkan (baris terpisah per store); link wajib mengarah ke halaman resmi store/repositori; Mi Store (GetApps), Oppo App Market, Vivo App Store, Huawei AppGallery, Baidu Mobile Assistant hanya disertakan bila halaman aplikasi spesifik dapat diverifikasi.
- K-8: Status dokumen `Final` (keputusan sudah disepakati pada sesi ini); `Implementasi = Belum Diimplementasikan` (riset dan pembuatan `apk_kompetitor.md` belum dijalankan).

## Rekomendasi
- R-1: Sebelum/saat pembuatan `apk_kompetitor.md`, selaraskan `.agents/skills/custom/riset-kompetitor/SKILL.md` ke konteks Spektra (atau buat skill pendamping), karena isi saat ini berkonteks "aplikasi berhenti merokok" (judul, kategori relevansi, rujukan `refrensi_apk.md`). Mekanisme kolom `Status Analisa` dan aturan verifikasi dipertahankan.
- R-2: Perbarui `.kilo/commands/cari_apk_kompetitor.md` agar memuat aturan eksplisit "satu store per iterasi, perbarui `apk_kompetitor.md` setelah tiap store selesai terverifikasi, baru lanjut store berikutnya" — meniru instruksi pengguna pada argumen; sekaligus catat prioritas instruksi pengguna atas aturan 9 skill (subagen paralel lintas-store) yang kini bertentangan.
- R-3: Gunakan kategori relevansi Spektra saat menyaring listing: info perangkat/CPU/RAM/GPU/penyimpanan, baterai, layar, OS/kernel/build, sensor (akselerasi, gyro, magnet, cahaya, proximity), termal/suhu, benchmark/performa, diagnostik layar/kamera/audio/sensor, uji jaringan, dan widget info perangkat.
- R-4: Kata kunci pencarian yang disarankan: `device info`, `hardware info`, `system info`, `phone info`, `device diagnostics`, `device monitor`, `sensor diagnostics`, `hardware benchmark`. Prioritaskan Play Store/F-Droid/GitHub (Android-first), disusul App Store (hanya referensi — README menyatakan platform Android), lalu Samsung/Mi/Oppo/Huawei/store lainnya.
- R-5: Terapkan verifikasi independen wajib: `curl -s -o /dev/null -w "%{http_code}" -A "Mozilla/5.0 ..." -L <url>`; HTTP 200 = valid; 404 = buang; 403 APKPure/Aptoide/SlideME = anti-bot (verifikasi via webfetch); iTunes `lookup` dengan `resultCount: 0` = tidak disertakan; Samsung Galaxy Store = 200 + judul halaman saja (verifikasi ringan).
- R-6: Semua listing baru wajib `Status Analisa = Belum Dianalisa`; tidak ada penandaan `Sudah Dianalisa` kecuali oleh perintah `.kilo/commands/riset_kompetitor.md` setelah analisa didokumentasikan.
- R-7: Commit `apk_kompetitor.md` dengan pesan `docs: ...` yang merujuk skill riset-kompetitor, setelah setiap batch store selesai terverifikasi (bukan menumpuk banyak store dalam satu commit tanpa verifikasi).

## Tindak Lanjut
| No | Tindakan | File Terdampak | Status |
|----|----------|----------------|--------|
| 1  | Jalankan riset **Google Play Store** (hanya mobile; kata kunci info/diagnostik/monitoring perangkat; sebanyak mungkin), verifikasi link independen, buat `apk_kompetitor.md` baru dan isi listing (`Status Analisa = Belum Dianalisa`) | `apk_kompetitor.md` (Dibuat) | belum |
| 2  | Lanjut riset store berikutnya **satu per satu** (mis. F-Droid, GitHub, App Store, Samsung Galaxy Store, Mi/GetApps, Oppo App Market, lainnya); setelah tiap store, perbarui `apk_kompetitor.md` sebelum lanjut | `apk_kompetitor.md` | belum |
| 3  | Perbarui `.kilo/commands/cari_apk_kompetitor.md` agar memuat aturan satu-per-satu store (R-2) | `.kilo/commands/cari_apk_kompetitor.md` | selesai |
| 4  | Selaraskan `.agents/skills/custom/riset-kompetitor/SKILL.md` ke konteks Spektra (R-1) | `.agents/skills/custom/riset-kompetitor/SKILL.md` | selesai |
| 5  | Commit hasil riset per batch store dengan pesan `docs: ...` (R-7) | git | belum |

## File Terdampak
| Lokasi File | Status Perubahan | Deskripsi |
|-------------|------------------|-----------|
| `hasil_diskusi/diskusi_3.md` | Dibuat | Berkas hasil diskusi ini |
| `memori/sesi/sesi_9.md` | Dibuat | Berkas sesi mode diskusi ini |
| `memori/sesi/sesi_2.md` | Diubah | Ditandai `Sudah Sinkron` (catch-up; perubahan tidak dapat diverifikasi) |
| `MEMORI.md` | Diubah | Sinkronisasi akhir sesi (lokasi hasil diskusi, riwayat diskusi, status sesi, catatan acuan riset Spektra) |
| `memori/riwayat_perubahan.md` | Diubah | Entri riwayat perubahan |
| `apk_kompetitor.md` | Belum dibuat | Dibuat saat perintah riset dijalankan (tindak lanjut) |
| `.kilo/commands/cari_apk_kompetitor.md` | Diubah | Tambah blok aturan satu store per iterasi, acuan Spektra, dan struktur `apk_kompetitor.md` (kerangka skill) — tindak lanjut R-2, selesai 2026-11-13 |
| `.agents/skills/custom/riset-kompetitor/SKILL.md` | Diubah | Penyelarasan dari konteks berhenti merokok ke Spektra (in-place, v1.5.0) — tindak lanjut R-1, selesai 2026-11-13 |

## Pertanyaan Terbuka
Belum ada

## Riwayat Perubahan
| Tanggal | Perubahan |
|---------|-----------|
| 2026-11-13 | Berkas dibuat dari diskusi mode diskusi; keputusan K-1 s.d. K-8; catatan catch-up `sesi_2.md`; pertanyaan terbuka dicatat. |
| 2026-11-13 | Pertanyaan terbuka ditutup: (1) penanganan skill riset-kompetitor — diperbarui in-place ke konteks Spektra (v1.5.0, bukan skill pendamping) (R-1 selesai); (2) `.kilo/commands/cari_apk_kompetitor.md` diubah sekarang (R-2 selesai); (3) urutan store setelah Play Store ditetapkan: F-Droid → GitHub → Apple App Store → Samsung/Mi/Oppo/lainnya; (4) struktur `apk_kompetitor.md` ditetapkan mengikuti kerangka skill (section per store, tabel pipe Markdown, kolom `Status Analisa`). Tindak Lanjut item 3 & 4 ditandai `selesai`; item 1 (riset Play Store + `apk_kompetitor.md`), item 2 (store berikutnya), dan item 5 (commit `docs:`) masih `belum`. Dilaksanakan lewat tindak lanjut hasil diskusi (sesi_10). |
