# COMMAND: AUDIT, OPTIMASI, DAN PEMELIHARAAN KILO CODE

**Path command:** `.kilo/commands/optimalkan_kilo.md`

**Path laporan:** `./laporan_optimasi_kilo.md`

## 1. TUJUAN UTAMA

Lakukan audit, optimasi, dan pemeliharaan Kilo Code agar dapat bekerja secara maksimal, efisien, konsisten, aman, dan sesuai kebutuhan pengguna.

Optimasi harus berdasarkan:

1. Dokumentasi resmi Kilo Code.
2. Konfigurasi Kilo Code yang benar-benar digunakan.
3. Versi Kilo Code dan platform yang digunakan.
4. Kemampuan model yang tersedia.
5. Kebutuhan pekerjaan pengguna.
6. Keterbatasan perangkat dan lingkungan kerja.
7. Efisiensi penggunaan konteks, waktu, dan sumber daya.

Jangan memberikan rekomendasi berdasarkan asumsi yang belum diverifikasi.

Jangan hanya memberikan daftar rekomendasi. Lakukan pemeriksaan, analisis, optimasi yang aman, pembersihan ekstensi versi lama, verifikasi perubahan, dan pembaruan laporan.

## 2. BATASAN WAJIB

Patuhi seluruh ketentuan berikut:

1. Jangan menyarankan pembelian atau penambahan kredit Kilo.
2. Jangan menyarankan pengisian saldo untuk menggunakan model atau fitur tertentu.
3. Jangan menjadikan layanan berbayar sebagai solusi optimasi.
4. Prioritaskan fitur gratis dan konfigurasi yang sudah tersedia.
5. Jangan menganggap semua fitur dalam dokumentasi dapat digunakan pada versi Kilo Code yang terpasang.
6. Jangan mengaktifkan fitur hanya karena fitur tersebut tersedia.
7. Jangan menghapus konfigurasi yang masih berfungsi tanpa alasan teknis.
8. Jangan memperluas izin akses agent hanya untuk mempercepat pekerjaan.
9. Jangan mengubah file proyek yang tidak berkaitan dengan optimasi Kilo Code.
10. Jangan menampilkan API key, token, password, atau informasi rahasia ketika memeriksa konfigurasi.
11. Jangan melakukan perubahan sistem yang berisiko tanpa persetujuan pengguna.
12. Jangan melakukan instalasi atau upgrade yang berpotensi mengganggu pekerjaan pengguna tanpa alasan teknis yang jelas.
13. Jangan mengarang kemampuan Kilo Code.
14. Jangan menyatakan suatu fitur sudah aktif apabila belum diverifikasi.
15. Jangan mengklaim pekerjaan berhasil apabila belum melakukan pemeriksaan setelah perubahan.

## 3. TAHAP PERTAMA — PEMERIKSAAN LINGKUNGAN

Sebelum melakukan optimasi, periksa kondisi Kilo Code yang sedang digunakan.

Identifikasi:

- Versi Kilo Code.
- Platform dan lingkungan kerja.
- Jenis editor yang digunakan.
- Versi editor.
- Konfigurasi global.
- Konfigurasi proyek.
- Lokasi instalasi ekstensi.
- Custom Modes atau Custom Agents.
- Custom Rules.
- Custom Instructions.
- Custom Subagents.
- Agent Permissions.
- `AGENTS.md` atau file instruksi terkait.
- Workflows.
- Skills.
- Marketplace.
- Model Selection.
- Auto Model.
- Context Management.
- Codebase Indexing.
- `.kilocodeignore`.
- Fitur produktivitas.
- Ekstensi Kilo yang terpasang.
- Direktori ekstensi yang digunakan editor.

Periksa file dan pengaturan yang benar-benar tersedia.

Jangan mengarang lokasi konfigurasi atau menganggap seluruh fitur sudah digunakan.

Kelompokkan status setiap fitur:

- Sudah tersedia dan aktif.
- Sudah tersedia tetapi belum digunakan.
- Belum dikonfigurasi.
- Tidak didukung oleh versi atau platform saat ini.
- Belum dapat diverifikasi.

Identifikasi juga apakah Kilo Code menggunakan arsitektur terbaru atau masih menggunakan konfigurasi versi sebelumnya.

**Penting:** Jangan menerapkan konfigurasi dari dokumentasi versi lama secara otomatis pada versi terbaru. Periksa terlebih dahulu apakah masih berlaku.

## 4. TAHAP KEDUA — WAJIB MEMBACA SELURUH DOKUMENTASI RESMI

**Seluruh 40 URL berikut wajib diperiksa satu per satu. Tidak boleh ada URL yang sengaja dilewati.**

### A. Dokumentasi Customize

1. https://kilo.ai/docs/customize
2. https://kilo.ai/docs/customize/marketplace
3. https://kilo.ai/docs/customize/custom-modes
4. https://kilo.ai/docs/customize/custom-rules
5. https://kilo.ai/docs/customize/custom-instructions
6. https://kilo.ai/docs/customize/custom-subagents
7. https://kilo.ai/docs/customize/agent-permissions
8. https://kilo.ai/docs/customize/agents-md
9. https://kilo.ai/docs/customize/workflows
10. https://kilo.ai/docs/customize/skills
11. https://kilo.ai/docs/customize/prompt-engineering
12. https://kilo.ai/docs/customize/context/codebase-indexing
13. https://kilo.ai/docs/customize/context/context-condensing
14. https://kilo.ai/docs/customize/context/kilocodeignore

### B. Dokumentasi Fitur Produktivitas

15. https://kilo.ai/docs/code-with-ai/features/autocomplete
16. https://kilo.ai/docs/code-with-ai/features/enhance-prompt
17. https://kilo.ai/docs/code-with-ai/features/browser-use
18. https://kilo.ai/docs/code-with-ai/features/task-todo-list
19. https://kilo.ai/docs/code-with-ai/features/checkpoints
20. https://kilo.ai/docs/code-with-ai/features/file-encoding
21. https://kilo.ai/docs/code-with-ai/features/message-feedback

### C. Dokumentasi Agents dan Model

22. https://kilo.ai/docs/code-with-ai/agents/goals
23. https://kilo.ai/docs/code-with-ai/agents/auto-model
24. https://kilo.ai/docs/code-with-ai/agents/model-selection
25. https://kilo.ai/docs/code-with-ai/agents/context-mentions
26. https://kilo.ai/docs/code-with-ai/agents/session-history
27. https://kilo.ai/docs/code-with-ai/agents/chat-interface

### D. Dokumentasi Gas Town

28. https://kilo.ai/docs/code-with-ai/gastown
29. https://kilo.ai/docs/code-with-ai/gastown/quick-start
30. https://kilo.ai/docs/code-with-ai/gastown/concepts
31. https://kilo.ai/docs/code-with-ai/gastown/mayor
32. https://kilo.ai/docs/code-with-ai/gastown/sling-work
33. https://kilo.ai/docs/code-with-ai/gastown/code-review
34. https://kilo.ai/docs/code-with-ai/gastown/settings

### E. Dokumentasi Gas Town Wasteland

35. https://kilo.ai/docs/code-with-ai/gastown/wasteland
36. https://kilo.ai/docs/code-with-ai/gastown/wasteland/quick-start
37. https://kilo.ai/docs/code-with-ai/gastown/wasteland/workflow
38. https://kilo.ai/docs/code-with-ai/gastown/wasteland/admin
39. https://kilo.ai/docs/code-with-ai/gastown/wasteland/concepts
40. https://kilo.ai/docs/code-with-ai/gastown/wasteland/settings

## 5. TAHAP KETIGA — PROSEDUR WAJIB MEMBACA DOKUMENTASI

Bagian ini dibuat khusus untuk mengatasi masalah AI yang sering tidak membaca seluruh tautan.

Ikuti prosedur berikut.

### A. Pemeriksaan URL satu per satu

1. Kunjungi URL nomor 1.
2. Baca seluruh isi utama halaman.
3. Pelajari fungsi, cara kerja, contoh konfigurasi, persyaratan, batasan, dan ketentuan penggunaannya.
4. Setelah selesai, tandai URL tersebut sebagai sudah dibaca.
5. Lanjutkan ke URL berikutnya.
6. Ulangi sampai seluruh 40 URL diperiksa.

Jangan membuka beberapa tautan sekaligus lalu menganggap semuanya sudah dibaca.

Jangan hanya membaca:

- Judul halaman.
- Ringkasan pencarian.
- Daftar navigasi.
- Deskripsi singkat.
- Potongan teks hasil pencarian.

Baca isi utama dokumentasi sampai selesai.

Jika halaman memiliki beberapa bagian atau tab yang relevan, periksa seluruh bagiannya.

### B. Jika URL tidak dapat dibuka

Apabila halaman tidak dapat diakses:

1. Coba buka kembali.
2. Periksa apakah URL mengalami pengalihan.
3. Coba metode pengambilan halaman lain.
4. Pastikan halaman tujuan merupakan dokumentasi resmi Kilo.
5. Jika tetap gagal, tandai sebagai gagal diakses.
6. Catat penyebab kegagalan.
7. Jangan mengarang isi dokumentasi tersebut.
8. Jangan mengubah status gagal menjadi sudah dibaca.

### C. Status wajib setiap URL

Gunakan status berikut:

- `DIBACA LENGKAP`
- `DIBACA SEBAGIAN`
- `GAGAL DIAKSES`
- `BELUM DIPERIKSA`

Status `DIBACA LENGKAP` hanya boleh diberikan apabila seluruh isi utama halaman berhasil dibaca.

### D. Bukti pembacaan

Untuk setiap URL, catat:

1. Nomor dokumentasi.
2. Judul halaman.
3. URL.
4. Status pembacaan.
5. Ringkasan materi yang benar-benar dibaca.
6. Informasi penting yang berkaitan dengan optimasi.

Jangan membuat ringkasan berdasarkan dugaan.

### E. Gerbang pemeriksaan dokumentasi

Sebelum melanjutkan ke rekomendasi:

- Pastikan seluruh 40 URL memiliki status.
- Pastikan semua halaman yang berhasil diakses sudah dibaca lengkap.
- Pastikan halaman yang gagal diakses dicatat.
- Pastikan tidak ada URL yang diam-diam dilewati.

Jika ada dokumentasi yang belum selesai dibaca, lanjutkan pemeriksaan.

Jika terdapat halaman yang tidak dapat diakses, tetap lakukan audit berdasarkan dokumentasi yang tersedia, tetapi nyatakan bahwa pemeriksaan dokumentasi belum sepenuhnya lengkap.

**Dilarang menyatakan seluruh dokumentasi telah dibaca apabila belum ada bukti pemeriksaan untuk seluruh 40 URL.**

## 6. TAHAP KEEMPAT — ANALISIS DAN AUDIT KILO CODE

Setelah dokumentasi diperiksa, lakukan analisis berikut.

### A. Struktur konfigurasi

Evaluasi:

- Konfigurasi global dan proyek.
- Custom Modes.
- Custom Agents.
- Custom Rules.
- Custom Instructions.
- Custom Subagents.
- Agent Permissions.
- `AGENTS.md`.
- Workflows.
- Skills.
- Marketplace.
- Struktur direktori.
- Konfigurasi yang duplikat.
- Konfigurasi yang sudah tidak digunakan.

Pastikan penempatan file mengikuti standar dokumentasi sesuai versi Kilo Code yang terpasang.

### B. Sistem Agents

Evaluasi:

- Pembagian tanggung jawab agent.
- Kesesuaian agent dengan pekerjaan.
- Model yang digunakan setiap agent.
- Kualitas instruksi.
- Izin akses.
- Penggunaan subagents.
- Delegasi pekerjaan.
- Pekerjaan yang berulang.
- Konflik tanggung jawab antaragent.

Pastikan setiap agent mempunyai fungsi yang jelas.

Jangan membuat agent tambahan apabila agent yang tersedia sudah dapat menangani tugas tersebut.

### C. Rules dan Instructions

Periksa apakah aturan:

- Tidak bertentangan.
- Tidak duplikat.
- Tidak ambigu.
- Tidak terlalu panjang tanpa manfaat.
- Mempunyai prioritas yang jelas.
- Sesuai dengan dokumentasi resmi.
- Ditempatkan pada lokasi yang tepat.
- Tidak memberikan instruksi yang sama berulang kali.

Jangan menghapus aturan hanya karena terlihat panjang. Evaluasi manfaat dan fungsinya terlebih dahulu.

### D. Agent Permissions

Periksa:

- Izin membaca file.
- Izin mengubah file.
- Izin menjalankan perintah terminal.
- Izin menggunakan browser.
- Izin menggunakan tools.
- Izin delegasi pekerjaan.
- Pengaturan persetujuan tindakan.

Utamakan keamanan dan kendali pengguna.

Jangan mengubah izin yang berisiko menjadi Allow secara otomatis.

### E. Context Management

Evaluasi:

- Codebase Indexing.
- Context Condensing.
- `.kilocodeignore`.
- Context Mentions.
- Session History.
- Penggunaan konteks file.
- Pengelolaan konteks yang berulang.
- Informasi yang tidak diperlukan.
- Efisiensi pemakaian context window.

Tujuannya adalah membuat AI memahami proyek secara akurat tanpa membebani konteks dengan informasi yang tidak relevan.

### F. Model Selection

Evaluasi:

- Kemampuan analisis.
- Kemampuan memahami proyek.
- Kemampuan mengikuti instruksi.
- Kemampuan menulis kode.
- Kemampuan debugging.
- Kemampuan menggunakan tools.
- Kecepatan respons.
- Ketersediaan model gratis.
- Kesesuaian model dengan jenis pekerjaan.

Prioritaskan model yang sudah tersedia dan bisa digunakan tanpa menambah saldo kredit.

Jangan merekomendasikan pembelian kredit.

### G. Productivity Features

Evaluasi manfaat:

- Autocomplete.
- Enhance Prompt.
- Browser Use.
- Task Todo List.
- Checkpoints atau Snapshots.
- File Encoding.
- Message Feedback.
- Session Goals.
- Session History.

Tentukan apakah fitur tersebut:

- Bermanfaat untuk kebutuhan pengguna.
- Sudah tersedia.
- Perlu diaktifkan.
- Tidak diperlukan.
- Tidak didukung versi saat ini.

### H. Gas Town dan Wasteland

Evaluasi secara terpisah.

Periksa:

- Fungsi masing-masing komponen.
- Arsitektur orkestrasi.
- Hubungan antaragent.
- Kebutuhan instalasi.
- Kebutuhan infrastruktur.
- Kebutuhan integrasi.
- Kompleksitas penggunaan.
- Penggunaan sumber daya.
- Potensi biaya.
- Manfaat nyata untuk pekerjaan pengguna.

Jangan menganggap Gas Town dan Wasteland wajib digunakan.

Jangan merekomendasikan instalasi jika manfaatnya tidak sebanding dengan kompleksitas dan keterbatasan lingkungan kerja.

## 7. TAHAP KELIMA — PEMERIKSAAN KONFLIK DAN KOMPATIBILITAS

Sebelum mengubah konfigurasi, periksa konflik pada:

1. Konfigurasi global dan konfigurasi proyek.
2. Custom Modes dan Custom Agents.
3. Custom Rules dan `AGENTS.md`.
4. Rules dan Skills.
5. Custom Instructions.
6. Agent Permissions.
7. Workflows dan Subagents.
8. Konfigurasi model.
9. Context Management.
10. Konfigurasi yang berasal dari versi Kilo sebelumnya.

Perhatikan perbedaan arsitektur Kilo Code versi lama dan terbaru.

Jika suatu fitur mengalami perubahan nama, struktur, atau mekanisme kerja:

- Pelajari mekanisme terbaru.
- Identifikasi konfigurasi lama yang berkaitan.
- Tentukan apakah konfigurasi lama masih didukung.
- Periksa apakah terdapat mekanisme migrasi.
- Jangan menerapkan konfigurasi lama pada versi baru secara membabi buta.
- Catat perubahan kompatibilitas dalam laporan.

Jika ada konflik:

1. Tampilkan aturan atau konfigurasi pertama.
2. Tampilkan aturan atau konfigurasi kedua.
3. Jelaskan pertentangannya.
4. Jelaskan dampaknya.
5. Tentukan solusi berdasarkan dokumentasi resmi.

Jangan menebak maksud konfigurasi yang belum jelas.

## 8. TAHAP KEENAM — PEMERIKSAAN DAN PENGHAPUSAN EKSTENSI KILO VERSI LAMA

**Tujuan:** Menghapus direktori ekstensi Kilo Code versi lama yang masih tertinggal setelah pembaruan, tanpa menghapus versi terbaru yang sedang digunakan.

Saya menginginkan direktori instalasi ekstensi Kilo Code tetap bersih dan tidak menyimpan salinan versi lama yang tidak lagi diperlukan.

### A. Identifikasi ekstensi yang terpasang

Periksa ekstensi Kilo Code yang terpasang pada editor saat ini.

Identifikasi:

- Nama ekstensi.
- Publisher.
- Extension ID.
- Versi aktif.
- Versi terbaru yang terpasang.
- Saluran rilis yang digunakan, misalnya stable atau pre-release.
- Direktori instalasi.
- Direktori ekstensi yang benar-benar digunakan editor.

Gunakan informasi dari editor dan manifest ekstensi `package.json`.

Jangan menebak Extension ID.

Pastikan ekstensi yang diperiksa merupakan ekstensi Kilo Code resmi, bukan ekstensi pihak ketiga yang hanya memiliki nama serupa.

### B. Periksa versi yang terpasang melalui CLI

Jika editor mendukung perintah CLI, gunakan pemeriksaan ekstensi berikut:

```bash
code --list-extensions --show-versions
```

Perintah tersebut digunakan untuk memeriksa ID dan versi ekstensi yang terdaftar.

Sesuaikan nama executable dengan editor yang benar-benar digunakan, misalnya `code`, `codium`, atau executable lain yang tersedia.

Jika diperlukan, periksa juga direktori ekstensi menggunakan opsi `--extensions-dir` yang sesuai dengan lingkungan editor.

Jangan menganggap semua editor mempunyai lokasi instalasi yang sama.

### C. Temukan direktori ekstensi

Identifikasi lokasi direktori ekstensi yang benar-benar digunakan.

Periksa:

- Argument `--extensions-dir` jika tersedia.
- Variabel lingkungan `VSCODE_EXTENSIONS` jika digunakan.
- Konfigurasi editor.
- Lokasi ekstensi pada lingkungan lokal.
- Lokasi ekstensi pada lingkungan remote atau server.

Direktori seperti berikut hanya boleh dianggap sebagai kandidat pemeriksaan, bukan lokasi yang pasti:

```text
~/.vscode/extensions/
~/.vscode-server/extensions/
~/.vscode-server-insiders/extensions/
~/.local/share/code-server/extensions/
~/.openvscode-server/extensions/
```

Jangan melakukan penghapusan sebelum memastikan direktori tersebut benar-benar digunakan oleh editor.

### D. Identifikasi versi lama

Periksa direktori yang berkaitan dengan Extension ID Kilo Code.

Untuk setiap direktori kandidat, baca manifest `package.json` dan periksa:

- `publisher`
- `name`
- `version`

Gunakan identitas ekstensi dan perbandingan versi semantik (Semantic Versioning) apabila format versinya mendukung.

Jangan menentukan versi lama hanya berdasarkan:

- Nama direktori.
- Waktu pembuatan file.
- Waktu modifikasi.
- Urutan hasil perintah `ls`.
- Urutan alfabetis.

Periksa juga apakah versi tersebut merupakan:

- Versi stable.
- Versi pre-release.
- Versi snapshot atau development.
- Salinan instalasi dari extension ID yang berbeda.

Jangan mencampur versi dari saluran rilis yang berbeda tanpa melakukan verifikasi.

### E. Ketentuan penghapusan

Apabila ditemukan beberapa direktori ekstensi dengan Extension ID Kilo Code yang sama:

1. Tentukan versi yang sedang digunakan editor.
2. Pastikan versi terbaru yang dipilih sudah terpasang dengan benar.
3. Pastikan Kilo Code dapat dijalankan menggunakan versi tersebut.
4. Identifikasi direktori versi lama yang tidak lagi digunakan.
5. Pastikan direktori tersebut bukan target symlink yang masih aktif.
6. Pastikan direktori tersebut bukan bagian dari instalasi editor lain atau profil lain.
7. Pastikan direktori tersebut bukan instalasi development yang masih dibutuhkan.
8. Catat seluruh direktori kandidat yang akan dihapus.
9. Hapus hanya direktori versi lama yang sudah terverifikasi tidak digunakan.

**Instruksi penghapusan:**

Lakukan penghapusan terhadap versi lama yang telah terbukti tidak digunakan.

Jangan hanya melaporkan bahwa versi lama ditemukan. Lakukan pembersihan apabila penghapusannya aman.

### F. Cara menghapus dengan aman

1. Utamakan mekanisme pengelolaan ekstensi resmi editor apabila ekstensi merupakan instalasi terpisah yang masih terdaftar.
2. Jika versi lama hanya berupa direktori fisik yang tertinggal dan tidak dapat dihapus melalui pengelola ekstensi, lakukan pembersihan direktori secara manual setelah diverifikasi.
3. Pastikan editor atau extension host tidak sedang menggunakan direktori yang akan dihapus.
4. Jika diperlukan, lakukan reload atau tutup editor secara aman sebelum membersihkan direktori.
5. Pastikan target penghapusan berada di dalam direktori ekstensi yang sudah diverifikasi.
6. Gunakan target direktori yang spesifik.
7. Jangan menghapus menggunakan wildcard yang terlalu luas.
8. Jangan menghapus folder induk ekstensi.
9. Jangan menghapus direktori versi terbaru.

**Dilarang menggunakan perintah berikut untuk menghapus versi lama apabila perintah tersebut justru menghapus seluruh ekstensi:**

```bash
code --uninstall-extension <extension-id>
```

Perintah tersebut merupakan perintah untuk menghapus ekstensi berdasarkan ID, bukan untuk memilih satu direktori versi lama saja.

Jangan menggunakannya untuk membersihkan versi lama jika versi terbaru masih harus dipertahankan.

### G. Data yang tidak boleh dihapus

Jangan menghapus:

- Versi Kilo Code yang sedang aktif.
- Konfigurasi pengguna.
- API key dan kredensial.
- Data akun.
- Global storage.
- Workspace storage.
- Riwayat percakapan.
- Database atau data internal Kilo Code.
- Cache yang belum terbukti aman dihapus.
- Ekstensi lain yang tidak berhubungan dengan Kilo Code.
- File proyek pengguna.

### H. Verifikasi setelah penghapusan

Setelah pembersihan:

1. Periksa kembali direktori ekstensi.
2. Pastikan versi lama yang ditargetkan sudah tidak ada.
3. Pastikan direktori versi terbaru masih tersedia.
4. Jalankan kembali pemeriksaan ekstensi menggunakan CLI jika tersedia.
5. Reload atau buka kembali editor secara aman jika diperlukan.
6. Pastikan Kilo Code dapat dibuka.
7. Pastikan Kilo Code tidak menampilkan kesalahan pemuatan ekstensi.
8. Pastikan konfigurasi dan data pengguna tetap tersedia.

Jika penghapusan tidak dapat dilakukan dengan aman, jangan memaksakan penghapusan. Jelaskan penyebabnya dalam laporan.

### I. Pencatatan pembersihan ekstensi

Catat dalam laporan:

- Extension ID.
- Versi yang aktif.
- Versi lama yang ditemukan.
- Lokasi direktori.
- Direktori yang dihapus.
- Direktori yang dipertahankan.
- Alasan penghapusan.
- Hasil verifikasi.

Jangan menyatakan direktori sudah bersih sebelum memeriksanya kembali.

## 9. TAHAP KETUJUH — SUSUN PRIORITAS OPTIMASI

Kelompokkan semua temuan menjadi empat kategori.

### Prioritas Tinggi

Masalah yang berdampak langsung terhadap:

- Ketepatan AI mengikuti instruksi.
- Keamanan konfigurasi.
- Konsistensi agent.
- Kegagalan penggunaan tools.
- Konflik aturan.
- Kerusakan konfigurasi.
- Masalah versi ekstensi.

### Prioritas Menengah

Optimasi yang meningkatkan:

- Efisiensi kerja.
- Kualitas analisis.
- Pengelolaan agent.
- Penggunaan konteks.
- Konsistensi hasil.
- Kecepatan pekerjaan.

### Prioritas Rendah

Penyempurnaan tambahan yang bermanfaat tetapi tidak mendesak.

### Tidak Direkomendasikan

Fitur atau perubahan yang:

- Tidak sesuai kebutuhan.
- Tidak didukung versi saat ini.
- Membutuhkan biaya tambahan.
- Terlalu kompleks.
- Berisiko merusak konfigurasi.
- Tidak memberikan manfaat yang sebanding.

Setiap rekomendasi wajib menjelaskan:

1. Kondisi saat ini.
2. Masalah yang ditemukan.
3. Dampak terhadap pekerjaan AI.
4. Solusi yang disarankan.
5. Alasan teknis.
6. Lokasi file atau pengaturan.
7. Risiko perubahan.
8. Status pelaksanaan.

Pisahkan fakta hasil pemeriksaan dengan rekomendasi dan pendapat teknis.

## 10. TAHAP KEDELAPAN — LAKUKAN OPTIMASI

Setelah analisis selesai:

1. Pertahankan konfigurasi yang sudah benar.
2. Perbaiki masalah yang jelas dan dapat diverifikasi.
3. Terapkan optimasi yang aman.
4. Hindari perubahan yang hanya bersifat kosmetik.
5. Hindari konfigurasi duplikat.
6. Jangan membuat agent baru tanpa kebutuhan.
7. Jangan menghapus file penting tanpa alasan teknis.
8. Jangan mengubah konfigurasi di luar kebutuhan optimasi.
9. Jika perubahan berisiko tinggi atau membutuhkan keputusan pengguna, jelaskan terlebih dahulu dan minta persetujuan.
10. Pastikan setiap perubahan sesuai dokumentasi resmi Kilo Code.
11. Pastikan versi ekstensi lama yang tidak diperlukan sudah dibersihkan apabila aman dilakukan.
12. Verifikasi perubahan setelah diterapkan.

Jangan mengubah semua pengaturan sekaligus tanpa memahami dampaknya.

Utamakan perubahan yang memberikan manfaat nyata.

## 11. TAHAP KESEMBILAN — PERBARUI LAPORAN OPTIMASI

**Target file: `./laporan_optimasi_kilo.md`**

Bagian ini wajib dilaksanakan.

### A. Masalah yang harus diatasi

AI sebelumnya sering mempertahankan isi laporan lama dan hanya menambahkan informasi baru.

Perilaku tersebut tidak saya inginkan.

Saya menginginkan laporan yang selalu mencerminkan kondisi pemeriksaan dan optimasi terbaru.

### B. Aturan pembaruan laporan

1. Baca laporan lama hanya untuk mengetahui informasi sebelumnya.
2. Gunakan laporan lama hanya sebagai bahan perbandingan.
3. Periksa ulang seluruh informasi yang pernah ditulis.
4. Hapus informasi yang sudah tidak benar.
5. Hapus rekomendasi yang sudah tidak relevan.
6. Hapus temuan yang sudah tidak berlaku.
7. Hapus informasi duplikat.
8. Jangan mempertahankan isi lama hanya karena sudah pernah ditulis.
9. Jangan sekadar menambahkan hasil terbaru di bagian bawah.
10. Jangan menggunakan metode append.
11. Jangan mempertahankan seluruh laporan lama lalu menambahkan bagian pembaruan.
12. Susun laporan baru berdasarkan kondisi aktual.

### C. Prosedur wajib mengganti seluruh isi laporan

Ikuti urutan ini:

1. Pastikan lokasi file laporan yang benar.
2. Baca laporan lama apabila tersedia.
3. Selesaikan audit dan optimasi.
4. Susun laporan baru secara menyeluruh.
5. Tulis laporan baru ke file sementara di direktori yang sama.
6. Periksa apakah file sementara tidak kosong dan memiliki seluruh bagian laporan yang diwajibkan.
7. Jika hasil sementara sudah lengkap, ganti seluruh isi file `laporan_optimasi_kilo.md` dengan laporan baru menggunakan operasi overwrite atau penggantian file.
8. Jangan menggunakan append.
9. Setelah penggantian, baca kembali file target.
10. Pastikan isi file benar-benar sesuai laporan baru.
11. Pastikan tidak ada bagian lama yang tertinggal tanpa alasan.
12. Bersihkan file sementara setelah proses berhasil.

Apabila laporan baru belum siap, jangan menghapus laporan lama terlebih dahulu.

Gunakan penggantian file secara aman agar laporan lama tidak hilang akibat proses penulisan yang gagal.

**KETENTUAN MUTLAK:**

Setiap pembaruan laporan harus mengganti keseluruhan isi laporan lama dengan laporan terbaru.

Bukan menambahkan informasi baru.

Bukan menggabungkan seluruh laporan lama dan laporan baru.

Bukan mempertahankan isi lama yang sudah tidak relevan.

### D. Struktur laporan terbaru

Susun `laporan_optimasi_kilo.md` dengan struktur berikut:

# LAPORAN OPTIMASI KILO CODE

## 1. Informasi Pemeriksaan

- Tanggal pemeriksaan.
- Versi Kilo Code.
- Versi editor.
- Platform.
- Lingkungan kerja.
- Lokasi konfigurasi.

## 2. Ringkasan Hasil Audit

- Kondisi keseluruhan.
- Masalah utama.
- Tingkat kesiapan konfigurasi.
- Kesimpulan awal.

## 3. Hasil Pembacaan Dokumentasi

Buat daftar seluruh 40 URL beserta:

- Nomor.
- Judul.
- URL.
- Status pembacaan.
- Ringkasan informasi yang dibaca.

## 4. Kondisi Konfigurasi Saat Ini

- Konfigurasi yang tersedia.
- Konfigurasi yang aktif.
- Konfigurasi yang belum digunakan.
- Konfigurasi yang perlu diperbaiki.

## 5. Temuan Masalah

- Nama masalah.
- Lokasi.
- Penyebab.
- Dampak.
- Prioritas.

## 6. Analisis Konflik dan Kompatibilitas

- Aturan yang bertentangan.
- Konfigurasi yang duplikat.
- Perbedaan versi.
- Masalah kompatibilitas.
- Solusi yang ditentukan.

## 7. Rekomendasi Optimasi

Pisahkan menjadi:

- Prioritas tinggi.
- Prioritas menengah.
- Prioritas rendah.
- Tidak direkomendasikan.

## 8. Hasil Optimasi

- Perubahan yang dilakukan.
- File yang diubah.
- Pengaturan yang diperbaiki.
- Alasan perubahan.
- Hasil verifikasi.

## 9. Pembersihan Ekstensi Kilo

- Extension ID.
- Versi aktif.
- Versi lama yang ditemukan.
- Lokasi direktori.
- Versi yang dihapus.
- Versi yang dipertahankan.
- Hasil verifikasi.

## 10. Pekerjaan yang Belum Dilakukan

- Nama pekerjaan.
- Alasan belum dilakukan.
- Risiko atau kendala.
- Persetujuan yang diperlukan.

## 11. Hasil Akhir

Jelaskan kondisi Kilo Code setelah optimasi.

## 12. Kesimpulan

Berikan kesimpulan berdasarkan hasil pemeriksaan dan verifikasi aktual.

## 12. TAHAP KESEPULUH — VERIFIKASI AKHIR

Sebelum menyelesaikan pekerjaan, pastikan:

### Dokumentasi

- [ ] Seluruh 40 URL sudah diperiksa.
- [ ] Setiap URL memiliki status pembacaan.
- [ ] Tidak ada halaman yang diklaim sudah dibaca tanpa bukti.
- [ ] Informasi dokumentasi sesuai versi Kilo Code.

### Konfigurasi

- [ ] Konfigurasi global dan proyek sudah diperiksa.
- [ ] Tidak ada konflik yang belum dicatat.
- [ ] Tidak ada duplikasi yang tidak diperlukan.
- [ ] Izin akses tetap aman.
- [ ] Perubahan sudah diverifikasi.

### Ekstensi

- [ ] Extension ID sudah diverifikasi.
- [ ] Versi aktif sudah diketahui.
- [ ] Direktori ekstensi sudah diperiksa.
- [ ] Versi lama yang tidak diperlukan sudah dibersihkan jika aman.
- [ ] Versi terbaru tetap tersedia.
- [ ] Kilo Code dapat dijalankan kembali.
- [ ] Data dan konfigurasi pengguna tetap tersedia.

### Laporan

- [ ] `laporan_optimasi_kilo.md` sudah diperbarui.
- [ ] Seluruh isi lama yang tidak relevan sudah diganti.
- [ ] Tidak menggunakan append.
- [ ] Isi laporan sudah dibaca ulang.
- [ ] Laporan mencerminkan kondisi terbaru.
- [ ] Tidak ada klaim yang tidak dapat dibuktikan.

Jika terdapat pekerjaan yang belum selesai, nyatakan secara terbuka.

Jangan menyatakan seluruh proses berhasil apabila masih ada tahapan yang belum diverifikasi.

## 13. FORMAT HASIL AKHIR KEPADA PENGGUNA

Setelah menyelesaikan pekerjaan, sampaikan hasil dengan struktur:

1. Kondisi Kilo Code sebelum optimasi.
2. Jumlah dokumentasi yang dibaca lengkap.
3. Dokumentasi yang gagal atau hanya dibaca sebagian.
4. Masalah yang ditemukan.
5. Optimasi yang berhasil dilakukan.
6. File konfigurasi yang diubah.
7. Ekstensi Kilo versi lama yang berhasil dihapus.
8. Versi ekstensi yang dipertahankan.
9. Pekerjaan yang belum dilakukan beserta alasannya.
10. Hasil verifikasi.
11. Lokasi laporan: `./laporan_optimasi_kilo.md`.

Jangan mengklaim berhasil jika belum melakukan verifikasi.

---

## 14. PRINSIP UTAMA

Optimalkan Kilo Code berdasarkan kebutuhan nyata, bukan berdasarkan banyaknya fitur yang digunakan.

Prioritaskan:

- Akurasi AI dalam memahami instruksi.
- Konsistensi perilaku agent.
- Penggunaan tools yang tepat.
- Efisiensi konteks.
- Keamanan konfigurasi.
- Penggunaan model yang tersedia tanpa menambah kredit.
- Kebersihan instalasi ekstensi.
- Kemudahan pemeliharaan.

**LAPORAN HARUS SELALU MENCERMINKAN KONDISI TERBARU.**

Setiap pembaruan wajib mengganti seluruh isi laporan lama yang sudah tidak relevan.

Seluruh dokumentasi wajib diperiksa satu per satu.

Jangan melewati pemeriksaan, jangan mengarang hasil, dan jangan mengklaim pekerjaan selesai tanpa verifikasi.
