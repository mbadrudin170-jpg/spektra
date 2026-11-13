---
description: Sinkronkan seluruh aturan proyek dengan skill custom, perbarui skill yang relevan, buat skill baru jika diperlukan, dan audit kepatuhan seluruh subfolder skill.
agent: code
---

# Sinkronisasi Skill dengan Aturan Proyek

## TUJUAN UTAMA

Tugas Anda adalah menyelaraskan seluruh skill di dalam folder `.agents/skills/custom/` dengan aturan proyek yang tersimpan di `.agents/rules/`.

Lakukan pemeriksaan menyeluruh terhadap aturan dan skill yang tersedia. Identifikasi aturan yang belum tercakup, skill yang perlu diperbarui, kebutuhan skill baru, serta subfolder skill yang belum sesuai dengan standar skill proyek.

Anda harus mengutamakan penggunaan dan penyempurnaan skill yang sudah tersedia. Jangan membuat skill baru apabila tujuan dan tanggung jawabnya sebenarnya sudah tercakup oleh skill yang ada.

Hasil akhir harus berupa kumpulan skill custom yang:

1. Sesuai dengan aturan proyek.
2. Tidak memiliki instruksi yang saling bertentangan.
3. Tidak memiliki duplikasi tujuan dan tanggung jawab.
4. Memiliki struktur dan metadata yang benar.
5. Memiliki instruksi yang jelas, terperinci, dan dapat dilaksanakan AI.
6. Mudah ditemukan dan digunakan berdasarkan konteks tugasnya.

---

# 1. BATASAN PERUBAHAN FILE (WAJIB)

Batasan ini bersifat mutlak dan harus dipatuhi sepanjang pengerjaan.

### 1.1 File yang boleh dibaca

Anda diperbolehkan membaca:

- Seluruh file di `.agents/rules/`, termasuk semua subfoldernya.
- Seluruh file dan subfolder di `.agents/skills/custom/`.
- File pendukung lain di dalam sebuah skill custom apabila diperlukan untuk memahami struktur, referensi, dan keterkaitan instruksinya.

### 1.2 File yang boleh dibuat atau diubah

Anda hanya diperbolehkan membuat dan mengubah file di dalam:

`.agents/skills/custom/`

Semua perubahan harus tetap berada di dalam direktori tersebut, termasuk:

- Memperbarui `SKILL.md`.
- Memperbarui file referensi milik skill.
- Memperbaiki file pendukung milik skill.
- Membuat direktori skill baru.
- Membuat `SKILL.md` untuk skill baru.
- Menambahkan file pendukung yang memang diperlukan oleh skill.

### 1.3 File yang dilarang diubah

Jangan mengubah, menghapus, memindahkan, atau membuat file di luar `.agents/skills/custom/`.

Termasuk tetapi tidak terbatas pada:

- `.agents/rules/`
- `.agents/rules/global/`
- `.agents/skills/` di luar subfolder `custom/`
- `.kilo/commands/`
- `AGENTS.md`
- File konfigurasi proyek.
- File kode aplikasi.
- File dokumentasi proyek lainnya.

**Penting:**
Folder `.agents/rules/` adalah sumber aturan yang harus dibaca, bukan sasaran perubahan.

Jangan mengubah file command yang sedang dijalankan.

Jangan melakukan refactoring, perapian, atau perubahan lain di luar ruang lingkup sinkronisasi skill.

Jika menemukan aturan yang mengharuskan perubahan terhadap file di luar direktori yang diizinkan, jangan melaksanakannya. Catat sebagai kendala dalam laporan akhir.

---

# 2. BACA ATURAN UTAMA SKILL TERLEBIH DAHULU

Sebelum melakukan pemeriksaan atau perubahan apa pun, wajib membaca seluruh isi file:

`.agents/rules/global/aturan_skill.md`

Aturan ini merupakan acuan utama untuk memahami bagaimana skill harus dibuat, disusun, diperbarui, dan dipelihara.

Baca seluruh isinya, bukan hanya judul atau bagian tertentu.

Anda wajib memahami dan mengikuti seluruh ketentuan di dalam file tersebut selama pengerjaan.

Jadikan file tersebut sebagai standar utama ketika:

- Menilai struktur skill.
- Menentukan format penulisan skill.
- Menentukan metadata skill.
- Menyusun instruksi skill.
- Memperbarui skill yang sudah ada.
- Membuat skill baru.
- Melakukan audit kepatuhan skill.

Jangan membuat standar sendiri apabila ketentuannya sudah tersedia di file tersebut.

### Kondisi jika file tidak ditemukan

Jika `.agents/rules/global/aturan_skill.md` tidak ditemukan atau tidak dapat dibaca secara lengkap:

1. Hentikan proses perubahan.
2. Jangan membuat atau memperbarui skill.
3. Laporkan masalah yang ditemukan.
4. Jangan mengganti aturan tersebut dengan asumsi atau standar buatan sendiri.

---

# 3. BACA SELURUH FILE ATURAN PROYEK

Setelah membaca dan memahami `aturan_skill.md`, lanjutkan dengan membaca seluruh file di:

`.agents/rules/`

### Ketentuan pemeriksaan

1. Telusuri semua subfolder secara rekursif.
2. Inventarisasi seluruh file yang ditemukan.
3. Baca seluruh isi setiap file, bukan hanya nama file atau ringkasannya.
4. Jangan melewatkan file hanya karena ekstensi atau nama filenya tidak dikenal.
5. Jika file terlalu panjang, baca secara bertahap sampai seluruh isinya selesai dibaca.
6. Jika file tidak dapat dibaca, catat nama dan alasannya.
7. Jangan menganggap file yang belum dibaca sebagai file yang tidak relevan.

File yang diperiksa harus mencakup seluruh struktur, misalnya:

- `.agents/rules/global/`
- `.agents/rules/` beserta seluruh subfolder lainnya.

### Setelah selesai membaca

Kelompokkan aturan berdasarkan:

- Tujuan aturan.
- Tanggung jawab atau fungsi yang diatur.
- Jenis pekerjaan yang berkaitan.
- Prosedur yang harus dilakukan AI.
- Larangan dan batasan.
- Standar kualitas.
- Ketentuan teknis.
- Aturan yang berhubungan langsung dengan skill tertentu.

Identifikasi juga aturan yang:

- Belum tercakup oleh skill mana pun.
- Sudah tercakup oleh skill tertentu.
- Tercakup sebagian tetapi belum lengkap.
- Memiliki hubungan dengan lebih dari satu skill.
- Berpotensi bertentangan dengan instruksi skill yang sudah ada.

**Jangan langsung menyalin seluruh aturan ke semua skill.**

Pahami terlebih dahulu fungsi setiap aturan, kemudian tentukan skill yang paling tepat untuk menampung instruksi tersebut.

---

# 4. INVENTARISASI SELURUH SKILL CUSTOM

Selanjutnya, periksa seluruh isi direktori:

`.agents/skills/custom/`

Telusuri semua subfolder skill dan file pendukungnya.

Buat inventarisasi yang mencakup:

- Nama direktori skill.
- Lokasi lengkap `SKILL.md`.
- Tujuan dan fungsi skill.
- Ruang lingkup pekerjaan.
- Instruksi utama.
- Metadata skill.
- File referensi dan pendukung.
- Hubungan dengan skill lainnya.

Baca isi `SKILL.md` setiap skill secara lengkap.

Baca juga file pendukung yang dirujuk oleh `SKILL.md` untuk memastikan instruksi dan referensinya masih sesuai.

Jangan hanya mengandalkan nama direktori atau deskripsi skill untuk menentukan fungsinya. Penilaian harus berdasarkan isi instruksi yang sebenarnya.

Jangan menganggap direktori `references/`, `scripts/`, atau `assets/` sebagai skill terpisah apabila direktori tersebut hanya berfungsi sebagai sumber pendukung skill.

---

# 5. COCOKKAN ATURAN DENGAN SKILL YANG SUDAH ADA

Ini merupakan tahap utama sinkronisasi.

Bandingkan setiap kelompok aturan yang sudah dibaca dengan seluruh skill di `.agents/skills/custom/`.

Gunakan prinsip berikut.

### A. Tujuan sama: perbarui skill yang sudah ada

Apabila terdapat skill yang memiliki tujuan dan tanggung jawab sama dengan aturan yang belum tercakup secara lengkap:

1. Gunakan skill tersebut sebagai tempat pembaruan.
2. Masukkan aturan yang relevan ke bagian yang tepat.
3. Perbaiki instruksi yang belum lengkap.
4. Perjelas prosedur yang ambigu.
5. Pastikan tidak terjadi pengulangan instruksi yang tidak diperlukan.
6. Pertahankan seluruh fungsi skill yang sudah benar.

Jangan membuat skill baru hanya karena ditemukan aturan tambahan.

### B. Tujuan berbeda: buat skill baru

Buat skill baru hanya apabila:

1. Aturan memiliki tujuan yang berbeda secara substantif.
2. Tidak ada skill yang sudah memiliki tanggung jawab tersebut.
3. Menggabungkannya dengan skill yang ada akan membuat ruang lingkup tidak jelas atau terlalu luas.
4. Skill baru memang diperlukan untuk menjalankan pekerjaan secara terstruktur.

Buat skill di dalam:

`.agents/skills/custom/<nama-skill>/SKILL.md`

Gunakan nama direktori yang jelas dan sesuai dengan ketentuan dalam `aturan_skill.md`.

### C. Tujuan berhubungan tetapi tanggung jawab berbeda

Apabila dua skill memiliki hubungan, tetapi mempunyai fungsi dan tanggung jawab yang berbeda:

- Jangan menggabungkannya secara otomatis.
- Pertahankan batas tanggung jawab masing-masing.
- Tambahkan referensi atau hubungan antar-skill apabila memang diperlukan.
- Hindari instruksi yang saling menduplikasi.

### D. Aturan berlaku untuk beberapa skill

Apabila sebuah aturan memang berlaku untuk beberapa jenis pekerjaan:

- Terapkan aturan tersebut hanya pada skill yang relevan.
- Sesuaikan redaksinya dengan konteks masing-masing skill.
- Jangan menyalin seluruh isi aturan apabila hanya sebagian yang diperlukan.
- Jangan mengubah makna atau tingkat kewajiban aturan aslinya.

### Prinsip utama

**Sempurnakan skill yang sudah ada sebelum mempertimbangkan pembuatan skill baru.**

Jangan membuat skill hanya untuk menampung satu aturan kecil apabila aturan tersebut lebih tepat menjadi bagian dari skill yang sudah tersedia.

---

# 6. AUDIT SELURUH SUBFOLDER SKILL CUSTOM

Selain melakukan sinkronisasi, lakukan audit menyeluruh terhadap semua subfolder skill di:

`.agents/skills/custom/`

Tujuannya adalah menemukan skill yang belum sesuai dengan ketentuan dalam:

`.agents/rules/global/aturan_skill.md`

Jangan hanya memeriksa skill yang kebetulan berkaitan dengan aturan baru. Semua skill custom yang sudah ada harus diperiksa.

### Aspek pemeriksaan

Periksa setiap skill berdasarkan seluruh ketentuan dalam `aturan_skill.md`, termasuk aspek berikut apabila diatur di dalamnya.

**A. Struktur direktori**

- Apakah struktur folder sudah benar?
- Apakah `SKILL.md` berada di lokasi yang benar?
- Apakah file pendukung berada di lokasi yang sesuai?
- Apakah terdapat struktur atau file yang tidak diperlukan?

**B. Metadata dan front matter**

- Apakah format YAML valid?
- Apakah metadata wajib tersedia?
- Apakah nama skill sesuai dengan nama direktori?
- Apakah deskripsi menjelaskan fungsi dan konteks penggunaan skill?
- Apakah metadata mengikuti standar yang berlaku?

Sebagai acuan interoperabilitas Agent Skills, periksa juga ketentuan format `SKILL.md` dari spesifikasi resmi apabila tidak bertentangan dengan aturan proyek:

- `name` dan `description` merupakan metadata wajib.
- Nama skill harus sesuai dengan nama direktori.
- Nama menggunakan format yang diperbolehkan spesifikasi.
- Deskripsi harus menjelaskan fungsi serta kapan skill digunakan.

Jangan menerapkan metadata yang bertentangan dengan ketentuan `aturan_skill.md`.

**C. Isi instruksi**

- Apakah tujuan skill jelas?
- Apakah ruang lingkup tugasnya jelas?
- Apakah langkah pengerjaannya runtut?
- Apakah setiap instruksi dapat dipahami AI?
- Apakah terdapat kalimat ambigu?
- Apakah terdapat instruksi yang bertentangan?
- Apakah terdapat pengulangan yang tidak diperlukan?
- Apakah terdapat aturan yang belum diterapkan?

**D. Konsistensi**

- Apakah instruksi sesuai dengan aturan proyek?
- Apakah ada ketentuan yang saling bertentangan?
- Apakah terdapat tanggung jawab yang tumpang tindih dengan skill lain?
- Apakah deskripsi dan isi skill memiliki tujuan yang sama?
- Apakah terdapat instruksi yang sudah tidak relevan?

**E. Referensi dan file pendukung**

- Apakah semua referensi yang disebutkan benar-benar tersedia?
- Apakah alamat file menggunakan path yang tepat?
- Apakah referensi relatif mengarah ke lokasi yang benar dari direktori skill?
- Apakah file pendukung benar-benar digunakan oleh instruksi skill?
- Apakah terdapat referensi yang sudah tidak berlaku?

### Tindakan setelah audit

Kelompokkan hasil pemeriksaan menjadi:

1. **Sesuai:** Tidak membutuhkan perubahan.
2. **Perlu perbaikan:** Terdapat pelanggaran aturan yang dapat diperbaiki.
3. **Belum lengkap:** Ada bagian atau file yang diperlukan tetapi belum tersedia.
4. **Berpotensi bermasalah:** Terdapat konflik atau ketidakjelasan yang membutuhkan pertimbangan.
5. **Duplikasi:** Tujuan atau tanggung jawabnya tumpang tindih dengan skill lain.

Perbaiki temuan yang dapat diselesaikan dengan aman sesuai aturan proyek dan batas perubahan direktori.

Jangan menghapus skill, menggabungkan direktori, atau membuang instruksi yang masih memiliki fungsi tanpa dasar yang jelas.

Apabila terdapat konflik yang tidak dapat diselesaikan tanpa mengambil keputusan yang tidak memiliki dasar, jangan menebak. Pertahankan isi terkait dan laporkan konflik tersebut.

---

# 7. STANDAR SAAT MEMPERBARUI SKILL

Ketika mengubah `SKILL.md` atau file pendukung skill, ikuti ketentuan berikut:

1. Pertahankan tujuan asli skill.
2. Pertahankan instruksi yang masih benar dan relevan.
3. Jangan menghilangkan persyaratan yang masih berlaku.
4. Jangan mengubah makna aturan sumber.
5. Jangan menambahkan aturan baru yang tidak memiliki dasar dari aturan proyek atau kebutuhan nyata skill.
6. Gunakan bahasa Indonesia yang baik dan benar apabila bahasa Indonesia digunakan oleh skill tersebut.
7. Gunakan istilah teknis secara konsisten.
8. Gunakan kalimat perintah yang jelas dan tidak ambigu.
9. Bedakan kewajiban, larangan, kondisi, dan rekomendasi.
10. Susun instruksi dalam urutan kerja yang logis.
11. Hindari duplikasi instruksi.
12. Hindari penjelasan yang tidak berkaitan dengan tanggung jawab skill.
13. Jangan memindahkan tanggung jawab skill lain ke dalam skill yang sedang diperbarui.
14. Jangan mengubah file di luar direktori custom.

Apabila satu skill memiliki banyak instruksi, susun berdasarkan kelompok pekerjaan agar AI mudah menemukan informasi yang diperlukan.

Jangan mempersingkat isi hanya untuk membuat file terlihat lebih ringkas apabila pemangkasan tersebut menghilangkan ketelitian instruksi.

---

# 8. PENANGANAN KONFLIK ATURAN

Selama pemeriksaan, Anda mungkin menemukan aturan yang bertentangan dengan isi skill.

Lakukan pemeriksaan berikut:

1. Identifikasi kedua instruksi yang bertentangan.
2. Catat lokasi file masing-masing.
3. Jelaskan letak pertentangannya.
4. Periksa apakah `aturan_skill.md` sudah menentukan cara penyelesaiannya.
5. Terapkan ketentuan yang secara jelas memiliki kewenangan berdasarkan aturan proyek.

Jangan membuat keputusan berdasarkan preferensi pribadi.

Jangan mengubah aturan sumber untuk menyelesaikan konflik.

Jangan mengubah aturan proyek menjadi lebih longgar atau lebih ketat tanpa dasar.

Jika konflik tidak memiliki penyelesaian yang jelas, jangan mengubah bagian yang terdampak. Laporkan agar dapat diputuskan secara terpisah.

---

# 9. VERIFIKASI SETELAH PERUBAHAN

Setelah seluruh sinkronisasi dan perbaikan selesai, lakukan pemeriksaan ulang.

### 9.1 Periksa perubahan file

Pastikan seluruh file yang dibuat atau diubah hanya berada di:

`.agents/skills/custom/`

Gunakan `git status` dan `git diff` apabila repositori menggunakan Git.

Perhatikan perubahan yang sudah ada sebelum pengerjaan. Jangan menganggap perubahan sebelumnya sebagai hasil pekerjaan Anda.

Jangan melakukan reset, checkout, restore, atau membuang perubahan pengguna.

Jangan melakukan commit atau push.

### 9.2 Periksa setiap skill

Pastikan:

- Semua skill yang baru dibuat memiliki struktur yang benar.
- Metadata mengikuti aturan proyek.
- Instruksi konsisten dengan aturan sumber.
- Tidak ada referensi file yang rusak akibat perubahan.
- Tidak ada instruksi yang bertentangan.
- Tidak ada duplikasi tujuan yang baru.
- Seluruh file yang diubah berada di direktori yang diizinkan.

### 9.3 Periksa kembali kelengkapan aturan

Pastikan semua file di `.agents/rules/` sudah diperiksa.

Pastikan semua aturan yang relevan sudah:

- Tercakup oleh skill yang sesuai.
- Diperbarui ke skill yang tepat.
- Atau dicatat sebagai belum dapat diterapkan beserta alasannya.

Jangan menyatakan sinkronisasi selesai apabila masih ada file aturan yang belum diperiksa.

---

# 10. FORMAT LAPORAN AKHIR

Setelah selesai, berikan laporan dalam bahasa Indonesia.

Gunakan format berikut.

## A. Ringkasan pekerjaan

Jelaskan:

- Jumlah file aturan yang diperiksa.
- Jumlah subfolder skill yang diaudit.
- Jumlah skill yang diperbarui.
- Jumlah skill baru yang dibuat.
- Jumlah skill yang sudah sesuai tanpa perubahan.
- Jumlah masalah yang belum terselesaikan.

## B. Hasil pemetaan aturan ke skill

Buat tabel:

| Aturan sumber | Skill tujuan | Tindakan                                                  |
| ------------- | ------------ | --------------------------------------------------------- |
| Path aturan   | Path skill   | Diperbarui / Sudah sesuai / Skill baru / Belum diterapkan |

Pastikan path ditulis secara lengkap dan benar.

## C. Hasil audit skill custom

Buat tabel:

| Subfolder skill | Status awal     | Tindakan   | Status akhir |
| --------------- | --------------- | ---------- | ------------ |
| Nama skill      | Perlu perbaikan | Diperbaiki | Sesuai       |

Masukkan seluruh skill yang diperiksa, bukan hanya skill yang diubah.

## D. Daftar perubahan

Tuliskan seluruh file yang dibuat atau diperbarui beserta:

- Path lengkap.
- Alasan perubahan.
- Ringkasan bagian yang diperbaiki.

## E. Masalah yang belum terselesaikan

Cantumkan:

- Aturan yang belum tercakup.
- Konflik yang belum memiliki penyelesaian.
- File yang tidak dapat dibaca.
- Skill yang membutuhkan keputusan lebih lanjut.

Jangan menyembunyikan masalah atau menyatakan semuanya sesuai apabila masih terdapat pelanggaran.

## F. Verifikasi batas perubahan

Nyatakan apakah seluruh perubahan yang dilakukan sudah berada di dalam:

`.agents/skills/custom/`

Apabila terdapat perubahan di luar direktori tersebut, jelaskan penyebabnya. Jangan melakukan pemulihan otomatis terhadap perubahan yang tidak Anda buat.

---

# 11. KETENTUAN PENUTUP

- Utamakan ketepatan daripada kecepatan.
- Baca seluruh sumber sebelum mengambil keputusan.
- Jangan membuat asumsi tentang isi file yang belum dibaca.
- Jangan membuat skill baru apabila skill lama masih dapat dikembangkan.
- Jangan mengubah aturan sumber.
- Jangan mengerjakan tugas lain di luar sinkronisasi dan audit skill.
- Jangan menghapus isi yang masih memiliki fungsi.
- Jangan mengubah file di luar direktori custom.
- Jangan menyatakan berhasil tanpa melakukan verifikasi.

**PRIORITAS UTAMA:**

Mewujudkan sinkronisasi yang akurat antara seluruh aturan proyek di `.agents/rules/` dan seluruh skill di `.agents/skills/custom/`, dengan menjadikan `.agents/rules/global/aturan_skill.md` sebagai pedoman wajib dalam seluruh proses pengembangan dan audit skill.
