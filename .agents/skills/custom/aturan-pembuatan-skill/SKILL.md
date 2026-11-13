---
name: aturan-pembuatan-skill
description: "Trigger: saat membuat skill baru atau memperbarui skill | Panduan SKILL.md di .agents/skills: lokasi, struktur, penamaan kebab-case bahasa Indonesia, sumber isi dari riwayat commit, front matter YAML, segmen trigger-only, section wajib, dan checklist verifikasi."
metadata:
  kategori: "custom"
  versi: "1.0.2"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Aturan Pembuatan dan Pembaruan SKILL.md

Mengatur cara **membuat** dan **memperbarui** file `SKILL.md` di `.agents/skills/` agar format, sumber isi, dan penamaan konsisten. Skill yang dibuat sebisa mungkin portabel dan dapat digunakan lintas-proyek Flutter.

## Cakupan yang Di-Cover

- Lokasi: `.agents/skills/<kategori>/<nama-skill>/SKILL.md`
- Kategori default: `custom`
- Struktur: satu folder per skill berisi `SKILL.md`
- Referensi format UI: `pola-ux/SKILL.md`, `pola-ui/SKILL.md`, `gaya/SKILL.md`, `tipografi/SKILL.md`, `spacing/SKILL.md`, `widget-custom/SKILL.md`
- Referensi format non-UI: `bug-runtime/SKILL.md`
- Front matter YAML: `name`, `description`, `metadata.kategori`, `metadata.versi`, `metadata.diperbarui`, `metadata.sumber-terakhir`, `metadata.model` (opsional)
- Section wajib: Judul/Intro, `## Cakupan yang Di-Cover`, `## Aturan`, `## Larangan`, `## Contoh Benar`, `## Contoh Salah`, `## Sumber Evaluasi`
- Sumber isi: riwayat commit (`git log`, `git show`, `git diff`)

## Aturan

1. Gunakan path `.agents/skills/<kategori>/<nama-skill>/SKILL.md` dengan folder `skills` (jamak), bukan `skill`; kategori default `custom`.
2. Beri nama folder skill dalam **bahasa Indonesia**, **deskriptif**, dan **kebab-case**: hanya `a-z`, `0-9`, dan strip `-`; tidak diawali angka.
3. Susun isi `SKILL.md` hanya dari **commit yang berkaitan** (commit yang menyentuh file/folder terkait topik skill) menggunakan `git log`, `git show <commit>`, atau `git diff <commit>`.
4. Jika ada beberapa commit relevan dengan pola berbeda, pilih pola dari **commit terbaru yang relevan** kecuali pengguna menentukan lain.
5. Cantumkan front matter YAML di paling atas (dibungkus `---`) dengan field wajib: `name` (sama dengan nama folder), `description` (wajib diawali segmen trigger-only, lihat aturan 6), `metadata.kategori`, `metadata.versi` (semver), `metadata.diperbarui` (format `TZ=Asia/Jakarta date`), dan `metadata.sumber-terakhir` (hash commit atau perintah/hasil eksplisit pengguna). Jika `metadata.model` dicantumkan, isi dengan model AI yang sedang mengedit dan perbarui setiap kali skill diedit.
6. Tulis `description` diawali segmen trigger-only sesuai `.agents/rules/global/aturan_skill.md` §8: diawali literal `Trigger:`, segmen trigger hanya berisi kondisi/tugas pemicu dalam bahasa Indonesia, dipisah dari segmen cakupan lain dengan ` | ` (spasi-pipe-spasi), dan berakhir pada ` | ` pertama atau akhir string. Setelah segmen trigger, `description` dan intro mencakup: apa yang di-cover, apa yang harus dihindari, langkah kerja (workflow), dan referensi ke file terkait.
7. Sertakan semua section wajib: Judul dan intro, `## Cakupan yang Di-Cover`, `## Aturan`, `## Larangan`, `## Contoh Benar`, `## Contoh Salah`, dan `## Sumber Evaluasi`. Contoh kode ditulis langsung di `SKILL.md` (tanpa folder `examples` terpisah).
8. Gunakan bahasa Indonesia, gaya teknis ringkas, tanpa pengalaman konversasi. Gunakan backtick `` ` `` untuk nama class, properti, method, dan package.
9. Ikuti standar format dan penulisan dari skill referensi sesuai topik (UI atau non-UI) sebagai acuan tata letak section, gaya bahasa, dan penggunaan backtick.
10. Jika menemukan skill lama yang melanggar aturan, laporkan kepada pengguna dan usulkan perbaikan sebelum melakukan rename atau restructure; jangan membiarkan pelanggaran tanpa tindak lanjut.
11. Sebelum selesai, verifikasi checklist: lokasi benar, nama folder valid, front matter lengkap, semua section ada, isi berbasis commit relevan, `description` diawali segmen trigger-only, dan pelanggaran skill lama telah dilaporkan bila ada.
12. Patuhi konvensi segmen trigger: literal `Trigger:` di posisi paling awal, trigger hanya memuat kondisi/tugas pemicu (bahasa Indonesia), tanpa cakupan/larangan/workflow/referensi file, dan ekstraksi trigger membaca dari setelah `Trigger:` sampai ` | ` pertama atau akhir string.

## Larangan

- DILARANG menggunakan folder `skill` (tunggal); wajib `skills`.
- DILARANG menamai folder skill dengan garis bawah (`_`), spasi, huruf besar, angka di awal, atau karakter selain `a-z`, `0-9`, dan `-`.
- DILARANG mengambil isi `SKILL.md` dari file yang belum di-commit (working directory/working tree), perubahan staging (`git diff --cached`), atau file untracked.
- DILARANG mengarang pola, gaya, atau contoh bila **tidak ada** commit yang berkaitan; wajib berhenti dan menanyakan kepada pengguna cara melanjutkan.
- DILARANG mengubah atau restructure skill lama yang melanggar aturan tanpa melaporkan dan menunggu arahan pengguna.
- DILARANG menghilangkan section wajib atau memindahkan contoh ke folder `examples` terpisah.
- DILARANG menulis deskripsi yang tidak mencakup trigger, cakupan, larangan penggunaan, langkah kerja, dan referensi file terkait.
- DILARANG menulis `description` tanpa segmen trigger-only di awal (literal `Trigger:`, lihat `.agents/rules/global/aturan_skill.md` §8.2).

## Contoh Benar

````markdown
---
name: material-app-tema-lokalisasi
description: Trigger: saat mengonfigurasi MaterialApp dan WidgetsApp | Panduan tema (theme, darkTheme, themeMode), lokalisasi (locale, supportedLocales, localizationsDelegates), serta ScrollBehavior.
metadata:
  kategori: "custom"
  versi: "1.0.0"
  diperbarui: "Wed Nov 11 2026 23:30:00 WIB"
  sumber-terakhir: "perintah pengguna: perbarui skill index"
  model: "kilo-auto/free"
---

# Konfigurasi MaterialApp, Tema, dan Lokalisasi

Mengatur `MaterialApp` / `WidgetsApp` dengan tema gelap/terang dan lokalisasi.

## Cakupan yang Di-Cover

- Package: `package:flutter`
- Class: `MaterialApp`, `WidgetsApp`

## Aturan

1. Sertakan `home`, `routes`, `onGenerateRoute`, atau `builder` pada `MaterialApp`.

## Larangan

- DILARANG `supportedLocales` kosong.

## Contoh Benar

```dart
MaterialApp(home: HomePage());
```
````

## Contoh Salah

```dart
MaterialApp(supportedLocales: []); // DILARANG
```

## Sumber Evaluasi

- File: `lib/main.dart`
- Commit rujukan: `85421c9fc058fc1af147fc29f7b2ab1721dec16b`

````

## Contoh Salah

```markdown
---
name: Integration_Test
description: panduan test
metadata:
  kategori: "custom"
  versi: "1.0"
---

# Skill

Contoh diambil dari perubahan yang belum di-commit.
````

```dart
// DILARANG: nama folder pakai huruf besar/underscore, front matter tidak lengkap,
// section wajib tidak ada, dan isi diambil dari working directory (bukan commit).
```

## Sumber Evaluasi

- File aturan sumber: `.agents/rules/global/aturan_skill.md` (§8 Definisi dan Konvensi Trigger)
- Skill referensi format UI: `.agents/skills/custom/pola-ux/SKILL.md`, `.agents/skills/custom/pola-ui/SKILL.md`, `.agents/skills/custom/gaya/SKILL.md`, `.agents/skills/custom/tipografi/SKILL.md`, `.agents/skills/custom/spacing/SKILL.md`, `.agents/skills/custom/widget-custom/SKILL.md`
- Skill referensi format non-UI: `.agents/skills/custom/bug-runtime/SKILL.md`
- Commit rujukan: `85421c9fc058fc1af147fc29f7b2ab1721dec16b` (docs(agents): rombak panduan kerja dan pertegas aturan referensi skill), `413f7e4` (refactor(agents): restrukturisasi skill kustom dan ringkas aturan pembuatan SKILL.md), `3cbc5db` (docs(agents): tambah aturan pembuatan SKILL.md dan perbarui AGENTS.md)
