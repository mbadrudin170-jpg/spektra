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
- Platform: Android (fitur pada PRD ini Android-only; aplikasi Spektra juga berjalan di iOS/web, tetapi tidak dicakup di sini)
- Versi: Spektra `1.0.0+1`; Dart `^3.13.7`; Flutter `3.47.9`
- Status pengembangan: belum ada fitur produk yang tersedia di kode; kerangka aplikasi + section statistik baterai (`lib/fitur/statistik/`) + tab pengaturan tema sudah ada

## 2. Tujuan PRD

**Konteks penggunaan:**
Digunakan untuk menentukan hasil yang ingin dicapai dari dokumen PRD ini. Tujuan harus berhubungan langsung dengan kebutuhan dokumen.

**Aturan pengisian:**
- Tuliskan hasil yang diharapkan dari PRD.
- Pastikan setiap tujuan memiliki hubungan dengan kebutuhan dokumen PRD.
- Gunakan tujuan yang jelas dan dapat dievaluasi.
- Jangan memasukkan tujuan yang berada di luar ruang lingkup PRD.

**Isi:**
PRD ini menetapkan kebutuhan, cakupan, alur, dan file terdampak untuk fitur **Tes diagnostik komponen interaktif** (kode item `A4` di `refrensi_apk.md`), salah satu dari pilar diagnostik Spektra yang secara eksplisit diminta pada `keluhan.md` poin 2 ("saya ingin menambahkan pengecekan layar sentuh nya apakah jalan."). Hasil yang diharapkan: pengguna Android dapat menjalankan tes interaktif (layar/dead pixel/multi-touch/kecerahan/getar/audio speaker/audio mikrofon loopback/senter/tombol volume) dari satu grid ikon besar, menerima hasil per tes (lulus/gagal/tidak tersedia), dan melihat ringkasan gabungan "N lulus / M gagal / K tidak tersedia" pada akhir sesi — celah yang tidak dimiliki kompetitor terdekat (Test Your Android, ytheekshana, DevCheck). Dokumen ini menjadi acuan implementasi terpisah; pembuatan PRD ini **tidak** mengubah kode Dart.

Rujukan: section A4 di `refrensi_apk.md:61-65` (Temuan/Tujuan/Referensi/Saran/Prioritas); pola alur grid → tes → ringkasan di `refrensi_apk.md:243-249` (C2); warna status semantic di `refrensi_apk.md:267-273` (C5); baris prioritas gabungan `refrensi_apk.md:343` (`| A4 Tes diagnostik komponen interaktif | Fitur baru | Tinggi |`); urutan eksekusi `refrensi_apk.md:375` (`... C6 → C1/C2/C9 → A4 → ...`).

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
| Alur menu grid ikon besar | Layar "Diagnostik Perangkat" berupa grid kartu besar (ikon + label) per tes; pola "pilih tes → jalankan → lulus/gagal" (`refrensi_apk.md:243-249`); hasil tiap tes dikembalikan ke grid via `Navigator.pop` | Must Have |
| Tes warna layar penuh | Latar berganti merah/hijau/biru/putih/hitam layar penuh untuk mendeteksi pixel rusak/tinting; tap untuk berganti warna; tombol selesai | Must Have |
| Tes dead pixel | Pola latar kontras (warna solid + pola) untuk mendeteksi dead/stuck pixel; ketuk area yang mencurigakan tidak wajib — cukup observasi visual lalu putuskan lulus/gagal | Must Have |
| Tes multi-touch | `Listener` dengan pointer tracking: tampilkan jumlah pointer aktif + koordinat tiap sentuhan; pengguna memverifikasi jumlah jari maksimal | Must Have |
| Tes kecerahan | Instruksi menaikkan kecerahan layar (via pengaturan sistem atau slider dalam aplikasi bila memungkinkan tanpa package baru); pengguna menilai dari layar aktual | Could Have |
| Tes getar | Pola getar pendek/panjang berurutan via `HapticFeedback` (Flutter SDK, tanpa package); pengguna memverifikasi getar terasa | Must Have |
| Tes audio speaker (nada uji) | Memutar nada uji (sinyal bip/sine) lewat package audio yang dipilih saat implementasi (`flutter pub add`, paket aktif & terbaru, versi dicek di pub.dev) | Must Have |
| Tes audio mikrofon (loopback) | Rekam beberapa detik lalu putar kembali untuk memverifikasi mikrofon + speaker; butuh izin `RECORD_AUDIO` (runtime, diminta saat tes dijalankan) | Must Have |
| Tes senter (flash) | Menyalakan/mematikan flash kamera sebagai senter; butuh izin/akses flash sesuai paket yang dipilih saat implementasi; diminta saat tes dijalankan | Must Have |
| Tes tombol volume | Verifikasi tombol volume mengeluarkan event; mekanisme (package vs platform channel) diputuskan saat implementasi dan dicatat di PRD bila menyimpang | Should Have |
| Ringkasan hasil akhir (in-memory) | Setelah seluruh tes selesai (atau pengguna menekan "Selesai"), tampilkan ringkasan "N lulus / M gagal / K tidak tersedia" untuk sesi tes berjalan; tidak ada persistensi | Must Have |
| Warna status semantic | Hijau = lulus, merah = gagal, kuning/abu = tidak tersedia/peringatan; selalu disertai ikon + teks (bukan warna saja); selaras aturan warna proyek (`refrensi_apk.md:267-273`) | Must Have |
| Entry point dari tab Dashboard | Tombol/kartu "Tes Diagnostik" di tab Dashboard (`lib/home.dart`) yang `push` ke layar grid; tab dan konten counter eksisting tidak dihapus (penghapusan counter = lingkup B1, bukan PRD ini) | Must Have |
| Platform | Android-only; non-Android/web menampilkan pesan "hanya tersedia di Android" | Must Have |
| Penyimpanan riwayat tes | Di luar cakupan versi awal (keputusan pengguna 2026-11-14: in-memory per sesi saja) | — |
| Kamera, sensor, sidik jari, root check, refresh rate, penyimpanan | Di luar cakupan PRD ini (arahan `refrensi_apk.md:61-65` menyebut 35+ tes; versi awal dibatasi daftar di atas) | — |
| Ringkasan persisten/ekspor laporan | Di luar cakupan (A8/A9) | — |
| Placement tab baru | Ditolak versi awal; entry lewat tab Dashboard saja (keputusan pengguna 2026-11-14) | — |

### Isi dari `refrensi_apk.md` (dipindahkan dari section `A4. Tes diagnostik komponen interaktif`, `refrensi_apk.md:61-65`)

- **Temuan:** Test Your Android (35+ tes: warna layar, multi-touch, piksel mati, refresh rate, speaker/mikrofon/getar, kamera, sidik jari, root check), ytheekshana (Hardware Tests: ~15 tes), DevCheck (sentrifugal, getar, tombol, multi-touch, layar, speaker, mikrofon), Device Test. Keluhan Spektra (`keluhan.md`) secara eksplisit menyebut uji layar sentuh.
- **Tujuan:** Memenuhi kebutuhan diagnostik terdokumentasi (layar sentuh) sekaligus menjadi nilai utama aplikasi; pola "pilih tes → jalankan → lulus/gagal" terbukti mudah dipahami.
- **Referensi:** [Test Your Android](https://play.google.com/store/apps/details?id=hibernate.v2.testyourandroid), [Device Info: System & CPU Info (ytheekshana)](https://play.google.com/store/apps/details?id=com.ytheekshana.deviceinfo), [DevCheck](https://play.google.com/store/apps/details?id=flar2.devcheck)
- **Saran:** Mulai dari tes layar (warna penuh, dead pixel, multi-touch, kecerahan) + tes audio (speaker/mikrofon loopback) + tes getar/tombol/senter; alur menu grid ikon besar → layar tes → hasil per tes; tambahkan ringkasan hasil akhir (celah yang tidak dimiliki Test Your Android); minta izin runtime hanya saat tes terkait dijalankan.
- **Prioritas:** Tinggi.

Catatan dari pembacaan referensi (2026-11-14, `webfetch` halaman store, ringkasan — bukan verifikasi visual):

- **Test Your Android** (4,8★, 12,4K review, 1M+ unduhan, diperbarui 2026-09-11): tes layar: color test, touch & multi-touch, dead pixel check; display performance: refresh rate; storage read/write; camera tests; audio checks (speaker, microphone, vibration, volume); connectivity (Wi-Fi/BT/NFC/SIM/GPS); sensor checks (akselerometer, giroskop, proximity, light, pressure, compass); biometric (fingerprint); system info; security info (root checker, security patch). Keluhan utama di review: iklan pop-up dan **tidak ada laporan gabungan setelah tes**.
- **ytheekshana** (4,8★, 241K review, 10M+ unduhan, diperbarui 2026-11-03): Hardware Tests & Device Diagnostics: display, multi-touch, flashlight, loudspeaker, earpiece, microphone, proximity sensor, light sensor, accelerometer, charging, headset, vibration, Bluetooth, fingerprint, volume buttons.
- **DevCheck** (4,5★, 34,6K review, 10M+ unduhan, diperbarui 2026-11-13): Tests: flashlight, vibrator, buttons, multitouch, display, backlight, charging, speakers, headset, earpiece, microphone, biometric scanners (enam tes terakhir memerlukan versi Pro). Iklan tidak ada, tetapi fitur inti dikunci Pro.
- Kesimpulan pola: ketiga kompetitor **tidak** menyediakan ringkasan hasil gabungan otomatis — ini nilai diferensiasi Spektra (selaras C2 `refrensi_apk.md:243-249`); ketiganya menempatkan tes dalam grid/daftar ikon besar; keduanya (Test Your Android, DevCheck) memiliki keterbatasan iklan/paywall yang harus dihindari (C9 `refrensi_apk.md:299-305`: tanpa iklan, minta izin hanya saat tes dipakai, fitur inti tidak dikunci paywall).
- **Keterbatasan:** tidak ada screenshot yang direproduksi; analisis berbasis deskripsi store + review; detail presisi perlu validasi visual bila pengguna menginginkan.

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
1. Pengguna membuka tab **Dashboard** (`NavigationBar`, indeks 0 di `lib/home.dart`).
2. Di tab Dashboard (di bawah konten counter eksisting), pengguna melihat kartu/tombol **"Tes Diagnostik"**.
3. Pengguna menekan tombol tersebut → aplikasi `push` layar **Diagnostik Perangkat** (`DiagnostikScreen`).
4. Layar menampilkan grid kartu besar (ikon + label): Warna Layar, Dead Pixel, Multi-Touch, Kecerahan, Getar, Audio Speaker, Audio Mikrofon, Senter, Tombol Volume.
5. Pengguna memilih satu kartu → aplikasi `push` layar tes terkait; kartu menampilkan lencana status (belum dites / lulus / gagal / tidak tersedia).
6. Pengguna menjalankan tes:
   - Warna Layar: layar penuh menampilkan warna; ketuk untuk berganti (merah → hijau → biru → putih → hitam → merah …); pengguna memutuskan tombol "Lulus"/"Gagal".
   - Dead Pixel: pola latar kontras; pengguna memutuskan "Lulus"/"Gagal".
   - Multi-Touch: layar menampilkan titik & koordinat tiap pointer aktif; pengguna memverifikasi jumlah jari maksimal, lalu "Lulus"/"Gagal".
   - Kecerahan: tampilkan instruksi menguji kecerahan (maks→min); pengguna menilai, lalu "Lulus"/"Gagal"/"Tidak tersedia".
   - Getar: aplikasi memicu pola getar pendek/panjang via `HapticFeedback`; pengguna memutuskan "Lulus"/"Gagal".
   - Audio Speaker: aplikasi memutar nada uji; pengguna memutuskan "Lulus"/"Gagal"/"Tidak tersedia".
   - Audio Mikrofon: aplikasi merekam beberapa detik (izin `RECORD_AUDIO` diminta saat tes dijalankan), lalu memutar ulang; pengguna memutuskan "Lulus"/"Gagal"/"Tidak tersedia".
   - Senter: aplikasi menyalakan flash kamera sebagai senter; pengguna memutuskan "Lulus"/"Gagal"/"Tidak tersedia" (perangkat tanpa flash → "Tidak tersedia").
   - Tombol Volume: aplikasi menunggu event tombol volume selama jendela waktu singkat; pengguna menekan tombol volume; bila event terbaca → "Lulus", bila tidak → "Gagal"/"Tidak tersedia" (bergantung platform & paket).
7. Layar tes ditutup dengan `Navigator.pop(context, HasilTes(...))`; grid memperbarui lencana kartu.
8. Pengguna dapat menekan **"Selesai & Lihat Ringkasan"** kapan pun (tombol di `AppBar` layar grid).
9. Aplikasi menampilkan layar **Ringkasan**: daftar per tes (ikon + teks hasil) + total "N lulus / M gagal / K tidak tersedia" untuk sesi tes berjalan; tombol "Kembali" kembali ke grid (hasil sesi tetap tersimpan selama layar ringkasan tidak ditutup; tidak ada persistensi — menutup layar grid berarti sesi berakhir).
10. Kondisi akhir: pengguna memperoleh gambaran lulus/gagal per komponen tanpa meninggalkan aplikasi, tanpa data karangan, dan tanpa iklan/paywall.

Percabangan:
- Platform non-Android/web → kartu/layar menampilkan pesan "Tes diagnostik hanya tersedia di Android" (pola `_PesanTidakDidukung` pada section baterai).
- Izin mikrofon ditolak → kartu Audio Mikrofon menandai "Tidak tersedia" dengan alasan; tes lain tetap berjalan.
- Perangkat tanpa flash/senter → "Tidak tersedia", tidak menggagalkan sesi.
- Kesalahan internal tes (exception) → "Tidak tersedia" + pesan ramah; tidak crash; dicatat `debugPrint`.
- Tombol volume tidak mengirim event pada perangkat tertentu → "Tidak tersedia" (bukan "Gagal") bila paket/platform tidak mendukung.

## 5. Steps

**Konteks penggunaan:**
Digunakan untuk menjelaskan urutan langkah-langkah kerja yang harus diikuti dalam mengisi atau menerapkan PRD.

**Aturan pengisian:**
- Buat langkah-langkah yang spesifik dan dapat diikuti.
- Gunakan numbered list untuk mempertahankan urutan.
- Setiap langkah harus tidak ambigu dan dapat dikerjakan.
- Jangan memasukkan langkah yang tidak relevan atau redundan.

**Isi:**

1. Tambahkan dependensi audio (mis. paket pemutar + perekam; nama final diputuskan dengan `flutter pub add` setelah verifikasi pub.dev — paket terbaru, aktif, tidak discontinued, kompatibel dengan Flutter `3.47.9`/Dart `^3.13.7`) dan paket senter ke `pubspec.yaml` (`dependencies`); jalankan `flutter pub get`. Irisan `pubspec.yaml` dengan PRD A5 disetujui pengguna 2026-11-14.
2. Tambahkan izin runtime di `android/app/src/main/AndroidManifest.xml`: `RECORD_AUDIO` (loopback) dan izin flash/senter sesuai paket (mis. `CAMERA` untuk paket berbasis camera). Minta izin saat tes dijalankan, bukan saat aplikasi dibuka.
3. Buat struktur fitur (feature-first, sub-folder lapisan di dalam fitur — mengikuti `hasil_diskusi/diskusi_4.md` dan skill `struktur-folder-lib`):
   - `lib/fitur/diagnostik/model/hasil_tes.dart` — DTO hasil per tes (`enum StatusTes { lulus, gagal, tidakTersedia }`, `id`, `label`); ringkasan in-memory.
   - `lib/fitur/diagnostik/screens/diagnostik_screen.dart` — grid kartu besar; lencana status per kartu; tombol "Selesai & Lihat Ringkasan".
   - `lib/fitur/diagnostik/screens/ringkasan_screen.dart` — daftar hasil + total "N lulus / M gagal / K tidak tersedia"; tanpa persistensi.
   - `lib/fitur/diagnostik/screens/tes/warna_layar_test_screen.dart`, `dead_pixel_test_screen.dart`, `multi_touch_test_screen.dart`, `kecerahan_test_screen.dart`, `getar_test_screen.dart`, `audio_speaker_test_screen.dart`, `audio_mikrofon_test_screen.dart`, `senter_test_screen.dart`, `tombol_volume_test_screen.dart`.
   - Tanpa Riverpod/notifier: ringkasan sesi di-passing lewat `Navigator` (`pop` + parameter); state tes ephemeral di widget `State` masing-masing.
4. Ubah `lib/home.dart`: tambah kartu/tombol "Tes Diagnostik" di tab Dashboard (di bawah konten counter) yang `push` ke `DiagnostikScreen`; konten counter dan tab lain tidak diubah; irisan `lib/home.dart` dengan PRD A5 disetujui pengguna 2026-11-14.
5. Layar non-Android/web: tiap layar tes dan grid menampilkan pesan "hanya tersedia di Android" (pola `_PesanTidakDidukung`).
6. Buat `test/diagnostik_test.dart` (berkas baru): widget test untuk render grid + navigasi dasar; plugin audio/senter tidak tersedia di VM test — gunakan fake/override sederhana, jangan mengubah `test/widget_test.dart` (berkas itu diklaim PRD A5).
7. Verifikasi: `dart format .`, `dart analyze`, `flutter test`.
8. Perbarui `refrensi_apk.md` hanya untuk penanda PRD (sudah dilakukan pada pembuatan PRD ini); jangan ubah bagian A4 lain tanpa kebutuhan.
9. Catatan: angka versi paket tidak di-pin di sini by design — diputuskan via `flutter pub add` (prinsip "paket terbaru & aktif", `diskusi_6`).

### Contoh potongan kode (ilustratif, bukan hasil akhir; file final ditulis saat implementasi)

Model hasil tes `lib/fitur/diagnostik/model/hasil_tes.dart`:

```dart
// Hasil satu tes diagnostik; ringkasan sesi diturunkan dari daftar ini.
enum StatusTes { lulus, gagal, tidakTersedia };

class HasilTes {
  const HasilTes({required this.id, required this.label, required this.status});

  final String id;
  final String label;
  final StatusTes status;
}
```

Grid layar `lib/fitur/diagnostik/screens/diagnostik_screen.dart` (kerangka):

```dart
// Grid kartu besar; tiap kartu push layar tes dan menerima HasilTes via Navigator.pop.
class DiagnostikScreen extends StatefulWidget {
  const DiagnostikScreen({super.key});

  @override
  State<DiagnostikScreen> createState() => _DiagnostikScreenState();
}

class _DiagnostikScreenState extends State<DiagnostikScreen> {
  final Map<String, HasilTes> _hasil = {}; // in-memory, per sesi

  Future<void> _jalankan(String id) async {
    final hasil = await Navigator.of(context).push<HasilTes>(
      MaterialPageRoute(builder: (_) => _bangunLayar(id)),
    );
    if (hasil != null) setState(() => _hasil[id] = hasil);
  }

  @override
  Widget build(BuildContext context) {
    // GridView.count(crossAxisCount: 3, ...) — kartu: Icon + label + lencana status.
    // AppBar action: 'Selesai & Lihat Ringkasan' -> push RingkasanScreen(hasil: _hasil.values).
    return const Scaffold(); // implementasi penuh saat coding
  }
}
```

Tes multi-touch `lib/fitur/diagnostik/screens/tes/multi_touch_test_screen.dart`:

```dart
// Menampilkan titik & koordinat tiap pointer aktif; lulus/gagal diputuskan pengguna.
Listener(
  onPointerDown: (event) => _pointers[event.pointer] = event.position,
  onPointerMove: (event) => setState(() {
    if (_pointers.containsKey(event.pointer)) {
      _pointers[event.pointer] = event.position;
    }
  }),
  onPointerUp: (event) => setState(() => _pointers.remove(event.pointer)),
  onPointerCancel: (event) => setState(() => _pointers.remove(event.pointer)),
  child: CustomPaint(
    painter: _TitikPointerPainter(_pointers),
    child: const SizedBox.expand(),
  ),
);
```

Tes warna layar penuh `warna_layar_test_screen.dart` (inti):

```dart
// Ketuk untuk berganti warna; tombol Lulus/Gagal mengembalikan HasilTes.
GestureDetector(
  onTap: () => setState(() {
    _index = (_index + 1) % _warnaUji.length;
  }),
  child: ColoredBox(color: _warnaUji[_index]), // merah, hijau, biru, putih, hitam
);
```

Tes getar `getar_test_screen.dart` (inti, tanpa package):

```dart
import 'package:flutter/services.dart';

Future<void> _getarPola() async {
  await HapticFeedback.selectionClick();
  await Future<void>.delayed(const Duration(milliseconds: 150));
  await HapticFeedback.heavyImpact();
}
```

Pemakaian `Navigator.pop` mengembalikan hasil (kontrak semua layar tes):

```dart
Navigator.of(context).pop(
  HasilTes(id: 'multi_touch', label: 'Multi-Touch', status: StatusTes.lulus),
);
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
| `prd/prd_tes_diagnostik.md` | Dibuat | PRD ini (fitur A4 dari `refrensi_apk.md`) |
| `refrensi_apk.md` | Diubah | Isi section `A4. Tes diagnostik komponen interaktif` (`refrensi_apk.md:61-65`) dipindahkan ke PRD ini; section ditandai sudah dibuatkan PRD (`<!-- PRD: prd_tes_diagnostik.md -->`); baris prioritas `refrensi_apk.md:343` dan urutan eksekusi `refrensi_apk.md:375` tetap apa adanya |
| `pubspec.yaml` | Diubah | Tambah dependensi audio (nada uji + loopback) dan senter/flash; nama & versi final via `flutter pub add` setelah verifikasi pub.dev (2026-11-14: pengguna menyetujui irisan dengan PRD A5) |
| `android/app/src/main/AndroidManifest.xml` | Diubah | Tambah `RECORD_AUDIO` (loopback) dan izin flash/senter sesuai paket; izin diminta saat tes terkait dijalankan, bukan saat startup |
| `lib/home.dart` | Diubah | Tambah kartu/tombol "Tes Diagnostik" di tab Dashboard (push ke `DiagnostikScreen`); konten counter dan tab lain tidak berubah (irisan dengan PRD A5 disetujui pengguna 2026-11-14) |
| `lib/fitur/diagnostik/model/hasil_tes.dart` | Dibuat | DTO hasil per tes (`enum StatusTes`, `HasilTes`) |
| `lib/fitur/diagnostik/screens/diagnostik_screen.dart` | Dibuat | Layar grid kartu besar; akumulasi hasil in-memory; tombol "Selesai & Lihat Ringkasan" |
| `lib/fitur/diagnostik/screens/ringkasan_screen.dart` | Dibuat | Ringkasan "N lulus / M gagal / K tidak tersedia"; tanpa persistensi |
| `lib/fitur/diagnostik/screens/tes/warna_layar_test_screen.dart` | Dibuat | Tes warna layar penuh (tap untuk berganti) |
| `lib/fitur/diagnostik/screens/tes/dead_pixel_test_screen.dart` | Dibuat | Tes pola dead pixel |
| `lib/fitur/diagnostik/screens/tes/multi_touch_test_screen.dart` | Dibuat | Tes multi-touch (`Listener` + `CustomPaint`) |
| `lib/fitur/diagnostik/screens/tes/kecerahan_test_screen.dart` | Dibuat | Tes kecerahan (instruksi; opsional Could Have) |
| `lib/fitur/diagnostik/screens/tes/getar_test_screen.dart` | Dibuat | Tes getar via `HapticFeedback` |
| `lib/fitur/diagnostik/screens/tes/audio_speaker_test_screen.dart` | Dibuat | Tes nada uji lewat package audio |
| `lib/fitur/diagnostik/screens/tes/audio_mikrofon_test_screen.dart` | Dibuat | Tes loopback mikrofon (izin `RECORD_AUDIO`) |
| `lib/fitur/diagnostik/screens/tes/senter_test_screen.dart` | Dibuat | Tes flash/senter (package senter; izin saat dijalankan) |
| `lib/fitur/diagnostik/screens/tes/tombol_volume_test_screen.dart` | Dibuat | Tes event tombol volume (mekanisme package/platform channel diputuskan saat implementasi) |
| `test/diagnostik_test.dart` | Dibuat | Widget test grid + navigasi (berkas baru; `test/widget_test.dart` diklaim PRD A5 — tidak disentuh) |
| `lib/fitur/statistik/**` | Tidak disentuh | Tidak ada berkas statistik yang diubah; penempatan entry lewat tab Dashboard |
| `keluhan.md` | Tidak disentuh | Tidak diubah; hanya menjadi acuan kebutuhan |

Irisan eksplisit dengan PRD A5 (`prd/prd_info_memori_penyimpanan.md`) yang disetujui pengguna pada 2026-11-14 (via tool `question`): `pubspec.yaml` dan `lib/home.dart`. Seluruh berkas lain berbeda dengan daftar terdampak PRD A5 (`prd/prd_info_memori_penyimpanan.md` §6): tidak ada berkas `lib/fitur/statistik/`, `lib/fitur/diagnostik/` (baru), `test/diagnostik_test.dart` (baru), dan `test/widget_test.dart` (tidak disentuh). `refrensi_apk.md` diedit oleh kedua PRD, section berbeda (A4 vs A5) — keharusan instruksi proyek (penanda PRD), bukan duplikasi cakupan.
