# Mode Diskusi

## 1. Tujuan

Mode ini digunakan untuk mendampingi pengguna dalam diskusi terfokus dan mendokumentasikan hasil diskusi ke dalam berkas hasil diskusi yang terstruktur.

## 2. Aturan Diskusi

1. Fokus hanya pada diskusi. Jangan melakukan implementasi, perubahan kode, atau tindakan di luar kebutuhan diskusi, kecuali diminta secara eksplisit sesuai konteks diskusi.
2. Selalu fokus pada topik yang sedang dibicarakan. Hindari pembahasan yang tidak relevan.
3. Selama diskusi, model WAJIB menggunakan bahasa Indonesia.
4. Model WAJIB memberikan saran atau rekomendasi yang relevan kepada pengguna terkait topik yang dibicarakan, sebelum atau bersama-sama dengan menjawab pertanyaan pengguna.
5. **Skill wajib mode diskusi** (muat sebelum mengerjakan bagian mana pun dari mode ini): `memori-check` (baca `MEMORI.md` sebelum diskusi dan perbarui setelahnya; setiap sesi wajib dicatat di berkas sesi `memori/sesi/sesi_N.md` — lihat skill), `penggunaan-tool-question` (bertanya kepada pengguna), dan aturan `.agents/rules/global/format_hasil_diskusi.md` (struktur, penamaan, dan penomoran berkas `diskusi_N.md`). Untuk diskusi yang membahas skill/`SKILL.md`, muat juga skill `aturan-pembuatan-skill`.

## 3. Aturan File Hasil Diskusi

1. Seluruh ketentuan lokasi, penamaan, dan penomoran berkas hasil diskusi **WAJIB** mengikuti `.agents/rules/global/format_hasil_diskusi.md`.
2. Setiap hasil diskusi WAJIB didokumentasikan dalam file baru di folder `hasil_diskusi/`.
3. Semua file hasil diskusi WAJIB disimpan di folder `hasil_diskusi/` (bukan di lokasi lain).
4. Nama file WAJIB menggunakan format `diskusi_N.md` dan disimpan sebagai `hasil_diskusi/diskusi_N.md` (contoh: `hasil_diskusi/diskusi_1.md`, `hasil_diskusi/diskusi_2.md`).
5. Penentuan nomor file:
   - Jika folder `hasil_diskusi/` kosong (belum ada file `diskusi_N.md`), buat `hasil_diskusi/diskusi_1.md`.
   - Jika sudah ada file, cari nomor tertinggi dari semua file `diskusi_N.md` di folder `hasil_diskusi/`, lalu buat file baru `hasil_diskusi/diskusi_<tertinggi+1>.md` (contoh: tertinggi `diskusi_11.md` → buat `hasil_diskusi/diskusi_12.md`).
   - Jika terdapat nomor yang terlewat (gap), tetap gunakan nomor `tertinggi + 1`. Jangan mengisi gap.

## 4. Struktur dan Isi File Hasil Diskusi

1. Struktur dan isi berkas hasil diskusi **WAJIB** mengikuti `.agents/rules/global/format_hasil_diskusi.md`.
2. Berkas hasil diskusi **BUKAN** dokumen PRD. **DILARANG** memakai struktur PRD (bagian "Konteks penggunaan", "Aturan pengisian", atau 6 bagian PRD) untuk berkas hasil diskusi.
3. Bagian wajib berurutan: `## Status`, `## Latar Belakang`, `## Poin Diskusi`, `## Keputusan`, `## Rekomendasi`, `## Tindak Lanjut`, `## File Terdampak`, `## Pertanyaan Terbuka`, dan `## Riwayat Perubahan`; judul dan urutan **persis** mengikuti aturan.
4. Penyesuaian status untuk mode diskusi:
   - `Dokumen` pada `## Status` WAJIB diisi salah satu dari: `Draft`, `Batal`, atau `Final` sesuai status hasil diskusi.
   - `Implementasi` pada `## Status` diisi sesuai kondisi aktual; jika belum diketahui atau belum relevan, tandai secara jelas tanpa mengarang.
5. Seluruh isi WAJIB didasarkan pada hasil diskusi dan informasi proyek yang diketahui. DILARANG mengarang informasi.
6. Jika suatu bagian belum dibahas, belum diputuskan, atau informasinya belum tersedia, isi bagian tersebut dengan keterangan yang jelas (misalnya "Belum dibahas" atau "Belum diketahui") sesuai konteks, dan jangan menebak.
7. Keputusan, tindak lanjut, dan poin penting dari diskusi WAJIB tercermin pada bagian `## Keputusan` dan `## Tindak Lanjut` agar hasil diskusi dapat ditindaklanjuti oleh `kerjakan_hasil_diskusi.md`.
8. Setelah berkas dibuat, diperbarui, atau dihapus, WAJIB perbarui `MEMORI.md` pada bagian `Lokasi Hasil Diskusi` dan `Riwayat Diskusi`, serta tambahkan entri pada `memori/riwayat_perubahan.md` — melalui alur berkas sesi (`memori/sesi/sesi_N.md`, status `Belum Sinkron` → `Sudah Sinkron`) sesuai skill `memori-check`; berkas sesi **tidak boleh dihapus**.
9. Bagian `## Pertanyaan Terbuka` WAJIB diperbarui setiap kali status atau isi berkas berubah: pertanyaan terjawab WAJIB dihapus dari daftar dan dicatat sebagai jejak di `## Riwayat Perubahan` (mis. "Pertanyaan terbuka ditutup: <ringkasan> — <jawaban singkat> (<tanggal>)"); bila tidak ada pertanyaan terbuka, tulis `Belum ada`.

## 5. Aturan Penggunaan Tool `question`

1. Ketika model perlu bertanya, meminta klarifikasi, atau meminta keputusan/input dari pengguna, model WAJIB menggunakan tool `question`.
2. Setiap pertanyaan yang dikirim melalui tool `question` WAJIB:
   - Memiliki `header` singkat (maksimal 30 karakter).
   - Menyediakan opsi jawaban yang jelas, masing-masing dengan deskripsi.
   - Menghindari pilihan yang ambigu atau membingungkan.
   - Meminta input secara langsung melalui format tool `question` (bukan sekadar pertanyaan di teks biasa).
3. Jika suatu jawaban atau keputusan bergantung pada input pengguna, model DILARANG memberikan jawaban final atau mengambil keputusan tersebut tanpa terlebih dahulu meminta input melalui tool `question`.
