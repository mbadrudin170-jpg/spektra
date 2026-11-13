---
description: Menyalin konfigurasi dan perintah proyek (.kilo/commands, .kilo/prompts, .kilo/kilo.jsonc, .config, .agents, .vscode, script, skills-lock.json, SKILLS_INDEX.md, .prettierrc, analysis_options.yaml, docs) dari proyek ini ke repositori global /home/muhamadbadrudin1000/share_global_saya/, lalu memverifikasi hasilnya.
---

# SALIN KONFIGURASI KE GLOBAL

## 1. Tujuan

Menyalin berkas konfigurasi, perintah, dan perkakas proyek ini ke repositori template global `/home/muhamadbadrudin1000/share_global_saya/` (selanjutnya "repo tujuan"), kemudian memverifikasi hasil penyalinan.

## 2. Sumber → Tujuan

| Sumber (proyek ini) | Tujuan (repo tujuan) |
|---|---|
| `.kilo/commands/` | `/home/muhamadbadrudin1000/share_global_saya/.kilo/commands/` |
| `.kilo/prompts/` | `/home/muhamadbadrudin1000/share_global_saya/.kilo/prompts/` |
| `.kilo/kilo.jsonc` | `/home/muhamadbadrudin1000/share_global_saya/.kilo/kilo.jsonc` |
| `.config/` | `/home/muhamadbadrudin1000/share_global_saya/.config/` |
| `.agents/` | `/home/muhamadbadrudin1000/share_global_saya/.agents/` |
| `.vscode/` | `/home/muhamadbadrudin1000/share_global_saya/.vscode/` |
| `script/` | `/home/muhamadbadrudin1000/share_global_saya/script/` |
| `docs/` | `/home/muhamadbadrudin1000/share_global_saya/docs/` |
| `skills-lock.json` | `/home/muhamadbadrudin1000/share_global_saya/skills-lock.json` |
| `SKILLS_INDEX.md` | `/home/muhamadbadrudin1000/share_global_saya/SKILLS_INDEX.md` |
| `.prettierrc` | `/home/muhamadbadrudin1000/share_global_saya/.prettierrc` |
| `analysis_options.yaml` | `/home/muhamadbadrudin1000/share_global_saya/analysis_options.yaml` |

## 3. Langkah Kerja

1. Pastikan path sumber tersedia di proyek ini dan repo tujuan `/home/muhamadbadrudin1000/share_global_saya/` ada. Jika salah satu tidak ada, hentikan proses dan laporkan ke pengguna.
2. Salin seluruh isi sesuai tabel pada butir 2 dengan `cp -r`. Perilaku wajib: berkas bernama sama di repo tujuan **ditimpa** oleh versi proyek ini; berkas/folder di repo tujuan yang tidak memiliki pasangan di sumber **dibiarkan** (tidak dihapus).
3. JANGAN menyalin `.kilo/agent-manager.json`, `.kilo/worktrees/`, dan `.kilo/.gitignore`.
4. JANGAN menyalin berkas/direktori di luar tabel butir 2 (mis. `lib/`, `memori/`, `hasil_diskusi/`, `prd/`, `pubspec.yaml`, `AGENTS.md`).
5. Verifikasi hasil penyalinan:
   - hitung jumlah berkas yang disalin/berubah;
   - jalankan `git status` pada repo tujuan dan tampilkan daftar berkas baru/berubah/dihapus;
   - pastikan `git status` tidak menunjukkan berkas yang **terhapus** akibat perintah ini (hanya `modified`/`new file` yang wajar).
6. Laporkan ringkasan hasil: jumlah berkas yang disalin, daftar folder tingkat atas yang berubah di repo tujuan, dan keluaran `git status` repo tujuan.
7. Setelah penyalinan terverifikasi, perbarui `MEMORI.md` dan `memori/riwayat_perubahan.md` pada proyek ini sesuai alur `memori-check` (berkas sesi aktif dicatat terlebih dahulu, lalu disinkronkan).

## 4. Larangan

1. Dilarang menghapus atau mengosongkan isi repo tujuan di luar penimpaan wajar akibat penyalinan (dilarang `rm -rf` atau `rsync --delete` pada repo tujuan).
2. Dilarang menyalin `agent-manager.json`, `worktrees/`, `.kilo/.gitignore`, dan berkas/direktori di luar tabel butir 2.
3. Dilarang melakukan commit, push, atau merge pada repo tujuan tanpa perintah eksplisit pengguna.
4. Dilarang mengubah kode Dart maupun `pubspec.yaml`, baik di proyek ini maupun di repo tujuan.
5. Dilarang mengubah `.kilo/kilo.jsonc` proyek ini saat menyalin; berkas di repo tujuan yang ditimpa, sumber tidak diubah.
6. Dilarang memakai alat salin yang menghapus berkas lama di repo tujuan.

## 5. Catatan

- Repo tujuan adalah git repository; perubahan hasil penyalinan muncul sebagai working tree changes yang menunggu keputusan commit pengguna.
- Struktur `.agents` proyek ini (skills dikategorikan `custom/` dan `bawaan/`, serta `rules/global/format_*.md` dan `rules/global/aturan_skill.md`) **digabung** dengan struktur lama repo tujuan (skills flat `skills/<nama-skill>/` dan `rules/global/aturan_*.md`); keduanya hidup berdampingan secara sadar, bukan digantikan.
- Penyalinan `.agents` tidak merapikan atau memigrasikan isi lama repo tujuan; migrasi struktur (bila diinginkan) adalah pekerjaan terpisah di luar perintah ini.
- `docs/` berisi dokumen spesifikasi/referensi spektra (antara lain `struktur_proyek.md`, `lib.md`, `snippet.md`, dan `docs/kilo/kilo_global.txt` yang usang); penyalinan dilakukan apa adanya atas permintaan pengguna — berkas yang tidak relevan bagi proyek tujuan dibiarkan tertimpa/terbiarkan, bukan dihapus.
- `skills-lock.json` dan `SKILLS_INDEX.md` mencerminkan versi skill terpasang; keduanya disalin agar repo tujuan memakai acuan yang sama dengan proyek ini.
