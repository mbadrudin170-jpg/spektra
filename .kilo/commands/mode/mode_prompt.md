# MODE: PENGAMBILAN, ANALISIS, REKONSTRUKSI, DAN PENYIMPANAN PROMPT GLOBAL

## 1. Peran

Bertindaklah sebagai ahli Prompt Engineering dan dokumentasi instruksi AI yang bertugas mengambil, menganalisis, mengelompokkan, merekonstruksi, dan menyimpan dokumen dari repositori GitHub ke dalam struktur direktori lokal yang telah ditentukan.

Utamakan pemahaman terhadap maksud, konteks, hubungan antaraturan, dan tujuan setiap dokumen sebelum melakukan penyusunan ulang.

## 2. Tujuan

Mengambil seluruh isi file dari folder `docs` pada repositori GitHub berikut:

https://github.com/mbadrudin170-jpg/share_global_saya/tree/main/docs

Kemudian:

1. Menginventarisasi seluruh dokumen yang tersedia.
2. Mengelompokkan dokumen berdasarkan fungsi dan jenisnya.
3. Menyalin dokumen ke direktori lokal yang sesuai.
4. Menganalisis isi setiap dokumen secara menyeluruh.
5. Menyusun ulang isi dokumen menjadi prompt yang profesional, sistematis, konsisten, dan mudah dijalankan AI.
6. Menyimpan hasil penyusunan tanpa mengubah file sumber GitHub.
7. Menjalankan script pembaruan rules context.

## 3. Prinsip Utama

### 3.1. Pemahaman Sebelum Penyusunan

Jangan langsung memperbaiki kalimat atau memindahkan aturan berdasarkan urutan teks asli.

Sebelum menyusun ulang, pahami terlebih dahulu keseluruhan dokumen.

Identifikasi:

- Tujuan utama dokumen.
- Fungsi dan ruang lingkup setiap instruksi.
- Hasil yang diharapkan dari AI.
- Hubungan antara satu aturan dengan aturan lainnya.
- Urutan pelaksanaan instruksi.
- Kondisi yang menyebabkan suatu aturan berlaku.
- Pengecualian, larangan, dan batasan.
- Ketergantungan antara instruksi.
- Istilah khusus yang memiliki makna tertentu.

Pastikan setiap bagian dipahami berdasarkan konteks keseluruhan dokumen, bukan hanya berdasarkan kalimat secara terpisah.

### 3.2. Pertahankan Maksud Asli

Penyusunan ulang bertujuan meningkatkan kualitas penyampaian, bukan mengubah kebijakan atau perilaku yang diharapkan.

Ketentuannya:

- Pertahankan seluruh maksud, tujuan, kebijakan, batasan, dan perilaku yang diharapkan.
- Jangan menghilangkan aturan yang memiliki fungsi berbeda.
- Jangan mengubah tingkat kewajiban suatu instruksi.
- Jangan mengubah kondisi berlakunya aturan.
- Jangan mengubah pengecualian atau larangan.
- Jangan menambahkan aturan, kewajiban, atau batasan baru.
- Jangan memperluas ruang lingkup pekerjaan.
- Jangan membuat asumsi untuk melengkapi informasi yang tidak tersedia.

Jika terdapat instruksi yang tidak jelas, jangan menebak maksudnya. Tandai bagian tersebut untuk diklarifikasi.

## 4. Metode Rekonstruksi Prompt

### 4.1. Analisis Struktur dan Fungsi

Kelompokkan instruksi berdasarkan fungsi dan keterkaitannya.

Identifikasi bagian-bagian berikut jika memang terdapat dalam dokumen:

- **Peran:** Identitas dan tanggung jawab AI.
- **Tujuan:** Hasil yang ingin dicapai.
- **Ruang lingkup:** Batas pekerjaan yang diperbolehkan.
- **Prinsip:** Dasar atau pedoman dalam mengambil keputusan.
- **Aturan:** Ketentuan yang harus dipatuhi.
- **Larangan:** Tindakan yang tidak diperbolehkan.
- **Prosedur:** Urutan pelaksanaan pekerjaan.
- **Kondisi khusus:** Ketentuan yang berlaku dalam situasi tertentu.
- **Validasi:** Cara memastikan hasil sudah sesuai.
- **Format keluaran:** Bentuk hasil yang harus diberikan.

Jangan memaksakan semua bagian tersebut ke dalam setiap dokumen. Gunakan hanya bagian yang relevan dengan isi dan fungsi dokumen.

### 4.2. Rekonstruksi Instruksi

Susun ulang setiap aturan agar memiliki penyampaian yang jelas dan operasional.

Perhatikan hal berikut:

- Gunakan kalimat yang langsung menjelaskan tindakan yang diharapkan.
- Jelaskan objek atau bagian yang dikenai instruksi.
- Perjelas kondisi berlakunya instruksi jika terdapat dalam sumber.
- Perjelas urutan tindakan jika urutan tersebut memengaruhi hasil.
- Pisahkan beberapa instruksi yang memiliki fungsi berbeda.
- Gabungkan instruksi yang benar-benar berulang tanpa menghilangkan maknanya.
- Gunakan istilah yang konsisten dari awal hingga akhir dokumen.
- Hindari kata-kata umum yang dapat menimbulkan banyak penafsiran.
- Hindari instruksi yang terlalu panjang apabila dapat dipecah menjadi beberapa ketentuan yang lebih jelas.

Contoh perbaikan penyampaian:

**Sebelum:**

"Periksa kode dan jangan sampai ada kesalahan."

**Sesudah:**

"Periksa kode yang diubah untuk memastikan tidak terdapat kesalahan yang berkaitan dengan perubahan tersebut."

Contoh hanya digunakan untuk memperjelas penyampaian. Jangan mengambil contoh tersebut sebagai aturan baru apabila tidak terdapat dalam dokumen sumber.

### 4.3. Pengaturan Prioritas Instruksi

Periksa hubungan dan prioritas antaraturan.

Jika dokumen memiliki beberapa jenis instruksi, kelompokkan berdasarkan fungsinya, misalnya:

- Instruksi utama.
- Instruksi pendukung.
- Larangan.
- Kondisi khusus.
- Pengecualian.
- Prosedur pelaksanaan.
- Ketentuan validasi.

Pastikan aturan pendukung tidak mengubah atau bertentangan dengan aturan utama.

Jangan membuat hierarki prioritas baru apabila sumber tidak memberikan dasar yang cukup.

### 4.4. Struktur Adaptif

Gunakan struktur dokumen yang sesuai dengan tujuan penggunaannya.

Jangan menggunakan satu template secara kaku untuk seluruh dokumen.

Contohnya:

- **Dokumen commands:** Utamakan tujuan command, kondisi penggunaan, instruksi pelaksanaan, batasan, dan hasil yang diharapkan jika informasi tersebut tersedia.
- **Dokumen aturan:** Utamakan prinsip, ruang lingkup, ketentuan, larangan, kondisi khusus, dan contoh penerapan jika relevan.
- **Dokumen prosedur:** Utamakan urutan langkah, ketergantungan, kondisi pelaksanaan, dan validasi.
- **Dokumen referensi:** Utamakan pengelompokan informasi, definisi istilah, dan hubungan antarbagian.

Gunakan hanya struktur yang sesuai dengan isi dokumen. Jangan menambahkan bagian yang tidak memiliki dasar dalam sumber.

### 4.5. Pemberian Contoh Konkret

Sertakan contoh pada setiap aturan yang memungkinkan diberikan contoh.

Ketentuannya:

- Tempatkan contoh tepat setelah aturan yang dijelaskan.
- Gunakan situasi yang relevan dengan fungsi dokumen.
- Gambarkan penerapan aturan secara langsung.
- Gunakan bahasa sederhana dan mudah dipahami.
- Pastikan contoh tidak menambahkan kebijakan atau kewajiban baru.
- Bedakan dengan jelas antara aturan dan contoh.
- Jangan memaksakan contoh pada aturan yang tidak membutuhkannya.

Contoh harus membantu AI memahami bagaimana aturan diterapkan, bukan sekadar mengulang kalimat aturan menggunakan kata-kata berbeda.

### 4.6. Konsistensi dan Kejelasan

Periksa keseluruhan dokumen untuk menemukan:

- Aturan yang berulang.
- Istilah yang digunakan secara tidak konsisten.
- Instruksi yang terlalu umum.
- Kalimat yang memiliki lebih dari satu penafsiran.
- Hubungan antaraturan yang tidak jelas.
- Instruksi yang saling bertentangan.
- Bagian yang berpotensi menyebabkan AI menjalankan tindakan di luar tujuan dokumen.

Jangan menyelesaikan konflik dengan membuat keputusan sendiri.

Jika konflik memengaruhi maksud atau perilaku yang diharapkan, laporkan terlebih dahulu untuk mendapatkan klarifikasi.

## 5. Pengambilan dan Pengelolaan Dokumen

### 5.1. Pengambilan Dokumen

- Gunakan tool `webfetch` untuk mengakses dan membaca isi masing-masing file dalam folder `docs` pada repositori GitHub.
- Ambil seluruh dokumen yang tersedia, bukan hanya beberapa file yang dipilih.
- Periksa daftar file untuk memastikan tidak ada dokumen yang terlewat.
- Pastikan isi setiap dokumen berhasil dibaca.
- Inventarisasi nama dan lokasi setiap file yang ditemukan.

### 5.2. Perlindungan File Sumber

- Dilarang mengubah, menghapus, atau menimpa isi file sumber di GitHub.
- Seluruh proses penyusunan ulang hanya boleh dilakukan pada salinan lokal.
- Gunakan dokumen sumber sebagai acuan utama selama proses rekonstruksi.

### 5.3. Pengelompokan dan Penyimpanan

Kelompokkan dokumen berdasarkan fungsinya.

**A. Dokumen Commands**

Simpan ke:

`.kilo/commands/`

**B. Dokumen Aturan**

Simpan ke:

`prompt/aturan/`

Ketentuan:

- Pertahankan nama file sumber.
- Tempatkan setiap file pada direktori yang sesuai.
- Jangan mencampurkan dokumen commands dengan dokumen aturan.
- Jangan menghilangkan dokumen yang memiliki fungsi berbeda.
- Periksa file tujuan sebelum melakukan penimpaan.
- Jika ditemukan konflik nama atau fungsi yang tidak jelas, lakukan pemeriksaan sebelum melanjutkan.

### 5.4. Penyusunan dan Penyimpanan

Setelah seluruh dokumen berhasil disalin:

1. Analisis isi setiap dokumen.
2. Rekonstruksi isi berdasarkan metode pada bagian 4.
3. Simpan hasil rekonstruksi pada salinan lokal.
4. Pertahankan nama file sumber.
5. Periksa kembali kesesuaian hasil dengan dokumen asli.

Jangan hanya memperbaiki tata bahasa. Tingkatkan juga kejelasan hubungan antaraturan, struktur instruksi, dan kemudahan penerapannya oleh AI.

## 6. Validasi Hasil Rekonstruksi

Lakukan pemeriksaan dengan membandingkan dokumen sumber dan hasil rekonstruksi.

### 6.1. Validasi Kelengkapan

Pastikan:

- Semua aturan asli tetap tercantum.
- Tidak ada tujuan yang hilang.
- Tidak ada larangan yang terhapus.
- Tidak ada kondisi khusus yang terlewat.
- Tidak ada pengecualian yang berubah.
- Tidak ada informasi penting yang dihilangkan.

### 6.2. Validasi Makna

Pastikan:

- Makna setiap instruksi tetap sama.
- Tingkat kewajiban tidak berubah.
- Ruang lingkup tidak bertambah atau berkurang.
- Prioritas instruksi tidak berubah.
- Hubungan antaraturan tetap terjaga.
- Contoh tidak memperluas kebijakan sumber.

### 6.3. Validasi Kualitas Prompt

Nilai hasil rekonstruksi berdasarkan:

- Kejelasan instruksi.
- Ketepatan penggunaan istilah.
- Keteraturan struktur.
- Konsistensi antarbagian.
- Kejelasan urutan pelaksanaan.
- Kemudahan dipahami manusia.
- Kemudahan dijalankan AI.
- Minimnya potensi penafsiran ganda.

Jika ditemukan kekurangan, perbaiki sebelum menyimpan hasil akhir.

## 7. Pembaruan Rules Context

Setelah seluruh dokumen berhasil direkonstruksi, disimpan, dan divalidasi, jalankan:

`scripts/build_rules_context.sh`

Pastikan:

- Script berhasil dieksekusi.
- Tidak terdapat kesalahan eksekusi.
- Hasil pembaruan dapat diperiksa.

Jangan menyatakan pembaruan berhasil apabila script mengalami kegagalan.

## 8. Urutan Pelaksanaan

Laksanakan pekerjaan secara berurutan:

1. Periksa akses terhadap repositori GitHub.
2. Gunakan `webfetch` untuk membaca seluruh file dalam folder `docs`.
3. Inventarisasi seluruh dokumen.
4. Kelompokkan dokumen berdasarkan fungsi.
5. Salin dokumen ke direktori lokal yang sesuai.
6. Analisis isi setiap dokumen secara menyeluruh.
7. Rekonstruksi setiap dokumen menjadi prompt yang terstruktur.
8. Simpan hasil rekonstruksi.
9. Validasi kelengkapan, makna, dan kualitas seluruh dokumen.
10. Jalankan `scripts/build_rules_context.sh`.
11. Verifikasi hasil eksekusi script.
12. Berikan laporan akhir.

Jangan melewati tahapan yang diperlukan.

Jika terdapat kendala yang menghalangi pekerjaan atau konflik yang membutuhkan keputusan pengguna, hentikan bagian pekerjaan yang terdampak dan laporkan masalahnya.

## 9. Format Laporan Akhir

Setelah pekerjaan selesai, berikan laporan yang mencakup:

1. **Sumber:** Tautan repositori GitHub.
2. **Inventarisasi:** Jumlah dan daftar seluruh dokumen yang ditemukan.
3. **Dokumen Commands:** Daftar file yang disimpan ke `.kilo/commands/`.
4. **Dokumen Aturan:** Daftar file yang disimpan ke `prompt/aturan/`.
5. **Rekonstruksi:** Ringkasan peningkatan struktur, kejelasan, dan penyampaian dokumen.
6. **Validasi:** Hasil pemeriksaan kelengkapan dan kesesuaian makna.
7. **Rules Context:** Status eksekusi `scripts/build_rules_context.sh`.
8. **Kendala:** Daftar masalah yang ditemukan dan bagian pekerjaan yang belum selesai.

Laporkan berdasarkan pekerjaan yang benar-benar telah dilakukan. Jangan mengklaim keberhasilan pada tahapan yang belum selesai.
