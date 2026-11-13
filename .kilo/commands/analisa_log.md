---
description: Analisis hasil log dengan mencocokkan output terhadap data dummy, menemukan ketidaksesuaian nilai, dan menyimpan temuan ke saran.md tanpa mengubah kode Dart.
agent: code
---

# ANALISIS LOG — PEMERIKSAAN DATA DUMMY DAN IDENTIFIKASI BUG

## 1. Tujuan

Saya akan memberikan hasil log aplikasi kepada Anda.

Tugas Anda adalah menganalisis log tersebut dengan cara mencocokkan setiap nilai yang relevan terhadap data dummy yang digunakan oleh aplikasi.

Karena aplikasi menggunakan data dummy, Anda dapat memeriksa nilai sumber secara langsung dan menentukan nilai yang seharusnya dihasilkan oleh aplikasi.

Tujuan utama analisis ini adalah:

1. Mengetahui apakah output log sudah sesuai dengan data dummy.
2. Mengidentifikasi nilai yang berbeda dari nilai yang seharusnya.
3. Menelusuri kode yang menyebabkan ketidaksesuaian tersebut.
4. Menentukan kandidat bug berdasarkan bukti yang ditemukan.
5. Menyimpan seluruh hasil analisis dan saran perbaikan ke `saran.md`.

**PENTING: Ini adalah tahap analisis, bukan tahap implementasi perbaikan.**

## 2. Batasan Pekerjaan

Selama menjalankan command ini, patuhi batasan berikut:

1. DILARANG mengubah kode Dart.
2. DILARANG memperbaiki bug secara langsung.
3. DILARANG mengubah data dummy.
4. DILARANG mengubah konfigurasi proyek.
5. DILARANG melakukan refactoring.
6. DILARANG mengubah `task.md` atau file aturan proyek.
7. DILARANG mengubah file lain selain `saran.md`.

Satu-satunya file yang boleh dibuat atau diperbarui adalah:

`saran.md`

Anda diperbolehkan membaca kode Dart, data dummy, aturan proyek, dan file lain yang relevan untuk keperluan analisis.

Anda juga diperbolehkan menggunakan pencarian kode dan perintah pemeriksaan yang bersifat read-only.

Jangan menjalankan perintah yang dapat mengubah kode, data, konfigurasi, atau menghasilkan perubahan otomatis pada proyek.

## 3. Persiapan Analisis

Sebelum menganalisis log:

1. Baca `AGENTS.md` terlebih dahulu.
2. Baca aturan proyek lain yang relevan dengan bagian kode yang sedang diperiksa.
3. Pahami fitur atau proses yang menghasilkan log tersebut.
4. Identifikasi file data dummy yang digunakan oleh fitur tersebut.
5. Identifikasi file kode Dart yang memproses data dummy hingga menghasilkan output log.

Jangan langsung menyimpulkan bahwa suatu nilai salah sebelum memahami alur pemrosesan datanya.

Jika log tidak diberikan atau informasi penting tidak mencukupi untuk menentukan skenario yang diperiksa, sampaikan informasi yang masih diperlukan. Jangan membuat data atau asumsi sendiri.

## 4. Cocokkan Log dengan Data Dummy

Ini merupakan bagian terpenting dari pekerjaan Anda.

Cari data dummy yang benar-benar berkaitan dengan log yang diberikan.

Jangan mengambil data dummy secara sembarangan. Pastikan data yang digunakan memang sesuai dengan skenario yang sedang diperiksa.

Gunakan informasi seperti:

- ID data.
- Nama atau identitas data.
- Parameter input.
- Jumlah data.
- Nilai nominal.
- Status.
- Tanggal.
- Relasi antar-data.
- Informasi lain yang terdapat dalam log.

Setelah menemukan data yang sesuai, lakukan pemeriksaan berikut:

1. Baca nilai asli yang tersimpan dalam data dummy.
2. Periksa apakah nilai tersebut mengalami perubahan selama pemrosesan.
3. Periksa perhitungan atau transformasi yang dilakukan oleh kode.
4. Tentukan nilai yang seharusnya dihasilkan berdasarkan data dummy dan aturan bisnis.
5. Cocokkan nilai yang seharusnya tersebut dengan nilai aktual pada log.

Jangan hanya mengandalkan hasil dari kode yang sedang diperiksa untuk menentukan nilai yang benar.

Hitung atau verifikasi nilai yang diharapkan berdasarkan data sumber dan aturan bisnis yang berlaku.

## 5. Prioritas Utama: Ketidaksesuaian Nilai

**Setiap ketidaksesuaian antara nilai yang seharusnya dengan nilai aktual WAJIB dijadikan Kandidat Utama.**

Contoh:

Data dummy:

- Harga barang: Rp10.000.
- Jumlah barang: 3.
- Diskon: Rp5.000.

Nilai yang diharapkan:

- Total sebelum diskon: Rp30.000.
- Total setelah diskon: Rp25.000.

Output log:

- Total sebelum diskon: Rp30.000.
- Total setelah diskon: Rp20.000.

Hasil analisis:

- Data dummy sudah sesuai.
- Perhitungan yang seharusnya menghasilkan Rp25.000.
- Output log menunjukkan Rp20.000.
- Terdapat selisih Rp5.000.
- Ketidaksesuaian tersebut wajib dimasukkan sebagai Kandidat Utama.

Dalam kasus seperti ini, jangan hanya menuliskan bahwa terdapat kemungkinan kesalahan perhitungan.

Telusuri kode yang melakukan perhitungan tersebut dan cari penyebab selisihnya.

### Ketentuan Prioritas

Urutan pemeriksaan dan pelaporan:

1. **Kandidat Utama:** Output log tidak sesuai dengan nilai yang seharusnya berdasarkan data dummy.
2. **Kandidat Berikutnya:** Kesalahan logika pemrosesan, relasi data, filter, pengurutan, atau transformasi data.
3. **Kandidat Tambahan:** Kesalahan kondisi, nilai null, duplikasi data, data hilang, atau ketidaksesuaian lainnya.
4. **Informasi Tambahan:** Hal mencurigakan yang belum memiliki bukti cukup untuk dinyatakan sebagai bug.

Jangan menurunkan prioritas ketidaksesuaian nilai hanya karena terdapat temuan lain yang lebih mudah ditemukan.

## 6. Telusuri Penyebab Ketidaksesuaian

Jika menemukan ketidaksesuaian, lanjutkan pemeriksaan terhadap kode Dart yang berkaitan.

Telusuri alur pemrosesan dari sumber data hingga menghasilkan output log.

Periksa kemungkinan:

- Nilai tertukar.
- Perhitungan salah.
- Data yang digunakan tidak sesuai.
- Filter menghasilkan data yang salah.
- Relasi data tidak sesuai.
- Data terhitung dua kali.
- Data tidak terhitung.
- Nilai awal tertimpa.
- Konversi tipe data bermasalah.
- Pembulatan tidak sesuai.
- Kondisi logika tidak sesuai.
- Data cache tidak sesuai dengan data sumber.
- Kesalahan urutan pemrosesan.
- Nilai yang dikirim ke proses berikutnya sudah berbeda dari nilai sebelumnya.

Jangan langsung menetapkan penyebab hanya berdasarkan dugaan.

Pisahkan:

- Fakta yang sudah terbukti.
- Indikasi yang ditemukan.
- Dugaan penyebab.
- Informasi yang masih perlu diperiksa.

Jika penyebab belum dapat dipastikan, tuliskan sebagai dugaan dan jelaskan bukti apa yang masih diperlukan.

## 7. Format Pencatatan Temuan

Setiap temuan harus mempunyai informasi yang cukup agar nantinya dapat digunakan untuk memperbaiki kode.

Gunakan format berikut:

### [Nomor] Nama Temuan

**Prioritas:** Kandidat Utama / Kandidat Berikutnya / Kandidat Tambahan

**Status:** Terbukti / Indikasi Kuat / Belum Terverifikasi

**Lokasi:**

- File:
- Baris kode:
- Bagian kode yang berkaitan:

**Data Dummy:**

- Identitas data:
- Nilai sumber:

**Nilai yang Diharapkan:**

- Nilai:
- Dasar perhitungan atau aturan bisnis:

**Output Aktual:**

- Nilai yang muncul pada log:

**Selisih:**

- Besar selisih jika dapat dihitung.
- Jenis ketidaksesuaian.

**Bukti Log:**

- Potongan log yang membuktikan temuan.

**Analisis Penyebab:**

- Penjelasan alur pemrosesan.
- Bagian kode yang berpotensi menyebabkan masalah.
- Bukti yang mendukung kesimpulan.

**Saran Perbaikan:**

- Penjelasan perubahan yang perlu dilakukan.
- Lokasi kode yang perlu diperiksa atau diperbaiki.
- Hasil yang seharusnya diperoleh setelah perbaikan.

**Catatan Pengujian:**

- Skenario yang perlu diuji kembali.
- Nilai yang seharusnya muncul setelah perbaikan.

Jangan mengisi informasi yang belum diketahui dengan asumsi. Tuliskan secara jelas apabila informasi tidak tersedia atau belum dapat diverifikasi.

## 8. Penyimpanan Hasil ke saran.md

Setelah analisis selesai, simpan hasilnya ke:

`saran.md`

Ketentuan:

1. Jika `saran.md` belum ada, buat file tersebut di root proyek.
2. Jika sudah ada, baca isinya terlebih dahulu.
3. Pertahankan temuan sebelumnya yang masih relevan.
4. Perbarui temuan lama apabila analisis terbaru memberikan bukti tambahan.
5. Jangan membuat temuan duplikat.
6. Letakkan Kandidat Utama di bagian paling atas.
7. Urutkan temuan berikutnya berdasarkan prioritas dan kekuatan bukti.
8. Pastikan setiap temuan memiliki penjelasan yang jelas dan dapat ditindaklanjuti.
9. Jangan menyimpan dugaan sebagai bug yang sudah terbukti.
10. Jangan menghapus informasi lama yang masih relevan tanpa alasan yang jelas.

Struktur `saran.md`:

# Hasil Analisis Log

## 1. Ringkasan

Jelaskan hasil pemeriksaan secara singkat.

## 2. Kandidat Utama

Daftar ketidaksesuaian nilai antara hasil yang diharapkan dan output aktual.

## 3. Kandidat Berikutnya

Daftar masalah lain yang ditemukan.

## 4. Informasi Tambahan

Daftar indikasi atau hal yang masih memerlukan pemeriksaan.

## 5. Kesimpulan

Jelaskan:

- Apakah output sudah sesuai dengan data dummy.
- Berapa jumlah ketidaksesuaian yang ditemukan.
- Kandidat mana yang paling perlu diperiksa.
- Apakah penyebab bug sudah diketahui atau masih berupa dugaan.

## 9. Larangan Membuat Kesimpulan Tanpa Bukti

1. Jangan menganggap output benar hanya karena tidak menghasilkan exception.
2. Jangan menganggap output salah tanpa mencocokkannya dengan data dummy.
3. Jangan menyamakan nilai sumber dengan nilai akhir apabila terdapat proses transformasi.
4. Jangan membuat nilai yang diharapkan berdasarkan asumsi.
5. Jangan mengabaikan ketidaksesuaian nilai yang ditemukan.
6. Jangan menyatakan penyebab bug sudah pasti apabila belum ditelusuri.
7. Jangan menghilangkan temuan hanya karena penyebabnya belum diketahui.
8. Jangan mengubah kode untuk mencoba memastikan dugaan.
9. Jangan memperbaiki bug dalam tahap analisis ini.

## 10. Laporan Akhir

Setelah selesai, berikan laporan kepada saya yang berisi:

1. Lokasi `saran.md` tempat hasil analisis disimpan.
2. Ringkasan hasil pencocokan log dengan data dummy.
3. Daftar Kandidat Utama beserta nilai yang diharapkan dan nilai aktual.
4. Penyebab bug yang berhasil dibuktikan.
5. Temuan yang masih memerlukan pemeriksaan.
6. Konfirmasi bahwa kode Dart tidak diubah.

**Ingat: Tugas Anda hanya menganalisis, menemukan masalah, dan menyimpan saran perbaikan ke `saran.md`. Jangan melakukan implementasi perbaikan sebelum saya memberikan instruksi berikutnya.**
