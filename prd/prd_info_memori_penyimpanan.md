# PRODUCT REQUIREMENTS DOCUMENT (PRD)

**Status Dokumen:** Final

**Status Implementasi:** Sedang Diimplementasikan

---

## 1. Informasi Produk

**Konteks penggunaan:**
Digunakan untuk mengidentifikasi produk dan memberikan gambaran umum proyek. Informasi ini menjadi identitas utama PRD.

**Aturan pengisian:**
- Isi informasi berdasarkan kondisi dan identitas proyek yang sebenarnya.
- Gunakan nama yang konsisten dengan proyek.
- Tuliskan platform dan versi yang menjadi target pengembangan.
- Bedakan status dokumen dengan status implementasi.
- Jangan mengarang informasi yang belum diketahui.

**Informasi:**
- Nama aplikasi: Spektra
- Deskripsi produk: Aplikasi info/diagnostik perangkat Android ("Know Your Device"), lokal-first (lihat `README.md`)
- Platform: Android (bagian lain aplikasi juga berjalan di iOS/web, tetapi fitur pada PRD ini Android-only)
- Versi: Spektra `1.0.0+1`; Dart `^3.13.7`; Flutter `3.47.9`
- Status pengembangan: belum ada fitur produk yang tersedia di kode; baru kerangka + section statistik baterai (`lib/fitur/statistik/`)

## 2. Tujuan PRD

**Konteks penggunaan:**
Digunakan untuk menentukan hasil yang ingin dicapai dari dokumen PRD ini. Tujuan harus berhubungan langsung dengan kebutuhan dokumen.

**Aturan pengisian:**
- Tuliskan hasil yang diharapkan dari PRD.
- Pastikan setiap tujuan memiliki hubungan dengan kebutuhan dokumen PRD.
- Gunakan tujuan yang jelas dan dapat dievaluasi.
- Jangan memasukkan tujuan yang berada di luar ruang lingkup PRD.

**Isi:**
PRD ini menetapkan kebutuhan, cakupan, alur, dan file terdampak untuk fitur **Info memori & penyimpanan** (kode item `A5` di `refrensi_apk.md`), yaitu salah satu dari tiga pilar spesifikasi dasar (CPU/RAM/penyimpanan) yang diharapkan pengguna "Know Your Device" (`refrensi_apk.md:69-73`). Hasil yang diharapkan: pengguna Android dapat melihat RAM total/terpakai/tersedia serta kapasitas penyimpanan internal (terpakai/bebas) langsung dari aplikasi, tanpa izin khusus, dengan nilai yang tidak valid/tidak tersedia ditampilkan sebagai `Tidak diketahui` — tidak mengarang data. Dokumen ini menjadi acuan implementasi terpisah; pembuatan PRD ini **tidak** mengubah kode Dart.

## 3. Daftar Fitur

**Konteks penggunaan:**
Digunakan untuk melihat keseluruhan fitur produk dan menentukan tingkat kepentingannya.

**Aturan pengisian:**
- Setiap fitur harus memiliki nama dan deskripsi yang jelas.
- Satu baris mewakili satu fitur yang dapat diidentifikasi secara terpisah.
- Hindari menggabungkan beberapa fitur berbeda dalam satu baris.
- Pastikan fitur mendukung tujuan produk dan masuk dalam ruang lingkup.
- Gunakan prioritas berdasarkan kepentingan kebutuhan produk.

| Fitur | Deskripsi | Prioritas   |
| ----- | --------- | ----------- |
| Info RAM | Total fisik (`physicalRamSize`, MB), tersedia (`availableRamSize`, MB), dan terpakai (`total - tersedia`) beserta persen, dengan sumber `device_info_plus` (`AndroidDeviceInfo`) | Must Have |
| Info penyimpanan internal | Total (`totalDiskSize`, bytes), bebas (`freeDiskSize`, bytes), terpakai (`total - bebas`) beserta persen; konversi tampilan ke MB/GB gaya Indonesia (titik sebagai pemisah ribuan, mengikuti pola `_angkaRibuan` pada section baterai) | Must Have |
| Snapshot + refresh manual | Data dibaca sekali saat tab statistik dibuka; tombol muat ulang memicu pembacaan ulang (bukan stream/Timer) | Must Have |
| Fallback `Tidak diketahui` | Platform non-Android/web, pembacaan gagal, atau nilai tidak valid → `Tidak diketahui`; tidak pernah mengisi angka karangan | Must Have |
| Indikator RAM rendah | Menampilkan `isLowRamDevice` (`Ya`/`Tidak`) bila tersedia | Could Have |
| Tipe memori (LPDDR) | Tidak tersedia lewat API publik; selalu `Tidak diketahui` pada versi awal | Could Have |
| Penyimpanan eksternal (SD card) | Di luar cakupan versi awal | — |
| Pembacaan realtime otomatis | Di luar cakupan (keputusan: snapshot + refresh manual) | — |
| Placement | Section baru `Memori & Penyimpanan` di dalam `StatistikScreen` (di bawah section baterai), mengikuti pola `SpesifikasiBateraiSection` | Must Have |

### Isi dari `refrensi_apk.md` (dipindahkan dari section `A5. Info memori & penyimpanan`, `refrensi_apk.md:69-73` — nomor baris setelah isi dipindahkan)

- **Temuan:** Seluruh kompetitor (DevCheck, AIDA64, CPU-Z, Droid Hardware Info, Castro, Device Watch) menampilkan RAM total/terpakai dan kapasitas/tipe penyimpanan.
- **Tujuan:** Satu dari tiga pilar spesifikasi dasar (CPU/RAM/penyimpanan) yang diharapkan pengguna "Know Your Device".
- **Referensi:** [DevCheck](https://play.google.com/store/apps/details?id=flar2.devcheck), [AIDA64](https://play.google.com/store/apps/details?id=com.finalwire.aida64), [CPU-Z](https://play.google.com/store/apps/details?id=com.cpuid.cpu_z), [Castro](https://play.google.com/store/apps/details?id=com.itemstudio.castro)
- **Saran:** RAM: total/terpakai realtime; penyimpanan: internal/eksternal, terpakai/bebas; tipe memori bila terbaca (LPDDR) dengan fallback `Tidak diketahui`. (Catatan implementasi: kata "realtime" pada saran asli **tidak** diikuti — keputusan pengguna 2026-11-14 adalah snapshot + refresh manual; "internal/eksternal" dipersempit menjadi internal saja; "tipe memori LPDDR" selalu `Tidak diketahui` di versi awal.)
- **Prioritas:** Tinggi.

Rujukan prioritas gabungan: `refrensi_apk.md:346` (`| A5 Info memori & penyimpanan | Fitur baru | Tinggi |`); urutan eksekusi menempatkan A5 setelah A1 dan sebelum A3 (`refrensi_apk.md:377`).

## 4. Alur Pengguna

**Konteks penggunaan:**
Digunakan untuk menjelaskan urutan interaksi pengguna dengan aplikasi dari awal hingga tujuan tercapai.

**Aturan pengisian:**
- Mulai dari kondisi awal pengguna.
- Jelaskan setiap langkah secara berurutan.
- Sebutkan tindakan pengguna dan respons aplikasi.
- Sertakan percabangan atau kondisi alternatif jika tersedia.
- Jelaskan kondisi akhir yang diharapkan.
- Pastikan alur sesuai dengan persyaratan fitur.
- Jangan memasukkan proses yang tidak didukung oleh kebutuhan produk.

**Isi:**
1. Pengguna membuka tab **Statistik** (`NavigationBar`, indeks 3 di `lib/home.dart`).
2. `StatistikScreen` memuat section **Spesifikasi Baterai** (sudah ada) dan section baru **Memori & Penyimpanan** di bawahnya.
3. Section membuat `MemoriNotifier` (`ref.watch(memoriProvider)`); notifier memicu `MemoriRepository.ambilInfo()` sekali.
4. Repository memeriksa platform: bila `kIsWeb` atau bukan Android → kembalikan `null` (UI menampilkan pesan "hanya tersedia di Android", mengikuti pola section baterai).
5. Repository memanggil `DeviceInfoPlugin().androidInfo`; dibungkus `try/catch` (kegagalan → `null` + `debugPrint`).
6. Bila pembacaan berhasil, UI menampilkan: RAM total, RAM tersedia, RAM terpakai (+ persen), indikator RAM rendah (opsional), Penyimpanan internal total/terpakai/bebas (+ persen); nilai yang tidak valid ditampilkan sebagai `Tidak diketahui`.
7. Pengguna dapat menekan tombol muat ulang (ikon `refresh`): section memanggil `memoriProvider.notifier.muatUlang()` (loading → snapshot baru), bukan stream.
8. Setelah muat ulang selesai, UI menampilkan snapshot terbaru; bila gagal, tampilkan blok gagal + tombol coba lagi.
9. Kondisi akhir: pengguna melihat kondisi memori/penyimpanan terkini tanpa meninggalkan tab Statistik, tanpa izin khusus, dan tanpa data karangan.

Percabangan:
- Non-Android/web → pesan tidak didukung (konsisten dengan `_PesanTidakDidukung` pada section baterai).
- `androidInfo` gagal/`null`/nilai tidak valid → blok gagal atau `Tidak diketahui` per baris; tidak pernah menampilkan angka karangan.

## 5. Steps

**Konteks penggunaan:**
Digunakan untuk menjelaskan urutan langkah-langkah kerja yang harus diikuti dalam mengisi atau menerapkan PRD.

**Aturan pengisian:**
- Buat langkah-langkah yang spesifik dan dapat diikuti.
- Gunakan numbered list untuk mempertahankan urutan.
- Setiap langkah harus tidak ambigu dan dapat dikerjakan.
- Jangan memasukkan langkah yang tidak relevan atau redundan.

**Isi:**

1. Tambahkan dependensi `device_info_plus: ^13.3.0` ke `pubspec.yaml` (`dependencies`), lalu jalankan `flutter pub get`.
2. Buat `lib/fitur/statistik/model/memori_info.dart` — DTO snapshot memori/penyimpanan (field nullable, gaya `BateraiInfo`).
3. Buat `lib/fitur/statistik/data/memori_repository.dart` — guard platform Android-only, pembacaan `DeviceInfoPlugin().androidInfo`, validasi nilai (RAM `>= 0`; disk `>= 0`; konversi byte → MB/GB), kegagalan → `null` dengan `debugPrint`.
4. Buat `lib/fitur/statistik/notifier/memori_notifier.dart` — `@Riverpod(keepAlive: true)`, `build() => _repository.ambilInfo()`, `muatUlang()` dengan `AsyncValue.guard`; jalankan `build_runner` untuk `memori_notifier.g.dart` (file generated tidak diedit manual).
5. Buat `lib/fitur/statistik/widgets/memori_penyimpanan_section.dart` — `ConsumerWidget` Android-only; pola section baterai: kartu, judul + tombol muat ulang, baris label–nilai dengan `FontFeature.tabularFigures()`, blok gagal + tombol coba lagi, pesan tidak didukung.
6. Ubah `lib/fitur/statistik/screens/statistik_screen.dart` — sisipkan `MemoriPenyimpananSection()` di bawah `SpesifikasiBateraiSection()`; perbarui catatan "Statistik perangkat lainnya" bila relevan.
7. Ubah `test/widget_test.dart` — override `memoriProvider` dengan notifier palsu (plugin tidak tersedia di VM test; tanpa override `pumpAndSettle` menggantung), ikuti pola override `bateraiProvider` yang sudah ada.
8. Verifikasi: `dart format .`, `dart analyze`, `flutter test`.
9. Perbarui `refrensi_apk.md` dan `apk_kompetitor.md` hanya bila ada penanda PRD yang perlu disesuaikan (di luar langkah implementasi).

### Contoh potongan kode (ilustratif, bukan hasil akhir; file final ditulis saat implementasi)

Dependensi di `pubspec.yaml`:

```yaml
dependencies:
  # Informasi perangkat Android (RAM fisik/tersedia, ukuran disk).
  device_info_plus: ^13.3.0
```

Model `lib/fitur/statistik/model/memori_info.dart`:

```dart
// DTO snapshot memori/penyimpanan; seluruh field nullable karena tidak
// semua perangkat menyediakan nilai valid.
class MemoriInfo {
  const MemoriInfo({
    this.ramTotalMb,
    this.ramTersediaMb,
    this.ramTerpakaiMb,
    this.perangkatRamRendah,
    this.penyimpananTotalByte,
    this.penyimpananBebasByte,
    this.penyimpananTerpakaiByte,
  });

  final int? ramTotalMb;
  final int? ramTersediaMb;
  final int? ramTerpakaiMb; // total - tersedia
  final bool? perangkatRamRendah; // AndroidDeviceInfo.isLowRamDevice
  final int? penyimpananTotalByte;
  final int? penyimpananBebasByte;
  final int? penyimpananTerpakaiByte; // total - bebas
}
```

Repository `lib/fitur/statistik/data/memori_repository.dart`:

```dart
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

import 'package:spektra/fitur/statistik/model/memori_info.dart';

// Android saja; nilai tidak valid/tidak tersedia → null agar UI menampilkan
// `Tidak diketahui` (pola sama dengan BateraiRepository).
class MemoriRepository {
  Future<MemoriInfo?> ambilInfo() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return null;
    }
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      final totalMb = info.physicalRamSize;
      final tersediaMb = info.availableRamSize;
      return MemoriInfo(
        ramTotalMb: _byteNonNegatif(totalMb),
        ramTersediaMb: _byteNonNegatif(tersediaMb),
        ramTerpakaiMb: _selisihNonNegatif(totalMb, tersediaMb),
        perangkatRamRendah: info.isLowRamDevice,
        penyimpananTotalByte: _byteNonNegatif(info.totalDiskSize),
        penyimpananBebasByte: _byteNonNegatif(info.freeDiskSize),
        penyimpananTerpakaiByte:
            _selisihNonNegatif(info.totalDiskSize, info.freeDiskSize),
      );
    } catch (error) {
      debugPrint('Gagal membaca info memori: $error');
      return null;
    }
  }

  static int? _byteNonNegatif(int nilai) => nilai >= 0 ? nilai : null;
  static int? _selisihNonNegatif(int a, int b) =>
      (a >= 0 && b >= 0 && a >= b) ? a - b : null;
}
```

Notifier `lib/fitur/statistik/notifier/memori_notifier.dart`:

```dart
@Riverpod(keepAlive: true)
class MemoriNotifier extends _$MemoriNotifier {
  final MemoriRepository _repository = MemoriRepository();

  @override
  Future<MemoriInfo?> build() => _repository.ambilInfo();

  Future<void> muatUlang() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.ambilInfo());
  }
}
```

Section `lib/fitur/statistik/widgets/memori_penyimpanan_section.dart` (kerangka, pola `SpesifikasiBateraiSection`):

```dart
class MemoriPenyimpananSection extends ConsumerWidget {
  const MemoriPenyimpananSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return const _PesanTidakDidukung();
    }
    final memoriAsync = ref.watch(memoriProvider);
    // ... Card + judul + tombol muat ulang + _BarisSpesifikasi:
    //   'RAM total' / 'RAM tersedia' / 'RAM terpakai' (+ persen),
    //   'Penyimpanan total' / 'terpakai' / 'bebas' (MB/GB),
    //   nilai null → 'Tidak diketahui', angka dengan tabularFigures.
  }
}
```

## 6. File-File Terdampak

**Konteks penggunaan:**
Digunakan untuk mengidentifikasi file proyek yang berkaitan dengan implementasi kebutuhan produk. Bagian ini menjadi gambaran awal cakupan perubahan kode.

**Aturan pengisian:**
- Periksa struktur proyek sebelum menentukan file terdampak.
- Cantumkan lokasi file secara spesifik berdasarkan struktur proyek sebenarnya.
- Tandai apakah file perlu dibuat, diubah, atau dihapus.
- Jelaskan alasan dan tujuan perubahan setiap file.
- Cantumkan hanya file yang memiliki hubungan dengan kebutuhan fitur.
- Jangan mengarang lokasi, nama, atau keberadaan file.
- Jika file belum dapat ditentukan, tandai sebagai belum diketahui dan jangan menebak.
- Perbarui daftar setelah analisis teknis atau implementasi apabila ditemukan file terdampak tambahan.

| Lokasi File | Status Perubahan          | Deskripsi Perubahan |
| ----------- | ------------------------- | ------------------- |
| `prd/prd_info_memori_penyimpanan.md` | Dibuat | PRD ini (fitur A5 dari `refrensi_apk.md`) |
| `refrensi_apk.md` | Diubah | Section `A5. Info memori & penyimpanan` (sekarang `refrensi_apk.md:69-73`) dipindahkan ke PRD ini; section ditandai sudah dibuatkan PRD (`<!-- PRD: prd_info_memori_penyimpanan.md -->`) |
| `pubspec.yaml` | Diubah | Tambah `device_info_plus: ^13.3.0` di `dependencies` |
| `lib/fitur/statistik/model/memori_info.dart` | Dibuat | DTO snapshot memori/penyimpanan (nullable) |
| `lib/fitur/statistik/data/memori_repository.dart` | Dibuat | Guard platform, pembacaan `DeviceInfoPlugin().androidInfo`, validasi/selisih nilai |
| `lib/fitur/statistik/notifier/memori_notifier.dart` | Dibuat | `MemoriNotifier` (`@Riverpod(keepAlive: true)`), `muatUlang()` via `AsyncValue.guard` |
| `lib/fitur/statistik/notifier/memori_notifier.g.dart` | Dibuat | Hasil `build_runner` (bukan diedit manual) |
| `lib/fitur/statistik/widgets/memori_penyimpanan_section.dart` | Dibuat | Section UI Android-only (pola `SpesifikasiBateraiSection`) |
| `lib/fitur/statistik/screens/statistik_screen.dart` | Diubah | Sisipkan `MemoriPenyimpananSection()` di bawah section baterai |
| `test/widget_test.dart` | Diubah | Override `memoriProvider` dengan notifier palsu di VM test |
| `lib/home.dart` | Diubah (tidak direncanakan) | Tidak diperlukan perubahan; tab Statistik sudah ada — dicatat agar tidak diubah tanpa kebutuhan |

Catatan cakupan: `lib/home.dart` tidak direncanakan berubah; bila implementasi menemukannya perlu diubah, PRD ini wajib diperbarui lebih dulu. Tidak ada PRD lain di proyek (folder `prd/` baru dibuat), sehingga tidak ada bentrok file terdampak dengan PRD lain. `lib/fitur/statistik/data/baterai_repository.dart` dan berkas baterai lainnya **tidak** disentuh.
