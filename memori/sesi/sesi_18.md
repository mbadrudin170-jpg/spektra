# Sesi 18 — Aturan: berkas sesi `Sudah Sinkron` bersifat arsip

## Status
- Status Sinkron: Belum Sinkron
- Tanggal: Sat Nov 14 2026 02:26:25 WIB
- Topik: Perintah pengguna agar model AI tidak mengubah berkas sesi ber-status `Sudah Sinkron` — tindak lanjut/koreksi dicatat di berkas sesi baru, bukan mengedit sesi lama

## Catatan Sesi
- Awal sesi: membaca `MEMORI.md`, `AGENTS.md` (konteks), skill `memori-check`; working tree berisi perubahan sesi paralel yang TIDAK disentuh sesi ini (`README.md`, `apk_kompetitor.md`, `MEMORI.md`, `memori/riwayat_perubahan.md`, `memori/sesi/sesi_13.md`, `memori/sesi/sesi_15.md`, `memori/sesi/sesi_16.md`, `memori/sesi/sesi_17.md`, `keluhan.md`, `hasil_diskusi/diskusi_3.md`).
- Catch-up sync memindai `memori/sesi/*.md` `Belum Sinkron`: hanya `sesi_16.md`. Isinya ambigu/inkonsisten (klaim "sinkronisasi selesai, `sesi_16.md` ditandai `Sudah Sinkron`", padahal baris `Status Sinkron`-nya masih `Belum Sinkron`; perubahan `README.md` nyata di working tree). Sesi_17 sudah melaporkannya ke pengguna dan sesi ini TIDAK memutuskannya; `sesi_16.md` tidak disentuh.
- Konteks masalah: sesi paralel sebelumnya mengedit `sesi_15.md` (yang sudah `Sudah Sinkron`) untuk mengoreksi catatan catch-up yang tidak akurat. Pengguna meminta aturan agar kasus serupa tidak terulang: model tidak boleh mengubah sesi yang statusnya sudah sinkron; jika ada tindak lanjut/koreksi, buat sesi baru.
- Perubahan yang diterapkan sesi ini:
  1. Skill `.agents/skills/custom/memori-check/SKILL.md` — aturan baru: berkas sesi ber-status `Sudah Sinkron` bersifat arsip, DILARANG diubah dengan alasan apa pun (isi, `Status Sinkron`, catatan, tabel); koreksi/tindak lanjut/klarifikasi atas isi berkas sesi lama WAJIB dicatat pada berkas sesi baru (nomor tertinggi + 1) yang merujuk berkas lama; yang boleh disentuh hanya berkas `Belum Sinkron` (catch-up) dan berkas sesi yang sedang aktif. Perbarui frontmatter (`versi` → 1.6.0, `diperbarui`, `sumber-terakhir`, `model`), tambah aturan/larangan/contoh benar & salah, dan perbarui langkah verifikasi (cek `git diff -- memori/sesi/` tidak memuat berkas `Sudah Sinkron`).
  2. `SKILLS_INDEX.md` — entri skill `memori-check` diperbarui timestamp `diperbarui`.
  3. `MEMORI.md` — butir baru di "Catatan untuk Model Selanjutnya" dan penyesuaian "Lokasi Berkas Sesi" (nomor tertinggi → 18).
  4. `memori/riwayat_perubahan.md` — entri sesi_18.
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
Belum disinkronkan
