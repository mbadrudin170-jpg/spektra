// ============================================================
// FILE: .agents/rules/global/aturan_skill.md
// ============================================================

# Aturan Pembuatan dan Pembaruan SKILL.md
## 1. Cakupan
Aturan ini berlaku saat AI **membuat** atau **memperbarui** file `SKILL.md`.
Semua skill yang dibuat sebisa mungkin harus dapat digunakan oleh berbagai proyek Flutter milik pengguna (portabel lintas-proyek).
## 2. Lokasi dan Struktur
- Path skill: `.agents/skills/<kategori>/<nama-skill>/SKILL.md`
- Wajib menggunakan folder `skills` (jamak), bukan `skill`
- Kategori default: `custom`
- Struktur wajib:
```
.agents/skills/<kategori>/<nama-skill>/
└── SKILL.md
```
## 3. Topik Wajib (Referensi Format)
Setiap skill harus mengikuti standar format dan penulisan dari skill referensi yang sudah ada. Skill referensi ini digunakan sebagai acuan tata letak section, gaya bahasa, dan penggunaan backtick, bukan harus meniru isi secara harfiah.
### 3.1 Referensi Skill Topik UI
Berikut adalah daftar skill referensi UI yang formatnya harus diikuti sebagai acuan:
- `pola-ux/SKILL.md`
- `pola-ui/SKILL.md`
- `gaya/SKILL.md`
- `tipografi/SKILL.md`
- `spacing/SKILL.md`
- `widget-custom/SKILL.md`
### 3.2 Referensi Skill Topik Non-UI
- `bug-runtime/SKILL.md`
## 4. Nama Folder Skill
Nama folder skill wajib memenuhi semua ketentuan berikut:
1. Wajib **bahasa Indonesia**.
2. Wajib **deskriptif** (menunjukkan isi skill, bukan nama generik).
3. Wajib **kebab-case** (pemisah strip `-`).
4. Dilarang menggunakan garis bawah (`_`).
5. Dilarang menggunakan spasi.
6. Dilarang huruf besar.
7. Dilarang angka di awal nama.
8. Dilarang karakter selain `a-z`, `0-9`, dan strip `-`.
Contoh nama yang benar: `menambahkan-integration-test-flutter`, `material-app-tema-lokalisasi`, `flutter-local-notifikasi-push`.
Contoh nama yang salah: `integration_test`, `Integration Test`, `01-test`, `my-skill`, `skill_test`.
## 5. Sumber Isi (Berdasarkan Riwayat Commit)
Semua isi `SKILL.md` wajib **mengikuti riwayat commit code** pengguna.
### 5.1 Pengambilan Sumber
AI hanya boleh membaca dari commit yang sudah ada menggunakan perintah git seperti:
- `git log`
- `git show <commit>`
- `git diff <commit>`
### 5.2 Dilarang Mengambil Dari
- File yang belum di-commit (working directory / working tree)
- Perubahan yang masih di staging (`git diff --cached`)
- File untracked
### 5.3 Commit yang Berkaitan
"Commit yang berkaitan" berarti commit yang menyentuh file atau folder yang berhubungan dengan topik skill.
- Jika ada commit yang berkaitan: isi `SKILL.md` disusun dari commit tersebut.
- Jika ada beberapa commit yang berkaitan dan polanya berbeda: AI memilih pola dari **commit terbaru yang relevan**, kecuali pengguna menentukan lain.
- Jika **tidak ada** commit yang berkaitan: AI **dilarang mengarang** pola, gaya, atau contoh. AI wajib berhenti dan menanyakan kepada pengguna bagaimana ingin melanjutkan (contoh: memberikan contoh dari SDK resmi, atau menunda pembuatan skill sampai ada commit yang relevan).
### 5.4 Referensi Commit
`SKILL.md` boleh mencantumkan hash commit sebagai rujukan (opsional).
## 6. Pelanggaran Aturan
- Jika menemukan skill lama yang melanggar aturan ini, AI wajib **melaporkan kepada pengguna dan mengusulkan perbaikan** melalui komentar/pesan sebelum melakukan rename atau restructure.
- AI dilarang membiarkan pelanggaran tetap tanpa ditindaklanjuti. Jika pelanggaran ditemukan, AI harus memberitahu pengguna dan menunggu arahan sebelum melanjutkan perubahan apapun pada skill tersebut.
## 7. Front Matter (YAML)
Setiap `SKILL.md` wajib memiliki frontmatter di paling atas file, dibungkus dengan `---` pada baris pertama dan `---` setelah field terakhir.
### 7.1 Field Wajib
| Field                      | Keterangan                                                    |
| -------------------------- | ------------------------------------------------------------- |
| `name`                     | Sama dengan nama folder skill (kebab-case, bahasa Indonesia)  |
| `description`              | Deskripsi yang sangat detail; **wajib diawali segmen trigger-only** (lihat §8) |
| `metadata.kategori`        | Sesuai folder kategori (default `"custom"`)                   |
| `metadata.versi`           | Format semver, contoh `"1.0.0"`                               |
| `metadata.diperbarui`      | Waktu pembaruan terakhir isi skill (format `TZ=Asia/Jakarta date`), wajib diisi dan diperbarui setiap kali isi skill berubah (frontmatter maupun body) |
| `metadata.sumber-terakhir` | Sumber terakhir perubahan (hash commit atau perintah/hasil eksplisit pengguna), menggantikan `metadata.commit-terakhir` |
### 7.2 Field Opsional
| Field            | Keterangan                                                                                                                 |
| ---------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `metadata.model` | Jika dicantumkan, wajib diisi dengan model AI yang sedang mengedit skill saat itu, dan diperbarui setiap kali skill diedit |
### 7.3 Contoh Front Matter
```yaml
---
name: menambahkan-integration-test-flutter
description: Trigger: saat menambahkan integration test Flutter | Panduan integration test, eksplorasi UI via MCP, dan mengotomasi alur pengguna dengan integration_test.
metadata:
  kategori: "custom"
  versi: "1.0.0"
  diperbarui: "Wed Nov 11 2026 23:30:00 WIB"
  sumber-terakhir: "perintah pengguna: perbarui skill index"
  model: "models/gemini-3.1-pro-preview"
---
```
## 8. Aturan Penulisan Deskripsi Skill
Deskripsi skill (bagian `description` dan paragraf pengantar) wajib mencakup poin-poin §8.4. Bagian `description` **wajib diawali segmen trigger-only** agar ekstraksi trigger untuk `SKILLS_INDEX.md` dapat dilakukan secara deterministik.
### 8.1 Definisi Trigger
**Trigger** adalah kondisi atau tugas pemicu yang membuat skill ini relevan digunakan (mis. "saat menambahkan notifikasi lokal", "saat membuat PRD"). Aturan definisi trigger:
1. Trigger hanya berisi **kondisi/tugas pemicu** — bukan cakupan, bukan larangan, bukan langkah kerja (workflow), dan bukan referensi file.
2. Trigger **tidak boleh** memuat daftar package/class/versi (cakupan), hal yang dilarang, urutan kerja, atau path file/folder.
3. Trigger wajib spesifik dan dapat dibedakan dari skill lain (bukan "saat bekerja dengan Flutter").
4. Trigger ditulis dalam **bahasa Indonesia** baku; istilah teknis (mis. `build_runner`, `SKILL.md`, `PRD`) boleh tetap dalam bahasa Inggris.
### 8.2 Format dan Penempatan Segmen Trigger di `description`
1. `description` **wajib diawali** dengan penanda literal `Trigger:` pada posisi paling awal (huruf `T` besar, diikuti satu spasi).
2. Segmen trigger adalah teks dari setelah `Trigger:` sampai pemisah **` | `** pertama (spasi, pipe, spasi) atau sampai akhir string bila pemisah tidak ada.
3. Setelah pemisah ` | `, segmen berikutnya memuat cakupan, larangan, workflow, dan referensi file seperti biasa (lihat §8.4).
4. Segmen trigger **hanya memuat trigger** — isi selain kondisi/tugas pemicu dilarang berada di segmen trigger.
5. Bila `description` tidak memuat pemisah ` | `, seluruh isi setelah `Trigger:` dianggap sebagai segmen trigger (satu segmen).
Contoh:
```yaml
description: Trigger: saat menambahkan notifikasi lokal Flutter | Panduan flutter_local_notifications v23.0.0, cek platform, izin runtime, dan payload validation.
```
### 8.3 Penanganan Bahasa ID/EN
1. Segmen trigger wajib **bahasa Indonesia**; isi boleh memuat istilah teknis bahasa Inggris yang lazim.
2. Segmen setelah pemisah ` | ` boleh bahasa Indonesia atau bahasa Inggris-campuran, tetapi dianjurkan bahasa Indonesia.
3. Bila `description` lama seluruhnya bahasa Inggris, terjemahkan hanya segmen trigger ke bahasa Indonesia saat normalisasi; segmen lainnya boleh dipertahankan (lihat strategi migrasi pada `task.md`).
4. Ekstraktor (mis. `perbarui_skills_index.md`) wajib membaca dari setelah `Trigger:` sampai ` | ` pertama atau akhir string; tidak boleh menebak-nebak isi non-trigger.
### 8.4 Poin Wajib Deskripsi Skill
Deskripsi skill (bagian `description` dan paragraf pengantar) wajib mencakup poin-poin berikut:
1. **Kapan digunakan (trigger/use case)** — jelaskan skenario spesifik yang memerlukan skill ini. Bagian ini **wajib** menjadi segmen trigger-only di awal `description` (lihat §8.1–8.3).
2. **Apa yang di-cover** — cakupan fungsi, class, package, atau versi yang relevan (contoh: `flutter_local_notifications` v22.3.3).
3. **Apa yang harus dihindari** — jangan digunakan untuk UI web, jangan diedit manual file generated, dll.
4. **Langkah kerja (workflow)** — urutan tindakan yang wajib diikuti, misal `pub get` → `build_runner` → verifikasi `dart analyze`.
5. **Referensi ke file terkait** — path file atau folder yang relevan dengan topik skill dan digunakan sebagai acuan saat menerapkan skill tersebut.
### 8.5 Rekonsiliasi dengan Front Matter
- `metadata.diperbarui` dan `metadata.sumber-terakhir` adalah field **wajib** (lihat §7.1) dan menggantikan `metadata.commit-terakhir` yang tidak lagi dipakai.
- Setiap perubahan `description` (termasuk penambahan/perbaikan segmen trigger) wajib memperbarui `metadata.diperbarui` dan `metadata.sumber-terakhir`, serta menaikkan `metadata.versi` (bump patch default).
- Segmen trigger-only di awal `description` adalah syarat validitas deskripsi, sehingga `description` tanpa penanda `Trigger:` dianggap belum memenuhi aturan ini.
## 9. Format Lengkap `SKILL.md`
Setiap section di bawah ini **wajib ada** dalam setiap `SKILL.md`. Tidak perlu folder `examples` terpisah — contoh kode langsung di dalam `SKILL.md`. Gunakan bahasa Indonesia, gaya teknis ringkas, tanpa pengalaman konversasi. Gunakan backtick `` ` `` untuk nama class, properti, method, dan package.
### 9.1 YAML Frontmatter (awal file)
```yaml
---
name: material-app-tema-lokalisasi
description: Trigger: saat mengonfigurasi MaterialApp dan WidgetsApp | Panduan tema (theme, darkTheme, themeMode), lokalisasi (locale, supportedLocales, localizationsDelegates), serta ScrollBehavior.
metadata:
  kategori: "custom"
  versi: "1.0.0"
  diperbarui: "Wed Nov 11 2026 23:30:00 WIB"
  sumber-terakhir: "<hash-commit>"
  model: "kilo-auto/free"
---
```
### 9.2 Judul dan Intro
```markdown
# Konfigurasi MaterialApp, Tema, dan Lokalisasi
Mengatur `MaterialApp` / `WidgetsApp` dengan tema gelap/terang, locale, supportedLocales, dan localizationsDelegates untuk aplikasi multi-bahasa.
```
- H1 = judul skill
- Paragraf berikutnya = penjelasan singkat tujuan skill
### 9.3 `## Cakupan yang Di-Cover`
Daftar bullet dengan kategori: Package, Class, Enum, Properti, Method.
```markdown
## Cakupan yang Di-Cover
- Package: `package:flutter` (file `lib/src/widgets/material/app.dart`, `lib/src/widgets/app.dart`)
- Class: `MaterialApp`, `WidgetsApp`, `ThemeMode`, `ThemeData`, ...
- Enum: `ThemeMode.system`, `ThemeMode.light`, `ThemeMode.dark`
- Properti: `theme`, `darkTheme`, ...
- Method: `basicLocaleListResolution`, `Theme.of`, ...
```
### 9.4 `## Aturan`
Daftar berurutan (numbered list) yang harus diikuti saat menerapkan skill ini.
```markdown
## Aturan
1. `MaterialApp` membungkus `WidgetsApp` ...
2. Salah satu dari `home`, `routes`, `onGenerateRoute`, atau `builder` harus non-null.
   ...
```
### 9.5 `## Steps` (Opsional)
Daftar langkah-langkah berurutan yang menjelaskan urutan kerja (workflow) dalam menerapkan skill ini. Section ini **hanya ada jika aksi membutuhkan urutan kerja** yang jelas dan tidak dapat dijelaskan sekadar dalam section Aturan. Jika urutan kerja sudah cukup dijelaskan dalam section Aturan, section Steps tidak perlu ditambahkan.
```markdown
## Steps
1. Langkah pertama yang harus dilakukan.
2. Langkah kedua yang harus dilakukan.
3. Langkah ketiga yang harus dilakukan.
```
- Gunakan numbered list untuk mempertahankan urutan.
- Setiap langkah harus spesifik, dapat diikuti, dan tidak ambigu.
- Jangan memasukkan langkah yang tidak relevan atau redundan dengan aturan.
### 9.6 `## Larangan`
Daftar bullet yang dimulai dengan `DILARANG` atau menjelaskan hal yang tidak boleh dilakukan.
```markdown
## Larangan
- `darkTheme` dengan brightness bukan `Brightness.dark`.
- `MaterialApp` tanpa `home`, `routes`, `onGenerateRoute`, atau `builder`.
  ...
```
### 9.7 `## Contoh Benar`
Satu blok kode Dart dengan implementasi yang benar.
````markdown
## Contoh Benar
```dart
MaterialApp(
  ...
);
```
````
### 9.8 `## Contoh Salah`
Satu atau lebih blok kode Dart dengan komentar `// DILARANG` atau `// salah: ...` yang menjelaskan mengapa salah.
````markdown
## Contoh Salah
```dart
// darkTheme tanpa brightness dark
darkTheme: ThemeData(primaryColor: Colors.blue), // salah: brightness default light
```
```dart
// supportedLocales kosong
supportedLocales: [], // assert error
```
````
### 9.9 `## Sumber Evaluasi`
Daftar file sumber dan class terkait untuk verifikasi.
```markdown
## Sumber Evaluasi
- File: `lib/path/to/file.dart`
- Class terkait: `NamaClass1`, `NamaClass2`
- Commit rujukan: `<hash-commit>`
```
## 10. Contoh Lengkap `SKILL.md` (Template Siap Salin)
Berikut adalah contoh lengkap yang dapat langsung disalin sebagai template untuk skill baru:
````markdown
---
name: nama-skill-bahasa-indonesia
description: Trigger: saat <kondisi/tugas pemicu> | <deskripsi detail: cakupan yang di-cover, larangan penggunaan, langkah kerja, dan referensi file terkait>.
metadata:
  kategori: "custom"
  versi: "1.0.0"
  diperbarui: "<waktu TZ=Asia/Jakarta date>"
  sumber-terakhir: "<hash-commit atau perintah/hasil eksplisit pengguna>"
  model: "nama-model-ai"
---
# Judul Skill dalam Bahasa Indonesia
Penjelasan singkat tujuan skill dalam satu atau dua paragraf.
## Cakupan yang Di-Cover
- Package: `package:nama_package`
- Class: `NamaClass1`, `NamaClass2`
- Enum: `EnumNilai1`, `EnumNilai2`
- Properti: `propertiSatu`, `propertiDua`
- Method: `namaMethodSatu`, `namaMethodDua`
## Aturan
1. Aturan pertama yang harus diikuti.
2. Aturan kedua yang harus diikuti.
3. Aturan ketiga yang harus diikuti.
## Steps
1. Langkah pertama yang harus dilakukan (hanya jika aksi membutuhkan urutan kerja).
2. Langkah kedua yang harus dilakukan.
3. Langkah ketiga yang harus dilakukan.
## Larangan
- DILARANG melakukan sesuatu yang melanggar pola.
- DILARANG menggunakan properti tanpa validasi yang sesuai.
## Contoh Benar
```dart
// Implementasi yang benar sesuai aturan skill
NamaClass(
  propertiSatu: nilai,
);
```
## Contoh Salah
```dart
// DILARANG: implementasi yang tidak sesuai
NamaClass(
  propertiSatu: null, // salah: properti wajib diisi
);
```
## Sumber Evaluasi
- File: `path/to/file.dart`
- Class terkait: `NamaClass1`, `NamaClass2`
````
## 11. Checklist Sebelum Menyelesaikan SKILL.md
Sebelum mengakhiri pembuatan atau pembaruan `SKILL.md`, verifikasi semua poin berikut:
- [ ] File berada di `.agents/skills/<kategori>/<nama-skill>/SKILL.md`
- [ ] Nama folder menggunakan kebab-case, bahasa Indonesia, deskriptif
- [ ] Tidak ada underscore, spasi, huruf besar, angka di awal, atau karakter selain `a-z0-9-`
- [ ] Front matter YAML lengkap dengan field wajib (`name`, `description`, `metadata.kategori`, `metadata.versi`, `metadata.diperbarui`, `metadata.sumber-terakhir`)
- [ ] Semua section wajib ada (Judul/Intro, Cakupan, Aturan, Steps [jika diperlukan], Larangan, Contoh Benar, Contoh Salah, Sumber Evaluasi)
- [ ] Isi mengikuti riwayat commit yang relevan (tidak diarang dari working directory/staging/untracked)
- [ ] Deskripsi mencakup segmen trigger-only di awal (lihat §8.2), cakupan, larangan, workflow, dan referensi file
- [ ] Bahasa Indonesia, gaya teknis ringkas, tanpa pengalaman konversasi
- [ ] Backtick digunakan untuk class, properti, method, package
- [ ] Jika menemukan pelanggaran pada skill lama, telah melaporkan dan mengusulkan perbaikan


// ============================================================
// FILE: .agents/rules/global/format_hasil_diskusi.md
// ============================================================

# Format Berkas Hasil Diskusi
## 1. Tujuan
Aturan ini menetapkan format, lokasi, penamaan, status, dan kewajiban pencatatan berkas hasil diskusi (`diskusi_N.md`) agar setiap orang dan AI yang membuat atau memperbarui berkas tersebut menghasilkan isi yang konsisten.
## 2. Cakupan
- **Berkas yang diatur**: berkas hasil diskusi `diskusi_N.md` pada folder `hasil_diskusi/` di root proyek.
- **Mode terkait**: `.kilo/commands/mode/mode_diskusi.md` (aturan pelaksanaan mode diskusi) dan `.kilo/commands/kerjakan_hasil_diskusi.md` (tindak lanjut hasil diskusi).
- **Dokumen lain**: `MEMORI.md` (bagian `Lokasi Hasil Diskusi` dan `Riwayat Diskusi`) serta `memori/riwayat_perubahan.md` (riwayat perubahan proyek); sinkronisasi dicatat pada `memori/sesi/sesi_N.md` (lihat skill `memori-check`); pada awal sesi AI juga wajib melakukan catch-up sync (memindai `memori/sesi/*.md` `Belum Sinkron` dari sesi sebelumnya) sebelum membuat berkas sesi baru.
## 3. Perbedaan dengan Format PRD
1. Berkas hasil diskusi **BUKAN** dokumen PRD. Sifatnya catatan proses: latar belakang, poin diskusi, keputusan, rekomendasi, dan tindak lanjut.
2. `.agents/rules/global/format_PRD.md` hanya berlaku untuk dokumen PRD dan **tidak** menjadi acuan struktur berkas hasil diskusi.
3. Perbedaan utama:
| Aspek | PRD (`format_PRD.md`) | Hasil Diskusi (aturan ini) |
| ----- | --------------------- | -------------------------- |
| Sifat | Spesifikasi produk | Catatan proses/keputusan |
| Pembuka | H1 PRD, metadata status, pemisah `---` | H1 topik + metadata ringkas pada `## Status` |
| Bagian | 6 bagian PRD (Informasi Produk, Tujuan PRD, Daftar Fitur, Alur Pengguna, Steps, File-File Terdampak) | Latar Belakang, Poin Diskusi, Keputusan, Rekomendasi, Tindak Lanjut, File Terdampak, Pertanyaan Terbuka, Riwayat Perubahan |
| Pengulangan aturan | Tiap bagian memuat "Konteks penggunaan" dan "Aturan pengisian" | Tidak ada pengulangan; langsung isi |
| Kata kunci wajib | — | `## Status`, `## Keputusan`, `## Tindak Lanjut` (dipakai `kerjakan_hasil_diskusi.md`) |
## 4. Aturan Lokasi dan Penamaan
1. Seluruh berkas hasil diskusi **WAJIB** disimpan di folder `hasil_diskusi/` pada root proyek.
2. Nama berkas **WAJIB** berformat `diskusi_N.md` dengan `N` berupa bilangan bulat positif tanpa awalan nol (contoh: `diskusi_1.md`, `diskusi_12.md`).
3. Penentuan nomor:
   - Jika folder `hasil_diskusi/` kosong, gunakan nomor `1`.
   - Jika sudah ada berkas, gunakan **nomor tertinggi + 1**.
   - Nomor yang terlewat (gap) **tidak diisi**; tetap gunakan `tertinggi + 1`.
4. **DILARANG** menyimpan berkas hasil diskusi di lokasi lain (mis. `prd/`, `docs/`, atau root tanpa folder).
5. **DILARANG** menimpa berkas hasil diskusi yang sudah ada. Diskusi baru selalu membuat berkas baru dengan nomor berikutnya.
## 5. Aturan Struktur Isi
1. Berkas **WAJIB** memuat bagian berikut **berurutan**, dengan teks judul **persis** seperti tertulis (tanpa penomoran):
   1. `# Hasil Diskusi <N> — <judul topik>`
   2. `## Status`
   3. `## Latar Belakang`
   4. `## Poin Diskusi`
   5. `## Keputusan`
   6. `## Rekomendasi`
   7. `## Tindak Lanjut`
   8. `## File Terdampak`
   9. `## Pertanyaan Terbuka`
   10. `## Riwayat Perubahan`
2. Isi tiap bagian:
   - `## Status` — memuat metadata: `Dokumen`, `Implementasi`, `Tanggal`, dan `Topik`.
   - `## Latar Belakang` — masalah, pemicu, atau konteks yang memunculkan diskusi.
   - `## Poin Diskusi` — poin-poin yang dibahas; setiap poin memuat pertanyaan dan kesimpulan singkat.
   - `## Keputusan` — daftar keputusan final, diberi kode `K-1`, `K-2`, dan seterusnya.
   - `## Rekomendasi` — daftar saran/tindakan yang dianjurkan, diberi kode `R-1`, `R-2`, dan seterusnya.
   - `## Tindak Lanjut` — tabel dengan kolom `No`, `Tindakan`, `File Terdampak`, `Status`.
   - `## File Terdampak` — tabel dengan kolom `Lokasi File`, `Status Perubahan`, `Deskripsi`.
   - `## Pertanyaan Terbuka` — hal yang masih menunggu jawaban/keputusan; tulis `Belum ada` bila tidak ada. **WAJIB diperbarui setiap kali status atau isi berkas berubah**: pertanyaan yang sudah terjawab WAJIB dihapus dari daftar dan dicatat sebagai jejak di `## Riwayat Perubahan` (mis. "Pertanyaan terbuka ditutup: <ringkasan pertanyaan> — <jawaban singkat> (<tanggal>)").
   - `## Riwayat Perubahan` — tabel dengan kolom `Tanggal`, `Perubahan`.
3. **Jumlah dan judul bagian DILARANG diubah** tanpa pembaruan aturan ini. Bila format perlu diperluas, ubah aturan ini terlebih dahulu.
4. Seluruh isi **WAJIB** menggunakan bahasa Indonesia, gaya teknis ringkas, tanpa pengalaman konversasi.
5. Seluruh isi **WAJIB** didasarkan pada hasil diskusi dan informasi proyek yang diketahui. **DILARANG mengarang informasi.**
6. Teks judul `## Status`, `## Keputusan`, dan `## Tindak Lanjut` **WAJIB** dipertahankan apa adanya karena menjadi titik baca `.kilo/commands/kerjakan_hasil_diskusi.md`.
7. **Pengecualian arsip.** Berkas hasil diskusi yang dibuat sebelum aturan ini berlaku (mis. `diskusi_1.md` sampai `diskusi_4.md`) dikecualikan dari kewajiban struktur di atas dan dipertahankan apa adanya sebagai arsip. **DILARANG** mengubah arsip tersebut tanpa persetujuan pengguna.
## 6. Aturan Status
1. `Dokumen` pada `## Status` **WAJIB** diisi salah satu dari:
   - `Draft` — masih dibahas atau belum disepakati.
   - `Final` — hasil diskusi sudah disepakati.
   - `Batal` — diskusi dibatalkan.
2. `Implementasi` pada `## Status` **WAJIB** diisi sesuai kondisi aktual, mis. `Belum Diimplementasikan`, `Sedang Diimplementasikan`, atau `Sudah Diimplementasikan`. Jika belum diketahui atau belum relevan, tulis secara eksplisit (mis. `Belum diketahui`) dan **DILARANG** mengarang.
3. Perubahan status **WAJIB** disertai penyesuaian isi bagian yang relevan agar dokumen tetap konsisten.
## 7. Aturan Bagian yang Belum Dibahas
1. Bagian yang belum dibahas, belum diputuskan, atau belum tersedia datanya **WAJIB** diisi keterangan eksplisit, mis. `Belum dibahas` atau `Belum diketahui`.
2. **DILARANG** menebak, mengisi contoh fiktif, atau mengosongkan bagian tanpa keterangan.
3. Bagian `## Pertanyaan Terbuka` **WAJIB** diperbarui setiap kali status atau isi berkas berubah: pertanyaan yang sudah terjawab WAJIB dihapus dari daftar, dan dicatat sebagai jejak di `## Riwayat Perubahan` (mis. "Pertanyaan terbuka ditutup: <ringkasan pertanyaan> — <jawaban singkat> (<tanggal>)"). Bila tidak ada pertanyaan terbuka, tulis `Belum ada`.
## 8. Aturan Pencatatan di `MEMORI.md` dan `memori/riwayat_perubahan.md`
1. Setelah berkas hasil diskusi dibuat, diperbarui, atau dihapus, **WAJIB** perbarui `MEMORI.md` pada bagian yang relevan, sekurang-kurangnya:
   - `Lokasi Hasil Diskusi` — lokasi folder, daftar berkas, dan nomor tertinggi.
   - `Riwayat Diskusi` — topik, status PRD, dan tindak lanjut.
2. Tambahkan entri riwayat perubahan pada `memori/riwayat_perubahan.md` — ringkasan perubahan berkas (sebagai pengganti bagian `Riwayat Perubahan` yang sebelumnya berada di `MEMORI.md`).
3. **DILARANG** membiarkan `MEMORI.md` memuat nomor tertinggi atau daftar berkas yang sudah usang.
4. Sinkronisasi `MEMORI.md` wajib dilakukan melalui alur berkas sesi (`memori/sesi/sesi_N.md`, status `Belum Sinkron` → `Sudah Sinkron`) sesuai skill `memori-check`: catat sesi ke berkas sesi sebelum/selama pembaruan, lalu tandai `Sudah Sinkron` setelah `MEMORI.md` dan `memori/riwayat_perubahan.md` diperbarui. Berkas `sesi_N.md` **tidak boleh dihapus** (diarsipkan permanen). Pada setiap **awal sesi**, setelah membaca `MEMORI.md` dan sebelum membuat berkas sesi baru, AI wajib melakukan **catch-up sync**: pindai berkas `memori/sesi/*.md` ber-status `Belum Sinkron` milik sesi sebelumnya; yatim/kosong tanpa perubahan nyata → ditandai `Sudah Sinkron` dengan catatan eksplisit "tidak ada perubahan untuk disinkronkan"; berisi perubahan nyata → disinkronkan dengan prosedur yang sama seperti akhir sesi (`MEMORI.md` + `memori/riwayat_perubahan.md` → isi `## Sinkronisasi ke MEMORI.md` → `Sudah Sinkron`); berkas sesi yang sedang aktif di sesi ini tidak ditandai; bila ambigu → dilaporkan ke pengguna, jangan diputuskan sendiri. Pemindaian dibatasi pada berkas `Belum Sinkron` saja; alur akhir sesi tetap dipertahankan (catch-up hanya jaring pengaman).
## 9. Larangan
- **DILARANG** membuat berkas hasil diskusi di luar `hasil_diskusi/`.
- **DILARANG** mengisi gap penomoran atau menimpa berkas yang sudah ada.
- **DILARANG** mengubah berkas hasil diskusi berstatus `Final` tanpa alasan yang disepakati pengguna.
- **DILARANG** mengubah kode sumber implementasi (`.dart` atau kode lain) sebagai bagian dari pembuatan berkas hasil diskusi; mode diskusi hanya menghasilkan dokumen.
- **DILARANG** memakai struktur PRD (bagian "Konteks penggunaan", "Aturan pengisian", atau 6 bagian PRD) untuk berkas hasil diskusi.
- **DILARANG** mengubah teks judul `## Status`, `## Keputusan`, atau `## Tindak Lanjut`.
- **DILARANG** menggunakan bahasa selain Indonesia, kecuali mengutip istilah teknis atau konten asing yang relevan.
- **DILARANG** mencantumkan informasi yang bukan pertanyaan (mis. catatan status/implementasi) pada `## Pertanyaan Terbuka`.
- **DILARANG** membiarkan pertanyaan yang sudah terjawab tetap tercantum pada `## Pertanyaan Terbuka`; pertanyaan terjawab WAJIB dihapus dan dicatat sebagai jejak di `## Riwayat Perubahan`.
## 10. Kerangka Berkas
```markdown
# Hasil Diskusi <N> — <judul topik>
## Status
- Dokumen: Draft | Final | Batal
- Implementasi: Belum Diimplementasikan | Sedang Diimplementasikan | Sudah Diimplementasikan
- Tanggal: YYYY-MM-DD
- Topik: <ringkasan topik>
## Latar Belakang
<masalah, pemicu, atau konteks diskusi>
## Poin Diskusi
### 1. <poin>
- Tanya: <pertanyaan>
- Kesimpulan: <kesimpulan singkat>
## Keputusan
- K-1: <keputusan>
## Rekomendasi
- R-1: <rekomendasi>
## Tindak Lanjut
| No | Tindakan | File Terdampak | Status |
|----|----------|----------------|--------|
| 1  | <tindakan> | <file> | belum |
## File Terdampak
| Lokasi File | Status Perubahan | Deskripsi |
|-------------|------------------|-----------|
| <file> | Dibuat / Diubah / Dihapus | <deskripsi> |
## Pertanyaan Terbuka
- <pertanyaan> / Belum ada
## Riwayat Perubahan
| Tanggal | Perubahan |
|---------|-----------|
| YYYY-MM-DD | <perubahan> |
```
## 11. Checklist Sebelum Menyelesaikan Berkas
- [ ] Berkas berada di `hasil_diskusi/diskusi_N.md` dengan nomor `tertinggi + 1`.
- [ ] Seluruh bagian pada §5 tersedia dan berurutan, dengan judul persis.
- [ ] `Dokumen` dan `Implementasi` pada `## Status` terisi dan konsisten dengan isi.
- [ ] Keputusan diberi kode `K-N` dan rekomendasi diberi kode `R-N`.
- [ ] Bagian yang belum dibahas diberi keterangan eksplisit.
- [ ] `## Pertanyaan Terbuka` diperbarui: pertanyaan terjawab dihapus dan dicatat sebagai jejak di `## Riwayat Perubahan`; bila tidak ada, berisi `Belum ada`.
- [ ] Tidak memakai struktur PRD.
- [ ] Bahasa Indonesia dan tidak ada informasi yang dikarang.
- [ ] `MEMORI.md` diperbarui pada bagian `Lokasi Hasil Diskusi` dan `Riwayat Diskusi`, serta `memori/riwayat_perubahan.md` diperbarui (riwayat perubahan) — sinkronisasi dicatat/ditandai pada `memori/sesi/sesi_N.md` (status `Sudah Sinkron`); awal sesi melakukan catch-up sync (`memori/sesi/*.md` `Belum Sinkron` dipindai; yatim/kosong ditandai `Sudah Sinkron` + catatan eksplisit; ambigu dilaporkan ke pengguna); berkas sesi tidak boleh dihapus.

// ============================================================
// FILE: .agents/rules/global/format_PRD.md
// ============================================================

# PRODUCT REQUIREMENTS DOCUMENT (PRD)
**Status Dokumen:** Draft / Final
**Status Implementasi:** Belum Diimplementasikan / Sedang Diimplementasikan / Sudah Diimplementasikan
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
- Nama aplikasi:
- Deskripsi produk:
- Platform:
- Versi:
- Status pengembangan:
## 2. Tujuan PRD
**Konteks penggunaan:**
Digunakan untuk menentukan hasil yang ingin dicapai dari dokumen PRD ini. Tujuan harus berhubungan langsung dengan kebutuhan dokumen.
**Aturan pengisian:**
- Tuliskan hasil yang diharapkan dari PRD.
- Pastikan setiap tujuan memiliki hubungan dengan kebutuhan dokumen PRD.
- Gunakan tujuan yang jelas dan dapat dievaluasi.
- Jangan memasukkan tujuan yang berada di luar ruang lingkup PRD.
**Isi:**
Jelaskan hasil dan manfaat yang ingin dicapai melalui dokumen PRD ini.
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
|       |           | Must Have   |
|       |           | Should Have |
|       |           | Could Have  |
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
Jelaskan langkah-langkah pengguna dalam menjalankan setiap proses utama aplikasi.
## 5. Steps
**Konteks penggunaan:**
Digunakan untuk menjelaskan urutan langkah-langkah kerja yang harus diikuti dalam mengisi atau menerapkan PRD.
**Aturan pengisian:**
- Buat langkah-langkah yang spesifik dan dapat diikuti.
- Gunakan numbered list untuk mempertahankan urutan.
- Setiap langkah harus tidak ambigu dan dapat dikerjakan.
- Jangan memasukkan langkah yang tidak relevan atau redundan.
**Isi:**
1. Langkah pertama yang harus dilakukan.
2. Langkah kedua yang harus dilakukan.
3. Langkah ketiga yang harus dilakukan.
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
| Lokasi File | Status Perubahan          | Deskripsi Perubahan |
| ----------- | ------------------------- | ------------------- |
|             | Dibuat / Diubah / Dihapus |                     |
|             | Dibuat / Diubah / Dihapus |                     |


// ============================================================
// FILE: .agents/rules/global/format_task.md
// ============================================================

saya ingin agar yang menambahkan atau memperbarui isi file `task.md` di root harus menaati semua aturan gaya penulisan format ini.
jadi agar setiap orang dan AI yang mengedit file task.md ini isi nya akan selalu konsisten.
saya ingin setiap task itu dikelompokkan berdasarkan file file yang terdampak, misalnya `task A` mengedit file `A,B,dan C` lalu `task B` hanya mengerjakan file `A` saja, maka dikelompokkan dalam satu kelompok.
lihat contoh di bawah untuk format nya.
Contoh:
# Kelompok 1
## file terdampak
- (file A)[../FileA.md]
## Tinggi
#### Task 1
- Status : isi misalnya [selesai, belum, setengah, kerjakan]
- Masalah : isi dengan masalah apa yang di ketahui nya.
- Solusi : isi dengan solusi apa yang di rekomendasikan dan berikan contoh nya.
- aturan dilanggar : sisipkan nama semua aturan yang dilanggarnya misalnya : (aturan_boilprate)[aturan_boilprate:32]
- file bermasalah : sisipkan semua file yang harus di perbaiki tersebut misalnya (aturan_boilprate)[aturan_boilprate:32].
- prompt : hanya diisi oleh saya
#### Task 2
- Status : isi misalnya [selesai, belum, setengah, kerjakan]
- Masalah : isi dengan masalah apa yang di ketahui nya.
- Solusi : isi dengan solusi apa yang di rekomendasikan dan berikan contoh nya.
- aturan dilanggar : sisipkan nama semua aturan yang dilanggarnya misalnya : (aturan_boilprate)[aturan_boilprate:32]
- file bermasalah : sisipkan semua file yang harus di perbaiki tersebut misalnya (aturan_boilprate)[aturan_boilprate:32]
- prompt : hanya diisi oleh saya
## Rendah
#### Task 1
- Status : isi misalnya [selesai, belum, setengah, kerjakan]
- Masalah : isi dengan masalah apa yang diketahui nya.


