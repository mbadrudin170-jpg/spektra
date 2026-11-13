---
name: pengurutan-paket-pubspec
description: "Trigger: saat menambah atau mengurutkan dependensi pubspec.yaml | Panduan urutan paket pada section `dependencies` dan `dev_dependencies` di `pubspec.yaml`: abjad case-insensitive, entri berbasis SDK (`flutter`, `flutter_test`) tetap di posisi teratas, komentar di atas entri paket dianggap bagian dari entri paket dan ikut berpindah; `dependency_overrides` dan section lain di luar cakupan. Untuk proyek Flutter: urutkan paket, lalu verifikasi `flutter pub get`. Acuan: `pubspec.yaml`, `.agents/rules/global/aturan_skill.md`."
metadata:
  kategori: "custom"
  versi: "1.0.0"
  diperbarui: "Sat Nov 14 2026 02:59:52 WIB"
  sumber-terakhir: "perintah pengguna: tindak lanjut hasil_diskusi/diskusi_5.md (kerjakan_hasil_diskusi)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Pengurutan Paket pubspec.yaml Sesuai Abjad

Mengatur urutan paket pada section `dependencies` dan `dev_dependencies` di `pubspec.yaml` agar selalu sesuai abjad (case-insensitive), dengan entri berbasis SDK tetap di posisi teratas. Isi skill disusun dari kondisi proyek aktual dan keputusan pengguna (`hasil_diskusi/diskusi_5.md`), bukan dari riwayat commit (tidak ada commit yang berkaitan dengan pengurutan paket `pubspec.yaml`).

## Cakupan yang Di-Cover

- File: `pubspec.yaml` (root proyek Flutter)
- Section yang diatur: `dependencies`, `dev_dependencies`
- Section yang tidak diatur: `dependency_overrides`, `flutter`, `environment`, dan section lain (`name`, `version`, `description`, `publish_to`)
- Entri berbasis SDK: `flutter` (di `dependencies`) dan `flutter_test` (di `dev_dependencies`)
- Kriteria urutan: abjad, case-insensitive (`battery_info_v2` < `flutter_riverpod` < `riverpod_annotation`)

## Aturan

1. Urutkan paket pada `dependencies` dan `dev_dependencies` sesuai abjad nama paket, tidak peka huruf besar/kecil (case-insensitive).
2. Entri berbasis SDK (`flutter` di `dependencies`, `flutter_test` di `dev_dependencies`) tetap ditempatkan di posisi teratas section; paket-paket lain diurutkan abjad di bawahnya.
3. Komentar di atas entri paket dianggap bagian dari entri paket tersebut; komentar-komentar tersebut wajib ikut berpindah bersama paket saat pengurutan dilakukan.
4. Entri lain di dalam section yang bukan dependensi (mis. `sdk: flutter` miliki entri SDK) tetap di bawah kunci paketnya dan tidak diurutkan terpisah.
5. Section selain `dependencies` dan `dev_dependencies` (termasuk `dependency_overrides`) tidak diatur oleh skill ini dan tidak boleh diurutkan berdasarkan aturan ini.
6. Saat menambah paket baru, sisipkan paket tersebut pada posisi abjad yang benar (bukan di akhir section) beserta komentar deskriptifnya bila ada.
7. Saat memperbarui versi paket, jangan mengubah posisi paket; perubahan posisi hanya dilakukan ketika melakukan pengurutan yang disengaja.
8. Setelah mengurutkan, verifikasi `flutter pub get` berhasil dan `dart analyze` (bila relevan) tetap bersih.
9. Jangan mengurutkan entri `dependency_overrides` dengan aturan skill ini; penanganannya (bila dibutuhkan) ditentukan terpisah.
10. Skill ini bersifat portabel lintas-proyek Flutter; gunakan pada `pubspec.yaml` proyek mana pun dengan struktur yang sama.

## Larangan

- DILARANG meletakkan entri non-SDK sebelum entri SDK di dalam section yang sama.
- DILARANG salah menempatkan komentar: komentar deskriptif paket wajib mengikuti paketnya, bukan tertinggal di posisi lama.
- DILARANG memindahkan atau mengurutkan entri `dependency_overrides`, `flutter`, `environment`, atau section lain menggunakan hasil urutan skill ini.
- DILARANG mengurutkan dengan mengabaikan case-insensitivity (mis. menempatkan semua huruf besar sebelum huruf kecil).
- DILARANG mengurutkan berdasarkan versi, tanggal penambahan, atau vendor; urutan murni berdasarkan nama paket secara abjad.
- DILARANG menghapus komentar paket saat mengurutkan; komentar tetap dipertahankan dan ikut berpindah.
- DILARANG memperkenalkan baris kosong ganda atau merusak indentasi `pubspec.yaml` saat menyusun ulang entri.
- DILARANG menganggap pengurutan sebagai izin untuk mengubah versi paket; versi hanya diubah bila memang diminta.

## Contoh Benar

```yaml
dependencies:
  flutter:
    sdk: flutter

  battery_info_v2: ^1.1.5
  cupertino_icons: ^1.0.8
  flutter_riverpod: ^3.5.0
  riverpod_annotation: ^4.0.8
  shared_preferences: ^2.5.3

dev_dependencies:
  flutter_test:
    sdk: flutter

  build_runner: ^2.17.1
  flutter_lints: ^6.0.0
  riverpod_generator: ^4.0.10
```

```yaml
# Komentar ikut berpindah bersama entri paket saat pengurutan
dependencies:
  flutter:
    sdk: flutter

  # Membaca info baterai Android.
  battery_info_v2: ^1.1.5
  # Persistensi pengaturan lokal (mis. mode tema).
  shared_preferences: ^2.5.3
```

## Contoh Salah

```yaml
# Salah: entri non-SDK ditempatkan sebelum entri SDK
dependencies:
  battery_info_v2: ^1.1.5
  flutter:
    sdk: flutter
# DILARANG: entri berbasis SDK wajib di posisi teratas
```

```yaml
# Salah: paket tidak urut abjad
dependencies:
  flutter:
    sdk: flutter

  shared_preferences: ^2.5.3
  battery_info_v2: ^1.1.5
# DILARANG: battery_info_v2 harus berada sebelum shared_preferences (abjad case-insensitive)
```

```yaml
# Salah: komentar tertinggal di posisi lama setelah entri dipindah
dependencies:
  flutter:
    sdk: flutter

  # Persistensi pengaturan lokal (mis. mode tema).  # salah: komentar ini milik shared_preferences
  battery_info_v2: ^1.1.5
  shared_preferences: ^2.5.3
# DILARANG: komentar harus mengikuti entri paketnya saat diurutkan
```

```yaml
# Salah: dependency_overrides ikut diurutkan dengan aturan ini
dependency_overrides:
  zeta: ^1.0.0
  alfa: ^1.0.0
# DILARANG: dependency_overrides di luar cakupan skill ini
```

## Sumber Evaluasi

- File: `pubspec.yaml`
- File aturan sumber: `.agents/rules/global/aturan_skill.md`
- Hasil diskusi: `hasil_diskusi/diskusi_5.md` (K-1..K-10; keputusan disusun atas pertanyaan pengguna melalui tool `question`)
- Skill referensi format non-UI: `.agents/skills/custom/bug-runtime/SKILL.md`
- Catatan: tidak ada commit yang berkaitan dengan pengurutan paket `pubspec.yaml`; isi skill disusun dari kondisi proyek aktual atas persetujuan pengguna, dan `metadata.sumber-terakhir` diisi perintah pengguna (bukan hash commit). Bagian `Contoh Benar` memakai versi dan komentar paket sebagaimana tercatat di `pubspec.yaml` proyek pada saat penulisan.
