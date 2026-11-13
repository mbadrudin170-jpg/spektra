# Tujuan

Memindai seluruh file `SKILL.md` di `.agents/skills/**/`, memvalidasi penempatan dan metadata setiap skill, lalu menulis indeks ke `SKILLS_INDEX.md` (root proyek) berdasarkan path skill, trigger, dan status diperbarui dari metadata. Perintah wajib memberi tahu pengguna ketika menemukan skill yang tidak berada dalam kategori standar `bawaan`/`custom`, tidak memiliki `metadata.kategori`, atau berkonflik dengan `metadata.kategori`.

# Sumber Kebenaran Kategori

1. Kategori skill ditentukan dari **folder fisik induk**, yaitu `bawaan` atau `custom`.
2. `metadata.kategori` **bukan** sumber kebenaran kategori. Field ini hanya dipakai sebagai informasi sekunder untuk deteksi konflik.
3. Alasan: skill bawaan (hasil instalasi paket) umumnya tidak memiliki field `metadata.kategori`, sehingga jika kategori bergantung pada metadata, skill bawaan akan hilang diam-diam.

# Alur Kerja

1. **Scan seluruh file SKILL.md.**
   - Temukan semua file `SKILL.md` di `.agents/skills/**/` (termasuk folder `bawaan` dan `custom`).
   - Baca front matter YAML setiap file untuk mendapatkan: `name`, `description`, `metadata.kategori`, `metadata.versi`, `metadata.diperbarui`, `metadata.sumber-terakhir`.
   - Catat path relatif setiap file untuk keperluan validasi dan pelaporan.

2. **Ekstrak trigger dari description (deterministik).**
   - Baca nilai `description` dari front matter YAML setiap file.
   - Cari literal `Trigger:` di posisi paling awal nilai `description` (konvensi `.agents/rules/global/aturan_skill.md` §8.2).
   - Segmen trigger adalah teks dari setelah `Trigger:` sampai pemisah ` | ` pertama (spasi-pipe-spasi), atau sampai akhir string bila pemisah tidak ada.
   - Tulis segmen trigger apa adanya; trigger wajib bahasa Indonesia dan tidak boleh memuat cakupan/larangan/workflow/referensi file.
   - Jika `description` tidak diawali `Trigger:`, atau segmen trigger kosong, tulis penanda eksplisit: `perlu dilengkapi trigger` dan catat path file sebagai **anomali ringan** (laporan wajib, tidak menghentikan proses).

3. **Tentukan kategori dari folder fisik.**
   - Ambil segmen folder tepat setelah `.agents/skills/` sebagai kategori (mis. `bawaan`, `custom`).
   - Gunakan kategori hasil langkah ini untuk pengelompokan indeks.

4. **Susun indeks per kategori.**
   - Kelompokkan entri berdasarkan kategori folder fisik (mis. `custom`, `bawaan`).
   - Buat heading `## <kategori>` untuk setiap kategori (mis. `## custom`, `## bawaan`).
   - Urutkan entri alfabetis berdasarkan path skill di dalam setiap kategori.

5. **Format entri indeks.**
   Setiap entri menggunakan format:
   ```
   1. <path skill>
   - Trigger : <isi trigger>
   - Status : diperbarui : <metadata.diperbarui>
   ```

6. **Tangani skill bawaan.**
   - Baca `installedAt` baris pertama dari `.config/dart_skills/skills_config.json`.
   - Konversi dari UTC ke Asia/Jakarta (`TZ=Asia/Jakarta date -d <timestamp>`).
   - Bandingkan dengan `metadata.diperbarui` di indeks; jika lebih baru, perbarui skill folder `bawaan` saja dan sinkronkan indeks.

7. **Validasi anomali (WAJIB).**
   Deteksi dan klasifikasikan anomali menjadi dua tingkat:

   **A. Anomali serius — MENGHENTIKAN (jangan tulis indeks):**
   - **Di luar kategori standar**: skill tidak berada di `.agents/skills/bawaan/` maupun `.agents/skills/custom/` (mis. langsung di `.agents/skills/<nama>/`).
   - **Konflik kategori**: folder fisik berbeda dengan nilai `metadata.kategori` (mis. folder `bawaan` tetapi `metadata.kategori: "custom"`).
   - **Fatal**: folder `.agents/skills/` tidak dapat dibaca, atau tidak ada satu pun `SKILL.md` ditemukan.

    **B. Anomali ringan — hanya peringatan (tetap lanjut):**
    - **Metadata kategori kosong**: skill tidak memiliki field `metadata.kategori`. Ini **wajar** untuk skill bawaan (sebelum migrasi front matter Kelompok 34), jadi tidak menghentikan proses.
    - **Description tanpa `Trigger:`**: skill tidak diawali penanda literal `Trigger:` pada `description` (konvensi `aturan_skill.md` §8.2), sehingga ekstraksi trigger jatuh ke penanda `perlu dilengkapi trigger`.

8. **Ambil keputusan berdasarkan tingkat anomali (WAJIB).**
   - Jika ada anomali serius/fatal: **STOP**. Cetak daftar anomali + ringkasan, **JANGAN menulis `SKILLS_INDEX.md`**, dan akhiri dengan status gagal.
   - Jika hanya ada anomali ringan: lanjutkan penulisan indeks sambil mencatat peringatan.

9. **Laporkan hasil (WAJIB).**
   - Cetak ringkasan: total skill dan jumlah per kategori.
   - Cetak daftar anomali (path file + jenis anomali + tingkat: serius/ringan) bila ada.
   - Bila tidak ada anomali, cetak "Tidak ada anomali".
   - DILARANG diam ketika daftar anomali tidak kosong.

10. **Tulis SKILLS_INDEX.md.** (hanya bila tidak ada anomali serius/fatal)
    - Simpan di root proyek (`SKILLS_INDEX.md`).
    - Gunakan format waktu baku Asia/Jakarta untuk semua timestamp.

11. **Validasi akhir.**
    - Pastikan `SKILLS_INDEX.md` hanya memuat trigger (bukan cakupan/larangan/workflow).
    - Pastikan `SKILL.md` tetap menjadi sumber kebenaran (wajib di-load sebelum mengerjakan tugas).
    - Pastikan jumlah entri indeks sama dengan jumlah `SKILL.md` yang dipindai (tidak ada yang hilang).

# Ketentuan Penulisan

1. **Bahasa:** Seluruh isi indeks wajib menggunakan bahasa Indonesia.
2. **Format waktu:** Wajib menggunakan output `TZ=Asia/Jakarta date` (contoh: `Wed Nov 11 2026 23:30:00 WIB`).
3. **Trigger:** Hanya ekstrak "kapan/untuk apa di-load", jangan salin seluruh `description`.
4. **Urutan:** Alfabetis per folder/kategori.
5. **Kategori:** Selalu dari folder fisik, bukan dari `metadata.kategori`.

# Larangan

1. Dilarang mengubah file `SKILL.md` selama proses scan (hanya baca).
2. Dilarang mencantumkan cakupan, larangan, atau workflow di indeks — hanya trigger.
3. Dilarang mengarang trigger jika tidak ditemukan; wajib tulis `perlu dilengkapi trigger`.
4. Dilarang mengubah file lain di luar `SKILLS_INDEX.md`.
5. Dilarang menentukan kategori dari `metadata.kategori` (kategori wajib dari folder fisik).
6. Dilarang melewatkan pelaporan anomali atau menampilkan hasil seolah normal ketika ada anomali.
7. Dilarang menulis `SKILLS_INDEX.md` ketika terdapat anomali serius/fatal (perintah wajib berhenti).

# Batasan Ruang Lingkup

1. Pekerjaan hanya mencakup pembuatan/memperbarui `SKILLS_INDEX.md` dari `SKILL.md` yang ada.
2. Tidak membuat, mengubah, atau menghapus file `SKILL.md`.
3. Jika `metadata.diperbarui` atau `metadata.sumber-terakhir` belum ada pada `SKILL.md`, catat di indeks dan lanjutkan; tidak menghentikan proses.
4. Anomali **ringan** (mis. `metadata.kategori` kosong) dilaporkan tetapi tidak menghentikan penulisan indeks. Anomali **serius/fatal** (di luar `bawaan`/`custom`, konflik kategori, folder tak terbaca, tidak ada `SKILL.md`) **menghentikan** perintah dan tidak menulis indeks.

# Hasil Akhir

Setelah selesai:
1. `SKILLS_INDEX.md` di root proyek berisi indeks seluruh skill.
2. Setiap kategori memiliki heading sendiri (`## custom`, `## bawaan`, dll.).
3. Entri diurutkan alfabetis per kategori.
4. Format waktu menggunakan Asia/Jakarta.
5. Trigger diekstrak dengan benar dalam bahasa Indonesia.
6. Pengguna menerima laporan anomali (atau "Tidak ada anomali") dan ringkasan jumlah per kategori.