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