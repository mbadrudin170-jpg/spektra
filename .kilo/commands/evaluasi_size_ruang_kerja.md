---
description: Audit kapasitas disk Linux, temukan file dan direktori terbesar, klasifikasikan berdasarkan tingkat keamanan penghapusan, dan tampilkan rekomendasi tanpa menghapus file.
---

# MODE: AUDIT KAPASITAS DAN KEAMANAN PENYIMPANAN

## A. Tujuan

Lakukan pemeriksaan ruang penyimpanan pada lingkungan Linux untuk mengetahui:

1. Total kapasitas penyimpanan.
2. Ruang yang sudah digunakan.
3. Ruang yang masih tersedia.
4. Persentase penggunaan kapasitas.
5. Filesystem yang hampir penuh.
6. Direktori yang paling banyak menggunakan ruang.
7. File individual yang memiliki ukuran paling besar.
8. File tersembunyi dan direktori tersembunyi yang menggunakan banyak ruang.
9. File dan direktori yang relatif aman untuk dibersihkan.
10. File dan direktori yang berisiko apabila dihapus.

**Tujuan akhir:** Berikan daftar file dan direktori beserta ukuran, lokasi, fungsi, serta tingkat keamanan penghapusannya agar pengguna dapat menentukan sendiri apa yang ingin dibersihkan.

## B. Batasan dan Larangan

1. Pemeriksaan hanya boleh membaca informasi penyimpanan dan ukuran file.
2. Dilarang menghapus file atau direktori apa pun.
3. Dilarang memindahkan atau mengubah file.
4. Dilarang membersihkan cache secara otomatis.
5. Dilarang menjalankan perintah yang menyebabkan penghapusan data, seperti `rm`, `rm -r`, `rm -f`, dan `rm -rf`.
6. Dilarang menjalankan `flutter clean`, `git clean`, `docker system prune`, atau perintah pembersihan lainnya.
7. Dilarang menganggap file besar sebagai file tidak berguna hanya berdasarkan ukuran atau namanya.
8. Dilarang menganggap semua cache aman dihapus.
9. Dilarang menghapus file meskipun sudah dikategorikan sebagai aman.
10. Jangan meminta konfirmasi untuk melakukan pembersihan. Command ini hanya bertugas melakukan audit dan membuat laporan.
11. Jangan menggunakan `sudo` untuk memaksakan akses pemeriksaan.
12. Apabila terdapat file yang tidak dapat diperiksa, sampaikan keterbatasannya secara jelas.

## C. Tahapan Pemeriksaan

### Tahap 1 — Memeriksa Kapasitas Filesystem

Jalankan:

```bash
df -h
```

Tujuan:

- Mengetahui total kapasitas.
- Mengetahui kapasitas terpakai.
- Mengetahui kapasitas tersedia.
- Mengetahui persentase penggunaan.
- Mengetahui lokasi mount point.

Kemudian jalankan:

```bash
df -hT
```

Untuk mengetahui jenis filesystem.

Periksa secara khusus lokasi home dan workspace:

```bash
df -h "$HOME" "$PWD"
```

Periksa juga penggunaan inode:

```bash
df -ih
```

Ketentuan:

- Identifikasi filesystem yang digunakan oleh `$HOME` dan `$PWD`.
- Jangan menghitung filesystem yang sama sebagai dua kapasitas berbeda.
- Jika terdapat filesystem yang hampir penuh, prioritaskan filesystem tersebut.
- Jangan hanya melihat persentase penggunaan. Perhatikan juga jumlah ruang yang masih tersedia.
- Jika inode hampir habis, jelaskan kondisi tersebut secara terpisah.

### Tahap 2 — Memeriksa Direktori Home

Direktori home merupakan prioritas utama pemeriksaan.

Gunakan:

```bash
du -xhd1 "$HOME" 2>/dev/null | sort -h
```

Ketentuan:

- Periksa seluruh direktori tingkat pertama.
- Sertakan direktori tersembunyi.
- Urutkan berdasarkan ukuran.
- Identifikasi direktori terbesar.
- Lakukan pemeriksaan lanjutan terhadap subdirektori yang paling besar.
- Jangan hanya memeriksa satu tingkat direktori.
- Gunakan `-x` agar pemeriksaan tidak melintasi filesystem lain.

Perhatikan lokasi seperti:

- `.cache`
- `.pub-cache`
- `.gradle`
- `.config`
- `.local`
- `.npm`
- `.dart`
- Flutter SDK.
- Dart SDK.
- Android SDK.
- Direktori proyek.
- Direktori backup dan arsip.
- Direktori lainnya yang ditemukan menggunakan banyak ruang.

Daftar tersebut hanya merupakan lokasi yang perlu diperhatikan apabila tersedia, bukan asumsi bahwa semuanya ada.

### Tahap 3 — Memeriksa Workspace Proyek

Gunakan:

```bash
du -xhd1 "$PWD" 2>/dev/null | sort -h
```

Periksa direktori yang paling besar secara bertahap.

Perhatikan:

- `build/`
- `.dart_tool/`
- `.git/`
- `node_modules/`
- Direktori hasil kompilasi.
- Dependency proyek.
- Database.
- File backup.
- File arsip.
- File lain yang berukuran besar.

Jika workspace berada di dalam home, hindari menghitung atau menampilkan data yang sama berulang kali.

Jika workspace berada pada filesystem berbeda, lakukan pemeriksaan secara terpisah.

### Tahap 4 — Mencari File Terbesar di Home

Wajib melakukan pencarian secara rekursif.

Gunakan:

```bash
find "$HOME" -xdev -type f -printf '%s\t%p\n' 2>/dev/null | sort -nr | head -n 30
```

Ketentuan:

1. Temukan maksimal 30 file individual terbesar.
2. Urutkan dari ukuran terbesar ke terkecil.
3. Tampilkan nama file.
4. Tampilkan ukuran setiap file.
5. Tampilkan path lengkap.
6. Sertakan file tersembunyi.
7. Jangan membatasi pencarian berdasarkan ekstensi.
8. Jangan mengabaikan file arsip, database, backup, atau log.
9. Jangan mengikuti symbolic link.
10. Jika ada filesystem lain yang ter-mount di dalam home, periksa secara terpisah apabila relevan.

Ukuran yang diperoleh dari `find` menggunakan satuan byte. Ubah menjadi KB, MB, GB, atau TB agar mudah dibaca pengguna.

### Tahap 5 — Mencari File Terbesar di Workspace

Jika workspace berada di luar home, lakukan pemeriksaan:

```bash
find "$PWD" -xdev -type f -printf '%s\t%p\n' 2>/dev/null | sort -nr | head -n 30
```

Tampilkan maksimal 30 file terbesar.

Jika workspace berada di dalam home, gunakan hasil pemeriksaan home dan hindari duplikasi.

### Tahap 6 — Pemeriksaan Lanjutan pada Direktori Terbesar

Jika ditemukan direktori yang menggunakan ruang sangat besar:

1. Periksa subdirektori di dalamnya.
2. Identifikasi file yang paling banyak menghabiskan ruang.
3. Periksa fungsi direktori dan file tersebut.
4. Tentukan apakah isinya berupa data pengguna, source code, cache, hasil build, atau dependency.
5. Tentukan apakah isinya dapat dibuat kembali atau merupakan data yang harus dipertahankan.

Jangan langsung mengategorikan seluruh direktori berdasarkan nama foldernya.

Contoh:

- `.cache` dapat berisi beberapa jenis data dengan tingkat kepentingan berbeda.
- `.gradle` dapat berisi cache yang dapat diunduh ulang maupun konfigurasi penting.
- `build/` dapat berisi hasil kompilasi dan APK yang masih dibutuhkan pengguna.
- Folder proyek dapat berisi source code, database, dan hasil build sekaligus.

Karena itu, evaluasi isi dan fungsi sebelum menentukan tingkat keamanan penghapusan.

## D. Klasifikasi Tingkat Keamanan Penghapusan

Setelah menemukan file dan direktori yang menggunakan banyak ruang, kelompokkan berdasarkan empat tingkatan berikut.

Urutan kategori wajib dimulai dari tingkat yang relatif paling aman dibersihkan hingga yang paling berisiko dihapus.

### LEVEL 1 — Risiko Paling Rendah

<badge color="success">Prioritas pemeriksaan pertama</badge>

Kandidat file atau direktori yang umumnya dapat dibuat kembali dan tidak mengandung data pengguna yang perlu dipertahankan.

Contoh:

- File sementara yang sudah tidak digunakan.
- File hasil build yang sudah tidak dibutuhkan.
- Hasil kompilasi sementara.
- Artefak pengembangan yang dapat dibuat kembali dari source code.

Syarat:

1. Pastikan file benar-benar merupakan hasil generate atau file sementara.
2. Pastikan tidak sedang digunakan oleh proses aktif.
3. Pastikan file bukan satu-satunya salinan hasil pekerjaan yang dibutuhkan pengguna.
4. Pastikan file dapat dibuat kembali.
5. Jika syarat tersebut tidak dapat dipastikan, turunkan kategorinya.

### LEVEL 2 — Relatif Aman dengan Syarat

<badge color="info">Perlu pemeriksaan tambahan</badge>

File atau direktori yang umumnya dapat dipulihkan, tetapi penghapusannya dapat menyebabkan proses pengunduhan ulang, instalasi ulang, atau konfigurasi kembali.

Contoh:

- `.pub-cache`
- `.gradle/caches`
- Cache npm.
- Cache pip.
- Cache package manager lainnya.
- `node_modules`, apabila dependency dan lockfile tersedia.
- `.dart_tool`, apabila metadata dan konfigurasi proyek dapat dibuat kembali.
- Cache aplikasi lainnya.

Syarat:

1. Pastikan fungsi dan isi direktori.
2. Periksa apakah data dapat diperoleh kembali.
3. Pertimbangkan kebutuhan koneksi internet.
4. Pertimbangkan waktu untuk mengunduh atau membangun ulang.
5. Pastikan tidak ada data khusus atau perubahan lokal yang perlu dipertahankan.

Jangan langsung merekomendasikan penghapusan seluruh cache apabila hanya sebagian yang menggunakan ruang besar.

### LEVEL 3 — Risiko Tinggi atau Belum Dapat Dipastikan

<badge color="warning">Jangan prioritaskan penghapusan</badge>

File atau direktori yang fungsi, kepentingan, atau kebutuhan pemulihannya belum dapat dipastikan.

Contoh:

- File backup.
- Arsip yang belum diketahui isinya.
- File database.
- Direktori proyek lama.
- File log yang mungkin masih diperlukan untuk investigasi.
- File konfigurasi khusus.
- File dengan fungsi yang belum teridentifikasi.
- Data aplikasi yang tidak jelas apakah masih digunakan.

Ketentuan:

- Jangan menganggap file tidak diperlukan hanya karena sudah lama.
- Jangan menyarankan penghapusan tanpa memahami kegunaannya.
- Tampilkan alasan mengapa file tersebut berisiko dihapus.
- Apabila fungsinya belum diketahui, tuliskan secara eksplisit bahwa statusnya belum dapat dipastikan.

### LEVEL 4 — Sangat Berisiko dan Wajib Dipertahankan

<badge color="danger">Jangan rekomendasikan penghapusan</badge>

File dan direktori yang berpotensi menyebabkan kerusakan proyek, kehilangan data, kehilangan konfigurasi, atau gangguan sistem apabila dihapus.

Contoh:

- Source code.
- Direktori `.git`.
- Database utama.
- File `.env`.
- SSH key.
- Credential dan token autentikasi.
- Konfigurasi sistem.
- Konfigurasi aplikasi penting.
- Flutter SDK.
- Dart SDK.
- Android SDK.
- File sistem operasi.
- File proyek yang menjadi satu-satunya salinan pekerjaan.

Ketentuan:

- Jangan merekomendasikan penghapusan.
- Jangan mengategorikannya sebagai aman hanya karena ditemukan berukuran besar.
- Jelaskan fungsi dan risiko apabila diketahui.
- Jika file mengandung kredensial, jangan tampilkan isi atau nilai rahasianya. Cukup tampilkan path dan ukuran.

**Catatan klasifikasi:**

- Tingkat keamanan tidak boleh ditentukan hanya berdasarkan nama file atau direktori.
- Satu direktori dapat memiliki isi dengan tingkat keamanan berbeda.
- Apabila tingkat keamanannya belum dapat dipastikan, tempatkan pada Level 3 atau Level 4 apabila terdapat indikasi data penting.
- Jangan menurunkan tingkat risiko hanya agar suatu file terlihat layak dihapus.
- Level 1 bukan izin untuk langsung menghapus file. Semua kategori hanya merupakan hasil evaluasi.

## E. Format Laporan

Hasil pemeriksaan wajib disajikan dengan format berikut.

# LAPORAN AUDIT PENYIMPANAN

## 1. Ringkasan Kapasitas

| Filesystem |    Total | Terpakai | Tersedia | Penggunaan | Status   |
| ---------- | -------: | -------: | -------: | ---------: | -------- |
| [Path]     | [Ukuran] | [Ukuran] | [Ukuran] |        [%] | [Status] |

Gunakan status:

- Normal.
- Perlu diperhatikan.
- Hampir penuh.
- Kritis.
- Penuh.

## 2. Direktori Terbesar di Home

| Peringkat | Direktori      |   Ukuran | Keterangan |
| --------- | -------------- | -------: | ---------- |
| 1         | [Path lengkap] | [Ukuran] | [Fungsi]   |
| 2         | [Path lengkap] | [Ukuran] | [Fungsi]   |

Urutkan dari terbesar ke terkecil.

## 3. File Terbesar

| Peringkat | Nama File   |   Ukuran | Path Lengkap   |
| --------- | ----------- | -------: | -------------- |
| 1         | [Nama file] | [Ukuran] | [Path lengkap] |
| 2         | [Nama file] | [Ukuran] | [Path lengkap] |

Tampilkan maksimal 30 file terbesar untuk setiap cakupan filesystem yang diperiksa.

## 4. Klasifikasi Berdasarkan Keamanan Penghapusan

Urutkan laporan mulai dari Level 1 sampai Level 4.

### LEVEL 1 — Risiko Paling Rendah

| No. | File/Direktori |   Ukuran | Path Lengkap | Alasan   |
| --- | -------------- | -------: | ------------ | -------- |
| 1   | [Nama]         | [Ukuran] | [Path]       | [Alasan] |

### LEVEL 2 — Relatif Aman dengan Syarat

Gunakan format tabel yang sama.

### LEVEL 3 — Risiko Tinggi atau Belum Dapat Dipastikan

Gunakan format tabel yang sama.

### LEVEL 4 — Sangat Berisiko dan Wajib Dipertahankan

Gunakan format tabel yang sama.

**Ketentuan pengurutan:**

- Tingkat keamanan lebih diutamakan daripada ukuran.
- Dalam setiap level, urutkan file dan direktori dari ukuran terbesar ke terkecil.
- Cantumkan ukuran dan path lengkap.
- Jangan mencampur file dari tingkat keamanan berbeda.
- Jangan menyembunyikan file besar hanya karena tidak aman dihapus.
- Jika tidak ditemukan kandidat dalam suatu level, tuliskan bahwa tidak ada temuan.

## 5. Potensi Penghematan Ruang

Buat estimasi berdasarkan kandidat pada Level 1 dan Level 2.

| Tingkat | Jumlah Kandidat | Total Ukuran | Keterangan   |
| ------- | --------------: | -----------: | ------------ |
| Level 1 |        [Jumlah] |     [Ukuran] | [Keterangan] |
| Level 2 |        [Jumlah] |     [Ukuran] | [Keterangan] |

Ketentuan:

- Jangan menghitung ukuran direktori dan seluruh isinya secara bersamaan karena dapat menyebabkan penghitungan ganda.
- Jangan menjumlahkan file yang saling bertumpang tindih.
- Tandai estimasi yang belum dapat dipastikan.
- Bedakan total ukuran kandidat dengan penghematan aktual yang benar-benar bisa diperoleh.
- Jangan mengklaim ruang sudah berhasil dihemat.

## 6. Rekomendasi

Berikan rekomendasi berdasarkan hasil audit.

Prioritaskan:

1. Kandidat Level 1 dengan ukuran terbesar.
2. Kandidat Level 1 lainnya.
3. Kandidat Level 2 yang manfaat penghematannya besar.
4. Hindari rekomendasi penghapusan Level 3 dan Level 4.

Untuk setiap rekomendasi, jelaskan:

- Path lengkap.
- Ukuran.
- Fungsi file atau direktori.
- Alasan layak dipertimbangkan.
- Risiko apabila dihapus.
- Cara memperoleh kembali apabila file tersebut dapat dibuat atau diunduh ulang.

Jangan menjalankan rekomendasi tersebut.

## 7. Kesimpulan

Jawab pertanyaan berikut:

1. Berapa kapasitas penyimpanan yang masih tersedia?
2. Filesystem mana yang paling membutuhkan perhatian?
3. Direktori apa yang paling banyak menggunakan ruang?
4. File apa yang paling besar?
5. File mana yang paling aman untuk dipertimbangkan dibersihkan?
6. Berapa potensi penghematan berdasarkan kandidat Level 1 dan Level 2?
7. Apakah terdapat file yang wajib dipertahankan?

## F. Ketentuan Akhir

Sebelum menyelesaikan audit:

1. Pastikan `df -h` sudah dijalankan.
2. Pastikan direktori home sudah diperiksa secara menyeluruh.
3. Pastikan file tersembunyi sudah disertakan.
4. Pastikan workspace sudah diperiksa.
5. Pastikan file terbesar sudah ditemukan dan diurutkan.
6. Pastikan ukuran setiap file ditampilkan dengan benar.
7. Pastikan seluruh kandidat sudah diklasifikasikan berdasarkan tingkat keamanan penghapusan.
8. Pastikan file yang belum diketahui fungsinya tidak dikategorikan sebagai aman.
9. Pastikan tidak ada file atau direktori yang dihapus maupun dimodifikasi.
10. Pastikan laporan tidak menghitung ukuran yang sama berulang kali.

**PENTING: Setelah audit selesai, berhenti pada tahap pelaporan. Tampilkan seluruh hasil kepada pengguna dan tunggu instruksi terpisah apabila pengguna ingin melakukan pembersihan. Jangan pernah menghapus file secara otomatis, termasuk file yang masuk Level 1.**
