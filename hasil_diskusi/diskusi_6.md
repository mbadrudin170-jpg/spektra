# Hasil Diskusi 6 — Skill pengecekan paket pubspec.yaml versi terbaru & aktif

## Status
- Dokumen: Final
- Implementasi: Belum Diimplementasikan
- Tanggal: 2026-11-14
- Topik: Pembuatan skill custom `menambah-paket-pubspec-terbaru` yang mewajibkan AI selalu mencari paket yang tidak usang saat menambah dependency ke `pubspec.yaml`

## Latar Belakang
Pengguna menyatakan: "saya ingin agar model ai selalu mencari paket yang tidak usang". Setelah klarifikasi bertahap, yang dimaksud adalah: setiap kali AI menambah (atau memperbarui) dependency di `pubspec.yaml`, AI wajib memastikan paket yang dipilih adalah versi terbaru dan paketnya aktif (tidak discontinued/deprecated), bukan paket usang.

Bentuk keluaran yang disepakati adalah **skill** (bukan aturan global di `.agents/rules/global/`), dengan nama folder `menambah-paket-pubspec-terbaru` (kategori `custom`).

Kondisi `pubspec.yaml` saat ini (diperiksa 2026-11-13/14): section `dependencies` memuat `flutter` (sdk), `cupertino_icons`, `shared_preferences`, `flutter_riverpod`, `riverpod_annotation`, `battery_info_v2`; section `dev_dependencies` memuat `flutter_test` (sdk), `flutter_lints`, `riverpod_generator`, `build_runner` — keduanya belum diurutkan abjad (lihat `diskusi_5.md`).

Riwayat commit `pubspec.yaml` hanya memuat: `1fb6840` (Initial commit), `c30a4ec`, `f0f437d`, `4601df9` — **tidak ada commit yang berkaitan dengan topik pemilihan paket terbaru**. Sesuai `.agents/rules/global/aturan_skill.md` §5.3, isi skill disusun dari kondisi proyek aktual + praktik pub.dev atas persetujuan pengguna, dan `metadata.sumber-terakhir` diisi perintah pengguna.

## Poin Diskusi
### 1. Maksud "paket yang tidak usang"
- Tanya: Apa yang dimaksud dengan "model AI selalu mencari paket yang tidak usang"?
- Kesimpulan: Cek saat menambah paket — setiap kali AI menambah dependency ke `pubspec.yaml`, AI wajib mengecek pub.dev (atau sumber resmi) untuk versi terbaru dan status paket (tidak deprecated/discontinued).
### 2. Bentuk keluaran
- Tanya: Dalam bentuk apa hasil diskusi ini dituangkan?
- Kesimpulan: Skill saja (bukan aturan global). Nama folder: `menambah-paket-pubspec-terbaru` (kategori `custom`).
### 3. Kriteria "tidak usang"
- Tanya: Apa kriteria paket yang tidak usang?
- Kesimpulan: Versi terbaru di pub.dev saat menambahkan (atau memperbarui) dependency, dan paket tidak bertanda discontinued/deprecated.
### 4. Cara verifikasi
- Tanya: Bagaimana AI memverifikasi paket tidak usang?
- Kesimpulan: AI mengambil halaman pub.dev paket (webfetch) untuk melihat versi terbaru, tanggal rilis, dan status (discontinued/legacy) sebelum menulis `pubspec.yaml`.
### 5. Kapan skill dimuat
- Tanya: Kapan skill ini wajib dimuat/digunakan?
- Kesimpulan: Dependency ditambahkan hanya lewat `flutter pub add <paket>` (yang otomatis memilih versi terbaru), bukan mengedit `pubspec.yaml` secara manual; skill memandu proses ini.
### 6. Cakupan section
- Tanya: Section `pubspec.yaml` mana yang diatur?
- Kesimpulan: `dependencies` dan `dev_dependencies`; `dependency_overrides` tidak diatur (mengikuti preseden `diskusi_5.md`).
### 7. Nama folder skill
- Tanya: Apa nama folder skill yang diinginkan?
- Kesimpulan: `menambah-paket-pubspec-terbaru` (bahasa Indonesia, kebab-case, deskriptif).
### 8. Kegagalan cek pub.dev
- Tanya: Bagaimana bila webfetch pub.dev gagal/tidak tersedia?
- Kesimpulan: AI melaporkan kegagalan ke pengguna dan tidak menebak versi; `flutter pub add` tetap boleh dipakai tanpa pin versi (memilih terbaru otomatis), metadata paket wajib dicari ulang saat memungkinkan.
### 9. Sumber isi skill
- Tanya: Tidak ada commit yang berkaitan; bagaimana melanjutkan sesuai aturan §5.3?
- Kesimpulan: Pengguna menyetujui isi skill disusun dari kondisi proyek aktual + praktik pub.dev; `metadata.sumber-terakhir` diisi perintah pengguna.
### 10. Status dokumen & tindak lanjut
- Tanya: Status dokumen dan cakupan tindak lanjutnya?
- Kesimpulan: Dokumen `Final`; tindak lanjut (1) buat skill `menambah-paket-pubspec-terbaru`, (2) perbarui `SKILLS_INDEX.md`; belum dikerjakan pada sesi diskusi ini.

## Keputusan
- K-1: Topik yang dibahas adalah skill custom `menambah-paket-pubspec-terbaru` untuk mewajibkan AI selalu mencari paket yang tidak usang saat menambah dependency ke `pubspec.yaml`.
- K-2: Bentuk keluaran hanya skill (tanpa aturan global baru di `.agents/rules/global/`).
- K-3: Nama folder skill: `.agents/skills/custom/menambah-paket-pubspec-terbaru/SKILL.md`.
- K-4: Kriteria "paket tidak usang": versi terbaru di pub.dev saat menambahkan/memperbarui dependency, dan paket tidak bertanda discontinued/deprecated.
- K-5: Cara verifikasi: webfetch halaman pub.dev paket (versi terbaru, tanggal rilis, status) sebelum menulis `pubspec.yaml`.
- K-6: Dependency ditambahkan hanya lewat `flutter pub add <paket>` (bukan edit manual `pubspec.yaml`); skill memandu proses ini.
- K-7: Cakupan: section `dependencies` dan `dev_dependencies`; `dependency_overrides` tidak diatur.
- K-8: Bila webfetch pub.dev gagal: laporkan ke pengguna dan jangan menebak versi; `flutter pub add` tanpa pin versi tetap boleh; metadata wajib dicari ulang saat memungkinkan.
- K-9: Tidak ada commit yang berkaitan dengan topik; isi skill disusun dari kondisi proyek aktual + praktik pub.dev atas persetujuan pengguna; `metadata.sumber-terakhir` diisi perintah pengguna (bukan hash commit).
- K-10: Saat skill dibuat nanti, `SKILLS_INDEX.md` (entri kategori `custom`) wajib diperbarui mengikuti struktur indeks yang berlaku.

## Rekomendasi
- R-1: Saat membuat skill, ikuti `.agents/rules/global/aturan_skill.md` secara penuh: folder `skills/` (jamak), front matter YAML lengkap (`name`, `description` diawali segmen trigger-only, `metadata.kategori`, `metadata.versi`, `metadata.diperbarui`, `metadata.sumber-terakhir`), section wajib (Judul/Intro, Cakupan, Aturan, Larangan, Contoh Benar, Contoh Salah, Sumber Evaluasi), bahasa Indonesia, dan backtick untuk nama package/kelas.
- R-2: Trigger skill yang diusulkan: "saat menambah dependency ke pubspec.yaml" (hanya kondisi/tugas pemicu, tanpa cakupan/larangan/workflow).
- R-3: Verifikasi setelah skill dibuat: front matter valid, semua section wajib ada, nama folder kebab-case bahasa Indonesia, dan `SKILLS_INDEX.md` terbarui; tidak perlu `dart analyze`/`flutter test` karena tidak ada perubahan kode.
- R-4: Skill sebaiknya juga memuat panduan singkat untuk kasus paket yang relevan tetapi berstatus `discontinued` di pub.dev (dilarang dipilih; cari alternatif atau laporkan ke pengguna).

## Tindak Lanjut
| No | Tindakan | File Terdampak | Status |
|----|----------|----------------|--------|
| 1  | Buat skill `menambah-paket-pubspec-terbaru` (front matter, section wajib, contoh benar/salah, Sumber Evaluasi; `metadata.sumber-terakhir` = perintah pengguna) | `.agents/skills/custom/menambah-paket-pubspec-terbaru/SKILL.md` | belum |
| 2  | Perbarui indeks skill (entri `custom` baru, penomoran mengikuti kondisi terakhir; status `diperbarui`) | `SKILLS_INDEX.md` | belum |

## File Terdampak
| Lokasi File | Status Perubahan | Deskripsi |
|-------------|------------------|-----------|
| `hasil_diskusi/diskusi_6.md` | Dibuat | Berkas hasil diskusi ini |
| `memori/sesi/sesi_24.md` | Diubah | Pencatatan diskusi ini |
| `.agents/skills/custom/menambah-paket-pubspec-terbaru/SKILL.md` | Dibuat (tindak lanjut) | Skill yang disepakati, belum dibuat |
| `SKILLS_INDEX.md` | Diubah (tindak lanjut) | Entri skill baru, belum diperbarui |

## Pertanyaan Terbuka
Belum ada

## Riwayat Perubahan
| Tanggal | Perubahan |
|---------|-----------|
| 2026-11-14 | Berkas dibuat berdasarkan diskusi mode diskusi (sesi_27; semula tercatat sebagai sesi_24 yang tertimpa sesi paralel, kemudian sesi_26 yang tertimpa sesi paralel); seluruh keputusan K-1..K-10 disepakati melalui tanya jawab dengan pengguna. |
