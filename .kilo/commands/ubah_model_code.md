---
description: Mengubah model (dan opsional variannya) untuk agent code pada .kilo/kilo.jsonc atas permintaan pengguna, dengan konfirmasi sebelum eksekusi.
agent: code
---

# TUJUAN UTAMA

Menyediakan alur terstandar bagi agen untuk mengubah nilai `agent.code.model` (dan opsional `agent.code.variant`) pada `.kilo/kilo.jsonc` atas permintaan eksplisit pengguna, dengan konfirmasi sebelum eksekusi, tanpa menyentuh bagian konfigurasi lain.

# INPUT

- `$1` (opsional): model baru yang diinginkan (contoh: `kilo/reflection/beam-free`).
- `$2` (opsional): variant reasoning yang diinginkan (contoh: `max`). Jika tidak diberikan, gunakan variant reasoning **tertinggi** yang didukung model baru (mis. `max` bila tersedia; jika tidak ada daftar variant, gunakan nilai tertinggi yang terdokumentasi untuk model tersebut).
- Jika `$1` kosong, tanyakan model baru kepada pengguna menggunakan tool `question` sebelum melanjutkan. Jika pengguna tidak menyebut variant, **jangan** mempertahankan variant lama; gunakan variant tertinggi yang didukung model baru. Jika model baru tidak mendukung variant, hapus field `variant` pada `agent.code`.

# KONTEKS WAJIB (BACA SEBELUM EKSEKUSI)

1. Baca `.kilo/kilo.jsonc` (sumber kebenaran konfigurasi) dan catat nilai lama `agent.code.model` serta `agent.code.variant`.
2. Baca `MEMORI.md` bagian `File Konfigurasi & Penting` untuk konteks model yang sedang aktif.
3. Patuhi aturan `memori-check`: pastikan berkas sesi aktif (`memori/sesi/sesi_N.md`) sudah dibuat dan berstatus `Belum Sinkron` sebelum mengubah berkas apa pun.
4. Patuhi larangan pada skill `konfigurasi-kilo-proyek`: perubahan model menunggu keputusan eksplisit pengguna; jangan commit/push; jangan mengubah permission, `external_directory`, atau model agent lain tanpa permintaan.

# ALUR KERJA (STEP-BY-STEP)

1. **Validasi input**:
   - Pastikan model baru non-kosong dan berformat `provider/model` (mis. `kilo/...`).
   - Jika format tidak valid, hentikan dan minta klarifikasi via tool `question`.
2. **Tampilkan draf konfirmasi** kepada pengguna sebelum mengubah berkas:
   - Nilai lama: `agent.code.model` = `<lama>`, `agent.code.variant` = `<lama/none>`.
   - Nilai baru: `agent.code.model` = `<baru>`, `agent.code.variant` = `<tertinggi yang didukung / nilai yang diberikan>`.
   - Daftar berkas terdampak: `.kilo/kilo.jsonc`, `MEMORI.md`, `memori/riwayat_perubahan.md`, berkas sesi aktif.
   - Minta konfirmasi eksplisit pengguna (setuju / batal) menggunakan tool `question`.
3. **Jangan ubah berkas apa pun** sebelum konfirmasi eksplisit pengguna diterima.
4. **Setelah konfirmasi**:
   - Gunakan tool `edit` (bukan `sed`/`cat`/`python3`) untuk mengubah hanya baris `agent.code.model` (dan `agent.code.variant` bila diminta) di `.kilo/kilo.jsonc`.
   - Jangan mengubah bagian lain dari config (permission, instructions, agent lain, dll.).
5. **Verifikasi**:
   - Baca ulang `.kilo/kilo.jsonc` dan pastikan nilai sudah berubah sesuai draf.
   - Config divalidasi otomatis oleh harness Kilo saat diedit; jika edit gagal validasi, perbaiki berkas sebelum melanjutkan dan laporkan galatnya.
6. **Sinkronisasi dokumentasi**:
   - Perbarui `MEMORI.md` bagian `File Konfigurasi & Penting` (catatan model `agent.code`) agar konsisten dengan config baru.
   - Tambah entri pada `memori/riwayat_perubahan.md` yang merangkum perubahan model (nilai lama → baru) dan tanggal.
   - Catat perubahan pada berkas sesi aktif (`memori/sesi/sesi_N.md`): bagian `## Berkas Terdampak` dan `## Sinkronisasi ke MEMORI.md`.
   - Di akhir sesi, ubah `Status Sinkron` berkas sesi menjadi `Sudah Sinkron` setelah `MEMORI.md` diperbarui.
7. **Laporan ke pengguna**: tampilkan ringkasan perubahan (model lama → baru, variant, berkas terdampak) dan status verifikasi.

# LARANGAN KERAS (PROHIBITIONS)

1. **Dilarang** mengubah `.kilo/kilo.jsonc` sebelum konfirmasi eksplisit pengguna (§2 alur kerja).
2. **Dilarang** mengubah model agent selain `code` (ask/plan/debug/compaction/orchestrator) tanpa permintaan eksplisit pengguna.
3. **Dilarang** mengubah permission, `external_directory`, `instructions`, `skills.paths`, atau bagian config lain selain `agent.code.model`/`agent.code.variant`.
4. **Dilarang** commit, push, atau membuat PR tanpa perintah eksplisit pengguna.
5. **Dilarang** menggunakan `sed`, `cat`, atau `python3` untuk membaca/mengedit berkas (izin `deny` bersifat mutlak); gunakan tool `read`/`edit`.
6. **Dilarang** mengandalkan `@file` ter-expand otomatis; baca berkas dengan tool `read`.
7. **Dilarang** mengarang nilai model yang tidak diberikan pengguna; jika tidak tahu, tanyakan.
8. **Dilarang** mempertahankan variant lama ketika berpindah model; gunakan variant reasoning tertinggi yang didukung model baru, kecuali pengguna menentukan variant tertentu. Jika model baru tidak mendukung variant, hapus field `variant`.

# CATATAN

- Command ini hanya mengubah model agent `code`; model global (`model`, `small_model`, `subagent_model`) dan agent lain tidak terpengaruh.
- Jika pengguna ingin mengubah model global atau agent lain, gunakan permintaan terpisah.
- Setelah perubahan, disarankan menjalankan sesi baru Kilo agar model baru aktif.