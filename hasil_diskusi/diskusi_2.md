# Hasil Diskusi 2 — Menampilkan spesifikasi baterai perangkat pengguna

## Status
- Dokumen: Final
- Implementasi: Belum Diimplementasikan
- Tanggal: 2026-11-13
- Topik: Menampilkan spesifikasi baterai perangkat pengguna (kapasitas mAh, level, status pengisian, kesehatan, suhu, tegangan, tipe baterai) di aplikasi Flutter; topik bersumber dari `keluhan.md`

## Latar Belakang
Keluhan pengguna (`keluhan.md`): "saya ingin menampilkan spesifikasi baterai perangkat user, misalnya berapa mah, apakah terhubung ke cargher". Proyek `spektra` masih tahap awal (hanya `lib/main.dart` dan `test/widget_test.dart`; belum ada fitur `lib/fitur/...`). Dokumen `docs/` tidak memuat referensi fitur baterai/statistik, dan `docs/struktur_proyek.md` belum terverifikasi sinkron dengan kode sumber. Konteks utama yang perlu diputuskan sebelum implementasi adalah ketersediaan data baterai per platform dan package yang dipakai.

Fakta teknis yang relevan (terverifikasi lewat dokumentasi Android dan pub.dev, 2026-11-13):

- Android tidak menyediakan API publik untuk **kapasitas desain** baterai (mAh pabrik). Nilai kapasitas hanya tersedia lewat hidden setting (sering `/sys/class/power_supply/battery/charge_full_design`) dan tidak tersedia di sebagian perangkat.
- `BATTERY_PROPERTY_CAPACITY` adalah **persentase** kapasitas tersisa, bukan mAh. `BATTERY_PROPERTY_CHARGE_COUNTER` adalah muatan tersisa dalam µAh, bukan kapasitas desain.
- iOS hanya menyediakan `batteryLevel` dan `batteryState` (batasan Apple); kapasitas mAh tidak tersedia.
- Web tidak memiliki API baterai yang dapat dipakai oleh Flutter (Battery Status API tidak tersedia/tidak didukung).
- Package `battery_info_v2` 1.1.5 (dirilis 2025-09-19, MIT, Android + iOS, 1 like, ~192 unduhan, publisher unverified, tanpa ketergantungan selain Flutter) menyediakan `AndroidBatteryInfo`: kapasitas (mAh, dari hidden setting), level, status pengisian, estimasi waktu terisi (API 28+), health, plugged status, teknologi, suhu, tegangan, dan aliran stream `androidBatteryInfoStream`. Package asli `battery_info` 1.1.1 (2022) tidak terawat. Package `battery` (resmi komunitas) hanya menyediakan level dan status pengisian.
- Contoh pemakaian (dari dokumentasi `battery_info_v2`):

```dart
import 'package:battery_info_v2/battery_info_v2.dart';
import 'package:battery_info_v2/model/android_battery_info.dart';

final AndroidBatteryInfo? info = await BatteryInfoPlugin().androidBatteryInfo;
final int? capacityMah = info == null ? null : (info.batteryCapacity / 1000).round();
```

## Poin Diskusi
### 1. Untuk apa spesifikasi baterai ditampilkan?
- Tanya: Apakah data baterai dipakai sebagai statistik/monitoring aplikasi, bagian dari layar profil, atau elemen motivasi?
- Kesimpulan: Dipakai sebagai **statistik/monitoring aplikasi**. Namun dipersempit menjadi snapshot kondisi saat ini (bukan riwayat historis).

### 2. Platform target
- Tanya: Platform mana yang menjadi target fitur ini?
- Kesimpulan: **Android saja**. Platform lain (iOS/web) ditangani dengan fallback pesan "tidak didukung" atau section disembunyikan; tidak ada implementasi data baterai untuk iOS/web.

### 3. Data yang ingin ditampilkan
- Tanya: Field Android apa saja yang ingin ditampilkan?
- Kesimpulan: Berikut semua dipilih: **kapasitas desain (mAh)**, **level persen**, **status & sumber charger** (charging/discharging/full; AC/USB/wireless), **kesehatan, suhu, tegangan**, dan **tipe/teknologi baterai**.

### 4. Definisi "berapa mAh"
- Tanya: mAh merujuk ke kapasitas desain atau kapasitas tersisa?
- Kesimpulan: **Kapasitas desain** (dari hidden Android setting lewat `battery_info_v2`). Bila tidak tersedia di perangkat, tampilkan `Tidak diketahui` — jangan menebak atau menampilkan charge counter sebagai pengganti tanpa label.

### 5. Package yang dipakai
- Tanya: Package mana yang dipakai untuk membaca data baterai?
- Kesimpulan: **`battery_info_v2` 1.1.5** (pilihan pengguna; alternatif yang dipertimbangkan: `battery_info` 1.1.1 yang tidak terawat, dan `battery` yang tidak menyediakan kapasitas mAh).

### 6. Lokasi tampilan
- Tanya: Di mana informasi baterai ditampilkan?
- Kesimpulan: **Bagian dari halaman statistik**. Catatan: halaman statistik belum ada di `lib/` maupun `docs/`; halaman/fitur statistik itu sendiri belum ada dan harus diputuskan/dirancang terpisah (lihat Pertanyaan Terbuka).

### 7. Cara pembaruan data
- Tanya: Manual refresh atau stream realtime?
- Kesimpulan: **Manual refresh** — sekali baca saat layar dibuka (FutureBuilder) plus tombol muat ulang. Bukan `androidBatteryInfoStream` (lebih hemat resource dan lebih sederhana untuk snapshot).

### 8. Sifat monitoring
- Tanya: Apakah monitoring berarti menyimpan riwayat data baterai ke database?
- Kesimpulan: **Tidak** — cukup snapshot kondisi saat ini pada halaman statistik; tidak ada penyimpanan/grafik historis dan tidak perlu perubahan skema SQLite.

## Keputusan
- K-1: Fitur spesifikasi baterai ditampilkan sebagai bagian dari **halaman statistik** aplikasi.
- K-2: Target platform adalah **Android saja**; iOS/web menampilkan fallback pesan "tidak didukung" atau menyembunyikan section.
- K-3: Data yang ditampilkan: kapasitas desain (mAh), level persen, status & sumber pengisian (AC/USB/wireless), kesehatan (health), suhu, tegangan, dan tipe/teknologi baterai.
- K-4: "mAh" yang dimaksud adalah **kapasitas desain** dari hidden Android setting; bila tidak tersedia di perangkat, tampilkan `Tidak diketahui` (dilarang menampilkan charge counter seolah-olah kapasitas desain).
- K-5: Package yang dipakai adalah **`battery_info_v2`** (`battery_info_v2: ^1.1.5`).
- K-6: Data diperbarui dengan **manual refresh** (baca sekali saat layar dibuka + tombol muat ulang); bukan stream realtime.
- K-7: Monitoring bersifat **snapshot kondisi saat ini**; tidak ada penyimpanan historis, tidak ada perubahan skema database.
- K-8: Status dokumen `Final` (diubah dari `Draft` pada 2026-11-14 atas persetujuan pengguna pada sesi tindak lanjut); fitur belum diimplementasikan dan halaman statistik itu sendiri belum ada.

## Rekomendasi
- R-1: Bungkus pembacaan baterai dalam satu repository/helper (mis. `BatteryRepository`) yang mengembalikan model/DTO nullable-toleran; jangan memanggil plugin langsung dari widget, agar mudah di-mock di test dan mudah diganti bila `battery_info_v2` tidak terawat lagi.
- R-2: Tangani nilai yang tidak tersedia secara eksplisit: kapasitas desain, suhu, tegangan, dan health dapat bernilai tidak valid/0 di sebagian perangkat — tampilkan `Tidak diketahui` dan jangan tampilkan nilai 0 sebagai data sah.
- R-3: Verifikasi di perangkat fisik Android (bukan emulator) — banyak properti baterai mengembalikan 0/-1 di emulator dan di sebagian OEM.
- R-4: Karena `battery_info_v2` adalah publisher unverified dengan adopsi sangat rendah (1 like, ~192 unduhan), tinjau lisensi (MIT — aman dipakai) dan pertimbangkan pin versi (`^1.1.5`) serta catat risiko maintenance; jika suatu saat tidak terawat, alternatif `battery_ffi` (Android, FFI/JNI) atau platform channel kustom perlu dievaluasi.
- R-5: Karena Android API untuk kapasitas desain non-publik, sertakan catatan di UI (tooltip/keterangan kecil) bahwa nilai mAh dapat berbeda antar perangkat.
- R-6: Jika halaman statistik belum ada saat implementasi dimulai, buat halaman statistik minimal terlebih dahulu sebagai wadah section baterai, atau laporkan/tanyakan ke pengguna sebelum menambah cakupan di luar `keluhan.md`.
- R-7: Periksa `AndroidManifest.xml` — `BATTERY_STATS` **tidak boleh** diminta (signature/system permission); data baterai dapat dibaca tanpa izin runtime. Jangan menambahkan permission yang tidak perlu.

## Tindak Lanjut
| No | Tindakan | File Terdampak | Status |
|----|----------|----------------|--------|
| 1  | Rancang halaman statistik (belum ada) sebagai wadah section baterai; putuskan bersama pengguna cakupannya | `lib/fitur/...` (belum diketahui), `docs/` | belum |
| 2  | Tambahkan dependency `battery_info_v2: ^1.1.5` ke `pubspec.yaml` dan jalankan `flutter pub get` | `pubspec.yaml` | belum |
| 3  | Buat repository/helper pembacaan baterai (snapshot, nullable-toleran, Android-only dengan guard platform) | `lib/...` (belum diketahui) | belum |
| 4  | Buat widget section "Spesifikasi Baterai" (kapasitas desain mAh, level, status/sumber charger, health, suhu, tegangan, teknologi) dengan tombol muat ulang | `lib/...` (belum diketahui) | belum |
| 5  | Fallback pesan "tidak didukung" untuk iOS/web; sembunyikan/ganti section pada platform non-Android | `lib/...` (belum diketahui) | belum |
| 6  | Verifikasi di perangkat fisik Android; catat perangkat yang kapasitas desainnya tidak tersedia | — | belum |
| 7  | Verifikasi `dart format`, `dart analyze`, `flutter test` | — | belum |

## File Terdampak
| Lokasi File | Status Perubahan | Deskripsi |
|-------------|------------------|-----------|
| `keluhan.md` | — | Sumber topik diskusi (tidak diubah) |
| `pubspec.yaml` | Diubah (rencana) | Menambah `battery_info_v2: ^1.1.5` |
| `lib/...` (halaman statistik + section baterai) | Dibuat/Diubah (rencana) | Lokasi belum diketahui; halaman statistik belum ada |
| `android/app/src/main/AndroidManifest.xml` | Diubah (rencana, bila perlu) | Tidak menambah permission `BATTERY_STATS`; hanya memastikan konfigurasi plugin |
| `hasil_diskusi/diskusi_2.md` | Dibuat | Berkas hasil diskusi ini |

## Pertanyaan Terbuka
- Halaman statistik sebagai wadah section baterai belum ada di `lib/` maupun `docs/` — apakah halaman statistik dirancang khusus untuk fitur ini, atau ditunda sampai ada halaman statistik yang direncanakan?
- Nama/lokasi fitur dan file untuk section baterai belum ditentukan (proyek belum memiliki `lib/fitur/...`).
- Apakah fitur ini perlu dicatat di dokumen spesifikasi (`docs/`) sebelum implementasi?

## Riwayat Perubahan
| Tanggal | Perubahan |
|---------|-----------|
| 2026-11-13 | Berkas dibuat dari diskusi mode diskusi; keputusan K-1 s.d. K-8; pertanyaan terbuka dicatat. |
| 2026-11-14 | Status dokumen diubah `Draft` → `Final` atas persetujuan pengguna (sesi tindak lanjut); Implementasi tetap `Belum Diimplementasikan`. |
