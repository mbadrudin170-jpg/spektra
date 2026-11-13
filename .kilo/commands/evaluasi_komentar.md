# Evaluasi dan Perbaikan Komentar Dart

**Path:** `.kilo/commands/evaluasi_komentar.md`

## Tujuan

Command ini digunakan untuk mengevaluasi dan memperbaiki komentar pada seluruh file Dart di dalam folder `lib/`.

AI harus menemukan komentar yang tidak memberikan manfaat nyata, memastikan seluruh komentar dokumentasi `///` hanya menggunakan satu baris, kemudian langsung memperbaiki kode Dart berdasarkan hasil evaluasi.

## Aturan Evaluasi

### 1. Evaluasi Komentar

- Telusuri seluruh folder `lib/` beserta subfoldernya.
- Periksa komentar pada seluruh file Dart.
- Identifikasi komentar yang tidak memberikan manfaat nyata terhadap pemahaman, dokumentasi, atau pemeliharaan kode.
- Temukan komentar yang hanya mengulang informasi yang sudah jelas dari kode.
- Temukan komentar yang tidak relevan, berlebihan, atau sudah tidak sesuai dengan implementasi.
- Jangan menghapus komentar yang memberikan informasi teknis, alasan implementasi, batasan, atau penjelasan logika yang penting.

### 2. Komentar Dokumentasi `///`

- Seluruh komentar dokumentasi dengan format `///` wajib hanya terdiri dari satu baris.
- Jika ditemukan komentar dokumentasi multibaris, perbaiki menjadi satu baris tanpa menghilangkan maksud dan informasi pentingnya.
- Pertahankan format dokumentasi yang sesuai dengan sintaks Dart.

### 3. Pengecualian Komentar Header

Abaikan komentar path file pada bagian header file.

Contoh:

`// lib/fitur/contoh/page/halaman.dart`

Komentar tersebut tidak boleh dihapus, diperbaiki, atau dilaporkan sebagai temuan.

Pengecualian ini hanya berlaku untuk komentar path file yang berada pada bagian header.

## Aturan Perbaikan

1. Setelah menemukan komentar yang tidak memberikan manfaat nyata, langsung hapus komentar tersebut.
2. Jika komentar masih diperlukan tetapi redaksinya tidak sesuai, perbaiki redaksinya tanpa mengubah maksud aslinya.
3. Jika komentar dokumentasi `///` terdiri dari beberapa baris, ringkas menjadi satu baris dengan tetap mempertahankan informasi penting.
4. Jangan mengubah implementasi, logika bisnis, struktur, atau perilaku kode Dart.
5. Jangan melakukan refactoring yang tidak berkaitan dengan perbaikan komentar.
6. Jangan mengubah nama variabel, fungsi, class, maupun identifier lainnya.
7. Jangan menambahkan komentar baru kecuali diperlukan untuk mempertahankan informasi penting yang sebelumnya sudah ada.
8. Pertahankan format dan indentasi kode yang sudah ada sejauh memungkinkan.

## Alur Kerja

### 1. Persiapan

- Baca `AGENTS.md` dan aturan proyek yang relevan sebelum bekerja.
- Pahami batasan perubahan yang berlaku pada proyek.
- Identifikasi seluruh file Dart di dalam folder `lib/`.

### 2. Pemeriksaan

- Periksa komentar setiap file Dart.
- Evaluasi manfaat setiap komentar berdasarkan konteks implementasi.
- Periksa komentar dokumentasi `///`.
- Abaikan komentar path file pada header.

### 3. Eksekusi Perbaikan

- Langsung perbaiki seluruh temuan yang memenuhi kriteria.
- Hapus komentar yang tidak memberikan manfaat.
- Perbaiki komentar yang masih diperlukan tetapi redaksinya kurang tepat.
- Ubah komentar dokumentasi multibaris menjadi satu baris.
- Jangan berhenti hanya dengan memberikan daftar temuan. Lanjutkan hingga seluruh perbaikan selesai.

### 4. Verifikasi

Setelah perbaikan:

- Periksa kembali seluruh file yang diubah.
- Pastikan tidak ada komentar dokumentasi `///` yang masih multibaris.
- Pastikan komentar path file pada header tetap dipertahankan.
- Pastikan tidak ada perubahan implementasi atau perilaku kode.
- Jalankan `dart format` pada file Dart yang diubah jika diperlukan untuk memastikan format kode tetap valid.
- Periksa hasil akhir perubahan.

## Format Laporan Akhir

Setelah seluruh pekerjaan selesai, sampaikan laporan dengan struktur berikut:

### A. Ringkasan

- Jumlah file Dart yang diperiksa.
- Jumlah komentar yang dihapus.
- Jumlah komentar yang diperbaiki.
- Jumlah komentar dokumentasi multibaris yang diringkas.

### B. Detail Perubahan

- Path file yang diubah.
- Jenis perubahan.
- Penjelasan singkat mengenai perubahan.

### C. Verifikasi

- Status pemeriksaan komentar `///`.
- Status pengecualian komentar header.
- Status pemeriksaan perubahan kode.
- Hasil `dart format` jika dijalankan.

### D. Temuan yang Tidak Dapat Diperbaiki

Jika terdapat komentar yang membutuhkan keputusan atau klarifikasi pengguna, jangan menebak. Cantumkan path, nomor baris, dan alasan mengapa komentar tersebut belum diperbaiki.

## Batasan Eksekusi

- Perubahan hanya diperbolehkan pada komentar di file Dart dalam folder `lib/`.
- Dilarang mengubah implementasi atau perilaku kode.
- Dilarang mengubah file di luar folder `lib/`.
- Dilarang mengubah file generated seperti `.g.dart` dan `.freezed.dart`.
- Dilarang menghapus komentar yang memberikan informasi penting.
- Wajib mempertahankan komentar path file pada header.

**Prinsip utama: Periksa seluruh komentar, evaluasi manfaatnya, langsung perbaiki temuan yang memenuhi kriteria, kemudian verifikasi bahwa perubahan tidak memengaruhi implementasi kode.**
