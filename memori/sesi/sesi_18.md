# Sesi 18 — Aturan: berkas sesi `Sudah Sinkron` bersifat arsip

## Status
- Status Sinkron: Sudah Sinkron
- Tanggal: Sat Nov 14 2026 02:26:25 WIB
- Topik: Perintah pengguna agar model AI tidak mengubah berkas sesi ber-status `Sudah Sinkron` — tindak lanjut/koreksi dicatat di berkas sesi baru, bukan mengedit sesi lama

## Catatan Sesi
- Awal sesi: membaca `MEMORI.md`, `AGENTS.md` (konteks), skill `memori-check`. Working tree berisi perubahan sesi paralel yang TIDAK disentuh sesi ini (`README.md`, `apk_kompetitor.md`, `memori/riwayat_perubahan.md`, `memori/sesi/sesi_13.md`, `memori/sesi/sesi_15.md`, `memori/sesi/sesi_16.md`, `memori/sesi/sesi_17.md`, `keluhan.md`, `hasil_diskusi/diskusi_3.md`, dan `MEMORI.md` yang ditulis ulang paralel selama sesi).
- Catch-up sync memindai `memori/sesi/*.md` `Belum Sinkron`: pada awal sesi hanya `sesi_16.md`, isinya ambigu/inkonsisten (diklaim sudah disinkronkan tetapi baris status masih `Belum Sinkron`). Sesi ini TIDAK memutuskannya. Selama sesi, sesi paralel menandai `sesi_16.md` `Sudah Sinkron` (terverifikasi: baris 4 kini `Sudah Sinkron`); sesi ini tidak menyentuhnya.
- Konteks masalah: sesi paralel sebelumnya mengedit `sesi_15.md` (yang sudah `Sudah Sinkron`) untuk mengoreksi catatan catch-up yang tidak akurat. Pengguna meminta aturan agar kasus serupa tidak terulang: model tidak boleh mengubah sesi yang statusnya sudah sinkron; jika ada tindak lanjut/koreksi, buat sesi baru.
- Perubahan yang diterapkan sesi ini:
  1. Skill `.agents/skills/custom/memori-check/SKILL.md` — aturan baru (Aturan 12 + paragraf pengantar arsip + langkah verifikasi `git diff -- memori/sesi/` + 2 butir larangan baru + 1 contoh benar + 3 contoh salah): berkas sesi ber-status `Sudah Sinkron` bersifat arsip, DILARANG diubah dengan alasan apa pun (isi, `Status Sinkron`, catatan, tabel); koreksi/tindak lanjut/klarifikasi atas isi berkas sesi lama WAJIB dicatat pada berkas sesi baru (nomor tertinggi + 1) yang merujuk berkas lama; yang boleh disentuh hanya berkas `Belum Sinkron` (catch-up) dan berkas sesi yang sedang aktif di sesi ini. Frontmatter: `versi` → 1.6.0, `diperbarui` → `Sat Nov 14 2026 02:26:25 WIB`, `sumber-terakhir` → perintah pengguna sesi_18, `model` tetap `openrouter/thinkingmachines/inkling-2-small:free`.
  2. `SKILLS_INDEX.md` — timestamp `diperbarui` entri skill `memori-check` → `Sat Nov 14 2026 02:26:25 WIB`.
  3. `MEMORI.md` — butir baru di "Catatan untuk Model Selanjutnya" (berkas sesi `Sudah Sinkron` = arsip; memori-check 1.6.0); "Aturan dan Skill" menyebut versi 1.6.0; "Lokasi Berkas Sesi" nomor tertinggi → 18 (`sesi_17.md` dicatat sebagai sebelumnya tercatat). Catatan: `MEMORI.md` ditulis ulang oleh sesi paralel selama sesi; edit sesi ini menargetkan bagian-bagian tersebut saja dan berpotensi tertimpa penulisan ulang paralel berikutnya.
  4. `memori/riwayat_perubahan.md` — entri sesi_18 ditambahkan.
- Keputusan desain: `AGENTS.md` TIDAK diubah dan TIDAK ada aturan global baru yang dibuat. Alasan: `AGENTS.md` adalah hasil generate `script/build_rules_context.sh` (konkatenasi `.agents/rules/**/*.md`); jalur yang diizinkan untuk "alur sesi" adalah skill `memori-check` (sesuai catatan skill itu sendiri: "pembaruan berikutnya untuk perubahan alur sesi mengikuti aturan_skill.md"). Membuat aturan global terpisah akan menggandakan sumber kebenaran yang harus dipelihara dua kali. Penegakan dilakukan lewat skill + `MEMORI.md` (keduanya wajib dibaca setiap sesi) + verifikasi `git diff -- memori/sesi/`.
- Tidak ada perubahan kode Dart, konfigurasi, atau dokumen selain dokumen/aturan di atas. Verifikasi `dart format`/`dart analyze`/`flutter test` tidak relevan (tidak ada perubahan kode).

## Berkas Terdampak
| Lokasi File | Status Perubahan | Deskripsi |
|-------------|------------------|-----------|
| `memori/sesi/sesi_18.md` | Dibuat | Berkas sesi ini |
| `.agents/skills/custom/memori-check/SKILL.md` | Diubah | Aturan/larangan/contoh: berkas sesi `Sudah Sinkron` = arsip; koreksi di sesi baru; verifikasi `git diff -- memori/sesi/`; frontmatter 1.6.0 |
| `SKILLS_INDEX.md` | Diubah | Timestamp `diperbarui` entri skill `memori-check` |
| `MEMORI.md` | Diubah | Butir "Catatan untuk Model Selanjutnya" (berkas sesi sinkron = arsip) + "Lokasi Berkas Sesi" (nomor tertinggi 18) |
| `memori/riwayat_perubahan.md` | Diubah | Entri sesi_18 |

## Sinkronisasi ke MEMORI.md
Selesai (2026-11-14): `MEMORI.md` diperbarui — (1) `Aturan dan Skill`: skill `memori-check` versi 1.6.0 beserta ringkasan aturan arsip; (2) `Lokasi Berkas Sesi`: nomor tertinggi → 18 (`sesi_18.md`), `sesi_17.md` dicatat sebagai sebelumnya tercatat; (3) `Catatan untuk Model Selanjutnya`: butir baru — berkas sesi `Sudah Sinkron` bersifat arsip, koreksi dicatat di berkas sesi baru. `memori/riwayat_perubahan.md`: entri sesi_18 ditambahkan (mencatat skill 1.6.0, perubahan `SKILLS_INDEX.md`, `MEMORI.md`, dan keputusan desain `AGENTS.md` tidak diubah/tanpa aturan global baru). Skill `memori-check` diperbarui ke 1.6.0 dan `SKILLS_INDEX.md` timestamp-nya selaras. Verifikasi: `git diff -- memori/sesi/` tidak memuat perubahan berkas sesi `Sudah Sinkron` (sesi_13/15/16/17 dimodifikasi oleh sesi paralel, bukan sesi ini; sesi ini hanya membuat `sesi_18.md`). Catatan risiko paralel: `MEMORI.md` ditulis ulang oleh sesi paralel selama sesi; edit sesi ini menargetkan bagian terkait saja dan berpotensi tertimpa penulisan ulang paralel berikutnya.
