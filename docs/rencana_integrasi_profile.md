# Rencana Integrasi: ProfilePageCustom + ProfileOrangPage

## 1. Tujuan

Menggabungkan logika UI dari `profile_orang_page.dart` ke dalam `profile_page_custom.dart` agar:

- Menghindari duplikasi kode profil pengguna
- Memiliki satu halaman profil yang seragam
- Tetap mempertahankan fitur khusus profil orang lain (follow, chat, laporkan, blokir)
- Selaras dengan struktur `NestedScrollView` + `SliverAppBar` yang sudah ada di `profile_page_custom.dart`

---

## 2. Analisis Komponen

### 2.1 Komponen yang SUDAH ADA di `profile_page_custom.dart`

- Struktur `NestedScrollView` + `SliverAppBar`
- `TabController` dengan 2 tab (Informasi, Momen)
- Galeri foto dengan upload
- Info card dasar (Nama, Nomor ID, Negara, Autentikasi, Bio, Hobi)
- `FormatUtils` untuk tanggal
- Widget `_buildGalleryItem`, `_buildInfoCard`

### 2.2 Komponen yang PERLU DITAMBAHKAN dari `profile_orang_page.dart`

| Komponen                           | Fungsi                                   | Prioritas    |
| ---------------------------------- | ---------------------------------------- | ------------ |
| Badge Premium                      | Menampilkan status premium pengguna lain | **TINGGI**   |
| Status Online/Offline              | Menampilkan ketersediaan pengguna        | **TINGGI**   |
| Tombol Follow/Berhenti Follow      | Fitur sosial follow                      | **TINGGI**   |
| Tombol Chat                        | Memulai percakapan                       | **TINGGI**   |
| Menu Options (Laporkan & Blokir)   | Aksi terhadap pengguna lain              | **TINGGI**   |
| Level Indicator Lengkap            | Level Skor + Berlian + Kekayaan          | **MENENGAH** |
| Hobi dengan Chips                  | Tampilan hobi dalam Wrap                 | **MENENGAH** |
| Alamat dengan privasi `showAlamat` | Menampilkan/sembunyikan alamat           | **MENENGAH** |
| Umur (dari tanggal lahir)          | Menghitung umur                          | **MENENGAH** |
| Jenis Kelamin (teks)               | "Laki-laki"/"Perempuan"                  | **RENDAH**   |

### 2.3 Komponen yang PERLU DIADAPTASI

| Komponen                  | Asal                      | Adaptasi yang Diperlukan                                                             |
| ------------------------- | ------------------------- | ------------------------------------------------------------------------------------ |
| `_buildProfilePhoto`      | `profile_orang_page.dart` | Integrasi dengan `_selectedImageUrl` di header                                       |
| `_buildVerificationBadge` | `profile_orang_page.dart` | Sesuaikan dengan asset gambar yang sudah ada di `profile_page_custom.dart`           |
| `_buildLevelIndicator`    | `profile_orang_page.dart` | Integrasi dengan widget `LevelKekayaanWidget` dan `LevelPesonaWidget` yang sudah ada |
| `_buildHobiSection`       | `profile_orang_page.dart` | Sesuaikan dengan gaya `_buildInfoCard` yang sudah ada                                |

---

## 3. Perubahan Struktural

### 3.1 Modifikasi `ProfilePageCustom`

**File:** `lib/fitur/saya/page/profile_page_custom.dart`

#### 3.1.1 Tambahkan Parameter `isMe`

```dart
class ProfilePageCustom extends ConsumerStatefulWidget {
  final bool isMe;
  final String idPengguna;

  const ProfilePageCustom({
    super.key,
    required this.isMe,
    required this.idPengguna,
  });
}
```

#### 3.1.2 Tambahkan Import yang Diperlukan

```dart
import 'package:service/fitur/pengguna/enum/jenis_kelamin_enum.dart';
import 'package:service/fitur/pengguna/utils/kekayaan_utils.dart';
import 'package:service/fitur/pengguna/utils/skor_utils.dart';
import 'package:service/fitur/premium/widget/premium_badge_widget.dart';
import 'package:service/fitur/saya/widget/tombol_opsi_tampilan_widget.dart';
import 'package:service/fitur/sosial/notifier/blokir_notifier.dart';
import 'package:service/fitur/sosial/notifier/relasi_notifier.dart';
import 'package:service/shared/tema/app_size.dart';
```

#### 3.1.3 Tambahkan State Baru

```dart
class _ProfilePageCustomState extends ConsumerState<ProfilePageCustom>
    with SingleTickerProviderStateMixin {
  // ... existing state ...
  OpsiTampilan _opsiTampilan = OpsiTampilan.informasi;
  ProviderSubscription<AsyncValue<RelasiState>>? _relasiSub;
  bool _isLoading = false;
}
```

#### 3.1.4 Modifikasi `initState` dan `dispose`

- Tambahkan listener untuk `relasiProvider` di `initState`
- Tutup `_relasiSub` di `dispose`

#### 3.1.5 Tambahkan Fungsi-fungsi Baru

- `_calculateAge(DateTime? tanggalLahir)` - menghitung umur
- `_toggleFollow()` - toggle follow/unfollow
- `_bukaChat()` - buka chat dengan pengguna
- `_showMenuOptions(BuildContext context)` - tampilkan menu laporkan/blokir
- `_showReportDialog(BuildContext context)` - dialog laporkan
- `_showBlockDialog(BuildContext context)` - dialog blokir
- `_updateFollowingStatus()` - update status follow

#### 3.1.6 Modifikasi `build` Method

- Tampilkan badge premium jika `!isMe && user.tanggalAkhirPremium?.isAfter(DateTime.now()) ?? false`
- Tampilkan status online jika `!isMe`
- Tampilkan tombol Follow/Chat jika `!isMe`
- Tampilkan menu options (Laporkan/Blokir) jika `!isMe`
- Ganti tab "Informasi"/"Momen" dengan `TombolOpsiTampilanWidget` jika `!isMe`

#### 3.1.7 Tambahkan Widget Baru

- `_buildProfileHeader(PenggunaModel user, ColorScheme colorScheme)` - header dengan foto, nama, badge premium, status online
- `_buildProfilePhoto(PenggunaModel user)` - foto profil dengan gradient border
- `_buildOnlineStatus(PenggunaModel user)` - indikator online/offline
- `_buildLevelIndicator(PenggunaModel user)` - level skor, berlian, kekayaan
- `_buildActionButtons(...)` - tombol Follow dan Chat
- `_buildInfoInformasi(ColorScheme colorScheme)` - informasi lengkap (alamat, umur, jenis kelamin, hobi)
- `_buildHobiSection(List<String> hobi, ColorScheme colorScheme)` - chips hobi
- `_buildVerificationBadge(ColorScheme colorScheme)` - badge verifikasi
- `_buildInfoRow(...)` - baris info umum

### 3.2 Modifikasi `ProfileOrangPage`

**File:** `lib/fitur/saya/page/profile_orang_page.dart`

#### 3.2.1 Ganti menjadi wrapper ke `ProfilePageCustom`

```dart
class ProfileOrangPage extends ConsumerWidget {
  final PenggunaModel penggunaLain;

  const ProfileOrangPage({super.key, required this.penggunaLain});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProfilePageCustom(
      isMe: false,
      idPengguna: penggunaLain.id,
    );
  }
}
```

---

## 4. Daftar Tugas Konkret

### Phase 1: Preparasi (Tidak Mengubah Kode)

- [x] **TASK-01**: Baca dan analisis kedua file profil
- [x] **TASK-02**: Identifikasi komponen yang perlu dipertahankan
- [x] **TASK-03**: Buat rencana integrasi (dokumen ini)

### Phase 2: Modifikasi `profile_page_custom.dart`

- [ ] **TASK-04**: Tambahkan parameter `isMe` ke `ProfilePageCustom`
- [ ] **TASK-05**: Tambahkan import yang diperlukan (premium, sosial, utils)
- [ ] **TASK-06**: Tambahkan state `_opsiTampilan`, `_relasiSub`, `_isLoading`
- [ ] **TASK-07**: Modifikasi `initState` untuk listen `relasiProvider`
- [ ] **TASK-08**: Modifikasi `dispose` untuk tutup `_relasiSub`
- [ ] **TASK-09**: Tambahkan fungsi `_calculateAge()`
- [ ] **TASK-10**: Tambahkan fungsi `_toggleFollow()`
- [ ] **TASK-11**: Tambahkan fungsi `_bukaChat()`
- [ ] **TASK-12**: Tambahkan fungsi `_showMenuOptions()`
- [ ] **TASK-13**: Tambahkan fungsi `_showReportDialog()`
- [ ] **TASK-14**: Tambahkan fungsi `_showBlockDialog()`
- [ ] **TASK-15**: Tambahkan fungsi `_updateFollowingStatus()`
- [ ] **TASK-16**: Modifikasi `build()` untuk kondisi `isMe`
- [ ] **TASK-17**: Tambahkan widget `_buildProfileHeader()`
- [ ] **TASK-18**: Tambahkan widget `_buildProfilePhoto()`
- [ ] **TASK-19**: Tambahkan widget `_buildOnlineStatus()`
- [ ] **TASK-20**: Tambahkan widget `_buildLevelIndicator()`
- [ ] **TASK-21**: Tambahkan widget `_buildActionButtons()`
- [ ] **TASK-22**: Tambahkan widget `_buildInfoInformasi()`
- [ ] **TASK-23**: Tambahkan widget `_buildHobiSection()`
- [ ] **TASK-24**: Tambahkan widget `_buildVerificationBadge()`
- [ ] **TASK-25**: Tambahkan widget `_buildInfoRow()`

### Phase 3: Modifikasi `profile_orang_page.dart`

- [ ] **TASK-26**: Ganti `ProfileOrangPage` menjadi wrapper ke `ProfilePageCustom`

### Phase 4: Verifikasi

- [ ] **TASK-27**: Jalankan `flutter analyze` pada kedua file
- [ ] **TASK-28**: Test build untuk memastikan tidak ada error kompilasi
- [ ] **TASK-29**: Verifikasi semua fitur profil orang lain masih berfungsi
- [ ] **TASK-30**: Verifikasi profil sendiri tetap berfungsi

---

## 5. Dependensi yang Diperlukan

### 5.1 Model

- `PenggunaModel` (sudah ada)
- `RelasiState` (sudah ada)
- `GaleriUserModel` (sudah ada)

### 5.2 Notifier

- `penggunaProvider` (sudah ada)
- `galeriUserProvider` (sudah ada)
- `momenProvider` (sudah ada)
- `relasiProvider` (sudah ada)
- `blokirProvider` (sudah ada)
- `pesertaPercakapanProvider` (sudah ada)
- `percakapanProvider` (sudah ada)

### 5.3 Widget

- `PremiumBadge` (sudah ada)
- `TombolOpsiTampilanWidget` (sudah ada)
- `JenisKelaminWidget` (sudah ada)
- `LevelKekayaanWidget` (sudah ada)
- `LevelPesonaWidget` (sudah ada)

### 5.4 Utils

- `SkorUtils` (sudah ada)
- `KekayaanUtils` (sudah ada)
- `FormatUtils` (sudah ada)
- `Nav` (sudah ada)

---

## 6. Risiko dan Mitigasi

| Risiko                                          | Dampak             | Mitigasi                                           |
| ----------------------------------------------- | ------------------ | -------------------------------------------------- |
| Kompleksitas `build()` meningkat                | Sulit maintain     | Pisahkan ke widget kecil yang jelas                |
| State `_relasiSub` bocor                        | Memory leak        | Pastikan `dispose()` menutup subscription          |
| Perubahan mengubah perilaku profil sendiri      | Bug                | Test kedua mode (`isMe: true/false`)               |
| Duplikasi kode dengan `profile_orang_page.dart` | Maintenance burden | Setelah integrasi, hapus `profile_orang_page.dart` |

---

## 7. Kriteria Sukses

1. `profile_page_custom.dart` mendukung kedua mode (`isMe: true` dan `isMe: false`)
2. `profile_orang_page.dart` menjadi wrapper sederhana ke `ProfilePageCustom`
3. Tidak ada duplikasi kode UI profil
4. Semua fitur profil orang lain tetap berfungsi (follow, chat, laporkan, blokir)
5. `flutter analyze` lulus tanpa error/warning
6. UI tetap konsisten dengan desain yang ada

---

## 8. Catatan Tambahan

- **Jangan menghapus `profile_orang_page.dart`** sampai integrasi sudah diverifikasi bekerja
- **Gunakan `FormatUtils`** untuk semua format tanggal (sesuai aturan proyek)
- **Gunakan `withValues(alpha:)`** bukan `withOpacity()` (sesuai aturan deprecated)
- **Gunakan `surfaceContainerHighest`** bukan `surfaceVariant` (sesuai aturan deprecated)
- Seluruh komentar dan teks UI menggunakan Bahasa Indonesia
