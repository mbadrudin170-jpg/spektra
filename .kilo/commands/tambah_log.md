---
description: Menambahkan log debug terstruktur (L.i, L.w, L.e) secara presisi pada variabel dan parameter di file Dart yang ditentukan sesuai standar proyek.
agent: code
---

# TUJUAN UTAMA

Perintahkan AI untuk menambahkan baris log debug terstruktur menggunakan utilitas kelas `L` pada file-file Dart yang ditentukan oleh pengguna secara presisi, terstruktur, tidak berlebihan, dan mematuhi arsitektur logging proyek.

# REFERENSI PATH & ARSITEKTUR KODE

1. **Path Berkas Command:** `.kilo/commands/tambah_log.md`
2. **Path Utilitas Log Utama:** `lib/shared/utils/l.dart` (Pengganti `log.dart` dan `print_util.dart`).
3. **Aturan Global:** Wajib membaca dan mematuhi file `.agents/rules/AGENTS.md` serta memeriksa batasan tool di `.kilo/commands/izin_kilo.md`.

# KETENTUAN PENEMPATAN LOG (PLACEMENT RULES)

1. **Setelah `L.init();`:**
   - Semua penambahan log debug utama **HANYA** boleh dilakukan di dalam fungsi/metode setelah pemanggilan `L.init();`.
   - Gunakan metode statis kelas `L` (`L.i`, `L.s`, `L.w`, `L.e`, dll.).
2. **Sebelum `L.init();`:**
   - Jika terdapat variabel atau alur yang harus dicek sebelum `L.init();` dipanggil (misalnya pada level inisialisasi awal aplikasi atau konstruktor global), **DILARANG** menggunakan kelas `L`.
   - Wajib menggunakan `debugPrint` standar yang dibungkus dengan pengecekan `kDebugMode` (contoh: `if (kDebugMode) debugPrint('...');`).

# STANDAR FORMAT & POLA PENULISAN METODE LOG `L`

AI wajib mengikuti pola dan redaksi berikut secara konsisten:

1. **`L.i()` - Informasi Variabel / Parameter:**
   - **Prinsip:** Jangan terlalu detail, cukup ambil nilai variabel atau parameter yang relevan untuk memantau status data.
   - **Contoh Penulisan:**
     ```dart
     L.i('kopi=$kopi, susu=$susu, teh=$teh');
     ```

2. **`L.w()` - Peringatan / Warning:**
   - **Prinsip:** Sama seperti `L.i()`, namun tambahkan sedikit informasi konteks kondisi peringatan beserta nilai variabel pendukungnya.
   - **Contoh Penulisan:**
     ```dart
     L.w('pengguna menolak izin, izin=$izin');
     ```

3. **`L.e()` - Error / Kegagalan (Penanganan Khusus):**
   - **Prinsip:** Wajib menyertakan informasi objek error (`$e`) dan stack trace (`$s`) untuk keperluan debugging exception.
   - **Contoh Penulisan:**
     ```dart
     L.e('gagal melakukan tambah pengguna: $e$s');
     ```

4. **Penanganan Variabel Berupa Model / Objek:**
   - **Prinsip:** Untuk variabel bertipe model atau objek kompleks, cukup interpolasikan objek model itu sendiri secara langsung, atau akses properti utamanya jika diperlukan.
   - **Contoh Penulisan Benar:**
     ```dart
     L.i('data_user=$model');
     // atau jika spesifik:
     L.i('nama=${model.nama}, umur=${model.umur}');
     ```

# ALUR KERJA (STEP-BY-STEP WORKFLOW)

1. **Analisis File Target:**
   - Gunakan tool `read` untuk membaca isi file Dart yang ditentukan oleh pengguna secara menyeluruh. Jangan menggunakan terminal atau perintah `cat`/`sed`.
2. **Pemeriksaan Posisi Inisialisasi:**
   - Cari baris pemanggilan `L.init();` di dalam file tersebut untuk menentukan batas area penambahan log `L`.
3. **Penyisipan Log:**
   - Identifikasi variabel atau parameter penting pada fungsi yang diminta, lalu sisipkan baris log sesuai format standar di atas (`L.i`, `L.w`, atau `L.e`).
4. **Validasi Sintaks & Linter:**
   - Setelah selesai menyisipkan log, jalankan `flutter analyze` pada file terkait untuk memastikan tidak ada kesalahan penulisan, tipe data, maupun pelanggaran aturan linter.

# LARANGAN KERAS (PROHIBITIONS)

1. **Dilarang Over-Logging:** Jangan menambahkan log pada setiap baris secara membabi buta; hanya tambahkan pada titik variabel kunci atau parameter penting yang ditentukan.
2. **Dilarang Salah Posisi:** Dilarang menggunakan metode `L.i()`, `L.w()`, atau `L.e()` sebelum baris `L.init();` dipanggil.
3. **Dilarang Ubah Logika Bisnis:** AI dilarang memodifikasi logika program, struktur pengendali alur (`if`/`for`), atau kode Dart di luar penambahan fungsi logging.
4. **Dilarang Pakai Terminal untuk Edit:** Wajib menggunakan tool `edit` yang disediakan, dilarang menggunakan manipulasi file via terminal command.
